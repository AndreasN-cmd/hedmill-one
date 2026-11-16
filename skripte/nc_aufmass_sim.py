#!/usr/bin/env python3
"""Programmierte Flaechen der Drehfraesjobs (G58, A0, B dreht) eines HEDmill-NC gegeneinander rechnen. Nur lesend, ohne numpy.

Wozu (Review 14.11.2026, Primaerteleskop SLM, MKD "beruehrt kaum"): prueft am fertigen NC, wie viel jeder Drehfraesjob
ueber der MKD-Bahn liegt (= programmiertes Aufmass, wie es wirklich im NC steht, inklusive CAM-Toleranz) und wo der MKD laut
Programm wie viel abnimmt. Dazu die Weite ueber parallele Flaechen (= Buegelmessschraube) der fertigen Friktion und der
Ringflaeche davor, damit ein Teil direkt gegen das NC gemessen werden kann.

Modell: Werkstueck-Polarraster (Y axial, phi um die B-Achse). Je Job der Radius rho(Y, phi), den das Werkzeug stehen laesst.
  Kugel: Schnitt Strahl/Kugel um die Kugelmitte (X-Versatz der Bahn eingerechnet).
  MKD T4126: Torus-Stirn (flach bis Rt - re, Eckenradius re), Achse radial, mit den DB-Werten (hyperDENT rechnet die Bahn damit).
  Drehsinn: Werkstueckwinkel = atan2(X, Z + r) - B (mit +B passen die Jobs nicht aufeinander; geprueft an UK44).
Nicht im Modell: Auslenkung, Waerme, Glaettung des LDYN-Satzes. Es zeigt nur, was programmiert ist.

Aufruf (am Mac, aus dem Repo):
  python3 -I skripte/nc_aufmass_sim.py <nc> [ystep 0.1] [phistep 2] [ymin] [ymax]
Laufzeit ca. 30 s je 50 Hoehen x 180 Winkel.
"""
import re, sys, math, bisect
from multiprocessing import Pool

RX = re.compile(r"([XYZABF])(-?\d+\.?\d*)")


def lesen(pfad):
    ops = []
    cur = None
    tool = None
    pos = {"X": 0.0, "Y": 0.0, "Z": 0.0, "A": 0.0, "B": 0.0}
    F = None
    for l in open(pfad, encoding="latin-1", errors="replace"):
        s = l.strip()
        m = re.match(r"N\d+\s*(.*)", s)
        if not m:
            continue
        body = m.group(1)
        mo = re.match(r"\(OPERATION (\d+): (.*)\)$", body)
        if mo:
            cur = dict(nr=int(mo.group(1)), name=mo.group(2), tool=tool, pts=[], g=None)
            ops.append(cur)
            continue
        mt = re.match(r"(T\d+) M6", body)
        if mt:
            tool = mt.group(1)
            if cur is not None and not cur["pts"]:
                cur["tool"] = tool
            continue
        if body.startswith("G58") or body.startswith("G59"):
            if cur is not None:
                cur["g"] = body[:3]
            continue
        if body.startswith("(") or body.startswith(";") or body.startswith("L ") or body.startswith("LDYN") \
                or re.match(r"[SM]\d", body):
            continue
        body = re.sub(r"\(.*?\)", "", body)
        w = dict((k, float(v)) for k, v in RX.findall(body))
        if not w:
            continue
        if "F" in w:
            F = w["F"]
        for k in "XYZAB":
            if k in w:
                pos[k] = w[k]
        if cur is not None and F is not None and F != 25000.0 and any(k in w for k in "XYZB"):
            cur["pts"].append((pos["X"], pos["Y"], pos["Z"], pos["A"], pos["B"], F))
    return ops


def abwickeln(B):
    out = [B[0]]
    for i in range(1, len(B)):
        d = B[i] - B[i - 1]
        if d < -180:
            d += 360
        if d > 180:
            d -= 360
        out.append(out[-1] + d)
    return out


def ist_dreh(o):
    p = o["pts"]
    if o["g"] != "G58" or len(p) < 100:
        return False
    Bs = [q[4] for q in p]
    return max(Bs) - min(Bs) > 300


