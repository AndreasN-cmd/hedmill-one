#VAR
   V.L.ZPrePos = 135
	V.L.ZPos = 110
#ENDVAR	

#HSC OFF
#MCS ON EX TOOL
#MEAS [TYPE=1 EDGE=NEG INPUT=2]


M34	; Messzylinder senken

G01 Z=V.L.ZPrePos FV.E.FEEDFAST	; Ausheben in Z
G100 Z=V.L.ZPos FV.E.FEEDMEASURE	; Zmin beim Messen
G01 Z=V.L.ZPrePos FV.E.FEEDFAST	; Ausheben in Z

$IF V.A.MERF.Z != TRUE
	#MSG SYN PLC ["Kein Messwert"]
$ENDIF

M35	; Messzylinder einfahren

#MEAS DEFAULT	; Wiederherstellen der Messeinstellungen aus den Achsparametern fuer alle Bahnachsen

M30