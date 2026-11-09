; ==========================================================
; MESS_G58_XZ V1 - MESSPROGRAMM G58-X und G58-Z (Drehfraesen A0)
; Werkzeug: T4081 - Vollradius D3.0, 4 Schneiden, frei 8 mm
; Rohling:  MESSING-Tonne D11.5 x 20, mit Gummihammer bis Anschlag
;           NIE mit D16 fahren (Kollision beim Eintauchen)!
; ----------------------------------------------------------
; GEOMETRIE (G58: Teilachse entlang Y, Y0 = hinterer Anschlag,
;            X0 / Z0 = Drehachse B, Stirnflaeche bei Y-20):
;   1) RUND: Kugelspitze bei Z5.000, X0, B dreht, Y-22 -> Y-10
;      => Zylinder D10.000 von der Stirn bis Y-10
;   2) FLAECHE LANG (6.0 mm): Flanke X-MINUS, B wie nach dem Drehen
;      Werkzeugmitte X-6.25 => Ebene X-4.750, 0.25 tief
;   3) B um +90 Grad
;   4) FLAECHE KURZ (3.5 mm): Flanke X-PLUS
;      Werkzeugmitte X+6.25 => Ebene X+4.750, 0.25 tief
;   Beide Flaechen laufen an der Stirnseite aus und liegen am
;   Teil um 90 Grad versetzt. Gegenueber ist jeweils rund.
;
; MESSEN (Buegelmessschraube, vorher Grat an den Kanten weg):
;   D  = Durchmesser, diagonal ZWISCHEN den Flaechen   SOLL 10.000
;   M1 = LANGE Flaeche -> runde Gegenseite              SOLL  9.750
;   M2 = KURZE Flaeche -> runde Gegenseite              SOLL  9.750
;
; AUSWERTUNG (Werkzeugradius und Abdraengung fallen heraus):
;   G58-X neu = alt + (M1 - M2) / 2
;   G58-Z neu = alt + (5.000 - D / 2)
;   Kontrolle Werkzeug: (M1 + M2) / 2 - D / 2 - 4.750 = ca. 0
;   G58-Y NICHT aus diesem Programm (kommt aus MESS_ABS)
;
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; ==========================================================

LSAFEPOS

T4081 M6
S11500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST

; ----------------------------------------------------------
; 1) RUND drehen mit der Kugelspitze, Z5 = Radius 5.000
;    Start 2 mm vor der Stirnflaeche in Luft, 0.1 mm je Umdrehung
; ----------------------------------------------------------
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z5 FV.E.FEEDSLOW

$FOR P100=1,120,1
	G1 G91 Y0.1 B360 F2000
$ENDFOR

G1 G90 Z25 F500

; ----------------------------------------------------------
; 2) FLAECHE LANG mit der Flanke X-MINUS (B unveraendert)
;    Eintauchen in Luft vor der Stirn, Z von 1.0 auf -3.2
;    Flaeche von der Stirn bis Y-14.0
; ----------------------------------------------------------
G1 G90 X-6.25 Y-22.5 FV.E.FEEDFAST
G1 G90 Z1 FV.E.FEEDSLOW

$FOR P100=1,42,1
	G1 G91 Y8.5 F1500
	G1 G91 Z-0.05
	G1 G91 Y-8.5
	G1 G91 Z-0.05
$ENDFOR

G1 G90 Z25 F500

; ----------------------------------------------------------
; 3) Teil um 90 Grad weiterdrehen (Werkzeug steht oben frei)
; ----------------------------------------------------------
G1 G91 B90 F3000

; ----------------------------------------------------------
; 4) FLAECHE KURZ mit der Flanke X-PLUS
;    Flaeche von der Stirn bis Y-16.5
; ----------------------------------------------------------
G1 G90 X6.25 Y-22.5 FV.E.FEEDFAST
G1 G90 Z1 FV.E.FEEDSLOW

$FOR P100=1,42,1
	G1 G91 Y6 F1500
	G1 G91 Z-0.05
	G1 G91 Y-6
	G1 G91 Z-0.05
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
