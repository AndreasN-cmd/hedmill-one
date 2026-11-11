#VAR
   V.L.tmpMPZ
#ENDVAR

#HSC OFF
#MEAS [TYPE=5 EDGE=NEG INPUT=2]	; Umschaltung der Messsignalauswertung 

M38	; 3D-Messtaster einschalten

#MCS ON EX TOOL
G01 Z=V.A.+SWE.Z-1 FV.E.FEEDSLOW
#MCS OFF
G310 G01 X-10 Y-10 FV.E.FEEDSLOW $GOTO [Label_Crash]
G310 G01 X0 Y0 FV.E.FEEDSLOW $GOTO [Label_Crash]

#MEAS MODE[1]
G100 Z50 
$IF V.A.MERF.Z == TRUE
	V.L.tmpMPZ = V.A.MESS.Z - V.G.WZ_AKT.L

$ENDIF
G01 Z=V.L.tmpMPZ+5 FV.E.FEEDSLOW
M0
	
#MEAS MODE[5]
G310 X-40 $GOTO [Label_Crash]

$GOTO [Label_END]

; ----------------------------------------------------------------------------------------------------------
; -- Sprungmarke wird verwendet, wenn während der eigentlichen Positionierung der 3D-Messtaster ausgelöst hat
[Label_Crash]
	#MSG SAVE EXCLUSIVE ["%S --- Während der Positionierung wurde der 3D-Messtaster ausgelöst", V.G.TIME_STAMP_FILE_NAME]
	#MSG SYN PLC ["Während der Positionierung wurde der 3D-Messtaster ausgelöst"]
	V.E.MessageNumber = 420	; CRASH mit 3D-Taster
	M39
	M199
; ----------------------------------------------------------------------------------------------------------


[Label_END]
M39
M30