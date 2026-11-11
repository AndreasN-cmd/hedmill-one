(------------------------- Wechslerkassette ausmessen ----------------------)

(--Beschreibung-------------------------------------------------------------)
;  Mit diesem Programm werden die Positionen von bis zu 4 Pins auf einem Blank
;  ermittelt, um das Nachfräsen von Lasermelting-Produkten zu ermöglichen
;  
;  Beschreibung
;  Grundlage ist ein gleichseitiges Dreieck oder ein Quadrat für die Anordnung 
;  der Pins. 
;  Bei der Dreieckanordnug liegt eine Ecke (PIN01) auf X0 und auf einer 
;  positiven Y-Position. Der Mittelpunkt des Dreiecks muss in der Mitte des Blanks 
;  liegen. 
;  Bsp:
;             1*
; 
;
;         3*      2*
;
;  Bei der quadratischen Anordnung liegt PIN01 auf X0 und auf einer 
;  positiven Y-Position oder auf einer negativen X-Position und auf einer 
;  positiven Y-Position.
;  Bsp:
;             1*                oder           1*       2*
;
;         4*       2*
;		  
;		      3*                               4*       3*
;
;  Weiter kann hier entschieden werden, ob alle vier Pins für die Vermessung 
;  verwender werden sollen oder nur drei. Über eine Variable kann entschieden 
;  werden welcher Pin nicht vermessen werden soll.
;
;  Die Reihenfolge der Pins wird im Uhrzeigersinn gezählt
;
;
;	Version		Datum 		Name 				Aenderungen
;	1.0.0		03.07.2025	H.-J. Albrecht		Programmerstellung            
(---------------------------------------------------------------------------)



