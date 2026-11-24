#!/usr/bin/env python3
"""Haengende Werkzeug- und Blankwechsel im HMI-Log finden - nur lesend, am Mac.

Anlass: 13.11.2026 21:51 und 14.11.2026 00:43 blieb der Werkzeugwechsel ohne Meldung stehen
(docs/11-stoerungen-historie.md). Das Skript prueft jeden Wechsel Schritt fuer Schritt und zeigt bei einem
fehlenden oder verspaeteten Schritt die TwinCAT-Meldungen aus dieser Zeit.

Schritte im HMI-Log (Code maschine/sub/M6, toolBreakControl, checkToolAtPos, removeTool, getTool):
  "Tn Werkzeugdeltalaenge ..."               toolBreakControl misst das ABGEHENDE Werkzeug (traegt die neue Nummer)
  "Auf Position p ist kein Fraeser"          checkToolAtPos: Ablageplatz leer, danach M198 (wartet auf SPS)
  "T0 wurde erfolgreich ... abgelegt"        removeTool fertig (normal 10,1-10,6 s nach der Platzpruefung)
  "Auf Position p ist ein Fraeser"           checkToolAtPos: neues Werkzeug liegt da (0,7-1,2 s nach "abgelegt")
  "Tn Werkzeug(delta)laenge ..."             Messung des neuen Werkzeugs (13,9-16,3 s danach)
  "BlankChange wurde aufgerufen" ... "BlankChange wurde abgearbeitet"

Einstufung je Schritt:
  normal                 erwartete naechste Zeile innerhalb der Grenze
  anderer Ablauf         innerhalb der Grenze kommt eine andere Logzeile (z. B. "Werkzeug ungueltig")
  Abbruch                Job vor Ablauf der Grenze abgebrochen (Bediener)
  HAENGER mit Meldung    Grenze ueberschritten, in der Zeit gab es einen SPS-/CNC-Alarm (ausser Druckluft-Warnung)
  HAENGER OHNE MELDUNG   Grenze ueberschritten, kein Alarm -> NC wartet stumm (Fall 13./14.11.2026)

Uhren: Die TwinCAT-Zeit (LoggedEvents.db) laeuft der Windows-Uhr des HMI-Logs voraus und driftet
(12.11.2026 ~6 s, 13./14.11. ~14 s). Das Skript schaetzt den Versatz je Ereignis aus den Paaren
"BlankChange wurde aufgerufen" (HMI) / "Job ... gestartet" (TwinCAT) und gibt TwinCAT-Zeiten in HMI-Zeit aus.

Aufruf (Ordner von LOGS_SAMMELN):
  python3 -I skripte/wechsel_haenger.py ~/Downloads/HEDmill-Logs-2026-11-14_0224
"""
import sys, os, re, glob, sqlite3, shutil, tempfile, datetime, json, statistics

if len(sys.argv) < 2:
    sys.exit(__doc__)
ordner = sys.argv[1]
S = datetime.timedelta(seconds=1)

# ---------- HMI-Log ----------
RX = re.compile(r"^(\d{8}T\d{9}) --- (.*)$")
zeilen = []
for f in sorted(glob.glob(os.path.join(ordner, "message*.txt"))):
    for l in open(f, encoding="cp1252", errors="replace"):
        m = RX.match(l.strip())
        if m:
            zeilen.append((datetime.datetime.strptime(m.group(1), "%Y%m%dT%H%M%S%f"), m.group(2)))
zeilen.sort()
if not zeilen:
    sys.exit("Keine message*.txt im Ordner gefunden")

def art(s):
    if re.match(r"T\d+ Werkzeug(delta)?l.nge", s):
        return "messen"
    if re.match(r"Auf Position \d+ ist kein Fraeser", s):
        return "platz_leer"
    if "erfolgreich in den Werkzeugwechsler abgelegt" in s:
        return "abgelegt"
    if re.match(r"Auf Position \d+ ist ein Fraeser", s):
        return "platz_belegt"
    if "aus dem Werkzeugwechsler geholt" in s:
        return "geholt"
    if s.startswith("BlankChange wurde aufgerufen"):
        return "bc_start"
    if s.startswith("BlankChange wurde abgearbeitet"):
        return "bc_ende"
    return None

