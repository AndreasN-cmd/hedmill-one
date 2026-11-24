# Wärme in der Z-Kette: Spindelkühlung, Temperaturband, Längenmessung

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Log) · 🌐 allgemein (Physik, Rechnung) · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 24.11.2026 abends (Log 23./24.11. ausgewertet, Abschnitt 3a; Beckhoff-Update und Nullpunkte beantwortet, Abschnitt 6). Anlass: Aussage des HEDS-Technikers (Besuch zwei Tage, Woche 16.–20.11.2026), von Andreas am 24.11. weitergegeben.
> Was die Frässtrategien daraus machen (Warmlauf, Nur messen, Jobfolge): `../fraesstrategien-hyperdent/docs/drehfraesen_spindelwaerme.md` Abschnitt 9.

## 1. Aussage des Technikers (Andreas 24.11.2026)
- ✅ Die größte Ungenauigkeit der Z-Achse kommt von der **Spindelkühlung**. Das Kühlgerät regelt in einem **Temperaturband von 2 °C** „und nutzt das auch aus“.
- ✅ Über die Länge der Z-Achse seien das **16 µm** Längenunterschied. Schwer auszugleichen, außer mit einem großen Ausgleichsbehälter zwischen Kühlgerät und Maschine, der die Temperaturspitzen glättet. Andreas will den Behälter nur, wenn es ohne nicht geht.
- ✅ Seine zwei Rechnungen im Wortlaut: (1) `150 × 2 × 0,00001238 = 0,003714` · (2) `0,1638 geteilt durch 10 = 0,01638`.

## 2. Was die Rechnungen bedeuten
🌐 Längenänderung = Länge × Ausdehnungszahl × Temperaturänderung (ΔL = L · α · ΔT), α = 12,38 · 10⁻⁶ je °C ist Stahl.

| Rechnung | Länge L | je 1 °C | im 2-°C-Band | Lesart |
|---|---|---|---|---|
| 1 | 150 mm | 1,86 µm | **3,7 µm** | ❓ kurzes Stück nahe am Werkzeug (Spindel bzw. Spindelnase bis Lager); welches Bauteil, hat der Techniker nicht gesagt |
| 2 | ≈ 662 mm | 8,19 µm | **16,4 µm** | ❓ „Länge der Z-Achse“. 0,1638 mm sind 662 mm × 20 °C × α; durch 10 geteilt = 2 °C. Die 662 mm sind zurückgerechnet, nicht abgelesen |

- 🌐 Beim Drehfräsen (A0, G58) steht das Werkzeug senkrecht auf der Friktion: jede Längenänderung der Z-Kette geht 1 : 1 in den Radius, doppelt in den Durchmesser. 16 µm wären 32 µm im Durchmesser, also drei bis vier Nachfräs-Schritte am Sekundärteil.
- 🌐 Die 16 µm sind der Endwert, wenn die ganze Länge der Temperatur folgt. Ein massives Bauteil folgt langsam (Minuten bis Stunden); kurze Temperaturwechsel kommen nur gedämpft an (Abschnitt 5).

## 3. Was das Log dazu zeigt (✅ gemessen, `skripte/laengen_streuung_log.py`)
Jedes Werkzeug wird beim Holen und beim Abgeben im Stillstand angetastet. Die Änderung im Job (Abgabe) hat je Werkzeug einen festen Anteil (Spindelwärme nach Drehzahl) und eine Streuung von Teil zu Teil. Die Streuung ist alles, was nicht von der Drehzahl kommt: Kühlband, Raum, Taster.

Log 09.–12.11.2026 (399 Werkzeugeinsätze, Serien Primärteleskop):

| Werkzeug | Jobdauer | Änderung im Job (Median) | Streuung von Teil zu Teil | Ausreißer > 5 µm | Änderung bis zum nächsten Holen: Streuung |
|---|---|---|---|---|---|
| MKD T4126 (6 000) | 30 min | −12,1 µm | **1,4 µm** | 3 von 20 | 5,0 µm |
| T4085 (20 000) | 21 min | +5,1 | 2,0 | 3 von 25 | 5,5 |
| T4090 (14 000) | 8 min | +0,8 | 2,5 | 5 von 51 | 4,7 |
| T4098 (19 500) | 4 min | −0,2 | 1,7 | 0 von 42 | 4,3 |
| T4086 (22 000) | 3 min | +2,3 | 1,5 | 1 von 50 | 5,4 |
| T4088 (18 000) | 5 min | −0,1 | 0,4 | 0 von 26 | 5,2 |
| T4089 (40 000) | 4 min | +6,8 | 3,1 (zwei Jobarten gemischt) | 4 von 47 | 3,5 |

