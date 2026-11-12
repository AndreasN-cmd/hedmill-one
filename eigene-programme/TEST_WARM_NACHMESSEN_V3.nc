; ==========================================================
; TEST_WARM_NACHMESSEN V3 - Warmlauf-Unterprogramme (Version 2) pruefen
; OHNE Bauteil, OHNE Preform. Kein Fraesen, nur Werkzeugwechsel,
; Spindel in Sicherheitsposition und Messen am Taster.
; ----------------------------------------------------------
; VORHER auf den Steuerungs-PC nach C:\HMI\NCProg\sub\ kopieren
; (aus eigene-programme\sub\, ohne Dateiendung):
;   WARMT4083S18000DYN4
;   WARMT4089S40000DYN5
;   WARMT4126S6000DYN17
; ----------------------------------------------------------
; ZWECK: hyperDENT schreibt NC-Text nur einzeilig (Test A). Der
;   Ablauf steht deshalb im Unterprogramm, der Job ruft es auf.
;   Dieses Programm ruft die Unterprogramme GENAU an der Stelle
;   auf, an der sie im Teleskop-NC stehen werden:
;     T.. M6 / LDYN.. / L WARM... / S.. M3 / M110 / M120 / M106 / M119
;   Je Unterprogramm (Version 2): Werkzeug pruefen, 4 min auf
;   Drehzahl, M5, 3 s, V.G.WZ_AKT.P[0] = 0, L measureTool (Hersteller,
;   macht selbst M5, misst voll), Werkzeugdaten laden, SAFEPOS,
;   Klappe zu (M62), LDYN.., Laenge ins Log. OHNE zweites M6, damit
;   die Reinigungsfahrt cleanWS entfaellt (Andreas 12.11.).
;   (V1-Test mit zweitem M6 lief am 12.11. fehlerfrei.)
;   T4089 und T4126 zweimal (Laenge nach 4 und nach 8 min).
;
; SICHERHEIT: Vor dem Messen M5 + 3 s, measureTool schaltet die
;   Spindel selbst nochmal aus. Vor jedem M6 dieses Programms M5.
; ACHTEN: Nach jedem Nachmessen muss die Wechslerklappe wieder zu
;   sein (M62), bevor die Spindel wieder anlaeuft.
;
; ABLAUF AN DER MASCHINE:
;   - Kein Bauteil, keine Preform noetig.
;   - Meldung "ohne Blankwechsel weiterarbeiten" je M6 bestaetigen.
;   - ERSTEN LAUF im Einzelsatz mit reduziertem Override.
;   - Laufzeit ca. 25 min.
;   - Danach LOGS_SAMMELN, Ordner an Claude (Suchwort WARMT).
; ==========================================================

LSAFEPOS

; ----------------------------------------------------------
; 1) T4083 wie Kavitaet Job 1 (SLM) / Job 5 (Bar)
; ----------------------------------------------------------
M5
M118 ; Spindel AUS -> Spindelluft AUS
T4083 M6
LDYN4
L WARMT4083S18000DYN4
S18000 M3
M110 (Reinigungsluft Kasette Intervall EIN)
M120 (Reinigungsluft Traverse Intervall EIN)
M106 (Absaugung EIN)
M119 (Reinigungsluft Spindel Dauerhaft EIN)

; ----------------------------------------------------------
; 2) T4089 wie Job 16/24 (SLM) / 20/28 (Bar), zweimal
; ----------------------------------------------------------
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
L WARMT4089S40000DYN5
S40000 M3
M119 (Reinigungsluft Spindel Dauerhaft EIN)

; ----------------------------------------------------------
; 3) T4126 MKD wie Job 25 (SLM) / 29 (Bar), direkt nach T4089,
;    zweimal
; ----------------------------------------------------------
M5
M118 ; Spindel AUS -> Spindelluft AUS
T4126 M6
LDYN17
L WARMT4126S6000DYN17
S6000 M3
M110 (Reinigungsluft Kasette Intervall EIN)
M120 (Reinigungsluft Traverse Intervall EIN)
M106 (Absaugung EIN)
M119 (Reinigungsluft Spindel Dauerhaft EIN)
L WARMT4126S6000DYN17
S6000 M3
M119 (Reinigungsluft Spindel Dauerhaft EIN)

; ----------------------------------------------------------
; Ende
; ----------------------------------------------------------
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS

M30
