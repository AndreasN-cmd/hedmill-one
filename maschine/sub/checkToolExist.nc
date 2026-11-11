(----------------- WZ PRÜFEN -----------------)

V.P.ToolExist = 0
#HSC OFF
#MCS ON EX TOOL
#MEAS MODE [1]

G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch

YV.E.TouchProbePos[1]		(auf Y-TouchProbePosition fahren)
XV.E.TouchProbePos[0]		(auf X-TouchProbePosition fahren)
ZV.E.ZPrePos

G100 ZV.E.TouchProbePos[2] FV.E.FEEDMEASURE	;Zmin beim Messen

#IF V.A.MERF.Z == TRUE
	V.P.ToolExist = 1
	V.E.ToolInSpindle = 1
	#FLUSH WAIT
#ELSE
	V.P.ToolExist = 2
#ENDIF
G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
M17
(----------------- ENDE WZ PRÜFEN -----------------)