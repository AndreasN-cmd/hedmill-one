# Kurzüberblick: Stand nach dem 03.11.2026

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ Nach dem HEDS-Update (30.10.2026) gab es drei Störungen am Blankwechsel – alle am 01.11.2026 selbst behoben:
  1. Preformhalter zu hoch gegriffen → setVPVars `V.P.ZOffsetPreformC` −17.7 → −28.2
  2. Rondenhalter-Laserprüfung M199 → SPS `stCheckPosZLaser1[3].MinValue` 505 → 480; danach Rondenhalter 5 mm zu hoch gegriffen → getBlankFromChanger `V.L.PosZPickOffset` 0 → −4
  3. Rundwechsler-Lift sofort Störung → SPS `stLifter.tEnablePosNotLeaved` / `tDisablePosNotLeaved` 0 ms → 8 s
- ✅ 03.11.2026 Problem: Preformhalter wird beim Ablegen ins Magazin zu tief abgesetzt (Holen ok, Maschine erkennt den Preform korrekt). Beim Öffnen des Greifers „rutscht das zu tief Abgelegte zusammen“ und der Greifer beschädigt das Bauteil. Ziel: Halter soll beim Ablegen 1–3 mm in den Halteradapter fallen
  - ✅ Andreas' Entscheidung 03.11.2026 ca. 17:15: erst mal minimal – `V.P.ZOffsetPreformC` in setVPVars −28.2 → **−26.2** (2 mm nach oben, Holen UND Ablegen wandern gemeinsam); ❓ Test steht aus
  - Falls nötig weiter in 1-mm-Schritten: −25.2, dann −24.2 – dabei beobachten, dass das Holen sicher bleibt (die „gegriffen“-Prüfung M85=1 löst bei Fehlgriff eine Störung aus, keinen Crash)
  - Tiefergehende Änderungen (A: 8-mm-Nachfahren in getBlankFromChanger abschalten, B: eigener Fallweg-Offset in giveBlankInChanger) sind ausgearbeitet, aber **zurückgestellt** – Andreas will nicht so stark in die Herstellerprogramme eingreifen (siehe 11-stoerungen-historie.md)
- ❓ Nach dem Neustart am 01.11.2026 abends prüfen, ob die drei SPS-Werte erhalten geblieben sind (LASERCHECK_LESEN + Lift-Test)
- ✅ Achsdynamik-Warnungen (50120/50121, Achse B) seit dem Update: Andreas klärt das über HEDS, keine eigene Änderung an der CNC-Konfiguration (siehe 21-achsdynamik-50120.md)
- 🔧 Hybrid-Express-Halter kalibrieren: Konzept steht, Rückfragen offen (siehe 22-hybrid-express-halter.md)
- Alle Änderungen mit Rückweg: 12-aenderungsprotokoll.md
