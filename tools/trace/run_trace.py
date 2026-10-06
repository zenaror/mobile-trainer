#!/usr/bin/env python3
"""Reproducible dynamic-analysis harness driver for the Mobile Trainer ROM.

Builds (once, out of tree, under .cache/trace/) the mGBA fork's libmgba and the C tracer
tools/trace/mgba_trace.c, runs every scenario of traces/scenarios.tsv headlessly, and writes:

  traces/coverage_<s>.tsv   traces/mbc_writes_<s>.tsv   traces/serial_<s>.tsv     (primary evidence)
  traces/detail/<s>/*       call graph, interrupts, hardware registers, SRAM/ROM data accesses, RAM code,
                            adapter/network log, stats ...
  traces/inputs/<s>.txt     resolved frame->buttons script of each macro (replayed by default)
  traces/summary.md         human-readable digest
  analysis/ram_code_dump.bin  WRAM/HRAM image at the end of the RAM-dump scenario

Usage:
  tools/trace/run_trace.py                    replay every scenario from its recorded traces/inputs/<s>.txt
  tools/trace/run_trace.py --only register,homepage
  tools/trace/run_trace.py --from-macro       re-run the .macro sources (waitstable etc.) and regenerate the .txt
  tools/trace/run_trace.py --list
  tools/trace/run_trace.py --verify-determinism register_neterr   run a scenario twice and compare all outputs
  tools/trace/run_trace.py --shots DIR        also keep the screenshots requested by 'shot' lines (default: .cache/trace/shots)

Environment:
  MGBA_SRC   mGBA fork source tree (default: the path recorded below)
  BASEROM    ROM to trace (default: <repo>/baserom.gbc)
Needs: cmake, make, gcc, python3, (Pillow only for tools/trace/contact_sheet.py).
"""
import argparse
import concurrent.futures
import hashlib
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CACHE = ROOT / ".cache" / "trace"
MGBA_SRC = Path(os.environ.get("MGBA_SRC", "/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects/MobileAdapterGB/mgba/mgba"))
BASEROM = Path(os.environ.get("BASEROM", ROOT / "baserom.gbc"))
SCEN_FILE = ROOT / "traces" / "scenarios.tsv"
TRACES = ROOT / "traces"
RAM_DUMP_SCENARIO = "register"       # analysis/ram_code_dump.bin comes from this scenario's end-of-run RAM
TAIL_FRAMES = 0                       # extra frames after the last scripted frame (0 = stop exactly there)
ROM_SHA256 = "6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570"

PRIMARY = ("coverage", "mbc_writes", "serial")


def sh(cmd, **kw):
    return subprocess.run(cmd, check=True, **kw)


# ----------------------------------------------------------------------------------------------------- build
def ensure_mgba():
    b = CACHE / "mgba"
    b.mkdir(parents=True, exist_ok=True)
    if not (b / "Makefile").exists():
        print("[build] configuring mGBA fork out of tree ->", b, flush=True)
        args = ["cmake", str(MGBA_SRC), "-DCMAKE_BUILD_TYPE=Release", "-DBUILD_QT=OFF", "-DBUILD_SDL=OFF",
                "-DBUILD_GL=OFF", "-DBUILD_GLES2=OFF", "-DBUILD_GLES3=OFF", "-DBUILD_SHARED=ON", "-DBUILD_STATIC=OFF",
                "-DUSE_FFMPEG=OFF", "-DUSE_LIBZIP=OFF", "-DUSE_LZMA=OFF", "-DUSE_ELF=OFF", "-DUSE_SQLITE3=OFF",
                "-DUSE_JSON_C=OFF", "-DUSE_DISCORD_RPC=OFF", "-DUSE_EDITLINE=OFF", "-DUSE_LUA=OFF", "-DENABLE_SCRIPTING=OFF",
                "-DUSE_PNG=ON", "-DUSE_LIBMOBILE=ON", "-DBUILD_LTO=OFF"]
        with open(b / "cmake.log", "w") as lg:
            sh(args, cwd=b, stdout=lg, stderr=subprocess.STDOUT)
    r = subprocess.run(["make", "-j%d" % (os.cpu_count() or 4)], cwd=b, capture_output=True, text=True)
    (b / "make.log").write_text(r.stdout + r.stderr)
    if r.returncode != 0:
        sys.exit("libmgba build failed, see %s" % (b / "make.log"))
    return b


