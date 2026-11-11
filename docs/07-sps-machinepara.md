# SPS-Maschinenparameter `GVL_HEDmillOne.machinePara`

> Kennzeichnung: ✅ bestätigt (Andreas / Maschine / Unterprogramme / Log / TwinCAT live / erfolgreich gelaufen) · 🌐 öffentliche Quelle / allgemeines Steuerungswissen · ❓ offen oder Annahme – NICHT als Fakt verwenden
> Stand: 09.11.2026 (Export aus dem claude.ai-Projekt „Hedmill Maschine“)

- ✅ Alle maschinenspezifischen Parameter liegen in der SPS-Struktur `GVL_HEDmillOne.machinePara` (Typ MP_Machine…, TwinCAT-SPS). Die V.E.-Variablen der NC sind darauf abgebildet (Datentyp z. B. `CNC_PLC_Project.VE_MinMax`)
- ✅ Die SPS ist die Quelle: Laser-Fenster lassen sich nicht per NC überschreiben (Test 01.11.2026), wohl aber per TwinCAT „Werte schreiben“
- ✅ Oberste Ebene live: btest1, stMachine, stMillingSpindle, stBlankChange (… stCNC, stToolChange)
- ✅ Zuordnung NC ↔ SPS:
  - `V.E.BlankPos[0..7]` ↔ `machinePara.stBlankChange.stBlankPositions[0..7]` (X/Y/Z)
  - `V.E.BC_CheckPosOffset` ↔ `machinePara.stBlankChange.fCheckPosOffsetX/Y/Z`
  - `V.E.BC_CheckPosZLaser1[0..10]` ↔ `machinePara.stBlankChange.stCheckPosZLaser1` („Werte für Wechsler“, ARRAY [0..10] OF VE_MinMax: 0 = LEER, 1 = LEER mit Preformbasis, 2 = Preformhalter, 3 = Blankhalter, 4–10 Option)
  - `V.E.BC_CheckPosZLaser0[0..3]` ↔ `stCheckPosZLaser0` = gleiches für das Klemmsystem B-Achse („Werte für Klemmsystem“); in checkBlankInB wird [1] (LEER mit Preformbasis) nicht ausgewertet (auskommentiert)
  - `V.E.ToolPos[1..28]` ↔ `machinePara.stToolChange.stPositions[1..28]`
  - `V.E.FEED…` ↔ `machinePara.stCNC.stFeed`
- ✅ Gruppen in machinePara:
  - stBlankChange: bRotaryChangerAvailable (TRUE), stBlankPositions, fCheckPosOffsetX/Y/Z, stCheckPosZLaser0/1, stClampBAxis (Spannsystem B-Achse, Booster, Dock-Luft), stGripper (stGripperOpenClose, stGripperLiftLower, Analogsensor-Werte), stRotaryChanger (stLifter, afBlankPositions[0..30], fOffsetSensorToBlankCenter 0, fVelocity 30, fAcceleration 150, fDeceleration 150, fJerk 1000), stTypeOfBlankOnPosition01[0..7] / 02[1..30] (Belegung je Platz: Rondendicke, Platznummer, Material, Definition, Teile-/Projektnummer)
  - stToolChange: stPositions[1..28], fCheckPosOffsetX/Y/Z (Werkzeug-Laserprüfung), fDeltaValueToolBroken, **fToolLengthOffset** (Werkzeug-Längenoffset; ✅ HEDS 10.11.2026: in der HMI unter stToolChange, Eingabe HMI → BACK / Maschinenparameter → „Übertragen in SPS“; ❓ = `V.E.ToolOffset` in measureTool.nc: `ToolLength = MESS.Z − ToolOffset`; keine Textdatei dahinter, `*.plcstruct` binär; eingestellt über Testkreuz/Plättchen, docs/02), Position Taster und 3D-Taster
  - stMachine: Druckluft-Grenzwerte, Sperrluft B-Achse, Ausblasen Kavität, Wechslerklappe, Festlager A-Achse (mit Sensor), Reinigungsluft Klappe / Powerclamp / Traverse, Messzylinder Z, Absaugstellen (max. 10)
  - stCNC: Achs-Endschalter und Offsets X/Y/Z/A/B, Vorschübe
  - stMillingSpindle: Werkzeug in Spindel, Kegel offen/zu-Zeiten, Kühlung (Durchfluss- und Temperaturgrenzen), Sperrluft-Verzögerung, Warmlauf-Pflicht