( --------------- Unterprogramm Kreismittelpunkt Messung ------------- )
%L UP_FindPinCenterPoint
	V.L.MeasurementNo = 0
	V.L.PinHeightMeasured = 0
	#MCS OFF
	; -------------- Hoehe des PINs bestimmen
	#MEAS MODE [5]
	G310 G01 X=V.L.XCenter Y=V.L.YCenter FV.E.FEEDSLOW $GOTO [Label_Crash]
	G310 G01 Z=V.L.PinHeight+20 $GOTO [Label_Crash]

	[Label_PinHeight]
	#MEAS MODE [1]
	LL UP_Check3DIsReady
	G100 Z=V.L.PinHeight-1 FV.E.FEEDMEASURE		; Zmin beim Messen
	$IF V.A.MERF.Z == TRUE
		V.L.PinHeightMeasured = V.L.PinHeightMeasured + V.A.MESS.Z - V.G.WZ_AKT.L
		#MSG SAVE EXCLUSIVE ["%S --- PIN %U Z-Hoehe = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.PinHeightMeasured]
		#MSG SYN HMI ["PIN %U Z-Hoehe = %Fmm", V.L.No, V.L.PinHeightMeasured]
	$ELSE
		$GOTO [Label_NoValue]
	$ENDIF
	
	V.L.MeasurementNo = V.L.MeasurementNo + 1
	G01 Z=V.L.PinHeightMeasured/V.L.MeasurementNo+10 FV.E.FEEDSLOW		; Ausheben in Z
	
	$IF V.L.MeasurementNo < V.L.NumberOfRepeat
		G04 0.2
		#FLUSH WAIT
		$GOTO [Label_PinHeight]
	$ENDIF
	V.L.PinHeightMeasured = V.L.PinHeightMeasured/V.L.NumberOfRepeat
	#MSG SAVE EXCLUSIVE ["%S --- Mittelwert PIN %U Z-Hoehe = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.PinHeightMeasured]
	#MSG SYN HMI ["Mittelwert PIN %U Z-Hoehe = %Fmm", V.L.No, V.L.PinHeightMeasured]
	#FLUSH WAIT
	

	; -------------- erster Messpunkt fuer Mittelpunktbestimmung
	V.L.MeasurementNo = 0
	V.L.tmpMPs[0][0] = 0
	#MEAS MODE [5]
	G310 G01 X=V.L.XCenter-V.L.XYOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	G310 G01 Z=V.L.PinHeightMeasured+V.L.ZOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	V.L.tmpPos = V.A.ACT_POS.X	; X-Position auf Variable speichern
	#FLUSH WAIT

	[Label_MP01]
	#MEAS MODE [1]
	G100 X=V.L.XCenter-V.L.PinDiameter/2 FV.E.FEEDMEASURE	; Messen in X-Richtung
	G01 X=V.L.tmpPos FV.E.FEEDMEASURE
	#FLUSH WAIT
	$IF V.A.MERF.X == TRUE
		V.L.tmpMPs[0][0] = V.L.tmpMPs[0][0] + V.A.MESS.X
		V.L.tmpMPs[0][1] = V.A.ACT_POS.Y
		#MSG SAVE EXCLUSIVE ["%S --- PIN %U Messwert01 = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.tmpMPs[0][0]]
		#MSG SYN HMI ["PIN %U Messwert01 = %Fmm", V.L.No, V.L.tmpMPs[0][0]]
	$ELSE
		$GOTO [Label_NoValue]
	$ENDIF
	#FLUSH WAIT
	V.L.MeasurementNo = V.L.MeasurementNo + 1
	$IF V.L.MeasurementNo < V.L.NumberOfRepeat
		G04 0.2
		#FLUSH WAIT
		$GOTO [Label_MP01]
	$ENDIF
	V.L.tmpMPs[0][0] = V.L.tmpMPs[0][0]/V.L.NumberOfRepeat
	#MSG SAVE EXCLUSIVE ["%S --- Mittelwert PIN %U Messwert01 = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.tmpMPs[0][0]]
	#MSG SYN HMI ["Mittelwert PIN %U Messwert01 = %Fmm", V.L.No, V.L.tmpMPs[0][0]]
	#FLUSH WAIT

	; -------------- zweiter Messpunkt fuer Mittelpunktbestimmung
	V.L.MeasurementNo = 0
	V.L.tmpMPs[1][0] = 0
	#MEAS MODE [5]
	G310 G01 Z=V.L.PinHeightMeasured+V.L.XYOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	G310 G01 X=V.L.XCenter+V.L.XYOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	G310 G01 Z=V.L.PinHeightMeasured+V.L.ZOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	V.L.tmpPos = V.A.ACT_POS.X	; X-Position auf Variable speichern
	#FLUSH WAIT

	[Label_MP02]
	#MEAS MODE [1]
	LL UP_Check3DIsReady
	G100 X=V.L.XCenter+V.L.PinDiameter/2 FV.E.FEEDMEASURE	; Messen in X-Richtung
	G01 X=V.L.tmpPos FV.E.FEEDMEASURE
	#FLUSH WAIT
	$IF V.A.MERF.X == TRUE
		V.L.tmpMPs[1][0] = V.L.tmpMPs[1][0] + V.A.MESS.X
		V.L.tmpMPs[1][1] = V.A.ACT_POS.Y
		#MSG SAVE EXCLUSIVE ["%S --- PIN %U Messwert02 = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.tmpMPs[1][0]]
		#MSG SYN HMI ["PIN %U Messwert02 = %Fmm", V.L.No, V.L.tmpMPs[1][0]]
	$ELSE
		$GOTO [Label_NoValue]
	$ENDIF
	#FLUSH WAIT
	V.L.MeasurementNo = V.L.MeasurementNo + 1
	$IF V.L.MeasurementNo < V.L.NumberOfRepeat
		G04 0.2
		#FLUSH WAIT
		$GOTO [Label_MP02]
	$ENDIF
	V.L.tmpMPs[1][0] = V.L.tmpMPs[1][0]/V.L.NumberOfRepeat
	#MSG SAVE EXCLUSIVE ["%S --- Mittelwert PIN %U Messwert02 = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.tmpMPs[1][0]]
	#MSG SYN HMI ["Mittelwert PIN %U Messwert02 = %Fmm", V.L.No, V.L.tmpMPs[1][0]]
	#FLUSH WAIT

	; -------------- dritter Messpunkt fuer Mittelpunktbestimmung
	V.L.MeasurementNo = 0
	V.L.tmpMPs[2][1] = 0
	#MEAS MODE [5]
	G310 G01 Z=V.L.PinHeightMeasured+V.L.XYOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	G310 G01 X=V.L.XCenter FV.E.FEEDSLOW $GOTO [Label_Crash]
	G310 G01 Y=V.L.YCenter+V.L.XYOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	G310 G01 Z=V.L.PinHeightMeasured+V.L.ZOffset FV.E.FEEDSLOW $GOTO [Label_Crash]
	V.L.tmpPos = V.A.ACT_POS.Y	; Y-Position auf Variable speichern
	#FLUSH WAIT

	[Label_MP03]
	#MEAS MODE [1]
	LL UP_Check3DIsReady
	G100 Y=V.L.YCenter+V.L.PinDiameter/2 FV.E.FEEDMEASURE	; Messen in X-Richtung
	G01 Y=V.L.tmpPos FV.E.FEEDMEASURE
	#FLUSH WAIT
	$IF V.A.MERF.Y == TRUE
		V.L.tmpMPs[2][0] = V.A.ACT_POS.X
		V.L.tmpMPs[2][1] = V.L.tmpMPs[2][1] + V.A.MESS.Y
		#MSG SAVE EXCLUSIVE ["%S --- PIN %U Messwert03 = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.tmpMPs[2][1]]
		#MSG SYN HMI ["PIN %U Messwert03 = %Fmm", V.L.No, V.L.tmpMPs[2][1]]
	$ELSE
		$GOTO [Label_NoValue]
	$ENDIF
	#FLUSH WAIT
	V.L.MeasurementNo = V.L.MeasurementNo + 1
	$IF V.L.MeasurementNo < V.L.NumberOfRepeat
		G04 0.2
		#FLUSH WAIT
		$GOTO [Label_MP03]
	$ENDIF
	V.L.tmpMPs[2][1] = V.L.tmpMPs[2][1]/V.L.NumberOfRepeat
	#MSG SAVE EXCLUSIVE ["%S --- Mittelwert PIN %U Messwert03 = %Fmm", V.G.TIME_STAMP_FILE_NAME, V.L.No, V.L.tmpMPs[2][1]]
	#MSG SYN HMI ["Mittelwert PIN %U Messwert03 = %Fmm", V.L.No, V.L.tmpMPs[2][1]]
	#FLUSH WAIT

	G01 Z=V.L.PinHeightMeasured+20 FV.E.FEEDSLOW
	#MEAS MODE [5]
	G310 G01 Y=V.L.YCenter
	$GOTO [Label_END]

	; ----------------------------------------------------------------------------------------------------------
	; -- Sprungmarke wird verwendet, wenn Waehrend der eigentlichen Positionierung der 3D-Messtaster ausgelöst hat
	[Label_Crash]
		LL UP_3DCrashed
		M199
	; ----------------------------------------------------------------------------------------------------------
	; -- Sprungmarke wird verwendet, wenn Waehrend der Messwertermittlung kein Messwert ermittelt wurde
	[Label_NoValue]
		V.E.MessageNumber = 499	; Es wurde kein Messwert ermittelt
		#MCS ON EX TOOL
		G01 Z=V.A.+SWE.Z-1 FV.E.FEEDSLOW	;Z hoch
		#MCS OFF
		#MEAS MODE [5]
		$IF ABS[V.A.ACT_POS.X] > 1
			G310 G01 X0 FV.E.FEEDSLOW $GOTO [Label_MainCrash]
		$ENDIF
		$IF ABS[V.A.ACT_POS.Y] > 1
			G310 G01 Y0 FV.E.FEEDSLOW $GOTO [Label_MainCrash]
		$ENDIF

		
		M50   ; Loadertuer entriegeln
		#MSG SYN HMI ["Warte 3D-Messtaster ausgeschaltet"]
		M39	; 3D-Messtaster ausschalten	
		#MSG SYN HMI ["Es wurde kein Messwert ermittelt"]
		M199
		#FLUSH WAIT
	; ----------------------------------------------------------------------------------------------------------


	[Label_END]
	
