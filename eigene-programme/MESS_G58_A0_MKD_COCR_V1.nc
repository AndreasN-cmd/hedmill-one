; ==========================================================
; MESS_G58_A0_MKD_COCR V1 - MKD T4126 IN CoCr MIT WARMLAUF
; Werkzeuge: T4090 Torus D2.0 ER0.4 (CoCr, vorschlichten/Bezug)
;            T4126 MKD Torus D2.01 ER0.2 Z1 (Friktion)
; Rohling:  NEUE Kera-Disc-Stange CoCr D11.5 x 20 (4.5 mm
;           Spannlaenge), gleicher Halter wie Primaerteleskop
;           CoCr Bar / Messing-Tonne. NIE mit D16 fahren!
; ----------------------------------------------------------
; ZWECK (Andreas 12.11.2026 nach Fit-Check V5.40): messen, wie
;   tief der MKD im CoCr-Teleskop wirklich schneidet - im selben
;   Zustand wie im Teleskop-Job (CAM V5.43 Bar Job 29 / SLM 25):
;   CoCr, 6000 min-1, 8000 Grad/min, 0.025 je Umdrehung, LDYN17,
;   Warmlauf 4 min + Nachmessen ueber L WARMT4126S6000DYN17
;   (wird automatisch aufgerufen, wie im Teleskop-NC).
;   Ergebnis = MKD-Fehler fuer die naechste Version
;   (CAM: docs/auslenkung_werkzeuge.md Abschnitt 27 Punkt 15).
;
; VORHER: WARMT4126S6000DYN17 liegt in C:\HMI\NCProg\sub\
;   (laeuft seit CAM V5.39 in jedem Teleskop).
;
; GEOMETRIE (G58: Teilachse entlang Y, Y0 = hinterer Anschlag,
;            X0/Z0 = Drehachse B, Stirnflaeche bei Y-20):
;   1) T4090 X0, S14000, 3 Gaenge je 0.05 im Radius
;      (Schnittwerte wie Konnektoren CoCr Bar: ap 0.05, 0.1 je
;      Umdrehung, ca. 800 mm/min)
;      Z5.70 / Z5.65 / Z5.60, Y-22 bis Y-13
;      -> D11.200 von der Stirn bis ca. Y-12.4
;   2) MKD X0, Z5.54, Y-22 bis Y-16.5, 0.025 je Umdrehung
;      -> D11.080 von der Stirn bis ca. Y-15.7 (4.3 mm breit)
;      MKD nimmt 0.06 im Radius (im Job V5.43 ca. 0.03): schneidet
;      sicher, auch wenn er bis 0.05 zu hoch sitzt.
;   Ergebnis von vorn: MKD-Band 4.3 mm | T4090-Band ca. 3.3 mm |
;   Rohteil D11.5
;
; VOR DEM MESSEN: 5 min abkuehlen lassen. Ansehen: Ist das
;   vordere Band glaenzend (MKD hat geschnitten) oder matt wie
;   das T4090-Band (MKD sitzt mehr als 0.05 zu hoch)?
;
; MESSEN (Buegelmessschraube, Grat weg, je Band 2 Richtungen
;   um 90 Grad versetzt, Mittel notieren):
;   D_MKD  : Amboss mind. 2.5 mm UEBER DIE STIRN ueberstehen
;            lassen (liegt nur auf dem MKD-Band)    SOLL 11.080
;   D_T4090: Amboss mit der HINTEREN Kante an die Stufe zum
;            Rohteil D11.5, nach vorn ueberstehen  SOLL 11.200
;
; AUSWERTUNG (Radius): (D_ist - D_soll) / 2
;   D_MKD   positiv: MKD schneidet zu hoch (Teil groesser)
;           negativ: MKD schneidet zu tief (Teil kleiner)
;   D_T4090 -> Grundzustand (Messing 12.11.: -0.017)
;   Werte (D_MKD, D_T4090, glaenzend ja/nein) an Claude.
;
; Werkzeuglaengen NICHT vorher per Refresh neu anlegen: das
;   Programm soll den Zustand messen, mit dem gefraest wird.
; ERSTEN LAUF im Einzelsatz mit Override fahren!
; Laufzeit ca. 30 min (T4090 12 min, Warmlauf 5 min, MKD 10 min).
; ==========================================================

LSAFEPOS

; ----------------------------------------------------------
; 1) T4090: vorn auf D11.200 (Z5.60) in 3 Gaengen, bis Y-13
;    Start 2 mm vor der Stirn in Luft
; ----------------------------------------------------------
T4090 M6
S14000 M3
M110 (Reinigungsluft Kasette Intervall EIN)
M120 (Reinigungsluft Traverse Intervall EIN)
M106 (Absaugung EIN)
M119 (Reinigungsluft Spindel Dauerhaft EIN)

G58

G1 G90 B0 A0 FV.E.FEEDFAST
G1 G90 X0 Y-22 FV.E.FEEDFAST

; Gang 1: Z5.70 (D11.40)
G1 G90 Z5.70 FV.E.FEEDSLOW
$FOR P100=1,90,1
	G1 G91 Y0.1 B360 F8000
$ENDFOR
G1 G90 Z6.2 F500
G1 G90 Y-22 FV.E.FEEDFAST

; Gang 2: Z5.65 (D11.30)
G1 G90 Z5.65 FV.E.FEEDSLOW
$FOR P100=1,90,1
	G1 G91 Y0.1 B360 F8000
$ENDFOR
G1 G90 Z6.2 F500
G1 G90 Y-22 FV.E.FEEDFAST

; Gang 3: Z5.60 (D11.20) = Bezug und Vorschlichten MKD-Band
G1 G90 Z5.60 FV.E.FEEDSLOW
$FOR P100=1,90,1
	G1 G91 Y0.1 B360 F8000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS

; ----------------------------------------------------------
; 2) MKD T4126 wie im Teleskop-Job: M6, LDYN17, Warmlauf 4 min
;    + Nachmessen (Unterprogramm), dann vorn D11.080 (Z5.54),
;    X0, Y-22 -> Y-16.5, 0.025 je Umdrehung, 8000 Grad/min
; ----------------------------------------------------------
T4126 M6
LDYN17
L WARMT4126S6000DYN17
S6000 M3
M110 (Reinigungsluft Kasette Intervall EIN)
M120 (Reinigungsluft Traverse Intervall EIN)
M106 (Absaugung EIN)
M119 (Reinigungsluft Spindel Dauerhaft EIN)

G58

G1 G90 B0 A0 FV.E.FEEDFAST
G1 G90 X0 Y-22 FV.E.FEEDFAST
G1 G90 Z5.54 FV.E.FEEDSLOW

$FOR P100=1,220,1
	G1 G91 Y0.025 B360 F8000
$ENDFOR

G1 G90 Z25 F500
M5
M118 ; Spindel AUS -> Spindelluft AUS
M9 (Kuehlmittelemulsion AUS)
M107 (Absaugung AUS)
G53
LSAFEPOS
G0 G90 B290 ; Preform gerade drehen

M30