- ✅ **Innerhalb eines Jobs (bis 40 min) ist die Z-Kette auf ≈ 1,5–2,5 µm wiederholbar.** Beim MKD liegen 16 von 20 Jobs zwischen −10,8 und −14,3 µm. Schwankte die Kette in dieser Zeit mit 16 µm, läge die Streuung bei ≈ 6,5 µm (zwei zufällige Proben einer Dreieckschwingung: 0,41 × Spitze-Spitze). Zurückgerechnet aus 1,4–2,5 µm: **schneller Anteil ≈ 3–6 µm Spitze-Spitze**. Das passt zu Rechnung 1 (3,7 µm), nicht zu Rechnung 2.
- ✅ **Von Teil zu Teil (≈ 1–1,5 h) wandert sie mit ≈ 5 µm Streuung** (alle Werkzeuge gleich, darin steckt auch das neue Einspannen im Kegel). Als langsame Schwingung gelesen sind das ≈ 12 µm Spitze-Spitze: Größenordnung von Rechnung 2.
- ✅ **Über Nacht noch mehr:** alle Längen gemeinsam −35 … −39 µm in 14 h (13./14.11., `13-offene-fragen.md`). ❓ Mit 8,19 µm je °C wären das 4,4 °C: passt zu einem Kühlgerät, das der Raumtemperatur folgt (Nachtabsenkung), ist aber nicht belegt.
- ✅ Einzelne Ausreißer gibt es (MKD einmal +7,2 statt −12, also 19 µm daneben; 10–15 % der langen Jobs liegen > 5 µm neben dem Median). ❓ Ursache offen: Schaltpunkt des Kühlgeräts, Span am Taster oder Kegel.
- ✅ Die Logs 09.–12.11. stammen aus der Zeit vor Warmlauf und „Nur messen“. Gegenprobe mit dem Log 23./24.11.: Abschnitt 3a.

## 3a. Log 23./24.11.2026 (✅ gemessen: elf Primärteleskope CAM V5.74 mit Warmlauf, 23.11. 18:05 bis 24.11. 20:45, HMI-Log in `maschine/log/`)
| Werkzeug | in der Spindel | Änderung im Job nach Warmlauf/Messen (Median) | Streuung von Teil zu Teil | Warmlauf selbst (kalt → warm, Median und Spanne) |
|---|---|---|---|---|
| MKD T4126 (6 000) | 20 min | **−4,8 µm** | 2,7 µm (2 von 11 > 5 µm daneben) | 8 min: −12,3 (−4,8 … −14,4) |
| T4089 (40 000) | 18 min | +0,6 | 0,9 | 4 min: +9,2 (+8,1 … +9,7); 4 min später noch +2,5 (+1,5 … +4,9) |
| T4098 (19 500) | 7 min | +0,3 | 0,8 | 4 min: +0,5 (−0,8 … +1,0) |
| T4086 (22 000) | 5 min | +1,1 | 1,2 | 4 min: +3,3 (+2,6 … +4,2) |
| T4088 / T4090 / T4085 / T4081 / T4083 | 4–7 min | +0,2 / −1,9 / +1,5 / −1,5 / +2,4 | 0,7 / 1,0 / 1,5 / 1,7 / 2,1 | ohne Warmlauf |

