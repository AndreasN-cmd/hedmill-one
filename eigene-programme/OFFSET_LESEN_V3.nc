; ==========================================================
; OFFSET_LESEN_V3 - liest den Werkzeug-Laengenoffset der Maschine
; NUR LESEN: keine Achsbewegung, kein Werkzeugwechsel, aendert nichts.
; Zeigt V.E.ToolLengthOffset (SPS: machinePara.stToolChange.fToolLengthOffset,
; HMI Maschinenparameter) in EINER HMI-Meldung und schreibt ihn ins Log
; (Suchwort OFFSET_LESEN, Datei C:\HMI\log\).
; Herkunft: aktives Unterprogramm measureTool (13.07.2026):
;   V.G.WZ_AKT.P[2] = V.A.MESS.Z - V.E.ToolLengthOffset
; V3: nur noch eine HMI-Meldung (V2: zweite Meldung ueberschrieb die erste,
;     Werkzeuglaenge ohne D-Aufruf immer 0 - weggelassen).
; Erwartung 11.11.2026: 49.828 (Anzeige HMI).
; ==========================================================
#MSG SAVE EXCLUSIVE ["OFFSET_LESEN: V.E.ToolLengthOffset = %F  (Werkzeug T%D)", V.E.ToolLengthOffset, V.G.T_AKT]
#MSG SYN HMI ["OFFSET_LESEN: ToolLengthOffset = %F  (Werkzeug T%D)", V.E.ToolLengthOffset, V.G.T_AKT]
M30
