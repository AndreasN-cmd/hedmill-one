; ==========================================================
; MESS_ABS V3 - ABSOLUTES MESSPROGRAMM G58-Y (Drehfraesen A0)
; Werkzeuge: T4081 - Vollradius D3.0, 4 Schneiden, HL 8 (Schruppen)
;            T4090 - Torus D2.0, 3 Schneiden, HL 8 (Schlichten)
; Material: CoCr (auch Ti Gr.5 / Messing moeglich)
; ----------------------------------------------------------
; GEOMETRIE:
;   Y0             = HINTERER ANSCHLAG in der Aufnahme
;   Stirnflaeche   = Y-20.0 (= Basis des Implantatanschlusses)
;   Halterstirn    = physisch bei Y-4.5
;   Interface      = positiv (Ø4.5), ragt ueber Y-20.0 -> tabu
;
; V3: SOLLMASS HALBIERT AUF 5.00 mm
;   Schulterflaeche jetzt bei Y-15.000 (5 mm zum Basic).
;   Nut: 9.0 mm breit (Y-15.0 bis Y-6.0), Grund-Ø6.6 (Z3.3).
;   T4081 schruppt die Nut, Kante Y-14.9 (0.1 Aufmass).
;   T4090 schlichtet NUR die Schulter (Mitte Y-14.0 =>
;   Flanke Y-15.0), Z von 7.0 auf 4.2.
;   Nutende Y-6.0 wie gehabt 1.5 mm vor der Halterstirn.
;
; MESSEN (Messschieber aussen):
;   Backe auf Stirnflaeche, Messerschneide hinter die Schulter
;   (aeussere Ringhaelfte, nicht in den Grundradius).
;   SOLL = 20.0 - 15.0 = 5.00 mm
;   Delta = Ist - Soll  ->  G58-Y in Nullpunkttabelle korrigieren
; ==========================================================

LSAFEPOS

T4081 M6
S11500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST

; ----------------------------------------------------------
; 1) Nut SCHRUPPEN mit T4081 - radial eintauchen mit B-Rotation
;    Mitte Y-7.5 | Z 7.0 -> 3.3 (Grund-Ø6.6)
; ----------------------------------------------------------
G1 G90 X0 Y-7.5 FV.E.FEEDFAST
G1 G90 Z7 FV.E.FEEDSLOW

$FOR P100=1,74,1
	G1 G91 Z-0.05 B360 F1200
$ENDFOR

; axial Richtung Schulter bis Mitte Y-13.4 (Kante Y-14.9, 0.1 Aufmass)
$FOR P100=1,118,1
	G1 G91 Y-0.05 B360 F1200
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
LSAFEPOS

; ----------------------------------------------------------
; 2) Schulterflaeche SCHLICHTEN mit T4090 auf Y-15.000
;    Mitte Y-14.0 => Flanke bei Y-15.0 | Z von 7.0 auf 4.2
; ----------------------------------------------------------
T4090 M6
S18500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST
G1 G90 X0 Y-14.0 FV.E.FEEDFAST
G1 G90 Z7 FV.E.FEEDSLOW

$FOR P100=1,56,1
	G1 G91 Z-0.05 B360 F1000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
