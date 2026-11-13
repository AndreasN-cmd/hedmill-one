; ==========================================================
; TEST_NURMESSEN V4 - "Nur messen" ohne Werkzeugwechsel und ohne cleanWS
; OHNE Bauteil, OHNE Preform. Kein Fraesen.
; ----------------------------------------------------------
; VORHER auf den Steuerungs-PC nach C:\HMI\NCProg\sub\ kopieren
; (aus eigene-programme\sub\, ohne Dateiendung):
;   MESST4089S40000DYN5G59      (neu)
;   WARMT4089S40000DYN5         (liegt seit 12.11. dort)
; ----------------------------------------------------------
; ZWECK: Ab CAM V5.49 ruft das Teleskop-NC am Ende des Jobs
;   "O0,6K Kavitaet Rest Ref 1,3" das Unterprogramm MESST... auf
;   (NC-Text "nach letzter Position"). Es merkt sich die Position,
;   faehrt auf SAFEPOS, haelt die Spindel an, misst mit dem
;   Hersteller-measureTool, startet die Spindel wieder und faehrt
;   zurueck: SAFEPOS180, G59, A/B, X/Y, Z. Kein M6, kein cleanWS.
;   Dieses Programm stellt die Lage wie am Jobende her (Position
;   aus einem echten Teleskop-NC, Rueckzugshoehe Z50) und ruft das
;   Unterprogramm fuenfmal auf:
;     1+2 direkt hintereinander  -> Wiederholgenauigkeit des Tasters
;     3-5 mit je 2 min Laufzeit  -> Drift nach dem Warmlauf
;
; SICHERHEIT: Gemessen wird nur bei stehender Spindel (M5 und 4 s
;   im Unterprogramm, measureTool schaltet selbst nochmal aus).
; ACHTEN: Nach jedem Messen muss die Wechslerklappe zu sein, bevor
;   die Spindel wieder anlaeuft. Die Achsen muessen danach wieder
;   auf A-95.5 B291.5 X-2.839 Y4.647 Z50 stehen (Anzeige G59).
;
; ABLAUF AN DER MASCHINE:
;   - Kein Bauteil, keine Preform noetig.
;   - Meldung "ohne Blankwechsel weiterarbeiten" am M6 bestaetigen.
;   - ERSTEN LAUF im Einzelsatz mit reduziertem Override.
;   - Laufzeit ca. 15 min.
;   - Danach LOGS_SAMMELN, Ordner an Claude (Suchwort MESST).
; ==========================================================

LSAFEPOS

M5
M118 ; Spindel AUS -> Spindelluft AUS
T4089 M6
LDYN5
L WARMT4089S40000DYN5
S40000 M3
M110 (Reinigungsluft Kasette Intervall EIN)
M120 (Reinigungsluft Traverse Intervall EIN)
M106 (Absaugung EIN)
M119 (Reinigungsluft Spindel Dauerhaft EIN)
L SAFEPOS180
G59
G1 A-95.50328 B291.53401 F25000.
G1 X-2.83898 Y4.64709
G1 Z50.0

; 1+2: zweimal direkt hintereinander (Wiederholgenauigkeit)
L MESST4089S40000DYN5G59
L MESST4089S40000DYN5G59

; 3-5: je 2 min Laufzeit bei 40 000, dann messen (Drift)
G04 120
L MESST4089S40000DYN5G59
G04 120
L MESST4089S40000DYN5G59
G04 120
L MESST4089S40000DYN5G59

; ----------------------------------------------------------
; Ende
; ----------------------------------------------------------
L SAFEPOS
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS

M30