RADIUS = {"T4081": 1.5, "T4083": 1.0, "T4086": 0.75, "T4098": 0.5, "T4089": 0.3}
MKD_RT, MKD_RE = 1.005, 0.2          # DB-Werte (hyperDENT rechnet die Bahn damit)
DB = 0.5                              # Verdichtung in Grad B
YBIN = 0.05


def verdichten(pts):
    Bu = abwickeln([p[4] for p in pts])
    out = []
    for i in range(1, len(pts)):
        x0, y0, z0 = pts[i - 1][0], pts[i - 1][1], pts[i - 1][2]
        x1, y1, z1 = pts[i][0], pts[i][1], pts[i][2]
        b0, b1 = Bu[i - 1], Bu[i]
        n = max(1, int(math.ceil(abs(b1 - b0) / DB)), int(math.ceil(math.hypot(z1 - z0, x1 - x0) / 0.05)))
        for k in range(1, n + 1):
            f = k / n
            out.append((x0 + f * (x1 - x0), y0 + f * (y1 - y0), z0 + f * (z1 - z0), b0 + f * (b1 - b0)))
    return out


def job_rechnen(arg):
    name, tool, pts, s, ys, phis = arg
    dens = verdichten(pts)
    ist_mkd = tool == "T4126"
    r = RADIUS.get(tool, 0.0)
    reich = MKD_RT if ist_mkd else r
    bins = {}
    for (x, y, z, b) in dens:
        if ist_mkd:
            alpha = (s * b) % 360.0
            rec = (alpha, y, z, x)
        else:
            zc = z + r
            alpha = (math.degrees(math.atan2(x, zc)) + s * b) % 360.0
            rec = (alpha, y, math.hypot(x, zc))
        bins.setdefault(int(math.floor(y / YBIN)), []).append(rec)
    keys = {}
    for k in bins:
        bins[k].sort()
        keys[k] = [q[0] for q in bins[k]]
    nb = int(math.ceil(reich / YBIN)) + 1
    grid = []
    for Y in ys:
        row = []
        kb = int(math.floor(Y / YBIN))
        for phi in phis:
            best = 1e9
            for k in range(kb - nb, kb + nb + 1):
                lst = bins.get(k)
                if not lst:
                    continue
                ka = keys[k]
                w = 32.0 if ist_mkd else min(60.0, math.degrees(math.asin(min(1.0, r / 1.8))) + 1.0)
                for lo, hi in ((phi - w, phi + w), (phi - w + 360, phi + w + 360), (phi - w - 360, phi + w - 360)):
                    if hi < 0 or lo > 360:
                        continue
                    i0 = bisect.bisect_left(ka, lo); i1 = bisect.bisect_right(ka, hi)
                    for q in lst[i0:i1]:
                        dy = Y - q[1]
                        d = math.radians(phi - q[0])
                        if ist_mkd:
                            if abs(dy) > MKD_RT:
                                continue
                            zj, xj = q[2], q[3]
                            cd, sd = math.cos(d), math.sin(d)
                            if cd <= 0.3:
                                continue
                            t = zj / cd
                            ok = True
                            for _ in range(4):
                                dd = math.hypot(t * sd - xj, dy)
                                if dd > MKD_RT:
                                    ok = False; break
                                rf = MKD_RT - MKD_RE
                                prof = 0.0 if dd <= rf else MKD_RE - math.sqrt(max(0.0, MKD_RE ** 2 - (dd - rf) ** 2))
                                t = (zj + prof) / cd
                            if ok and t < best:
                                best = t
                        else:
                            if abs(dy) >= r:
                                continue
                            rc = q[2]
                            cross = rc * math.sin(d)
                            disc = r * r - dy * dy - cross * cross
                            if disc <= 0:
                                continue
                            t = rc * math.cos(d) - math.sqrt(disc)
                            if t < best:
                                best = t
            row.append(best if best < 1e8 else None)
        grid.append(row)
    return name, tool, grid


