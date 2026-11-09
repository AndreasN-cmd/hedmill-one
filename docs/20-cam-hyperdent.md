# hyperDENT-Vorlagen & CAM-Jobs (HEDmill One)

> Kennzeichnung: ✅ bestätigt · 🌐 Beckhoff-Doku / allgemein · ❓ offen oder Annahme
> Stand: 09.11.2026

## Allgemein
- ✅ CAM: hyperDENT (Follow-Me); Postprozessor setzt Nullpunkte G58/G59 automatisch, kein NC-Text nötig
- ✅ CAD: exocad DentalCAD
- ✅ hyperDENT-Optimierung von PMMA-Schienen-Innenflächen mit Hinterschnitten war Thema
- ✅ SLM+CNC-Hybridfertigung (TruPrint 1000, Starbond Easy Powder) → siehe 22-hybrid-express-halter.md und Andreas' eigene Offset-Software (separates Repo)

## Prefab-Abutments (Drehfräsen)
- ✅ CoCr/Titan-Prefab-Abutments per Drehfräsen, hyperDENT-Vorlage „Präfabriziertes Abutment MASTER“
- ✅ Rohteile Ø11,5 und Ø16 mm, zu 99 % Ø11,5
- ✅ Ziel: EINE Vorlage, die den Rohteildurchmesser selbst erkennt; manuelles Umschalten oder Pflege von Rohteilgruppen (MA-abhängig, fehleranfällig) kommt nicht infrage; Verzweigung in der Maschine (`$IF` im NC-Text) ist Andreas derzeit zu experimentell
- ✅ Gewählter Weg (Okt 2026): zwei rohteilbasierte axiale 3D-Schruppjobs („Schruppen – beliebige Seite“, Rohteilnachführung) VOR der Drehfräs-Kaskade:
  - T5051 Ø3 FS8 (8 mm Hals) für die ersten 7,5 mm
  - T5052 Ø3 (13 mm Hals) für den Rest
- ✅ Bei seinen Abutments gibt es keine großen Schulterradien (Hinterschnitt kein Thema)

## Job 1.5 „Vorschlichten Prep-Grenzenband Torus“
- ✅ Früherer Stand: Band bis 3 mm außerhalb der Präparationsgrenze erweitert, Start 3 mm außen
- ✅ 01.11.2026: Andreas gefällt die Fräsrichtung beim Start 3 mm außen nicht → Aufteilung in zwei Jobs:
  - Job 1: Bearbeitungsrichtung von außen nach innen, Band 0,1 mm innerhalb bis 3 mm innerhalb der Grenze
  - Job 2: Bearbeitungsrichtung von innen nach außen, Band 0,1 mm innerhalb bis 3 mm außerhalb der Grenze
- ✅ Prinzip: Beide Jobs beginnen an der Grenze und arbeiten von ihr weg
- ❓ Hinweise zur Prüfung: kleine Überlappung an der Trennlinie (0,1 mm innen), damit kein Grat stehen bleibt; Gleich-/Gegenlauf in beiden Jobs gleich; Anfahren nicht direkt auf der Grenzkante
- ❓ Name der Vorlage, in der der Job liegt, noch nicht notiert

## Bearbeitungstoleranz
- ✅ Im Template wurde die Bearbeitungstoleranz testweise auf 0,005 mm gesetzt – so fein wie nie zuvor; Andreas wollte die 0,005 mm möglichst behalten
- ✅ Ergebnis 01.11.2026 abends: 0,005 mm → Fehler 50120 (Maschine stoppt); 0,01 mm → nur Warnschwelle Achsbeschleunigung (50121), Maschine stoppt nicht → **Andreas läuft mit 0,01 mm und beobachtet**
- ✅ Die Maschine fräst mit HSC-Glättung der Steuerung (`#HSC ON`, `#SLOPE[TYPE=HSC]`, z. B. nach M6 und Home.nc); in setVPVars steht als Standardwert für die HSC-Bahnabweichung `V.P.PathDev = 0.04` (mm, „Path_DEV für HSC-Funktion … DYN1 … DYNvar“)
- ❓ Welche DYN-Einstellung (DYN-Standard / DYN1 / DYNvar …) die hyperDENT-Programme im NC-Kopf aufrufen und mit welcher Bahnabweichung sie fräsen, noch nicht geprüft

## Wege, um feine Toleranz zu nutzen bzw. Reserve zu schaffen (besprochen 01.11.2026)
1. Vorschub nur im betroffenen Job senken (Beschleunigung steigt etwa mit dem Quadrat der Geschwindigkeit: 70 % Vorschub ≈ halbe Beschleunigung); Test vorab mit Override 70–80 % in diesem Job
2. Feine Toleranz nur in den Jobs verwenden, wo sie auf der Fläche wirkt (Schlichten Funktionsflächen); Jobs mit viel B-Bewegung mit gröberer Toleranz
3. Prüfen, mit welcher HSC-Bahnabweichung die Jobs laufen (siehe oben)
4. Nicht empfohlen: B-Beschleunigungsgrenze (P-AXIS-00008) oder Schwellen (P-AXIS-00441/00442) erhöhen – Schutz für Antrieb/Mechanik
5. Look-ahead wieder auf den Stand vor dem Update – Entscheidung liegt bei HEDS (21-achsdynamik-50120.md)
- Beobachten: Bei welchem Satz / Job kommt die Warnung, wie oft, Verhältnis-Wert in der Meldung; tritt zusätzlich 50120 auf → Vorschub im Job senken
