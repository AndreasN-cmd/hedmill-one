# LOGS_SAMMELN - nur lesend. Am Steuerungs-PC in PowerShell ausfuehren (Rechtsklick > "Mit PowerShell ausfuehren").
# Kopiert alles, was fuer die Analyse der Stoerung 50120 / 50121 (Beschleunigung Achse B) gebraucht wird,
# in einen neuen Ordner unter D:\CNC\Bibliothek\Logs: HEDmill-Logs-<Datum-Uhrzeit>. Diesen Ordner auf den USB-Stick ziehen.
# Veraendert nichts an der Maschine. Kann auch laufen, waehrend die Maschine fraest.
#
# Inhalt des Ordners:
#   LoggedEvents.db            TwinCAT-Ereignisprotokoll (CNC-Meldungen 50120/50121 mit Programm und Satznummer)
#   message<Datum>.txt         HMI-Log der letzten 3 Tage (Blankwechsel, Werkzeuge, Programme)
#   wp\*.nc                    die 12 zuletzt geaenderten NC-Programme aus C:\CNC\wp (dort liegt nur der laufende Job)
#   done\*.nc                  die 8 zuletzt fertig gewordenen NC-Programme aus dem Fertig-Ordner der Jobliste
#                              (donePath in C:\HMI\config\paths.xml, sonst D:\CNC\done): die Teleskope der Nacht
#   diag\*                     Diagnosedateien der Steuerung, falls vorhanden (diag_data*.txt)
#   sub\DYN*                   alle Dynamiksaetze, wie sie gerade auf der Maschine liegen (Kontrolle DYN17 / DYN18)
#   UEBERSICHT.txt             Liste aller kopierten Dateien mit Datum und Groesse

$stamp = Get-Date -Format 'yyyy-MM-dd_HHmm'
# Ablage (Andreas 25.11.2026): D:\CNC\Bibliothek\Logs statt Desktop. Gibt es den Ordner nicht, wird er angelegt;
# ist D: nicht erreichbar, ersatzweise der Desktop.
$basis = 'D:\CNC\Bibliothek\Logs'
try { New-Item -ItemType Directory -Path $basis -Force -ErrorAction Stop | Out-Null } catch { $basis = [Environment]::GetFolderPath('Desktop') }
$ziel = Join-Path $basis "HEDmill-Logs-$stamp"
New-Item -ItemType Directory -Path $ziel -Force | Out-Null
$ue = Join-Path $ziel 'UEBERSICHT.txt'
"HEDmill One - Logs gesammelt am $(Get-Date)" | Out-File $ue -Encoding utf8

function Kopiere($quelle, $unterordner) {
    if (Test-Path $quelle) {
        $z = if ($unterordner) { Join-Path $ziel $unterordner } else { $ziel }
        if (-not (Test-Path $z)) { New-Item -ItemType Directory -Path $z -Force | Out-Null }
        try {
            Copy-Item $quelle -Destination $z -Force -ErrorAction Stop
            "OK      $quelle" | Out-File $ue -Append -Encoding utf8
        } catch {
            "FEHLER  $quelle : $($_.Exception.Message)" | Out-File $ue -Append -Encoding utf8
        }
    } else {
        "FEHLT   $quelle" | Out-File $ue -Append -Encoding utf8
    }
}

# 1. TwinCAT-Ereignisprotokoll (SQLite). Falls gesperrt: zweiter Versuch ueber eine Schattenkopie mit robocopy /B
$db = 'C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot\LoggedEvents.db'
Kopiere $db ''
if (-not (Test-Path (Join-Path $ziel 'LoggedEvents.db'))) {
    robocopy 'C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot' $ziel 'LoggedEvents.db' /B /R:1 /W:1 | Out-Null
    if (Test-Path (Join-Path $ziel 'LoggedEvents.db')) { "OK      $db (robocopy /B)" | Out-File $ue -Append -Encoding utf8 }
}
# dazugehoerige Journal-Dateien, falls vorhanden
foreach ($ext in @('-wal','-shm','-journal')) { if (Test-Path "$db$ext") { Kopiere "$db$ext" '' } }

