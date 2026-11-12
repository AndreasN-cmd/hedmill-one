; ==========================================================
; MESS_G58_A0_MKD V2 - MKD T4126 SAUBER MESSEN (gleiche Tonne)
; Werkzeuge: T4090 Torus D2.0 ER0.4, T4126 MKD Torus D2.01 ER0.2
; Rohling:  DIESELBE Messing-Tonne wie MESS_G58_A0_ENDWZ_V1
;           (Ringe 9.78 / 9.86 / 9.966), Gummihammer bis
;           Anschlag. NIE mit D16 fahren!
; ----------------------------------------------------------
; ZWECK: In V1 war Ring 1 (MKD) nicht allein messbar
;   (9.780 = groesster Wert von Ring 1 und 2). Hier entsteht
;   vorn EIN breites MKD-Band, dahinter ein T4090-Band.
;   MKD liegt 0.08 unter T4090 programmiert -> schneidet
;   sicher, auch wenn er bis 0.06 zu hoch sitzt.
;
; GEOMETRIE (G58, Stirnflaeche bei Y-20):
;   1) T4090 Z4.80 von Y-22 bis Y-14.4 (0.2 je Umdrehung)
;      -> D9.600 von der Stirn bis ca. Y-13.8
;   2) MKD   Z4.72 von Y-22 bis Y-16.5 (0.1 je Umdrehung)
;      -> D9.440 von der Stirn bis ca. Y-15.7  (4.3 mm breit)
;   Ergebnis von vorn: MKD-Band 4.3 mm | T4090-Band 1.7 mm |
;   Rest Ring C | REF 9.966 | Rohteil
;
; VOR DEM MESSEN ANSEHEN: Ist das vordere Band glaenzend
;   (MKD hat geschnitten) oder matt wie das T4090-Band?
;
; MESSEN (Buegelmessschraube, Grat weg, 2 Richtungen):
;   D_MKD : Amboss mind. 2.5 mm UEBER DIE STIRN ueberstehen
;           lassen (dann liegt er nur auf dem MKD-Band)  SOLL 9.440
;   D_T4090: Amboss mit der HINTEREN Kante an die Stufe zum
;           hoeheren Ring, nach vorn ueberstehen         SOLL 9.600
;
; AUSWERTUNG (Radius): (D_ist - D_soll) / 2
;   D_MKD   -> wie hoch/tief der MKD wirklich schneidet
;   D_T4090 -> T4090 mit leichtem Schnitt (V1 REF: -0.017)
;
; Werkzeuglaengen NICHT vorher per Refresh neu anlegen.
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; Laufzeit ca. 15 min.
; ==========================================================

LSAFEPOS

T4090 M6
S18500 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST

; ----------------------------------------------------------
; 1) T4090: vorn alles auf D9.600 (Z4.80), bis Y-14.4
;    Start 2 mm vor der Stirn in Luft
; ----------------------------------------------------------
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.8 FV.E.FEEDSLOW

$FOR P100=1,38,1
	G1 G91 Y0.2 B360 F3000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS

; ----------------------------------------------------------
; 2) MKD T4126: vorn D9.440 (Z4.72), X0, Y-22 -> Y-16.5
; ----------------------------------------------------------
T4126 M6
S6000 M3
M119 ; Spindel EIN -> Spindelluft EIN

G58

G1 G90 B0 A0 FV.E.FEEDFAST
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z4.72 FV.E.FEEDSLOW

$FOR P100=1,55,1
	G1 G91 Y0.1 B360 F3000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
