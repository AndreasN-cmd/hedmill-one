# AUTOSTART_SUCHEN - nur lesend. Am Steuerungs-PC in PowerShell ausfuehren (Rechtsklick > "Mit PowerShell ausfuehren").
# Anlass 24.11.2026: Seit 22.11. schaltet die Jobliste nach jedem Job den Autostart aus, ohne Eintrag in
# LoggedEvents.db oder C:\HMI\log\message*.txt. Gesucht: wo das HMI den Autostart fuehrt und ob es dazu ein
# eigenes Log oder eine Einstellung schreibt.
# Veraendert nichts an der Maschine, liest nur. Durchsucht die Festplatte 1-3 Minuten: am besten starten, wenn die
# Maschine steht (zwischen zwei Jobs oder Autostart aus). Waehrend des Fraesens nur ausserhalb von Friktion/MKD.
#
# Inhalt des Ordners HEDmill-Autostart-<Datum-Uhrzeit> unter D:\CNC\Bibliothek\Logs:
#   JOBABLAGE_WP.txt   was in C:\CNC\wp (Jobablage, aus der die Jobs starten) gerade liegt, mit Datum
#   DATEILISTE.txt     alle Dateien in C:\HMI ausser NCProg, die in den letzten 4 Tagen geaendert wurden
#   TREFFER.txt        Textstellen mit "autostart", "auto start", "automatik", "autorun", "joblist", "jobliste"
#                      in Einstellungs- und Logdateien unter C:\HMI, C:\HM1 und C:\CNC (mit Datei und Zeile)
#   dateien\...        Kopien der Dateien mit Treffern (nur bis 5 MB), aller Logdateien (*.log) der letzten 4 Tage
#                      und der HEDS-Plugins aus C:\HMI\Plugins (Heds*.dll, nur um am Mac die Texte zu lesen)
#   UEBERSICHT.txt     was kopiert wurde

$stamp = Get-Date -Format 'yyyy-MM-dd_HHmm'
# Ablage (Andreas 25.11.2026): D:\CNC\Bibliothek\Logs statt Desktop. Gibt es den Ordner nicht, wird er angelegt;
# ist D: nicht erreichbar, ersatzweise der Desktop.
$basis = 'D:\CNC\Bibliothek\Logs'
try { New-Item -ItemType Directory -Path $basis -Force -ErrorAction Stop | Out-Null } catch { $basis = [Environment]::GetFolderPath('Desktop') }
$ziel = Join-Path $basis "HEDmill-Autostart-$stamp"
$zd = Join-Path $ziel 'dateien'
New-Item -ItemType Directory -Path $zd -Force | Out-Null
$ue = Join-Path $ziel 'UEBERSICHT.txt'
"HEDmill One - Autostart-Suche am $(Get-Date)" | Out-File $ue -Encoding utf8

function Kopiere($pfad) {
    try {
        $rel = $pfad.Substring(3) -replace '[\\/:]', '_'
        Copy-Item $pfad -Destination (Join-Path $zd $rel) -Force -ErrorAction Stop
        "OK      $pfad" | Out-File $ue -Append -Encoding utf8
    } catch {
        "FEHLER  $pfad : $($_.Exception.Message)" | Out-File $ue -Append -Encoding utf8
    }
}

$seit = (Get-Date).AddDays(-4)
$wurzeln = @('C:\HMI', 'C:\HM1', 'C:\CNC') | Where-Object { Test-Path $_ }

