#!/usr/bin/env python3
"""Verliert ein Werkzeug gegen die anderen Laenge (Verschleiss, Ausbruch, Setzen im Halter)? - nur lesend, am Mac.

Frage (Review 24.11.2026, zweiter MKD seit 23.11.): Die Maschine tastet jedes Werkzeug beim Holen und beim Abgeben an.
Summiert man je Werkzeug alle gemessenen Aenderungen (Holen, Warmlauf WARMT, Nur messen MESST, Abgeben), erhaelt man
seine Laenge als Reihe ueber die Teile. Darin stecken zwei Dinge:
  gemeinsame Drift   alle Werkzeuge gleich (Z-Kette der Maschine: Kuehlung, Raum, Dauerlauf)
  eigener Anteil     nur dieses Werkzeug (Verschleiss der Spitze, Ausbruch, Rutschen im Halter)
Verglichen wird der Stand beim Holen (letzte Nutzung je Teil): gleicher Ablauf davor, also gleicher Waermezustand.
Ausgabe: Stand je Teil und Werkzeug (um, relativ zum ersten Teil des Abschnitts), Aenderung vom ersten zum letzten Teil
und je Teil. Ein neues Werkzeug (Vollmessung beim Holen) beginnt einen neuen Abschnitt (*).
Dazu fuer ein Werkzeug (--einzel, Standard 4126 = MKD) je Teil: Holen / Warmlauf / im Job.

Lesehilfe: Liegen alle Werkzeuge bei -2 bis -3 um je Teil und eines bei -5, verliert dieses rund 2 um je Teil selbst.
Das erste Teil nach einem Kaltstart nicht mitzaehlen (--ab 2): spaete Werkzeuge im Teil sehen dort einen anderen Zustand.
Grenze: einzelne Werkzeuge weichen auch ohne Verschleiss um 2-3 um je Teil ab (anderer Waermezustand beim Holen);
erst ein Vergleich mit einem zweiten Log desselben Werkzeugtyps macht die Aussage belastbar.

Aufruf (am Mac): python3 -I skripte/laengen_trend_log.py <Log-Ordner> [--blank GA,MG] [--ab 2] [--einzel 4126]
"""
import collections, glob, os, re, sys


def arg(n, d):
    return sys.argv[sys.argv.index(n) + 1] if n in sys.argv else d


if len(sys.argv) < 2:
    sys.exit(__doc__)
RXZ = re.compile(r"^(\d{8})T(\d{2})(\d{2})(\d{2})\d* --- (.*)$")
ev = []
for p in sorted(glob.glob(os.path.join(sys.argv[1], "message*.txt"))):
    for z in open(p, encoding="latin-1", errors="replace"):
        m = RXZ.match(z.strip())
        if m:
            d, h, mi, s, tx = m.groups()
            ev.append(((int(d[4:6]) * 31 + int(d[6:8])) * 86400 + int(h) * 3600 + int(mi) * 60 + int(s), f"{d[6:8]}.{d[4:6]}. {h}:{mi}", tx))