# Schritt: (erwartete naechste Zeile, Grenze in s, was dazwischen laeuft)
SCHRITT = {
    "platz_leer": ("abgelegt", 15, "M198 (SPS quittiert Platzpruefung), dann removeTool: M61 Klappe, Anfahrt, "
                   "G100-Einfahren mit Halter-Ueberwachung, M70 Konus auf, checkToolExist"),
    "abgelegt": ("platz_belegt", 5, "getTool: checkToolAtPos am neuen Platz"),
    "platz_belegt": ("messen", 25, "getTool: Werkzeug holen, Laenge pruefen"),
    "bc_start": ("bc_ende", 300, "blankChange"),   # ohne Tausch ~48 s, mit Tausch ~190 s
}

# ---------- LoggedEvents.db ----------
ereignisse = []
db = os.path.join(ordner, "LoggedEvents.db")
if os.path.exists(db):
    tmp = tempfile.mkdtemp()
    kopie = os.path.join(tmp, "le.db")
    shutil.copy(db, kopie)
    for ext in ("-wal", "-shm"):
        if os.path.exists(db + ext):
            shutil.copy(db + ext, kopie + ext)
    con = sqlite3.connect(f"file:{kopie}?mode=ro", uri=True)
    con.text_factory = lambda b: b.decode("utf-8", "replace")
    cat = dict(con.execute("select Id, Text from Category"))
    txt = {}
    for ec, eid, t, lc in con.execute(
            "select et.EventClass, et.EventId, tr.Text, tr.LcId from EventTexts et "
            "join StringLocalized_Translations st on st.StringLocalizedId = et.StringLocalizedId "
            "join Translations tr on tr.Id = st.TranslationId"):
        if (ec, eid) not in txt or lc == 1031:
            txt[(ec, eid)] = t
    arg = {}
    for eid, buf in con.execute("select EventId, DataBuffer from Arguments"):
        v = buf.decode("latin1", "replace").strip("\x00") if isinstance(buf, bytes) else str(buf)
        arg.setdefault(eid, []).append(v)
    js = dict(con.execute("select EventId, Json from JsonAttributes"))
    t0 = datetime.datetime(1601, 1, 1, tzinfo=datetime.timezone.utc)
    for eid, ft, ca, ec, evid, src in con.execute(
            "select e.Id, e.Time, e.CategoryId, en.EventClass, en.EventId, en.SourceInfo "
            "from Events e join Entities en on en.Id = e.EntityId order by e.Time"):
        if cat.get(ca) == "Alarm Cleared":
            continue
        zeit = (t0 + datetime.timedelta(microseconds=ft / 10)).astimezone().replace(tzinfo=None)
        try:
            quelle = json.loads(src).get("name", "").split(".")[-1]
        except Exception:
            quelle = str(src)
        prog = ""
        if eid in js:
            try:
                prog = json.loads(js[eid]).get("Prog", "")
            except Exception:
                pass
        ereignisse.append(dict(zeit=zeit, quelle=quelle, nr=evid, text=txt.get((ec, evid), ""),
                               arg="|".join(arg.get(eid, [])), prog=prog))

# Uhrversatz je Ereignis
starts = [e["zeit"] for e in ereignisse if "wurde gestartet" in e["text"] and "Home" not in e["arg"]]
paare = []
for t, s in zeilen:
    if art(s) == "bc_start":
        d = [(ts - t).total_seconds() for ts in starts if 0 <= (ts - t).total_seconds() <= 40]
        if d:
            paare.append((t, min(d)))

def versatz_bei(t):
    nah = [d for tp, d in paare if abs((tp - t).total_seconds()) <= 6 * 3600] or [d for _, d in paare]
    return statistics.median(nah) if nah else 0.0

RUHIG = ("Druckluft", "wurde gestartet", "wurde abgearbeitet", "wurde abgebrochen", "Drehzahl", "gestoppt")
# harmlos: 120206 Programmende bei Polynomueberschleifen, 20723 Formatwarnung #MSG (eigenes MESST, 14.11.2026)
RUHIG_NR = (120206, 20723)

def ev_hmi(von, bis, vs):
    return [(e["zeit"] - vs * S, e) for e in ereignisse if von <= e["zeit"] - vs * S <= bis]