### Pneumatik-Zylinder (Datentyp MP_Pne…)
- ✅ Alle Pneumatik-Zylinder haben denselben Parameterblock (live Stand 01.11.2026): `bOnlyPulseSignals`, `tPulseLength`, `abDisableMonitoring[]`, `abDisableMonitoring2[]`, `abSimulatePosReached[]`, `atSimulatePosReachedTime[]`, `tEnablePosNotReached`, `tDisablePosNotReached`, `tEnablePosNotLeaved`, `tDisablePosNotLeaved`, `tDelayEnablePosReached`, `tDelayDisablePosReached`, `bTest`
  - ✅ `abDisableMonitoring2`, `tEnablePosNotLeaved`, `tDisablePosNotLeaved` gab es im Dezember 2025 noch nicht (fehlen in MaschDaten1.plcstruct) → später per Update dazugekommen
  - ✅ `…PosNotReached` = Zeit, bis die Ziel-Endlage erreicht sein muss; `…PosNotLeaved` = Zeit, bis die Ausgangs-Endlage verlassen sein muss
  - ✅ `…PosNotLeaved = T#0ms` → SPS meldet sofort Störung und der Zylinder fährt gar nicht los (Fehlerbild Rundwechsler-Lift 01.11.2026)
- ✅ Beispiele: stRotaryChanger.stLifter (Rundwechsler-Lift), stGripper.stGripperLiftLower (Greifer-Hubzylinder), stGripper.stGripperOpenClose, stMachine.stChangestationFlap (Wechslerklappe), stFixedBearingAAxis, stMeasuringCylinderZ, stClampBAxis.stDockAirSupply
- ✅ Live-Werte 01.11.2026:

  | Parameter | stLifter (vor Fix) | stLifter (nach Fix) | stGripperLiftLower |
  |---|---|---|---|
  | bOnlyPulseSignals | FALSE | FALSE | FALSE |
  | tPulseLength | 150 ms | 150 ms | 150 ms |
  | tEnablePosNotReached | 8 s | 8 s | 25 s |
  | tDisablePosNotReached | 8 s | 8 s | 25 s |
  | tEnablePosNotLeaved | **0 ms** | **8 s** | 8 s |
  | tDisablePosNotLeaved | **0 ms** | **8 s** | 8 s |
  | tDelayEnable/DisablePosReached | 0 / 0 | 0 / 0 | 0 / 0 |

- ✅ Dezember 2025 (MaschDaten1.plcstruct = Auslieferung): stLifter 150 ms / 8 s / 8 s, atSimulatePosReachedTime 6 s / 1 s; stGripperLiftLower 150 ms / 8 s / 8 s (inzwischen 25 s); Wechslerklappe 150 ms / 4 s / 4 s
- ❓ Andere Zylinder, die selten benutzt werden, könnten ebenfalls `…PosNotLeaved = 0` haben → bei ähnlicher Sofort-Störung zuerst dort nachsehen

### Greifer-Analogsensor (stBlankChange.stGripper, live 01.11.2026)
- ✅ fGripperOpenedSensorValue 10 / Range 0,6; fGripperGrippedSensorValue 2 / Range 2; fGripperClosedSensorValue 0 / Range 1
- ✅ nCalcMinValueSensor 2606, nCalcMaxValueSensor 1810; fCalcMinValueDisplay 0, fCalcMaxValueDisplay 10 (Skalierung Rohwert → Anzeige 0–10)

### Rundwechsler
- ✅ `stRotaryChanger.afBlankPositions[0..30]` (Winkel, Raster 12°): Stand 08.12.2025 349,18 / 349,18 / 1,18 / 13,18 … 337,18; Auslieferung 359,23 / 359,23 / 11,38 / 23,23 … 347,23 (um ca. 10° nachjustiert)

### Dateien in `C:\HMI\System\MParam\`
- ✅ `MaschDaten1.plcstruct` (Stand 08.12.2025) und `Auslieferung.plcstruct` (Stand 26.11.2025): Beckhoff-„PlcStructure“-Dateien (.NET-Binärformat) mit Aufbau, Beschreibungen, Min/Max/Einheiten plus altem Werte-Stand
  - ✅ NICHT die Live-Werte (z. B. CheckPosOffset X 0 / Y −22, live X 5 / Y −18; Fenster 505/545 fehlen; neue Zylinder-Parameter fehlen)
  - ✅ Nicht im Editor bearbeiten (Binärdatei); als Referenz für alte Werte nützlich
