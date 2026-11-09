# DYNSUCHE – nur lesend. Am Steuerungs-PC in PowerShell ausfuehren.
# Schreibt nur DYNSUCHE.txt auf den Desktop (UTF-8). Nur laufen lassen, wenn die Maschine NICHT fraest.
# Sucht nicht in gepackten Archiven (.tnzip / .tszip).
# Hinweis: Der Boot-Pfad 'C:\TwinCAT\3.1\Boot' ist fuer diese Maschine falsch,
# richtig ist 'C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot' (unten bereits korrigiert).
# Erfolgreich gelaufen am 01.11.2026.

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$ziel = "$env:USERPROFILE\Desktop\DYNSUCHE.txt"
$boot = 'C:\ProgramData\Beckhoff\TwinCAT\3.1\Boot'
$muster = 'a_trans_weight|r_trans_weight|trans_limit_with_curvature|opt_contour_mode|auto_contour_mode|LOOK_AHEAD|FCT_SURFACE|dev_surface_5ax|slope\.profile|filter\[0\]\.order|filter\[0\]\.prototype|error_filter|dyn_monitoring|corr_v_trans_jerk|mode_trans_jerk'
$proj = @('C:\','D:\') | Where-Object { Test-Path $_ } | ForEach-Object { Get-ChildItem $_ -Recurse -File -Include *.tsproj,*.tszip,*.tnzip -ErrorAction SilentlyContinue }
$ordner = (@('C:\TwinCAT','C:\HMI','C:\CNC') + @($proj | Where-Object { $_.Extension -eq '.tsproj' } | ForEach-Object { $_.DirectoryName })) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique
"=== TwinCAT-Projekte ===" | Out-File $ziel
$proj | Sort-Object LastWriteTime | Format-Table LastWriteTime, Length, FullName -AutoSize | Out-String -Width 400 | Out-File $ziel -Append
"=== Boot-Ordner, neueste zuerst ===" | Out-File $ziel -Append
Get-ChildItem $boot -Recurse -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Format-Table LastWriteTime, Length, FullName -AutoSize | Out-String -Width 400 | Out-File $ziel -Append
"=== Treffer ===" | Out-File $ziel -Append
Get-ChildItem $ordner -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -lt 30MB -and $_.Extension -notin '.dll','.exe','.sys','.pdb','.zip','.tmc','.lib','.compiled-library' } | Select-String -Pattern $muster -AllMatches -ErrorAction SilentlyContinue | ForEach-Object { $z = $_; foreach ($m in $z.Matches) { $s = [Math]::Max(0, $m.Index - 40); $n = [Math]::Min(160, $z.Line.Length - $s); '{0} | Z.{1} | {2}' -f $z.Path, $z.LineNumber, $z.Line.Substring($s, $n).Trim() } } | Out-File $ziel -Append
"=== FERTIG ===" | Out-File $ziel -Append
