; Mit diesem Programm wird der Blank von der Position 1 im Wechsler geholt
; ist schon ein Blank in der Maschine wird dieser vorher auf seinen Platz 
; im Wechsler zurück gebracht

V.E.FunctionNumber = 6000
V.E.FunctionValue = 2	; Blank-Platz im Wechsler

#MSG SAVE EXCLUSIVE ["%S --- Das Programm GetBlankPos%D wurde aufgerufen", V.G.TIME_STAMP_FILE_NAME, V.E.FunctionValue] 
		
#MSG SYN PLC ["Warte auf SPS-Bestätigung der Blankposition %D", V.E.FunctionValue]
#WAIT FOR V.E.FunctionNumber == -1
#MSG SYN PLC [""]

L blankchange

M30