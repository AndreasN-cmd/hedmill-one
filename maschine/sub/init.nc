#VAR
 ;WZ-M.nc
	V.S.ToolOffset = 61.0638
	V.S.VorPos = 120
 ;BW.nc
 	V.S.MaxBlankPos = 1		;maximal mögliche Blankposition im Loader
	V.S.XBlankPos = 202.24	;zum Aufnehmen und Ablegen in Aufnahme
	V.S.YBlankPos = 309.94	;zum Aufnehmen und Ablegen in Aufnahme
	V.S.ZBlankPos = 56.48	;zum Aufnehmen und Ablegen in Aufnahme
	V.S.XVorPos = 201.94		;
	V.S.XVorPos2 = 161		;
	V.S.YVorPos = 308.74		;
	V.S.YVorPos2 = 305.04	;
	V.S.YVorPosA = 263		;Position bevor A gedreht wird
	V.S.AVorPos = -20			;um mit Y in bzw. aus dem Loader fahren zu können
	V.S.XLoaderBlankPos[8] = [77.5,351,351,351,351,351,351,351]
									;X-Blankpositionen im Loader
	V.S.YLoaderBlankPos[8] = [-4.4,113.72,148.72,183.72,218.72,253.72,288.72,323.72]
									;Y-Blankpositionen im Loader
	V.S.ZLoaderBlankPos[8] = [11.55,0.1,0.1,0.1,0.1,0.1,0.1,0.1]
									;Z-Blankpositionen im Loader
									
 ;WZW
   V.S.WZPruefen = 0
	V.S.WZW_PosX
	V.S.WZW_PosXVor = 51 ;290
	V.S.WZW_PosY
	V.S.WZW_PosYMitte = 35.5
	V.S.WZW_PosZ
	
;Home
	V.S.HomeX = 249.6 ;1
	V.S.HomeY = 350 ;249.6
#ENDVAR


	V.E.Messtasterpos[0] = 42.6   ;298.4	;PosY Messtaster
	V.E.Messtasterpos[1] = -12.5	;PosX Messtaster
	V.E.Messtasterpos[2] = 80		;Zmin beim Messen

;Werkzeugnummer setzen
	TV.E.AktToolNumber 
	DV.E.AktToolNumber

;Werkzeug pruefen
;Blank setzen

M17