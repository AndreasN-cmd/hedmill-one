#!/usr/bin/env python3
"""Wie stark schwankt die Z-Kette (Spindel + Z-Achse + Kuehlung) von Teil zu Teil? - nur lesend, am Mac.

Frage (Techniker 11/2026): Die Spindelkuehlung nutzt ein Temperaturband von 2 Grad C; ueber die Laenge der Z-Achse
seien das 16 um. Sieht man das in den Werkzeuglaengen, und in welcher Zeit?

Was das HMI-Log hergibt (message<JJJJMMTT>.txt): jedes Werkzeug wird beim Holen und beim Abgeben im Stillstand angetastet
("Tn Werkzeugdeltalaenge d mm ermittelt", d gegen die aktive Laenge; die Messung des abgehenden Werkzeugs traegt die
Nummer des neuen).
  Abgabe-Delta = Aenderung waehrend des Jobs (gleiche Einspannung, Dauer = Jobdauer).
      Der Median je Werkzeug ist die Spindelwaerme nach Drehzahl (wiederholbar),
      die STREUUNG um den Median ist alles, was von Teil zu Teil anders ist: Kuehlband, Raum, Taster.
  Hol-Delta    = Aenderung seit der letzten Abgabe dieses Werkzeugs (etwa ein Teil spaeter, neu eingespannt).
      Streuung = langsame Aenderung der Kette + Wiederholgenauigkeit des Kegels.
Robuste Streuung = 1,4826 x mittlere absolute Abweichung vom Median (Ausreisser zaehlen nicht mit); Ausreisser werden
getrennt gezaehlt (Abweichung vom Median > 5 um).

Lesehilfe: Schwankte die Kette mit 16 um Spitze-Spitze in Zeiten kuerzer als ein Job, laege die Streuung der
Abgabe-Deltas langer Jobs bei etwa 0,41 x 16 = 6,5 um (zwei zufaellige Proben einer Dreieckschwingung).

Aufruf (am Mac): python3 -I skripte/laengen_streuung_log.py <Log-Ordner oder message-Dateien> [--werte T4126]
"""
import collections, glob, os, re, statistics as st, sys

RXZ = re.compile(r"^(\d{8})T(\d{2})(\d{2})(\d{2})\d* --- (.*)$")
args = [a for a in sys.argv[1:] if not a.startswith("--")]
werte = sys.argv[sys.argv.index("--werte") + 1].lstrip("T") if "--werte" in sys.argv else None
if werte:
    args = [a for a in args if a.lstrip("T") != werte]
dateien = []
for a in args:
    dateien += sorted(glob.glob(os.path.join(a, "message*.txt"))) if os.path.isdir(a) else [a]
if not dateien:
    sys.exit(__doc__)

ev = []
for p in dateien:
    for z in open(p, encoding="latin-1", errors="replace"):
        m = RXZ.match(z.strip())
        if m:
            d, h, mi, s, tx = m.groups()
            ev.append(((int(d[4:6]) * 31 + int(d[6:8])) * 86400 + int(h) * 3600 + int(mi) * 60 + int(s), f"{d[6:8]}.{d[4:6]}. {h}:{mi}", tx))

ab = collections.defaultdict(list)   # wz -> (zeit, dauer_min, delta_um)
an = collections.defaultdict(list)   # wz -> delta_um
akt = th = last = None
for t, zs, tx in ev:
    m = re.match(r"T(\d+) Werkzeugdeltal.nge (-?[\d.eE+-]+)mm", tx)
    if m:
        last = (t, float(m.group(2)) * 1000)
        continue
    if tx.startswith("T0 wurde erfolgreich in den Werkzeugwechsler abgelegt"):
        if last and akt and t - last[0] < 60 and abs(last[1]) < 60:
            ab[akt].append((zs, (last[0] - th) / 60, last[1]))
        last = akt = None
        continue
    m = re.match(r"T(\d+) wurde aus dem Werkzeugwechsler geholt", tx)
    if m:
        if last and t - last[0] < 10 and abs(last[1]) < 60:
            an[m.group(1)].append(last[1])
        akt, th, last = m.group(1), t, None


def rob(v):
    med = st.median(v)
    return med, st.median([abs(x - med) for x in v]) * 1.4826, sum(1 for x in v if abs(x - med) > 5)


print(f"Zeitraum {ev[0][1]} bis {ev[-1][1]}, {sum(len(v) for v in ab.values())} Abgaben")
print("WZ       n  Job min | Abgabe (im Job): Median  rob.Streuung  Ausreisser>5 | Holen (seit letzter Abgabe): Median  rob.Streuung")
for wz in sorted(ab):
    v = [x[2] for x in ab[wz] if x[1] >= 1.5]
    if len(v) < 8:
        continue
    m1, s1, a1 = rob(v)
    hol = an.get(wz, [])
    h = "%+7.1f      %5.1f" % rob(hol)[:2] if len(hol) > 3 else "      -          -"
    print(f"T{wz:5s} {len(v):3d}  {st.median([x[1] for x in ab[wz]]):6.1f} |        {m1:+7.1f}        {s1:5.1f}        {a1:2d}/{len(v):<3d}  |                        {h}")
if werte:
    print(f"\nT{werte} Einzelwerte Abgabe: " + "  ".join(f"{z} ({d:.0f} min) {v:+.1f}" for z, d, v in ab[werte]))