def ensure_harness(b):
    flags = (b / "CMakeFiles" / "mgba.dir" / "flags.make").read_text()
    defs = re.search(r"^C_DEFINES = (.*)$", flags, re.M).group(1).split()
    defs = [d for d in defs if d not in ("-DMGBA_DLL", "-Dmgba_EXPORTS")]
    src = ROOT / "tools" / "trace" / "mgba_trace.c"
    out = CACHE / "mgba_trace"
    stamp = CACHE / "mgba_trace.stamp"
    want = hashlib.sha256((src.read_bytes() + " ".join(defs).encode() + (b / "libmgba.so.0.11.0").read_bytes())).hexdigest()
    if out.exists() and stamp.exists() and stamp.read_text() == want:
        return out
    print("[build] compiling tracer", flush=True)
    cmd = ["gcc", "-O2", "-fwrapv", "-Wall", "-Wno-unused-function"] + defs + [
        "-o", str(out), str(src),
        "-I%s" % (MGBA_SRC / "include"), "-I%s" % (b / "include"),
        "-I%s" % (MGBA_SRC / "src" / "third-party" / "libmobile"), "-I%s" % (b / "libmobile"),
        "-L%s" % b, "-lmgba", "-Wl,-rpath,%s" % b]
    sh(cmd)
    stamp.write_text(want)
    return out


# ----------------------------------------------------------------------------------------------- scenarios
class Scen:
    """One row of traces/scenarios.tsv.  `net` is `stub|fake|real` optionally followed by `:key=value,key=value` (fake Internet
    options, see the comment above the fake net in mgba_trace.c; the key `mail=a+b` selects traces/net/mail_a.eml, mail_b.eml for
    the fake POP3 mailbox).  `web` is 0, 1 (index.html + page.html, the original two pages), `all` (every traces/web/* file
    served under its own name, index.html for any path containing index.html, page.html for other .html) or the name of a site, a sub-directory
    of traces/web (`r2`, `ul`): its own pages first, then everything of `all`."""

    def __init__(self, row):
        (self.name, self.mobile, net, self.parent, self.web, self.desc) = row[:6]
        self.net, _, optstr = net.partition(":")
        self.netopts, self.mails = [], []
        for kv in [x for x in optstr.split(",") if x]:
            k, _, v = kv.partition("=")
            if k == "mail":
                self.mails += ["mail_%s.eml" % m for m in v.split("+") if m]
            else:
                self.netopts.append(kv)
        self.parent = None if self.parent == "-" else self.parent
        # optional 7th column: extra tokens: `lite` (publish only coverage/mbc_writes + the small detail files), or raw harness
        # arguments (`--sram-fill 00`, `--sram-poke 0:A000=12`, `--cfg-poke 2=00`) separated by spaces
        extra = row[6].split() if len(row) > 6 else []
        self.lite = "lite" in extra
        self.forced = "forced" in extra          # FORCED execution (macro directives `force` / `ramset`): published under traces/forced/, never in the union
        self.args = [x for x in extra if x not in ("lite", "forced")]


def load_scenarios():
    out = []
    for ln in SCEN_FILE.read_text().splitlines():
        if not ln.strip() or ln.startswith("#"):
            continue
        row = ln.split("\t")
        if row[0] == "name":
            continue
        out.append(Scen(row))
    return out


def order(scens):
    by = {s.name: s for s in scens}
    done, res = set(), []

    def visit(s):
        if s.name in done:
            return
        if s.parent:
            visit(by[s.parent])
        done.add(s.name)
        res.append(s)
    for s in scens:
        visit(s)
    return res


def web_sites():
    """The names of the sub-directories of traces/web (r2, ul, ...): each is a site that a scenario selects with `web=<name>`."""
    return sorted(d.name for d in (ROOT / "traces" / "web").iterdir() if d.is_dir())


def put_file(dst, data):
    """Write `data` to `dst` unless it already holds exactly that, and replace it atomically otherwise: scenarios run in parallel (--jobs) and every one calls prepare_web(), so a plain
    write_bytes() would truncate a page that another scenario's fake server is serving at that moment (an empty answer: the replay then differs from the recorded one)."""
    if dst.exists() and dst.read_bytes() == data:
        return
    tmp = dst.with_name(".%s.%d.tmp" % (dst.name, os.getpid()))
    tmp.write_bytes(data)
    os.replace(tmp, dst)


