# Werkstückwechsler (Changer) / Automatisierung

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

### Aufbau
- ✅ Magazin (Wechsler) mit 7 Blankpositionen in einer Reihe, Raster ca. 35–36 mm in X; zusätzlich Rundwechsler (Drehteller, „RC“) mit Positionen 101–130, geholt über einen Lift (Blankhubzylinder, M92 heben / M93 senken, SPS `stRotaryChanger.stLifter`) an Position 5 (`V.E.RotaryChangerAvailable`)
- ✅ `V.E.BlankPos[0]` = Position in der B-Achse (Nullpunktspannsystem), `V.E.BlankPos[1..7]` = Magazinplätze
- ✅ Plätze 1–5 aktuell ausgeschaltet („mit Drehteller unten“), Plätze 6 und 7 aktiv
- ✅ Preformhalter haben im Magazin eine eigene, deutlich niedrigere Position als Rondenhalter; ❓ Höhenunterschied nicht gemessen
- ✅ Greifer: separater Arm neben der Spindel (Blankgreifer mit Hubzylinder), wird ausgefahren, Feinpositionierung über Z, greift mit zwei Fingern; kein Werkzeug, keine T-Nummer; Greiferstellung wird über einen Analogsensor überwacht
- ✅ Pos 7: nach dem Greifen/Ablegen 5 mm nach links (V.L.SafeOffsetXPos7 = −5), um die Faltenbalg-Lamellen nicht zu beschädigen

### Positionswerte (live ausgelesen mit LASERCHECK_LESEN.nc am 01.11.2026, 18:43)

| Platz | X | Y | Z |
|---|---|---|---|
| 0 (B-Achse) | −6,3 | 109,2 | 129 |
| 1 | −144,95 | −202,9 | 73,5 |
| 2 | −109,77 | −203,05 | 73,5 |
| 3 | −74,6 | −203,2 | 73,5 |
| 4 | −39,4 | −203,35 | 73,5 |
| 5 (RC-Lift) | −5,2 | −203,5 | 85 |
| 6 | 31 | −203,65 | 73,5 |
| 7 | 67,1 | −203,8 | 73,5 |

- ✅ BC_CheckPosOffset: X 5 / Y −18 / Z 0 → Laser-Messpunkt liegt X +5 / Y −16 (inkl. PickBlankOffset Y 2) neben dem Platz-Mittelpunkt
- ✅ PickBlankOffset: X 0 / Y 2 / Z 3,5; CHolderYPosOffset 12; CHolderCheckDif 25
- ✅ Laserwert in Ruhelage (nach LASERCHECK): 478

### Laser-Prüfung (checkBlankAtPos V1.1.0, 03.09.2026)
- ✅ EIN Messpunkt pro Platz für ALLE Haltertypen – kein eigener Messpunkt für Preform oder Ronde
- ✅ Messpunkt X/Y = `V.E.BlankPos[n].X/Y` + `V.E.BC_CheckPosOffset.X/Y` + `V.P.PickBlankOffset[0/1]`
- ✅ Z fährt ganz hoch (`V.A.+SWE.Z-1`); `V.L.BC_PosZ` wird berechnet, aber nicht angefahren → der Laser misst von oben
- ✅ Die Fenster werden zu Beginn von checkBlankAtPos im `#VAR`-Block in die lokalen Variablen `V.L.ZLaserMinValue[0..3]` / `V.L.ZLaserMaxValue[0..3]` kopiert; diese lokalen Werte stehen auch in der Log-Zeile (min/max)
- ✅ Laserwert: kleiner Wert = höheres Objekt (näher am Laser); ❓ Einheit des Laserwerts unbekannt
- ✅ Ablauf: Klappe auf (M61) → X/Y auf Messpunkt → 0,5 s warten → `V.E.SensorZLaser` lesen → Vergleich mit Fenstern
- ✅ Messfenster Magazin `machinePara.stBlankChange.stCheckPosZLaser1[n]` (Stand 01.11.2026 abends):
  - [0] LEER: 648–720
  - [1] LEER mit Preformbasis: 615–645
  - [2] Preformhalter: 565–620 (überlappt mit [1] bei 615–620; [2] wird zuerst geprüft)
  - [3] Blankhalter (Ronde): **480**–545 (bis 01.11.2026: 505–545)
