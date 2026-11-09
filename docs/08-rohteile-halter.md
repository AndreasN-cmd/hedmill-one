# Rohteile & Halter

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ Preform: Tonne Ø11,5 × 20 mm inkl. 4,5 mm Spannlänge; Implantat-Interface positiv Ø4,5 (Zylinder/6kt) außerhalb der 20 mm; Stirnfläche = Schulter = Basic-Bezug bei Y-20,0
- ✅ Prefab-Abutment-Rohteile (CoCr/Titan) Ø11,5 und Ø16 (99 % Ø11,5); Drehfräsen mit hyperDENT-Vorlage „Präfabriziertes Abutment MASTER“ (siehe 20-cam-hyperdent.md)
- ✅ Messing als verschleißfreier Rohling für Relativtests
- ✅ Haltertypen im Einsatz: Rondenhalter (Blankhalter, 30 mm breit), Preformhalter (deutlich niedriger als Rondenhalter), C-Halter; zusätzlich Hybrid-Express-Halter für SLM-Teile (22-hybrid-express-halter.md)
- ✅ Preformhalter sitzen im Magazin in einem Halteradapter (Preformbasis); der Halter kann 1–3 mm in den Adapter fallen, ohne Schaden (Andreas)
- ✅ Haltertyp aus der Artikelnummer (blankChange): erstes Zeichen nach dem Punkt in `V.E.BlankInMachine.Name` / `BlankRequest.Name` (Format 003.40012-1234): Ziffer 1–7 = Blankhalter, 8–9 = Preformhalter, „C“ = C-Halter; sonst Fehler 900 „Artikelnummer … nicht richtig definiert“
- ✅ Der Laser misst beim Rondenhalter auf dem Halter, nicht auf der Ronde (Andreas) → Rondendicke spielt für die Erkennung keine Rolle
- ✅ Ergebniscodes der Laser-Prüfung (`V.E.FunctionValue` → `V.P.BlankPosChecked`): 1 = Blankhalter, 2 = Preformhalter, 3 = leer mit Preformbasis, 4 = leer, 5 = undefinierter Messwert (→ M199 Störung), 6 = C-Halter
  - ✅ Rundwechsler (checkBlankAtPosRC, Induktivsensoren statt Laser): 1 = Blankhalter, 3 = Preformbasis (mit oder ohne Halter – nicht unterscheidbar), 4 = leer; deshalb ist im RC-Zweig von getBlankFromChanger 3 = „Preformhalter soll geholt werden“
- 🌐 HEDS-Halterprogramm: Blank-Klemmringhalter, C-Klemmringhalter, Drehfräshalter Glaskeramik, Drehfräshalter Medentika / One-Step-Teleskop
