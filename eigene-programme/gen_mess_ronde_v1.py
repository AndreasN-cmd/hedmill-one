"""Erzeugt MESS_RONDE_G54G55_V1.nc: Messplaettchen in einer PMMA-Ronde 98x16 fuer G54/G55-X, Hoehe (Laengenoffset) und A-Kippung.
Werkzeug T3011 Kugel D3 (R1.5). Alle Masse in mm, Koordinaten im Nullpunkt G54 (B0) bzw. G55 (B180)."""
R = 1.5
S, F_CUT, F_FIN, F_RAMP, F_POS = 37000, 4000, 3000, 1200, 17000
Z_TOP, Z_BOT = 8.0, -8.0            # Ronde 16 mm, mittig zur Drehachse
Z_PLAT = 3.0                        # Plateau je Seite -> Plaettchen 6 mm
Z_SLOT = -6.5                       # Umriss-Nut bis 1.5 mm Haut
Z_THRU = -4.6                       # Taschen durch das Plaettchen (Kugelmitte unter -3)
Z_SAFE = 20.0
FACE0 = (-15.0, 15.0, -38.0, 38.0)  # Planen B0 (x1,x2,y1,y2)
FACE1 = (-11.0, 11.0, -35.0, 35.0)  # Planen B180 (laesst 1 mm Steg zum Umriss)
PIECE = (-12.0, 12.0, -36.0, 36.0)  # Plaettchen (Umriss-Nut aussen daran)
BANDS = {1: (19.0, 31.0), 2: (4.0, 16.0), 3: (-16.0, -4.0), 4: (-31.0, -19.0)}
SLOT_L, SLOT_R = (-13.0, -3.0), (3.0, 13.0)   # bis in die Umriss-Nut, damit der Amboss von aussen an die Flanke kommt
HOLE = (0.0, 33.5)

out = []
def L(s): out.append(s)
def f(v): return f"{v:.3f}".rstrip("0").rstrip(".") if abs(v) >= 1e-9 else "0"

def facing(area, z_from, z_to, ap, ae_rough, ae_fin):
    x1, x2, y1, y2 = area
    xs_lo, xs_hi = x1 + R, x2 - R          # Werkzeugmitten
    ys_lo, ys_hi = y1 + R, y2 - R
    layers = []
    z = z_from
    while z - ap > z_to + 1e-6:
        z -= ap; layers.append((z, ae_rough, F_CUT))
    layers.append((z_to, ae_fin, F_FIN))
    for z, ae, feed in layers:
        n = int((xs_hi - xs_lo) / ae + 0.999)
        ae_eff = (xs_hi - xs_lo) / n
        L(f"G1 G90 X{f(xs_lo)} Y{f(ys_lo)} F{F_POS}")
        L(f"G1 G90 Z{f(z + ap + 0.5)} F{F_POS}")
        ramp_len = min(24.0, ys_hi - ys_lo)
        L(f"G1 G90 Y{f(ys_lo + ramp_len)} Z{f(z)} F{F_RAMP}")   # Rampe entlang Y
        L(f"G1 G90 Y{f(ys_hi)} F{feed}")
        for i in range(1, n + 1):
            x = xs_lo + i * ae_eff
            L(f"G1 G90 X{f(x)}")
            L(f"G1 G90 Y{f(ys_lo if i % 2 else ys_hi)}")
        L(f"G1 G90 Z{f(z + 1.0)} F{F_POS}")                 # Rampenbahn flach nachfahren: erst heben
        L(f"G1 G90 X{f(xs_lo)} Y{f(ys_hi)} F{F_POS}")
        L(f"G1 G90 Z{f(z)} F{F_RAMP}")
        L(f"G1 G90 Y{f(ys_lo)} F{feed}")
        L(f"G1 G90 Z{f(Z_SAFE)} F{F_POS}")

def outline(z_from, z_to, ap):
    x1, x2, y1, y2 = PIECE
    cx1, cx2, cy1, cy2 = x1 - R, x2 + R, y1 - R, y2 + R   # Werkzeugmitte 1.5 ausserhalb
    L(f"G1 G90 X{f(cx1)} Y{f(cy1)} F{F_POS}")
    L(f"G1 G90 Z{f(z_from + 0.5)} F{F_POS}")
    z = z_from
    while z > z_to + 1e-6:
        z = max(z - ap, z_to)
        L(f"G1 G90 X{f(cx1)} Y{f(cy1 + 20)} Z{f(z)} F{F_RAMP}")   # Rampe auf der ersten Kante
        L(f"G1 G90 Y{f(cy2)} F{F_CUT}")
        L(f"G1 G90 X{f(cx2)}")
        L(f"G1 G90 Y{f(cy1)}")
        L(f"G1 G90 X{f(cx1)}")
        L(f"G1 G90 Y{f(cy1 + 20)}")      # Rampenstueck nochmals auf volle Tiefe
        L(f"G1 G90 Y{f(cy1)}")
    L(f"G1 G90 Z{f(Z_SAFE)} F{F_POS}")

