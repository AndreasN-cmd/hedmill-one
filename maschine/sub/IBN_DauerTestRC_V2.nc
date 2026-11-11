(-------------------- Rundwechslertest -----------------------)

(--Beschreibung-------------------------------------------------------------)
;  Mit diesem Programm werden die Positionen und das Ausheben und Ablegen 
;  von Blankhaltern im Rundwechsler getestet. Dafuer wird ein Blankhalter 
;  benoetigt welche auf die Startposition gesetzt werden muss.
;  Nach dem Starten des Programms wird die Startposition angefahren und der Blank
;  durch den Lift bis an die obere Endlage gefahren. Danach positioniert der 
;  Rundwechsler eine Position weiter und der Lift setzt den Blank auf dieser
;  Position wieder ab. Nach einer Wartezeit wird der Blank wieder in die obere
;  Endlage gehoben. Nach dem Erreichen der letzten Position wird der angehobene
;  Blankhalter wieder auf der Startposition abgelegt.
;
;  Es kann auch ein Dauertest gestartet werden. Dazu muss V.L.RepeatTest=1 und
;  V.L.Runs die Anzahl der Durchlaeufe eingetragen werden. Wenn dort eine -1 
;  eingetragen wird, laeuft der Test Endlos.
;
;
;	Version		Datum 		Name 				aenderungen
;	1.0.0		27.05.2026	H.-J. Albrecht		Programmerstellung
;
(---------------------------------------------------------------------------)

#VAR
	V.L.StartPos = 1	 	; Position bei der Test starten soll. Dort ist dann der Blankhalter
	V.L.EndPos = 30			; Position bei der Test beendet oder ab der wiederholt werden soll+
	V.L.MoveToPos 			; diese Variable wird für die Positionierung des Rundwechslers verwendet
	V.L.RepeatTest = 0		; 0 = Wiederholung deaktiviert   1= Wiederholung aktiviert
	V.L.Runs = -1			; Anzahl der Durchlaeufe. -1 = unendlich
	V.L.CycleNo	= 0			; diese Variable wird zum Zählen der Zyklen verwendet
	V.L.Finished = FALSE	; TRUE = Ein Zyklus durchlaufen
#ENDVAR


#MSG SYN HMI ["Loadertuer bitte schliessen"]
M51   	; Loadertuer verriegeln
#FLUSH WAIT

#MSG SYN HMI ["Warte auf Wechslerklappe geschlossen"]
M61		; Wechslerklappe oeffnen
#FLUSH WAIT

#MSG SYN HMI ["Warte auf Hubzylinder unten"]
M93   ; pruefen ob Hubzylinder unten
#FLUSH WAIT

#MSG SYN HMI [""]

#MSG SAVE EXCLUSIVE ["--------------------------------------"]
#MSG SAVE EXCLUSIVE ["%S --- Wechslertest wurde gestartet", V.G.TIME_STAMP_FILE_NAME]
	
V.L.MoveToPos = V.L.StartPos	; Startwert fuer Rundwechslerpositionierung setzen
[LABEL_START]
   #FLUSH WAIT
	V.E.FunctionNumber = 3500	; Starte Rundwechsler auf Position aus FunctionValue
	V.E.FunctionValue = V.L.MoveToPos + 100
	#MSG SAVE EXCLUSIVE ["%S --- Positionierung Rundwechsler wurde gestartet zu Pos %d", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
	#MSG SYN HMI ["Positionierung Rundwechsler wurde gestartet zu Pos %d", V.L.MoveToPos]
	M90	; Rundwechsler Positionierung starten
	#FLUSH WAIT
	G04 1
	#FLUSH WAIT
	M91	; warten das Rundwechsler Position erreicht hat
	#MSG SYN HMI ["Warte auf Rundwechsler Position erreicht"]
	#FLUSH WAIT
	$IF V.E.FeedbackMFunc == -91 
		#MSG SAVE EXCLUSIVE ["%S --- Rundwechsler hat die Pos. %d nicht erreicht", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
		#MSG SYN HMI ["Rundwechsler hat die Pos. %d nicht erreicht", V.L.MoveToPos]
		M199
		#FLUSH WAIT
	$ENDIF
	$IF V.E.HWInput.BlankExistRC == TRUE
			#MSG SAVE EXCLUSIVE ["%S --- Pos. %d erreicht. Blank vorhanden", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
			#MSG SYN HMI ["Pos. %d erreicht. Blank vorhanden", V.L.MoveToPos]
			#FLUSH WAIT
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Pos. %d erreicht. Kein Blank vorhanden", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
			#MSG SYN HMI ["Pos. %d erreicht. Kein Blank vorhanden. ABBRUCH!", V.L.MoveToPos]
			M199
			#FLUSH WAIT
	$ENDIF
	
	V.L.MoveToPos = V.L.MoveToPos + 1	; nächste Position berechnen
	$IF V.L.MoveToPos > V.L.EndPos		; prüfen ob letzte Position schon angefahren wurde
		V.L.MoveToPos = V.L.StartPos	; wieder Startposition fuer Rundwechslerpositionierung setzen
	$ENDIF


