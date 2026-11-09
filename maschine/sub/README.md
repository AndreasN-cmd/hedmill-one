# Hersteller-Unterprogramme (Kopie von `C:\HMI\NCProg\sub\`)

Hier 1:1 hineinkopieren (nicht abtippen, nicht in einem Editor neu speichern): den kompletten Ordnerinhalt inkl. `old\` und `old20261030\`.

Erwartete Dateien (Stand claude.ai-Projekt 01.11.2026, Paket V1.0.9):
3DTouchXNeg, 3DTouchXPos, 3DTouchYNeg, 3DTouchYPos, 3DTouchZNeg, 3Pins.nc, AB-Null, AB-Null_old, blankChange, checkBlankAtAllPosRC, checkBlankAtPos, checkBlankAtPosRC, checkBlankAtPosRC2, checkBlankchangeDone, checkBlankInB, checkToolAtAllPos, checkToolAtPos, checkToolExist, cleanBAxis, cleanBlank, cleanM8Water, cleanWR, cleanWS, closeClamp, declareVPVars, findNextFreeBlankPos, findNextFreeToolPos, getBlankFromB, getBlankFromChanger, getTool, giveBlankInB, giveBlankInChanger, Home.nc, M6, measureTool, openClamp, removeTool, SAFEPOS, SAFEPOS180, SAFEPOSZ, setVPVars, setVPVars001, SetupChanger, start_init.nc, toolBreakControl, ToolDistFactOff, ToolDistFactOn, ToolWeightOff, ToolWeightOn, WarmUp, ToDo.txt, VersionsInfo_V1-0-1.txt … VersionsInfo_V1-0-9.txt

Prüfpunkte nach dem Kopieren (Stand 09.11.2026):
- `setVPVars` Z. 27: `V.P.ZOffsetPreformC = -26.2` (eigene Änderung 03.11.2026)
- `getBlankFromChanger` Z. 100: `V.L.PosZPickOffset = -4` (eigene Änderung 01.11.2026)

Weitere Hersteller-Ordner, falls gewünscht: `C:\CNC\IBN\` (IBN-Programme) und der DYN-Ordner (DYN-Standard, DYN1, DYNvar) → in `maschine/ibn/` bzw. `maschine/dyn/`.