# ---------- Schritte pruefen ----------
dauer, faelle = {}, []
for i, (t, s) in enumerate(zeilen):
    a = art(s)
    if a not in SCHRITT:
        continue
    soll, grenze, was = SCHRITT[a]
    rest = zeilen[i + 1:]
    if a == "bc_start":   # Zwischenzeilen gehoeren zum Blankwechsel
        nxt = next((r for r in rest if art(r[1]) in ("bc_ende", "bc_start")), None)
    else:
        nxt = rest[0] if rest else None
    if nxt is None:
        continue
    dt = (nxt[0] - t).total_seconds()
    if art(nxt[1]) == soll and dt <= grenze:
        dauer.setdefault(a, []).append(dt)
        continue
    vs = versatz_bei(t)
    ev = ev_hmi(t - 40 * S, nxt[0] + 10 * S, vs)
    abbruch = next((z for z, e in ev if "wurde abgebrochen" in e["text"] and t < z <= nxt[0]), None)
    stopp = abbruch or nxt[0]
    alarme = [(z, e) for z, e in ev if t - 30 * S <= z <= stopp
              and not any(r in e["text"] for r in RUHIG) and e["nr"] not in RUHIG_NR]
    if dt <= grenze and art(nxt[1]) is None:
        stufe = "anderer Ablauf"
    elif (stopp - t).total_seconds() <= grenze:
        stufe = "Abbruch"
    elif alarme:
        stufe = "HAENGER mit Meldung"
    else:
        stufe = "HAENGER OHNE MELDUNG"
    faelle.append(dict(t=t, s=s, nxt=nxt, dt=dt, was=was, grenze=grenze, stufe=stufe, vs=vs,
                       ev=[x for x in ev if x[0] <= stopp + 10 * S], abbruch=abbruch))

# ---------- Ausgabe ----------
print(f"HMI-Log {zeilen[0][0]:%d.%m. %H:%M} bis {zeilen[-1][0]:%d.%m. %H:%M}")
namen = {"platz_leer": "Platzpruefung leer -> abgelegt", "abgelegt": "abgelegt -> Platzpruefung neu",
         "platz_belegt": "Platzpruefung neu -> Messen", "bc_start": "BlankChange aufgerufen -> abgearbeitet"}
for k in SCHRITT:
    v = sorted(dauer.get(k, []))
    if v:
        print(f"  {namen[k]}: {len(v)} x normal, {v[0]:.1f} / {statistics.median(v):.1f} / {v[-1]:.1f} s "
              f"(min/median/max, Grenze {SCHRITT[k][1]} s)")
if paare:
    print(f"TwinCAT-Zeit = HMI-Zeit + {min(d for _, d in paare):.0f} bis {max(d for _, d in paare):.0f} s; "
          f"TwinCAT-Zeiten unten in HMI-Zeit")
zaehl = {}
for f in faelle:
    zaehl[f["stufe"]] = zaehl.get(f["stufe"], 0) + 1
print("Auffaellige Schritte:", ", ".join(f"{k} {v}" for k, v in sorted(zaehl.items())) or "keine")

for stufe in ("HAENGER OHNE MELDUNG", "HAENGER mit Meldung", "Abbruch", "anderer Ablauf"):
    for f in faelle:
        if f["stufe"] != stufe:
            continue
        print(f"\n== {stufe}: {f['t']:%d.%m. %H:%M:%S}  letzter Schritt: {f['s']}")
        if stufe.startswith("HAENGER"):
            print(f"   danach laeuft: {f['was']}")
        stand = (f["abbruch"] - f["t"]).total_seconds() if f["abbruch"] else f["dt"]
        wie = "bis zum Jobabbruch" if f["abbruch"] else "bis zur naechsten Logzeile"
        print(f"   {stand:.0f} s {wie} (Grenze {f['grenze']} s); naechste Logzeile {f['nxt'][0]:%H:%M:%S} {f['nxt'][1]}")
        if stufe in ("anderer Ablauf", "Abbruch"):
            continue
        dl = 0
        for z, e in f["ev"]:
            if "Druckluft" in e["text"] and abs((z - f["t"]).total_seconds()) > 20:
                dl += 1
                continue
            extra = f" [{e['arg']}]" if e["arg"] else ""
            pr = f" ({e['prog']})" if e["prog"] else ""
            print(f"   TwinCAT {z:%H:%M:%S} {e['quelle']} #{e['nr']} {e['text']}{extra}{pr}"[:200])
        if dl:
            print(f"   (+ {dl} kurze Druckluft-Warnungen weiter weg)")
        print(f"   (Uhrversatz hier {f['vs']:.0f} s)")
