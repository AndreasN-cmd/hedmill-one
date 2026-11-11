# Achsdynamik: Störung 50120 / Warnung 50121 Achse B, Look-ahead, TwinCAT-Projekt

> Kennzeichnung: ✅ bestätigt · 🌐 Beckhoff-Doku / allgemein · ❓ offen oder Annahme
> Stand: 11.11.2026

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
- ✅ 05.11.2026 (Andreas, aus `../fraesstrategien-hyperdent/docs/grundsaetze.md`): 50120 kommt weiterhin bei großen Molaren (6er, 7er) trotz Drehfräs-Genauigkeit 0,01, nur am MKD (T4126), bei keinem anderen Werkzeug
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
- ✅ 09.11.2026: Die Hersteller-Datei `maschine/sub/ToDo.txt` listet die CNC-Parameter, die HEDS für die Steuerung vorsieht: `interpolator.function FCT_LOOK_AHEAD_CUSTOM`, `interpolator.parameter 200`, `path_preparation.function FCT_DEFAULT|FCT_SURFACE`, Kanal SDA `trans_limit_with_curvature 1`, `opt_contour_mode 2`, `hsc.bspline.auto_contour_mode 2`, Achsen `a_trans_weight`/`r_trans_weight` 50–1000, `filter[0].order 6`, `prototype 5`. ❓ Welche davon auf der Maschine aktiv sind, ist nicht geprüft

## 11.11.2026: Nacht 10./11.11. – neun Teleskope drehgefräst, eines mit 50120 (Analyse läuft)
- ✅ Andreas 11.11.2026: neun Primärteleskope im Drehfräsprozess in einer Nacht, eines mit Abbruch durch den B-Achsen-Beschleunigungsfehler. **Der Fehler ist der größte Störfaktor im Automatikbetrieb** (ohne ihn ≈ 50 Teleskope in 3 Tagen möglich; ist er weg, darf die Frässtrategie wieder schneller werden). Ziel: endgültig lösen
- ✅ **Beobachtung Andreas (mehrfach bestätigt):** Der Fehler kommt beim Drehfräsen **nur beim Torus (MKD T4126, Job 25), nie bei den Kugeljobs**, und erst, **wenn der Torus die Friktionsfläche schon fertig hat** (also in der Kuppel/okklusalen Zone, die genaue Stelle ist unbekannt)
- ❓ Noch unbekannt: Lief die Nacht mit der neuen `ldyn.cfg` (MKD → `LDYN17`) oder noch mit `LDYN60`? Steht im NC der Nacht in der Zeile nach `T4126 M6`
- ✅ **NC-Analyse SA13 (08.11.2026, LDYN60, `maschine/nc-beispiele/2007-24__SA13.nc`), MKD-Abschnitt gegen die Kugel-Drehfräsjobs derselben Außenfläche** (Skript `skripte/nc_drehfraes_analyse.py <nc> <Werkzeug> [Vorkommen] [Zonenbreite]`, Kennzahlen je Y-Zone, B modulo 360 beachtet):
  - MKD Job 25: 101 496 Sätze, 407 Umdrehungen, 249 Sätze je Umdrehung, 5 500 °/min = 91,7 °/s, kürzester Satz 0,1875° = 2,05 ms, Z-Geschwindigkeit max 10,5 mm/s, Zeit rechnerisch 26,6 min, X 0 (Spitze auf der Achse), keine B-Umkehr (B358 → B0 ist der Modulo-Übergang, keine Umkehr)
  - Friktionszone (Y −24,5 bis −22): Querschnitt je Umdrehung gleich (Z 2,23–4,27), ≈ 6 Z-Umkehrungen je Umdrehung, viele kurze Sätze (bis 1 772 je 0,5 mm)
  - Kuppel (Y −21 bis −14,4): Radius 1,5–3,5, **Z-Umkehrungen steigen auf 30–57 je Umdrehung** (Fissuren, Höcker; Beispiel N4312570: Z 3,33 → 2,98 → 3,47 innerhalb 20° B, Flanke 0,08 mm/°), kurze Sätze dagegen seltener. Das ist genau die Zone, in der Andreas den Fehler sieht
  - Ø2-Kugel Job 21 (T4083, LDYN1) über dieselbe Fläche: 16 000 °/min = 267 °/s, Sätze bis 0,70 ms, **Z-Geschwindigkeit bis 36 mm/s, bis 106 Z-Umkehrungen je Umdrehung in der Kuppel** – und kein Fehler. Ø1,5 (T4086, LDYN2) ebenso; T4098/T4089 Hohlkehle 10 000 °/min mit Sätzen von 1,13 ms
  - **Schlussfolgerung:** Geometrie und Vorschub des MKD-Jobs sind in jeder Kennzahl harmloser als die Kugeljobs. Was den MKD unterscheidet: der Dynamiksatz (bis 10.11. **DYN60**: 50 % der B-Grenze = 5 000 °/s², Rampe 30 ms = härtester Ruck, Bahnabweichung 0,2 mm), die Spitze auf der Achse (X 0, `leadangle 0`) und die Dauer (26 min am Stück). Der Fehlerwert 37 500 °/s² (01.11.) ist das 7,5-fache dessen, was der Planer mit DYN60 selbst anfordern darf – also kein geplanter Bremsvorgang, sondern ein Sprung in der Sollwertbahn. Mit der Kuppel (viele Z-Umkehrungen) und DYN60 (weiche 0,2-mm-Glättung, harter Ruck) passt das Bild zu den Beobachtungen von Andreas