M17


( --------------- Unterprogramm Kreismittelpunkt Berechnen ------------- )
%L UP_CalcPinCenterPoint
	P11 = V.L.tmpMPs[0][0]	;X1
	P12 = V.L.tmpMPs[0][1]	;Y1
	P21 = V.L.tmpMPs[1][0]	;X2
	P22 = V.L.tmpMPs[1][1]	;Y2
	P31 = V.L.tmpMPs[2][0]	;X3
	P32 = V.L.tmpMPs[2][1]	;Y3
	P40 = 2 * [P11 * [P22 - P32] + P21 * [P32 - P12] + P31 * [P12 - P22]]
	V.L.CalculatedCenter[0] = [[P11 * P11 + P12 * P12] * [P22 - P32] + [P21 * P21 + P22 * P22] * [P32 - P12] + [P31 * P31 + P32 * P32] * [P12 - P22]] / P40
	V.L.CalculatedCenter[1] = [[P11 * P11 + P12 * P12] * [P31 - P21] + [P21 * P21 + P22 * P22] * [P11 - P31] + [P31 * P31 + P32 * P32] * [P21 - P11]] / P40

M17


( ------------- Unterprogramm Abstände Berechnen Dreieck -------------- )
;Grundlage gleichseitiges Dreieck
%L UP_CalcPinCentrumTriangle
	; feste Distanz X PIN01
	V.L.XCenterPin[0] = 0.0		
	; berechnete Distanz X PIN02
	V.L.XCenterPin[1] = V.L.SideLength/2	
	; berechnete Distanz X PIN03	
	V.L.XCenterPin[2] = -V.L.SideLength/2			

	V.L.TmpValue[0] = SQR[V.L.SideLength]
	V.L.TmpValue[1] = V.L.SideLength/2  
	V.L.TmpValue[1] = SQR[V.L.TmpValue[1]]
	V.L.TmpValue[2] = SQRT[V.L.TmpValue[0]-V.L.TmpValue[1]]	;Dreieckhoehe   
	V.L.TmpValue[3] = V.L.SideLength/[SQRT[3]]	; Umkreisradius  
	; berechnete Distanz Y PIN01
	V.L.YCenterPin[0]= V.L.TmpValue[3]
	; berechnete Distanz Y PIN02
	V.L.YCenterPin[1] = V.L.YCenterPin[0] - V.L.TmpValue[2]
	; berechnete Distanz Y PIN03
	V.L.YCenterPin[2] = V.L.YCenterPin[0] - V.L.TmpValue[2]
M17


