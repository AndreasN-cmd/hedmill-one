; ==========================================================
; MESS_G58_A0_ENDWZ V1 - DREHFRAESMASS DER TELESKOP-ENDWERKZEUGE
; Werkzeuge: T4090 Torus D2.0 ER0.4 (Bezug, vorschlichten)
;            T4126 MKD Torus D2.01 ER0.2 (Friktion)
;            T4089 Kugel D0.6 (Hohlkehlenringe), mittig und
;                  seitlich versetzt X1.5 wie in den Ringjobs
; Rohling:  NEUE MESSING-Tonne D11.5 x 20, Gummihammer bis
;           Anschlag. NIE mit D16 fahren!
; ----------------------------------------------------------
; ZWECK (Fit-Check 12.11.2026): Die Kontroll-Tonne vom 11.11.
;   lief nur mit T4081/T4090. Dieses Programm prueft, ob MKD
;   und T4089 bei A0 unter G58 das programmierte Mass drehen.
;   Messing: fast keine Abdraengung -> reine Lage/Laenge.
;
; GEOMETRIE (G58: Teilachse entlang Y, Y0 = hinterer Anschlag,
;            X0/Z0 = Drehachse B, Stirnflaeche bei Y-20):
;   Treppe, nach vorn (Stirn) immer kleiner:
;   A  MKD  T4126  X0    D 9.700  Y-20.0 bis ca. Y-17.5 (vorn)
;   B  Kugel T4089 X0    D 9.800  ca. Y-17.3 bis Y-15.3
;   C  Kugel T4089 X1.5  D 9.900  ca. Y-14.8 bis Y-12.8
;   REF Torus T4090 X0   D10.000  ca. Y-12.5 bis Y-9.4
;   dahinter Rohteil D11.5
;   T4090 schlichtet vor auf Endmass +0.03 (D9.76/9.86/9.96),
;   die Endwerkzeuge nehmen je 0.03 im Radius.
;   C: Kugelmitte X1.5, Abstand zur Achse 5.25 ->
;      Kugelspitze Z = sqrt(5.25^2 - 1.5^2) - 0.3 = 4.7312
;
; MESSEN (Buegelmessschraube, Grat weg, je Band 2 Richtungen
;   um 90 Grad versetzt, Mittel notieren): Amboss mit der
;   HINTEREN Kante an die hintere Stufe des Bandes legen und
;   nach vorn ueberstehen lassen (vorn ist alles kleiner,
;   beruehrt nicht). Band A: Amboss steht ueber die Stirn.
;   D_REF  SOLL 10.000
;   D_C    SOLL  9.900
;   D_B    SOLL  9.800
;   D_A    SOLL  9.700
;
; AUSWERTUNG (Radius): Abweichung = (D_ist - D_soll) / 2
;   REF ~ 0     : Grundzustand wie Kontroll-Tonne 11.11.
;   A  negativ  : MKD dreht kleiner als programmiert (Friktion)
;   B, C negativ: T4089 dreht kleiner (Ringe, Teil 12.11.)
;   C - B       : Einfluss seitlicher Versatz / G58-X
;
; Werkzeuglaengen NICHT vorher per Refresh neu anlegen, das
; Programm soll den Zustand messen, mit dem gefraest wird.
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; Laufzeit ca. 40 min.
; ==========================================================

LSAFEPOS

T4090 M6
S18500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST

; ----------------------------------------------------------
; R1) Bezug: ganze Laenge auf D10.000 (Z5.000)
;     Start 2 mm vor der Stirn in Luft, 0.1 mm je Umdrehung
; ----------------------------------------------------------
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z5 FV.E.FEEDSLOW

$FOR P100=1,120,1
	G1 G91 Y0.1 B360 F3000
$ENDFOR

G1 G90 Z25 F500

; ----------------------------------------------------------
; R2) Vorschlichten Band C: D9.960 (Z4.98) bis Y-13.2
; ----------------------------------------------------------
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.98 FV.E.FEEDSLOW

$FOR P100=1,44,1
	G1 G91 Y0.2 B360 F4000
$ENDFOR

G1 G90 Z25 F500

; ----------------------------------------------------------
; R3) Vorschlichten Band B: D9.860 (Z4.93) bis Y-15.6
; ----------------------------------------------------------
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.93 FV.E.FEEDSLOW

$FOR P100=1,32,1
	G1 G91 Y0.2 B360 F4000
$ENDFOR

G1 G90 Z25 F500

; ----------------------------------------------------------
; R4) Vorschlichten Band A: D9.760 (Z4.88) bis Y-18.0
; ----------------------------------------------------------
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.88 FV.E.FEEDSLOW

$FOR P100=1,20,1
	G1 G91 Y0.2 B360 F4000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS

; ----------------------------------------------------------
; A) MKD T4126: D9.700 (Z4.85), X0, Y-22 -> Y-18.3
;    0.1 mm je Umdrehung (Stirnflaeche D1.61 deckt ab)
; ----------------------------------------------------------
T4126 M6
S6000 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.85 FV.E.FEEDSLOW

$FOR P100=1,37,1
	G1 G91 Y0.1 B360 F3000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS

; ----------------------------------------------------------
; B) Kugel T4089 mittig: D9.800 (Z4.90), X0
;    Y-22 -> Y-18.0 schnell in Luft (ueber Band A, D9.70)
;    Y-18.0 -> Y-15.3 mit 0.03 mm je Umdrehung
; ----------------------------------------------------------
T4089 M6
S40000 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.9 FV.E.FEEDSLOW

$FOR P100=1,16,1
	G1 G91 Y0.25 B360 F10000
$ENDFOR

$FOR P100=1,90,1
	G1 G91 Y0.03 B360 F10000
$ENDFOR

G1 G90 Z25 F500

; ----------------------------------------------------------
; C) Kugel T4089 seitlich X1.5 wie die Ringjobs: D9.900
;    Kugelspitze Z4.7312 (Mitte X1.5 / Z5.0312, Abstand 5.25)
;    Y-22 -> Y-15.5 schnell in Luft (ueber A und B, <= D9.80)
;    Y-15.5 -> Y-12.8 mit 0.03 mm je Umdrehung
; ----------------------------------------------------------
G1 G90 X1.5 Y-22 FV.E.FEEDFAST
G1 G90 Z4.7312 FV.E.FEEDSLOW

$FOR P100=1,26,1
	G1 G91 Y0.25 B360 F10000
$ENDFOR

$FOR P100=1,90,1
	G1 G91 Y0.03 B360 F10000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