- ✅ **Im Job bleibt die Z-Kette auch mit Warmlauf auf 0,7–2,7 µm wiederholbar** (vorher 1,4–2,5). Beim Holen streut sie 2,5–9 (≈ 5) µm. Abschnitt 4 gilt unverändert.
- ✅ **Gemeinsame Drift im Dauerlauf:** von Teil 2 bis Teil 11 (22 h) werden alle Werkzeuge 25–32 µm kürzer (T4081 −25, T4085 −28, T4088 −32, T4089 −25, T4090 −25), ≈ −3 µm je Teil. Jedes Antasten nimmt das mit.
- ✅ **MKD nach dem Ø0,6-Ring (40 000 → 6 000):** beim Holen +12,7 µm gegen die letzte Abgabe, im 8-min-Warmlauf −12,3, danach im Job noch −4,8 (−0,3 … −13,4). Mit 4 min Warmlauf (Log 20./21.11., vier Teile) im Job −4,7 / −4,4 / +3,8 / −8,4. **8 min bringen gegen 4 min nichts Messbares:** das Abkühlen hat einen schnellen Teil (≈ −12 µm, nach 4 min durch) und einen langsamen Rest (≈ −0,4 µm je Minute), den auch 8 min nicht holen. Die Abklingzeit „3–4,5 min“ aus Abschnitt 4 gilt nur für den schnellen Teil.
- ✅ T4098 ändert sich im Warmlauf nicht (kein Drehzahlsprung davor), T4086 um +3,3 µm, T4089 um +9,2 und in weiteren 4 min um +2,5 µm.
- ❓ **Zweiter MKD (seit 23.11., der erste nach ≈ 100 Teilen bei Hufschmied, Andreas 24.11.):** `skripte/laengen_trend_log.py` (neu): seine Länge beim Holen fällt von Teil 2 bis 11 um 46 µm (−5,1 je Teil), die anderen Werkzeuge −2,7 … −3,5, T4083 −4 … −5, T4086 0. Nicht eindeutig: der erste MKD zeigte am 09./10.11. dasselbe (−34 µm in fünf Teilen, danach +15 in neun). Das Log belegt weder Verschleiß noch Ausbruch.

## 4. Was das Antasten ausgleicht und was nicht
| Anteil der Z-Kette | Größe | Zeit | ausgeglichen durch |
|---|---|---|---|
| Kühlband, langsam (Rechnung 2) und Raumtemperatur | bis 16 µm im Band, über Nacht bis ≈ 36 µm | Stunden | ✅ jedes Antasten (bei jedem Werkzeugwechsel, nach jedem Warmlauf, bei „Nur messen“): der Stand zum Messzeitpunkt ist in der Länge |
| Kühlband, schnell (Rechnung 1) | ≈ 3–6 µm Spitze-Spitze | Minuten | ❌ nicht (zu schnell); bleibt als ≈ ± 2 µm in jeder Fläche |
| Spindelwärme nach Drehzahlsprung | T4089 +10 … +13 µm, MKD −12 … −16 µm | Abklingzeit 3–4,5 min | ✅ Warmlauf auf Jobdrehzahl + Nachmessen (eigene Unterprogramme `WARMT…`, `MESST…`); Rest im Job ≤ 1 µm, **beim MKD ≈ 5 µm (langsamer Teil, auch nach 8 min, Abschnitt 3a)** |
| Lage des Tasters gegen die B-Achse (Werkstück) | ❓ unbekannt | ❓ | ❌ Antasten sieht das nicht. Prüfbar nur am Teil: Kontroll-Tonne morgens kalt und nach langem Dauerlauf (`13-offene-fragen.md`) |
| Spindel läuft gegen Spindel steht (Lager, Fliehkraft) | ❓ unbekannt, je Drehzahl fest | sofort | ❌ gemessen wird im Stillstand. Fester Betrag je Werkzeug, gehört ins Aufmaß (CAM) |

- 🌐 Folge: Nach dem Antasten zählt nur, was sich **bis zum Ende des Schnitts** noch ändert. Langsame Drift ≈ 0,04–0,07 µm je Minute (aus −36 µm in 14 h bzw. 5 µm Streuung je Teil) → in einem 15-min-Job ≈ 1 µm.
- 🌐 Ein Ausgleichsbehälter würde nur den schnellen Anteil glätten, also die ≈ 3–6 µm. Nach den Zahlen oben lohnt er nicht, solange vor jeder Passfläche angetastet wird.

## 5. Rechnung Ausgleichsbehälter (falls er doch kommt)
🌐 Ein durchströmter Behälter mit Volumen V (Liter) und Durchfluss Q (Liter je Minute) hat die Zeitkonstante τ = V / Q. Eine Temperaturschwingung mit der Periode P (Minuten, von Einschalten zu Einschalten des Kühlgeräts) kommt dahinter mit dem Faktor 1 / √(1 + (2π · τ / P)²) an.

