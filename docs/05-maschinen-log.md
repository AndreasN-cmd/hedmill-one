# Maschinen-Log

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ Pfad: `C:\HMI\log\message<YYYYMMDD>.txt` (eine Datei pro Tag), Kodierung Windows-1252/ISO-8859, CRLF
- ✅ Zeitstempel-Format: `20261101T182843250` (JJJJMMTT T hhmmss + ms)
- ✅ Enthält u. a.: Laser-Prüfungen mit Messwert und Fenster, Werkzeugprüfung („ist ein / kein Fraeser“), Werkzeuglängen, Warmlaufprogramm, Blankwechsel-Schritte, aufgerufene HMI-Programme
- ✅ HMI-Programme für Blankwechsel: `GetPreFormPos6`, `GetBlankPos0`, `GetBlankPos7` → rufen BlankChange auf
- ✅ Log-Zeilen eines Blankwechsels (Reihenfolge): „BlankChange wurde aufgerufen“ → „Im Spannsystem ist ein Preformhalter/Blankhalter/C-Halter. Messwert = …“ bzw. „Das Spannsystem ist LEER“ (checkBlankInB) → Platzprüfung „Auf Position n ist … / Position n ist LEER / nur die Preformbasis“ → „Blank '…' aus B-Achse geholt“ → „Blankhalter erfolgreich im Wechlser abgelegt. Pos n“ (Laserkontrolle ok) bzw. „Beim Ablegen Pos n ist ein Fehler aufgetreten, Blankhalter eventuell noch in der Maschine!“ (→ M199) → ggf. Holen „Blank '…' aus Wechslerposition n geholt“ → „Blank '…' im B-Achsennullpunktspannsystem abgesetzt“ → „Blankhalter erfolgreich im Nullpunktspannsystem abgelegt“ → „BlankChange wurde abgearbeitet“
- ✅ Warmlaufprogramm: 4 Teile (Soll 120/60/120/120 s), gesamt ca. 441 s
- ✅ Kopie des Logs vom 01.11.2026 liegt auf dem Mac in ~/Downloads/message20261101.txt
- ✅ TwinCAT-Ereignisprotokoll (CNC-Meldungen wie 50120): `C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot\LoggedEvents.db` (SQLite, Zeit = Windows-FILETIME UTC), siehe 21-achsdynamik-50120.md
- ✅ 3Pins.nc schreibt Messergebnisse nach `C:\PINresult\PINresult.txt`
- ✅ 11.11.2026: `skripte/LOGS_SAMMELN.ps1` (nur lesend, am Steuerungs-PC) sammelt LoggedEvents.db (+ -wal/-shm), HMI-Logs der letzten 3 Tage, die 12 zuletzt geänderten NC aus `C:\CNC\wp`, diag_data-Dateien und alle DYN-Sätze in einen Desktop-Ordner `HEDmill-Logs-<Datum>` (mit UEBERSICHT.txt). Am Mac: `python3 -I skripte/loggedevents_dump.py <LoggedEvents.db> [Suchbegriff]` listet Tabellen und alle Zeilen mit 50120/50121, FILETIME → Ortszeit
- ✅ 12.11.2026: `skripte/werkzeuglaengen_log.py` (am Mac, nur lesend): liest `message*.txt` (Ordner von LOGS_SAMMELN oder einzelne Dateien), listet alle Vollmessungen („Werkzeuglänge … ermittelt“, mit Offset-Stand und Differenz zur vorigen Vollmessung, nach der Offset-Änderung 11.11. erwartet +0,052) und je Werkzeug die Kontrollen („Werkzeugdeltalänge“) mit dem aktuellen Offset: Delta ≈ 0 = gespeicherte Länge passt, ≈ +0,05 = Länge vom alten Offset. Ordnet die Messung des abgehenden Werkzeugs (trägt im Log die Nummer des neuen) richtig zu. Aufruf: `python3 -I skripte/werkzeuglaengen_log.py <Ordner oder Dateien> [--ab JJJJMMTT]`
