#!/usr/bin/env python3
"""Jobuebergaenge aus der LoggedEvents.db (TwinCAT-Ereignisprotokoll) - nur lesend.
Aufruf am Mac:  python3 -I skripte/job_uebergaenge.py <Ordner von LOGS_SAMMELN oder LoggedEvents.db> [--ab JJJJ-MM-TT]

Je Jobende ("Job ... wurde abgearbeitet/abgebrochen", SPS-Meldung stMachine 5/4):
  - Abstand bis zum naechsten "Job ... wurde gestartet"
  - AUTO  = naechster Job startet <= 10 s danach (Autostart der Jobliste, normal 1-2 s)
  - HAND  = spaeter (Autostart war aus oder Liste leer)
  - Warnungen, die bis zum Jobende anstanden und wann sie geloescht wurden (Reset beim Start von Hand
    loescht sie ca. 1 s vor "gestartet"; im Autostart bleiben sie stehen)
  - alle Meldungen ab Schweregrad 2 zwischen Jobende und naechstem Start (ohne Druckluft-Warnung)
Hilfsjobs (Home, Warmlauf, EntladeBlank, GetBlankPos..) werden als Folgejob mitgezaehlt, aber nicht als Jobende gelistet.
Befund 24.11.2026: bis 21.11. jeder Serienuebergang AUTO, seit 22.11. keiner mehr (docs/11-stoerungen-historie.md).
"""
import sys, os, sqlite3, datetime, shutil, tempfile, json

args = [a for a in sys.argv[1:] if not a.startswith("--")]
ab = None
if "--ab" in sys.argv:
    ab = datetime.datetime.strptime(sys.argv[sys.argv.index("--ab") + 1], "%Y-%m-%d")
    args = [a for a in args if a != sys.argv[sys.argv.index("--ab") + 1]]
quelle = args[0]
db = os.path.join(quelle, "LoggedEvents.db") if os.path.isdir(quelle) else quelle

tmp = tempfile.mkdtemp()
kopie = os.path.join(tmp, "le.db")
shutil.copy(db, kopie)
for ext in ("-wal", "-shm"):
    if os.path.exists(db + ext):
        shutil.copy(db + ext, kopie + ext)
con = sqlite3.connect(f"file:{kopie}?mode=ro", uri=True)
con.text_factory = lambda b: b.decode("utf-8", "replace")

txt = {}
for ec, eid, t, lc in con.execute(
        "select et.EventClass, et.EventId, tr.Text, tr.LcId from EventTexts et "
        "join StringLocalized_Translations st on st.StringLocalizedId = et.StringLocalizedId "
        "join Translations tr on tr.Id = st.TranslationId"):
    if (ec, eid) not in txt or lc == 1031:
        txt[(ec, eid)] = t
arg = {}
for eid, buf in con.execute("select EventId, DataBuffer from Arguments"):
    arg[eid] = buf.decode("latin1", "replace").replace("\x00", " ").strip() if isinstance(buf, bytes) else str(buf)
t0 = datetime.datetime(1601, 1, 1, tzinfo=datetime.timezone.utc)
ev = []
for eid, ft, ca, ent, ec, evid, sev, src in con.execute(
        "select e.Id, e.Time, e.CategoryId, e.EntityId, en.EventClass, en.EventId, en.Severity, en.SourceInfo "
        "from Events e join Entities en on en.Id = e.EntityId order by e.Time"):
    z = (t0 + datetime.timedelta(microseconds=ft / 10)).astimezone().replace(tzinfo=None)
    try:
        q = json.loads(src).get("name", "")
    except Exception:
        q = str(src)
    ev.append(dict(z=z, cat=ca, ent=ent, nr=evid, sev=sev, quelle=q, text=txt.get((ec, evid), ""), arg=arg.get(eid, "")))

HILF = ("Home", "Warmlauf", "EntladeBlank", "0800_", "GetBlank", "1GetBlank", "0GetBlank", "GetPreform", "WZmessen")
starts = [e for e in ev if e["cat"] == 2 and "wurde gestartet" in e["text"]]
enden = [e for e in ev if e["cat"] == 2 and ("wurde abgearbeitet" in e["text"] or "wurde abgebrochen" in e["text"])]

def job(e):
    return e["arg"].split(" T#")[0].strip()

print(f"{'Jobende':15s} {'Job':38s} {'Laufzeit':10s} {'naechster Start':>15s}  Art   {'naechster Job':28s} Warnungen offen/geloescht  Meldungen dazwischen")
for e in enden:
    if ab and e["z"] < ab:
        continue
    j = job(e)
    if j.startswith(HILF):
        continue
    nxt = next((s for s in starts if s["z"] >= e["z"]), None)
    gap = (nxt["z"] - e["z"]).total_seconds() if nxt else None
    art = "AUTO" if gap is not None and gap <= 10 else "HAND"
    # Warnungen (CNC) offen am Jobende: zuletzt Raised vor Jobende, Cleared danach
    offen, gel_ende = 0, 0
    last = {}
    for x in ev:
        if x["z"] > e["z"] + datetime.timedelta(seconds=2):
            break
        if x["quelle"].startswith("TcCnc"):
            last.setdefault(x["ent"], []).append(x)
    for ent, lst in last.items():
        r = [x for x in lst if x["cat"] == 2]
        c = [x for x in lst if x["cat"] == 3]
        if r and (not c or c[-1]["z"] < r[-1]["z"]):
            offen += 1
        if c and abs((c[-1]["z"] - e["z"]).total_seconds()) <= 2:
            gel_ende += 1
    bis = nxt["z"] if nxt else e["z"] + datetime.timedelta(hours=12)
    dazw = sorted({f"{x['nr']} {x['text'][:45] or x['quelle'][-25:]}" for x in ev
                   if e["z"] < x["z"] < bis and x["cat"] == 2 and x["sev"] >= 2 and "Druckluft, Druck fast" not in x["text"]})
    lz = e["arg"].split(" T#")[1] if " T#" in e["arg"] else ""
    abbr = " ABGEBROCHEN" if "abgebrochen" in e["text"] else ""
    print(f"{e['z'].strftime('%m-%d %H:%M:%S'):15s} {j[:38]:38s} {lz:10s} "
          f"{(f'{gap/60:7.1f} min' if gap is not None else '-'):>15s}  {art}  {(job(nxt) if nxt else '-')[:28]:28s} {offen:3d} offen, {gel_ende:2d} am Ende geloescht"
          f"{abbr}  {'; '.join(dazw)[:120]}")
