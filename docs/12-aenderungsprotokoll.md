# Änderungsprotokoll (Rückweg auf Herstellerstand)

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

| Datum | Was | Ort (Datei / Variable / Feld) | Alt | Neu | Getestet |
|---|---|---|---|---|---|
| 07/2026 | G58-Y | Nullpunkttabelle | −0,685 | −0,255 | ❓ Wiederholteil offen |
| 07/2026 | G59-Z | Nullpunkttabelle | 0,000 | +0,190 | ❓ Wiederholteil offen |
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
