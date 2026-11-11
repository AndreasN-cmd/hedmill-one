#!/usr/bin/env python3
"""Reale Zeit je Werkzeugabschnitt (aus dem HMI-Log: 'Txxxx wurde aus dem Werkzeugwechsler geholt') gegen die
programmierte Zeit (NC: Satzlaenge / F, B in Grad wie mm) eines HEDmill-Programms.
Aufruf: python3 -I skripte/nc_zeit_real_vs_soll.py <nc> <message-log> <Start hh:mm> <Ende hh:mm>
"""
import re, sys, math, datetime
nc, log, t0, t1 = sys.argv[1:5]
rx = re.compile(r"([XYZABF])(-?\d+\.?\d*)")

# NC: Abschnitte je Werkzeugwechsel, Soll-Zeit je Abschnitt
lines = open(nc, encoding="latin-1", errors="replace").read().splitlines()
abschnitte = []  # (tool, soll_s, saetze, grad_B, strecke_mm)
pos = {"X": 0.0, "Y": 0.0, "Z": 0.0, "A": 0.0, "B": 0.0}; F = None; cur = None
for l in lines:
    s = l.strip()
    m = re.search(r"\b(T\d+) M6\b", s)
    if m:
        cur = [m.group(1), 0.0, 0, 0.0, 0.0]; abschnitte.append(cur); continue
    if cur is None or not s or s[0] in ";(": continue
    mm = re.match(r"N\d+\s*(.*)", s)
    if not mm: continue
    body = re.sub(r"\(.*?\)", "", mm.group(1))
    if re.match(r"[TSML]|G0?4\b|G58|G59|LDYN|#", body): continue
    w = dict((k, float(v)) for k, v in rx.findall(body))
    if "F" in w: F = w["F"]
    new = dict(pos)
    for k in "XYZAB":
        if k in w: new[k] = w[k]
    d = {k: new[k] - pos[k] for k in "XYZAB"}
    if abs(d["B"]) > 180: d["B"] -= math.copysign(360, d["B"])
    L = math.sqrt(sum(v * v for v in d.values()))
    if F and L > 0:
        cur[1] += L / F * 60; cur[2] += 1; cur[3] += abs(d["B"]); cur[4] += math.sqrt(d["X"]**2 + d["Y"]**2 + d["Z"]**2)
    pos = new

# Log: Zeitpunkte der Einwechslung
day = re.search(r"message(\d{8})", log).group(1)
def ts(hhmm): return datetime.datetime.strptime(day + hhmm, "%Y%m%d%H:%M")
T0, T1 = ts(t0), ts(t1)
ereignisse = []
for l in open(log, encoding="latin-1", errors="replace"):
    m = re.match(r"(\d{8}T\d{6})\d* --- (T\d+) wurde aus dem Werkzeugwechsler geholt", l)
    if m:
        t = datetime.datetime.strptime(m.group(1), "%Y%m%dT%H%M%S")
        if T0 <= t <= T1: ereignisse.append((t, m.group(2)))
ereignisse.sort()
print(f"NC {nc.split('/')[-1]}: {len(abschnitte)} Werkzeugabschnitte; Log {day} {t0}-{t1}: {len(ereignisse)} Einwechslungen")
print(f"{'#':>2} {'Werkzeug':8} {'Soll min':>8} {'Real min':>8} {'Real/Soll':>9} {'Saetze':>7} {'Grad B':>8} {'Weg mm':>7}  Einwechslung")
soll_sum = real_sum = 0.0
for i, a in enumerate(abschnitte):
    real = None
    if i < len(ereignisse) and ereignisse[i][1] == a[0]:
        ende = ereignisse[i + 1][0] if i + 1 < len(ereignisse) else T1
        real = (ende - ereignisse[i][0]).total_seconds() / 60
    soll = a[1] / 60
    soll_sum += soll; real_sum += real or 0
    print(f"{i+1:2d} {a[0]:8} {soll:8.1f} {real if real is not None else float('nan'):8.1f} {(real/soll) if real and soll else float('nan'):9.2f} {a[2]:7d} {a[3]:8.0f} {a[4]:7.0f}  {ereignisse[i][0].strftime('%H:%M:%S') if i < len(ereignisse) else '-'} {'' if i < len(ereignisse) and ereignisse[i][1]==a[0] else '(Reihenfolge weicht ab)'}")
print(f"Summe Soll {soll_sum:.0f} min, Real {real_sum:.0f} min (Real enthaelt Werkzeugwechsel, Messen, Anfahren)")