def prepare_web():
    """Shift-JIS copies of the synthetic pages -> .cache/trace/web/ (binary files such as .bmp are copied as they are)"""
    w = CACHE / "web"
    w.mkdir(parents=True, exist_ok=True)
    for f in sorted((ROOT / "traces" / "web").iterdir()):
        if f.suffix == ".html":
            t = f.read_text(encoding="utf-8")
            put_file(w / f.name, t.replace("\r\n", "\n").encode("cp932"))
        elif f.suffix in (".bmp", ".htm"):
            put_file(w / f.name, f.read_bytes())
    for site in web_sites():                          # a site (web=<name>): its own index.html and pages, same conversion rules
        (w / site).mkdir(exist_ok=True)
        for f in sorted((ROOT / "traces" / "web" / site).iterdir()):
            if f.suffix == ".html":
                put_file(w / site / f.name, f.read_text(encoding="utf-8").replace("\r\n", "\n").encode("cp932"))
            elif f.suffix in (".bmp", ".htm", ".meta"):
                put_file(w / site / f.name, f.read_bytes())
    return w


def web_args(mode):
    w = prepare_web()
    if mode in web_sites():
        # a site (web=r2, web=ul, ...): traces/web/<site>/* first (own names; index.html = <site>/index.html), then everything of web=all.  A file
        # NAME.meta next to NAME holds `status N` and/or `hdr Header: value` lines (--web-status / --web-hdr for that path).
        a = []
        r2 = w / mode
        for f in sorted(r2.iterdir()):
            if f.suffix == ".meta" or f.name == "index.html":
                continue
            a += ["--web-map", "*/%s=%s" % (f.name, f)]
        a += ["--web-map", "*index.html=%s" % (r2 / "index.html")]
        for f in sorted(r2.glob("*.meta")):
            target = f.name[:-5]
            for ln in f.read_text().splitlines():
                if ln.startswith("status "):
                    a += ["--web-status", "*/%s=%s" % (target, ln[7:].strip())]
                elif ln.startswith("hdr "):
                    a += ["--web-hdr", "*/%s=%s" % (target, ln[4:].strip())]
        return a + web_args("all")
    if mode == "all":
        a = []
        for f in sorted(w.iterdir()):
            if f.is_file() and f.name not in ("index.html", "page.html"):
                a += ["--web-map", "*/%s=%s" % (f.name, f)]    # own name first ('*' = substring match on the request path)
        a += ["--web-map", "*index.html=%s" % (w / "index.html"), "--web-map", "*.html=%s" % (w / "page.html")]
        return a
    return ["--web-map", "*index.html=%s" % (w / "index.html"), "--web-map", "*.html=%s" % (w / "page.html")]


def last_frame(txt):
    m = re.search(r"# last scripted frame: (\d+)", txt.read_text())
    if not m:
        sys.exit("%s has no '# last scripted frame' header (regenerate with --from-macro)" % txt)
    return int(m.group(1))


