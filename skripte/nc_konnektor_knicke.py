#!/usr/bin/env python3
"""Sucht im MKD-Drehfraesabschnitt eines HEDmill-NC die Stellen, an denen der Torus den Konnektorzylinder
(Z konstant) verlaesst oder erreicht (Knick in der Z(B)-Kontur), und bewertet sie.
Aufruf (am Mac, aus dem Repo): python3 -I skripte/nc_konnektor_knicke.py <nc> [Werkzeug T4126] [Satznummern der Ereignisse, z. B. 4616650 4692170]
"""
import re, sys, math

path = sys.argv[1]
tool = sys.argv[2] if len(sys.argv) > 2 else "T4126"
events = set(int(x) for x in sys.argv[3:])
rx = re.compile(r"([XYZABF])(-?\d+\.?\d*)")
lines = open(path, encoding="latin-1", errors="replace").read().splitlines()
start = next(i for i, l in enumerate(lines) if re.search(rf"\b{tool} M6\b", l))
end = next((i for i in range(start + 1, len(lines)) if re.search(r"\bT\d+ M6\b", lines[i])), len(lines))
pos = {"X": 0.0, "Y": 0.0, "Z": 0.0, "B": 0.0}; F = None
blocks = []
for l in lines[start:end]:
    m = re.match(r"N(\d+)\s*(.*)", l.strip())
    if not m: continue
    body = re.sub(r"\(.*?\)", "", m.group(2))
    if re.match(r"[TSML]|G0?4\b|G58|G59|LDYN|#", body): continue
    w = dict((k, float(v)) for k, v in rx.findall(body))
    if "F" in w: F = w["F"]
    new = dict(pos)
    for k in "XYZB":
        if k in w: new[k] = w[k]
    dB = new["B"] - pos["B"]
    if dB > 180: dB -= 360
    if dB < -180: dB += 360
    if F and F < 20000 and dB != 0:
        blocks.append((int(m.group(1)), new["Y"], new["Z"], new["Z"] - pos["Z"], dB, F))
    pos = new

# Konnektorradius = haeufigster Z-Wert nahe dem Minimum
zs = sorted(b[2] for b in blocks)
zmin = zs[int(len(zs) * 0.002)]
rk = round(zmin, 1)
print(f"Abschnitt {tool}: {len(blocks)} Saetze, kleinster Radius {zmin:.3f} -> Konnektor-Radius ≈ {rk}")

# Flache Strecke: |dZ/dB| < 0.002 mm/Grad und Z < rk + 0.05
def flat(b): return abs(b[3] / b[4]) < 0.004 and b[2] < rk + 0.06
kinks = []
for i in range(6, len(blocks) - 3):
    b = blocks[i]
    prev = blocks[i - 6:i]
    if all(flat(p) for p in prev) and not flat(b):
        steep = max(abs(blocks[j][3] / blocks[j][4]) for j in range(i, min(i + 4, len(blocks))))
        if steep > 0.02:
            kinks.append(("Austritt", b[0], b[1], b[2], b[4], b[3] / b[4], steep, prev[-1][4]))
    if i + 7 < len(blocks) and all(flat(p) for p in blocks[i + 1:i + 7]) and not flat(b):
        steep = max(abs(blocks[j][3] / blocks[j][4]) for j in range(max(0, i - 3), i + 1))
        if steep > 0.02:
            kinks.append(("Eintritt", b[0], b[1], b[2], b[4], b[3] / b[4], steep, blocks[i + 1][4]))

print(f"Konnektor-Knicke gesamt: {len(kinks)} (Austritt {sum(1 for k in kinks if k[0]=='Austritt')}, Eintritt {sum(1 for k in kinks if k[0]=='Eintritt')})")
ys = [k[2] for k in kinks]
if ys: print(f"Y-Bereich der Knicke: {min(ys):.2f} .. {max(ys):.2f}")
# Ereignisse zuordnen: naechster Knick vor/bei der Satznummer
for ev in sorted(events):
    cand = [k for k in kinks if abs(k[1] - ev) <= 60]
    print(f"Ereignis N{ev}: " + (", ".join(f"{k[0]} N{k[1]} Y{k[2]:.2f} Z{k[3]:.3f} dZ/dB {k[5]:+.4f} steilste {k[6]:.4f} mm/°, Satz davor/danach {k[7]:.3f}°" for k in cand) if cand else "kein Konnektor-Knick in ±60 Saetzen"))
# Rangfolge nach Steilheit
kinks.sort(key=lambda k: -k[6])
print("\nSteilste 15 Knicke (Steilheit = max |dZ/dB| der ersten 4 Saetze nach dem Knick):")
for k in kinks[:15]:
    mark = " <== EREIGNIS" if any(abs(k[1] - ev) <= 60 for ev in events) else ""
    print(f"  {k[0]:8s} N{k[1]} Y{k[2]:.2f} Z{k[3]:.3f} steil {k[6]:.4f} mm/° erster Satz {k[4]:.4f}° (davor {k[7]:.3f}°){mark}")
import statistics
if kinks:
    st = [k[6] for k in kinks]
    print(f"Steilheit alle Knicke: Median {statistics.median(st):.4f}, max {max(st):.4f}")
    rank = {k[1]: i + 1 for i, k in enumerate(kinks)}
    for ev in sorted(events):
        for k in kinks:
            if abs(k[1] - ev) <= 60: print(f"  Ereignis N{ev}: Rang {rank[k[1]]} von {len(kinks)} nach Steilheit")

# Zeitanteil der Konnektorzone: Y ab erstem flachen Konnektorsatz
flatY = [b[1] for b in blocks if flat(b)]
if flatY:
    y0 = min(flatY)  # Y, bei dem der Konnektor erstmals beruehrt wird (negatives Y = Start)
    t_all = sum(abs(b[4]) / b[5] * 60 for b in blocks)
    t_zone = sum(abs(b[4]) / b[5] * 60 for b in blocks if b[1] >= y0)
    print(f"\nKonnektorkontakt ab Y {y0:.2f} bis Ende {blocks[-1][1]:.2f}: {blocks[-1][1]-y0:.2f} mm, Zeit {t_zone/60:.1f} von {t_all/60:.1f} min")