( ---------- Unterprogramm Abstände Berechnen Quadrat Spitze ---------- )
;Grundlage Quadrat auf Spitze gedreht
%L UP_CalcPinCentrumSquare01
	; feste Distanz X PIN01
	V.L.XCenterPin[0] = 0.0		
	; berechnete Distanz X PIN02
	V.L.XCenterPin[1] = SQRT[SQR[V.L.SideLength]/2]
	; feste Distanz X PIN03	
	V.L.XCenterPin[2] = 0.0		
	; berechnete Distanz X PIN04
	V.L.XCenterPin[3] = -V.L.XCenterPin[1]	

	; berechnete Distanz Y PIN01
	V.L.YCenterPin[0] = V.L.XCenterPin[1]
	; feste Distanz Y PIN02
	V.L.YCenterPin[1] = 0
	; berechnete Distanz Y PIN03
	V.L.YCenterPin[2] = -V.L.YCenterPin[0]
	; feste Distanz Y PIN04
	V.L.YCenterPin[3] = 0

M17


( ---------- Unterprogramm Abstände Berechnen Quadrat Seite ---------- )
;Grundlage Quadrat auf Seite gedreht
%L UP_CalcPinCentrumSquare02
	; berechnete Distanz X PIN01
	V.L.XCenterPin[0] = -V.L.SideLength]/2	
	; berechnete Distanz X PIN02
	V.L.XCenterPin[1] = V.L.SideLength]/2
	; berechnete Distanz X PIN03	
	V.L.XCenterPin[2] = V.L.SideLength]/2		
	; berechnete Distanz X PIN04
	V.L.XCenterPin[3] = -V.L.SideLength]/2	

	; berechnete Distanz Y PIN01
	V.L.YCenterPin[0] = V.L.SideLength]/2
	; berechnete Distanz Y PIN02
	V.L.YCenterPin[1] = V.L.SideLength]/2
	; berechnete Distanz Y PIN03
	V.L.YCenterPin[2] = -V.L.SideLength]/2
	; berechnete Distanz Y PIN04
	V.L.YCenterPin[3] = -V.L.SideLength]/2

M17


