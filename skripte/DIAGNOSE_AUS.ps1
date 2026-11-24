# DIAGNOSE_AUS - schaltet das Diagnose-Log des HEDS-Plugins wieder aus.
# Am Steuerungs-PC in PowerShell ausfuehren (im Ordner D:\CNC\Bibliothek: .\DIAGNOSE_AUS.ps1).
# Loescht nur die Schalterdatei C:\TEMP\hedmill_debug.on. Das Log C:\TEMP\hedmill_ui_debug.log bleibt liegen
# (vorher mit JOBLISTE_SAMMELN.ps1 holen). Wirksam nach dem naechsten Neustart der Bedienoberflaeche.

if (Test-Path 'C:\TEMP\hedmill_debug.on') {
    Remove-Item 'C:\TEMP\hedmill_debug.on' -ErrorAction SilentlyContinue
    if (Test-Path 'C:\TEMP\hedmill_debug.on') { Write-Host "FEHLER: Schalterdatei konnte nicht geloescht werden" }
    else { Write-Host "OK: Schalterdatei geloescht. Das Log endet nach dem naechsten Neustart der Bedienoberflaeche." }
} else {
    Write-Host "Schalterdatei war nicht da, Diagnose-Log ist schon aus (nach dem naechsten Neustart)."
}
$log = Get-Item 'C:\TEMP\hedmill_ui_debug.log' -ErrorAction SilentlyContinue
if ($log) { Write-Host ("Log: {0}  {1:N0} Byte, zuletzt {2:dd.MM. HH:mm}" -f $log.FullName, $log.Length, $log.LastWriteTime) }
Write-Host ""
Read-Host "Enter druecken zum Schliessen"
