#VAR
   V.L.WaitTime = 2
   V.L.OnlyOne = FALSE                ; TRUE = nur die StartPos wird angefahren
   V.L.StartToolPos = 1 				  ; Werkzeugposition im WZ-Wechsler die als erstes oder nur angefahren werden soll
   V.L.EndToolPos = 28  		        ; Werkzeugposition im WZ-Wechsler die als letztes angefahren soll
	V.L.PosX							; X-Wert für Schleife
	V.L.PosY							; Y-Wert für Schleife
	V.L.PosZ							; Z-Wert für Schleife
#ENDVAR


L DYN-Standard
L SAFEPOS 	;Achsen auf Sicherheitsposition fahren
#HSC OFF
#MCS ON EX TOOL

M61   ; WZ-Klappe oeffnen

$IF V.L.OnlyOne == TRUE
   V.L.PosX = V.E.ToolPos[V.L.StartToolPos].X 
   V.L.PosY = V.E.ToolPos[V.L.StartToolPos].Y 
   V.L.PosZ = V.E.ToolPos[V.L.StartToolPos].Z
   
   G01 X=V.L.PosX Y=V.L.PosY FV.E.FEEDFAST
   G01 Z=V.L.PosZ+30  FV.E.FEEDSLOW
   G01 Z=V.L.PosZ  FV.E.FEEDMEASURE
   G04 XV.L.WaitTime
   G01 Z=V.L.PosZ+30  FV.E.FEEDSLOW
   G01 Z=V.A.+SWE.Z-1 FV.E.FEEDFAST
$ELSE
   $FOR P1=V.L.StartToolPos, V.L.EndToolPos, 1
      V.L.PosX = V.E.ToolPos[P1].X 
      V.L.PosY = V.E.ToolPos[P1].Y 
      V.L.PosZ = V.E.ToolPos[P1].Z
      
      G01 X=V.L.PosX Y=V.L.PosY FV.E.FEEDFAST
      G01 Z=V.L.PosZ+30  FV.E.FEEDSLOW
      G01 Z=V.L.PosZ  FV.E.FEEDMEASURE
      G04 XV.L.WaitTime
      G01 Z=V.L.PosZ+30  FV.E.FEEDSLOW
      G01 Z=V.A.+SWE.Z-1 FV.E.FEEDFAST
   $ENDFOR    
$ENDIF



G01 Z=V.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch

L SAFEPOS 	;Achsen auf Sicherheitsposition fahren

M62   ; WZ-Klappe schliessen
	

#MEAS DEFAULT	; Wiederherstellen der Messeinstellungen aus den Achsparametern für alle Bahnachsen
#MCS OFF
#HSC ON 
#SLOPE[TYPE=HSC] ; Definition des Beschleunigungsverlaufs, Anwendungsart des Rucks

M30