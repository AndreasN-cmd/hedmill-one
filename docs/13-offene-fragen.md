# Offene Fragen

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- Preform-Ablegen 03.11.2026: Reicht −26.2 (Ablegen 50,8)? Holen noch sauber? Falls weiter nach oben: ab welchem Wert wird das Holen zu hoch?
- B-Achsen-Laserfenster `stCheckPosZLaser0[0..3]` komplett auslesen (LASERCHECK_LESEN um Laser0 erweitern)
- Nach dem Neustart 01.11.2026: Sind die drei SPS-Werte erhalten (LASERCHECK: Fenster 3 min 480; Lift heben/senken ohne Störung)? Falls nicht → machinePara nicht PERSISTENT, Werte nach jedem Neustart neu schreiben bzw. anderen Weg suchen
- Lief die Nachtschicht vom 01./02.11.2026 ohne Störung durch?
- Hat die C-Halter-Prüfung den Rondenhalter auf Platz 7 korrekt als Blankhalter (1) eingeordnet? (Log)
- Ablegen eines Rondenhalters ins Magazin nach der −4-Änderung ok?
- Haben weitere (selten genutzte) Zylinder `…PosNotLeaved = T#0ms`?
- Misst ein Rondenhalter auf Platz 6 ebenfalls ~498?
- Einheit des Laserwerts
- Preform aus dem Rundwechsler mit neuem Wert getestet (nutzt BlankPos[6].Z + ZOffsetPreformC)?
- Platz 7 mit Preform getestet?
- Höhenunterschied Ronden-/Preformhalter
- Was passiert physisch beim 8-mm-Nachfahren nach dem Greiferschließen (Wechsler und B-Achse)?
- Plättchen (statt Testkreuz) 10.11.2026: Erwartung ΔX ≈ −0,071; Dicke 5,875 = Längenoffset erklärt alles, 6,000 = G58-Z; aktueller Längenoffset-Wert ablesen (HMI BACK / Maschinenparameter, `stToolChange` → `fToolLengthOffset`) und notieren; ❓ ist `V.E.ToolOffset` aus measureTool.nc wirklich `fToolLengthOffset` (live prüfen); Historie nach dem Spannzangen-Update; ❓ Vorzeichen ΔA am eigenen Plättchen bestätigen
- G58-X bleibt 0,069 (Andreas 10.11.2026): erstes Teleskop auf Hohlkehle, Rand und MKD-Oberfläche prüfen
- Nullpunkte 09.11.2026: Kontroll-Lauf MESS_REL_PLAN + MESS_ABS nach dem Technikertermin 19.11.2026 (Soll 19,50 / 4,50); neue X- und Y-Werte ohne Bestätigungslauf
- G58-Z: +0,0625 mit T4081 und T4090 bestätigt (Maschine). Entscheidung Andreas 10.11.2026: HEDS-Weg – Längenoffset über das Plättchen setzen, G59-Z nachführen, eine Tonne (MESS_REL_PLAN + MESS_G58_XZ) validieren, Rest in G58-Z; Frässtrategie-Version mit Drehfräs-Aufmaßen − Korrektur vor dem ersten Teleskop. Beim Technikertermin 19.11.2026 darauf achten, dass Längenoffset und G58-Z nicht unbemerkt geändert werden
- Nach jedem Crash (HEDS: alle Achsen geklemmte Getriebe) neu einmessen: Plättchen → Tonnen. Prüfen, ob die drei SPS-Werte vom 01.11. und der Längenoffset einen Neustart überleben
- Schräge Anstellung unter G59: Kalibrierteil A −65 bis −100 schreiben (braucht echtes hyperDENT-NC mit Anstellung); Vorhersage rund 6 µm je Grad prüfen; mit dem Techniker klären, ob die Steuerung eine Kinematik-Korrektur hat
- `KONTROLL_TELESKOP_V1.nc` einmal fahren (zurückgestellt)
- Lose Auflage im Spannsystem der B-Achse (NSE mini 90-25-V4): Wie hält die feste Auflage (Lippen, Gummischnur, Stift)? Winkelanschlag oder Höhenauflage (Filzstift-Probe)? Neues Teil von HEDS? Danach G58/G59 neu kalibrieren (11-stoerungen-historie.md)
- Wie stark streut die Länge der Prefab-Tonnen (Soll 20,00)? 3–5 Rohlinge messen
- Antwort von HEDS zu Look-ahead (`interpolator.parameter 200`), CNC 4.34 und Meldung 70222
- Hybrid-Express-Halter: sechs Rückfragen offen (22-hybrid-express-halter.md)
- Herkunft der Schnittwerte T4090 (S8000 / S18500, HL 8) und T4081 (S11500) in 06-werkzeuge-schnittwerte.md: eigene NC-Programme oder alter Stand? (weichen von der Werkzeug-DB ab)
