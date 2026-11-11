( WZW-Ablauf )

(----------------- Hauptprogramm -----------------)
LSAFEPOS 	;Achsen auf Sicherheitsposition fahren
#HSC OFF

M01
M5
M9


#IF V.G.T_AKT == V.E.OldToolNumberBasic 	;gefordertes WZ gleich WZ in Frässpindel 
	(???????? && V.G.ToolExist == 1 noch abfragen ????????)
	LmeasureTool.nc	; WZ Länge ermitteln
	; LtoolBreakControl	; WZ Verschleiß oder Bruch ermitteln
	$GOTO [Label_End]
#ENDIF

; wenn T0 in Spindel, dann prüfen ob wirklich kein Werkzeug in Spindel
#IF V.E.OldToolNumberBasic == 0
	LcheckToolExist.nc	;prüfen, ob WZ in Frässpindel
#ENDIF


#IF V.E.OldToolNumberBasic == 0 AND V.S.ToolExist == 1
	V.E.MessageNumber = 101 ;T0, aber WZ in Spindel
	M201
#ENDIF

;#IF V.E.OldToolNumberBasic != 0 AND V.S.ToolExist == 2
;	V.E.MessageNumber = 102 ;T<>0, aber kein WZ in Spindel
;	T0 D0
;	M201
;#ENDIF
	
#IF V.E.OldToolNumberBasic == 0			;kein WZ in Frässpindel
	#IF V.G.T_AKT == 0	
			$GOTO [Label_End]			;kein neues WZ gefordert --> an das Ende springen
	#ELSE
			$GOTO [Label_GetTool]		;nur WZ holen
	#ENDIF
#ENDIF

#IF V.G.T_AKT == 0
	$GOTO [Label_RemoveTool]			;nur WZ wegbringen
#ENDIF

#IF V.G.T_AKT != 0
	#IF V.G.T_AKT == V.E.OldToolNumberBasicBasic 
			G04 0.1
			$GOTO [Label_End]			;gefordertes WZ gleich WZ in Frässpindel --> an das Ende springen
	#ELSE
			G04 0.1
			$GOTO [Label_RemoveGetTool]	;gefordertes WZ ungleich WZ In Frässpindel --> wegbringen und holen
	#ENDIF
#ENDIF


[Label_GetTool] ;----------- nur neues WZ holen -----------
;WZW-Pos zuweisen
#FLUSH WAIT
V.P.TC_PosX = V.E.ToolXPos[V.E.TCPosToolNew]
V.P.TC_PosY = V.E.ToolYPos[V.E.TCPosToolNew]
V.P.TC_PosZ = V.E.ToolZPos[V.E.TCPosToolNew]
#FLUSH WAIT
LgetTool.nc
$GOTO [Label_End]	;--> an das Ende springen



[Label_RemoveTool] ;----------- nur altes WZ wegbringen -----------
;WZW-Pos zuweisen
#FLUSH WAIT
V.P.TC_PosX = V.E.ToolXPos[V.E.TCPosToolInSpindle]
V.P.TC_PosY = V.E.ToolYPos[V.E.TCPosToolInSpindle]
V.P.TC_PosZ = V.E.ToolZPos[V.E.TCPosToolInSpindle]
#FLUSH WAIT
LremoveTool.nc
$GOTO [Label_End]



[Label_RemoveGetTool] ;----------- altes WZ wegbringen, neues WZ holen -----------
;WZW-Pos zuweisen
#FLUSH WAIT
V.P.TC_PosX = V.E.ToolXPos[V.E.TCPosToolInSpindle]
V.P.TC_PosY = V.E.ToolYPos[V.E.TCPosToolInSpindle]
V.P.TC_PosZ = V.E.ToolZPos[V.E.TCPosToolInSpindle]
#FLUSH WAIT
LremoveTool.nc
;WZW-Pos zuweisen
#FLUSH WAIT
V.P.TC_PosX = V.E.ToolXPos[V.E.TCPosToolNew]
V.P.TC_PosY = V.E.ToolYPos[V.E.TCPosToolNew]
V.P.TC_PosZ = V.E.ToolZPos[V.E.TCPosToolNew]
#FLUSH WAIT
LgetTool.nc
$GOTO [Label_End]


[Label_End]

LSAFEPOS

M62	;Wechslerklappe schließen
#MCS OFF
#HSC ON
M17