def pocket(xr, yr, z_from, z_to, ap, flank_x):
    """Tasche xr x yr, Bahnen entlang Y, letzte Bahn am Messflanke-seitigen Rand; flank_x = Mitte der Bahn an der Messflanke"""
    xa, xb = xr; ya, yb = yr
    lanes = [xa + R + k * (xb - xa - 2 * R) / 3 for k in range(4)]   # 4 Bahnen, ae 1.67
    if abs(lanes[0] - flank_x) < 1e-6: lanes = lanes[::-1]   # Flankenbahn zuletzt
    ya_c, yb_c = ya + R, yb - R
    L(f"G1 G90 X{f(lanes[0])} Y{f(ya_c)} F{F_POS}")
    L(f"G1 G90 Z{f(z_from + 0.5)} F{F_POS}")
    z = z_from
    zprev = z_from + 0.5
    while z > z_to + 1e-6:
        z = max(z - ap, z_to)
        L(f"G1 G90 Z{f(zprev + 1.0)} F{F_POS}")           # ueber die Riefen der letzten Ebene heben
        L(f"G1 G90 X{f(lanes[0])} Y{f(ya_c)} F{F_POS}")
        L(f"G1 G90 Z{f(zprev)} F{F_POS}")
        L(f"G1 G90 Y{f(yb_c)} Z{f(z)} F{F_RAMP}")        # Rampe auf der ersten Bahn
        L(f"G1 G90 Y{f(ya_c)} F{F_CUT}")
        L(f"G1 G90 X{f(lanes[1])}")
        L(f"G1 G90 Y{f(yb_c)}")
        L(f"G1 G90 X{f(lanes[2])}")
        L(f"G1 G90 Y{f(ya_c)}")
        L(f"G1 G90 X{f(lanes[3])}")
        L(f"G1 G90 Y{f(yb_c)}")
        L(f"G1 G90 X{f(lanes[0])}")                        # Rampenbahn flach nachfahren
        L(f"G1 G90 Y{f(ya_c)}")
        zprev = z
    # Schlichtgang an der Messflanke auf voller Tiefe
    L(f"G1 G90 X{f(lanes[3])} Y{f(ya_c)} F{F_FIN}")
    L(f"G1 G90 Y{f(yb_c)}")
    L(f"G1 G90 Y{f(ya_c)}")
    L(f"G1 G90 Z{f(Z_SAFE)} F{F_POS}")

def hole(xy, z_from, z_to):
    x, y = xy
    L(f"G1 G90 X{f(x)} Y{f(y)} F{F_POS}")
    L(f"G1 G90 Z{f(z_from + 0.5)} F{F_POS}")
    z = z_from
    while z > z_to + 1e-6:
        z = max(z - 1.5, z_to)
        L(f"G1 G90 Z{f(z)} F600")
        L(f"G1 G90 Z{f(z_from + 0.5)} F{F_POS}")
    L(f"G1 G90 Z{f(Z_SAFE)} F{F_POS}")

