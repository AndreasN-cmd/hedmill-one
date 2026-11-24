# DIAGNOSE_EIN - schaltet das Diagnose-Log des HEDS-Plugins ein und prueft, ob ein Neustart der Bedienoberflaeche jetzt passt.
# Am Steuerungs-PC in PowerShell ausfuehren (im Ordner D:\CNC\Bibliothek: .\DIAGNOSE_EIN.ps1).
# Aendert nur eines: legt die leere Schalterdatei C:\TEMP\hedmill_debug.on an. Sonst wird nur gelesen.
# Wirksam erst nach dem Neustart der Bedienoberflaeche (HMI). Ausschalten: DIAGNOSE_AUS.ps1.
# Anlass 24.11.2026: Autostart geht nach jedem Job aus (hedmill-one docs/11-stoerungen-historie.md, docs/13-offene-fragen.md).

Write-Host ""
Write-Host "1. Bedienoberflaeche (Programme unter C:\HMI) laeuft seit:"
try {
    $p = Get-CimInstance Win32_Process -ErrorAction Stop | Where-Object { $_.ExecutablePath -like 'C:\HMI\*' }
    if ($p) {
        foreach ($x in $p) { Write-Host ("   {0}  seit {1:dd.MM.yyyy HH:mm}   {2}" -f $x.Name, $x.CreationDate, $x.ExecutablePath) }
    } else { Write-Host "   keines gefunden" }
} catch { Write-Host "   nicht lesbar: $($_.Exception.Message)" }

Write-Host ""
Write-Host "2. Startordner C:\CNC\wp (HEDS loescht beim Start der Bedienoberflaeche alle Dateien darin):"
$nc = Get-ChildItem 'C:\CNC\wp' -File -ErrorAction SilentlyContinue
if ($nc) {
    foreach ($f in $nc) { Write-Host ("   {0}   {1:dd.MM. HH:mm}" -f $f.Name, $f.LastWriteTime) }
    Write-Host "   ACHTUNG: Diese Dateien loescht HEDS beim Neustart. Ein Job, der noch nicht gelaufen ist,"
    Write-Host "   ist danach weg und muss neu aus hyperDENT geschickt werden."
    Write-Host "   Neustart erst, wenn hier kein laufender oder ungelaufener Job mehr liegt."
} else { Write-Host "   leer - passt" }

Write-Host ""
Write-Host "3. Diagnose-Log einschalten:"
New-Item -ItemType Directory -Force -Path 'C:\TEMP' | Out-Null
New-Item -ItemType File -Force -Path 'C:\TEMP\hedmill_debug.on' | Out-Null
if (Test-Path 'C:\TEMP\hedmill_debug.on') { Write-Host "   OK: C:\TEMP\hedmill_debug.on angelegt" }
else { Write-Host "   FEHLER: Datei konnte nicht angelegt werden" }

Write-Host ""
Write-Host "Naechste Schritte:"
Write-Host " - Maschine steht, kein Job aktiv, Startordner leer: in der CNC-Ansicht Reset druecken"
Write-Host " - Bedienoberflaeche ganz schliessen und neu starten (oder Steuerungs-PC neu starten)"
Write-Host " - Die HEDS-Seite muss beim ersten Mal aufgehen. Wenn nicht: Reset, dann Bedienoberflaeche"
Write-Host "   nochmals GANZ neu starten (nicht nur die Seite erneut oeffnen)"
Write-Host " - Erst nach dem Reset den Autostart einschalten (Reset schaltet ihn aus), dann Start"
Write-Host ""
Read-Host "Enter druecken zum Schliessen"