- **Nächste Schritte (Reihenfolge):**
  1. Logs holen: `skripte/LOGS_SAMMELN.ps1` am Steuerungs-PC (kopiert LoggedEvents.db, HMI-Logs 3 Tage, die 12 letzten NC aus `C:\CNC\wp`, diag_data, DYN-Sätze auf den Desktop) → USB-Stick → Mac `~/Downloads`. Auswerten: `python3 -I skripte/loggedevents_dump.py <LoggedEvents.db>` (alle 50120/50121 mit Programm und Satznummer), dann Satznummern im NC nachschlagen (Y-Position, Satzlänge, Z-Umkehr?) – damit wird die Stelle erstmals sichtbar, auch über die Warnungen 50121 statistisch
  2. Im NC der Nacht prüfen: `LDYN17` oder `LDYN60` nach `T4126 M6`. Bei LDYN60: zuerst `DYN18` auf die Maschine, dann neue `ldyn.cfg` am CAM-PC, Nacht beobachten (20-cam-hyperdent.md)
  3. Bleibt der Fehler mit LDYN17: `_201` → LDYN26 (längste Rampe) als Gegenprobe, dann MKD-Vorschub 5 500 → 4 000 in der Vorlage (Plan Primärteleskop Punkt 54), dann HEDS (Look-ahead 200 → 500, CNC 4.34). Nie B-Grenzen (P-AXIS-00008/00441/00442) erhöhen

## 11.11.2026, 11:30: Logauswertung – die Stelle ist gefunden (Konnektor-Knick im MKD-Job)
- ✅ Logs vom Steuerungs-PC per `skripte/LOGS_SAMMELN.ps1` (Ordner `~/Downloads/HEDmill-Logs-2026-11-11_1127`, LoggedEvents.db 15 MB bleibt dort; HMI-Logs 09.–11.11. in `maschine/log/`). **Die Nacht lief bereits mit der neuen `ldyn.cfg` (Andreas; NC `1109-59__ED00.nc` vom 11.11.: `LDYN17` nach `T4126 M6`, `LDYN18` nach T4093, sonst DYN1/4/5).** → DYN17 allein löst den Fehler nicht
- ✅ **Alle CNC-Meldungen 50120/50121 seit 09.11.2026** (LoggedEvents.db, Tabelle `JsonAttributes`: Programm, Satz N, Achse 5 = B, Istwert/Grenze; Auswertung `skripte/loggedevents_dump.py`, Liste in `maschine/log/cnc_ereignisse_2026-11-09_bis_11.md`):

