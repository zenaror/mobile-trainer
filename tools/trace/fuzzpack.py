#!/usr/bin/env python3
"""Turn a finished tools/trace/explore.py search into an ordinary scenario macro.

explore.py keeps every corpus entry that found new instruction starts (`<out>/corpus/eN.macro`, a full script from power-on).  Here each entry is replayed
through the same tracer command line that the scenario will use, its exact coverage is compared with the current natural union (`analysis/coverage_union.tsv`,
optionally plus extra `--known` files), and a greedy set cover picks the few entries that reproduce all the new starts.  The chosen scripts are concatenated
into `<name>.macro` (a power cycle `reset` between them) that is meant to be added to traces/scenarios.tsv with the same start state / net options; only the
result of running that scenario through run_trace.py counts as evidence.

usage: fuzzpack.py --out SEARCHDIR --start STATE --name NAME [--net SPEC] [--web all] [--jobs N] [--known FILE ...] [--dest DIR]
"""
import argparse
import concurrent.futures
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))
import run_trace as rt  # noqa: E402


def load_union(path, keys):
    for ln in open(path):
        if ln.startswith("#") or not ln.strip():
            continue
        f = ln.split("\t")
        if len(f[0]) == 2 and f[0] not in ("WRAM", "HRAM"):
            try:
                keys.add((int(f[0], 16), int(f[1], 16)))
            except ValueError:
                pass


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", required=True)
    ap.add_argument("--start", required=True)
    ap.add_argument("--name", required=True)
    ap.add_argument("--net", default="fake:latency=2,mail=jp+ascii+game+multipart+long")
    ap.add_argument("--web", default="all")
    ap.add_argument("--jobs", type=int, default=6)
    ap.add_argument("--known", action="append", default=[])
    ap.add_argument("--dest", default=None, help="where to write NAME.macro (default: the search dir)")
    a = ap.parse_args()
    out = Path(a.out)
    have = set()
    load_union(ROOT / "analysis" / "coverage_union.tsv", have)
    for k in a.known:
        if k.endswith(".txt"):
            for ln in open(k):
                if ln.strip() and not ln.startswith("#"):
                    b, ad = ln.split()
                    have.add((int(b, 16), int(ad, 16)))
        else:
            load_union(k, have)
    s = rt.Scen([a.name, "on", a.net, a.start if a.start != "-" else "-", a.web, "fuzzpack"])
    entries = sorted((out / "corpus").glob("e*.macro"), key=lambda p: int(p.stem[1:]))
    work = out / "pack"
    work.mkdir(exist_ok=True)

    def run(p):
        n = p.stem
        od = work / n
        od.mkdir(exist_ok=True)
        cmd = [str(rt.CACHE / "mgba_trace"), "--rom", str(rt.BASEROM), "--scenario", n, "--outdir", str(od), "--macro", str(p), "--mobile", "on", "--net", s.net,
               "--frames", "60000"]
        if a.start != "-":
            cmd += ["--save-in", str(rt.CACHE / "state" / (a.start + ".sav")), "--mobile-config-in", str(rt.CACHE / "state" / (a.start + ".cfg"))]
        for kv in s.netopts:
            cmd += ["--net-opt", kv]
        for m in s.mails:
            cmd += ["--mail", str(rt.TRACES / "net" / m)]
        if s.web != "0":
            cmd += rt.web_args(s.web)
        subprocess.run(cmd, capture_output=True, text=True, timeout=600)
        keys = set()
        for ln in (od / ("coverage_%s.tsv" % n)).read_text().splitlines():
            if ln.startswith("#"):
                continue
            f = ln.split("\t")
            if len(f[0]) == 2 and f[0] not in ("WRAM", "HRAM"):
                keys.add((int(f[0], 16), int(f[1], 16)))
        frames = 0
        for ln in (od / ("stats_%s.txt" % n)).read_text().splitlines():
            if ln.startswith("frames="):
                frames = int(ln.split("=")[1])
        return p, keys - have, frames

    res = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as ex:
        for r in ex.map(run, entries):
            res.append(r)
    chosen = []
    covered = set()
    pool = [(p, k, fr) for (p, k, fr) in res if k]
    while pool:
        best = max(pool, key=lambda r: (len(r[1] - covered) / (200.0 + r[2]), len(r[1] - covered)))
        gain = best[1] - covered
        if not gain:
            break
        chosen.append((best[0], len(gain), best[2]))
        covered |= gain
        pool = [r for r in pool if r is not best]
    text = ["# Scenario '%s': replay of the useful entries of a coverage-guided input search (tools/trace/explore.py, docs/research/dynamic_tracing.md section 11)" % a.name,
            "# from the cartridge state left by '%s'; entries picked by tools/trace/fuzzpack.py (greedy set cover over the exact coverage of each replay).  Every segment starts with a" % a.start,
            "# power cycle; the random button sequences are plain macro lines (taps of 4 frames + 14 idle, waits, a few held combinations, sometimes a fake-Internet fault).",
            "# %d segments, %d instruction starts that the scenarios before it had not executed." % (len(chosen), len(covered))]
    for i, (p, gain, fr) in enumerate(chosen):
        text.append("# ---- segment %d: search entry %s, +%d starts, %d frames" % (i, p.stem, gain, fr))
        text.append("reset")
        text += [ln for ln in p.read_text().splitlines() if ln.strip()]
    dest = Path(a.dest) if a.dest else out
    (dest / (a.name + ".macro")).write_text("\n".join(text) + "\n")
    print("entries %d useful %d chosen %d new starts %d frames %d -> %s" % (len(entries), len(pool) + len(chosen), len(chosen), len(covered), sum(c[2] for c in chosen), dest / (a.name + ".macro")))


if __name__ == "__main__":
    main()
