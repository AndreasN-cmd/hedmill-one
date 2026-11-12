#!/usr/bin/env python3
"""Werkzeuglaengen aus dem HMI-Log (C:\\HMI\\log\\message<JJJJMMTT>.txt) auswerten - nur lesend, am Mac.

Frage (Fit-Check 12.11.2026): Arbeiten die Teleskop-Werkzeuge nach der Laengenoffset-Aenderung (49,828 -> 49,776,
11.11.2026 zwischen 09:25 und 10:19) mit einer Laenge, die zum neuen Offset passt?

Was das Log hergibt (Code measureTool / toolBreakControl / M6 / getTool, docs/02 und docs/06):
  - Vollmessung (measureTool, nur wenn das Werkzeug neu/geaendert ist):
      "Tn Werkzeuglaenge L mm ermittelt (erwartet E mm)"  ->  gespeicherte Laenge L = MESS.Z - Offset
  - sonst bei jedem Wechsel nur Kontrolle (toolBreakControl):
      "Tn Werkzeugdeltalaenge d mm ermittelt"  ->  d = [MESS.Z - Offset] - L_gespeichert
    d ~ 0  : gespeicherte Laenge passt zum aktuellen Offset
    d ~ +0,05 nach der Offset-Aenderung : gespeicherte Laenge stammt noch vom alten Offset
  - Beschriftung: Die Messung des ABGEHENDEN Werkzeugs (in M6, vor "T0 ... abgelegt") traegt die Nummer des NEUEN
    Werkzeugs. Das Skript ordnet sie dem zuletzt geholten Werkzeug zu.

Aufruf (am Mac, Ordner von LOGS_SAMMELN oder einzelne Dateien):
  python3 -I skripte/werkzeuglaengen_log.py ~/Desktop/HEDmill-Logs-2026-11-12_1500
  python3 -I skripte/werkzeuglaengen_log.py maschine/log/message20261111.txt maschine/log/message20261112.txt
Optional: --ab 20261112  (Zusammenfassung nur fuer Messungen ab diesem Tag; Vollmessungen werden immer gelesen)
"""
import re, sys, os, glob, statistics

# Bekannte Offset-Staende (Zeitstempel ab dem der Wert gilt). Aenderung 11.11.: nach der Vollmessung T3011 09:25:25,
# vor dem Delta T3011 +0,048 um 10:19:00 (OFFSET_LESEN zeigt 49,776 direkt nach 09:25:25).
OFFSET = [("00000000T000000000", 49.828), ("20261111T092600000", 49.776)]
TELESKOP = ["4081", "4083", "4085", "4086", "4088", "4089", "4090", "4093", "4098", "4126"]

RX_ZEIT = re.compile(r"^(\d{8}T\d{9}) --- (.*)$")
RX_VOLL = re.compile(r"^T(\d+) Werkzeugl.nge (-?[\d.]+)mm ermittelt \(erwartet (-?[\d.]+)mm\)")
RX_DELTA = re.compile(r"^T(\d+) Werkzeugdeltal.nge (-?[\d.eE+-]+)mm ermittelt")
RX_GEHOLT = re.compile(r"^T(\d+) wurde aus dem Werkzeugwechsler geholt")
RX_ABGELEGT = re.compile(r"^T\d+ wurde erfolgreich in den Werkzeugwechsler abgelegt")
RX_AUSSER = re.compile(r"^T(\d+) Werkzeug au.erhalb der erwarteten L.nge")
RX_OFFSET = re.compile(r"OFFSET_LESEN: V\.E\.ToolLengthOffset = ([\d.]+)")


def offset_bei(t):
    w = OFFSET[0][1]
    for ab, v in OFFSET:
        if t >= ab:
            w = v
    return w


def dateien(args):
    out = []
    for a in args:
        out += sorted(glob.glob(os.path.join(a, "message*.txt"))) if os.path.isdir(a) else [a]
    return sorted(set(out), key=os.path.basename)


def lesen(pfade):
    ereignisse, aktiv, phase, hinweise = [], None, "holen", []
    for p in pfade:
        for zeile in open(p, encoding="latin-1", errors="replace").read().splitlines():
            m = RX_OFFSET.search(zeile)
            if m:
                hinweise.append(f"{os.path.basename(p)}: OFFSET_LESEN {m.group(1)}")
                continue
            m = RX_ZEIT.match(zeile.strip())
            if not m:
                continue
            t, text = m.groups()
            if RX_GEHOLT.match(text):
                aktiv, phase = RX_GEHOLT.match(text).group(1), "abgabe"
                continue
            if RX_ABGELEGT.match(text):
                phase = "holen"
                continue
            for rx, art in ((RX_VOLL, "voll"), (RX_DELTA, "delta"), (RX_AUSSER, "ausserhalb")):
                mm = rx.match(text)
                if mm:
                    etikett = mm.group(1)
                    wz = aktiv if (phase == "abgabe" and aktiv) else etikett
                    wert = float(mm.group(2)) if art in ("voll", "delta") else None
                    ereignisse.append(dict(t=t, art=art, wz=wz, etikett=etikett, wert=wert,
                                           richtung="ab" if phase == "abgabe" else "an", text=text))
    return ereignisse, hinweise


