# Maschine & Hersteller

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ HEDmill One, 5-Achs-HSC-Dentalfräsmaschine, stark ausgelastet; läuft auch in Nachtschicht (mannlos)
- ✅ Steuerung: Beckhoff TwinCAT mit ISG-CNC-Kern + TwinCAT-SPS (Projekt „CNC_PLC_Project“), HEDS-eigene Bedienoberfläche (HMI)
- ✅ Steuerungs-PC: Windows, Benutzer „Administrator“, PowerShell verfügbar, **TwinCAT XAE Shell installiert**
- ✅ Auf dem Steuerungs-PC liegt eine Projektsicherung von Freitag 30.10.2026 (kurz vor dem HEDS-Update); Login damit am 01.11.2026 ohne Download-/Online-Change-Rückfrage → SPS-Programm passt zu diesem Stand
- ✅ Werkzeugschaft 6 mm (6h6), Werkzeuge von Hufschmied
- ✅ Keine öffentliche Dokumentation; Ziel: alles ohne Hersteller-Support selbst lösen
- ✅ Autor der Hersteller-Unterprogramme: H.-J. Albrecht; Änderungsvorschläge auch von L. Felzmann (z. B. checkBlankAtPos V1.0.5, blankChange V1.2.7)
- ✅ Der Hersteller ändert Greifpositionen bisher in TwinCAT (Beobachtung Andreas)
- ✅ Unterprogramme lassen sich am Steuerungs-PC direkt im Datei-Explorer mit dem Windows-Editor ändern
- ✅ Andreas' Vorgehensregel (03.11.2026): möglichst wenig in die Hersteller-Unterprogramme eingreifen; Werte in setVPVars (dafür vorgesehene Datei) sind der bevorzugte Weg, Programmlogik ändern nur wenn es anders nicht geht
- ✅ Änderungen sollen fehlerfrei und rückgängig machbar sein, damit nichts beim Hersteller negativ auffällt
- 🌐 Hersteller: HEDmill GmbH & Co. KG, Göttingen (HEDS Group / HEDS Dental, GF Leon Felzmann)
- 🌐 Spindel-Frequenzumrichter: Sieb & Meyer SD4S
- ✅ Weitere Fräsmaschinen im Labor (NICHT HEDmill, nur zur Abgrenzung): Zfx Dental PI5 (CIMT, Rexroth-Steuerung IndraWorks, meist nass, hyperDENT-Postprozessor „Pi5 CIMT GmbH“, NC-Dateien brauchen CIMTHMI-Metazeilen) und eine 650i; alle Maschinen 6-mm-Schaftaufnahme
