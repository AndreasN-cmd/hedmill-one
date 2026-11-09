# Offene Fragen

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- Preform-Ablegen 03.11.2026: Reicht −26.2 (Ablegen 50,8)? Holen noch sauber? Falls weiter nach oben: ab welchem Wert wird das Holen zu hoch?
- `maschine/sub/setVPVars` muss −26.2 zeigen (Projektkopie stand noch auf −28.2)
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
- G58-Y / G59-Z: Bestätigung per Wiederholteil
- Antwort von HEDS zu Look-ahead (`interpolator.parameter 200`), CNC 4.34 und Meldung 70222
- Hybrid-Express-Halter: sechs Rückfragen offen (22-hybrid-express-halter.md)
- Herkunft der Schnittwerte T4090 (S8000 / S18500, HL 8) und T4081 (S11500) in 06-werkzeuge-schnittwerte.md: eigene NC-Programme oder alter Stand? (weichen von der Werkzeug-DB ab)