# 2. HMI-Logs der letzten 3 Tage
for ($i = 0; $i -lt 3; $i++) {
    $d = (Get-Date).AddDays(-$i).ToString('yyyyMMdd')
    Kopiere "C:\HMI\log\message$d.txt" ''
}

# 3. Die 12 zuletzt geaenderten NC-Programme
if (Test-Path 'C:\CNC\wp') {
    Get-ChildItem 'C:\CNC\wp' -File -Filter *.nc | Sort-Object LastWriteTime -Descending | Select-Object -First 12 | ForEach-Object { Kopiere $_.FullName 'wp' }
    "" | Out-File $ue -Append -Encoding utf8
    "Alle NC-Programme in C:\CNC\wp (Datum, Groesse, Name):" | Out-File $ue -Append -Encoding utf8
    Get-ChildItem 'C:\CNC\wp' -File | Sort-Object LastWriteTime -Descending | Select-Object -First 40 | ForEach-Object { '{0}  {1,12}  {2}' -f $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm'), $_.Length, $_.Name } | Out-File $ue -Append -Encoding utf8
} else { "FEHLT   C:\CNC\wp" | Out-File $ue -Append -Encoding utf8 }

# 3b. Fertige Jobs (seit 25.11.2026): die Jobliste verschiebt jedes NC am Jobende von C:\CNC\wp in den Fertig-Ordner.
#     Reihenfolge nach dem Zeitpunkt, an dem die Datei dort ankam (Erstelldatum im Fertig-Ordner), sonst Aenderungsdatum.
$done = 'D:\CNC\done'
try {
    [xml]$px = Get-Content 'C:\HMI\config\paths.xml' -ErrorAction Stop
    $kn = $px.SelectSingleNode('//donePath')
    if ($kn -and $kn.InnerText) { $done = $kn.InnerText }
} catch { }
if (Test-Path $done) {
    $fertig = @(Get-ChildItem $done -File -Filter *.nc | Sort-Object { if ($_.CreationTime -gt $_.LastWriteTime) { $_.CreationTime } else { $_.LastWriteTime } } -Descending)
    $fertig | Select-Object -First 8 | ForEach-Object { Kopiere $_.FullName 'done' }
    "" | Out-File $ue -Append -Encoding utf8
    "Fertige NC-Programme in $done (fertig am, berechnet am, Groesse, Name):" | Out-File $ue -Append -Encoding utf8
    $fertig | Select-Object -First 40 | ForEach-Object { '{0}  {1}  {2,12}  {3}' -f $_.CreationTime.ToString('yyyy-MM-dd HH:mm'), $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm'), $_.Length, $_.Name } | Out-File $ue -Append -Encoding utf8
    "" | Out-File $ue -Append -Encoding utf8
} else { "FEHLT   $done" | Out-File $ue -Append -Encoding utf8 }

# 4. Diagnosedateien der Steuerung (diag_data), wo immer sie liegen
foreach ($root in @('C:\HMI','C:\CNC','C:\TwinCAT','C:\ProgramData\Beckhoff','C:\HM1')) {
    if (Test-Path $root) {
        Get-ChildItem $root -Recurse -File -Include 'diag_data*','*.diag' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10 | ForEach-Object { Kopiere $_.FullName 'diag' }
    }
}

# 5. Dynamiksaetze, wie sie auf der Maschine liegen
if (Test-Path 'C:\HMI\NCProg\sub') {
    Get-ChildItem 'C:\HMI\NCProg\sub' -File -Filter 'DYN*' | ForEach-Object { Kopiere $_.FullName 'sub' }
}

"" | Out-File $ue -Append -Encoding utf8
"=== FERTIG === Ordner: $ziel" | Out-File $ue -Append -Encoding utf8
Write-Host "Fertig. Ordner: $ziel"
Write-Host "Diesen Ordner auf den USB-Stick kopieren und am Mac nach ~/Downloads legen."
Start-Sleep -Seconds 5
