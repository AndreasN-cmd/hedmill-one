#!/usr/bin/env python3
"""Masse am MKD-Drehfraesabschnitt je Programm: Y-Start (Praepgrenzenseite), Ende der Friktionszone
(ab hier aendert sich der Ringquerschnitt), Pol (= Ende minus bottomoffset 1), Beginn Konnektorkontakt.
Aufruf: python3 -I skripte/nc_kuppel_masse.py <nc> [<nc> ...]
"""
import re, sys, math, os
rx = re.compile(r"([XYZABF])(-?\d+\.?\d*)")

def analyse(path, tool="T4126", offset_now=1.0):
    lines = open(path, encoding="latin-1", errors="replace").read().splitlines()
    start = next(i for i, l in enumerate(lines) if re.search(rf"\b{tool} M6\b", l))
    end = next((i for i in range(start + 1, len(lines)) if re.search(r"\bT\d+ M6\b", lines[i])), len(lines))
    pos = {"Y": 0.0, "Z": 0.0, "B": 0.0}; F = None
    rings = []  # je Ring: (Y, [Z...])
    cur = []; curY = None; lastB = None
    for l in lines[start:end]:
        m = re.match(r"N(\d+)\s*(.*)", l.strip())
        if not m: continue
        body = re.sub(r"\(.*?\)", "", m.group(2))
        if re.match(r"[TSML]|G0?4\b|G58|G59|LDYN|#", body): continue
        w = dict((k, float(v)) for k, v in rx.findall(body))
        if "F" in w: F = w["F"]
        for k in "YZB":
            if k in w: pos[k] = w[k]
        if not F or F >= 20000 or "B" not in w: continue
        if lastB is not None and pos["B"] - lastB < -180:  # Umlauf
            if cur: rings.append((curY, cur))
            cur = []
        lastB = pos["B"]; curY = pos["Y"]
        cur.append(pos["Z"])
    if cur: rings.append((curY, cur))
    rings = [r for r in rings if len(r[1]) > 50]
    y_start = rings[0][0]; y_end = rings[-1][0]
    pol = y_end - offset_now
    # Friktionszone: Ringquerschnitt (Z-Profil) wie im 3. Ring; Ende = erster Ring, dessen Z-Spanne oder Z-Mittel um > 0,05 abweicht
    ref = rings[2][1]; rs = max(ref) - min(ref); rm = sum(ref) / len(ref)
    y_frik = None
    for y, zs in rings[3:]:
        if abs((max(zs) - min(zs)) - rs) > 0.05 or abs(sum(zs) / len(zs) - rm) > 0.05:
            y_frik = y; break
    rk = min(min(zs) for _, zs in rings)
    y_kon = None
    for y, zs in rings:
        flat = sum(1 for z in zs if z < rk + 0.06)
        if flat >= 10:
            y_kon = y; break
    name = os.path.basename(path)[:-3]
    return name, y_start, y_frik, pol, y_kon, y_end, rk

print(f"{'Programm':22s} {'Start':>7s} {'Frik-Ende':>9s} {'Kuppel mm':>9s} {'Pol':>7s} {'Konnektor ab':>12s} {'vor Pol':>7s} {'Ende jetzt':>10s}  sicherer Offset")
for p in sys.argv[1:]:
    name, ys, yf, pol, yk, ye, rk = analyse(p)
    kuppel = (pol - yf) if yf is not None else float("nan")
    vor_pol = (pol - yk) if yk is not None else float("nan")
    # Offset, bei dem der MKD 0,5 mm vor dem Konnektorkontakt endet: Ende = yk - 0.5 -> offset = Ende - pol
    off = (yk - 0.5 - pol) if yk is not None else float("nan")
    print(f"{name:22s} {ys:7.2f} {yf if yf is not None else float('nan'):9.2f} {kuppel:9.2f} {pol:7.2f} {yk if yk is not None else float('nan'):12.2f} {vor_pol:7.2f} {ye:10.2f}  {off:+.2f}")
