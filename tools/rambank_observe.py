#!/usr/bin/env python3
"""Per-address bank observations: which WRAM bank (rSVBK) and SRAM bank (RAMB) were in force when each ROM instruction
started, over the traced scenarios.  Writes ONLY under analysis/rambank/ (or --out); the coverage outputs owned by
tools/trace/run_trace.py (traces/, analysis/coverage_union.tsv, .cache/trace/state) are never read for writing or changed.

    python3 tools/rambank_observe.py [--only a,b] [--jobs N] [--out DIR] [--work DIR] [--harness FILE]
    python3 tools/rambank_observe.py --merge-only        # re-merge existing <work>/obs/*/bankobs_*.tsv

How: every scenario of traces/scenarios.tsv is replayed from its recorded input (traces/inputs/<s>.txt) with the same
arguments as run_trace.py, but with the extra tracer option `--bank-obs` (tools/trace/mgba_trace.c) and with a private
chain-state directory (<work>/state) so a re-run never overwrites the state of the trace agent.  The tracer writes
bankobs_<s>.tsv (bank addr wram_mask sram_mask sram_enabled joint_mask); this script ORs the masks over all scenarios into

  analysis/rambank/observed_banks.tsv   bank addr wram_mask sram_mask sram_enabled joint_mask nscen
  analysis/rambank/observe_runs.tsv     scenario, frames, instructions, unique instruction starts

Observations are dynamic evidence about the scenarios that were run: absence of an observation proves nothing and an
observed bank set is only a lower bound of the banks a routine can run under.
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

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools' / 'trace'))
import run_trace as rt                              # noqa: E402  (read-only use: Scen, load_scenarios, order, last_frame)

TRACER_SRC = ROOT / 'tools' / 'trace' / 'mgba_trace.c'
DEFAULT_OUT = ROOT / 'analysis' / 'rambank'
DEFAULT_WORK = Path(os.environ.get('RAMBANK_WORK', ROOT / '.cache' / 'rambank'))


def build_harness(work: Path) -> Path:
    """Compile the tracer into <work> against the libmgba that run_trace.py already built (read-only)."""
    b = rt.CACHE / 'mgba'
    if not (b / 'libmgba.so.0.11.0').exists():
        sys.exit('libmgba is not built (%s); run tools/trace/run_trace.py once' % b)
    flags = (b / 'CMakeFiles' / 'mgba.dir' / 'flags.make').read_text()
    defs = re.search(r'^C_DEFINES = (.*)$', flags, re.M).group(1).split()
    defs = [d for d in defs if d not in ('-DMGBA_DLL', '-Dmgba_EXPORTS')]
    work.mkdir(parents=True, exist_ok=True)
    out = work / 'mgba_trace'
    stamp = work / 'mgba_trace.stamp'
    want = hashlib.sha256(TRACER_SRC.read_bytes() + ' '.join(defs).encode() + (b / 'libmgba.so.0.11.0').read_bytes()).hexdigest()
    if out.exists() and stamp.exists() and stamp.read_text() == want:
        return out
    M = rt.MGBA_SRC
    cmd = ['gcc', '-O2', '-fwrapv', '-Wall', '-Wno-unused-function'] + defs + [
        '-o', str(out), str(TRACER_SRC), '-I%s' % (M / 'include'), '-I%s' % (b / 'include'),
        '-I%s' % (M / 'src' / 'third-party' / 'libmobile'), '-I%s' % (b / 'libmobile'),
        '-L%s' % b, '-lmgba', '-Wl,-rpath,%s' % b]
    subprocess.run(cmd, check=True)
    stamp.write_text(want)
    return out


def web_dir(work: Path) -> Path:
    w = work / 'web'
    w.mkdir(parents=True, exist_ok=True)
    for f in sorted((ROOT / 'traces' / 'web').iterdir()):
        if f.suffix == '.html':
            t = f.read_text(encoding='utf-8')
            (w / f.name).write_bytes(t.replace('\r\n', '\n').encode('cp932'))
        elif f.suffix in ('.bmp', '.htm'):
            shutil.copy(f, w / f.name)
    return w


def web_args(mode: str, w: Path):
    if mode == 'all':
        a = []
        for f in sorted(w.iterdir()):
            if f.name not in ('index.html', 'page.html'):
                a += ['--web-map', '*/%s=%s' % (f.name, f)]
        a += ['--web-map', '*index.html=%s' % (w / 'index.html'), '--web-map', '*.html=%s' % (w / 'page.html')]
        return a
    return ['--web-map', '*index.html=%s' % (w / 'index.html'), '--web-map', '*.html=%s' % (w / 'page.html')]


def run_one(s, harness: Path, work: Path, wdir: Path):
    state = work / 'state'
    out = work / 'obs' / s.name
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)
    txt = ROOT / 'traces' / 'inputs' / (s.name + '.txt')
    if not txt.exists():
        raise SystemExit('missing recorded input %s (this tool only replays)' % txt)
    cmd = [str(harness), '--rom', str(rt.BASEROM), '--scenario', s.name, '--outdir', str(out), '--bank-obs',
           '--input', str(txt), '--frames', str(rt.last_frame(txt) + rt.TAIL_FRAMES), '--shots', str(out / 'shots')]
    if s.mobile == 'on':
        cmd += ['--mobile', 'on']
    elif s.mobile.startswith('at:'):
        cmd += ['--mobile-at', s.mobile[3:]]
    cmd += ['--net', s.net]
    if s.parent:
        cmd += ['--save-in', str(state / (s.parent + '.sav'))]
        if s.mobile != 'off':
            cmd += ['--mobile-config-in', str(state / (s.parent + '.cfg'))]
    cmd += ['--save-out', str(out / (s.name + '.sav'))]
    if s.mobile != 'off':
        cmd += ['--mobile-config-out', str(out / (s.name + '.cfg'))]
    cmd += s.args
    for kv in s.netopts:
        cmd += ['--net-opt', kv]
    for m in s.mails:
        cmd += ['--mail', str(ROOT / 'traces' / 'net' / m)]
    if s.web != '0':
        cmd += web_args(s.web, wdir)
    t0 = time.time()
    r = subprocess.run(cmd, capture_output=True, text=True)
    dt = time.time() - t0
    if r.returncode != 0:
        sys.stderr.write(r.stdout + r.stderr)
        raise SystemExit('scenario %s failed' % s.name)
    shutil.copy(out / (s.name + '.sav'), state / (s.name + '.sav'))
    if (out / (s.name + '.cfg')).exists():
        shutil.copy(out / (s.name + '.cfg'), state / (s.name + '.cfg'))
    shutil.rmtree(out / 'shots', ignore_errors=True)
    for f in out.iterdir():                                    # keep only the observation and stats, drop the big files
        if not (f.name.startswith('bankobs_') or f.name.startswith('coverage_') or f.name.startswith('stats_')):
            f.unlink()
    return dt


def is_forced(s):
    """Scenarios that force execution (poke RAM / call a routine directly, see `force`/`ramset` in mgba_trace.c) are never natural
    paths: their bank observations must not be mixed with the natural ones, so they are skipped."""
    if getattr(s, 'forced', False):
        return True
    txt = ROOT / 'traces' / 'inputs' / (s.name + '.txt')
    try:
        return any(re.match(r'^\d+\s+(force|ramset)\b', ln) for ln in txt.read_text().splitlines())
    except OSError:
        return False


def run_all(scens, harness, work, jobs):
    skipped = [s.name for s in scens if is_forced(s)]
    if skipped:
        print('skipping forced scenarios:', ' '.join(skipped))
    scens = [s for s in scens if not is_forced(s)]
    (work / 'state').mkdir(parents=True, exist_ok=True)
    wdir = web_dir(work)
    by = {s.name: s for s in scens}
    done, times = set(), {}
    pending = {s.name for s in scens}
    running = {}
    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as ex:
        while pending or running:
            for n in sorted(pending):
                s = by[n]
                if (s.parent is None or s.parent in done or s.parent not in by) and len(running) < jobs:
                    running[ex.submit(run_one, s, harness, work, wdir)] = n
                    pending.discard(n)
                    print('[run] %s' % n, flush=True)
            fin, _ = concurrent.futures.wait(list(running), return_when=concurrent.futures.FIRST_COMPLETED)
            for f in fin:
                n = running.pop(f)
                times[n] = f.result()
                done.add(n)
                print('[done] %s %.0fs' % (n, times[n]), flush=True)
    return times


def parse_stat(p: Path):
    d = {}
    for ln in p.read_text().splitlines():
        if '=' in ln:
            k, v = ln.split('=', 1)
            d[k] = v
    return d


def merge(work: Path, out: Path, times):
    agg = {}
    runs = []
    for d in sorted((work / 'obs').iterdir()):
        f = d / ('bankobs_%s.tsv' % d.name)
        if not f.exists():
            continue
        n = 0
        for ln in f.read_text().splitlines():
            if not ln or ln.startswith('#'):
                continue
            c = ln.split('\t')
            key = (c[0], int(c[1], 16))
            w, sm, en, j = int(c[2], 16), int(c[3], 16), int(c[4]), int(c[5], 16)
            a = agg.setdefault(key, [0, 0, 0, 0, 0])
            a[0] |= w
            a[1] |= sm
            a[2] |= en
            a[3] |= j
            a[4] += 1
            n += 1
        sf = d / ('stats_%s.txt' % d.name)
        st = parse_stat(sf) if sf.exists() else {}
        runs.append((d.name, st.get('frames', '?'), st.get('instructions', '?'), st.get('unique_instruction_starts', '?'),
                     ))
    out.mkdir(parents=True, exist_ok=True)
    with open(out / 'observed_banks.tsv', 'w') as fh:
        fh.write('# bank\taddr\twram_mask\tsram_mask\tsram_enabled\tjoint_mask\tnscen\n')
        fh.write('# Generated by tools/rambank_observe.py (do not edit).  One row per executed instruction start (ROM bank, or region name for RAM code),\n')
        fh.write('# ORed over every scenario of traces/scenarios.tsv replayed with the tracer option --bank-obs.\n')
        fh.write('# wram_mask (hex): bit n = effective WRAM bank n (rSVBK 0 counts as 1) was in force when the instruction started;\n')
        fh.write('# sram_mask (hex): bit n = RAMB value n; sram_enabled: 1 = only RAM-disabled seen, 2 = only RAM-enabled, 3 = both;\n')
        fh.write('# joint_mask (hex): bit (wram*4 + (sram&3)) = that pair together; nscen = scenarios in which the instruction executed.\n')
        fh.write('# Dynamic evidence of the replayed scenarios only: a missing row / a smaller mask than the truth proves nothing.\n')

        def order(k):
            b = k[0]
            return (0, int(b, 16), k[1]) if re.fullmatch(r'[0-9A-F]{2}', b) else (1, b, k[1])
        for k in sorted(agg, key=order):
            a = agg[k]
            fh.write('%s\t%04X\t%02X\t%04X\t%d\t%08X\t%d\n' % (k[0], k[1], a[0], a[1], a[2], a[3], a[4]))
    with open(out / 'observe_runs.tsv', 'w') as fh:
        fh.write('# scenario\tframes\tinstructions\tunique_instruction_starts\n')
        for r in runs:
            fh.write('\t'.join(r) + '\n')
    print('observed_banks.tsv: %d instruction starts from %d scenarios' % (len(agg), len(runs)))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--only', help='comma separated scenario names (their parents run too)')
    ap.add_argument('--jobs', type=int, default=8)
    ap.add_argument('--out', type=Path, default=DEFAULT_OUT)
    ap.add_argument('--work', type=Path, default=DEFAULT_WORK)
    ap.add_argument('--harness', type=Path)
    ap.add_argument('--merge-only', action='store_true')
    args = ap.parse_args()
    times = {}
    if not args.merge_only:
        scens = rt.order(rt.load_scenarios())
        if args.only:
            need = set()
            by = {s.name: s for s in scens}

            def add(n):
                if n not in need:
                    need.add(n)
                    if by[n].parent:
                        add(by[n].parent)
            for n in args.only.split(','):
                add(n)
            scens = [s for s in scens if s.name in need]
        if not rt.BASEROM.exists() or hashlib.sha256(rt.BASEROM.read_bytes()).hexdigest() != rt.ROM_SHA256:
            sys.exit('baserom.gbc missing or wrong hash')
        harness = args.harness or build_harness(args.work)
        times = run_all(scens, harness, args.work, args.jobs)
    merge(args.work, args.out, times)
    return 0


if __name__ == '__main__':
    sys.exit(main())