# 0. Jobablage C:\CNC\wp: welche Jobs liegen bereit (Datum, Groesse, Name; NC-Programme werden nicht kopiert)
$wpl = Join-Path $ziel 'JOBABLAGE_WP.txt'
"Inhalt C:\CNC\wp am $(Get-Date):" | Out-File $wpl -Encoding utf8
if (Test-Path 'C:\CNC\wp') {
    Get-ChildItem 'C:\CNC\wp' -Recurse -Force -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime |
        ForEach-Object { '{0}  {1,12}  {2}' -f $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'), $(if ($_.PSIsContainer) { '<Ordner>' } else { $_.Length }), $_.FullName } |
        Out-File $wpl -Append -Encoding utf8
}

# 0b. Programmteil des HMI von HEDS (Jobliste/Autostart vermutlich dort): Plugin-Dateien kopieren, nur zum Lesen der Texte am Mac
foreach ($p in @('C:\HMI\Plugins')) {
    if (Test-Path $p) {
        Get-ChildItem $p -Recurse -File -Include 'Heds*.dll', '*.config', '*.xml', '*.json' -ErrorAction SilentlyContinue |
            Where-Object { $_.Length -lt 20MB } | ForEach-Object { Kopiere $_.FullName }
    }
}

# 1. Dateiliste: was hat sich in C:\HMI in den letzten 4 Tagen geaendert (ohne NC-Programme)
$liste = Join-Path $ziel 'DATEILISTE.txt'
"Geaendert seit $seit (ohne C:\HMI\NCProg):" | Out-File $liste -Encoding utf8
if (Test-Path 'C:\HMI') {
    Get-ChildItem 'C:\HMI' -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notlike 'C:\HMI\NCProg\*' -and $_.LastWriteTime -ge $seit } |
        Sort-Object LastWriteTime -Descending |
        ForEach-Object { '{0}  {1,12}  {2}' -f $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'), $_.Length, $_.FullName } |
        Out-File $liste -Append -Encoding utf8
}

# 2. Logdateien des HMI selbst (nicht message*.txt, die kommen mit LOGS_SAMMELN)
foreach ($w in $wurzeln) {
    Get-ChildItem $w -Recurse -File -Include '*.log', '*.log.*', '*.trace' -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -ge $seit -and $_.Length -lt 20MB } |
        ForEach-Object { Kopiere $_.FullName }
}

# 3. Textsuche in Einstellungen, Logs und SPS-Quellen
$muster = 'autostart|auto start|auto-start|automatik|autorun|auto_run|joblist|jobliste|bAuto'
$endungen = @('*.xml', '*.ini', '*.json', '*.config', '*.cfg', '*.txt', '*.log', '*.csv', '*.TcPOU', '*.TcGVL', '*.TcDUT', '*.settings')
$treffer = Join-Path $ziel 'TREFFER.txt'
"Suchmuster: $muster" | Out-File $treffer -Encoding utf8
$gefunden = @{}
foreach ($w in $wurzeln) {
    Get-ChildItem $w -Recurse -File -Include $endungen -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notlike 'C:\HMI\NCProg\*' -and $_.FullName -notlike 'C:\HMI\log\message*' -and $_.FullName -notlike 'C:\CNC\wp\*' -and $_.Length -lt 50MB } |
        ForEach-Object {
            $f = $_
            $hits = Select-String -Path $f.FullName -Pattern $muster -ErrorAction SilentlyContinue | Select-Object -First 40
            foreach ($h in $hits) {
                $zeile = $h.Line.Trim()
                if ($zeile.Length -gt 300) { $zeile = $zeile.Substring(0, 300) }
                '{0}:{1}: {2}' -f $f.FullName, $h.LineNumber, $zeile | Out-File $treffer -Append -Encoding utf8
                $gefunden[$f.FullName] = $f.Length
            }
        }
}
foreach ($p in $gefunden.Keys) { if ($gefunden[$p] -lt 5MB) { Kopiere $p } }

"" | Out-File $ue -Append -Encoding utf8
"=== FERTIG === Ordner: $ziel" | Out-File $ue -Append -Encoding utf8
Write-Host "Fertig. Ordner: $ziel"
Write-Host "Diesen Ordner zusammen mit LOGS_SAMMELN auf den USB-Stick kopieren und am Mac nach ~/Downloads legen."
Start-Sleep -Seconds 5
