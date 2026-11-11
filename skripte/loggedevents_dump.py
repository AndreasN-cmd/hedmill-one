#!/usr/bin/env python3
"""LoggedEvents.db (TwinCAT-Ereignisprotokoll, SQLite) auswerten - nur lesend.
Aufruf am Mac:  python3 -I skripte/loggedevents_dump.py <Pfad zu LoggedEvents.db> [Suchbegriff, Standard 5012]
Listet Tabellen und Spalten, dann alle Zeilen, in denen der Suchbegriff vorkommt (z. B. 5012 = Meldungen 50120/50121),
Zeiten (Windows-FILETIME, UTC) werden in Ortszeit umgerechnet.
"""
import sys, sqlite3, datetime, shutil, tempfile, os, re

src = sys.argv[1]
such = sys.argv[2] if len(sys.argv) > 2 else "5012"

# Kopie lesen, damit die Originaldatei unangetastet bleibt
tmp = tempfile.mkdtemp()
dbp = os.path.join(tmp, "LoggedEvents.db")
shutil.copy(src, dbp)
for ext in ("-wal", "-shm"):
    if os.path.exists(src + ext):
        shutil.copy(src + ext, dbp + ext)
con = sqlite3.connect(f"file:{dbp}?mode=ro", uri=True)
con.text_factory = lambda b: b.decode("utf-8", "replace")
cur = con.cursor()

def filetime(v):
    try:
        v = int(v)
        if v > 10**17:
            dt = datetime.datetime(1601, 1, 1, tzinfo=datetime.timezone.utc) + datetime.timedelta(microseconds=v / 10)
            return dt.astimezone().strftime("%Y-%m-%d %H:%M:%S")
    except Exception:
        pass
    return None

tables = [r[0] for r in cur.execute("SELECT name FROM sqlite_master WHERE type='table'")]
print("Tabellen:", ", ".join(tables))
for t in tables:
    cols = [c[1] for c in cur.execute(f"PRAGMA table_info('{t}')")]
    n = cur.execute(f"SELECT COUNT(*) FROM '{t}'").fetchone()[0]
    print(f"\n== {t} ({n} Zeilen) ==\n   Spalten: {', '.join(cols)}")
    rows = cur.execute(f"SELECT rowid, * FROM '{t}'").fetchall()
    hits = 0
    for r in rows:
        txt = " | ".join("" if v is None else str(v) for v in r)
        if such in txt:
            hits += 1
            if hits <= 400:
                parts = []
                for c, v in zip(["rowid"] + cols, r):
                    ft = filetime(v)
                    s = f"{v} ({ft})" if ft else str(v)
                    if isinstance(v, bytes):
                        s = f"<{len(v)} Bytes>"
                    parts.append(f"{c}={s}")
                print("   " + " | ".join(parts))
    print(f"   Treffer '{such}': {hits}")
