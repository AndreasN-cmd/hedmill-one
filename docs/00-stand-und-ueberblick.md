# Kurzüberblick: Stand nach dem 03.11.2026

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ⚠️ **G58-Z-Versatz (gemessen 09.11.2026, dauerhaft zu beachten):** Drehfräsen bei A0 kommt 0,125 mm im Durchmesser kleiner als programmiert (T4081 und T4090 gleich → Maschine). G58-Z bleibt bewusst −0,025, weil alle Passungen der Primärteleskope, Abutments und Sekundärteile darauf eingestellt sind. Nicht ändern ohne Andreas' Ansage und ohne neue Frässtrategie-Version (02-koordinaten-nullpunkte.md, CLAUDE.md Regel 9)
- ✅ Nach dem HEDS-Update (30.10.2026) gab es drei Störungen am Blankwechsel – alle am 01.11.2026 selbst behoben:
  1. Preformhalter zu hoch gegriffen → setVPVars `V.P.ZOffsetPreformC` −17.7 → −28.2
  2. Rondenhalter-Laserprüfung M199 → SPS `stCheckPosZLaser1[3].MinValue` 505 → 480; danach Rondenhalter 5 mm zu hoch gegriffen → getBlankFromChanger `V.L.PosZPickOffset` 0 → −4
  3. Rundwechsler-Lift sofort Störung → SPS `stLifter.tEnablePosNotLeaved` / `tDisablePosNotLeaved` 0 ms → 8 s
- ✅ 03.11.2026 Problem: Preformhalter wird beim Ablegen ins Magazin zu tief abgesetzt (Holen ok, Maschine erkennt den Preform korrekt). Beim Öffnen des Greifers „rutscht das zu tief Abgelegte zusammen“ und der Greifer beschädigt das Bauteil. Ziel: Halter soll beim Ablegen 1–3 mm in den Halteradapter fallen
  - ✅ Andreas' Entscheidung 03.11.2026 ca. 17:15: erst mal minimal – `V.P.ZOffsetPreformC` in setVPVars −28.2 → **−26.2** (2 mm nach oben, Holen UND Ablegen wandern gemeinsam); ❓ Test steht aus
  - Falls nötig weiter in 1-mm-Schritten: −25.2, dann −24.2 – dabei beobachten, dass das Holen sicher bleibt (die „gegriffen“-Prüfung M85=1 löst bei Fehlgriff eine Störung aus, keinen Crash)
  - Tiefergehende Änderungen (A: 8-mm-Nachfahren in getBlankFromChanger abschalten, B: eigener Fallweg-Offset in giveBlankInChanger) sind ausgearbeitet, aber **zurückgestellt** – Andreas will nicht so stark in die Herstellerprogramme eingreifen (siehe 11-stoerungen-historie.md)
- ✅ 09.11.2026: Nullpunkte G58/G59 neu kalibriert, fünf Werte eingetragen (G58 X 0,069 / Y −0,230; G59 X 0,079 / Y −0,663 / Z 0,209), G58-Z bewusst unverändert −0,025 (02-koordinaten-nullpunkte.md, 12-aenderungsprotokoll.md). Offen: Gegenprobe G58-Z mit T4090, Schräg-Kalibrierteil (braucht ein hyperDENT-NC mit Anstellung), Kontroll-Lauf nach dem Technikertermin Do 19.11.2026 (lose Auflage im Spannsystem, 11-stoerungen-historie.md), Kontroll-Teleskop zurückgestellt
- ❓ Nach dem Neustart am 01.11.2026 abends prüfen, ob die drei SPS-Werte erhalten geblieben sind (LASERCHECK_LESEN + Lift-Test)
- ✅ Achsdynamik-Warnungen (50120/50121, Achse B) seit dem Update: Andreas klärt das über HEDS, keine eigene Änderung an der CNC-Konfiguration (siehe 21-achsdynamik-50120.md)
- 🔧 Hybrid-Express-Halter kalibrieren: Konzept steht, Rückfragen offen (siehe 22-hybrid-express-halter.md)
- Alle Änderungen mit Rückweg: 12-aenderungsprotokoll.md
