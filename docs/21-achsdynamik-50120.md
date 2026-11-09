# Achsdynamik: Störung 50120 / Warnung 50121 Achse B, Look-ahead, TwinCAT-Projekt

> Kennzeichnung: ✅ bestätigt · 🌐 Beckhoff-Doku / allgemein · ❓ offen oder Annahme
> Stand: 09.11.2026

## Entscheidung
- ✅ **02.11.2026, 00:00: Andreas klärt Achsdynamik / Look-ahead / CNC 4.34 über den Hersteller (HEDS)** – keine eigene Änderung an der CNC-Konfiguration
- ✅ Mail-Entwurf an HEDS in zwei Varianten erstellt: „Nur Symptome melden“ / „Mit Befund“ (Betreff: „HEDmill One – Beschleunigungsmeldungen Achse B seit Update V1.0.12 (30.10.2026)“); Inhalt „Mit Befund“: CNC 4.30 → 4.34, neue Zeile `interpolator.parameter 200` unter `number_blocks_lah 500`, Achsdynamik/Filter/Kanal unverändert, Meldung 70222 seit Update; Bitte um Fernwartungstermin (Maschine läuft nachts)
- ✅ Hinweis dazu: Die drei Wechsler-Korrekturen vom 01.11.2026 (v. a. Hubzylinder 0 ms → 8 s) gehen beim nächsten Update evtl. verloren, wenn HEDS nichts davon weiß – ob mitmelden, entscheidet Andreas
- ❓ Antwort von HEDS steht aus
- ✅ Bis zur Klärung: mit 0,01 mm fräsen und beobachten
- ✅ Regel: NICHT das Archiv von vor dem Update aktivieren (würde SPS, Meldungen, VE-Variablen und HEDS-Änderungen zurückdrehen)

## Fehlerbild
- ✅ Beckhoff: maximale Achsbeschleunigung (P-AXIS-00008) über Fehlerschwelle (P-AXIS-00442) → 50120, Stopp Klasse 6; über Warnschwelle (P-AXIS-00441) → 50121, kein Stopp
- ✅ Verwandte IDs: 50118 / 50119 Geschwindigkeit, 50123 Ruck, 51069 Singularität, 110498 Warnfaktor > Fehlerfaktor, 50612 Look-ahead-Satzanzahl zu groß (Steuerung korrigiert)
- ✅ Stelle 50120: Programm `C:\CNC\wp\1714-22__26_SA_5.nc`; Satznummer laut Ereignisprotokoll N2848140 (Andreas hatte N24848140 abgelesen – ❓ Tippfehler?); Satz `Y-23.07982 Z5.57765 B235.12500`, davor `Z5.57759 B235.0000` → B dreht 0,125°, Z fast nichts
- ✅ Das Problem gab es vor langer Zeit schon einmal; damals hat Beckhoff es mit einem Update gelöst; Andreas hat seitdem nichts daran verändert
- ✅ **Vor dem HEDS-Update (30.10.2026) kam mit 0,01 mm KEINE Warnung, jetzt schon** (Andreas)

## Messwerte aus dem TwinCAT-Ereignisprotokoll (LoggedEvents.db, 07.10.–01.11.2026)
- ✅ 50120 / 50121 vor dem 01.11.2026 kein einziges Mal im Protokoll
- ✅ 01.11. 21:34:06 – 50120, logische Achse 5 (= B), Sollbeschleunigung 37 500 °/s², Maximum 10 000 °/s² → Verhältnis 3,75 (Fehler ab 2,0)
- ✅ 01.11. 21:55:29 – 2 × 50121, Achse B, 18 210 / −18 270 °/s² → Verhältnis 1,82 / 1,83 (Warnung ab 1,5), Programm `C:\CNC\wp\2146-36__26_SA_5.nc`, Satz N106270
- ✅ Daraus: maximale Achsbeschleunigung B (P-AXIS-00008) = 10 000 °/s²; Warnschwelle 1,5 und Fehlerschwelle 2,0 = Beckhoff-Standard
- ✅ **CNC-Software-Version vor dem Update 4.30.0-x64, seit 30.10.2026 08:46 4.34.0-x64** → das HEDS-Update hat auch den Beckhoff-CNC-Kern erneuert (TwinCAT selbst unverändert 3.1.4026.17)
- ✅ Seit dem Update bei jedem TwinCAT-Start neue Meldung 70222 (TcCnc.PosCtrl, Modul LR_CANOP.C) für die logischen Achsen 1–5, Wert 40 bzw. 47; vorher nie → ❓ Bedeutung noch nicht nachgeschlagen (mit HEDS klären)
- ✅ Bei jedem Start (vor und nach dem Update): 21203 (Decoder, Wert 285 → auf 1000 korrigiert) – ❓ vermutlich harmlos
- ✅ 120206 „Programmende bei aktivem Polynomüberschleifen“ 97 × im Zeitraum – steht NICHT im error_filter (obwohl VersionsInfo V1.0.6 das vorsieht)
- ✅ Ereignisklassen: CNC = `{3AFE1771-EB17-4B85-9958-18E33AFD4791}`; Protokoll-Datei `C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot\LoggedEvents.db` (SQLite, Zeit = Windows-FILETIME UTC)

