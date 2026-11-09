# SPS-Werte ändern mit TwinCAT XAE (erprobt 01.11.2026, dreimal erfolgreich)

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ Ablauf: XAE Shell → Projektsicherung öffnen → Zielsystem `<Local>` → PLC → Login (nur wenn KEINE Rückfrage zu Download / Online Change kommt, sonst Abbrechen) → GVLs → `GVL_HEDmillOne` → Variable aufklappen → Spalte „Vorbereiteter Wert“ → „Werte schreiben“ (Strg+F7, NICHT Forcen F7) → PLC → Logout → ohne Speichern schließen
- ✅ Mehrere vorbereitete Werte werden mit einem Strg+F7 gemeinsam geschrieben
- ✅ Niemals: Activate Configuration, Build, Download, „Login ohne Änderung“
- ✅ Beim Schließen der XAE Shell kann „Schließen des Projekts fehlgeschlagen … Visual Studio will restart now“ kommen → OK, harmlos für die Maschine (nur das Engineering-Programm stürzt ab)
- ✅ TIME-Werte schreibt man als `T#150MS`, `T#8S`
- ✅ Vorgehen bei Störungen: betroffenen Parameterblock mit einem gleichartigen, funktionierenden Block vergleichen (so wurde der Lift-Fehler gefunden)
- ❓ Ob machinePara `VAR_GLOBAL PERSISTENT` ist (Werte überleben Neustart), noch nicht nachgesehen → Test nach Neustart 01.11.2026 abends
