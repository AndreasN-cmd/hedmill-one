; ==========================================================
; MESS_G58_Z_T4090 V1 - GEGENPROBE G58-Z mit zweitem Werkzeug
; Werkzeug: T4090 - Torus D2.0, 3 Schneiden, frei 10 mm
; Rohling:  MESSING-Tonne D11.5 x 20 (neu ODER die schon
;           gefraeste Tonne aus MESS_G58_XZ, wieder eingespannt)
;           NIE mit D16 fahren!
; ----------------------------------------------------------
; ZWECK: MESS_G58_XZ hat mit T4081 (Kugel) einen um 0.125 zu
;   kleinen Durchmesser ergeben. Dieses Programm dreht ein
;   Band mit dem Torus T4090. Kommt dieselbe Abweichung
;   heraus, liegt es am Nullpunkt / Laengenoffset der Maschine.
;   Kommt eine andere heraus, liegt es an der Laengenmessung
;   des einzelnen Werkzeugs.
;
; GEOMETRIE (G58: Teilachse entlang Y, Z0 = Drehachse B):
;   Werkzeugstirn bei Z4.800, X0, B dreht, Y-22 -> Y-16
;   => Band D9.600 von der Stirnflaeche bis ca. Y-15.5
;
; MESSEN (Buegelmessschraube, Amboss zur Stirnseite hin):
;   D = Durchmesser des Bandes                 SOLL 9.600
;   Bei der schon gefraesten Tonne: schraeg zwischen den
;   Resten der alten Flaechen messen.
;
; AUSWERTUNG:
;   Abweichung Z (T4090) = 4.800 - D / 2
;   Vergleich mit T4081: +0.0625
;
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; ==========================================================

LSAFEPOS

T4090 M6
S18500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST

; ----------------------------------------------------------
; Band drehen mit der Werkzeugstirn, Z4.8 = Radius 4.800
; Start 2 mm vor der Stirnflaeche in Luft, 0.1 mm je Umdrehung
; ----------------------------------------------------------
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.8 FV.E.FEEDSLOW

$FOR P100=1,60,1
	G1 G91 Y0.1 B360 F2000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
