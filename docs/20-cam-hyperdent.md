# hyperDENT-Vorlagen & CAM-Jobs (HEDmill One)

> Kennzeichnung: ✅ bestätigt · 🌐 Beckhoff-Doku / allgemein · ❓ offen oder Annahme
> Stand: 09.11.2026

## Zuständigkeit (seit 09.11.2026)
- **Vorlagen, Jobs, Schnittwerte, Aufmaße gehören ins Nachbar-Repo `../fraesstrategien-hyperdent`** (Start dort: `README.md`, `docs/grundsaetze.md`). Dort steht der gültige Stand, hier wird er nicht doppelt gepflegt.
- Hier bleibt nur, was Maschine und Steuerung betrifft (Toleranz gegen Achsdynamik, HSC-Glättung, Nullpunkte, NC-seitige Wege).

## G58-Z-Versatz und Passungen (seit 09.11.2026)
- ✅ Drehfräsen bei A0 unter G58 kommt real 0,0625 mm im Radius kleiner als programmiert (Messing, Bügelmessschraube, T4081 Ø10,000 → 9,875 und T4090 Ø9,600 → 9,475)
- ✅ Andreas 09.11.2026: ab sofort werden alle Primärteleskope und Titan-Abutments drehgefräst hergestellt → jedes dieser Teile trägt den Versatz
- ✅ Die Frässtrategien sind darauf eingestellt; Rechenregel und Folgen stehen in `../fraesstrategien-hyperdent/docs/grundsaetze.md` (hyperDENT / Maschine) und `docs/auslenkung_werkzeuge.md` §25
- ✅ G58-Z bleibt −0,025; Änderung nur zusammen mit einer neuen Frässtrategie-Version (CLAUDE.md Regel 9)

## Allgemein
- ✅ CAM: hyperDENT (Follow-Me); Postprozessor setzt Nullpunkte G58/G59 automatisch, kein NC-Text nötig. ⚠️ **Aber nur, wenn hyperDENT das Rohteil als Preform führt: NC `1109-59__ED00.nc` (CoCr_Bar, 11.11.2026) kam mit G54/G55 (Rondenmuster: G55 B180 „oben“, G54 B0 „unten“, Drehfräsen unter G55 bei B 180) → Kavität 0,41 mm versetzt. SLM-Teil SA13 (08.11.): G59/G58. Vor jedem Preform-Start Zeile N120 prüfen (`docs/02`, CoCr-Bar-Änderungsplan 15)**
  - ✅ Vier weitere NC geprüft (11.11. abends): OX_3 (28.10., CoCr_Bar) G58/G59; HF45 (10.11.) G54/G55; ED01 und Abutment AB24 (Ti_Bar, 11.11.) G54/G55 → seit 10.11. alle Preform-Programme betroffen (HF-Nacht, AB24 prüfen). PP `.oma` byteidentisch seit 14.08.2026 → nicht der PP
  - ✅ **Nullpunktwahl des PP steuert der Halter (`.fmdf`):** `addcfgparams` → `*HD_HEDS_ZP 3` (vorhanden im Halter „HEDmill One - Medentika“, **fehlt** in `hedmill_one_one_step.fmdf` „HEDmill_One - One_Step“, dort nur `*HD_STOCK_TYPE CYLINDER`, `*HD_PREMILL_SIMUL 20.0`). Ohne den Parameter schreibt der PP das Rondenschema G54 (B 0) / G55 (B 180). Fix: Zeile im One_Step-Halter ergänzen, hyperDENT neu starten, Teleskop rechnen, N120 = G59. ✅ Andreas 11.11. abends: eingetragen (One_Step und Medentika), Kontroll-NC mit beiden Haltern wieder G58/G59 → **gelöst.** Regel: nach jedem Hedmill-Paket alle HEDmill-`.fmdf` auf den Parameter prüfen, N120 des ersten NC lesen. Bedeutung des Werts 3 (❓ Index des Nullpunktpaars G58/G59?) bei HEDS erfragen. Seit wann der Parameter fehlt (Paket „MHT 2“ / Update Center 30.10.?), ist offen
  - ✅ **Standweg-Gewichtung beim Drehfräsen** (HEDS 11.11., „ToolDistCal On/Off“): Unterprogramme `ToolDistFactOn` (`V.TLM.DIST_FACT = 0.085`, Umdrehung ≈ 10 mm Standweg) und `ToolDistFactOff` (1.0) seit V1.0.5 (23.04.2026, `maschine/sub/`). `M6` ruft am Ende `ToolDistFactOff` → `L ToolDistFactOn` muss in jedem Drehfräsjob nach dem Werkzeugwechsel stehen (NC-Text am Jobanfang); der PP schreibt es nicht (fünf NC geprüft). Wirkt nur auf die Standzeitzählung (CoCr-Bar-Änderungsplan 17)