# ---------------- Kopf ----------------
L("; ==========================================================")
L("; MESS_RONDE_G54G55 V1 - Messplaettchen fuer G54/G55 (Ronde A0)")
L("; Werkzeug: T3011 Kugel D3.0 (Kunststoff), ein Werkzeug fuer alles")
L("; Rohling:  PMMA-Ronde D98 x 16, Rondenhalter, Mitte = Drehachse")
L("; ----------------------------------------------------------")
L("; PRINZIP (wie das HEDS-Testkreuz, nur kleiner und mit der")
L(";   Buegelmessschraube messbar): Ein Plaettchen 24 x 72 wird von")
L(";   beiden Seiten auf 6.000 geplant (B0 unter G54, B180 unter G55).")
L(";   Vier Zungen 6 mm breit, Flanken senkrecht zu X, Schlitze 10 mm")
L(";   breit und zum Rand hin offen (Amboss kommt von aussen an die Flanke):")
L(";   Zunge 1 (Y+25) Referenz: beide Flanken aus B0")
L(";   Zunge 2 (Y+10) FLIP:     linke Flanke B0, rechte Flanke B180")
L(";   Zunge 3 (Y-10) REVERS:   linke Flanke B180, rechte Flanke B0")
L(";   Zunge 4 (Y-25) Referenz: beide Flanken aus B0")
L(";   Marke: Loch D3 am Y-PLUS-Ende (bei Y+33.5)")
L(";   Das Plaettchen haengt an 1 mm Steg und 1.5 mm Haut:")
L(";   nach dem Fraesen herausbrechen oder heraussaegen.")
L(";")
L("; MESSEN (Buegelmessschraube):")
L(";   W1..W4 = Breite der Zungen (quer, in X)          SOLL 6.000")
L(";   T1..T4 = Dicke der Zungen (Plateau zu Plateau)   SOLL 6.000")
L(";   Reihenfolge 1..4 vom Loch aus.")
L(";")
L("; AUSWERTUNG:")
L(";   dX = (W2 - W3) / 4        -> G54-X und G55-X je um dX aendern")
L(";   Probe: (W2 + W3) / 2 = (W1 + W4) / 2  (Werkzeugradius faellt heraus)")
L(";   dZ = (6.000 - Mittel T1..T4) / 2  -> Werkzeug-Laengenoffset (Abstimmung!)")
L(";   dA = atan((T1 - T4) / (4 * 25)) * 180/pi  -> A-Spalte G54 und G55,")
L(";        Vorzeichen wie HEDS-Merkblatt: Y-PLUS-Seite dicker = positiv")
L(";")
L("; ERSTEN LAUF im Einzelsatz mit Override fahren!")
L("; ==========================================================")
L("")
L("M107 M111 M118 ; Absaugung / Luft AUS")
L(f"M06 T3011 ; Werkzeugwechsel")
L("LDYN60")
L(f"S{S} M03")
L("LSAFEPOS")
L("G54")
L("G1 FV.E.FEEDMAX A0.00 B0.00")
L("G1 FV.E.FEEDMAX X0 Y0")
L("M106 M110 M117 ; Absaugung / Luft EIN")
L("M120")
L("")
L("; ---- SEITE 1 (B0, G54): Planen auf Z3, Umriss-Nut, Taschen B0, Loch ----")
L(f"G1 G90 Z{f(Z_SAFE)} F{F_POS}")
L("; Planen 30 x 76 von Z8 auf Z3")
facing(FACE0, Z_TOP, Z_PLAT, 1.25, 1.0, 0.25)
L("; Umriss-Nut 24 x 72 bis Z-6.5 (Haut 1.5)")
outline(Z_PLAT, Z_SLOT, 1.0)
L("; Taschen aus B0: Zunge 1 beide, Zunge 2 links, Zunge 3 rechts, Zunge 4 beide")
for t, side in ((1, "L"), (1, "R"), (2, "L"), (3, "R"), (4, "L"), (4, "R")):
    xr = SLOT_L if side == "L" else SLOT_R
    flank = (xr[1] - R) if side == "L" else (xr[0] + R)
    L(f"; Zunge {t}, Tasche {'links' if side=='L' else 'rechts'}")
    pocket(xr, BANDS[t], Z_PLAT, Z_THRU, 1.27, flank)
L("; Marke Y-PLUS")
hole(HOLE, Z_PLAT, Z_THRU)
L("")
L("; ---- Wenden auf B180 (G55) ----")
L("LSAFEPOSZ")
L("G1 FV.E.FEEDMAX B0 A0")
L("Y-110")
L("G55")
L("B180")
L("X0.0 Y0.0")
L("G1 FV.E.FEEDMAX A0.00 B180.00")
L("")
L("; ---- SEITE 2 (B180, G55): Planen auf Z3, Taschen B180 ----")
L(f"G1 G90 Z{f(Z_SAFE)} F{F_POS}")
L("; Planen 22 x 70 von Z8 auf Z3 (Steg 1 mm bleibt am Umriss)")
facing(FACE1, Z_TOP, Z_PLAT, 1.25, 1.0, 0.25)
L("; Taschen aus B180: in G55 gespiegelt programmiert")
L("; Zunge 2: Tasche bei X-11..-3 in G55 = rechte Seite am Teil")
pocket(SLOT_L, BANDS[2], Z_TOP, Z_THRU, 1.27, SLOT_L[1] - R)   # ab Z8: raeumt Steg und Haut am Rand mit ab
L("; Zunge 3: Tasche bei X3..11 in G55 = linke Seite am Teil")
pocket(SLOT_R, BANDS[3], Z_TOP, Z_THRU, 1.27, SLOT_R[0] + R)
L("")
L("; ---- Ende: zurueck auf B0 ----")
L("M111")
L("M118")
L("M121")
L("LSAFEPOSZ")
L("G1 FV.E.FEEDMAX B180 A0")
L("Y-110")
L("G54")
L("B0")
L("X0.0 Y0.0")
L("LSAFEPOS")
L("M5")
L("M30")
import sys
open(sys.argv[1], "w", newline="\n").write("\n".join(out) + "\n")
print(len(out), "Zeilen")
