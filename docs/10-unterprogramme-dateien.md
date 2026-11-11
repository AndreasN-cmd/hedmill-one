# Unterprogramme & Dateien

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ Pfade am Steuerungs-PC: Unterprogramme `C:\HMI\NCProg\sub\` (Sicherungen `old\`, `old20261030\`); Log `C:\HMI\log\`; Maschinenparameter-Dateien `C:\HMI\System\MParam\`; Plugins `C:\HMI\Plugins\` (u. a. `HedsCncPlugin1.dll`); außerdem `C:\HMI\WebBrowser\`, `C:\HMI\TcCNCVariablenViewer\`; Jobs/NC-Programme `C:\CNC\wp\`; IBN-Programme `C:\CNC\IBN\`; DYN-Programme im Ordner DYN (DYN-Standard, DYN1, DYNvar); TwinCAT-Projekt `C:\HM1\`
- ✅ Alle Unterprogramme lagen als Dokumente im claude.ai-Projekt „Hedmill Maschine“ (Stand 01.11.2026; setVPVars dort noch mit −28.2, Maschine hat −26.2) → maßgeblich ist immer der Stand auf der Maschine, Kopie in `maschine/sub/` dieses Repos
- ✅ Die Kopie ~/Downloads/HEDmillone-subs auf dem Mac war am 01.11.2026 abends nicht mehr dort; MaschDaten1.plcstruct und Auslieferung.plcstruct liegen in ~/Downloads
- ✅ Dateien: blankChange (Hauptablauf Blankwechsel), getBlankFromChanger, giveBlankInChanger, getBlankFromB, giveBlankInB, checkBlankAtPos / checkBlankAtPosRC / checkBlankAtPosRC2 / checkBlankAtAllPosRC, checkBlankInB, checkBlankchangeDone, findNextFreeBlankPos, SetupChanger, declareVPVars, setVPVars, setVPVars001, start_init.nc, SAFEPOS / SAFEPOS180 / SAFEPOSZ, M6, getTool, removeTool, measureTool, checkToolAtPos / checkToolAtAllPos / checkToolExist, findNextFreeToolPos, toolBreakControl, WarmUp, Home.nc, AB-Null (+ AB-Null_old), 3DTouchXPos/XNeg/YPos/YNeg/ZNeg, 3Pins.nc, cleanBAxis / cleanBlank / cleanM8Water / cleanWR / cleanWS, openClamp / closeClamp, ToolWeightOn/Off, ToolDistFactOn/Off, VersionsInfo V1-0-1 bis V1-0-9, ToDo.txt
- ✅ Eigene Programme (01.11.2026, liegen auf dem Mac in ~/Downloads):
  - LASERCHECK_LESEN.nc – schreibt Laser-Messfenster, BC_CheckPosOffset, PickBlankOffset, C-Halter-Werte, BlankPos[0..7] und aktuellen Laserwert ins Log, nur lesend, Suchwort LASERCHECK; auf der Maschine erfolgreich gelaufen
  - FENSTER3_SETZEN.nc – Versuch, das Fenster per NC zu ändern; OHNE Wirkung (SPS überschreibt) → nicht mehr verwenden, kann gelöscht werden
- ✅ 09.11.2026: Hersteller-Unterprogramme 1:1 aus `~/Downloads/Hedmill-maschinendaten` nach `maschine/sub/` kopiert (136 Dateien inkl. HJA/, IBN-Programme, DYN-Sätze, VersionsInfo V1.0.1–V1.0.9, ToDo.txt des Herstellers mit CNC-Parametern); setVPVars zeigt `ZOffsetPreformC = -26.2` ✅ (passt zur Doku). Ein echtes hyperDENT-Teleskop-NC liegt in `maschine/nc-beispiele/`. Die fünf großen Produktions-NCs (SA13, SA16, SA22, SA26, SA27) bleiben in Downloads
- ✅ setVPVars = maschinenspezifische NC-Werte, getrennt von start_init, damit Updates sie nicht überschreiben; Deklaration in declareVPVars; Datei ist UTF-8 + CRLF
- ✅ Weitere Werte setVPVars: MinPosRC 101, MaxPosRC 130, AccXYZ/AB 3000, RampXYZ/AB 50, PathDev 0,04, IBNactive = TRUE
- ✅ declareVPVars enthält auch die 3Pins-Variablen: V.P.PinLayout = 0, V.P.DropPin = −1, V.P.SideLength, V.P.PinDiameter, V.P.PinHeight
- ✅ SetupChanger („Wechslerkassette ausmessen“): 3D-Messtaster misst zwei Messzapfen Ø8 (Zapfen 1 bei X −132 / Y −219,8 / Z 10, Zapfen 2 +176 mm in X), berechnet Schiefstellung und daraus V.E.ToolPos[1..28] (X/Y); danach Messpins aus dem Wechsler entfernen
- ✅ ToDo.txt (vom HEDS-Techniker): CNC-Startup (Look-ahead, Surface), Kanal-SDA-Parameter, Achsdynamik/Filter für alle Achsen (Details 21-achsdynamik-50120.md); Intervalle Kassettendeckel 10 s, Traverse 29 s
- ✅ IBN-Programme des Herstellers: IBN_BlankChangePosTest.nc, IBN_BlankPosLaserValueTest, IBN_ToolPosLaserValueTest, IBN_ToolChangePosTest.nc, IBN_Testpreform_A0.nc, IBN_Testpreform_A-90.nc (Ordner `C:\CNC\IBN`)
- ✅ Zeichenkodierung gemischt: meist UTF-8 (u. a. setVPVars, declareVPVars, blankChange, SetupChanger), einige Windows-1252 / ISO-8859 (u. a. getBlankFromChanger, giveBlankInChanger, getBlankFromB, Log-Dateien); getBlankFromChanger ist Windows-1252 mit einer UTF-8-Zeile (Z. 62); alle mit Windows-Zeilenenden (CRLF)
- ✅ Beim Bearbeiten immer Kodierung und CRLF der Originaldatei beibehalten (Windows-Editor: Statusleiste zeigt Kodierung und Zeilenende, mit Strg+S speichern); in Kommentaren eigener Änderungen keine Umlaute (Hersteller schreibt „oeffnen“, „Hoehe“)
- ✅ Änderungen an Hersteller-Unterprogrammen (z. B. getBlankFromChanger, giveBlankInChanger) gehen bei einem HEDS-Update verloren → nach Updates Änderungsprotokoll prüfen

### Versionshistorie Hersteller-Pakete (aus VersionsInfo_V1-0-x.txt)
- V1.0.0: Stand 28.01.2026 als Basis
- V1.0.1: M6 bricht ab, wenn Werkzeuglänge < 15 mm
- V1.0.2: setVPVars eingeführt (aus start_init ausgelagert); blankChange V1.2.3 (FIND für Haltertyp)
- V1.0.3: SetupChanger mit V.L.CalcBlanlkPos; IBN_BlankChangePosTest; DYNvar; Preformhalter aus/in RC
- V1.0.4: Holen/Ablege-Offsets in setVPVars; Messwerte der Laserprüfungen werden geloggt; cleanBlank je nach Haltertyp; getTool reinigt Fräser vor Aufnahme
- V1.0.5: ToolDistFactOn/Off; Z-PrePos in getTool/removeTool (Z-Haube nicht auf Wechslerdeckel); toolBreakControl fängt unbekannte VALID-Rückmeldung ab
- V1.0.6: error_filter um 120206 erweitern (CNC-Kanal SDA); Pos 7 X −5 (Faltenbalg); nach Greifer-Öffnen 2 mm hoch; Meldung 305/306; cleanWR erstellt
- V1.0.7: Laserkontrolle nach dem Ablegen (blankChange 1.2.6); declareVPVars eingeführt; start_init ruft declareVPVars vor setVPVars; M79 Powerclamp; cleanWR → cleanWS; Ablauf wegen Scharnieren am Wechslerdeckel geändert; SYN PLC → SYN HMI überall; IBN_BlankPosLaserValueTest / IBN_ToolPosLaserValueTest
- V1.0.8: blankChange 1.2.7–1.2.9 (Felzmann-Vorschläge, 900er-Meldungen, cleanWS); checkBlankAtPosRC2; checkBlankAtPos 1.0.5 / checkToolAtPos 1.0.3 (Bereichsprüfung vor Indexzugriff, M199 statt Weiterlaufen); nach Greifer-Öffnen 4 mm hoch (giveBlankInB 1.0.6, giveBlankInChanger 1.1.1)
- V1.0.9 (aktuell bei den Unterprogrammen): C-Halter holen/ablegen/erkennen (blankChange 1.3.0, checkBlankAtPos/checkBlankInB/findNextFreeBlankPos 1.1.0, getBlankFromChanger/giveBlankInChanger 1.2.0, getBlankFromB/giveBlankInB 1.1.0); setVPVars001 erstellt; Fehlertexte über V.E.MessageText
- TwinCAT-Projekt-Update 30.10.2026 = V1.0.12 (siehe 21-achsdynamik-50120.md)