- ✅ Messfenster B-Achse (checkBlankInB, `stCheckPosZLaser0`): Spannsystem LEER 615–645, Preformhalter 570–614; ❓ Blankhalter-Fenster [3] der B-Achse noch nicht ausgelesen
- ✅ checkBlankInB: Messung bei A-90, B = `V.E.BPosTo.OpenSystem`, X/Y = BlankPos[0] + BC_CheckPosOffset (ohne PickBlankOffset); Prüfreihenfolge [3] Blankhalter (+ C-Halter-Prüfung nur wenn ExpectedBlankTyp == 6) → [2] Preformhalter → [0] LEER → sonst 5; [1] ist auskommentiert
- ✅ Gemessene Werte 01.11.2026: Preformhalter Platz 6 = 605–606; Platz 6 nur Preformbasis = 634; B-Achse leer = 633–634; B-Achse mit Preformhalter = 601; Rondenhalter Platz 7 = 498 (reproduzierbar)
- ✅ Prüfreihenfolge Magazin: [3] → [2] → [1] → [0] → sonst Ergebnis 5 „undefinierter Messwert“ + M199 (Programm bleibt in Störung stehen)
- ✅ Bei Treffer [3] immer C-Halter-Prüfung: Y um CHolderYPosOffset (12) versetzen, 2. Messung; ist sie größer als 1. Messung + CHolderCheckDif (25) → C-Halter (6), sonst Blankhalter (1)
- ✅ Ergebnis an SPS: FunctionNumber = 3000 + Platz, FunctionValue = Code; danach „Warte auf SPS-Rueckmeldung“ bis SPS FunctionNumber auf 0 setzt
- ✅ Jede Prüfung schreibt eine Zeile ins Log mit Messwert und min/max des getroffenen Fensters (bei undefiniert nur den Messwert)
- ✅ Nach dem Ablegen ins Magazin (giveBlankInChanger) wird mit checkBlankAtPos per Laser kontrolliert, ob der erwartete Haltertyp (`V.L.BlankPosCheckedInB`) jetzt auf dem Platz liegt; bei Abweichung Fehler 900 + M199, sonst Hinweis 920 „erfolgreich im Wechlser abgelegt“; beim Rundwechsler wird dafür Platz 5 geprüft

