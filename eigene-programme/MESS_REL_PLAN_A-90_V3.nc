; ==========================================================
; MESS_REL_PLAN V3 - RELATIVES KONTROLLPROGRAMM Teil 1 (A-90)
; Werkzeuge: T4081 - Vollradius D3.0, 4 Schn., HL 8 (Schruppen)
;            T4090 - Torus D2.0, 3 Schn., HL 8 (Finish-Ebene)
; Material: CoCr / Messing (Messing ideal: kein Verschleiss,
;           keine Abdraengung)
; ----------------------------------------------------------
; ZWECK: Implantatanschluss auf A-90 (G59) planen, in Kreisen
;   von aussen nach innen, inkl. 0.5 mm der Tonne.
;   T4081 schruppt bis 0.1 ueber Ziel, T4090 schlichtet die
;   Ebene auf Z19.5 -> saubere plane Messflaeche.
;   DANACH: MESS_ABS_G58Y_A0_V3 in DERSELBEN Aufspannung
;   laufen lassen. Messung Stirnflaeche->Schulter:
;   SOLL dann 4.50 mm (5.00 minus 0.5 Abtrag).
; ----------------------------------------------------------
; GEOMETRIE (Interface-Ø4.5 bestaetigt):
;   G59: Teilachse entlang Z, Z0 = hinterer Anschlag
;   Stirnflaeche bei Z20.0  ->  Zielflaeche Z19.5
;   Eintauchen bei X4.3: sicher auch fuer 6kt mit 4.5 ueber
;   die FLAECHEN (Eckenradius bis ~2.6). Interface-Hoehe
;   max. 3.0 weiterhin Annahme - sonst Startebene anpassen!
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; ==========================================================

LSAFEPOS

T4081 M6
S11500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G59

G1 G90 B0 A-90 FV.E.FEEDFAST
G1 G90 X4.3 Y0 FV.E.FEEDFAST
G1 G90 Z40 FV.E.FEEDFAST

; ----------------------------------------------------------
; PHASE 1 (T4081): Interface abraeumen, Ebenen 0.3,
;                  Eintauchen in Luft bei X4.3 (6kt-sicher)
; ----------------------------------------------------------
; --- Ebene Z22.7 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z22.7 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z22.4 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z22.4 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z22.1 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z22.1 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z21.8 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z21.8 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z21.5 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z21.5 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z21.2 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z21.2 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z20.9 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z20.9 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z20.6 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z20.6 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z20.3 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z20.3 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

; --- Ebene Z20 ---
G1 G90 X4.3 Y0 F900
G1 G90 Z20 F300
G1 G90 X3.5 F900
G3 X3.5 Y0 I-3.5 J0 F900
G1 G90 X2.7 F900
G3 X2.7 Y0 I-2.7 J0 F900
G1 G90 X1.9 F900
G3 X1.9 Y0 I-1.9 J0 F900
G1 G90 X1.1 F900
G3 X1.1 Y0 I-1.1 J0 F900
G1 G90 X0.3 F900
G3 X0.3 Y0 I-0.3 J0 F900

G1 G90 Z25 F500

; ----------------------------------------------------------
; PHASE 2 (T4081): Vollflaeche schruppen bis Z19.6
;                  (0.1 Aufmass), Eintauchen in Luft bei X7.4
; ----------------------------------------------------------
; --- Ebene Z19.8 ---
G1 G90 X7.4 Y0 F900
G1 G90 Z19.8 F300
G1 G90 X6.6 F900
G3 X6.6 Y0 I-6.6 J0 F900
G1 G90 X5.8 F900
G3 X5.8 Y0 I-5.8 J0 F900
G1 G90 X5 F900
G3 X5 Y0 I-5 J0 F900
G1 G90 X4.2 F900
G3 X4.2 Y0 I-4.2 J0 F900
G1 G90 X3.4 F900
G3 X3.4 Y0 I-3.4 J0 F900
G1 G90 X2.6 F900
G3 X2.6 Y0 I-2.6 J0 F900
G1 G90 X1.8 F900
G3 X1.8 Y0 I-1.8 J0 F900
G1 G90 X1 F900
G3 X1 Y0 I-1 J0 F900
G1 G90 X0.2 F900
G3 X0.2 Y0 I-0.2 J0 F900

; --- Ebene Z19.6 ---
G1 G90 X7.4 Y0 F900
G1 G90 Z19.6 F300
G1 G90 X6.6 F900
G3 X6.6 Y0 I-6.6 J0 F900
G1 G90 X5.8 F900
G3 X5.8 Y0 I-5.8 J0 F900
G1 G90 X5 F900
G3 X5 Y0 I-5 J0 F900
G1 G90 X4.2 F900
G3 X4.2 Y0 I-4.2 J0 F900
G1 G90 X3.4 F900
G3 X3.4 Y0 I-3.4 J0 F900
G1 G90 X2.6 F900
G3 X2.6 Y0 I-2.6 J0 F900
G1 G90 X1.8 F900
G3 X1.8 Y0 I-1.8 J0 F900
G1 G90 X1 F900
G3 X1 Y0 I-1 J0 F900
G1 G90 X0.2 F900
G3 X0.2 Y0 I-0.2 J0 F900

G1 G90 Z40 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
LSAFEPOS

; ----------------------------------------------------------
; PHASE 3 (T4090): Ebene schlichten auf Z19.5 (ZIEL),
;                  Eintauchen in Luft bei X6.9
; ----------------------------------------------------------
T4090 M6
S18500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G59

G1 G90 B0 A-90 FV.E.FEEDFAST
G1 G90 X6.9 Y0 FV.E.FEEDFAST
G1 G90 Z40 FV.E.FEEDFAST

; --- Ebene Z19.5 ---
G1 G90 X6.9 Y0 F700
G1 G90 Z19.5 F300
G1 G90 X6.2 F700
G3 X6.2 Y0 I-6.2 J0 F700
G1 G90 X5.4 F700
G3 X5.4 Y0 I-5.4 J0 F700
G1 G90 X4.6 F700
G3 X4.6 Y0 I-4.6 J0 F700
G1 G90 X3.8 F700
G3 X3.8 Y0 I-3.8 J0 F700
G1 G90 X3 F700
G3 X3 Y0 I-3 J0 F700
G1 G90 X2.2 F700
G3 X2.2 Y0 I-2.2 J0 F700
G1 G90 X1.4 F700
G3 X1.4 Y0 I-1.4 J0 F700
G1 G90 X0.6 F700
G3 X0.6 Y0 I-0.6 J0 F700

G1 G90 Z40 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