( --------------- Werte aus VP-Variablen holen ------------- )
%L UP_GetVPValues
	; verwendete Pin-Anordnung
	V.L.ArrayValue = 1
	$IF EXIST[V.P.PinLayout] == TRUE	; pruefen, ob Variable vorhanden
			$IF V.P.PinLayout >= 1 AND V.P.PinLayout <= 3	; pruefen, ob sinvoller Wert vorhanden
					V.L.PinLayout = V.P.PinLayout
					#MSG SAVE EXCLUSIVE ["%S --- Es wird die Anordnung aus V.P.PinLayout verwendet (Nr. %d)", V.G.TIME_STAMP_FILE_NAME, V.P.PinLayout]
				$ELSE
					#MSG SAVE EXCLUSIVE ["%S --- Es wird die Anordnung aus V.L.PinLayout verwendet (Nr. %d)", V.G.TIME_STAMP_FILE_NAME, V.L.PinLayout]
					#MSG SAVE EXCLUSIVE ["V.P.PinLayout liefert keinen sinvollen Wert (Nr. %d)", V.P.PinLayout]
					V.L.VPMissing[V.L.ArrayValue] = TRUE
			$ENDIF
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Die Variable V.P.PinLayout ist nicht definiert", V.G.TIME_STAMP_FILE_NAME] 
			#MSG SAVE EXCLUSIVE ["Es wird die vordefinierte Anordnung Nr. %d verwendet", V.L.PinLayout] 
			V.L.VPMissing[V.L.ArrayValue] = TRUE
	$ENDIF
	V.L.VPMissing[0] = V.L.VPMissing[0] OR V.L.VPMissing[V.L.ArrayValue] 
	$IF V.L.VPMissing[V.L.ArrayValue]
		V.E.MessageText = "PinLayout"
	$ENDIF
	
	; verwendete Seitenlaenge schreiben
	V.L.ArrayValue = V.L.ArrayValue + 1
	$IF EXIST[V.P.DropPin] == TRUE	; pruefen, ob Variable vorhanden
			$IF V.P.DropPin >= 0 AND V.P.DropPin <= 4	; pruefen, ob sinvoller Wert vorhanden
					V.L.DropPin = V.P.DropPin
					#MSG SAVE EXCLUSIVE ["%S --- Es wird der Wert aus V.P.DropPin verwendet (%d)", V.G.TIME_STAMP_FILE_NAME, V.P.DropPin]
				$ELSE
					#MSG SAVE EXCLUSIVE ["%S --- Es wird der Wert aus V.L.DropPin verwendet (%d)", V.G.TIME_STAMP_FILE_NAME, V.L.DropPin]
					#MSG SAVE EXCLUSIVE ["V.P.DropPin liefert keinen sinvollen Wert (%d)", V.P.DropPin]
					V.L.VPMissing[V.L.ArrayValue] = TRUE
			$ENDIF
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Die Variable V.P.DropPin ist nicht definiert", V.G.TIME_STAMP_FILE_NAME] 
			#MSG SAVE EXCLUSIVE ["Es wird der vordefinierte Wert aus %d verwendet", V.L.DropPin] 
			V.L.VPMissing[V.L.ArrayValue] = TRUE
	$ENDIF
	V.L.VPMissing[0] = V.L.VPMissing[0] OR V.L.VPMissing[V.L.ArrayValue] 
	$IF V.L.VPMissing[V.L.ArrayValue]
		V.E.MessageText = V.E.MessageText + ", DropPin"
	$ENDIF
	
	; verwendete Seitenlaenge schreiben
	V.L.ArrayValue = V.L.ArrayValue + 1
	$IF EXIST[V.P.SideLength] == TRUE	; pruefen, ob Variable vorhanden
			$IF V.P.SideLength >= 20.0 AND V.P.SideLength <= 80.0	; pruefen, ob sinvoller Wert vorhanden
					V.L.SideLength = V.P.SideLength
					#MSG SAVE EXCLUSIVE ["%S --- Es wird die Seitenlaenge aus V.P.SideLength verwendet (%f mm)", V.G.TIME_STAMP_FILE_NAME, V.P.SideLength]
				$ELSE
					#MSG SAVE EXCLUSIVE ["%S --- Es wird die Seitenlaenge aus V.L.SideLength verwendet (%f mm)", V.G.TIME_STAMP_FILE_NAME, V.L.SideLength]
					#MSG SAVE EXCLUSIVE ["V.P.SideLength liefert keinen sinvollen Wert (%f mm)", V.P.SideLength]
					V.L.VPMissing[V.L.ArrayValue] = TRUE
			$ENDIF
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Die Variable V.P.SideLength ist nicht definiert", V.G.TIME_STAMP_FILE_NAME] 
			#MSG SAVE EXCLUSIVE ["Es wird die vordefinierte Seitenlaenge %f mm verwendet", V.L.SideLength] 
			V.L.VPMissing[V.L.ArrayValue] = TRUE
	$ENDIF
	V.L.VPMissing[0] = V.L.VPMissing[0] OR V.L.VPMissing[V.L.ArrayValue] 
	$IF V.L.VPMissing[V.L.ArrayValue]
		V.E.MessageText = V.E.MessageText + ", SideLength"
	$ENDIF

	; verwendeten Pin-Durchmesser schreiben
	V.L.ArrayValue = V.L.ArrayValue + 1
	$IF EXIST[V.P.PinDiameter] == TRUE	; pruefen, ob Variable vorhanden
			$IF V.P.PinDiameter >= 5.0 AND V.P.PinDiameter <= 20.0	; pruefen, ob sinvoller Wert vorhanden
					V.L.PinDiameter = V.P.PinDiameter
					#MSG SAVE EXCLUSIVE ["%S --- Es wird der Pin-Durchmesser aus V.P.PinDiameter verwendet (%f mm)", V.G.TIME_STAMP_FILE_NAME, V.P.PinDiameter]
				$ELSE
					#MSG SAVE EXCLUSIVE ["%S --- Es wird der Pin-Durchmesser aus V.L.PinDiameter verwendet (%f mm)", V.G.TIME_STAMP_FILE_NAME, V.L.PinDiameter]
					#MSG SAVE EXCLUSIVE ["V.P.PinDiameter liefert keinen sinvollen Wert (%f mm)", V.P.PinDiameter]
					V.L.VPMissing[V.L.ArrayValue] = TRUE
			$ENDIF
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Die Variable V.P.PinDiameter ist nicht definiert", V.G.TIME_STAMP_FILE_NAME] 
			#MSG SAVE EXCLUSIVE ["Es wird der vordefinierte Durchmesser %f mm verwendet", V.L.PinDiameter] 
			V.L.VPMissing[V.L.ArrayValue] = TRUE
	$ENDIF
	V.L.VPMissing[0] = V.L.VPMissing[0] OR V.L.VPMissing[V.L.ArrayValue] 
	$IF V.L.VPMissing[V.L.ArrayValue]
		V.E.MessageText = V.E.MessageText + ", PinDiameter"
	$ENDIF

	; verwendete Pin-Hoehe schreiben
	V.L.ArrayValue = V.L.ArrayValue + 1
	$IF EXIST[V.P.PinHeight] == TRUE	; pruefen, ob Variable vorhanden
			$IF V.P.PinHeight >= 5.0 AND V.P.PinHeight <= 20.0	; pruefen, ob sinvoller Wert vorhanden
					V.L.PinHeight = V.P.PinHeight
					#MSG SAVE EXCLUSIVE ["%S --- Es wird der Pin-Durchmesser aus V.P.PinHeight verwendet (%f mm)", V.G.TIME_STAMP_FILE_NAME, V.P.PinHeight]
				$ELSE
					#MSG SAVE EXCLUSIVE ["%S --- Es wird der Pin-Durchmesser aus V.L.PinHeight verwendet (%f mm)", V.G.TIME_STAMP_FILE_NAME, V.L.PinHeight]
					#MSG SAVE EXCLUSIVE ["V.P.PinHeight liefert keinen sinvollen Wert (%f mm)", V.P.PinHeight]
					V.L.VPMissing[V.L.ArrayValue] = TRUE
			$ENDIF
		$ELSE
			#MSG SAVE EXCLUSIVE ["%S --- Die Variable V.P.PinHeight ist nicht definiert", V.G.TIME_STAMP_FILE_NAME] 
			#MSG SAVE EXCLUSIVE ["Es wird der vordefinierte Durchmesser %f mm verwendet", V.L.PinHeight] 
			V.L.VPMissing[V.L.ArrayValue] = TRUE
	$ENDIF
	V.L.VPMissing[0] = V.L.VPMissing[0] OR V.L.VPMissing[V.L.ArrayValue] 
	$IF V.L.VPMissing[V.L.ArrayValue]
		V.E.MessageText = V.E.MessageText + ", PinHeight"
	$ENDIF
	
	$IF V.L.VPMissing[0]
		V.E.MessageText = V.E.MessageText + " fehlt!"
	$ENDIF
