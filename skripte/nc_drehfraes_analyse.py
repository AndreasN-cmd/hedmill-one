#!/usr/bin/env python3
"""Analyse eines Drehfraes-Abschnitts (B dreht, A0) in einem HEDmill-NC.
Aufruf (am Mac, aus dem Repo): python3 -I skripte/nc_drehfraes_analyse.py <nc-datei> <Werkzeug z.B. T4126> [n-tes Vorkommen, Standard 1] [Zonenbreite mm, Standard 0.5]
B steht im NC modulo 360 (B358 -> B0): Spruenge > 180 Grad werden als Umlauf gewertet, nicht als Umkehr.
Satzzeit = Satzlaenge/F mit B in Grad wie mm (kein #TRAFO im NC).
"""
import re, sys, math
from collections import defaultdict

path = sys.argv[1]
tool = sys.argv[2] if len(sys.argv) > 2 else "T4126"
occ = int(sys.argv[3]) if len(sys.argv) > 3 else 1
zw = float(sys.argv[4]) if len(sys.argv) > 4 else 0.5

rx = re.compile(r"([XYZABF])(-?\d+\.?\d*)")
lines = open(path, encoding="latin-1", errors="replace").read().splitlines()

hits = [i for i, l in enumerate(lines) if re.search(rf"\b{tool} M6\b", l)]
if len(hits) < occ:
    sys.exit(f"{tool} M6 nur {len(hits)}x gefunden")
start = hits[occ - 1]
end = len(lines)
for i in range(start + 1, len(lines)):
    if re.search(r"\bT\d+ M6\b", lines[i]):
        end = i
        break
ldyn = next((l.strip() for l in lines[start:start + 5] if "LDYN" in l), "?")
opname = next((l.strip() for l in lines[max(0, start - 6):start] if "OPERATION" in l), "?")
print(f"{opname}")
print(f"Abschnitt {tool} (Vorkommen {occ}): Zeilen {start+1}..{end} ({end-start} Zeilen), {ldyn}")

pos = {"X": 0.0, "Y": 0.0, "Z": 0.0, "A": 0.0, "B": 0.0}
F = None
blocks = []  # (n, Y, Z, dY, dZ, dB, F, dX, X)
for l in lines[start:end]:
    s = l.strip()
    if not s or s[0] in ";(" or s.startswith("L ") or s.startswith("G58") or s.startswith("G59"):
        continue
    m = re.match(r"N(\d+)\s*(.*)", s)
    if not m:
        continue
    n = int(m.group(1)); body = re.sub(r"\(.*?\)", "", m.group(2))
    if re.match(r"[TSML]|G0?4\b|G58|G59|LDYN|#", body):
        continue
    words = dict((k, float(v)) for k, v in rx.findall(body))
    if "F" in words:
        F = words["F"]
    new = dict(pos)
    for k in "XYZAB":
        if k in words:
            new[k] = words[k]
    dY = new["Y"] - pos["Y"]; dZ = new["Z"] - pos["Z"]; dB = new["B"] - pos["B"]; dX = new["X"] - pos["X"]
    wrap = False
    if dB > 180: dB -= 360; wrap = True
    if dB < -180: dB += 360; wrap = True
    if F and F < 20000 and (abs(dB) > 0 or abs(dZ) > 0 or abs(dY) > 0 or abs(dX) > 0):
        blocks.append((n, new["Y"], new["Z"], dY, dZ, dB, F, dX, new["X"], wrap))
    pos = new

print(f"Bearbeitungssaetze (F<20000): {len(blocks)}")
if not blocks:
    sys.exit()
Ys = [b[1] for b in blocks]; Zs = [b[2] for b in blocks]; Xs = [b[8] for b in blocks]
print(f"Y-Bereich: {min(Ys):.3f} .. {max(Ys):.3f} (Start {blocks[0][1]:.3f}, Ende {blocks[-1][1]:.3f}); Z (Radius) {min(Zs):.3f} .. {max(Zs):.3f}; X {min(Xs):.3f} .. {max(Xs):.3f}")
degs = sum(abs(b[5]) for b in blocks)
wraps = sum(1 for b in blocks if b[9])
print(f"B gesamt {degs:.0f} Grad = {degs/360:.0f} Umdrehungen, {wraps} Umlaeufe (Modulo-Spruenge), Saetze je Umdrehung {len(blocks)/max(1,degs/360):.0f}")
tt = sum(math.sqrt(b[3]**2 + b[4]**2 + b[5]**2 + b[7]**2) / b[6] * 60 for b in blocks)
print(f"Rechnerische Zeit bei F (ohne Beschleunigungsphasen): {tt/60:.1f} min")