| Zeit | ID | Programm | Satz N | Beschleunigung B (Vielfaches von 10 000 °/s²) | Dynamiksatz MKD |
|---|---|---|---|---|---|
| 09.11. 03:54 | 50121 | 2033-08__GH17 | 5345770 | ±1,75 | DYN60 |
| 09.11. 05:44 | 50121 | 2050-40__GH24 | 3933920 | ±1,76 | DYN60 |
| 09.11. 07:34 | 50121 | 2049-11__GH23 | 4220510 | ±1,98 | DYN60 |
| 09.11. 13:21 | **50120** | 1042-14__AS22 | 2964620 | 5,14 | DYN60 |
| 09.11. 20:47 | **50120** | 2012-56__SA21 | 4272950 | 5,90 | DYN60 |
| 10.11. 00:04 | 50121 | 2016-22__SA22 | 3473180 | ±3,74 | DYN60 |
| 10.11. 11:45 | 50121 | 2007-24__SA13 | 4616650 | ±3,47 / 3,70 | DYN60 |
| 10.11. 11:48 | 50121 | 2007-24__SA13 | 4692170 | ±2,16 / 2,56 | DYN60 |
| 10.11. 11:50 | **50120** | 2007-24__SA13 | 4758370 | 5,35 | DYN60 |
| 11.11. 00:17 | **50120** | 1041-54__HF46 | 4686010 | 5,79 | **DYN17** |
| 11.11. 09:07 | 50121 | 1120-19__HF33 | 6109080 | ±4,02 | **DYN17** |

  - Jede Warnung kommt als Paar +a / −a im Abstand von 1–2 ms (Modul `BAHN_ABL.C`, Z. 11640 Warnung / 11348 Fehler): ein einzelner Sollwert-Ausreißer der B-Achse (Sprung hin und zurück), kein Bremsvorgang. Vier Abbrüche in drei Tagen, bei allen Teilen im MKD-Abschnitt (Satznummern 2,9–6,1 Mio = letztes Drittel des Programms)
- ✅ **SA13 (Programm liegt im Repo) – alle drei Ereignisse an derselben Art Stelle:** N4616650 (Y −17,03), N4692170 (Y −15,98), N4758370 (Y −15,13): Der MKD läuft im Ring 35–45° lang auf **Z = 1,50 = Radius des Ø3-Konnektors** (lange 2°-Sätze, Z konstant) und verlässt den Konnektor dann mit einem **Knick** in die Kuppelflanke (0,1875°/0,25°-Sätze, Z steigt 0,005 → 0,015 mm je Satz, bis 0,06 mm/°). Skript `skripte/nc_konnektor_knicke.py`: 199 solcher Knicke in SA13 (Y −17,5 bis −14,4, Konnektorkontakt die letzten 3,15 mm des MKD-Jobs), die drei Ereignisse liegen nach Steilheit auf Rang 189, 82 und 41 → **welcher Knick auslöst, ist Zufall (Timing), jeder Konnektor-Knick kann es**. ED00 (11.11.): 50 Knicke auf den letzten 1,73 mm. Bis zum Konnektorkontakt (Friktion, Kuppel mit Fissuren) kein einziges Ereignis seit 09.11. – genau Andreas' Beobachtung „erst wenn die Friktionsfläche fertig ist“
- ❓ Mechanik (Deutung): In der Bahnmetrik (B in Grad wie mm) ist der Knick fast gerade (1–3°), der Planer bremst deshalb nicht; die Z-Achse muss aber aus dem Stand auf 2–5 mm/s. Bei langen 2°-Sätzen vor und 0,19°-Sätzen nach dem Knick entsteht im Interpolator ein Einzelzyklus-Ausreißer in B. Die Kugeljobs laufen über dieselben Konnektoren fehlerfrei – sie fahren seitlich versetzt (X 1,5–3,9), dort gibt es den flachen Konnektorbogen mit Knick nicht
- **Lösung CAM-seitig (Vorschlag, Entscheidung Andreas, neue Version nur auf Ansage):** MKD-Job vor dem Konnektorkontakt enden lassen: `bottomoffset` 1 → **−3** (Ende 3 mm vor dem okklusalen Pol, wie die Hohlkehlenringe T4098/T4089). Nimmt alle Konnektor-Knicke aus dem MKD-Job und spart **8,3 von 26,6 min MKD-Zeit (SA13) bzw. 4,5 von 20,5 (ED00)**. Die Kuppel am Konnektor bleibt dann auf Ø1,5-Kugel +0,03 (Job 22, läuft bis Pol +2); okklusal liegt unter dem Deckelspalt 0,1, keine Passungswirkung. Kontrolle in hyperDENT: letzter MKD-Ring frei vom Konnektor, sonst −4. Plan Primärteleskop SLM Punkt 56, CoCr Bar Punkt 14. Maschinenseitig nichts ändern; DYN17 bleibt (Qualität). HEDS-Meldung mit dieser Stelle (Satz + NC) ist jetzt möglich
- ❓ Gegenprobe offen: NC-Programme HF46, HF33, SA22, SA21, AS22, GH17/23/24 vom CAM-PC (hyperDENT-Ausgabeordner) holen und die Satznummern mit `skripte/nc_konnektor_knicke.py <nc> T4126 <N>` prüfen. `C:\CNC\wp` enthält nur das jeweils aktuelle Programm

