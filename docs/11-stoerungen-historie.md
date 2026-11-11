# Störungen & Historie

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- 07/2026: Fehler ID 70020 „Dynamischer Schleppabstand zu groß“
- 07/2026: Nullpunkt-Kalibrierung G58/G59 (02-koordinaten-nullpunkte.md)
- Lose Auflage im Nullpunktspannsystem der B-Achse (Schunk) – **OFFEN**, erfasst 09.11.2026
  - ✅ Seit einem früheren Crash sitzt eine der beiden Auflagen (Andreas: „Auflagemulde“ / „Backe“) lose im Spannsystem und fällt sehr häufig heraus (Andreas)
  - ✅ Aussage Hersteller: in Ordnung, einfach wieder einsetzen (Andreas)
  - ✅ Nullpunkte G58/G59 wurden 07/2026 MIT der Auflage kalibriert; in der Woche vor dem 09.11.2026 wurde OHNE sie gefräst (Andreas)
  - ❓ Vermutung Andreas: daher kommt eine kleine Abweichung der Nullpunkte. Plausibel (Halter liegt ohne Auflage anders auf), Größe nicht gemessen
  - ✅ Spannsystem laut Gravur: SCHUNK VERO-S NSE mini 90-25-V4, Pmax 6 bar (Andreas, Foto 09.11.2026)
  - 🌐 V4 = vier Verdrehsicherungsnuten im 90°-Raster in der Stirnfläche (Schunk-Produktseite); die Höhe bestimmt bei VERO-S die Planfläche des Moduls, die Lage der Spannbolzen
  - ✅ Foto: in den Nuten bei 3 und 9 Uhr sitzen die beiden Auflagen, in den Nuten bei 12 und 6 Uhr je eine Schraube. Die Auflage ist ein kleiner Block mit Grundplatte, halbrunder Mulde (läuft radial) und zwei Längsbohrungen neben der Mulde, jede mit einem Schlitz zur Außenseite (federnde Lippen)
  - ✅ Befund Andreas 09.11.2026: kein Gewinde, keine Bohrung zum Schrauben, keine Klebstoffreste, kein Spiel, kippelt nicht, lässt sich bis zum Anschlag einsetzen – bleibt aber nicht fest. Zweite Auflage baugleich und fest
  - ❓ Deutung (Foto, nicht bestätigt): Die Auflage klemmt sich über die geschlitzten Lippen selbst in der Nut. Auf dem Foto ist ein Schlitz deutlich weiter und die Lippe unregelmäßig (verbogen oder ausgebrochen), in der anderen Bohrung hängt ein schwarzer Rest (Gummi oder Span). Dann fehlt nach dem Crash die Vorspannung → neues Teil ist die saubere Reparatur
  - ❓ Deutung Funktion: sitzt in der Verdrehsicherungsnut → vermutlich Winkelanschlag für einen Querstift am Halter, nicht Höhenauflage. Dann würde eine fehlende Auflage den Winkel und die Steifigkeit um B betreffen, nicht direkt G58-Y. Prüfen mit Filzstift-Probe (Mulde und Planfläche anmalen, Halter spannen, Abrieb ansehen)
  - ✅ Entscheidung Andreas 09.11.2026 (ersetzt „erst befestigen“): nicht kleben, Auflage lose einsetzen und so kalibrieren; der Maschinentechniker kommt am Mo/Di 16./17.11.2026 und soll die Auflage befestigen. Nach der Befestigung ein MESS_ABS-Lauf zur Kontrolle
  - ⚠️ Für den Technikertermin 16./17.11.2026: Nullpunkttabelle vorher und nachher abschreiben. G58-Z nicht ohne Absprache ändern lassen (02-koordinaten-nullpunkte.md); die übrigen fünf Werte sind am 09.11.2026 neu eingemessen
  - Vorschlag (nicht umgesetzt): 1. zwei neue Auflagen bei HEDS bestellen (vermutlich HEDS-Teil, kein Schunk-Normteil). 2. Falls geklebt wird: Auflage trocken einsetzen, mit gespanntem Halter auf Anschlag halten, erst dann kapillaren Klebstoff (Loctite 290) sparsam an die Fuge der Langseiten – so kann sie nicht höher sitzen. Schlitze, Bohrungen und Mulde frei lassen, nichts Richtung Mittelbohrung. 24 h aushärten, danach kalibrieren
