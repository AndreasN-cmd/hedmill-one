#!/usr/bin/env python3
"""Werkzeugeinsaetze aus dem HMI-Log (message<JJJJMMTT>.txt) je Werkzeug als Zeitreihe: Delta beim Holen, Warmlauf
(Laenge kalt -> warm), "Nur messen", Delta beim Abgeben, Fraeszeit nach dem Warmlauf. Nur lesend.

Wozu (Review 14.11.2026): zeigt, ob ein Werkzeug gegen die anderen wandert (Verschleiss, Laengenfehler) oder ob alle
gemeinsam wandern (Maschine/Taster). Die Fraeszeit des MKD verraet die CAM-Version (V5.45 ca. 14-20 min, ab V5.49 ca. 5-8 min).
Die Messung des abgehenden Werkzeugs traegt im Log die Nummer des neuen Werkzeugs; das Skript ordnet sie richtig zu.

Aufruf (am Mac): python3 -I skripte/werkzeug_warm_log.py <Log-Ordner> [Werkzeuge, z.B. 4126,4089,4083]
"""
import re, sys, glob, os
RXZ = re.compile(r"^(\d{8})T(\d{2})(\d{2})(\d{2})\d* --- (.*)$")
def sek(d, h, m, s): return (int(d[6:8])*24 + int(h))*3600 + int(m)*60 + int(s)
ev = []
for p in sorted(glob.glob(os.path.join(sys.argv[1], "message*.txt"))):
    for z in open(p, encoding="latin-1", errors="replace"):
        m = RXZ.match(z.strip())
        if m: ev.append((sek(*m.groups()[:4]), m.group(1)[6:8]+"."+m.group(2)+":"+m.group(3), m.group(5)))
blank = None; akt = None; last_delta = None; rows = []
cur = None
def schliessen(t, dab):
    global cur
    if cur:
        cur["ende"] = t; cur["dab"] = dab; rows.append(cur); cur = None
for t, zs, tx in ev:
    m = re.match(r"Blank '([^']+)' im B-Achsennullpunktspannsystem abgesetzt", tx)
    if m: blank = m.group(1); continue
    m = re.match(r"Blank '([^']+)' aus B-Achse geholt", tx)
    if m: blank = None; continue
    m = re.match(r"T(\d+) Werkzeugdeltal.nge (-?[\d.eE+-]+)mm", tx)
    if m: last_delta = (t, float(m.group(2))*1000); continue
    if re.match(r"T0 wurde erfolgreich in den Werkzeugwechsler abgelegt", tx):
        schliessen(last_delta[0] if last_delta else t, last_delta[1] if last_delta else None); continue
    m = re.match(r"T(\d+) wurde aus dem Werkzeugwechsler geholt", tx)
    if m:
        cur = dict(blank=blank, wz=m.group(1), zeit=zs, start=t, dan=last_delta[1] if last_delta and t-last_delta[0] < 10 else None, warm=[], mess=[])
        continue
    m = re.match(r"WARMT(\d+)\S*: Warmlauf \d+ min Start, Laenge aktiv ([\d.]+)mm", tx)   # 4 min, seit CAM V5.74 auch ...MIN8
    if m and cur: cur["w0"] = float(m.group(2)); continue
    m = re.match(r"WARMT(\d+)\S*: warm nachgemessen, Laenge aktiv ([\d.]+)mm", tx)
    if m and cur: cur["w1"] = float(m.group(2)); cur["tw"] = t; continue
    m = re.match(r"MESST(\d+)\S*: nachgemessen, Laenge aktiv ([\d.]+)mm, Aenderung (-?[\d.]+)mm", tx)
    if m and cur: cur["mess"].append(float(m.group(3))*1000); continue
    m = re.match(r"T(\d+) Werkzeugl.nge ([\d.]+)mm ermittelt", tx)
    if m and cur: cur.setdefault("voll", []).append(float(m.group(2))); continue
wz = sys.argv[2].split(",") if len(sys.argv) > 2 else None
print("Zeit   Blank                 WZ    Δ Holen µm  Warmlauf: L kalt -> warm (Δ µm)   Nur messen µm   Δ Abgabe µm  Fräszeit min (nach Warmlauf)")
for r in rows:
    if wz and r["wz"] not in wz: continue
    w = f"{r['w0']:.4f} -> {r['w1']:.4f} ({(r['w1']-r['w0'])*1000:+5.1f})" if "w1" in r else " " * 30
    fz = (r["ende"] - r.get("tw", r["start"])) / 60
    dan = f"{r['dan']:+6.1f}" if r["dan"] is not None else "     –"
    dab = f"{r['dab']:+6.1f}" if r["dab"] is not None else "     –"
    print(f"{r['zeit']} {str(r['blank']):21s} T{r['wz']} {dan}      {w}  {str([round(x,1) for x in r['mess']]):12s}  {dab}      {fz:5.1f}")