- ✅ Hedmill verteilt Maschinendefinition, Postprozessor, Templates, Rohteile und Halter über das hyperDENT Update Center (`https://update.heds.dental/hyperdent/MASTER/index.xml`, Prüfung täglich). Andreas schaltet das ab (10.11.2026), Anleitung und Kontrolle: `../fraesstrategien-hyperdent/docs/hyperdent_updatecenter.md`. Letzter Hedmill-Lauf, der den PP-Ordner neu schrieb: 14.08.2026
- ✅ CAD: exocad DentalCAD
- ✅ hyperDENT-Optimierung von PMMA-Schienen-Innenflächen mit Hinterschnitten war Thema
- ✅ SLM+CNC-Hybridfertigung (TruPrint 1000, Starbond Easy Powder) → siehe 22-hybrid-express-halter.md und Andreas' eigene Offset-Software (separates Repo)

## Prefab-Abutments (Drehfräsen)
- Gültiger Stand: `../fraesstrategien-hyperdent/indikationen/abutment/titan-prefab-drehfraesen/` (V5.7 vom 06.11.2026: seitlich schruppen nur mit T5051, T5052 soll aus der Maschine).
- Überholt: Stand Okt 2026 mit zwei axialen Schruppjobs (T5051 für die ersten 7,5 mm, T5052 für den Rest).
- ✅ Rohteile Ø11,5 und Ø16 mm, zu 99 % Ø11,5 (siehe 08-rohteile-halter.md); EINE Vorlage für beide, kein manuelles Umschalten, keine Rohteilgruppen
- ✅ Verzweigung in der Maschine (`$IF` im NC-Text) ist Andreas derzeit zu experimentell

## Job 1.5 „Vorschlichten Prep-Grenzenband Torus“
- Gültige Regel: `../fraesstrategien-hyperdent/docs/grundsaetze.md` (Präpgrenzenjobs von innen nach außen, nie 3 mm tief innen starten).
- Überholt: Aufteilung vom 01.11.2026 in zwei Jobs (einer davon mit Band bis 3 mm innerhalb der Grenze).

## Bearbeitungstoleranz
- ✅ Im Template wurde die Bearbeitungstoleranz testweise auf 0,005 mm gesetzt – so fein wie nie zuvor; Andreas wollte die 0,005 mm möglichst behalten
- ✅ Ergebnis 01.11.2026 abends: 0,005 mm → Fehler 50120 (Maschine stoppt); 0,01 mm → nur Warnschwelle Achsbeschleunigung (50121), Maschine stoppt nicht → **Andreas läuft mit 0,01 mm und beobachtet**
- ✅ 05.11.2026 (Andreas, aus `../fraesstrategien-hyperdent/docs/grundsaetze.md`): 50120 ist nicht erledigt. Bei großen Molaren (6er, 7er) kommt „Beschleunigung überschritten“ trotz Drehfräs-Genauigkeit 0,01, nur am MKD (T4126), bei keinem anderen Werkzeug
- Regel für die Vorlagen (Genauigkeit in Drehfräsjobs 0,01, enger erst nach der Verbesserung durch den Hersteller): `../fraesstrategien-hyperdent/docs/grundsaetze.md`
- ✅ Die Maschine fräst mit HSC-Glättung der Steuerung (`#HSC ON`, `#SLOPE[TYPE=HSC]`, z. B. nach M6 und Home.nc); in setVPVars steht als Standardwert für die HSC-Bahnabweichung `V.P.PathDev = 0.04` (mm, „Path_DEV für HSC-Funktion … DYN1 … DYNvar“)
- ✅ 10.11.2026 geklärt: die hyperDENT-Programme rufen nach jedem Werkzeugwechsel `LDYNn` auf (Abschnitt „Dynamiksätze aus hyperDENT“ unten)

