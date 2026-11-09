# Werkzeuge & Schnittwerte

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- **Schnittwerte und Werkzeugdaten für hyperDENT-Vorlagen stehen im Nachbar-Repo `../fraesstrategien-hyperdent`** (`werkzeuge/`: Export der Werkzeug-DB, `schnittwerte_*.json`; `material/`). Hier nur die Maschinenseite (Wechsler, Laserprüfung, Messtaster, Längenmessung) und Werte aus eigenen NC-Programmen.
- ❓ Die Angaben zu T4090 und T4081 in den nächsten zwei Zeilen weichen von der Werkzeug-DB ab (dort T4090 FS10, in den Vorlagen 20 000 min⁻¹; T4081 12 500 min⁻¹). Vermutlich Werte aus den eigenen Mess-/Kalibrierprogrammen, Herkunft klären
- ✅ T4090 Torus Ø2,0, 3 Schneiden, HL 8 mm (Ti Gr.5 ca. S8000; CoCr S18500)
- ✅ T4081 Vollradius Ø3,0, 4 Schneiden, HL 8 mm (CoCr S11500, Schruppen); Kombination: T4081 schruppt tief, T4090 schlichtet nur die Messfläche
- ✅ T5051 Ø3 FS8 (8 mm Hals) / T5052 Ø3 (13 mm Hals): axiale 3D-Schruppjobs vor der Drehfräs-Kaskade (Prefab-Abutments) – überholt, seit V5.7 seitlich nur T5051, T5052 soll aus der Maschine (`../fraesstrategien-hyperdent/indikationen/abutment/titan-prefab-drehfraesen/grundsaetze.md`)
- ✅ Weitere Werkzeuge im Einsatz laut Log: T4083 (Länge 27,40 mm ermittelt, erwartet 28,5 mm), T4085, T4089
- ✅ Werkzeugwechsler: 28 Plätze in 2 Reihen (1–14, 15–28), Raster 16 mm in X
- ✅ Laser-Werkzeugprüfung: Fräser vorhanden ≈ 520–531, kein Fräser ≈ 702–705 (Ausnahme 01.11.: Platz 14 „kein Fraeser“ mit 564)
- ✅ T9999 / D9999 = 3D-Messtaster; M38 Messtaster ein, M39 aus; vor M6 muss der Taster aus der Spindel (Meldung 135)
- ✅ Werkzeuglänge < 15 mm nach Wechsel → M6 bricht ab (Längenmesswert vermutlich nicht an CNC übertragen)
- ✅ CoCr: Starbond Easy Disc wegen Werkzeugbruch aufgegeben, Vergleich mit Denseo NEM