### Ablauf blankChange (Hauptprogramm, V1.3.0 vom 03.09.2026)
1. „BlankChange wurde aufgerufen“; `BlankRequest.Pos == -1` → Ende; SAFEPOS, DYN-Standard, cleanBAxis, cleanWS
2. Haltertyp in der Maschine aus der Artikelnummer → `V.L.HolderTypM` (1/2/6) → `V.P.ExpectedBlankTyp`
3. **checkBlankInB** (Laser B-Achse) → `V.P.BlankPosChecked`; 0 → Fehler 601, 5 → Fehler 603; Ergebnis wird in **`V.L.BlankPosCheckedInB` gemerkt**
4. Plausibilität: Request == InMachine und Typ passt → Ende; Halter soll da sein, Laser sagt LEER (4) → 610 + M0 (weiter mit START); kein Halter erwartet, aber 1/2 gemessen → 611 M199
5. Gültigkeitsbereich der Blankposition (1–7 bzw. 101–130), UP_CheckBeforeStart (Kassette, Loadertür M51)
6. **[Label_Unload]**: BlankPosChecked == 4 → direkt zu Load. Sonst cleanBlank (Blank-/C-Halter zusätzlich 2. Seite bei B180), Reinigungsluft
7. Zielplatz prüfen: `V.P.BlankPosToCheck = BlankInMachine.Pos` → checkBlankAtPos (bzw. checkBlankAtPosRC). Belegt (1, 2, 3 bei Blankhalter, 4 bei Preform ohne Basis) → FindNextFreeBlankPos → FunctionNumber 3200 an SPS → BlankInMachine.Pos muss dem neuen Platz entsprechen
8. **`V.P.BlankPosChecked = V.L.BlankPosCheckedInB`** (Ergebnis aus Schritt 3 wiederherstellen!) → `L getBlankFromB` → `L giveBlankInChanger`
9. **[Label_Load]**: BlankRequest.Pos <= 0 → Ende. Haltertyp aus Artikelnummer → `V.L.HolderTypC`; Platz prüfen (checkBlankAtPos / RC); passt nicht (und nicht 3 bei Preform) → 617 + M0 → erneut
10. **[Label_GET]**: `L getBlankFromChanger` → `L giveBlankInB` → checkBlankInB als Kontrolle (≠ HolderTypC → Fehler 900 M199)
11. **[Label_End]**: FunctionNumber 6000 / Value −1, Z hoch, X −120, SAFEPOS, Klappe zu (M62); bei IBNactive == FALSE zusätzlich AB-Null; `V.P.BlankchangeDone = 1`; „BlankChange wurde abgearbeitet“
- ✅ `V.L.DontUseLaser = 0` fest im Programm (Laserprüfung aktiv); bei 1 werden die Codes aus der Artikelnummer gesetzt
- ✅ Folge für das Ablegen ins Magazin: welcher Z-Zweig in giveBlankInChanger läuft, entscheidet ausschließlich das checkBlankInB-Ergebnis vom Anfang (Schritt 3), nicht die Platzprüfung (Schritt 7); bei Andreas' Problem vom 03.11.2026 erkennt die Maschine den Preform korrekt (Preform-Zweig läuft)
- ✅ In blankChange steht ein auskommentierter „1.2.7 VORSCHLAG“-Block (Ablagekontrolle mit Fallunterscheidung Rundwechsler) – Herstellerstand, nicht aktiv

### Weitere Offsets (NC-seitig)
- ✅ setVPVars (NC-Textdatei, Zeile 26–28 / 34–39): PickBlankOffset = [0, 2, 3.5]; **ZOffsetPreformC = −26.2** (seit 03.11.2026 ca. 17:15; 01.–03.11. −28.2; vorher −17.7); ZOffsetGetPreform = 8; ZOffsetPreformM = −80.5 (vorher −79.1); PlaceBlankOffset = PickBlankOffset
- ✅ setVPVars001: CHolderCheckDif = 25, CHolderYPosOffset = 12,0
- ✅ getBlankFromChanger Z. 99/100 (lokal): `V.L.PosZPrePickOffset = 20` (Anfahrhöhe darüber, für alle Halter), `V.L.PosZPickOffset = -4` (seit 01.11.2026, vorher 0; Zusatz-Offset Greifhöhe NUR für Blank-/C-Halter aus den Magazinplätzen 1–7, wirkt nur in Z. 213; nicht für Preform, nicht Rundwechsler, nicht Ablegen, nicht B-Achse)
- ✅ Vorsicht Namensähnlichkeit: PosZ**Pre**PickOffset (20, Vorposition) ≠ PosZPickOffset (Greifhöhe)
- ✅ giveBlankInChanger: PosZPreOffset = 20 (Anfahrhöhe nach dem Ablegen); Blankhalter-Ablegehöhe = PlacePosZ ohne eigenen Offset; Preform-Ablegehöhe = PlacePosZ + ZOffsetPreformC ohne eigenen Offset (Stand Hersteller)
- ✅ giveBlankInB: `V.L.PosZPlaceOffset = -5` (Ablegehöhe Blankhalter in B-Achse: BlankPos[0].Z − 5 = 124)
- ✅ `V.E.BlankPos[n].Z` wird in KEINEM NC-Programm gesetzt; `V.E.BlankPos[n].X/Y` berechnet SetupChanger nur, wenn `V.L.CalcBlanlkPos = TRUE` (aktuell FALSE)