[LABEL_CYCLE]	
	#MSG SYN HMI ["Warte auf Hubzylinder oben"]
	M92 ; Blankhubzylinder Rundwechsler HEBEN
	G04 2 
	#FLUSH WAIT
	V.E.FunctionNumber = 3500	; Starte Rundwechsler auf Position aus FunctionValue
	V.E.FunctionValue = V.L.MoveToPos + 100
	#MSG SAVE EXCLUSIVE ["%S --- Positionierung Rundwechsler wurde gestartet zu Pos %d", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
	#MSG SYN HMI ["Positionierung Rundwechsler wurde gestartet zu Pos %d", V.L.MoveToPos]
	M90	; Rundwechsler Positionierung starten
	#FLUSH WAIT
	G04 1
	#FLUSH WAIT
	M91	; warten das Rundwechsler Position erreicht hat
	#MSG SYN HMI ["Warte auf Rundwechsler Position erreicht"]
	#FLUSH WAIT
	$IF V.E.FeedbackMFunc == -91 
		#MSG SAVE EXCLUSIVE ["%S --- Rundwechsler hat die Pos. %d nicht erreicht", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
		#MSG SYN HMI ["Rundwechsler hat die Pos. %d nicht erreicht", V.L.MoveToPos]
		M199
		#FLUSH WAIT
	$ENDIF
	$IF V.E.HWInput.BlankExistRC == FALSE	; Position soll leer sein
			#MSG SAVE EXCLUSIVE ["%S --- Pos. %d erreicht. Kein Blank vorhanden", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
			#MSG SYN HMI ["Pos. %d erreicht. Kein Blank vorhanden", V.L.MoveToPos]
			#FLUSH WAIT
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Pos. %d erreicht. Blank vorhanden. ABBRUCH!", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
			#MSG SYN HMI ["Pos. %d erreicht. Blank vorhanden. ABBRUCH!", V.L.MoveToPos]
			M199
			#FLUSH WAIT
	$ENDIF
		
	#MSG SYN HMI ["Warte auf Hubzylinder unten"]
	M93 ; Blankhubzylinder Rundwechsler SENKEN
	G04 2 
	#FLUSH WAIT
	$IF V.E.HWInput.BlankExistRC == TRUE
			#MSG SAVE EXCLUSIVE ["%S --- Blankhalter wurde auf Pos. %d richtig abgesetzt", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
			#MSG SYN HMI ["Blankhalter wurde auf Pos. %d richtig abgesetzt", V.L.MoveToPos]
			#FLUSH WAIT
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Blankhalter wurde auf Pos. %d nicht richtig abgesetzt. ABBRUCH!", V.G.TIME_STAMP_FILE_NAME, V.L.MoveToPos]
			#MSG SYN HMI ["Blankhalter wurde auf Pos. %d nicht richtig abgesetzt. ABBRUCH!", V.L.MoveToPos]
			M199
			#FLUSH WAIT
	$ENDIF
	#FLUSH WAIT
	
	V.L.MoveToPos = V.L.MoveToPos + 1	; nächste Position berechnen
	$IF V.L.MoveToPos > V.L.EndPos		; prüfen ob letzte Position schon angefahren wurde
		V.L.MoveToPos =  V.L.StartPos	; wieder Startposition fuer Rundwechslerpositionierung setzen
		V.L.Finished = TRUE
		V.L.CycleNo = V.L.CycleNo + 1
		#MSG SAVE EXCLUSIVE ["%S --- Rundwechslertest Zyklus %d durchlaufen", V.G.TIME_STAMP_FILE_NAME, V.L.CycleNo]
		#MSG SYN HMI ["Rundwechslertest Zyklus %d durchlaufen", V.L.CycleNo]
	$ENDIF
	
	$IF V.L.RepeatTest	; Dauertest an ?
			V.L.Finished = FALSE
			#FLUSH WAIT
			$IF V.L.Runs < 0	; Endlos ?
					$GOTO [LABEL_CYCLE]
				$ELSEIF V.L.CycleNo <= V.L.Runs	; Anzahl der Durchlaeufe erreicht ?
					$GOTO [LABEL_CYCLE]
			$ENDIF
		$ELSEIF V.L.MoveToPos <= V.L.EndPos AND V.L.Finished == FALSE
			$GOTO [LABEL_CYCLE]
		$ELSEIF V.L.MoveToPos == V.L.StartPos AND V.L.Finished == TRUE
			$GOTO [LABEL_CYCLE]
	$ENDIF
		
		
	M62		; Wechslerklappe schliessen
	
	#MSG SAVE EXCLUSIVE ["%S --- Wechslertest wurde beendet", V.G.TIME_STAMP_FILE_NAME]
   #MSG SAVE EXCLUSIVE ["--------------------------------------"]
   #MSG SYN HMI ["Wechslertest wurde beendet"]
		


M30
