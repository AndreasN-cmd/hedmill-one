#VAR
   V.L.RPM = 30000
   V.L.FEED = 1500
	V.L.DistanceX = 70
	V.L.DistanceY = 3
	V.L.DistanceZ = 1	
#ENDVAR



;M6 T5000 ; 5mm Einzahn ca. 25mm lang
;M0

;Startwert am Powerclampzylinder
;---------------------------------
;X=-25
;Y=-200
;Z=30

V.E.ToolInSpindle.Exist=1

SV.L.RPM M3

G91
[START] 
G01 XV.L.DistanceX  FV.L.FEED
G01 YV.L.DistanceY

G01 X-V.L.DistanceX  
G01 YV.L.DistanceY

G01 XV.L.DistanceX  
G01 YV.L.DistanceY

G01 X-V.L.DistanceX  
G01 Y-V.L.DistanceY*3

G01 Z-V.L.DistanceZ
M0
$GOTO [START]

M30
