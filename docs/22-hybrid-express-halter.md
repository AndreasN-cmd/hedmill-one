# Hybrid-Express-Halter (SLM-Teile nachfräsen)

> Kennzeichnung: ✅ bestätigt · 🌐 öffentlich/allgemein · ❓ offen/Annahme
> Stand: 09.11.2026 (Konzept vom 05.11.2026, noch nicht umgesetzt)

## Halter
- ✅ Andreas nutzt an der HEDmill One einen „Hybrid-Express-Halter“ zum Nachfräsen von Hybridteilen (SLM-Bauteile vom TRUMPF TruPrint 1000)
- ✅ Ziel (05.11.2026): Halter in der Maschine sauber kalibrieren, damit die SLM-Bauteile bestmöglich getroffen werden; größte (nicht konstante) Toleranz bleibt die SLM-Bauteilproduktion
- ✅ In hyperDENT kann der Halter in X, Y und Z verschoben werden, aber NICHT rotiert
- ✅ Andreas kann für die Kalibrierung beliebige Prüfbauteile produzieren (SLM und gefräst)
- ✅ Für PI5 und 650i ist ebenfalls je ein Hybridhalter vorhanden (eigene Maschinen, nicht HEDmill)
- ✅ Zusammenhang: Andreas' eigene Offset-Software für SLM-Hybridteile (Hybridwege 1–3, MicroImp-Spinne, Teleskophalter; Gesamthöhe inkl. 3 mm Supports max. 30 mm) – eigenes Repo
- 🌐 Im bekannten HEDS-Halterprogramm (Blank-/C-Klemmringhalter, Drehfräshalter) taucht kein Hybridhalter auf

## Offene Rückfragen (an Andreas, 05.11.2026)
1. Spannung / Artikelnummer des Halters (Rondenformat in der B-Achse? welcher Haltertyp für den Wechsler?)
2. Befestigung des SLM-Teils bzw. der Bauplatte auf dem Halter – sind Pins vorhanden?
3. Welcher hyperDENT-Nullpunkt wird verwendet, gibt es eine Halter-STL?
4. Beidseitige Bearbeitung (B0/B180)?
5. Ist der 3D-Messtaster einsatzbereit?
6. Gewünschte Zielgenauigkeit?
- ❓ Außerdem unbekannt: Aufbau, Hersteller

## Vorhandenes Herstellerprogramm 3Pins.nc (HEDS, V1.0.0 vom 03.07.2025, H.-J. Albrecht)
- ✅ Zweck laut Kopf: Positionen von bis zu 4 Pins auf einem Blank mit dem 3D-Messtaster ermitteln, „um das Nachfräsen von Lasermelting-Produkten zu ermöglichen“ (Programmkopf trägt fälschlich den Titel „Wechslerkassette ausmessen“)
- ✅ Pin-Anordnungen (`V.L.PinLayout` / `V.P.PinLayout`): 1 = gleichseitiges Dreieck (PIN01 auf X0 / +Y, Dreieckmitte = Blankmitte), 2 = Quadrat auf Spitze, 3 = Quadrat auf Seite; Zählung im Uhrzeigersinn; `DropPin` 0–4 lässt beim Quadrat einen Pin aus
- ✅ Standardwerte: Seitenlänge 69,0 mm (erlaubt 20–80), Pin-Ø 5,0 (5–20), Pin-Höhe 15,0 über Blankmitte (5–20); jede Messung 3× wiederholt (Mittelwert)
- ✅ Ablauf je Pin: Höhe Z antasten, dann 3 Punkte am Umfang (X−, X+, Y+) bei Pinhöhe −3 mm → Kreismittelpunkt aus 3 Punkten
- ✅ Bedienerabfrage „Ist der 3D-Messtaster in der Fraesspindel?“ (M199=1 + M0); T9999/D9999, M38/M39; Kollisionsschutz über G310
- ✅ Ergebnis wird NUR protokolliert: `C:\PINresult\PINresult.txt` (Soll-Mittelpunkte + gemessene X/Y/Z je Pin); es wird KEIN Nullpunkt verschoben/gedreht
- ✅ Fehler im Code: `UP_CalcPinCentrumSquare02` (Layout 3) enthält überzählige Klammern `V.L.SideLength]/2` → Layout 3 läuft vermutlich nicht
- ✅ Die V.P.-Variablen dazu (PinLayout, DropPin, SideLength, PinDiameter, PinHeight) sind in declareVPVars deklariert
- ❓ Gehört 3Pins.nc zum Hybrid-Express-Halter? Pins auf dem Halter oder auf der SLM-Bauplatte?

## Kalibrierkonzept (Vorschlag 05.11.2026)
- Fehler trennen:
  1. Lage des Halters in der Maschine = systematisch → einmal kalibrieren (hyperDENT-Verschiebung)
  2. Verdrehung = in hyperDENT nicht korrigierbar → erst messen
  3. SLM-Streuung (Platte auf Halter, Bauteil auf Platte, Schrumpf/Skalierung) = Prozess → nicht über den Halter korrigieren; Skalierung ist keine Verschiebung (gehört in den Slicer)
- Stufe 1 – Halter ohne SLM-Einfluss: Referenzflächen des Halters mit 3D-Taster antasten (Ist vs. Soll aus Halter-STL) oder Prüfkörper auf dem Halter fräsen und Wandstärken messen (Korrekturformel neu = alt + (Soll − Ist), < 0,05 mm Messschieber-Rauschen)
- Stufe 2 – SLM-Validierung: Testbauteil mit mehreren verteilten Zylindern + Aufmaß, konzentrischen Absatz fräsen, Restwand ringsum messen → Mittelwert = Restversatz, Streuung = nötiges Aufmaß, nach außen wachsender Fehler = Skalierung
- Ausbaustufe: pro Bauplatte antasten (Basis 3Pins.nc) und Nullpunkt NC-seitig automatisch verschieben + drehen (Beckhoff kann Rotation, hyperDENT nicht)
