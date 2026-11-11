( Home-Position anfahren )

(--Beschreibung-------------------------------------------------------------)
;  Mit diesem Programm wird einer vordefinierte Home-/Sicherheitsposition
;  aller Achsen angefahren
;
;	Version		Datum 		Name 				Änderungen
;	1.0.0		28.11.2024	H.-J. Albrecht		Programmerstellung
(---------------------------------------------------------------------------)

#VAR
	V.L.HomeX = -100
	V.L.HomeY = 0
#ENDVAR

L DYN-Standard

#HSC OFF
#MCS ON EX TOOL

#MSG SYN PLC ["Achsen fahren auf SAFEPOS"]
G01 Z=V.A.+SWE.Z-1 FV.E.FEEDMAX	;Z hoch
X=V.L.HomeX Y=V.L.HomeY A0 B0
#MSG SYN PLC ["Wechslerklappe schliessen"]
M62
#MSG SYN PLC ["Loadertuer entriegeln"]
M50
#MSG SYN PLC [""]

#MCS OFF
#HSC ON
#SLOPE[TYPE=HSC] ; Definition des Beschleunigungsverlaufs, Anwendungsart des Rucks

M30