## Beckhoff-Parameter rund um 50120 / 50121
- 🌐 P-AXIS-00441 `kenngr.dyn_monitoring_a_warn` – Warnschwelle; Standard 500 → Warnung ab 1,5 × P-AXIS-00008
- 🌐 P-AXIS-00442 – Fehlerschwelle; Standard 1000 → Fehler ab 2,0 × P-AXIS-00008
- 🌐 P-AXIS-00013 `getriebe[0].dynamik.a_trans_weight` – Gewichtung der Beschleunigung am Satzübergang; 0–1000 (0,1 %); Standard 0
- 🌐 P-AXIS-00154 `getriebe[0].dynamik.r_trans_weight` – Gewichtung des Rucks am Satzübergang; 0–1000, Standard 1000; wirkt nur mit `corr_v_trans_jerk` (P-CHAN-00009) = 1
- ✅ P-AXIS-00140 `filter[0].order` (0 = Filter aus); P-AXIS-00153 `filter[0].prototype`; P-CHAN-00071 `prog_start.slope.profile`
- 🌐 **P-STUP-00070** `configuration.channel[0].interpolator.function` – legt u. a. die Größe des Look-ahead-Puffers fest = über wie viele NC-Sätze Bremsweg und Dynamik vorausgeplant werden; FCT_LOOK_AHEAD_CUSTOM = eigene Satzanzahl
- 🌐 **P-STUP-00071** `configuration.channel[0].interpolator.number_blocks_lah` – Satzanzahl im Look-ahead-Puffer (nur mit FCT_LOOK_AHEAD_CUSTOM); Standard 120, Obergrenze 500 (ab CNC V3.1.3067.07); **in älteren CNC-Versionen hieß derselbe Parameter `configuration.channel[0].interpolator.parameter`** (wird aus Kompatibilitätsgründen weiter verstanden)
- ✅ HEDS ändert Kanalparameter selbst (VersionsInfo V1.0.6: `error_filter[0].reason` um 120206 erweitern)

## ToDo.txt des HEDS-Technikers (Soll-Konfiguration CNC)
- CNC Startup: `interpolator.function FCT_LOOK_AHEAD_CUSTOM`, `interpolator.parameter 200`, `path_preparation.function FCT_DEFAULT | FCT_SURFACE`
- Kanal SDA: `trans_limit_with_curvature 1`, `opt_contour_mode 2`, `prog_start.slope.profile 3`, `hsc.bspline.auto_contour_mode 2`, (optional 5 Achsen) `dev_surface_5ax 1`
- Alle Achsen: `getriebe[0].dynamik.a_trans_weight 50–1000`, `r_trans_weight 50–1000`, `filter[0].order 6`, `filter[0].prototype 5`
- Intervalldauer Kassettendeckel 10 s, Traverse 29 s

