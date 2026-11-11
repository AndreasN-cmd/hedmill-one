# CLAUDE.md – HEDmill One Wissensdatenbank (Erhardt NextGen Dental)

Dieses Repo ist die Wissensdatenbank zur 5-Achs-Dentalfräsmaschine **HEDmill One** (Hersteller HEDS / HEDmill GmbH & Co. KG, Steuerung Beckhoff TwinCAT + ISG-CNC) im Labor von Andreas Nusser, Erhardt NextGen Dental, Ulm-Jungingen.
Ziel: **Alles an der Maschine selbst lösen können, ohne Hersteller-Support.**

## Wichtigste Arbeitsregeln
1. **Wissen pflegen:** Jedes neue Detail über die Maschine sofort in die passende Datei unter `docs/` eintragen – unaufgefordert. Änderungen an der Maschine immer zusätzlich in `docs/12-aenderungsprotokoll.md` (Datum, Ort, Alt, Neu, getestet). Stand ganz oben in `docs/00-stand-und-ueberblick.md` aktuell halten, erledigte offene Fragen aus `docs/13-offene-fragen.md` streichen.
2. **Kennzeichnung beibehalten:** ✅ bestätigt · 🌐 öffentliche Quelle/allgemein · ❓ offen oder Annahme (nie als Fakt verwenden).
3. **So wenig wie möglich in Hersteller-Unterprogramme eingreifen.** Bevorzugt Werte in `setVPVars` anpassen (dafür vorgesehene Datei). Programmlogik nur ändern, wenn es nicht anders geht – und nur nach Rückfrage. Änderungen müssen fehlerfrei und rückgängig machbar sein (nichts soll beim Hersteller negativ auffallen).
4. **Kleinster Schritt zuerst:** Erst eine Stellschraube minimal ändern, testen, dann weiter.
5. **Beim Ändern von Maschinendateien:** Kodierung (UTF-8 oder Windows-1252) und Zeilenende CRLF der Originaldatei beibehalten; alter Wert als Kommentar dahinter (`V.P.X = -26.2  ;-28.2 ;-17.7`); in eigenen Kommentaren keine Umlaute.
6. **SPS-Werte** (machinePara) nur per TwinCAT „Werte schreiben“ (Strg+F7) – nie Activate Configuration, Build, Download, Forcen. Ablauf: `docs/04-twincat-sps-werte-aendern.md`.
7. **Achsdynamik / Look-ahead / CNC-Konfiguration:** klärt Andreas über HEDS – hier nichts selbst ändern (`docs/21-achsdynamik-50120.md`).
8. **Maßgeblich ist der Stand auf der Maschine** (`C:\HMI\NCProg\sub\`). Die Kopien in `maschine/` sind Referenz; vor Analysen prüfen, ob sie aktuell sind.

9. **Werkzeug-Längenoffset (HMI `stToolChange` → `fToolLengthOffset`) und G58-Z nie ohne Andreas' ausdrückliche Ansage ändern.** Gemessen 09.11.2026 (T4081 und T4090 gleich): Drehfräsen bei A0 kommt 0,0625 mm im Radius (0,125 mm im Durchmesser) kleiner als programmiert; laut HEDS (10.11.2026) zuerst ein Längenoffset-Fehler, der über das Plättchen/Testkreuz gesetzt wird (Plan in `docs/02-koordinaten-nullpunkte.md`), Rest G58-Z. Alle Primärteleskope und Titan-Abutments werden so drehgefräst, die Passungen (auch der Sekundärteile) sind auf diesen Zustand eingestellt. Eine Korrektur geht nur zusammen mit einer neuen Frässtrategie-Version (`../fraesstrategien-hyperdent/docs/grundsaetze.md`). Gilt auch für Techniker, Hersteller-Update und Neu-Einmessen: Nullpunkttabelle vorher und nachher festhalten (`docs/02-koordinaten-nullpunkte.md`).

## Arbeitsweise mit Andreas
- Antworten auf Deutsch, so kurz wie möglich ohne Details zu verlieren, gerne Stichpunkte.
- Er ist DIY-orientiert, aber kein IT-Profi: Fachbegriffe kurz in Klammern erklären.
- Terminal-/PowerShell-Befehle: jeder Befehl in einem eigenen Codeblock, dazu angeben, wo er eingegeben wird (Mac / Steuerungs-PC).
- NC-Programme direkt als `.nc` liefern (kein ZIP). Dateinamen nur Buchstaben, Ziffern, Bindestrich, Unterstrich (keine Leerzeichen, Kommas, Umlaute).
- Eigene NC-Programme: Programmrahmen und Konventionen aus `docs/03-nc-programmierung.md`; erste Läufe im Einzelsatz mit reduziertem Override.
- Nicht raten: Wenn etwas aus den Unterprogrammen hervorgehen müsste, erst den Code in `maschine/sub/` lesen.

## Wegweiser
| Thema | Datei |
|---|---|
| Aktueller Stand, was gerade läuft | `docs/00-stand-und-ueberblick.md` |
| Maschine, Hersteller, Regeln | `docs/01-maschine-hersteller.md` |
| Nullpunkte G53–G59, Kalibrierung | `docs/02-koordinaten-nullpunkte.md` |
| NC-Dialekt, Variablen, Meldungsnummern, M-Funktionen | `docs/03-nc-programmierung.md` |
| SPS-Werte mit TwinCAT XAE ändern | `docs/04-twincat-sps-werte-aendern.md` |
| Maschinen-Log lesen | `docs/05-maschinen-log.md` |
| Werkzeuge, Schnittwerte | `docs/06-werkzeuge-schnittwerte.md` |
| SPS-Struktur machinePara, Pneumatik-Zylinder | `docs/07-sps-machinepara.md` |
| Rohteile, Haltertypen, Laser-Codes | `docs/08-rohteile-halter.md` |
| Werkstückwechsler, Blankwechsel-Abläufe, Greifhöhen | `docs/09-werkstueckwechsler.md` |
| Pfade am Steuerungs-PC, Unterprogramme, Versionshistorie | `docs/10-unterprogramme-dateien.md` |
| Störungen und Lösungen | `docs/11-stoerungen-historie.md` |
| Änderungsprotokoll (Rückweg) | `docs/12-aenderungsprotokoll.md` |
| Offene Fragen | `docs/13-offene-fragen.md` |
| hyperDENT: Toleranz, HSC, Maschinenseite (Vorlagen selbst: `../fraesstrategien-hyperdent`) | `docs/20-cam-hyperdent.md` |
| Fehler 50120/50121, Look-ahead, TwinCAT-Projekt | `docs/21-achsdynamik-50120.md` |
| Hybrid-Express-Halter (SLM nachfräsen) | `docs/22-hybrid-express-halter.md` |
| Hersteller-Unterprogramme (Kopie) | `maschine/sub/` |
| Eigene NC-Programme | `eigene-programme/` |
| Skripte für den Steuerungs-PC | `skripte/` |

## Nachbar-Repo Frässtrategien
- `../fraesstrategien-hyperdent` (liegt im selben Ordner `claudecode/`): hyperDENT-Vorlagen, Jobs, Schnittwerte, Aufmaße, Werkzeug-DB-Export. Dort gilt die dortige `CLAUDE.md` – vor Arbeit an Frässtrategien zuerst lesen.
- Jede Tatsache hat ein Zuhause: CAM-Wissen dort, Maschine/Steuerung/Wechsler/Störungen hier. Im anderen Repo nur verweisen, nicht doppelt pflegen.
- Die Regeln dieses Repos (Override-Tests, kleinster Schritt, Kennzeichnung ✅ 🌐 ❓) gelten nur hier, nicht für Frässtrategien – und umgekehrt.
- Betrifft eine Erkenntnis beide Seiten (z. B. Toleranz gegen Fehler 50120, Achsgrenzen, Nullpunkte): hier eintragen und im Frässtrategien-Repo in `maschine/hedmill_one_wissensdatenbank.md` verweisen.

## Abgrenzung
- Andere Fräsmaschinen im Labor (Zfx PI5 mit Rexroth-Steuerung, 650i) sind NICHT Thema dieses Repos.
- Andreas' Offset-Software für SLM-Hybridteile und „Erhardt Flow“ (Maschinen-Tracking) sind eigene Repos.
