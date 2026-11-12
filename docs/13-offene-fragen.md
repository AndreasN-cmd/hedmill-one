# Offene Fragen

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 11.11.2026. Andreas 11.11.2026: Halternummerierung und Werkzeugkontrolle der Tonne gestrichen; einziger offener Kalibrierpunkt ist das Schräg-Kalibrierteil (irgendwann später, Maschine soll jetzt produzieren). Technikertermin Mo/Di 16./17.11.2026

- Werkzeuglängen 12.11.2026 um +0,022 … +0,048 größer als „alt + 0,052“ (alle Werkzeuge, `docs/02-koordinaten-nullpunkte.md`): Taster/Spindelbezug oder Werkzeug im Halter? Messing-Tonne mit T4126 und T4089 direkt nach einer Vollmessung (auch zur Klärung des Teleskops 12.11., CAM §27) → Programm `eigene-programme/MESS_G58_A0_ENDWZ_V1.nc` liegt bereit
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
- Plättchen (statt Testkreuz) 10.11.2026: Erwartung ΔX ≈ −0,071; Dicke 5,875 = Längenoffset erklärt alles, 6,000 = G58-Z; Längenoffset 49,828 (HMI = SPS, OFFSET_LESEN_V3 11.11.2026); ✅ Variable heißt `V.E.ToolLengthOffset` (aktives measureTool); Historie nach dem Spannzangen-Update; ❓ Vorzeichen ΔA am eigenen Plättchen bestätigen
- G58-X bleibt 0,069 (Andreas 10.11.2026): erstes Teleskop auf Hohlkehle, Rand und MKD-Oberfläche prüfen
- Nullpunkte 09.11.2026: Kontroll-Lauf MESS_REL_PLAN + MESS_ABS nach dem Technikertermin 16./17.11.2026 (Soll 19,50 / 4,50); neue X- und Y-Werte ohne Bestätigungslauf
- G58-Z: +0,0625 mit T4081 und T4090 bestätigt (Maschine). Entscheidung Andreas 10.11.2026: HEDS-Weg – Längenoffset über das Plättchen setzen, G59-Z nachführen, eine Tonne (MESS_REL_PLAN + MESS_G58_XZ) validieren, Rest in G58-Z; Frässtrategie-Version mit Drehfräs-Aufmaßen − Korrektur vor dem ersten Teleskop. Beim Technikertermin 16./17.11.2026 darauf achten, dass Längenoffset und G58-Z nicht unbemerkt geändert werden
- Nach jedem Crash (HEDS: alle Achsen geklemmte Getriebe) neu einmessen: Plättchen → Tonnen. Prüfen, ob die drei SPS-Werte vom 01.11. und der Längenoffset einen Neustart überleben
- Schräge Anstellung unter G59: Kalibrierteil A −65 bis −100 schreiben (braucht echtes hyperDENT-NC mit Anstellung); Vorhersage rund 6 µm je Grad prüfen; mit dem Techniker klären, ob die Steuerung eine Kinematik-Korrektur hat
- `KONTROLL_TELESKOP_V1.nc` einmal fahren (zurückgestellt)
- Lose Auflage im Spannsystem der B-Achse (NSE mini 90-25-V4): Wie hält die feste Auflage (Lippen, Gummischnur, Stift)? Winkelanschlag oder Höhenauflage (Filzstift-Probe)? Neues Teil von HEDS? Danach G58/G59 neu kalibrieren (11-stoerungen-historie.md)
- Wert von `fDeltaValueToolBroken` (SPS): ab welchem Delta meldet die Maschine 301/302/305? (Rest aus dem am 11.11. abends widerlegten Längen-Befund, `docs/06-werkzeuge-schnittwerte.md`)
- ⚠️ **NC 1109-59 mit G54/G55 statt G58/G59 (11.11.2026):** am CAM-PC klären: (1) HF-NC vom 10./11.11. Zeile N120 → G59?; (2) Rohteil und Halter/Spannsystem im hyperDENT-Job 1109-59 gegen HF45; (3) Rohteil-Datensätze 80012 und 80018 (welcher Rohlingstyp, welcher Halter); (4) danach Regel: vor jedem Preform-Start Zeile N120 prüfen. **Gelöst 11.11. abends: Halter One_Step ohne `*HD_HEDS_ZP 3`, Parameter ergänzt (One_Step und Medentika), Kontroll-NC beider Halter G58/G59 (`docs/20-cam-hyperdent.md`).** ✅ Andreas: alle weiteren Halter geprüft; HF-Teleskope werden nicht nachgeprüft. Restlich offen: seit wann er fehlt; neun HF-Teleskope der Nacht 10./11.11. und Abutment AB24 nachprüfen (Kavität 0,43 bzw. 0,41 mm versetzt); Bedeutung des Werts 3 bei HEDS erfragen
- `L ToolDistFactOn` in die Drehfräsjobs der Preform-Strategien aufnehmen (HEDS 11.11.); ob der Faktor 0,085 zur realen Umdrehung passt (Ø 4–8 mm → Umfang 12–25 mm, HEDS rechnet 10 mm), bei HEDS nachfragen
- Fit-Check des nächsten Primärteleskops mit den aktuellen Vorlagen bei Offset 49,776 / G58-Z −0,016 (Andreas 11.11.2026: erst validieren, keine neue Version vorher); Ergebnis in `../fraesstrategien-hyperdent` eintragen
- Wie stark streut die Länge der Prefab-Tonnen (Soll 20,00)? 3–5 Rohlinge messen
- Antwort von HEDS zu Look-ahead (`interpolator.parameter 200`), CNC 4.34 und Meldung 70222
- Hybrid-Express-Halter: sechs Rückfragen offen (22-hybrid-express-halter.md)
- Herkunft der Schnittwerte T4090 (S8000 / S18500, HL 8) und T4081 (S11500) in 06-werkzeuge-schnittwerte.md: eigene NC-Programme oder alter Stand? (weichen von der Werkzeug-DB ab)
- 50120 am MKD: Ursache bestätigt (Konnektor-Austritt des MKD-Rings, 5 von 5 Ereignissen, 21-achsdynamik-50120.md). Offen: fester `bottomoffset` nicht robust (Konnektoraustritt je Teil 1,0 mm hinter bis 2,1 mm vor dem Pol, kurze Teleskope); Andreas 11.11.: Minimum −1 ohne Variante (CoCr Bar Jobs 27, 28, 29); 12 von 16 Programmen damit frei, SA13 behält 1,08 mm Konnektorzone → Nächte beobachten, Ereignisse mit `nc_konnektor_knicke.py` prüfen; HEDS-Mail (`docs/meldung_heds_50120_2026-11-11.md`) abschicken
- MKD-Vorschub: Andreas 11.11.2026 – zwei bis drei Nächte V5.25 mit 5 500 °/min beobachten; ohne 50120/50121 danach Job 25 auf 8 000 (Plan Primärteleskop Punkt 45). Nach den Nächten `skripte/LOGS_SAMMELN.ps1` laufen lassen; bei einer Meldung NC und Satznummer prüfen (`nc_konnektor_knicke.py`)