M17


( --------------- pruefen ob 3D-Messtaster aktiv ------------- )
%L UP_Check3DIsReady
	$IF V.E.MeasureSignal[1] != 1	; pruefen ob der Messtaster ein 1-Signal liefert, 0 --> Störung
		V.E.MessageNumber = 208 (3D-Messtaster liefert vor der Messung 0-Wert)
		#MSG SAVE EXCLUSIVE ["%S --- Messung kann nicht durchgefuehrt werden, 3D-Messtaster nicht bereit", V.G.TIME_STAMP_FILE_NAME]
		#MSG SYN HMI ["Messung kann nicht durchgefuehrt werden, 3D-Messtaster nicht bereit"]
		M199
	$ENDIF
M17	


( --------------- 3D-Messtaster kollidiert ------------- )
%L UP_3DCrashed
	#MSG SAVE EXCLUSIVE ["%S --- Waehrend der Positionierung wurde der 3D-Messtaster ausgelöst", V.G.TIME_STAMP_FILE_NAME]
	#MSG SYN HMI ["Waehrend der Positionierung wurde der 3D-Messtaster ausgelöst"]
	V.E.MessageNumber = 420	; CRASH mit 3D-Taster
	M199
	#FLUSH WAIT
M17


( ---------------------------------------------------------------------- )
( ----------------- Hauptprogramm -------------------------------------- )
( ---------------------------------------------------------------------- )
%MAIN
#VAR
	V.L.PinLayout = 1							; 1=Dreieck, 2=Quadrat auf Spitze, 3=Quadrat auf Seite
	V.L.DropPin = 0								; nur bei Quadrat, welcher Pin wird nicht verwendet. 0=alle verwenden, 1-4 = dieser nicht
	V.L.SideLength = 69.0                       ; Seitenlaenge des Dreiecks
	V.L.PinDiameter = 5.0						; Durchmesser der Pins
	V.L.PinHeight = 15.0						; Hoehe der Pins bezogen auf Blankmitte
	V.L.VPMissing[6] : BOOLEAN				 	; [0]-SammelSignal, [1-5] = welche VP-Variable fehlt oder ist nicht richtig beschrieben
	V.L.ArrayValue = 0							; Zähler
	V.L.MeasurePin[4] : BOOLEAN					; definiert, ob ein Pin vermessen werden soll
	V.L.ResultValues[4][3] = [500.0, 500.0, 500.0, \	; berechnete Werte je PIN1 --> X, Y, Z
							500.0, 500.0, 500.0, \		;					  PIN2 --> X, Y, Z
							500.0, 500.0, 500.0, \		;					  PIN3 --> X, Y, Z
							500.0, 500.0, 500.0]		;					  PIN4 --> X, Y, Z

	; für UP_CalcPinCentrumTriangle/Square
	V.L.XCenterPin[4] = [500.0, 500.0, 500.0, 500.0] ; X-Abstand des der Pins zum Zentrum 
	V.L.YCenterPin[4] = [500.0, 500.0, 500.0, 500.0] ; Y-Abstand des der Pins zum Zentrum 
	
	; für UP_FindPinCenterPoint
	V.L.XCenter = 500.0							; X-Zielpunkt für die Pin-Messung
	V.L.YCenter = 500.0							; Y-Zielpunkt für die Pin-Messung
	V.L.XYOffset = 8.0							; Abstand in X und Y zum Zentrum, um die Messung zu starten
	V.L.ZOffset = -3.0							; Abstand zur Pin-Hoehe, um die Messwerte in XY durchzufuehren
	V.L.tmpMPs[3][2] = [500.0, 500.0, \			; gemessene XY-Werte für die Pin-Zentrum-Berechnung
						500.0, 500.0, \
						500.0, 500.0]
	V.L.PinHeightMeasured = 500.0				; gemessene Pin-Hoehe
	V.L.No										; Nummer des zu messenden Pins
	V.L.tmpPos									; Merker für Positionen
	
	V.L.NumberOfRepeat = 3						; Anzahl der Wiederholungen der einzelnen Messpunkte
	V.L.MeasurementNo = 0						; Zähler um die Wiederholungen zu zaehlen
	
	;für UP_CalcPinCenterPoint
	V.L.CalculatedCenter[2]	= [500.0, 500.0]

	; Temp-Werte für allgemeine Berechnungen
	V.L.TmpValue[6] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
