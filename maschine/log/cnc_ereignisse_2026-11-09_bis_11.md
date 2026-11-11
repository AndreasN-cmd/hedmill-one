# CNC-Meldungen 50120 / 50121 Achse B, 09.–11.11.2026

Quelle: `C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot\LoggedEvents.db` (Kopie 11.11.2026 11:27), Tabelle `JsonAttributes` je Ereignis. Auswertung: `skripte/loggedevents_dump.py`. Deutung: `docs/21-achsdynamik-50120.md`.
Zeit = Ortszeit; 50121 = Warnung (ab 1,5-fach, kein Stopp), 50120 = Fehler (ab 2,0-fach, Stopp). Grenze B 10 000 °/s². Modul `BAHN_ABL.C` Zeile 11640 (Warnung) / 11348 (Fehler). Jede Warnung kommt als Paar +a / −a innerhalb 1–2 ms.

| Zeit | ID | Programm | Satz N | Istwert °/s² | Vielfaches | Teil im Spannsystem (HMI-Log) |
|---|---|---|---|---|---|---|
| 09.11. 03:54:14 | 50121 | C:\CNC\wp\2033-08__GH17.nc | 5345770 | +17 500 / −17 530 | 1,75 | 107.90018-GH17 |
| 09.11. 05:44:07 | 50121 | 2050-40__GH24.nc | 3933920 | +17 640 / −17 620 | 1,76 | 106.90018-GH24 |
| 09.11. 07:34:27 | 50121 | 2049-11__GH23.nc | 4220510 | +19 840 / −19 810 | 1,98 | 105.90018-GH23 |
| 09.11. 13:21:54 | **50120** | 1042-14__AS22.nc | 2964620 | 51 400 | 5,14 | 107.80012-AS22 (Blankwechsel 13:35) |
| 09.11. 20:47:22 | **50120** | 2012-56__SA21.nc | 4272950 | 58 950 | 5,90 | 120.90018-SA21 (Blankwechsel 22:34) |
| 10.11. 00:04:27 | 50121 | 2016-22__SA22.nc | 3473180 | +37 440 / −37 460 | 3,74 | 122.90018-SA22 |
| 10.11. 11:45:05 | 50121 | 2007-24__SA13.nc | 4616650 | +34 660 / −36 990 | 3,47 / 3,70 | 117.90018-SA13 |
| 10.11. 11:48:02 | 50121 | 2007-24__SA13.nc | 4692170 | +21 560 / −25 590 | 2,16 / 2,56 | 117.90018-SA13 |
| 10.11. 11:50:30 | **50120** | 2007-24__SA13.nc | 4758370 | 53 540 | 5,35 | 117.90018-SA13 (Blankwechsel 11:52) |
| 11.11. 00:17:52 | **50120** | 1041-54__HF46.nc | 4686010 | 57 930 | 5,79 | 106.80018-HF46 (Blankwechsel 00:28, mit LDYN17) |
| 11.11. 09:07:01 | 50121 | 1120-19__HF33.nc | 6109080 | +40 160 / −40 170 | 4,02 | 101.80018-HF33 (mit LDYN17) |

Weitere CNC-Meldungen im Zeitraum: 120206 (Programmende bei aktivem Polynomüberschleifen) 21 ×, 120462 8 ×, 120662 2 ×, 20394 1 × – keine Achsmeldungen außer B.

SA13 im Repo (`maschine/nc-beispiele/2007-24__SA13.nc`): alle drei Sätze sind Konnektor-Austritte des MKD (Y −17,03 / −15,98 / −15,13, Z 1,51–1,52 → Kuppelflanke). Prüfung: `python3 -I skripte/nc_konnektor_knicke.py maschine/nc-beispiele/2007-24__SA13.nc T4126 4616650 4692170 4758370`.