def run_scenario(s, harness, args, outroot):
    state = CACHE / "state"
    state.mkdir(parents=True, exist_ok=True)
    out = outroot / s.name
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)
    macro = TRACES / "inputs" / (s.name + ".macro")
    txt = TRACES / "inputs" / (s.name + ".txt")
    if getattr(args, "verify_round", 0):
        txt = outroot.parent / "verify1" / s.name / (s.name + ".txt")     # recorded by round 1
    cmd = [str(harness), "--rom", str(BASEROM), "--scenario", s.name, "--outdir", str(out)]
    replay = txt.exists() and (not args.from_macro or getattr(args, "verify_round", 0) == 2)
    if replay:
        cmd += ["--input", str(txt), "--frames", str(last_frame(txt) + TAIL_FRAMES)]
    else:
        if not macro.exists():
            sys.exit("no macro for %s" % s.name)
        rec = txt if not args.verify else out / (s.name + ".txt")
        cmd += ["--macro", str(macro), "--record-input", str(rec)]
    shots = Path(args.shots) if args.shots else CACHE / "shots"
    shotdir = out / "shots" if args.verify else shots / s.name
    shotdir.mkdir(parents=True, exist_ok=True)
    cmd += ["--shots", str(shotdir)]
    if s.mobile == "on":
        cmd += ["--mobile", "on"]
    elif s.mobile.startswith("at:"):
        cmd += ["--mobile-at", s.mobile[3:]]
    cmd += ["--net", s.net]
    if s.parent:
        cmd += ["--save-in", str(state / (s.parent + ".sav"))]
        if s.mobile != "off":
            cmd += ["--mobile-config-in", str(state / (s.parent + ".cfg"))]
    cmd += ["--save-out", str(out / (s.name + ".sav"))]
    if s.mobile != "off":
        cmd += ["--mobile-config-out", str(out / (s.name + ".cfg"))]
    cmd += s.args
    for kv in s.netopts:
        cmd += ["--net-opt", kv]
    for m in s.mails:
        cmd += ["--mail", str(TRACES / "net" / m)]
    if s.web != "0":
        cmd += web_args(s.web)
    t0 = time.time()
    r = subprocess.run(cmd, capture_output=True, text=True)
    dt = time.time() - t0
    if r.returncode != 0:
        sys.stderr.write(r.stdout + r.stderr)
        sys.exit("scenario %s failed" % s.name)
    for line in r.stderr.splitlines():
        if "hit the" in line and "cap" in line:
            print("   note:", line.strip())
    # persist chain state
    shutil.copy(out / (s.name + ".sav"), state / (s.name + ".sav"))
    if (out / (s.name + ".cfg")).exists():
        shutil.copy(out / (s.name + ".cfg"), state / (s.name + ".cfg"))
    return dt


def publish(s, outroot):
    """copy primary files to traces/ and the rest to traces/detail/<s>/"""
    out = outroot / s.name
    root = TRACES / "forced" if s.forced else TRACES
    root.mkdir(exist_ok=True)
    detail = root / "detail" / s.name
    if detail.exists():
        shutil.rmtree(detail)
    detail.mkdir(parents=True)
    for f in sorted(out.iterdir()):
        n = f.name
        kind = n[:-len(s.name) - 5] if n.endswith("_%s.tsv" % s.name) else None
        if s.lite and kind in ("serial", "callgraph", "hwregs", "mbc_seq", "irq"):
            continue                    # lite scenarios keep coverage, mbc_writes, dataaccess, ramcode, serialsum, irqsum, stats, marks, adapter.log
        if kind in PRIMARY:
            shutil.copy(f, root / n)
        elif n.endswith((".sav", ".cfg", ".bin")) and not n.startswith("ram_end"):
            continue                    # chain state / big binaries stay in the cache
        elif n.startswith("ram_end_"):
            continue
        elif n.endswith(".txt") and n == s.name + ".txt":
            continue
        else:
            k = n.replace("_%s." % s.name, ".")
            shutil.copy(f, detail / k)
    if s.name == RAM_DUMP_SCENARIO:
        (ROOT / "analysis").mkdir(exist_ok=True)
        shutil.copy(out / ("ram_end_%s.bin" % s.name), ROOT / "analysis" / "ram_code_dump.bin")


# ------------------------------------------------------------------------------------------------ summary
def detail_dir(s):
    return (TRACES / "forced" if s.forced else TRACES) / "detail" / s.name


def parse_stats(p):
    d = {}
    for ln in p.read_text().splitlines():
        if "=" in ln:
            k, v = ln.split("=", 1)
            d[k] = v
    return d


def serial_total(s):
    p = detail_dir(s) / "serialsum.tsv"
    n = 0
    for ln in p.read_text().splitlines():
        if ln and not ln.startswith("#"):
            n += int(ln.split("\t")[4])
    return n


def adapter_commands(log):
    cnt = {}
    if not log.exists():
        return cnt
    for ln in log.read_text(errors="replace").splitlines():
        m = re.search(r">>> ([0-9A-F]{2}) ([A-Za-z0-9 ]+?)(?::|\s\(|$)", ln)
        if m:
            k = "%s %s" % (m.group(1), m.group(2).strip())
            cnt[k] = cnt.get(k, 0) + 1
    return cnt