#ENDVAR

#HSC OFF

M5    	; Fraesspindel aus
M9    	; Kuehlmittelpumpe aus

#MSG SAVE EXCLUSIVE ["%S --- Das Programm zum Ausmessen der Pins fürs Lasermelting wurde gestartet!", V.G.TIME_STAMP_FILE_NAME]

; Werte für die Berechnung aus VP-Variablen holen, falls vorhanden
LL UP_GetVPValues
$IF V.L.VPMissing[0]
	#MSG SAVE EXCLUSIVE ["%S --- Externe VP-Variablen nicht richtig definiert. Trotzdem weiter? Dann START druecken.", V.G.TIME_STAMP_FILE_NAME]
	#MSG SYN HMI["Externe VP-Variablen nicht richtig definiert. Trotzdem weiter? Dann START druecken."]
	; V.E.MessageText --> wurde schon in UP_GetVPValues beschrieben
	V.E.MessageNumber = 910	; Warnung in SPS erzeugen mit Text aus V.E.MessageText
	M199=1
	M0
	#FLUSH WAIT
$ENDIF

#MSG SYN HMI["Seitenlaenge = %f mm, Pin-Durchmesser = %f mm, Pin-Hoehe =  %f mm", V.L.SideLength, V.L.PinDiameter, V.L.PinHeight]
#FLUSH WAIT

L DYN-Standard

#MSG SAVE EXCLUSIVE ["%S --- Ist der 3D-Messtaster in der Fraesspindel? Wenn ja, dann START druecken.", V.G.TIME_STAMP_FILE_NAME] 
#MSG SYN HMI["Ist der 3D-Messtaster in der Fraesspindel? Wenn ja, dann START druecken."]
V.E.MessageText = "Ist der 3D-Messtaster in der Fraesspindel? Wenn ja, dann START druecken."
V.E.MessageNumber = 910	; Warnung in SPS erzeugen mit Text aus V.E.MessageText
M199=1	; M199 zum senden der Nachricht. =1 M199 wird quittiert
M0
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- Der Bediener hat bestätigt, dass der 3D-Messtaster in der Fraesspindel ist!", V.G.TIME_STAMP_FILE_NAME] 
#MSG SYN HMI["Der Bediener hat bestätigt, dass der 3D-Messtaster in der Fraesspindel ist!"]
V.E.MessageText = "Der Bediener hat bestätigt, dass der 3D-Messtaster in der Fraesspindel ist!"
V.E.MessageNumber = 920	; Info in SPS erzeugen mit Text aus V.E.MessageText
M199=1	; M199 zum senden der Nachricht. =1 M199 wird quittiert


T9999 ; T-Nummer 3D-Messtaster
D9999	; D-Nummer 3D-Messtaster
#FLUSH WAIT


L ToolWeightOff	; Werkzeugstandzeitgewichtung deaktivieren

#MSG SYN HMI ["Warte 3D-Messtaster eingeschaltet"]
M38	; 3D-Messtaster einschalten
G04 1
#FLUSH WAIT


;LL UP_Check3DIsReady

; ------------------------------------------------------------------------------------
				L measureTool
				#HSC OFF
				#FLUSH WAIT
				LL UP_Check3DIsReady
				#MSG SYN HMI [""]
				#MEAS [TYPE=1 EDGE=NEG INPUT=2]	; Umschaltung der Messsignalauswertung
				#MEAS MODE [5]
				#MCS ON EX TOOL
				G01 Z=V.A.+SWE.Z-1 FV.E.FEEDSLOW
				#MCS OFF
				G310 G01 X0 Y-69.5 FV.E.FEEDSLOW $GOTO [Label_MainCrash]
				#MSG SYN HMI ["Warte auf Wechslerklappe geschlossen"]
				M62	; Wechslerklappe öffnen
				#FLUSH WAIT
				#MSG SYN HMI [""]
; ------------------------------------------------------------------------------------


; erwartete PIN-Zentren berechnen
$IF V.L.PinLayout == 1
		LL UP_CalcPinCentrumTriangle
	$ELSEIF V.L.PinLayout == 2
		LL UP_CalcPinCentrumSquare01
	$ELSEIF V.L.PinLayout == 3
		LL UP_CalcPinCentrumSquare02