- 30.10.2026: HEDS-Update (Sicherung der Unterprogramme in `old20261030\`, TwinCAT-Projektsicherung von Freitag); danach drei Störungen am Blankwechsel (siehe unten) und Achsdynamik-Warnungen (21-achsdynamik-50120.md)
- 11/2026: Preformhalter wurde beim Blankwechsel zu hoch gegriffen → Automatisierung blockiert
  - ✅ GELÖST 01.11.2026: V.P.ZOffsetPreformC in setVPVars −17.7 → −28.2 (Schließpunkt und Holen-Position je 10,5 mm tiefer)
  - ✅ Log 01.11.2026, 18:19–18:28: Preform Platz 6 dreimal geholt, in B-Achse abgesetzt, aus B-Achse geholt und wieder in Platz 6 abgelegt – kompletter Zyklus erfolgreich
  - ⚠️ Nebenwirkung: Ablegehöhe Preform im Magazin ist dadurch ebenfalls 10,5 mm tiefer (59,3 → 48,8)
- 11/2026: Laser-Prüfung: Rondenhalter Platz 7 misst 498, Fenster [3] war 505–545 → „undefinierter Wert“ → M199
  - ✅ Versuch per NC (FENSTER3_SETZEN.nc): ohne Wirkung
  - ✅ GELÖST 01.11.2026 ca. 19:25: in TwinCAT `machinePara.stBlankChange.stCheckPosZLaser1[3].MinValue` 505 → 480 per „Werte schreiben“; danach kein M199 mehr bei GetBlankPos7
- 11/2026: Rondenhalter Platz 7 wurde nach Erkennung ca. 5 mm zu hoch gegriffen
  - ✅ GELÖST 01.11.2026 ca. 19:50: `V.L.PosZPickOffset` in getBlankFromChanger Z. 100: 0 → −4; Andreas zufrieden
  - Bewusst nicht BlankPos[7].Z in der SPS geändert: hätte auch Preforms auf Platz 7 verschoben
- 11/2026: Rundwechsler-Lift (Blankhubzylinder unten, M92 heben) – manuell und automatisch sofort Störung „Hubzylinder oben nicht angekommen“, Zylinder fuhr gar nicht los, Störung ohne Wartezeit
  - ✅ Ursache: neue Parameter `stLifter.tEnablePosNotLeaved` / `tDisablePosNotLeaved` standen auf T#0ms (funktionierender Greifer-Hubzylinder: T#8s)
  - ✅ GELÖST 01.11.2026 ca. 20:10: beide per TwinCAT „Werte schreiben“ auf T#8S; Lift läuft wieder
- 01.11.2026 ca. 20:15: Maschinenneustart, danach Nachtschicht-Fräsung
- 01.11.2026 abends: Störung 50120 / Warnung 50121 Achse B bei Toleranz 0,005 / 0,01 mm (21-achsdynamik-50120.md); 02.11.2026 Entscheidung: Klärung über HEDS, Mail-Entwurf (Varianten „Nur Symptome“ / „Mit Befund“) erstellt
- 03.11.2026: Preformhalter wird beim Ablegen ins Magazin **zu tief** abgesetzt; beim Öffnen des Greifers rutscht der zu tief abgelegte Halter zusammen und der Greifer beschädigt das Bauteil. Holen ok, Preform wird korrekt erkannt (Andreas) – **IN ARBEIT**
  - ✅ Code-Befund: Ablegehöhe = Holen-Position = 8 mm unter der Schließhöhe. Beim Holen schließt der Greifer bei Holen-Position + 8 und fährt dann geschlossen 8 mm nach unten (`ZOffsetGetPreform`); beim Ablegen gibt es diese 8 mm nicht
  - ✅ Andreas' Ziel: Halter soll beim Ablegen 1–3 mm in den Halteradapter fallen; das 8-mm-Nachfahren gefällt ihm nicht
  - ✅ `ZOffsetGetPreform` in setVPVars NICHT ändern (wirkt auch auf getBlankFromB, B-Achse funktioniert); ebenso nicht BlankPos.Z, PickBlankOffset
  - ✅ **Schritt 1 (umgesetzt 03.11.2026 ca. 17:15):** `V.P.ZOffsetPreformC` −28.2 → **−26.2** in setVPVars Z. 27 → Schließhöhe 58,8, Holen-Position 50,8, Ablegehöhe 50,8 (alles 2 mm höher, Holen und Ablegen gekoppelt). ❓ Test steht aus; bei Bedarf in 1-mm-Schritten weiter nach oben (−25.2, −24.2)
  - ❓ **Zurückgestellt** (zu starker Eingriff in die Herstellerprogramme, nur falls Holen zu hoch wird, bevor das Ablegen passt):
    - Änderung A (getBlankFromChanger): die zwei Zeilen „auf Holen-Position fahren“ (Magazin `G01 Z= V.L.PickPosZ + V.P.ZOffsetPreformC`, Rundwechsler `G01 Z= V.L.PickPos6Z + V.P.ZOffsetPreformC`) mit `;` auskommentieren → kein 8-mm-Nachfahren
    - Änderung B (giveBlankInChanger): `#VAR` `V.L.PosZPlacePreformOffset = 2`; beide Preform-Ablegezeilen auf `… + V.P.ZOffsetPreformC + V.P.ZOffsetGetPreform + V.L.PosZPlacePreformOffset FV.E.FEEDMEASURE` → Ablegen = Schließhöhe + Fallweg, unabhängig vom Holen
    - Testidee dazu: erst nur B; fällt der Halter ~2 mm → Nachfahren verschiebt nichts; fällt er ~10 mm → Greifer rutscht beim Nachfahren wirklich 8 mm am Halter
  - Alle Dateien: Kodierung/CRLF beibehalten; setVPVars-Änderung wirkt ab dem nächsten Programmstart
- 05.11.2026: Hybrid-Express-Halter – Kalibrierkonzept erstellt (22-hybrid-express-halter.md)