## 11.11.2026, 12:00: Gegenprobe mit 15 NC-Programmen vom CAM-PC – bestätigt
- ✅ Andreas hat 15 NC-Programme geliefert (`~/Downloads/*.nc`, 02.11., 07.11. und 10.11.): SA_6/SA_3/SA_4, AS23/AS12/AS11/AS21/AS22/AS25, HF46/HF45/HF43/HF44/HF33/HF35. Zusammen mit SA13 (Repo) 16 Programme. Hinweis: Der Ordner `~/Downloads/HEDmill-Logs-2026-11-11_1127` mit der LoggedEvents.db ist nicht mehr in Downloads; die Ereignisliste steht in `maschine/log/cnc_ereignisse_2026-11-09_bis_11.md`
- ✅ **Alle fünf Ereignisse mit vorliegendem NC liegen am Konnektor-Austritt des MKD-Rings (5 von 5):**

| Programm | Ereignis | Satz N | Stelle | Konnektorzone (Y, Länge) | Knicke im Job | Rang nach Steilheit |
|---|---|---|---|---|---|---|
| 2007-24__SA13 (DYN60) | 50121 3,5× | 4616650 | Austritt Y −17,03, Z 1,507 | −17,50 … −14,36, 3,15 mm | 250 | 187 |
| 2007-24__SA13 | 50121 2,2× | 4692170 | Austritt Y −15,98, Z 1,515 | | | 83 |
| 2007-24__SA13 | **50120** 5,4× | 4758370 | Austritt Y −15,13, Z 1,521 | | | 41 |
| 1041-54__HF46 (DYN17) | **50120** 5,8× | 4686010 | Austritt Y −15,33, Z 1,524: 16° lang Z 1,5225 flach, dann +0,0017/+0,0056/+0,0056/+0,0057 je 0,1875° | −15,48 … −15,00, 0,48 mm | 41 | 21 |
| 1120-19__HF33 (DYN17) | 50121 4,0× | 6109080 | Austritt Y −13,17, Z 1,528: 16° lang Z 1,525 flach, dann +0,0008/+0,0017/+0,0017/+0,0036 je 0,1875° (flacher Knick) | −13,73 … −12,50, 1,23 mm | 44 | 27 |

- ✅ Kontrollgruppe (11 Programme ohne Meldung, DYN60 und DYN17): jedes hat eine Konnektorzone von 0,30 bis 2,35 mm mit 13 bis 161 Knicken und lief trotzdem fehlerfrei → der Auslöser ist zufällig (Timing), die Zone ist die Bedingung. Kein Ereignis außerhalb einer Konnektorzone, in keinem der 16 Programme
- ✅ Konnektorzonen aller 16 Programme: 0,30 … 3,15 mm vor dem MKD-Ende (Maximum SA13). **`bottomoffset` −3 lässt den MKD 4 mm früher enden als heute (1) → Reserve ≥ 0,85 mm in allen 16; `bottomoffset` −4 → Reserve ≥ 1,85 mm.** Empfehlung −4 (die Kuppel dort bleibt ohnehin unter dem Sekundärteil-Deckel, Fräszeit sinkt noch etwas)
- ✅ Skript `skripte/nc_konnektor_knicke.py` (Schwellen: flach |dZ/dB| < 0,004 mm/° bei Z < Konnektorradius + 0,06; Knick, wenn innerhalb 5 Sätzen > 0,008 mm/°). Aufruf: `python3 -I skripte/nc_konnektor_knicke.py <nc> T4126 <N …>`
- **Damit ist der Fehler CAM-seitig vermeidbar, ohne an der Maschine etwas zu ändern.** Für HEDS (falls gewünscht): „Einzelzyklus-Beschleunigungsspitze der B-Achse am Übergang von langen 2°-Sätzen (Z konstant) auf 0,19°-Sätze mit steigendem Z, z. B. 2007-24__SA13.nc N4758370, CNC 4.34, HSC SURFACE PATH_DEV 0,016/0,2, Look-ahead 200“
- 11.11.2026: Meldungsentwurf an HEDS mit der gefundenen Stelle: `docs/meldung_heds_50120_2026-11-11.md`

