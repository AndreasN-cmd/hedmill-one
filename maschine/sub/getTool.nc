(----------------- WZ HOLEN -----------------)

M61	; Wechslerklappe öffnen
#MCS ON EX TOOL
G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
X0
YV.P.TC_PosY 
XV.P.TC_PosX

M70	;Konus auf

G01 ZV.P.TC_PosZ FV.E.FEEDSLOW

M71	;Konus zu

G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
XV.E.TouchProbePos[0]
YV.E.TouchProbePos[1]			;auf Y-TouchProbePosition fahren)
			;LWZ_Pruefen.nc					;prüfen ob WZ wirklich in Spindel
LmeasureTool.nc	; WZ Länge ermitteln
; LtoolBreakControl	; WZ Verschleiß oder Bruch ermitteln
#IF V.P.ToolExist != 1			;kein WZ in Frässpindel
	T0D0
	LSAFEPOS
	M62	;Wechslerklappe schließen
	V.E.MessageNumber = 110 (WZ blieb im WZW)
	M201
#ENDIF
M17
(----------------- ENDE WZ HOLEN -----------------)