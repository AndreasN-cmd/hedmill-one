(--Beschreibung-------------------------------------------------------------)
;  	Mit diesem Programm werden die Lasermesswerte für jeden Werkzeugplatz ermittelt
;
;	Version		Datum 		Name 				Änderungen
;	1.0.0		30.06.2026	H.-J. Albrecht		Programmerstellung
;
; 
(---------------------------------------------------------------------------)

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

#MSG SAVE EXCLUSIVE ["%S --- Die Ermittlung der Lasermesswerte zu den Werkzeugpositionen wurde gestartet", V.G.TIME_STAMP_FILE_NAME]    
#MSG SYN HMI ["Die Ermittlung der Lasermesswerte zu den Werkzeugpositionen wurde gestartet"]


#MSG SYN HMI ["Loadertuer bitte schliessen"]
M51   	; Loadertuer verriegeln
#FLUSH WAIT
M61   ; WZ-Klappe oeffnen

$IF V.L.OnlyOne == TRUE
	V.L.PosX = V.E.ToolPos[V.L.StartToolPos].X 
	V.L.PosY = V.E.ToolPos[V.L.StartToolPos].Y 
	V.L.PosZ = V.E.ToolPos[V.L.StartToolPos].Z
	V.P.ToolPosToCheck = V.L.StartToolPos
	
	; Mit Z-Laser Werkzeugplatz Prüfen
	L checkToolAtPos
	
	G01 X=V.L.PosX Y=V.L.PosY FV.E.FEEDFAST
	G04 XV.L.WaitTime
	
	; Mit Z-Laser Werkzeugplatz Prüfen
	L checkToolAtPos
$ELSE
   $FOR P1=V.L.StartToolPos, V.L.EndToolPos, 1
      V.L.PosX = V.E.ToolPos[P1].X 
      V.L.PosY = V.E.ToolPos[P1].Y 
      V.L.PosZ = V.E.ToolPos[P1].Z
	  V.P.ToolPosToCheck = P1
      
      ; Mit Z-Laser Werkzeugplatz Prüfen
		L checkToolAtPos
		
		G01 X=V.L.PosX Y=V.L.PosY FV.E.FEEDFAST
		G04 XV.L.WaitTime
		
		; Mit Z-Laser Werkzeugplatz Prüfen
		L checkToolAtPos
   $ENDFOR    
$ENDIF

#MCS ON EX TOOL

G01 Z=V.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch

L SAFEPOS 	;Achsen auf Sicherheitsposition fahren

M62   ; WZ-Klappe schliessen

#MSG SAVE EXCLUSIVE ["%S --- Die Ermittlung der Lasermesswerte zu den Werkzeugpositionen wurde beendet", V.G.TIME_STAMP_FILE_NAME]    
#MSG SYN HMI ["Die Ermittlung der Lasermesswerte zu den Werkzeugpositionen wurde beendet"]


#MEAS DEFAULT	; Wiederherstellen der Messeinstellungen aus den Achsparametern für alle Bahnachsen
#MCS OFF
#HSC ON 
#SLOPE[TYPE=HSC] ; Definition des Beschleunigungsverlaufs, Anwendungsart des Rucks

M30