zone = defaultdict(lambda: {"n": 0, "degB": 0.0, "maxdZdB": 0.0, "rev": 0, "tmin": 9e9, "vZmax": 0.0,
                            "zmin": 9e9, "zmax": -9e9, "t": 0.0, "nB0": 0, "small": 0, "t1": 0, "t2": 0,
                            "ratio": 0.0, "zrev": 0, "zrevfine": 0})
prev_sign = 0; prev_dB = None; prev_dZ = None; total_t = 0.0
for n, Y, Z, dY, dZ, dB, F, dX, X, wrap in blocks:
    k = math.floor(Y / zw) * zw
    z = zone[k]
    z["n"] += 1; z["degB"] += abs(dB)
    L = math.sqrt(dY * dY + dZ * dZ + dB * dB + dX * dX)
    t = L / F * 60.0
    z["t"] += t
    vZ = abs(dZ) / t if t > 0 else 0
    z["vZmax"] = max(z["vZmax"], vZ)
    if abs(dB) > 0:
        z["tmin"] = min(z["tmin"], t)
        z["maxdZdB"] = max(z["maxdZdB"], abs(dZ / dB))
        if abs(dB) <= 0.2: z["small"] += 1
        if t < 0.001: z["t1"] += 1
        if t < 0.002: z["t2"] += 1
        if prev_dB and abs(prev_dB) > 0:
            z["ratio"] = max(z["ratio"], abs(dB) / abs(prev_dB), abs(prev_dB) / abs(dB))
    else:
        z["nB0"] += 1
    sgn = (dB > 0) - (dB < 0)
    if sgn and prev_sign and sgn != prev_sign:
        z["rev"] += 1
    if sgn: prev_sign = sgn
    # Z-Umkehr (Grat/Rille): Vorzeichenwechsel von dZ
    if prev_dZ is not None and dZ * prev_dZ < 0 and abs(dB) > 0:
        z["zrev"] += 1
        if abs(dB) <= 0.2: z["zrevfine"] += 1
    prev_dB = dB; prev_dZ = dZ
    z["zmin"] = min(z["zmin"], Z); z["zmax"] = max(z["zmax"], Z)

print()
print("Y-Zone | Saetze | Umdr. | Saetze/Umdr. | Z min..max | ΔZ/Umdr. | max|dZ/dB| mm/° | dB≤0,2° | t<1ms | t<2ms | dB=0 | B-Umkehr | max Nachbar-Verhaeltnis dB | Z-Umkehr | davon in Saetzen ≤0,2° | t_min ms | vZ max mm/s | Zeit min")
for k in sorted(zone):
    z = zone[k]
    u = z["degB"] / 360
    print(f"{k:7.1f} | {z['n']:6d} | {u:5.1f} | {z['n']/u if u else 0:6.0f} | {z['zmin']:.2f}..{z['zmax']:.2f} | {z['zmax']-z['zmin']:.2f} | {z['maxdZdB']:.4f} | {z['small']:6d} | {z['t1']:5d} | {z['t2']:5d} | {z['nB0']:4d} | {z['rev']:4d} | {z['ratio']:6.1f} | {z['zrev']:5d} | {z['zrevfine']:5d} | {z['tmin']*1000 if z['tmin']<1 else 0:6.2f} | {z['vZmax']:6.1f} | {z['t']/60:5.1f}")

# Saetze, in denen Z die Richtung wechselt und der Satz sehr kurz ist (scharfer Grat)
print()
print("Scharfe Z-Umkehr in kurzen Saetzen (dB ≤ 0,2°), erste 25:")
prev_dZ = None; c = 0
for n, Y, Z, dY, dZ, dB, F, dX, X, wrap in blocks:
    if prev_dZ is not None and dZ * prev_dZ < 0 and 0 < abs(dB) <= 0.2:
        c += 1
        if c <= 25:
            print(f"  N{n} Y{Y:.3f} Z{Z:.4f} dB={dB:+.4f} dZ={dZ:+.5f} (davor dZ={prev_dZ:+.5f})")
    prev_dZ = dZ
print(f"  gesamt {c}")
