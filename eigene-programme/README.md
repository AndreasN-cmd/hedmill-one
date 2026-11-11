# Eigene NC-Programme und Werkzeuge

Hier ablegen (1:1 kopieren, Kodierung/CRLF nicht ändern):

| Datei | Zweck | Status | Wo aktuell |
|---|---|---|---|
| `LASERCHECK_LESEN.nc` | Schreibt Laser-Fenster, BC_CheckPosOffset, PickBlankOffset, C-Halter-Werte, BlankPos[0..7] und aktuellen Laserwert ins Log (Suchwort LASERCHECK). Nur lesend. | ✅ gelaufen 01.11.2026 | Mac `~/Downloads` |
| `FENSTER3_SETZEN.nc` | Versuch, Laser-Fenster per NC zu ändern – wirkungslos (SPS überschreibt) | ❌ nicht mehr verwenden, nicht übernehmen | Mac `~/Downloads` |
| `MESS_ABS_G58Y_A0_V3.nc` | Messprogramm absolut, korrigiert G58-Y (Soll 5,00; Tonnenlänge vorher messen) | ✅ gelaufen 07/2026, geprüft 09.11.2026 | hier (Kopie aus Mac `~/Downloads`) |
| `MESS_REL_PLAN_A-90_V3.nc` | Messprogramm relativ, korrigiert G59-Z (Soll 4,50; nur Ø11,5, Interface ≤ 3,0 mm) | ✅ gelaufen 07/2026, geprüft 09.11.2026 | hier (Kopie aus Mac `~/Downloads`) |
| `Versatz_Rechner-2von2.html` | Nullpunktrechner: neu = alt + (Soll − Ist), Vorzeichen-Umschalter, Rauschwarnung < 0,05 | ✅ nachgerechnet 09.11.2026 | hier (Kopie aus Mac `~/Downloads`) |
| `MESS_G58_XZ_A0_V1.nc` | Messprogramm radial A0: Rund Ø10,000 mit der Kugelspitze, lange Fläche (Flanke X−) und kurze Fläche (Flanke X+, B+90). Korrigiert G58-X und G58-Z. T4081, Messing Ø11,5, Bügelmessschraube | ✅ gelaufen 09.11.2026 (Werkzeugkontrolle +0,0005) | hier |
| `MESS_G59_XY_A-90_V1.nc` | Messprogramm radial A-90: Rund Ø10,500 mit der Flanke, Flächen 5 mm (X−), 3 mm (Y−), 4 mm (X+, B+135). Korrigiert G59-X und G59-Y. T4081, Messing Ø11,5, Bügelmessschraube | ✅ gelaufen 09.11.2026 (Werkzeugkontrolle −0,0025) | hier |
| `MESS_G58_Z_T4090_V1.nc` | Gegenprobe G58-Z mit zweitem Werkzeug: Band Ø9,600 mit der Stirn des Torus T4090 (Z4,8, Y−22→−16). Abweichung Z = 4,800 − D/2, Vergleich mit T4081 (+0,0625) | ✅ gelaufen 09.11.2026 (D 9,475 → +0,0625, wie T4081) | hier |
| `KONTROLL_TELESKOP_V1.nc` | Kontrollteil für zwischendurch: Hohlzylinder Ø10/Ø8, Wand 1,000. Bohrung bei A-90 mit stehendem B (G59), außen bei A0 gedreht (G58), Marke tief bei X+, flach bei Y+. T4081, Messing ohne Interface. G59-X neu = alt + (W1 − W2)/2, G59-Y neu = alt + (W3 − W4)/2, mittlere Wand = D/2 − 4,000 | ❓ neu 09.11.2026, simuliert (kein Eingriff in Eilgang und Zustellung, Schaft frei, Wand 1,000, Formeln mit künstlichem Versatz bestätigt), noch nicht gelaufen, zurückgestellt (Andreas 09.11.2026) | hier |
| `IBN_Testkreuz_T3011_T3012.nc` | Hersteller-Testkreuz mit Andreas' Werkzeugnummern (T3011 = Kugel Ø3, T3012 = Kugel Ø2); sonst byteidentisch zu `maschine/sub/IBN_Testkreuz.nc`. PMMA 16 mm, 40 min, G54/G55 | ❓ 10.11.2026 vorbereitet, noch nicht gelaufen | hier |
| `Versatz_Rechner_eigen_V1.html` | Eigener Nullpunktrechner für die eigenen Programme: Reiter Plättchen (W1–W4, T1–T4 → G54/G55-X, A, Werkzeug-Längenoffset, Folgewert G59-Z, erwarteter Tonnen-Ø) und Reiter Tonnen (MESS_REL_PLAN, MESS_ABS, MESS_G58_XZ, MESS_G59_XY, T4090). Regel neu = alt + (Soll − Ist). Offline, eine Datei | ✅ 10.11.2026 mit den Messwerten vom 09.11. nachgerechnet (Node-Test) | hier; auf den CAM-PC kopieren |
| `MESS_RONDE_G54G55_V1.nc` | Eigenes Messplättchen statt HEDS-Testkreuz: PMMA 98 × 16, nur T3011, ≈ 12 min, G54/G55 mit einem Wenden. Vier Zungen (Referenz, Flip, Revers, Referenz), Loch markiert Y+. ΔX = (W2 − W3)/4, ΔZ = (6 − Mittel T)/2, ΔA aus T1 − T4 | ❓ 10.11.2026 simuliert (Geometrie, Versatzformeln, Werkzeugtiefe 14,5), noch nicht gelaufen | hier |

To-do: `LASERCHECK_LESEN.nc` um die B-Achsen-Fenster `V.E.BC_CheckPosZLaser0[0..3]` erweitern (offene Frage).