def write_summary(scens, times):
    sys.path.insert(0, str(Path(__file__).parent))
    import merge_coverage
    stats = {s.name: parse_stats(detail_dir(s) / "stats.txt") for s in scens}
    L = []
    L.append("# Dynamic trace summary\n")
    L.append("Generated by `tools/trace/run_trace.py` (do not edit). See `docs/research/dynamic_tracing.md` for method and limits.\n")
    L.append("* ROM: `baserom.gbc` sha256 `%s`" % ROM_SHA256)
    try:
        head = subprocess.run(["git", "-C", str(MGBA_SRC), "rev-parse", "--short", "HEAD"], capture_output=True, text=True).stdout.strip()
    except Exception:
        head = "?"
    L.append("* Emulator: mGBA fork (libmgba 0.11, Mobile Adapter GB support via libmobile), source commit `%s`, built out of tree from the source tree (the pre-built binaries in `build-noble` are older than the sources and were **not** used)." % head)
    L.append("* CPU model: CGB (ROM header 0xC0), HLE boot (no BIOS), SRAM 0xFF-filled unless a scenario chains a previous save.")
    L.append("* Coverage = instruction-start addresses actually executed. **Absence of coverage proves nothing.**\n")
    L.append("## Scenarios\n")
    L.append("| scenario | frames | instr. executed | unique instr. starts (ROM / RAM) | ROM banks | IRQs | serial events (all) | adapter cmds | description |")
    L.append("|---|---:|---:|---:|---:|---:|---:|---:|---|")
    for s in scens:
        st = stats[s.name]
        ac = adapter_commands(detail_dir(s) / "adapter.log")
        L.append("| %s | %s | %s | %s (%s / %s) | %s | %s | %s | %d | %s |" % (
            s.name + (" (forced)" if s.forced else ""), st["frames"], st["instructions"], st["unique_instruction_starts"], st["rom_instruction_starts"],
            st["ram_instruction_starts"], st["rom_banks_executed"], st["interrupts_taken"],
            serial_total(s), sum(ac.values()), s.desc))
    L.append("")
    u = merge_coverage.union_stats()
    L.append("## Union over all natural scenarios\n")
    L.append("Scenarios marked `(forced)` in the table above (harness directive `force`, outputs under `traces/forced/`) are NOT part of this union (`analysis/coverage_forced.tsv` lists what only they executed).\n")
    L.append("* unique executed ROM instruction starts: **%d** in **%d** banks (`analysis/coverage_union.tsv`)" % (u["rom_addrs"], len(u["banks"])))
    L.append("* executed RAM instruction starts (WRAM/HRAM): **%d**" % u["ram_addrs"])
    L.append("* ROM banks with executed code: %s" % " ".join("%02X" % b for b in sorted(u["banks"])))
    L.append("")
    L.append("## Mobile Adapter commands issued by the ROM (all scenarios)\n")
    tot = {}
    per = {}
    for s in scens:
        if s.forced:
            continue
        for k, v in adapter_commands(detail_dir(s) / "adapter.log").items():
            tot[k] = tot.get(k, 0) + v
            per.setdefault(k, []).append(s.name)
    L.append("Command byte and name are as logged by libmobile (not ROM-derived names).\n")
    L.append("| cmd | name | count | scenarios |")
    L.append("|---|---|---:|---|")
    for k in sorted(tot):
        c, n = k.split(" ", 1)
        L.append("| %s | %s | %d | %s |" % (c, n, tot[k], ", ".join(per[k][:6]) + (" ..." if len(per[k]) > 6 else "")))
    L.append("")
    L.append("## Files\n")
    L.append("* `coverage_<s>.tsv`, `mbc_writes_<s>.tsv`, `serial_<s>.tsv`: primary evidence per scenario (formats in `docs/research/dynamic_tracing.md`).")
    L.append("* `detail/<s>/`: `callgraph`, `irq`, `irqsum`, `hwregs`, `ramcode`, `dataaccess`, `serialsum`, `mbc_seq`, `marks`, `adapter.log`, `stats.txt`.")
    L.append("* `inputs/<s>.macro` (readable source) and `inputs/<s>.txt` (resolved frame script that is replayed).")
    L.append("* `scenarios.tsv`: scenario table. `web/`: synthetic pages for the fake Internet.\n")
    (TRACES / "summary.md").write_text("\n".join(L))