## 11.11.2026, 13:00: Fester `bottomoffset` ist nicht robust – Maße der 16 Programme
- ✅ Andreas (Test in hyperDENT): Bounding-Box-**Minimum** ist die Okklusal-/Konnektorseite (richtig für den MKD-Job), Maximum die Präpgrenzenseite. **Minimum −3 endet bei seinem Testteil mitten in der Friktionsfläche** → bei kurzen Teleskopen nicht möglich
- ✅ Maße aus den 16 NC-Programmen (`skripte/nc_kuppel_masse.py`; Pol = Jobende − 1 mm; „Konnektor ab“ = erster Ring mit flachem Konnektorbogen; „sicherer Offset“ = Jobende 0,5 mm vor dem Konnektorkontakt):

| Programm | Start Y | Pol Y | Konnektor ab Y | vor dem Pol | sicherer Offset |
|---|---|---|---|---|---|
| SA13 | −24,50 | −15,36 | −17,44 | 2,08 | −2,58 |
| HF46 | −22,46 | −16,00 | −15,46 | −0,54 | +0,04 |
| HF33 | −24,75 | −13,50 | −13,64 | 0,14 | −0,64 |
| SA_6 | −21,89 | −16,00 | −15,01 | −0,99 | +0,49 |
| SA_3 | −24,89 | −16,00 | −17,01 | 1,01 | −1,51 |
| SA_4 | −24,09 | −16,00 | −17,03 | 1,03 | −1,53 |
| AS23 | −24,53 | −16,00 | −16,98 | 0,98 | −1,48 |
| AS12 | −22,26 | −16,00 | −16,83 | 0,83 | −1,33 |
| AS11 | −23,53 | −16,00 | −17,30 | 1,30 | −1,80 |
| AS21 | −23,39 | −16,00 | −15,09 | −0,91 | +0,41 |
| AS22 | −22,63 | −16,00 | −16,01 | 0,01 | −0,51 |
| AS25 | −22,05 | −16,00 | −15,66 | −0,34 | −0,16 |
| HF45 | −23,41 | −16,00 | −15,76 | −0,24 | −0,26 |
| HF43 | −24,95 | −13,50 | −13,96 | 0,46 | −0,96 |
| HF44 | −23,73 | −16,00 | −16,44 | 0,44 | −0,94 |
| HF35 | −24,50 | −15,34 | −15,50 | 0,16 | −0,66 |

- ✅ Der Konnektor tritt je nach Neigung der Okklusalfläche zwischen **1,0 mm hinter und 2,1 mm vor dem Pol** aus der Kuppel. Ein fester Offset, der alle 16 abdeckt, wäre −2,6; bei 9 von 16 reichte −1, bei 4 sogar 0. Die Kuppelhöhe über der 0°-Friktion liegt in diesen 16 bei 5,3 bis 10,5 mm, Andreas' Testteil ist kürzer
- **Folgerung:** Ein fester Wert kann nicht gleichzeitig alle Konnektoraustritte vermeiden und die Friktion kurzer Teleskope schonen. Varianten: (a) **−2** als Master-Wert (deckt alle 16, SA13 mit 0,08 mm knapp) plus Variante „kurz“ (z. B. −1 oder 0) für Teleskope mit niedriger Kuppel, Wahl beim Berechnen; (b) Wert je Teil nach Sichtkontrolle der MKD-Bahn am Konnektor; (c) echte Lösung über HEDS (Steuerung, Mail vom 11.11.). Empfehlung −3/−4 vom Vormittag ist damit zurückgenommen
- ❓ Mechanik, verfeinert: Die Ereignisse sind alle Austritte (Z beschleunigt aus dem Stand), nie Eintritte. Vermutung: Übergang von langen 2–3°-Sätzen (Konnektorbogen, Satzvorbereitung hat Luft) auf 0,19°-Sätze mit 500 Sätzen/s → Satzvorbereitung (HSC SURFACE) kommt nicht nach, Look-ahead reißt kurz ab → Einzelzyklus-Ausreißer. Passt zu Zufall, zu DYN-Unabhängigkeit, zum Update (Look-ahead 500 → 200, CNC 4.34) und dazu, dass die Kugeljobs (immer kurze Sätze, nie „Luft“) nicht betroffen sind. Für HEDS als Hypothese ergänzt
