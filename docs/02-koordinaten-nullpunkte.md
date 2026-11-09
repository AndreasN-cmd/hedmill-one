# Koordinatensysteme / Nullpunkte

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ G53 = Maschinenkoordinaten; Z+ = oben (Z hoch = `V.A.+SWE.Z-1`, positiver Software-Endschalter − 1)
- ✅ G54 (B0) / G55 (B180): Ronden auf A0, Testkreuz-kompensiert, 5-Achs-simultan fehlerfrei; Y in G54 und G55 muss gleich sein (verschiebt nur das Nesting)
- ✅ G58: Drehfräsen über B-Achse bei A0, Teilachse entlang Y, Y0 = hinterer Anschlag in der Aufnahme
- ✅ G59: Fräsen auf A-90, Teilachse entlang Z, gleiche Anschlag-Logik
- ✅ hyperDENT-Postprozessor setzt G58/G59 automatisch
- ✅ Wechselroutinen fahren in Maschinenkoordinaten (`#MCS ON EX TOOL`), Nullpunkte G54–G59 beeinflussen sie nicht
- 🌐 `#MCS ON` blendet alle Verschiebungen, Transformationen und Werkzeugkorrekturen aus (Maschinenachsen werden direkt positioniert); `EX TOOL` bedeutet: auch ein Werkzeugwechsel innerhalb des MCS rechnet keine Werkzeugversätze ein, das passiert erst bei `#MCS OFF` (Beckhoff-Doku TF5200). → Die Z-Werte der Wechselroutinen sind reine Achspositionen, unabhängig vom Werkzeug in der Spindel
- ✅ Software-Endschalter in start_init.nc (auskommentiert): X −145…71, Y −236…112, Z −18…138, A −100…37; in der SPS liegen sie unter machinePara.stCNC.stAxis.<Achse>.fLimitSwitchNeg/Pos
- ✅ Kalibrierung Juli 2026: Hersteller-IBN hatte den axialen Bezug nie gemessen (G58-Y stammte aus der radialen A-90-Messung → ca. 0,5 mm Axialversatz; Aufbau zu nah am Implantatbereich, Topf-Deckel 0,5 statt 1,0 mm)
  - G58 alt X 0,110 / Y −0,685 / Z −0,025 → Y neu −0,255 (Messung absolut: Ist 4,57, Soll 5,00)
  - G59 alt X 0,130 / Y −0,685 / Z 0,000 → Z neu +0,190 (Messung relativ: Ist 4,31, Soll 4,50)
  - ❓ Bestätigung per Wiederholteil stand zuletzt noch aus
- ✅ Korrekturformel: neu = alt + (Soll − Ist); Vorzeichenkonvention der Beckhoff-Tabelle per Wiederholteil bestätigen; Abweichung < 0,05 mm = Messschieber-Rauschen, nicht korrigieren
- ✅ Messprogramme (eigene, erfolgreich gelaufen):
  - MESS_ABS_G58Y_A0_V3.nc (A0/G58): Nut Ø6,6 Grund, ~9 mm breit (Y-15…Y-6), Schulter geschlichtet auf Y-15,000; Messschieber außen Stirnfläche→Schulter, Soll fest 5,00 → korrigiert G58-Y
  - MESS_REL_PLAN_A-90_V3.nc (A-90/G59): Interface + 0,5 mm der Tonne plan wegfräsen, dann MESS_ABS in derselben Aufspannung, Soll fest 4,50 → korrigiert G59-Z (nie G58-Y!)
  - HTML-Nullpunktrechner (CI-Farben Erhardt, Nullpunktfelder leer, Sollmaße 5,00/4,50 als Platzhalter, Vorzeichen-Umschalter, Rauschwarnung)
- ✅ G54/G55-Y ist für Ronden funktional unkritisch (verschiebt nur das Nesting), muss aber in beiden gleich sein
