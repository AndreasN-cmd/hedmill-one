T9001 M6
S20000 M3
G58
G1 G90 B0 A-90 FV.E.FEEDFAST

G1 G90 X-6.75 Y-6.75 FV.E.FEEDFAST
G1 G90 Z20 FV.E.FEEDSLOW

; In Y-Richtnug, linke Seite des Preforms abfraesen (9Uhr)
;---------------------------------------------------------
$FOR P100=1,60,1
	G1 G91 Y13.5 F3000
	G1 G91 Z-0.05 
	G1 G91 Y-13.5 
	G1 G91 Z-0.05 
$ENDFOR
G1 G90 Z20 F500
G1 G90 X-6.75 Y-6.75 F500

; In X-Richtnug, untere Seite des Preforms abfraesen (6Uhr)
;---------------------------------------------------------
$FOR P100=1,60,1
	G1 G91 X13.5 F3000
	G1 G91 Z-0.05 
	G1 G91 X-13.5 
	G1 G91 Z-0.05 
$ENDFOR

G1 G90 Z25 F500 M5
G53
LSAFEPOS
G0 G90 B270 ; Preform gerade drehen

M30