### M-Befehle Wechsler (aus Kommentaren der Unterprogramme)
- M5 Frässpindel aus · M9 Kühlmittelpumpe aus
- M35 Messzylinder einfahren · M79 Powerclamp einfahren
- M38 / M39 3D-Messtaster ein / aus
- M50 Loadertür entriegeln · M51 verriegeln
- M61 Wechslerklappe öffnen · M62 schließen
- M80 Blankklemmung (B-Achse) öffnen · M81 schließen · M88 Booster Blankklemmung aktivieren
- M82 Blankgreifer-Hubzylinder senken · M83 heben
- M84 Blankgreifer öffnen (M84=100: Quittierung auch bei Misserfolg) · M85 schließen + auf „nicht offen“ prüfen · M85=1 auf „gegriffen“ prüfen · M85=2 prüfen ob abgelegt
- M86 / M87=<ms> Reinigungs-/Sperrluft Greifer verzögert ein / aus
- M90 Rundwechsler positionieren · M91 warten bis Position erreicht
- M92 Blankhubzylinder Rundwechsler heben · M93 senken (M93=-100 = direkte Quittierung)
- M107 Absaugung aus
- M111 / M112 Reinigungsluft Kassette aus / ein
- M118 / M119 Ausblasen Kavität aus / ein
- M130 Reinigungsluft B-Achse Spannsystem Intervall EIN · M131 / M132 B-Achse Reinigungsluft aus / ein
- M198 Werkzeugplatznummer an SPS übergeben (M6)
- M199 Störung auslösen · M17 Unterprogrammende

### Ablauf getBlankFromChanger (Version 1.2.0 vom 04.09.2026)
1. Klappe auf (M61), Greifer-Hubzylinder heben (M83), Z hoch + Greifer öffnen (M84)
2. X/Y auf PickPosX/Y
3. Greifer-Hubzylinder senken (M82)
4. Preformhalter (`V.P.BlankPosChecked == 2`):
   - Z. 207: `G01 Z= V.L.PickPosZ + V.L.PosZPrePickOffset` (Vorposition 20 mm darüber)
   - Z. 208: `G01 Z= V.L.PickPosZ + V.P.ZOffsetPreformC + V.P.ZOffsetGetPreform` (FEEDMEASURE) → Schließhöhe
   - Z. 209: M85 Greifer schließen
   - Z. 210: `G01 Z= V.L.PickPosZ + V.P.ZOffsetPreformC` („auf Holen-Position fahren“ – 8 mm tiefer, mit geschlossenem Greifer, Halter sitzt dabei noch im Magazin)
   - Rundwechsler-Zweig identisch mit `V.L.PickPos6Z` (BlankPos[6].Z)
5. Blankhalter (sonst):
   - Z. 212: `G01 Z= V.L.PickPosZ + V.L.PosZPrePickOffset` (identisch mit Z. 207!)
   - Z. 213: `G01 Z= V.L.PickPosZ + V.L.PosZPickOffset`
6. Z. 271 M85 Greifer schließen, Z hoch, M85=1 (gegriffen? – Sicherheitsnetz: sonst Störung), Y +3, Hubzylinder heben, bei Pos 7 X −5
7. Rundwechsler: UP_StartPosRC (M93 Lift unten prüfen, FunctionNumber 3500, M90) → UP_RCPosArrived (M91) → UP_LiftIsOnTop (M92, bei FeedbackMFunc −92 → M199)