def stuetzweiten(rho, phis):
    pts = [(r * math.cos(math.radians(p)), r * math.sin(math.radians(p))) for r, p in zip(rho, phis) if r is not None]
    W = []
    for t in range(0, 180):
        c, s = math.cos(math.radians(t)), math.sin(math.radians(t))
        pr = [x * c + y * s for x, y in pts]
        W.append((max(pr) - min(pr), t))
    return max(W), min(W)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    nc = sys.argv[1]
    ystep = float(sys.argv[2]) if len(sys.argv) > 2 else 0.1
    pstep = float(sys.argv[3]) if len(sys.argv) > 3 else 2.0
    ops = [o for o in lesen(nc) if ist_dreh(o) and (o["tool"] in RADIUS or o["tool"] == "T4126")
           and "KONNEKTOR" not in o["name"] and "STUFE 1" not in o["name"]]
    mkd = [o for o in ops if o["tool"] == "T4126"]
    if not mkd:
        sys.exit("kein MKD-Drehfraesjob (T4126) im NC")
    ym = [p[1] for p in mkd[0]["pts"]]
    ymin = float(sys.argv[4]) if len(sys.argv) > 4 else math.floor(min(ym) * 10) / 10
    ymax = float(sys.argv[5]) if len(sys.argv) > 5 else math.ceil(max(ym) * 10) / 10
    ys = [round(ymin + i * ystep, 4) for i in range(int(round((ymax - ymin) / ystep)) + 1)]
    phis = [i * pstep for i in range(int(round(360 / pstep)))]
    with Pool(min(6, len(ops))) as p:
        res = p.map(job_rechnen, [(o["name"], o["tool"], o["pts"], -1.0, ys, phis) for o in ops])
    mk = [g for n, t, g in res if t == "T4126"][0]
    pre = [(n, g) for n, t, g in res if t != "T4126"]
    print("Jobs vor dem MKD: " + " | ".join(n[:34] for n, _ in pre))
    print("\nY       n  | MKD nimmt programmiert (um): min  p10  Median  p90  max | Anteil < 10 um | je Vorjob Median ueber der MKD-Bahn (um)"
          " | Weite MKD-Flaeche gross/klein | Weite Flaeche vor MKD gross/klein")
    for i, Y in enumerate(ys):
        rem = []
        per = [[] for _ in pre]
        vor = []
        for k in range(len(phis)):
            vals = [g[i][k] for _, g in pre]
            v = min((x for x in vals if x is not None), default=None)
            vor.append(v)
            m = mk[i][k]
            if m is None or v is None:
                continue
            rem.append((v - m) * 1000)
            for q, x in enumerate(vals):
                if x is not None:
                    per[q].append((x - m) * 1000)
        if len(rem) < 20 or any(v is None for v in vor):
            print(f"{Y:7.2f} {len(rem):3d}  | (MKD oder Vorjobs decken diese Hoehe nicht ganz ab)")
            continue
        rem.sort()
        n = len(rem)
        fin = [min(v, m) if m is not None else v for v, m in zip(vor, mk[i])]
        (wg, _), (wk, _) = stuetzweiten(fin, phis)
        (vg, _), (vk, _) = stuetzweiten(vor, phis)
        pm = " ".join(f"{sorted(p)[len(p) // 2]:5.0f}" if p else "    -" for p in per)
        print(f"{Y:7.2f} {n:3d}  | {rem[0]:6.1f} {rem[n // 10]:5.1f} {rem[n // 2]:6.1f} {rem[9 * n // 10]:5.1f} {rem[-1]:6.1f} | "
              f"{sum(1 for r in rem if r < 10) / n * 100:4.0f} % | {pm} | {wg:.3f} / {wk:.3f} | {vg:.3f} / {vk:.3f}")
    print("\nWeite = Abstand zweier paralleler Flaechen (Buegelmessschraube), groesste und kleinste ueber alle Drehlagen. "
          f"Raster {pstep:g} Grad: Weite bis {2 * 4.0 * (1 - math.cos(math.radians(pstep / 2))) * 1000:.1f} um zu klein "
          "(fuer Messwerte phistep 0.5 nehmen).")


if __name__ == "__main__":
    main()
