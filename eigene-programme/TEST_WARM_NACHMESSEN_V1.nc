; ==========================================================
; TEST_WARM_NACHMESSEN V1 - Warmlauf 4 min + Nachmessen pruefen
; OHNE Bauteil, OHNE Preform. Kein Fraesen, nur Werkzeugwechsel,
; Spindel in Sicherheitsposition und Messen am Taster.
; Werkzeuge in Job-Reihenfolge aussen: T4098 -> T4089 -> T4126
; ----------------------------------------------------------
; ZWECK:
;  1) Pruefen, ob dieser Befehlsblock fehlerfrei laeuft (spaeter
;     als NC-Text in den Drehfraes-Vorlagen):
;       S.. M3 / M119 / G04 240        Spindel 4 min auf Drehzahl
;       M5 / M118 / G04 3              Spindel AUS, Stillstand
;       V.G.WZ_AKT.P[0] = 0            naechstes M6 misst VOLL
;       T.. M6                         gleiches Werkzeug: Hersteller-
;                                      M6 haelt Spindel an (M5),
;                                      misst (measureTool), laedt
;                                      Werkzeugdaten, Klappe zu
;       LDYN.. / S.. M3 / M119         wie der Postprozessor
;  2) Nebenbei messen, wie stark die Spindel waechst/schrumpft:
;     T4089 und T4126 je zweimal 4 min (zeigt, ob 4 min reichen).
;
; SICHERHEIT: Gemessen wird nur im Hersteller-M6. Das M6 schaltet
;   die Spindel vor jeder Messung selbst aus (M5); zusaetzlich
;   steht vorher M5 + 3 s Pause. Nie Messen bei drehender Spindel.
;
; ABLAUF AN DER MASCHINE:
;   - Kein Bauteil, keine Preform im Halter noetig.
;   - Meldung "ohne Blankwechsel weiterarbeiten" je M6 bestaetigen.
;   - ERSTEN LAUF im Einzelsatz mit reduziertem Override, danach
;     Automatik. Laufzeit ca. 30 min.
;   - Bricht ein Satz mit Fehler ab: Satznummer und Meldung notieren.
;   - Danach HMI-Log (LOGS_SAMMELN) an Claude. Suchwort WARMTEST.
; ==========================================================

LSAFEPOS

; ----------------------------------------------------------
; 1) T4098 Kugel D1.0 FS3, 19500 (Hohlkehlenringe)
; ----------------------------------------------------------
T4098 M6
LDYN4
S19500 M3
M119 ; Spindel EIN -> Spindelluft EIN
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D geholt, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

G04 240            ; 4 min auf Drehzahl
M5
M118 ; Spindel AUS -> Spindelluft AUS
G04 3
V.G.WZ_AKT.P[0] = 0
T4098 M6
LDYN4
S19500 M3
M119 ; Spindel EIN -> Spindelluft EIN
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D nach 4 min nachgemessen, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

; ----------------------------------------------------------
; 2) T4089 Kugel D0.6, 40000 (Hohlkehlenringe), zweimal 4 min
; ----------------------------------------------------------
M5
M118 ; Spindel AUS -> Spindelluft AUS
T4089 M6
LDYN5
S40000 M3
M119 ; Spindel EIN -> Spindelluft EIN
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D geholt, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

G04 240
M5
M118 ; Spindel AUS -> Spindelluft AUS
G04 3
V.G.WZ_AKT.P[0] = 0
T4089 M6
LDYN5
S40000 M3
M119 ; Spindel EIN -> Spindelluft EIN
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D nach 4 min nachgemessen, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

G04 240
M5
M118 ; Spindel AUS -> Spindelluft AUS
G04 3
V.G.WZ_AKT.P[0] = 0
T4089 M6
LDYN5
S40000 M3
M119 ; Spindel EIN -> Spindelluft EIN
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D nach 8 min nachgemessen, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

; ----------------------------------------------------------
; 3) T4126 MKD, 6000 (Friktion), zweimal 4 min - wie im Job
;    direkt nach T4089 (Spindel kuehlt von 40000 auf 6000 ab)
; ----------------------------------------------------------
M5
M118 ; Spindel AUS -> Spindelluft AUS
T4126 M6
LDYN17
S6000 M3
M119 ; Spindel EIN -> Spindelluft EIN
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D geholt, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

G04 240
M5
M118 ; Spindel AUS -> Spindelluft AUS
G04 3
V.G.WZ_AKT.P[0] = 0
T4126 M6
LDYN17
S6000 M3
M119 ; Spindel EIN -> Spindelluft EIN
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D nach 4 min nachgemessen, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

G04 240
M5
M118 ; Spindel AUS -> Spindelluft AUS
G04 3
V.G.WZ_AKT.P[0] = 0
T4126 M6
LDYN17
#FLUSH WAIT
#MSG SAVE EXCLUSIVE ["%S --- WARMTEST T%D nach 8 min nachgemessen, Laenge aktiv %Fmm", V.G.TIME_STAMP_FILE_NAME, V.G.T_AKT, V.G.WZ_AKT.L]

; ----------------------------------------------------------
; Ende
; ----------------------------------------------------------
M5
M118 ; Spindel AUS -> Spindelluft AUS
G53
LSAFEPOS

M30
