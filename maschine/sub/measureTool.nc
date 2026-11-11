(Wz vermessen)
#HSC OFF
#MCS ON EX TOOL
#MEAS MODE [1]
M5
M9
D V.G.T_AKT

#IF V.G.T_AKT == 0			;kein Werkzeug in Frässpindel --> an das Ende springen
	$GOTO [Label_Ende]
#ENDIF


M61	;Wechslerklappe öffnen

G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
A0 B0

XV.E.TouchProbePos[0] YV.E.TouchProbePos[1]	;auf XY positionieren
ZV.E.TouchProbePos[2]+40					;Vorposition in Z um Messen starten zu können
G100 ZV.E.TouchProbePos[2] FV.E.FEEDMEASURE ;Zmin beim Messen
#FLUSH WAIT

G01 ZV.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch

#IF V.A.MERF.Z == TRUE
	V.P.ToolExist = 1
	V.E.ToolInSpindle = 1
	
	V.E.ToolLength = V.A.MESS.Z - V.E.ToolOffset
	#FLUSH WAIT
	V.E.FunctionNumber = 2
	V.E.FunctionValue = 1	;Messwert zur SPS
	M200	;warten bis Messwert verarbeitet
	
	#FLUSH WAIT
	
	V.G.WZ_AKT.L = V.E.WZLaenge
	D V.G.T_AKT
#ELSE
	V.E.ToolInSpindle = 0
	V.E.MessageNumber = 201 (Kein Messwert)
	M201
#ENDIF

[Label_Ende]
#FLUSH WAIT
#MCS OFF
#HSC ON
M17