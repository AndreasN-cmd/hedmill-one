LSAFEPOS

T9001 M6
S20000 M3
G57

G1 G90 B0 A0 FV.E.FEEDFAST

G1 G90 X0 Y-21 FV.E.FEEDFAST
G1 G90 Z5 FV.E.FEEDSLOW

; In Y-Richtung zustellen und B dabei drehen
;---------------------------------------------------------
$FOR P100=1,90,1
	G1 G91 Y0.1 B360 F2000
$ENDFOR

G1 G90 Z20 F500
G1 G90 X-6.75 Y-21 F500
G1 G90 Z4.5

; In Z-Richtung, untere Seite des Preforms abfraesen (12Uhr)
;---------------------------------------------------------
$FOR P100=1,50,1
	G1 G91 X13.5 F3000
	G1 G91 Y0.05 
	G1 G91 X-13.5 
	G1 G91 Y0.05 
$ENDFOR

G1 G90 Z20 F500
G1 G90 X-6.75 Y-21 F500



G1 G90 X-6.25 Y-22 FV.E.FEEDFAST
G1 G90 Z3 FV.E.FEEDSLOW

; In Y-Richtung, linke Seite des Preforms abfraesen (9Uhr)
;---------------------------------------------------------
$FOR P100=1,70,1
	G1 G91 Y8 F3000
	G1 G91 Z-0.05 
	G1 G91 Y-8 
	G1 G91 Z-0.05 
$ENDFOR


G1 G90 Z25 F500 
M5
G53
LSAFEPOS
G0 G90 B270 ; Preform gerade drehen

M30