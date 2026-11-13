# Änderungsprotokoll (Rückweg auf Herstellerstand)

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 13.11.2026 (Grundlage: Export aus dem claude.ai-Projekt „Hedmill Maschine“ vom 09.11.2026)

| Datum | Was | Ort (Datei / Variable / Feld) | Alt | Neu | Getestet |
|---|---|---|---|---|---|
| 07/2026 | G58-Y | Nullpunkttabelle | −0,685 | −0,255 | ✅ Richtung bestätigt 09.11.2026 (zwei Läufe: Ist 4,96 und 5,00 bei Soll 5,024), Rest −0,02 bis −0,06 |
| 07/2026 | G59-Z | Nullpunkttabelle | 0,000 | +0,190 | ✅ Richtung bestätigt 09.11.2026 (Scheibe 4,45/4,46 bei Soll 4,50) |
| 09.11.2026 | G58-Y (drei Läufe Messing, Halter 2, Gummihammer; Auflage im Spannsystem lose eingesetzt) | Nullpunkttabelle | −0,255 | −0,230 | ❓ Kontrolle nach Technikertermin 16./17.11.2026 |
| 09.11.2026 | G59-Z (zwei Läufe, Gesamtlänge mit Bügelmessschraube) | Nullpunkttabelle | +0,190 | +0,209 | ❓ Kontrolle nach Technikertermin 16./17.11.2026 |
| 09.11.2026 | G58-X (MESS_G58_XZ_A0_V1, ein Lauf, Werkzeugkontrolle +0,0005) | Nullpunkttabelle | +0,110 | +0,069 | ❓ kein Bestätigungslauf, erstes echtes Teil ist die Probe |
| 09.11.2026 | G59-X (MESS_G59_XY_A-90_V1, ein Lauf, Werkzeugkontrolle −0,0025) | Nullpunkttabelle | +0,130 | +0,079 | ❓ kein Bestätigungslauf |
| 09.11.2026 | G59-Y (MESS_G59_XY_A-90_V1, ein Lauf) | Nullpunkttabelle | −0,685 | −0,663 | ❓ kein Bestätigungslauf |
| 09.11.2026 | G58-Z bewusst NICHT geändert (gemessen +0,0625, würde alle gedrehten Durchmesser um 0,125 vergrößern) | Nullpunkttabelle | −0,025 | −0,025 | – Gegenprobe T4090 09.11.2026 ebenfalls +0,0625 → Maschine, nicht Werkzeug. Bleibt bis zur Entscheidung zusammen mit den Frässtrategien |
| 11.11.2026 | G54-X (Plättchen MESS_RONDE_G54G55_V1: W2 5,901 / W3 6,143) | Nullpunkttabelle | +0,140 | +0,080 | ❓ erstes Rondenteil ist die Probe |
| 11.11.2026 | G55-X (gleich G54) | Nullpunkttabelle | +0,140 | +0,080 | ❓ |
| 11.11.2026 | **Werkzeug-Längenoffset** (Plättchen Dicke 5,8955 → −0,052; HEDS-Weg) | HMI → BACK / Maschinenparameter, `stToolChange.fToolLengthOffset` (= `V.E.ToolLengthOffset`), „Übertragen in SPS“ | 49,828 | 49,776 | ✅ Kontroll-Tonne D 9,982 (erwartet 9,980) – ⚠️ gilt nur für danach voll vermessene Werkzeuge (T4081, T4090); alle anderen Längen noch alt, Vollmessung aller Werkzeuge steht aus (docs/02, Befund 11.11. abends) |
| 11.11.2026 | G59-Z rechnerisch nachgeführt (Längenoffset −0,052) | Nullpunkttabelle | +0,209 | +0,157 | ✅ Kontroll-Tonne max. Länge 19,495 (Soll 19,500) |
| 11.11.2026 | G54/G55-A geprüft (Plättchen ΔA +0,002°) | Nullpunkttabelle | −0,040 | −0,040 | ✅ keine Änderung nötig |
| 11.11.2026 | G58-Z Rest aus der Kontroll-Tonne (5,000 − 9,982/2 = +0,009); damit Drehfräsen A0 = programmiertes Maß | Nullpunkttabelle | −0,025 | −0,016 | ❓ Fit-Check am nächsten Primärteleskop (Entscheidung Andreas: keine neue Vorlagenversion vorher) |
| 12.11.2026 | Eigene Unterprogramme Warmlauf + Nachmessen CoCr-Primärteleskop (`WARMT4083S18000DYN4`, `WARMT4089S40000DYN5`, `WARMT4126S6000DYN17`, Quelle `eigene-programme/sub/`) | `C:\HMI\NCProg\sub\` (neue Dateien, kein Herstellerprogramm geändert) | – | 3 Dateien | ✅ Test V3 12.11.2026 problemlos; Rückweg: Dateien löschen, dann laufen CAM-Vorlagen ab V5.39 nicht mehr (NC stoppt an der Aufrufzeile) |
| 13.11.2026 | Eigene Unterprogramme Warmlauf + Nachmessen Titan-Primärteleskop CAM V5.41 (`WARMT5053S13000DYN4`, `WARMT5059S35000DYN5`, `WARMT5062S7000DYN18`, Quelle `eigene-programme/sub/`) | `C:\HMI\NCProg\sub\` (neue Dateien, kein Herstellerprogramm geändert) | – | 3 Dateien (Andreas) | ❓ noch nicht gelaufen, erstes Titan-Teleskop ist die Probe; Rückweg: Dateien löschen |
| 13.11.2026 (geplant) | Eigene Unterprogramme für CAM V5.49: „Nur messen“ `MESST4089S40000DYN5G59`, `MESST5059S35000DYN5G59`; Warmlauf `WARMT4083S16000DYN4`, `WARMT5062S15000DYN18`, `WARMT4092S8000DYN18` (Quelle `eigene-programme/sub/`) | `C:\HMI\NCProg\sub\` (neue Dateien, kein Herstellerprogramm geändert) | – | 5 Dateien | ❓ noch nicht kopiert; Test `TEST_NURMESSEN_V4.nc` vor dem ersten V5.49-Teleskop; Rückweg: Dateien löschen und CAM-Vorlagen ohne den Messaufruf bauen |
| 2026 | Endposition B | eigene V3-Programme | B270 | B290 | ✅ |
| 01.11.2026 | Preform-Greifhöhe Wechsler (Plätze + Rundwechsler, Holen + Ablegen) | setVPVars Z. 27, `V.P.ZOffsetPreformC` | −17.7 | −28.2 | ✅ Holen Platz 6 · ⚠️ Ablegen zu tief → 03.11. ersetzt |
| 01.11.2026 | Laser-Fenster Blankhalter Untergrenze | SPS (TwinCAT) `GVL_HEDmillOne.machinePara.stBlankChange.stCheckPosZLaser1[3].MinValue` | 505 | 480 | ✅ Erkennung Platz 7 · ❓ nach Neustart |
| 01.11.2026 | Greifhöhe Rondenhalter Magazin (nur Holen) | getBlankFromChanger Z. 100, `V.L.PosZPickOffset` (Herstellerprogramm!) | 0 | −4 | ✅ Holen Platz 7 · ❓ Ablegen |
| 01.11.2026 | Rundwechsler-Lift: Zeit „Endlage verlassen“ heben | SPS (TwinCAT) `…stBlankChange.stRotaryChanger.stLifter.tEnablePosNotLeaved` | T#0ms | T#8s | ✅ manuell + automatisch · ❓ nach Neustart |
| 01.11.2026 | Rundwechsler-Lift: Zeit „Endlage verlassen“ senken | SPS (TwinCAT) `…stBlankChange.stRotaryChanger.stLifter.tDisablePosNotLeaved` | T#0ms | T#8s | ✅ manuell + automatisch · ❓ nach Neustart |
| 01.11.2026 | Bearbeitungstoleranz hyperDENT-Template | hyperDENT | (bisher gröber) | 0,01 mm (0,005 → Fehler 50120) | ✅ läuft mit Warnung 50121 |
| 03.11.2026 ca. 17:15 | Preform-Greifhöhe Wechsler 2 mm höher (Holen + Ablegen) | setVPVars Z. 27, `V.P.ZOffsetPreformC` (Herstellerstand −17.7) | −28.2 | −26.2 | ❓ Test steht aus |
| zurückgestellt | Vorschlag A: 8-mm-Nachfahren beim Preform-Holen im Wechsler abschalten | getBlankFromChanger Z. 210 + RC-Gegenstück | aktiv | `;` | – nicht umgesetzt |
| zurückgestellt | Vorschlag B: Ablegehöhe Preform = Schließhöhe + Fallweg | giveBlankInChanger `#VAR` + 2 Ablegezeilen | – | `V.L.PosZPlacePreformOffset = 2` | – nicht umgesetzt |
