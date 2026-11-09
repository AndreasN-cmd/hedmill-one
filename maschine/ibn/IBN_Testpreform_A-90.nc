LSAFEPOS

T9001 M6	; 3mm
S20000 M3
G57

G1 G90 B0 A-90 FV.E.FEEDFAST
G1 G90 X-6.75 Y0 FV.E.FEEDFAST
G1 G90 Z21 FV.E.FEEDSLOW

; "Rund fräsen"
; In Z-Richtung zustellen und B dabei drehen
;---------------------------------------------------------
$FOR P100=1,110,1
	G1 G91 Z-0.1 B360 F5000
	;G1 G91 B360 
$ENDFOR

G1 G90 X-6.25 Y-6.75 FV.E.FEEDFAST
G1 G90 Z20 FV.E.FEEDSLOW

; In Y-Richtung, linke Seite des Preforms abfraesen (9Uhr)
;---------------------------------------------------------
$FOR P100=1,60,1
	G1 G91 Y13.5 F3000
	G1 G91 Z-0.05 
	G1 G91 Y-13.5 
	G1 G91 Z-0.05 
$ENDFOR
G1 G90 Z20 F500
G1 G90 X-6.75 Y-6.25 F500

; In X-Richtung, untere Seite des Preforms abfraesen (6Uhr)
;---------------------------------------------------------
$FOR P100=1,60,1
	G1 G91 X13.5 F3000
	G1 G91 Z-0.05 
	G1 G91 X-13.5 
	G1 G91 Z-0.05 
$ENDFOR

G1 G90 Z25 F500 
M5
G53
LSAFEPOS
G0 G90 B270 ; Preform gerade drehen

M30