#!/usr/bin/env python3
"""Coverage-guided input search on top of the tracer's fork server (`mgba_trace --serve`, see docs/research/dynamic_tracing.md, section 11).

Idea (AFL style, but for menu-driven software): a *corpus entry* is a macro script that starts at power-on from a fixed cartridge
state.  A worker replays one entry in a tracer process that then stays alive as a fork server; for every trial the server forks, the
child runs a short random button sequence (the *suffix*) from exactly the machine state the prefix left behind (memory, adapter,
fake Internet included) and reports which ROM instruction starts are new relative to a global bitmap.  A suffix that found new
starts becomes a new corpus entry (prefix + suffix); a suffix that reached a new BG tile-map picture without new starts is kept
(weakly, capped) so that the search can walk down menus whose first visit adds no code.

Determinism: the harness has no hidden inputs, so replaying an entry's whole script from power-on reproduces its coverage; the
accepted entries are re-run through the ordinary scenario machinery (traces/scenarios.tsv) and only that output is evidence.

usage: explore.py --start STATE [--net SPEC] [--web all] [--mail a+b] [--workers N] [--minutes M] [--seed S] [--out DIR]
                  [--known-extra FILE ...] [--seed-macro FILE ...]
       explore.py --start STATE --out DIR --report        (summary of a finished/running search)
"""
import argparse
import os
import random
import subprocess
import sys
import threading
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))
import run_trace as rt  # noqa: E402

BOOT = ["wait 400", "waitstable 60 max 600", "gap 30"]
BUTTONS = ["A"] * 6 + ["B"] * 3 + ["UP", "DOWN", "LEFT", "RIGHT"] * 2 + ["START", "SELECT"]
COMBOS = ["SELECT+LEFT", "B+SELECT+RIGHT", "A+B", "SELECT+START", "UP+SELECT", "A+START", "B+UP", "B+DOWN", "SELECT+RIGHT", "SELECT+DOWN"]
FAULTS = ["pop_fail=user", "pop_fail=pass", "pop_fail=stat", "pop_fail=retr", "pop_fail=connect", "smtp_fail=rcpt", "smtp_fail=data",
          "http_status=500", "http_missing=500", "http_trunc=300", "dns=nx", "tcp=refuse", "tcp=reset"]


def load_bitmap_from_union(path, bm):
    for ln in open(path):
        if ln.startswith("#") or not ln.strip():
            continue
        f = ln.split("\t")
        if len(f[0]) == 2 and f[0] not in ("WRAM", "HRAM"):
            try:
                b, a = int(f[0], 16), int(f[1], 16)
            except ValueError:
                continue
            o = a & 0x3FFF
            bm[b * 2048 + (o >> 3)] |= 1 << (o & 7)


def bm_set(bm, b, a):
    o = a & 0x3FFF
    i = b * 2048 + (o >> 3)
    m = 1 << (o & 7)
    if bm[i] & m:
        return False
    bm[i] |= m
    return True


class Entry:
    def __init__(self, eid, parent, lines, new, bg, depth, frames):
        self.id, self.parent, self.lines, self.new, self.bg, self.depth, self.frames = eid, parent, lines, new, bg, depth, frames
        self.picked = 0
        self.keys = []      # (bank, addr) first found by this entry's suffix