$ENDIF


; Definieren welcher PIN vermessen werden soll
$FOR P100 = 0, 3, 1
	$IF [V.L.PinLayout == 1 AND P100 < 3] OR [V.L.PinLayout > 1 AND V.L.PinLayout <= 3 AND V.L.DropPin != P100 + 1]
			V.L.MeasurePin[P100] = TRUE
	$ENDIF
$ENDFOR


; PIN-Zentren-Messung durchfuehren und berechnen
$FOR P100 = 0, 3, 1
	$IF V.L.MeasurePin[P100]
		#MCS ON EX TOOL
		G01 Z=V.A.+SWE.Z-1 FV.E.FEEDSLOW
			V.L.XCenter = V.L.XCenterPin[P100]
			V.L.YCenter = V.L.YCenterPin[P100]
			V.L.No = P100 + 1
			LL UP_FindPinCenterPoint	; PIN vermessen
			#FLUSH WAIT
			LL UP_CalcPinCenterPoint	; PIN-Zentren-Berechnung durchführen
			#FLUSH WAIT
			V.L.ResultValues[P100][0] = V.L.CalculatedCenter[0]
			V.L.ResultValues[P100][1] = V.L.CalculatedCenter[1]
			V.L.ResultValues[P100][2] = V.L.PinHeightMeasured
	$ENDIF
$ENDFOR	

; Protokollierung
#FILE NAME[MSG="C:\PINresult\PINresult.txt"]	; Datei für das Ergebnis

#MSG SAVE EXCLUSIVE ["-----------------------------------------------------------"]	
#MSG SAVE EXCLUSIVE ["%S --- Berechnung der PIN-Mittelpunkte beendet", V.G.TIME_STAMP_FILE_NAME]
#MSG SAVE EXCLUSIVE ["Gegebene Werte:"]
#MSG SAVE EXCLUSIVE ["Layout=%d, nicht zu messender PIN NR. %d", V.L.PinLayout, V.L.DropPin]		
#MSG SAVE EXCLUSIVE ["Seitenlaenge=%f, Pin-Durchmesser=%f, Pin-Hoehe=%f", V.L.SideLength, V.L.PinDiameter, V.L.PinHeight]	
#MSG SAVE EXCLUSIVE ["Berechnete Mittelpunkte für Messung:"]
$FOR P100 = 0, 3, 1
	#MSG SAVE EXCLUSIVE ["PIN %d X=%f Y=%f", P100+1, V.L.XCenterPin[P100], V.L.YCenterPin[P100]]
$ENDFOR
#MSG SAVE EXCLUSIVE ["Berechnetes Positionen der PINs:"]
$FOR P100 = 0, 3, 1
	#MSG SAVE EXCLUSIVE ["PIN %d X=%f Y=%f Z=%f", P100+1, V.L.ResultValues[P100][0], V.L.ResultValues[P100][1], V.L.ResultValues[P100][2]]
$ENDFOR
#MSG SAVE EXCLUSIVE ["-----------------------------------------------------------"]	

#FLUSH WAIT

#FILE NAME [MSG=V.P.MsgFileName]	; Log-Datei wieder aktvieren für Protokollierung
#FLUSH WAIT

$GOTO [Label_Ende]

; ----------------------------------------------------------------------------------------------------------
; -- Sprungmarke wird verwendet, wenn Waehrend der eigentlichen Positionierung der 3D-Messtaster ausgelöst hat
[Label_MainCrash]
	LL UP_3DCrashed
	M199
; ----------------------------------------------------------------------------------------------------------
	
[Label_Ende]


#FLUSH WAIT
V.E.FunctionNumber = 0
V.E.FunctionValue = 0
#FLUSH WAIT

#MCS ON EX TOOL
G01 Z=V.A.+SWE.Z-1 FV.E.FEEDSLOW
#MCS OFF

#MEAS MODE [5]
$IF ABS[V.A.ACT_POS.X] > 1
	G310 G01 X0 FV.E.FEEDSLOW $GOTO [Label_MainCrash]
$ENDIF
$IF ABS[V.A.ACT_POS.Y] > 1
	G310 G01 Y0 FV.E.FEEDSLOW $GOTO [Label_MainCrash]
$ENDIF

#FLUSH WAIT

M50   ; Loadertuer entriegeln
#MSG SYN HMI ["Warte 3D-Messtaster ausgeschaltet"]
M39	; 3D-Messtaster ausschalten
#MSG SYN HMI [""]

#MEAS DEFAULT
;#MCS OFF
#HSC ON

#MSG SAVE EXCLUSIVE ["%S --- !! WICHTIG !! 3D-Messtaster aus der Fraesspindel nehmen!!!", V.G.TIME_STAMP_FILE_NAME]
#MSG SYN HMI ["!! WICHTIG !! 3D-Messtaster aus der Fraesspindel nehmen!!!"]
M30
(---------------------- Wechslerkassette ausmessen ENDE -------------------)