## Wege, um feine Toleranz zu nutzen bzw. Reserve zu schaffen (besprochen 01.11.2026)
1. Vorschub nur im betroffenen Job senken (Beschleunigung steigt etwa mit dem Quadrat der Geschwindigkeit: 70 % Vorschub ≈ halbe Beschleunigung); Test vorab mit Override 70–80 % in diesem Job
2. Feine Toleranz nur in den Jobs verwenden, wo sie auf der Fläche wirkt (Schlichten Funktionsflächen); Jobs mit viel B-Bewegung mit gröberer Toleranz
3. Prüfen, mit welcher HSC-Bahnabweichung die Jobs laufen (siehe oben)
4. Nicht empfohlen: B-Beschleunigungsgrenze (P-AXIS-00008) oder Schwellen (P-AXIS-00441/00442) erhöhen – Schutz für Antrieb/Mechanik
5. Look-ahead wieder auf den Stand vor dem Update – Entscheidung liegt bei HEDS (21-achsdynamik-50120.md)
- Beobachten: Bei welchem Satz / Job kommt die Warnung, wie oft, Verhältnis-Wert in der Meldung; tritt zusätzlich 50120 auf → Vorschub im Job senken

## Dynamiksätze aus hyperDENT (LDYN, Stand 10.11.2026)
- ✅ Der hyperDENT-Postprozessor schreibt nach jedem `T… M6` die Zeile `LDYNn` (Aufruf von `maschine/sub/DYNn`). Die Nummer kommt aus `ldyn.cfg` im PP-Ordner am CAM-PC: Materialklasse (CoCr_Blank, Titanium_Blank, CoCr_Bar, Ti_Bar, WAX, Plastic, ZR) × Werkzeug-Ø in Hundertstel; die Klasse kommt aus `hdmaterialtypes.ini` (hyperDENT-Materialname wörtlich). Tabellen, Materialzuordnung und die gültigen Dateien: `../fraesstrategien-hyperdent/maschine/hedmill_postprozessor.md` und `maschine/hedmill_postprozessor/`.
- ✅ Inhalt der Sätze (`V.L.AccXYZ`/`V.L.AccAB` → `G130` in Prozent der Achsgrenze, Basis 100; Rampe → `G132`; `#HSC [SURFACE PATH_DEV …]` in mm): DYN-Standard 1000 / 65 / –; DYN1 3000 / 50 / 0,04; DYN2 und DYN3 3000 / 50 / 0,03; DYN4 3000 / 55 / 0,016; DYN5 3000 / 60 / 0,016; DYN12 2000 / 45 / 0,016; DYN15/16/17 1000 / 30/35/40 / 0,016; DYN20–26 2000 / 50–80 / 0,02; **DYN60 5000 / 30 / 0,2** (Kommentar „Plastic“); DYN61 4000 / 45 / 0,05; DYN99 4000 / 45 bzw. B 30 / 0,04 („Plastic“); DYNvar nimmt `V.P.AccXYZ`, `V.P.AccAB`, `V.P.RampXYZ`, `V.P.RampAB`, `V.P.PathDev`. Alle 35 Dateien liegen in `maschine/sub/` (Kopie 09.11.2026).
- ✅ NC-Beispiel `maschine/nc-beispiele/2007-24__SA13.nc` (08.11.2026, CoCr Powder One Step): T4081/T4083/T4090 → LDYN1, T4085/T4086/T4088/T4089/T4098 → LDYN2, T4093 (Ø1,01) → LDYN12, **T4126 MKD (Ø2,01) → LDYN60**. Das ist die Tabelle Ti_Bar, obwohl das Material CoCr ist: Die Materialnamen wurden am 06.11.2026 umbenannt und standen nicht mehr in `hdmaterialtypes.ini`; vorher (Name `Remanium Star Powder One Step` = CoCr_Bar) lief nach Hedmill-Tabelle jedes Werkzeug Ø ≤ 2 auf LDYN60.
- ✅ **Befund zum MKD:** In jeder Stangenklasse von Hedmill lief der MKD mit DYN60: 50 % der B-Achsgrenze (5 000 °/s²), kürzeste Rampe (höchster Ruck aller Sätze), 0,2 mm zulässige Bahnabweichung bei einem Job mit CAM-Genauigkeit 0,01. Das ist der einzige Job mit Spitze auf der Achse (X 0), 5 500 °/min um B und Satzlängen bis 0,125°, und der einzige mit 50120/50121 (21-achsdynamik-50120.md). Die Kugel-Drehfräsjobs liefen bis 06.11. ebenfalls mit DYN60 ohne Meldung.
- ✅ **CAM-seitige Maßnahme (10.11.2026, Dateien fertig, Einsatz am CAM-PC steht aus):** `ldyn.cfg` korrigiert: MKD (`_201`) in allen Metallklassen → **LDYN17** (1 000 °/s² = 10 % der B-Grenze, Rampe 40, Bahnabweichung 0,016; Ruck ein Sechstel von DYN60), CoCr_Bar/Ti_Bar sonst wie die Blank-Klassen (DYN1/3/4/5/12), kein DYN60/DYN99 mehr in Metall. `hdmaterialtypes.ini` mit allen hyperDENT-Namen. Kontrolle im NC: nach `T4126 M6` muss `LDYN17` stehen.
- ✅ **Eigener Satz DYN18 (10.11.2026, Andreas):** `eigene-programme/DYN18` = Kopie von DYN14 (2 000 / 55 ms) mit `PATH_DEV 0.008` für Fertigjobs mit CAM-Genauigkeit 0,005 (T4092/T5062 Ø1,49, T4093/T5063 Ø1,01, Schlüssel `_149`/`_101` in `ldyn.cfg`). **Muss vor der neuen `ldyn.cfg` auf die Maschine, in denselben Ordner wie DYN17** (❓ vermutlich `C:\HMI\NCProg\sub\`, am Steuerungs-PC prüfen), sonst „Unterprogramm nicht gefunden“ beim Werkzeugwechsel. Beobachten: Abutment Job 7 T5062 „Friktion Drehfräsen“ (B-Drehfräsen wie der MKD, vorher DYN60).
- ✅ **Ergebnis 11.11.2026: Nacht 10./11.11. lief mit LDYN17 (NC geprüft), trotzdem 1 × 50120 (HF46, 5,8-fach) und 1 × 50121 (HF33, 4,0-fach). DYN17 allein reicht nicht; die Stelle ist der Konnektor-Knick im MKD-Job (21-achsdynamik-50120.md). DYN17 bleibt wegen der Oberfläche.** Ursprüngliche Erwartung: 50121 am MKD verschwindet, 50120 bei 0,01 bleibt aus. Ergebnis des ersten Teils hier und in 21-achsdynamik-50120.md eintragen. Bleibt die Warnung, ist es die Satzverarbeitung (Look-ahead 500 → 200 seit 30.10., CNC 4.34) und nicht der Dynamiksatz: dann `_201` → LDYN26 (2000/80/0,02) als Gegenprobe, danach MKD-Vorschub 5 500 → 4 000 °/min in der Vorlage, danach HEDS (Look-ahead). Nie: P-AXIS-00008/00441/00442 erhöhen.
- ❓ Rückfall auf Ti_Bar bei unbekanntem Namen ist Schlussfolgerung aus dem Vergleich, nicht aus dem PP-Code. Beweis: am Steuerungs-PC `C:\CNC\wp\1714-22__26_SA_5.nc` (Fehlerprogramm 01.11.) öffnen, Zeile nach `T4083 M6` lesen: `LDYN60` = CoCr_Bar-Tabelle war aktiv. Die NC-Programme im Ordner `OPEN MIND\nc` des CAM-PC sind Pi5-Programme, dafür unbrauchbar.
- ✅ Regel: Materialnamen in hyperDENT nie umbenennen oder neu anlegen, ohne `hdmaterialtypes.ini` nachzuziehen (`python3 tools/pp_check.py` im CAM-Repo); Hedmill-Updates überschreiben beide PP-Dateien, deshalb liegen die gültigen im CAM-Repo.