### Ablauf giveBlankInChanger (ablegen, Version 1.2.0 vom 04.09.2026)
1. Rundwechsler: Lift unten prüfen (M93), Drehteller positionieren (FunctionNumber 3500, M90)
2. Klappe auf (M61), ToolWeightOff, Z hoch (FEEDSLOW)
3. PlacePosX/Y/Z berechnen = BlankPos[Platz] + PlaceBlankOffset; X/Y anfahren, dabei Y + 3
4. Greifer-Hubzylinder senken (M82), dann Y auf PlacePosY (FEEDSLOW)
5. Z nach unten – **genau zwei mögliche Höhen im Magazin**:

   | `V.P.BlankPosChecked` | Zeile | Z (Platz 6/7) |
   |---|---|---|
   | == 2 (Preformhalter) | `G01 Z= V.L.PlacePosZ + V.P.ZOffsetPreformC` (ohne F → FEEDSLOW modal) | **50,8** (mit −26.2; vorher 48,8) |
   | alles andere (1, 3, 4, 6 …) | `G01 Z= V.L.PlacePosZ FV.E.FEEDMEASURE` | **77,0** |

   - ✅ Rundwechsler: Z auf PlacePos5Z + 20, M91 warten, M92 Lift heben; Preform (== 2): `G01 Z= V.L.PlacePos6Z + V.P.ZOffsetPreformC` (BlankPos[6].Z, Programmkommentar: Greifhöhen Preform im Wechsler und RC-Lift gleich hoch) = wie Magazin; Blank-/C-Halter: Z = PlacePos5Z (FEEDMEASURE) = 88,5
   - ✅ Kein platzabhängiger Preform-Wert, keine Werkzeuglänge (MCS) – andere Höhen als diese zwei sind im Code nicht möglich
   - ✅ Die Preform-Ablegehöhe liegt immer 8 mm UNTER der Schließhöhe beim Holen (= `ZOffsetGetPreform`) – Ursache des „zu tief“ vom 03.11.2026
6. Greifer öffnen M84=100 → `G01 G91 Z2 F500` (2 mm hoch gegen Verklemmen; VersionsInfo V1.0.8 nennt 4 mm) → M84 → Hubzylinder heben (M83)
7. Pos 7: X −5; dann Z auf PlacePosZ + 20 (FEEDMEASURE); M85=2 (prüfen ob Greifer leer)
8. Laserkontrolle des Platzes (checkBlankAtPos mit `V.P.ExpectedBlankTyp = V.L.BlankPosCheckedInB`), Rundwechsler: M93 Lift senken, bei Preform/Blank zusätzlich `V.E.HWInput.PreformHolderOnPlace` prüfen („fehlerhaft abgelegt“ → 900 + M199)
9. Z hoch (FEEDMAX), BlankInGripper leeren, BlankChangeActiveNo = 80
- ✅ Wird giveBlankInChanger außerhalb von blankChange aufgerufen (direkt/manuell), gilt `V.P.BlankPosChecked` der zuletzt gelaufenen Laserprüfung – z. B. 3 „nur Preformbasis“ nach einer Platzprüfung → Z 77 statt Preform-Höhe

### Ablauf B-Achse (getBlankFromB / giveBlankInB)
- ✅ getBlankFromB Preform: Sperrluft M86=2000, schließen bei `BlankPos[0].Z + ZOffsetPreformM + ZOffsetGetPreform` (= 129 − 80,5 + 8 = Z 56,5, FEEDMEASURE), M85, dann runter auf `BlankPos[0].Z + ZOffsetPreformM` (= Z 48,5) – die Klemmung (M80) öffnet erst NACH dem M85=1, der Halter ist beim 8-mm-Nachfahren also noch gespannt; Blankhalter: M86, Z = BlankPos[0].Z (= 129); danach M87=500, M85=1, M80 Klemmung auf, Z hoch + M83, M81 Klemmung zu
- ✅ giveBlankInB Preform (`BlankPosChecked == 2 oder 3`): Hubzylinder senken, Z = `BlankPos[0].Z + ZOffsetPreformM + 30` (= Z 78,5, FEEDMEASURE), Klemmung zu (M81), Reinigungsluft M132 + B ±2700° F30000, M131, Klemmung auf (M80), Z = `BlankPos[0].Z + ZOffsetPreformM` (= Z 48,5), Klemmung zu, Greifer öffnen + 2 mm hoch
- ✅ giveBlankInB Blankhalter: erst Reinigung (Klemmung zu, B-Rotation), dann Klemmung auf, Hubzylinder senken, Z = `BlankPos[0].Z + V.L.PosZPlaceOffset` (= 129 − 5 = Z 124, FEEDMEASURE)
- ✅ Nach dem Absetzen: Z hoch (FEEDMAX) + M83, M85=2, B auf `V.E.BPosTo.BoostSystem`, M88 Booster; B-Positionen aus SPS: `V.E.BPosTo.OpenSystem` (A-90) und `V.E.BPosTo.BoostSystem`
- ✅ B-Achse funktioniert mit den aktuellen Werten (Andreas, 03.11.2026) → `ZOffsetGetPreform` und `ZOffsetPreformM` nicht anfassen

