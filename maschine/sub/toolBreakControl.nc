(Wz Bruchkontrolle)

#HSC OFF
#MCS ON EX TOOL
#MEAS MODE [1]
M5
M9
G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
A0 B0
XV.E.TouchProbePos[0] YV.E.TouchProbePos[1]
ZV.E.TouchProbePos[2]+40
G100 ZV.E.TouchProbePos[2] FV.E.FEEDMEASURE ; Zmin beim Messen
#FLUSH WAIT

G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch

#IF V.A.MERF.Z == TRUE
	V.P.ToolExist = 1
	V.E.ToolInSpindle = 1
	V.E.MesswertWZLaenge = V.A.Mess.Z + V.S.ToolOffset
	#FLUSH WAIT
	V.E.FunctionNumber = 2
	V.E.FunctionValue = 2	;Messwert zur SPS
	M200	;warten bis Messwert verarbeitet
#ELSE
	V.P.ToolExist = 1
	V.E.ToolInSpindle = 1
	V.E.FunctionNumber = 2
	V.E.FunctionValue = 3	;Kein Messwert -> Werkzeug abgebrochen
	M200
#ENDIF

#FLUSH WAIT
#MCS OFF
#HSC ON
M17