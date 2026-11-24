# Wärme in der Z-Kette: Spindelkühlung, Temperaturband, Längenmessung

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Log) · 🌐 allgemein (Physik, Rechnung) · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 24.11.2026. Anlass: Aussage des HEDS-Technikers (Besuch zwei Tage, Woche 16.–20.11.2026), von Andreas am 24.11. weitergegeben.
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
- ❓ Die Logs 09.–12.11. stammen aus der Zeit vor Warmlauf und „Nur messen“. Für die Zeit danach liegt kein Log auf dem Mac; Gegenprobe mit dem nächsten `LOGS_SAMMELN` (gleiches Skript).

## 4. Was das Antasten ausgleicht und was nicht
| Anteil der Z-Kette | Größe | Zeit | ausgeglichen durch |
|---|---|---|---|
| Kühlband, langsam (Rechnung 2) und Raumtemperatur | bis 16 µm im Band, über Nacht bis ≈ 36 µm | Stunden | ✅ jedes Antasten (bei jedem Werkzeugwechsel, nach jedem Warmlauf, bei „Nur messen“): der Stand zum Messzeitpunkt ist in der Länge |
| Kühlband, schnell (Rechnung 1) | ≈ 3–6 µm Spitze-Spitze | Minuten | ❌ nicht (zu schnell); bleibt als ≈ ± 2 µm in jeder Fläche |
| Spindelwärme nach Drehzahlsprung | T4089 +10 … +13 µm, MKD −12 … −16 µm | Abklingzeit 3–4,5 min | ✅ Warmlauf auf Jobdrehzahl + Nachmessen (eigene Unterprogramme `WARMT…`, `MESST…`); Rest im Job 1–3 µm |
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
- ❓ Offen: Ist das Update auf der Maschine installiert (Datum, CNC-Version; bisher 4.34.0)? Hat der Techniker Nullpunkte oder den Längenoffset angefasst (Tabelle vorher/nachher, `02-koordinaten-nullpunkte.md`)? Liegen die eigenen Unterprogramme (`WARMT…`, `MESST…`, `DYN18`) noch in `C:\HMI\NCProg\sub\`? Eintrag in `12-aenderungsprotokoll.md` folgt mit Andreas' Antwort.
- ❓ Prüfbar nach den ersten Teilen: `LoggedEvents.db` auf 50120/50121 (Skript `loggedevents_dump.py`), CNC-Version im Startprotokoll.

## 7. Nächste Schritte ohne Eingriff
1. **Log vom 23.11.2026 holen** (`LOGS_SAMMELN`; neun Primärteleskope mit CAM V5.74, erste Teile mit 8 min MKD-Warmlauf und den vier neuen Unterprogrammen). Am Mac `python3 -I skripte/werkzeug_warm_log.py <Ordner> 4126,4089,4098,4086`: Frage Andreas 24.11., ob 8 min gegen 4 min etwas bringen (MKD im Job ≈ −1 … −3 µm = ja, weiter −4 … −8 = nein); dazu `python3 -I skripte/laengen_streuung_log.py <Ordner>`: bleibt die Streuung im Job bei ≈ 2 µm, auch mit Warmlauf? Und `loggedevents_dump.py`: 50120/50121 seit dem Technikerbesuch?
2. Beim nächsten Kontakt mit HEDS: Welches Bauteil sind die 150 mm, welche Länge die „Z-Achse“; regelt das Kühlgerät auf einen festen Wert oder gegen die Raumtemperatur; gibt es eine Wärmekompensation der Z-Achse in der Steuerung?
3. Zwei Zahlen vom Kühlgerät (Durchfluss, Zykluszeit), nur falls der Behälter wieder Thema wird.
