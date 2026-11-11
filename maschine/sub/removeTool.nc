(----------------- WZ ABLEGEN -----------------)

M61	; Wechslerklappe öFV.E.Fnen
#MCS ON EX TOOL

LmeasureTool.nc	; WZ Länge ermitteln
; LtoolBreakControl	; WZ Verschleiß oder Bruch ermitteln

G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
X0
YV.P.TC_PosY 
XV.P.TC_PosX
G01 ZV.P.TC_PosZ FV.E.FEEDSLOW

M70	;Konus auf

G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
XV.E.TouchProbePos[0]	;auf X-TouchProbePosition fahren 
YV.E.TouchProbePos[1]	;auf Y-TouchProbePosition fahren 

LcheckToolExist.nc		;prüfen ob WZ wirklich aus Spindel
#IF V.P.ToolExist != 2
	TV.E.OldToolNumber DV.E.OldToolNumber
	M71	;Konus zu
	LSAFEPOS
	V.E.MessageNumber = 120 (WZ blieb in der Spindel)
	M201
#ENDIF
M17
(----------------- ENDE WZ ABLEGEN -----------------)