class Search:
    def __init__(self, a):
        self.a = a
        self.out = Path(a.out)
        (self.out / "work").mkdir(parents=True, exist_ok=True)
        self.lock = threading.Lock()
        self.known = bytearray(128 * 2048)
        load_bitmap_from_union(ROOT / "analysis" / "coverage_union.tsv", self.known)
        for extra in a.known_extra or []:
            if extra.endswith(".txt"):
                for ln in open(extra):
                    if ln.strip() and not ln.startswith("#"):
                        b, ad = ln.split()
                        bm_set(self.known, int(b, 16), int(ad, 16))
            else:
                load_bitmap_from_union(extra, self.known)
        self.rng = random.Random(a.seed)
        self.entries = []
        self.bgcount = {}
        self.total_new = 0
        self.jobs = 0
        self.t0 = time.time()
        self.deadline = self.t0 + a.minutes * 60
        self.log = open(self.out / "log.tsv", "a")
        self.next_id = 0
        seeds = [BOOT]
        for m in a.seed_macro or []:
            seeds.append([ln.rstrip("\n") for ln in open(m) if ln.strip() and not ln.startswith("#")])
        for lines in seeds:
            self.add(None, lines, 0, 0, 0)
        # a harness command line shared by every server
        self.base = self.harness_args()

    def add(self, parent, lines, new, bg, frames):
        e = Entry(self.next_id, parent.id if parent else None, lines, new, bg, (parent.depth + 1) if parent else 0, frames)
        self.next_id += 1
        self.entries.append(e)
        return e

    def harness_args(self):
        a = self.a
        s = rt.Scen([a.name, "on", a.net, a.start if a.start != "-" else "-", a.web, "explore"])
        cmd = [str(rt.CACHE / "mgba_trace"), "--rom", str(rt.BASEROM), "--scenario", a.name, "--outdir", str(self.out / "work"), "--serve"]
        cmd += ["--mobile", "on", "--net", s.net]
        if a.start != "-":
            state = rt.CACHE / "state"
            sav = a.state_dir / (a.start + ".sav") if a.state_dir else state / (a.start + ".sav")
            cfg = a.state_dir / (a.start + ".cfg") if a.state_dir else state / (a.start + ".cfg")
            cmd += ["--save-in", str(sav), "--mobile-config-in", str(cfg)]
        for kv in s.netopts:
            cmd += ["--net-opt", kv]
        for m in s.mails:
            cmd += ["--mail", str(rt.TRACES / "net" / m)]
        if s.web != "0":
            cmd += rt.web_args(s.web)
        return cmd

    # ---------------------------------------------------------------- suffix generator
    def suffix(self, rng):
        L = []
        if rng.random() < 0.03:
            L.append("net " + rng.choice(FAULTS))
        n = 1
        while rng.random() < 0.72 and n < 9:
            n += 1
        for _ in range(n):
            r = rng.random()
            if r < 0.04:
                L.append("hold %s %d" % (rng.choice(COMBOS), rng.choice([40, 120])))
            elif r < 0.12:
                L.append("tap %s x%d" % (rng.choice(BUTTONS), rng.randint(2, 12)))
            else:
                L.append("tap %s" % rng.choice(BUTTONS))
            L.append("wait %d" % rng.choice([30, 45, 60, 90, 180]))
        L.append("wait 60")
        return L

    def pick(self, rng):
        with self.lock:
            best, bw = None, -1
            for e in rng.sample(self.entries, min(len(self.entries), 24)):
                w = rng.random() / (1.0 + e.picked) * (2.0 if e.new else 1.0) / (1.0 + 0.04 * e.depth)
                if w > bw:
                    best, bw = e, w
            best.picked += 1
            return best

    # ---------------------------------------------------------------- worker
    def worker(self, wid):
        rng = random.Random(self.a.seed * 1000 + wid)
        while time.time() < self.deadline:
            e = self.pick(rng)
            base = self.out / "work" / ("w%d" % wid)
            base.mkdir(exist_ok=True)
            mac = base / "prefix.macro"
            mac.write_text("\n".join(e.lines) + "\n")
            with self.lock:
                kb = self.out / "known.bin"
                kb.write_bytes(bytes(self.known))
            cmd = self.base + ["--macro", str(mac), "--known", str(kb), "--outdir", str(base)]
            errf = open(base / "stderr.txt", "w")
            p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=errf, text=True, bufsize=1)
            try:
                line = p.stdout.readline()
                if not line.startswith("READY"):
                    continue
                prefix_frames = int(line.split()[1])
                for j in range(self.a.jobs):
                    if time.time() > self.deadline:
                        break
                    suf = self.suffix(rng)
                    sm = base / "job.macro"
                    sm.write_text("\n".join(suf) + "\n")
                    res = base / "job.res"
                    if res.exists():
                        res.unlink()
                    p.stdin.write("JOB %d %s %s\n" % (self.a.maxframes, sm, res))
                    p.stdin.flush()
                    line = p.stdout.readline()
                    if not line.startswith("DONE"):
                        break
                    self.jobs += 1
                    self.consume(e, suf, res, prefix_frames)
            finally:
                try:
                    p.stdin.write("QUIT\n")
                    p.stdin.flush()
                except Exception:
                    pass
                try:
                    p.wait(timeout=10)
                except Exception:
                    p.kill()
                errf.close()

    def consume(self, e, suf, res, prefix_frames):
        try:
            rows = res.read_text().splitlines()
        except FileNotFoundError:
            return
        info = {}
        keys = []
        for r in rows:
            f = r.split()
            if f[0] in ("frames", "lcd", "bg"):
                info[f[0]] = f[1]
            else:
                keys.append((int(f[0], 16), int(f[1], 16)))
        with self.lock:
            fresh = [(b, a) for (b, a) in keys if bm_set(self.known, b, a)]
            bg = info.get("bg", "0")
            frames = prefix_frames + int(info.get("frames", "0"))
            if fresh:
                ne = self.add(e, e.lines + suf, len(fresh), bg, frames)
                ne.keys = fresh
                cd = self.out / "corpus"
                cd.mkdir(exist_ok=True)
                (cd / ("e%d.macro" % ne.id)).write_text("\n".join(ne.lines) + "\n")
                with open(self.out / "new_starts.txt", "a") as nf:
                    for (b, a) in fresh:
                        nf.write("%02X %04X\n" % (b, a))
                with open(self.out / "found.tsv", "a") as ff:
                    ff.write("%d\t%s\t%d\t%d\t%d\t%s\n" % (ne.id, e.id, len(fresh), ne.depth, frames, " ".join("%02X:%04X" % k for k in fresh[:64])))
                self.total_new += len(fresh)
                self.bgcount[bg] = self.bgcount.get(bg, 0) + 1
                self.log.write("%d\t%d\t%d\t%d\t%.0f\t%s\n" % (ne.id, e.id, len(fresh), self.total_new, time.time() - self.t0,
                                                              " | ".join(suf)))
                self.log.flush()
            elif e.depth < self.a.maxdepth and self.bgcount.get(bg, 0) < self.a.bgcap and info.get("frames"):
                self.bgcount[bg] = self.bgcount.get(bg, 0) + 1
                self.add(e, e.lines + suf, 0, bg, frames)

    def run(self):
        ths = [threading.Thread(target=self.worker, args=(i,)) for i in range(self.a.workers)]
        for t in ths:
            t.start()
        while any(t.is_alive() for t in ths):
            time.sleep(30)
            with self.lock:
                print("[%4.0fs] jobs %d entries %d total new starts %d" % (time.time() - self.t0, self.jobs, len(self.entries), self.total_new), flush=True)
        for t in ths:
            t.join()
        print("done: jobs %d entries %d strong %d new starts %d" % (self.jobs, len(self.entries), sum(1 for e in self.entries if e.new), self.total_new))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--name", default="explore")
    ap.add_argument("--start", required=True, help="scenario whose saved SRAM/adapter config the cartridge starts from, or -")
    ap.add_argument("--state-dir", type=Path)
    ap.add_argument("--net", default="fake:latency=2,mail=jp+ascii+game+multipart+long")
    ap.add_argument("--web", default="all")
    ap.add_argument("--workers", type=int, default=8)
    ap.add_argument("--minutes", type=float, default=10)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--jobs", type=int, default=96, help="trials per server process")
    ap.add_argument("--maxframes", type=int, default=3000)
    ap.add_argument("--maxdepth", type=int, default=14)
    ap.add_argument("--bgcap", type=int, default=2, help="weak entries kept per BG-map picture")
    ap.add_argument("--out", required=True)
    ap.add_argument("--known-extra", action="append")
    ap.add_argument("--seed-macro", action="append")
    a = ap.parse_args()
    Search(a).run()


if __name__ == "__main__":
    main()