# ------------------------------------------------------------------------------------------------- main
def dirhash(d):
    h = {}
    for f in sorted(d.iterdir()):
        if f.is_file():
            h[f.name] = hashlib.sha256(f.read_bytes()).hexdigest()
    return h


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--only", help="comma separated scenario names (their parents are run too)")
    ap.add_argument("--from-macro", action="store_true", help="run the .macro sources and regenerate inputs/*.txt")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--shots", help="directory for screenshots (default .cache/trace/shots)")
    ap.add_argument("--verify-determinism", metavar="SCENARIO", help="run SCENARIO (and its parents) twice, compare every output")
    ap.add_argument("--jobs", type=int, default=1, help="parallel scenarios (only independent ones)")
    ap.add_argument("--reuse-state", action="store_true", help="with --only: do not re-run a parent scenario whose saved state is already in .cache/trace/state")
    args = ap.parse_args()
    args.verify = False
    scens = order(load_scenarios())
    if args.list:
        for s in scens:
            print("%-22s mobile=%-8s net=%-5s from=%-18s %s" % (s.name, s.mobile, s.net, s.parent or "-", s.desc))
        return 0
    if not BASEROM.exists():
        sys.exit("missing %s" % BASEROM)
    sha = hashlib.sha256(BASEROM.read_bytes()).hexdigest()
    if sha != ROM_SHA256:
        sys.exit("ROM hash mismatch: %s" % sha)
    b = ensure_mgba()
    harness = ensure_harness(b)
    by = {s.name: s for s in scens}

    def closure(names):
        need = set()

        def add(n):
            if n in need:
                return
            need.add(n)
            if by[n].parent:
                pp = CACHE / "state" / (by[n].parent + ".sav")
                if args.reuse_state and pp.exists():
                    return                       # parent state is on disk: the child starts from it
                add(by[n].parent)
        for n in names:
            add(n)
        return [s for s in scens if s.name in need]

    if args.verify_determinism:
        sel = closure([args.verify_determinism])
        args.verify = True
        args.from_macro = True
        res = []
        for rnd in (1, 2):
            root = CACHE / ("verify%d" % rnd)
            if root.exists():
                shutil.rmtree(root)
            root.mkdir(parents=True)
            args.verify_round = rnd            # round 1 = run the macros, round 2 = replay round 1's recorded input
            for s in sel:
                run_scenario(s, harness, args, root)
            res.append({s.name: dirhash(root / s.name) for s in sel})
            for s in sel:
                sd = root / s.name / "shots"
                if sd.exists():
                    res[-1][s.name].update({"shots/" + k: v for k, v in dirhash(sd).items()})
        ok = True
        for s in sel:
            a, c = res[0][s.name], res[1][s.name]
            for k in sorted(set(a) | set(c)):
                if k == s.name + ".txt":
                    continue
                if a.get(k) != c.get(k):
                    print("DIFF", s.name, k)
                    ok = False
        print("deterministic: all %d scenario(s), %d output files identical" % (len(sel), sum(len(v) for v in res[0].values())) if ok else "NOT deterministic")
        return 0 if ok else 1

    sel = closure(args.only.split(",")) if args.only else scens
    outroot = CACHE / "out"
    outroot.mkdir(parents=True, exist_ok=True)
    (TRACES / "inputs").mkdir(parents=True, exist_ok=True)
    times = {}
    done = set()
    pending = list(sel)
    with concurrent.futures.ThreadPoolExecutor(max_workers=max(1, args.jobs)) as ex:
        while pending:
            ready = [s for s in pending if not s.parent or s.parent in done or s.parent not in {p.name for p in pending}]
            futs = {ex.submit(run_scenario, s, harness, args, outroot): s for s in ready}
            for f in concurrent.futures.as_completed(futs):
                s = futs[f]
                times[s.name] = f.result()
                print("[run] %-20s %.1fs" % (s.name, times[s.name]), flush=True)
                publish(s, outroot)
                done.add(s.name)
            pending = [s for s in pending if s.name not in done]
    if not args.only:
        # merged views
        sys.path.insert(0, str(Path(__file__).parent))
        import merge_coverage
        merge_coverage.main([])
        write_summary(scens, times)
        print("wrote traces/summary.md, analysis/coverage_union.tsv")
    return 0


if __name__ == "__main__":
    sys.exit(main())
