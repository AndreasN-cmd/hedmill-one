# Eigene NC-Programme und Werkzeuge

Hier ablegen (1:1 kopieren, Kodierung/CRLF nicht ändern):

| Datei | Zweck | Status | Wo aktuell |
|---|---|---|---|
| `LASERCHECK_LESEN.nc` | Schreibt Laser-Fenster, BC_CheckPosOffset, PickBlankOffset, C-Halter-Werte, BlankPos[0..7] und aktuellen Laserwert ins Log (Suchwort LASERCHECK). Nur lesend. | ✅ gelaufen 01.11.2026 | Mac `~/Downloads` |
| `FENSTER3_SETZEN.nc` | Versuch, Laser-Fenster per NC zu ändern – wirkungslos (SPS überschreibt) | ❌ nicht mehr verwenden, nicht übernehmen | Mac `~/Downloads` |
| `MESS_ABS_G58Y_A0_V3.nc` | Messprogramm absolut, korrigiert G58-Y (Soll 5,00) | ✅ gelaufen 07/2026 | suchen |
| `MESS_REL_PLAN_A-90_V3.nc` | Messprogramm relativ, korrigiert G59-Z (Soll 4,50) | ✅ gelaufen 07/2026 | suchen |
| Nullpunktrechner (HTML) | Korrektur neu = alt + (Soll − Ist), Vorzeichen-Umschalter, Rauschwarnung < 0,05 | ✅ | suchen |

To-do: `LASERCHECK_LESEN.nc` um die B-Achsen-Fenster `V.E.BC_CheckPosZLaser0[0..3]` erweitern (offene Frage).