### Konstruktionsmuster Preform greifen
- ✅ In Wechsler UND B-Achse gleich: Greifer schließt 8 mm (ZOffsetGetPreform) über der End-/Holen-Position, fährt dann geschlossen 8 mm nach unten; Ablegen fährt jeweils auf die Holen-Position (ohne die +8)
- ❓ Was beim 8-mm-Nachfahren physisch passiert (Greifer rutscht am Halter / drückt), ist nicht bekannt; Andreas hält „Greifer rutscht“ für unwahrscheinlich; ihn stört das Nachfahren, er will es aber vorerst nicht im Programm abschalten

### Greifhöhe – Formel und Werte
- ✅ `V.L.PickPosZ = V.E.BlankPos[Pos].Z + V.P.PickBlankOffset[2]` (Ablegen identisch mit PlaceBlankOffset[2] = 3,5)
- ✅ Preform im Magazin (BlankPos Z 73,5, PickBlankOffset Z 3,5), Formel: schließen bei 77 + ZOffsetPreformC + 8, Holen-/Ablegeposition 77 + ZOffsetPreformC

  | ZOffsetPreformC | gültig | Schließhöhe | Holen-/Ablegeposition |
  |---|---|---|---|
  | −17.7 | bis 01.11.2026 (Hersteller) | 67,3 | 59,3 |
  | −28.2 | 01.–03.11.2026 | 56,8 | 48,8 |
  | **−26.2** | ab 03.11.2026 ca. 17:15 | **58,8** | **50,8** |

  - (Korrektur 03.11.2026: in einer früheren Fassung stand 60,3 / 70,8 – Rechenfehler, es wurde 11,5 statt 8 addiert)
- ✅ Rondenhalter im Magazin: Greifhöhe Z 73,0 (= 73,5 + 3,5 − 4); vorher Z 77,0; Ablegehöhe Rondenhalter Z 77,0 (PlacePosZ, kein Offset)
- ✅ Preform B-Achse: schließen Z 56,5, Holen-/Ablegeposition Z 48,5; Blankhalter B-Achse: holen Z 129, ablegen Z 124
- ✅ Es gibt KEINEN eigenen Preform-Z-Wert pro Magazinplatz. Der Programmkommentar (Z. 249–251) sagt selbst, dass dafür ein weiterer Offset nötig wäre.
- ✅ Wirkung der Stellschrauben:
  - `V.E.BlankPos[n].Z` (SPS machinePara): nur Platz n, aber alle Haltertypen; BlankPos[6].Z auch für Preforms aus/in den Rundwechsler
  - `V.P.PickBlankOffset[2]` (setVPVars): alle Plätze, alle Halter, auch Ablegen
  - `V.P.ZOffsetPreformC` (setVPVars Z. 27): nur Preform, nur Wechslerbereich (alle Plätze + Rundwechsler), Holen UND Ablegen; B-Achse nicht betroffen; verschiebt Schließpunkt, Holen-Position und Ablegehöhe gemeinsam – **bevorzugte Stellschraube, solange Holen und Ablegen in dieselbe Richtung wollen**
  - `V.P.ZOffsetGetPreform` (setVPVars Z. 28): Schließhöhe beim Preform-Holen (= Holen-Position + 8), Wechsler UND B-Achse → nicht anfassen, um nur das Magazin zu korrigieren
  - `V.P.ZOffsetPreformM` (setVPVars Z. 26): nur Preform in der B-Achse, Holen UND Ablegen
  - `V.L.PosZPickOffset` (getBlankFromChanger Z. 100): nur Holen von Blank-/C-Haltern aus den Plätzen 1–7
  - zurückgestellt (11-stoerungen-historie.md): eigener Fallweg-Offset nur fürs Ablegen (giveBlankInChanger) und Abschalten des 8-mm-Nachfahrens (getBlankFromChanger) – erst nötig, wenn das Holen zu hoch wird, bevor das Ablegen passt