L = collections.defaultdict(float); seg = collections.defaultdict(int)
akt = pend = blank = neu = w0 = None
rows = []      # (t, zeit, blank, wz, art, stand, abschnitt, aenderung)
for t, zs, tx in ev:
    m = re.match(r"Blank '([^']+)' im B-Achsennullpunktspannsystem abgesetzt", tx)
    if m:
        blank = m.group(1); continue
    if re.match(r"Blank '([^']+)' aus B-Achse geholt", tx):
        blank = None; continue
    m = re.match(r"T(\d+) Werkzeugdeltal.nge (-?[\d.eE+-]+)mm", tx)
    if m:
        pend = (t, float(m.group(2)) * 1000); continue
    m = re.match(r"T(\d+) Werkzeugl.nge ([\d.]+)mm ermittelt", tx)
    if m:
        if akt != m.group(1):
            neu = (t, m.group(1))
        continue
    m = re.match(r"(?:WARMT|MESST)(\d+)\S*: (?:Warmlauf \d+ min )?Start, Laenge aktiv ([\d.]+)mm", tx)
    if m:
        w0 = float(m.group(2)) * 1000; continue
    m = re.match(r"(WARMT|MESST)(\d+)\S*: (?:warm )?nachgemessen, Laenge aktiv ([\d.]+)mm", tx)
    if m and akt == m.group(2) and w0 is not None:
        dl = float(m.group(3)) * 1000 - w0; L[akt] += dl
        rows.append((t, zs, blank, akt, "Warmlauf" if m.group(1) == "WARMT" else "Messen", L[akt], seg[akt], dl))
        w0 = float(m.group(3)) * 1000; continue
    if tx.startswith("T0 wurde erfolgreich in den Werkzeugwechsler abgelegt"):
        if pend and akt and abs(pend[1]) < 80:
            L[akt] += pend[1]; rows.append((pend[0], zs, blank, akt, "im Job", L[akt], seg[akt], pend[1]))
        pend = akt = None; continue
    m = re.match(r"T(\d+) wurde aus dem Werkzeugwechsler geholt", tx)
    if m:
        wz = m.group(1)
        if neu and neu[1] == wz and t - neu[0] < 30:
            seg[wz] += 1; L[wz] = 0.0; rows.append((t, zs, blank, wz, "neu", 0.0, seg[wz], 0.0))
        elif pend and t - pend[0] < 10 and abs(pend[1]) < 80:
            L[wz] += pend[1]; rows.append((t, zs, blank, wz, "Holen", L[wz], seg[wz], pend[1]))
        akt, pend, neu, w0 = wz, None, None, None

filt = arg("--blank", "").split(",") if "--blank" in sys.argv else None
ab = int(arg("--ab", "1"))
blanks = []
for r in rows:
    if r[2] and r[2] not in blanks and (not filt or any(f in r[2] for f in filt)):
        blanks.append(r[2])
blanks = blanks[ab - 1:]
if not blanks:
    sys.exit("keine Teile gefunden")
tools = sorted({r[3] for r in rows if r[2] in blanks})


def stand(b, w):
    v = [r for r in rows if r[2] == b and r[3] == w and r[4] in ("Holen", "neu")]
    return (v[-1][5], v[-1][6]) if v else None


print(f"Stand beim Holen je Teil (um, relativ zum ersten Teil des Abschnitts; * = neues Werkzeug), Teile {len(blanks)}")
print("Teil".ljust(14) + "".join(f"T{w}".rjust(8) for w in tools))
erst = {}; reihen = collections.defaultdict(list)
for b in blanks:
    z = b[-12:].ljust(14)
    for w in tools:
        s = stand(b, w)
        if s is None:
            z += "       -"; continue
        k = (w, s[1]); stern = k not in erst and any(kk[0] == w for kk in erst)
        erst.setdefault(k, s[0]); reihen[k].append(s[0] - erst[k])
        z += (("*" if stern else "") + f"{s[0] - erst[k]:+.0f}").rjust(8)
    print(z)
print("\nAenderung vom ersten zum letzten Teil des Abschnitts (nur Abschnitte mit mindestens 5 Teilen):")
for (w, sg), v in sorted(reihen.items()):
    if len(v) >= 5:
        print(f"  T{w}: {v[-1]:+6.1f} um in {len(v) - 1} Schritten = {v[-1] / (len(v) - 1):+5.2f} um je Teil")
einzel = arg("--einzel", "4126")
print(f"\nT{einzel} je Teil (um): Holen = gegen die letzte Abgabe, Warmlauf = kalt -> warm, im Job = Abgabe")
for b in blanks:
    v = [r for r in rows if r[2] == b and r[3] == einzel]
    if v:
        print("  " + v[0][1] + " " + b[-12:].ljust(14) + "  ".join(f"{r[4]} {r[7]:+.1f}" for r in v if r[4] != "neu"))