| τ = V / Q | P = 5 min | P = 10 min | P = 20 min | P = 40 min |
|---|---|---|---|---|
| 2 min (z. B. 10 l bei 5 l/min) | 0,37 | 0,62 | 0,85 | 0,95 |
| 5 min (25 l bei 5 l/min) | 0,16 | 0,30 | 0,54 | 0,79 |
| 10 min (50 l bei 5 l/min) | 0,08 | 0,16 | 0,30 | 0,54 |
| 20 min (100 l bei 5 l/min) | 0,04 | 0,08 | 0,16 | 0,30 |

- ❓ Zum Auslegen fehlen zwei Zahlen vom Kühlgerät: Durchfluss (Typenschild oder Anzeige) und die Zykluszeit (Stoppuhr: von Kompressor ein bis zum nächsten Kompressor ein, einmal bei laufender Spindel mit 40 000 und einmal mit 6 000 min⁻¹).
- 🌐 Ohne Umbau wirkt ein engeres Schaltband am Kühlgerät genauso (1 °C statt 2 °C halbiert alles), falls es sich einstellen lässt und der Kompressor das häufigere Schalten verträgt. ❓ Beim Hersteller des Kühlgeräts bzw. HEDS nachfragen; nichts selbst verstellen.

## 6. Beckhoff-Update (Andreas 24.11.2026)
- ✅ Andreas: Beckhoff hat in der Woche des Technikerbesuchs ein Update herausgebracht, das das Drehfräs- und B-Achs-Beschleunigungsproblem (50120/50121, `21-achsdynamik-50120.md`) vollständig lösen soll. Andreas geht deshalb in den Frässtrategien zurück auf die alte Drehfräs-Geschwindigkeit und will Genauigkeit 0,005 probieren.
- ✅ **Andreas 24.11. abends: Das Beckhoff-Update ist seit 17.11.2026 installiert; was es genau ändert, ist nicht bekannt.** Nullpunkte und Längenoffset sind unverändert, der Techniker hat mechanisch nichts verändert.
- ✅ `LoggedEvents.db` (08.11. bis 24.11. 21:09): 50120/50121 am 08.–11.11. je Tag 12–16, am 13.11. 4, **seitdem keine mehr**, auch nicht in den elf Teleskopen vom 23./24.11. Gelaufen sind seit dem Update aber nur die schonenden MKD-Werte (5 600 °/min, Ende 1 mm vor dem Pol); die schnelleren Werte der CAM V5.77 (gebaut 24.11.: 8 000 °/min, bis zum Pol, Genauigkeit 0,005) sind damit nicht geprüft.
- ❓ CNC-Version nach dem Update: im Ereignisprotokoll steht nur ein Versionseintrag (08.11.: 4.34.0-x64), keiner nach dem 17.11. Liegen die eigenen Unterprogramme noch in `C:\HMI\NCProg\sub\`? ✅ ja, alle `WARMT…`/`MESST…` der V5.74 liefen am 23./24.11.

## 7. Nächste Schritte ohne Eingriff
1. ✅ Erledigt 24.11.: Log 23./24.11. ausgewertet (Abschnitt 3a). CAM V5.77 (24.11.) nimmt den Warmlauf an T4086 und T4098 wieder heraus und setzt den MKD auf 4 min (`WARMT4126S6000DYN17`); die Unterprogramme `WARMT4086S22000DYN4`, `WARMT4098S19500DYN4` (CoCr-Abutment nutzt es weiter) und `WARMT4126S6000DYN17MIN8` bleiben auf der Maschine. Nach den ersten V5.77-Teilen wieder `LOGS_SAMMELN`, dann `werkzeug_warm_log.py`, `laengen_streuung_log.py`, `laengen_trend_log.py` und die Zählung 50120/50121 (neue MKD-Werte).
2. Beim nächsten Kontakt mit HEDS: Welches Bauteil sind die 150 mm, welche Länge die „Z-Achse“; regelt das Kühlgerät auf einen festen Wert oder gegen die Raumtemperatur; gibt es eine Wärmekompensation der Z-Achse in der Steuerung?
3. Zwei Zahlen vom Kühlgerät (Durchfluss, Zykluszeit), nur falls der Behälter wieder Thema wird.