def z(t):
    return f"{t[6:8]}.{t[4:6]}. {t[9:11]}:{t[11:13]}:{t[13:15]}"


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    ab = next((sys.argv[i + 1] for i, a in enumerate(sys.argv) if a == "--ab"), "00000000")
    pfade = dateien(args)
    if not pfade:
        sys.exit(__doc__)
    ev, hinweise = lesen(pfade)
    print("Dateien:", ", ".join(os.path.basename(p) for p in pfade))
    for h in hinweise:
        print("  ", h)
    print(f"Offset-Stände: " + ", ".join(f"ab {z(a) if a[0] != '0' else 'Beginn'} {v}" for a, v in OFFSET))

    print("\n## Vollmessungen (gespeicherte Länge = MESS.Z − Offset)")
    letzte = {}
    for e in ev:
        if e["art"] != "voll":
            continue
        off = offset_bei(e["t"])
        vor = letzte.get(e["wz"])
        diff = ""
        if vor:
            d = e["wert"] - vor[1]
            soll = off - vor[2]   # Offset kleiner -> Laenge groesser um die Differenz
            diff = f" | gegen {z(vor[0])}: {d:+.3f}" + (f" (Offset-Änderung erwartet {-soll:+.3f})" if abs(soll) > 1e-6 else "")
        print(f"  {z(e['t'])}  T{e['wz']}  L {e['wert']:.4f}  bei Offset {off}{diff}")
        letzte[e["wz"]] = (e["t"], e["wert"], off)

    print(f"\n## Zusammenfassung je Werkzeug (nur Deltas mit Offset {OFFSET[-1][1]} nach der letzten Vollmessung; 'vor dem Fräsen' = beim Holen gemessen)")
    wzs = sorted({e["wz"] for e in ev}, key=lambda w: (w not in TELESKOP, w))
    for w in wzs:
        lv = [e for e in ev if e["wz"] == w and e["art"] == "voll"]
        lt = lv[-1]["t"] if lv else "00000000T000000000"
        aktuell_ab = OFFSET[-1][0]   # nur Kontrollen mit dem aktuellen Offset zaehlen
        ds = [e for e in ev if e["wz"] == w and e["art"] == "delta" and e["t"] > max(lt, aktuell_ab) and e["t"][:8] >= ab]
        an = [e["wert"] for e in ds if e["richtung"] == "an"]
        alle = [e["wert"] for e in ds]
        aktuell = offset_bei(ev[-1]["t"]) if ev else OFFSET[-1][1]
        if lv:
            off_l = offset_bei(lt)
            basis = f"letzte Vollmessung {z(lt)} L {lv[-1]['wert']:.4f} bei Offset {off_l}"
        else:
            off_l = None
            basis = "keine Vollmessung in diesen Logs"
        if alle:
            mw = statistics.mean(alle)
            stat = f"{len(alle)} Deltas, Mittel {mw:+.3f} (min {min(alle):+.3f}, max {max(alle):+.3f}); vor dem Fräsen {len(an)}: " + \
                   (f"Mittel {statistics.mean(an):+.3f}" if an else "–")
        else:
            mw, stat = None, f"keine Kontrolle mit Offset {OFFSET[-1][1]} nach der letzten Vollmessung"
        if mw is None:
            urteil = ("? Länge vom alten Offset, mit dem neuen noch nie angetastet" if off_l is not None and off_l != aktuell
                      else "? ohne Daten" if off_l is None else "OK (vermessen mit aktuellem Offset, noch ohne Kontrolle)")
        elif abs(mw) < 0.02:
            urteil = "OK: gespeicherte Länge passt zum Offset (Delta ≈ 0)"
        elif 0.035 < mw < 0.075:
            urteil = "ALT: gespeicherte Länge vom Offset 49,828 (Delta ≈ +0,05) – Werkzeug schneidet nur richtig, wenn die SPS das Delta verrechnet"
        else:
            urteil = "? Delta auffällig – ansehen"
        mark = "*" if w in TELESKOP else " "
        print(f" {mark}T{w}: {basis}\n      {stat}\n      -> {urteil}")
    print("\n* = Teleskop-Werkzeug. Streuung des Tasters je Messung erfahrungsgemäß ± 0,01.")
    # Laengenaenderung waehrend einer Einspannung: Messung beim Abgeben minus Messung beim Holen (Waerme der Spindel)
    print("\n## Länge nach dem Job minus vor dem Job (je Einspannung; + = Werkzeugspitze tiefer, schneidet tiefer)")
    offen, paare = {}, []
    for e in ev:
        if e["art"] not in ("delta", "voll"):
            continue
        if e["richtung"] == "an":
            offen[e["wz"]] = (e["t"], 0.0 if e["art"] == "voll" else e["wert"])
        elif e["art"] == "delta" and e["wz"] in offen:
            t0, d0 = offen.pop(e["wz"])
            if t0 < OFFSET[-1][0] <= e["t"]:
                continue
            if abs(e["wert"] - d0) <= 0.06:
                paare.append((e["wz"], d0, e["wert"]))
    for w in TELESKOP:
        v = [p for p in paare if p[0] == w]
        if v:
            print(f"  T{w}: n {len(v):2d}  beim Holen {statistics.median([p[1] for p in v])*1000:+5.1f} µm, beim Abgeben "
                  f"{statistics.median([p[2] for p in v])*1000:+5.1f} µm, Änderung Median {statistics.median([p[2]-p[1] for p in v])*1000:+5.1f} µm")
    au = [e for e in ev if e["art"] == "ausserhalb"]
    for e in au:
        print(f"Hinweis {z(e['t'])}: {e['text']}")


if __name__ == "__main__":
    main()
