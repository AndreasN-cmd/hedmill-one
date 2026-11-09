# HEDmill One – Wissensdatenbank

Alles, was bisher über die HEDmill One (Erhardt NextGen Dental) herausgefunden wurde – exportiert aus dem claude.ai-Projekt „Hedmill Maschine“ am 09.11.2026. Für Claude Code gilt `CLAUDE.md`.

## Ordner
- `docs/` – das Wissen, nach Themen (Start: `00-stand-und-ueberblick.md`)
- `maschine/` – Kopien von Dateien des Steuerungs-PCs (Unterprogramme, Log, Parameterdateien, TwinCAT-Sicherungen) – **noch zu befüllen, siehe unten**
- `eigene-programme/` – selbst geschriebene NC-Programme und Werkzeuge – **noch zu befüllen**
- `skripte/` – PowerShell-Skripte für den Steuerungs-PC

## Noch zu tun: Dateien von der Maschine ins Repo kopieren
Die Hersteller-Unterprogramme sind absichtlich NICHT abgetippt, sondern werden 1:1 kopiert – nur so bleiben Kodierung (UTF-8 / Windows-1252) und Zeilenenden (CRLF) exakt erhalten.

1. Am Steuerungs-PC (Maschine darf dabei nicht fräsen): Inhalt von `C:\HMI\NCProg\sub\` (inkl. Unterordner `old` und `old20261030`) auf einen USB-Stick kopieren.
2. Am Mac: Inhalt in `maschine/sub/` dieses Repos legen.
3. Weitere Dateien siehe die `README.md` im jeweiligen Unterordner.
4. Danach in Claude Code sagen: „Prüf die Dateien in maschine/ gegen die Wissensdatenbank“ – Claude gleicht ab (z. B. ob `setVPVars` den Wert −26.2 enthält).

`.gitattributes` sorgt dafür, dass Git die Maschinendateien nicht verändert (keine Zeilenend-Umwandlung).
