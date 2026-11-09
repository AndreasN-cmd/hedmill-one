; ==========================================================
; MESS_G59_XY V1 - MESSPROGRAMM G59-X und G59-Y (A-90)
; Werkzeug: T4081 - Vollradius D3.0, 4 Schneiden, frei 8 mm
; Rohling:  MESSING-Tonne D11.5 x 20, mit Gummihammer bis Anschlag
;           NIE mit D16 fahren (Kollision beim Eintauchen)!
; ----------------------------------------------------------
; GEOMETRIE (G59: Teilachse entlang Z, Z0 = hinterer Anschlag,
;            X0 / Y0 = Drehachse B, Stirnflaeche bei Z20):
;   1) RUND: Flanke bei X-5.25 (Mitte X-6.75), B dreht,
;      Z21 -> Z13 => Zylinder D10.500, gerade bis Z14.5
;   2) FLAECHE LANG (5 mm):  Flanke X-MINUS, Mitte X-6.5
;      => Ebene X-5.000, 0.25 tief
;   3) FLAECHE KURZ (3 mm):  Flanke Y-MINUS, Mitte Y-6.5
;      => Ebene Y-5.000, 0.25 tief
;   4) B um +135 Grad
;   5) FLAECHE MITTEL (4 mm): Flanke X-PLUS, Mitte X+6.5
;      => Ebene X+5.000, 0.25 tief
;   Alle Flaechen laufen an der Stirnseite aus. Gegenueber ist
;   jeweils rund. Unterscheidung NUR ueber die Laenge 5 / 4 / 3.
;
; MESSEN (Buegelmessschraube, vorher Grat an den Kanten weg):
;   M1 = LANGE   Flaeche (5 mm) -> runde Gegenseite   SOLL 10.250
;   M2 = MITTLERE Flaeche (4 mm) -> runde Gegenseite  SOLL 10.250
;   M3 = KURZE   Flaeche (3 mm) -> runde Gegenseite   SOLL 10.250
;   D  = Durchmesser, wo beidseitig keine Flaeche ist SOLL 10.500
;
; AUSWERTUNG (Werkzeugradius und Abdraengung fallen heraus):
;   G59-X neu = alt + (M1 - M2) / 2
;   G59-Y neu = alt + M3 - (M1 + M2) / 2
;   Kontrolle Werkzeug: (M1 + M2) / 2 - D / 2 - 5.000 = ca. 0
;   G59-Z NICHT aus diesem Programm (kommt aus MESS_REL_PLAN)
;
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; ==========================================================

LSAFEPOS

T4081 M6
S11500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G59

G1 G90 B0 A-90 FV.E.FEEDFAST
G1 G90 X-6.75 Y0 FV.E.FEEDFAST
G1 G90 Z40 FV.E.FEEDFAST

; ----------------------------------------------------------
; 1) RUND drehen mit der Flanke, Start 1 mm ueber der Stirn,
;    0.1 mm je Umdrehung nach unten bis Z13 (7 mm Eingriff)
; ----------------------------------------------------------
G1 G90 Z21 FV.E.FEEDSLOW

$FOR P100=1,80,1
	G1 G91 Z-0.1 B360 F3000
$ENDFOR

; erst seitlich weg, dann hoch (kein Schleifen am Rundkoerper)
G1 G90 X-8.5 F500
G1 G90 Z40 F500

; ----------------------------------------------------------
; 2) FLAECHE LANG mit der Flanke X-MINUS (B unveraendert)
;    Bahn in Y von -4 nach +4, Ein- und Austritt in Luft
;    Z von 20.5 auf 13.5 => Flaeche 5 mm lang
; ----------------------------------------------------------
G1 G90 X-6.5 Y-4 FV.E.FEEDFAST
G1 G90 Z20.5 FV.E.FEEDSLOW

$FOR P100=1,70,1
	G1 G91 Y8 F1500
	G1 G91 Z-0.05
	G1 G91 Y-8
	G1 G91 Z-0.05
$ENDFOR

G1 G90 Z40 F500

; ----------------------------------------------------------
; 3) FLAECHE KURZ mit der Flanke Y-MINUS (B unveraendert)
;    Bahn in X von -4 nach +4
;    Z von 20.5 auf 15.5 => Flaeche 3 mm lang
; ----------------------------------------------------------
G1 G90 X-4 Y-6.5 FV.E.FEEDFAST
G1 G90 Z20.5 FV.E.FEEDSLOW

$FOR P100=1,50,1
	G1 G91 X8 F1500
	G1 G91 Z-0.05
	G1 G91 X-8
	G1 G91 Z-0.05
$ENDFOR

G1 G90 Z40 F500

; ----------------------------------------------------------
; 4) Teil um 135 Grad weiterdrehen (Werkzeug steht oben frei)
; ----------------------------------------------------------
G1 G91 B135 F3000

; ----------------------------------------------------------
; 5) FLAECHE MITTEL mit der Flanke X-PLUS
;    Bahn in Y von -4 nach +4
;    Z von 20.5 auf 14.5 => Flaeche 4 mm lang
; ----------------------------------------------------------
G1 G90 X6.5 Y-4 FV.E.FEEDFAST
G1 G90 Z20.5 FV.E.FEEDSLOW

$FOR P100=1,60,1
	G1 G91 Y8 F1500
	G1 G91 Z-0.05
	G1 G91 Y-8
	G1 G91 Z-0.05
$ENDFOR

G1 G90 Z40 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
