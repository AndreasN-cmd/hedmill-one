; ==========================================================
; KONTROLL_TELESKOP V1 - Hohlzylinder mit 1.000 mm Wand
; Werkzeug: T4081 - Vollradius D3.0, 4 Schneiden, frei 8 mm
; Rohling:  MESSING-Tonne D11.5 x 20, OHNE Interface,
;           mit Gummihammer bis Anschlag
;           NIE mit D16 und NIE mit Interface-Preform fahren!
; ----------------------------------------------------------
; PRINZIP (wie ein echtes Primaerteleskop):
;   INNEN  wird bei A-90 (G59) mit stehendem B gefraest
;          => Bohrung sitzt auf dem Nullpunkt G59-X / G59-Y
;   AUSSEN wird bei A0 (G58) mit drehendem B gedreht
;          => Aussenflaeche sitzt auf der Drehachse B
;   Liegt G59-X/Y neben der Drehachse, wird die Wand auf einer
;   Seite dicker und gegenueber duenner.
;
; GEOMETRIE:
;   1) BOHRUNG D8.000 (Kreisbahn Radius 2.5 + Fraeser 1.5),
;      Z20.3 -> Z14.0, gerade Wand von der Stirn bis ca. Z15.5
;   2) MARKE TIEF  (0.8 mm) als Nut im Rand bei X-PLUS
;      MARKE FLACH (0.3 mm) als Nut im Rand bei Y-PLUS
;   3) AUSSEN D10.000 gedreht, Kugelspitze bei Z5.000,
;      Y-22 -> Y-12
;   => Wand SOLL (10.000 - 8.000) / 2 = 1.000
;
; MESSEN:
;   D  = Aussendurchmesser (Buegelmessschraube)      SOLL 10.000
;   Wandstaerke (Messschieber, immer gleich tief ansetzen,
;   ca. 2-3 mm unter dem Rand):
;   W1 = an der TIEFEN Marke          (X-PLUS)       SOLL 1.000
;   W2 = gegenueber der tiefen Marke  (X-MINUS)      SOLL 1.000
;   W3 = an der FLACHEN Marke         (Y-PLUS)       SOLL 1.000
;   W4 = gegenueber der flachen Marke (Y-MINUS)      SOLL 1.000
;
; AUSWERTUNG:
;   G59-X neu = alt + (W1 - W2) / 2
;   G59-Y neu = alt + (W3 - W4) / 2
;   Mittlere Wand = D / 2 - 4.000  (zeigt G58-Z / Werkzeuglaenge)
;   In Ordnung: alle vier Waende innerhalb 0.02 gleich
;
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; ==========================================================

LSAFEPOS

T4081 M6
S11500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G59

G1 G90 B0 A-90 FV.E.FEEDFAST
G1 G90 X1 Y0 FV.E.FEEDFAST
G1 G90 Z40 FV.E.FEEDFAST

; ----------------------------------------------------------
; 1) BOHRUNG D8.000 in Ebenen von 0.15 mm, B steht
;    je Ebene: Kreis Radius 1.0 (Mitte), Kreis Radius 2.5 (Wand),
;    dann schraeg um 0.15 nach unten zurueck zur Mitte
;    Start 0.3 mm ueber der Stirnflaeche in Luft
; ----------------------------------------------------------
G1 G90 Z20.3 FV.E.FEEDSLOW

$FOR P100=1,42,1
	G3 G90 X1 Y0 I-1 J0 F600
	G1 G91 X1.5 F600
	G3 G90 X2.5 Y0 I-2.5 J0 F600
	G1 G91 X-1.5 Z-0.15 F300
$ENDFOR

; letzte Ebene Z14.0 fertig fraesen
G3 G90 X1 Y0 I-1 J0 F600
G1 G91 X1.5 F600
G3 G90 X2.5 Y0 I-2.5 J0 F600

; in die Mitte und hoch auf Markenhoehe
G1 G90 X0 Y0 F600

; ----------------------------------------------------------
; 2) MARKEN im Rand: tief bei X-PLUS, flach bei Y-PLUS
;    Werkzeug faehrt aus der Bohrung seitlich durch den Rand
; ----------------------------------------------------------
G1 G90 Z19.2 F500
G1 G90 X4.6 F300
G1 G90 X0 F600

G1 G90 Z19.7 F500
G1 G90 Y4.6 F300
G1 G90 Y0 F600

G1 G90 Z40 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
LSAFEPOS

; ----------------------------------------------------------
; 3) AUSSEN D10.000 drehen bei A0 mit der Kugelspitze
;    Start 2 mm vor der Stirnflaeche in Luft, 0.1 mm je Umdrehung
; ----------------------------------------------------------
S11500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z5 FV.E.FEEDSLOW

$FOR P100=1,100,1
	G1 G91 Y0.1 B360 F2000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