## TwinCAT-Projekt & Sicherungen auf dem Steuerungs-PC
- ✅ Aktives Projekt: `C:\HM1\HedmillOne.sln` / `HedmillOne.tsproj` (gespeichert 30.10.2026 08:49:32), `HedmillOne.tsproj.bak` (08:46, inhaltsgleich); SPS-Teil in `C:\HM1\TC3_CNCPLCBase\`
- ✅ **Aktive Konfiguration = aktuelles Projekt**: `CurrentConfig.tszip` im Boot-Ordner enthält ein HedmillOne.tsproj, das Byte für Byte gleich mit `C:\HM1\HedmillOne.tsproj` ist (geprüft 02.11.2026)
- ✅ Boot-Ordner (TwinCAT 3.1 Build 4026): `C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot\` (CurrentConfig.xml/.tszip, TCNC.bootdata, Plc\Port_851.*, LoggedEvents.db); `C:\TwinCAT\3.1\Boot` gibt es nicht
- ✅ Sicherungen (.tnzip = gepacktes TwinCAT-Projektarchiv) in `C:\HM1\`: `HedmillOne_20260225.tnzip`, `HedmillOne_vorV1-0-6_20260505.tnzip`, `HedmillOne_vorV1-0-12_20261030.tnzip` (30.10.2026 08:01 = echter Stand vor dem Update; tsproj darin vom 22.05.2026)
- ✅ Update-Paket von HEDS: `D:\Updates\HM1\HedmillOneV1-0-12\HedmillOne.tsproj` (18.09.2026, mit TwinCAT 3.1.4026.18 erstellt) → Update 30.10.2026 = TwinCAT-Projekt **V1.0.12**
- ✅ Ablauf 30.10.2026: 07:53 letzter Start mit CNC 4.30 → 08:01 Sicherung → 08:46 Konfiguration aktiviert (Start mit CNC 4.34) → 08:49 Projekt gespeichert
- ❓ (logisch abgeleitet) Das Projekt, mit dem Andreas am 01.11.2026 in TwinCAT XAE war („Sicherung von Freitag“), war das aktuelle Projekt `C:\HM1\HedmillOne.sln` (Stand NACH dem Update): SPS-Teil vor/nach Update unterscheidet sich (anderer TmcHash, neue VE-Variable MessageText), Login lief aber ohne Download-Rückfrage
- ✅ HMI-Werkzeug „TcCNCVariablenViewer“ unter `C:\HMI\TcCNCVariablenViewer\`
- ✅ Sicherheitsachsen (TwinSAFE): X-Axis_TA1, Y-Axis_TA2, Z-Axis_TA3, A-Axis_TA4 (ELM7231-9018), B-Axis_TA5, Blank-Axis_TA6 (sonst ELM7231-9016)

## Vergleich CNC-Parameter vor dem Update ↔ jetzt (vollständig, 02.11.2026)
- ✅ Identisch vor und nach dem Update: alle Achsparameter (a_trans_weight / r_trans_weight 50 / 50 und Filter 6 / 5 auf 5 Achslisten, 0 / 0 und Filter aus auf 3 Achslisten), Kanal-Einstellungen (slope.profile 3, trans_limit_with_curvature 1, opt_contour_mode 2, hsc.bspline.auto_contour_mode 2, dev_surface_5ax 1), Startup FCT_LOOK_AHEAD_CUSTOM | FCT_CALC_STATE_AT_T, FCT_DEFAULT | FCT_SURFACE | FCT_EMF, `number_blocks_lah 500`, error_filter 20803,20804 (HIDE)
- ✅ Die ToDo.txt-Werte standen also schon vor dem Update drin
- ✅ Neu seit dem Update in der CNC-Hochlaufliste (kommt aus dem Update-Paket): `configuration.channel[0].interpolator.parameter 200` direkt unter `number_blocks_lah 500` → laut Beckhoff alter Name desselben Parameters → ❓ vermutlich gilt jetzt 200 statt 500 Sätze Look-ahead
- ✅ Sonst neu (für Dynamik ohne Bedeutung): `m_synch[30]` MOS → 0x00000002, neues `m_synch[11]` (Schmierkühlmittel-Schlauch ausblasen), externe Variablen 81 → 86 (u. a. `V.E.MessageText`), neue HMI-Meldungstexte
- ✅ Update-Paket V1.0.12 hatte alle ToDo-Werte auf Standard; der Techniker hat sie am 30.10. nachgetragen

## Zwei Kandidaten für „Warnung seit dem Update“
1. ❓ Look-ahead 500 → 200 Sätze durch die neue Zeile `interpolator.parameter 200` (technisch rückgängig machbar durch Auskommentieren + „Activate Configuration“ – laut Entscheidung aber Sache von HEDS)
2. ❓ Neuer CNC-Kern 4.34 (vorher 4.30) mit evtl. anderer Bahnplanung

## Suchskript
- `skripte/DYNSUCHE.ps1` (nur lesend, PowerShell am Steuerungs-PC, erfolgreich gelaufen 01.11.2026)
