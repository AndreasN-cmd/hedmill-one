(--Beschreibung-------------------------------------------------------------)
;  Mit diesem Programm werden die Lasermesswerte der Blankpositionen im 
;  Wechslerbereich ermittelt
;
;
;	Version		Datum 		Name 				Änderungen
;	1.0.0		30.06.2026	H.-J. Albrecht		Programmerstellung 
;	1.0.1		25.08.2026	H.-J. Albrecht		Abfrage für V.L.WithRC eingefügt 
;
(---------------------------------------------------------------------------)

#VAR
   V.L.WaitTime = 1
   V.L.OnlyOne = FALSE                ; TRUE = nur die StartPos wird angefahren
   V.L.StartBlankPos = 1 				  ; Werkzeugposition im WZ-Wechsler die als erstes oder nur angefahren werden soll
   V.L.EndBlankPos = 7  		        ; Werkzeugposition im WZ-Wechsler die als letztes angefahren soll
   V.L.WithRC = TRUE				; TRUE = Rundwechsler vorhanden, dann wird Platz 5 ausgelassen
	V.L.PosX							; X-Wert für Schleife
	V.L.PosY							; Y-Wert für Schleife
	V.L.PosZ							; Z-Wert für Schleife
	V.L.NextPos
#ENDVAR


L DYN-Standard
L SAFEPOS 	;Achsen auf Sicherheitsposition fahren
M83		; Blankgreifer-Hubzylinder heben
#HSC OFF
#MCS ON EX TOOL

#MSG SYN HMI ["Loadertuer bitte schliessen"]
M51   	; Loadertuer verriegeln
#FLUSH WAIT

M61   ; WZ-Klappe oeffnen

#MSG SYN HMI [""]

$IF V.L.OnlyOne == TRUE
	V.L.PosX = V.E.BlankPos[V.L.StartBlankPos].X + V.P.PickBlankOffset[0]
	V.L.PosY = V.E.BlankPos[V.L.StartBlankPos].Y + V.P.PickBlankOffset[1]
	V.L.PosZ = V.E.BlankPos[V.L.StartBlankPos].Z + V.P.PickBlankOffset[2]
	
	V.P.BlankPosToCheck = V.L.StartBlankPos
	L checkBlankAtPos
   
   #HSC OFF
   #MCS ON EX TOOL

	G01 X=V.L.PosX Y=V.L.PosY FV.E.FEEDFAST
	G04 XV.L.WaitTime
	V.P.BlankPosToCheck = V.L.StartBlankPos
	L checkBlankAtPos
$ELSE
	; erste Position anfahren
	V.L.PosX = V.E.BlankPos[V.L.StartBlankPos].X + V.P.PickBlankOffset[0]
	V.L.PosY = V.E.BlankPos[V.L.StartBlankPos].Y + V.P.PickBlankOffset[1]
	V.L.PosZ = V.E.BlankPos[V.L.StartBlankPos].Z + V.P.PickBlankOffset[2]
	
	V.P.BlankPosToCheck = V.L.StartBlankPos
	L checkBlankAtPos
   
   #HSC OFF
   #MCS ON EX TOOL

	G01 X=V.L.PosX Y=V.L.PosY FV.E.FEEDFAST
	G04 XV.L.WaitTime
	#FLUSH WAIT
	V.P.BlankPosToCheck = V.L.StartBlankPos
	L checkBlankAtPos
	
	V.L.NextPos = V.L.StartBlankPos + 1
	; Nächste Position > Endposition
	$IF V.L.NextPos > V.L.EndBlankPos
		G01 Z=V.A.+SWE.Z-1 FV.E.FEEDFAST
		$GOTO [Label_END]
	$ENDIF
		
	$FOR P1=V.L.NextPos, V.L.EndBlankPos, 1
	   $IF V.L.WithRC == TRUE AND P1 == 5
	      P1 = P1 + 1
	   $ENDIF
		V.L.PosX = V.E.BlankPos[P1].X + V.P.PickBlankOffset[0]
		V.L.PosY = V.E.BlankPos[P1].Y + V.P.PickBlankOffset[1]
		V.L.PosZ = V.E.BlankPos[P1].Z + V.P.PickBlankOffset[2]
		
		V.P.BlankPosToCheck = P1
		L checkBlankAtPos
   
	   #HSC OFF
	   #MCS ON EX TOOL
   	
		G01 X=V.L.PosX Y=V.L.PosY FV.E.FEEDSLOW
		G04 XV.L.WaitTime
		#FLUSH WAIT
		
		V.P.BlankPosToCheck = P1
		L checkBlankAtPos
		
      #HSC OFF
      #MCS ON EX TOOL
		G01 Z=V.A.+SWE.Z-1 FV.E.FEEDSLOW
	$ENDFOR    
	
	
$ENDIF

G01 Z=V.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch

L SAFEPOS 	;Achsen auf Sicherheitsposition fahren

[Label_END]

M62   ; WZ-Klappe schliessen
	

#MEAS DEFAULT	; Wiederherstellen der Messeinstellungen aus den Achsparametern für alle Bahnachsen
#MCS OFF
#HSC ON 
#SLOPE[TYPE=HSC] ; Definition des Beschleunigungsverlaufs, Anwendungsart des Rucks

M30