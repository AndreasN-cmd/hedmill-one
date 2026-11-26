# Maschinen-Logs (Kopie von `C:\HMI\log\`)

Dateien `message<JJJJMMTT>.txt` (Windows-1252, CRLF) bei Bedarf hier ablegen – z. B. zu jeder Störung den Log des Tages.
Vorhanden auf dem Mac: `~/Downloads/message20261101.txt` (Tag der drei Wechsler-Reparaturen).

Optional: TwinCAT-Ereignisprotokoll `C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot\LoggedEvents.db` (SQLite) für CNC-Meldungen wie 50120.
Lesen/Auswerten: siehe `docs/05-maschinen-log.md`.

11.11.2026: `message20261109.txt` bis `message20261111.txt` (Nächte mit 50120 am MKD) und `cnc_ereignisse_2026-11-09_bis_11.md` (alle 50120/50121 aus LoggedEvents.db mit Programm und Satznummer). Die LoggedEvents.db selbst (15 MB) liegt in `~/Downloads/HEDmill-Logs-2026-11-11_1127/`, nicht im Repo.

24.11.2026: `message20261122.txt` bis `message20261124.txt` (elf Primärteleskope CAM V5.74 mit Warmlauf, zweiter MKD; Auswertung `docs/23-waerme-z-kette.md` Abschnitt 3a). Die LoggedEvents.db dazu liegt in `~/Downloads/HEDmill-Logs-2026-11-24_2112/`, nicht im Repo.

25.11.2026: `message20261124.txt` (jetzt der ganze Tag) und `message20261125.txt` bis 11:44 (die ersten drei Primärteleskope CAM V5.77: MG22, MG25, MG23; Auswertung `docs/23-waerme-z-kette.md` Abschnitt 3b). Die LoggedEvents.db dazu liegt in `~/Downloads/HEDmill-Logs-2026-11-25_1148/`, nicht im Repo.

26.11.2026: `message20261125.txt` (jetzt der ganze Tag) und `message20261126.txt` bis 17:18 (sechs Primärteleskope CAM V5.79: AP43, AP34, AP37, AP44, GA17, GA21; fünf Titan-Abutments CAM V5.75; zwei Jobs ohne Rohling am Wechslerplatz; Auswertung `docs/23-waerme-z-kette.md` Abschnitt 3c, `docs/21-achsdynamik-50120.md`, `docs/11-stoerungen-historie.md`). Die LoggedEvents.db dazu liegt in `~/Downloads/HEDmill-Logs-2026-11-26_1719/`, nicht im Repo.
