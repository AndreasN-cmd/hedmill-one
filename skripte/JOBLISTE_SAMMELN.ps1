# JOBLISTE_SAMMELN - nur lesend, dauert wenige Sekunden, darf auch waehrend des Fraesens laufen.
# Am Steuerungs-PC in PowerShell ausfuehren (Rechtsklick > "Mit PowerShell ausfuehren").
# Anlass 24.11.2026: Autostart geht nach dem Jobende aus. Sammelt, was die HEDS-Jobliste steuert:
#   PFADE.txt          Job-Ordner aus C:\HMI\config\paths.xml (jobPath, workingPath, donePath ...) und deren Inhalt mit Uhrzeit
#   TEMP.txt           Inhalt von C:\TEMP (HEDS-Diagnoseschalter hedmill_debug.on, Log hedmill_ui_debug.log)
#   PROZESSE.txt       Programme unter C:\HMI mit Startzeit (seit wann laeuft die Bedienoberflaeche)
#   dateien\...        paths.xml, machPara.xml, GeneralSettings.xml, Blanks.xml, HEDS-Diagnoselog, HMI Program.log
# Ergebnis: Ordner HEDmill-Jobliste-<Datum-Uhrzeit> auf dem Desktop.

$stamp = Get-Date -Format 'yyyy-MM-dd_HHmm'
$ziel = Join-Path ([Environment]::GetFolderPath('Desktop')) "HEDmill-Jobliste-$stamp"
$zd = Join-Path $ziel 'dateien'
New-Item -ItemType Directory -Path $zd -Force | Out-Null
$ue = Join-Path $ziel 'UEBERSICHT.txt'
"HEDmill One - Jobliste gesammelt am $(Get-Date)" | Out-File $ue -Encoding utf8

function Kopiere($pfad) {
    if (-not (Test-Path $pfad)) { "FEHLT   $pfad" | Out-File $ue -Append -Encoding utf8; return }
    try {
        $rel = $pfad.Substring(3) -replace '[\\/:]', '_'
        Copy-Item $pfad -Destination (Join-Path $zd $rel) -Force -ErrorAction Stop
        "OK      $pfad" | Out-File $ue -Append -Encoding utf8
    } catch {
        "FEHLER  $pfad : $($_.Exception.Message)" | Out-File $ue -Append -Encoding utf8
    }
}

function Liste($ordner, $datei) {
    "=== $ordner" | Out-File $datei -Append -Encoding utf8
    if (Test-Path $ordner) {
        Get-ChildItem $ordner -Force -ErrorAction SilentlyContinue | Sort-Object LastWriteTime |
            ForEach-Object { '{0}  {1,12}  {2}' -f $_.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'), $(if ($_.PSIsContainer) { '<Ordner>' } else { $_.Length }), $_.Name } |
            Out-File $datei -Append -Encoding utf8
    } else { "(Ordner fehlt)" | Out-File $datei -Append -Encoding utf8 }
}

# 1. Einstellungsdateien und Logs
foreach ($f in @('C:\HMI\config\paths.xml', 'C:\HMI\config\machPara.xml', 'C:\HMI\System\GeneralSettings.xml',
                 'C:\HMI\config\blanks\Blanks.xml', 'C:\TEMP\hedmill_ui_debug.log', 'C:\HMI\Log\Program.log')) { Kopiere $f }

# 2. Job-Ordner laut paths.xml und ihr Inhalt
$pf = Join-Path $ziel 'PFADE.txt'
"Job-Ordner laut C:\HMI\config\paths.xml am $(Get-Date):" | Out-File $pf -Encoding utf8
try {
    [xml]$x = Get-Content 'C:\HMI\config\paths.xml' -ErrorAction Stop
    foreach ($n in @('jobPath', 'workingPath', 'donePath', 'helpPath', 'masterBlankPath', 'masterToolPath', 'LibPath')) {
        $knoten = $x.SelectSingleNode("//$n")
        $wert = if ($knoten) { $knoten.InnerText } else { '(nicht gefunden)' }
        "$n = $wert" | Out-File $pf -Append -Encoding utf8
    }
    "" | Out-File $pf -Append -Encoding utf8
    foreach ($n in @('jobPath', 'workingPath', 'donePath')) {
        $knoten = $x.SelectSingleNode("//$n")
        if ($knoten -and $knoten.InnerText) { Liste $knoten.InnerText $pf }
    }
} catch {
    "FEHLER beim Lesen von paths.xml: $($_.Exception.Message)" | Out-File $pf -Append -Encoding utf8
}
Liste 'C:\CNC\wp' $pf

# 3. C:\TEMP
$tp = Join-Path $ziel 'TEMP.txt'
"Inhalt C:\TEMP am $(Get-Date):" | Out-File $tp -Encoding utf8
Liste 'C:\TEMP' $tp

# 4. Bedienoberflaeche: welche Programme unter C:\HMI laufen seit wann (Neustart erkennen)
$pp = Join-Path $ziel 'PROZESSE.txt'
"Programme unter C:\HMI am $(Get-Date):" | Out-File $pp -Encoding utf8
try {
    Get-CimInstance Win32_Process -ErrorAction Stop | Where-Object { $_.ExecutablePath -like 'C:\HMI\*' } |
        ForEach-Object { '{0:yyyy-MM-dd HH:mm:ss}  {1}  {2}' -f $_.CreationDate, $_.Name, $_.CommandLine } |
        Out-File $pp -Append -Encoding utf8
} catch { "nicht lesbar: $($_.Exception.Message)" | Out-File $pp -Append -Encoding utf8 }

"" | Out-File $ue -Append -Encoding utf8
"=== FERTIG === Ordner: $ziel" | Out-File $ue -Append -Encoding utf8
Write-Host "Fertig. Ordner: $ziel"
Write-Host "Diesen Ordner auf den USB-Stick kopieren und am Mac nach ~/Downloads legen."
Start-Sleep -Seconds 5
