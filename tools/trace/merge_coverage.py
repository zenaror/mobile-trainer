#!/usr/bin/env python3
"""Union the per-scenario coverage files and validate them against the SM83 decoder.

Inputs : traces/coverage_<scenario>.tsv          (from tools/trace/run_trace.py)
         traces/detail/<scenario>/ramcode.tsv    (distinct byte windows seen at executed RAM addresses)
         baserom.gbc                              (read only)
Outputs: analysis/coverage_union.tsv             one row per executed instruction start (first_scenario = index into the scenario list of the first header line)
         traces/coverage_validation.txt          human readable list of inconsistencies / warnings

usage: merge_coverage.py [--traces DIR] [--rom FILE] [--out FILE] [--quiet]

Validation ("does the executed set look like real instructions?"), using tools/sm83.py on the ROM bytes of the
bank that was mapped when the address executed:
  ERROR  ILLEGAL     the opcode at an executed address is one of the 11 illegal SM83 opcodes (data-as-code or bank bug)
  ERROR  OVERLAP     another executed address lies strictly inside the bytes of this instruction
                     (two executions disagree on where instructions start: data-as-code, jump into an operand,
                      self-modifying/relocated code, or a bank-mapping bug in the tracer)
  ERROR  CROSSBANK   the instruction's bytes run past the end of its bank window
  ERROR  BADADDR     address outside the window of its bank (bank 0 must be 0000-3FFF, others 4000-7FFF)
  INFO   COND_ALWAYS_TAKEN  a conditional jp/jr/ret that was executed but never fell through (so the branch was taken
                     every time in the traced runs; says nothing about the other path)
  WARN   FALL_MISSING a sequential/call/halt/stop instruction whose fall-through address was never executed
                     (expected for: last instruction of the run, calls that never return, halt/stop; suspicious otherwise)
  WARN   TARGET_MISSING an unconditional jp/jr/call/rst executed, but its static target was never executed in any bank
RAM rows are decoded from the 3 bytes recorded at first execution (plus every variant in ramcode.tsv).
Flags are written into the 'flags' column of the union file. Exit status 0 always (this is a report, not a gate);
use --strict to exit 1 when any ERROR is present.
"""
import argparse
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
import sm83  # noqa: E402

TRACES = ROOT / "traces"
TERMINATING = {"jp", "jr", "ret", "jphl", "bad"}


def read_cov(path):
    rows = []
    for ln in path.read_text().splitlines():
        if not ln or ln.startswith("#"):
            continue
        f = ln.split("\t")
        rows.append(f)
    return rows


def load(traces):
    """-> {(bank, addr): [total_count, [scenarios], first_scenario, first_frame, first_bytes, wram_bank]}"""
    cov = {}
    scen_names = []
    for p in sorted(traces.glob("coverage_*.tsv")):
        s = p.stem[len("coverage_"):]
        scen_names.append(s)
        for f in read_cov(p):
            bank, addr, cnt, ff = f[0], int(f[1], 16), int(f[2]), int(f[3])
            fb = f[4] if len(f) > 4 else "-"
            wb = f[6] if len(f) > 6 else "-"
            k = (bank, addr)
            e = cov.get(k)
            if e is None:
                cov[k] = [cnt, [s], s, ff, fb, wb]
            else:
                e[0] += cnt
                e[1].append(s)
    return cov, scen_names


def ram_variants(traces):
    var = defaultdict(set)
    for d in sorted((traces / "detail").glob("*")):
        p = d / "ramcode.tsv"
        if not p.exists():
            continue
        for f in read_cov(p):
            region, addr, wb, by = f[0], int(f[1], 16), f[2], f[3]
            var[(region, addr)].add(by)
    return var


def rom_window(rom, bank):
    return rom[bank * 0x4000:(bank + 1) * 0x4000]


def validate(cov, rom, ramvar):
    """-> ({key: flags list}, {key: (len, flow, text)}, stats)"""
    flags = defaultdict(list)
    info = {}
    romkeys = defaultdict(set)     # bank -> set(addr)
    for (bank, addr) in cov:
        if len(bank) == 2 and all(c in "0123456789ABCDEF" for c in bank):
            romkeys[int(bank, 16)].add(addr)
    ram_by_region = defaultdict(set)
    for (bank, addr) in cov:
        if bank in ("WRAM", "HRAM", "VRAM", "SRAM", "OTHER"):
            ram_by_region[bank].add(addr)
    anywhere = set()
    for b, s in romkeys.items():
        anywhere |= {(b, a) for a in s}
    exec_addr_any_bank = defaultdict(set)   # addr -> banks
    for b, s in romkeys.items():
        for a in s:
            exec_addr_any_bank[a].add(b)

    def check(key, ins, addrset, base, end, region_is_rom, bank_num=None):
        L = ins.length
        a = key[1]
        if ins.flow == "bad":
            flags[key].append("ILLEGAL")
        if a + L > end:
            flags[key].append("CROSSBANK")
        for j in range(1, L):
            if (a + j) in addrset:
                flags[key].append("OVERLAP@%04X" % (a + j))
                break
        nxt = a + L
        if ins.flow not in TERMINATING:
            if nxt not in addrset:
                if ins.flow in ("call", "callcc", "rst"):
                    flags[key].append("FALL_MISSING(call)")
                elif ins.flow in ("halt", "stop"):
                    flags[key].append("FALL_MISSING(%s)" % ins.flow)
                elif ins.flow in ("jpcc", "jrcc", "retcc"):
                    flags[key].append("COND_ALWAYS_TAKEN")
                else:
                    flags[key].append("FALL_MISSING")
        if ins.flow in ("jp", "jr", "call", "rst") and ins.target is not None:
            t = ins.target
            if t >= 0x8000:
                ok = True                       # target in RAM/IO: not checked here
            elif t < 0x4000:
                ok = t in romkeys.get(0, ())
            else:
                ok = t in exec_addr_any_bank
            if not ok:
                flags[key].append("TARGET_MISSING(%04X)" % t)

    stats = defaultdict(int)
    for b in sorted(romkeys):
        win = rom_window(rom, b)
        lo = 0x0000 if b == 0 else 0x4000
        hi = lo + 0x4000
        addrs = romkeys[b]
        for a in sorted(addrs):
            key = (("%02X" % b), a)
            if a < lo or a >= hi:
                flags[key].append("BADADDR")
                continue
            ins = sm83.decode(win, a - lo, a)
            info[key] = (ins.length, ins.flow, ins.text(), ins.target)
            check(key, ins, addrs, lo, hi, True, b)
    for region, addrs in ram_by_region.items():
        for a in sorted(addrs):
            key = (region, a)
            variants = ramvar.get((region, a)) or {cov[key][4]}
            for v in sorted(variants):
                try:
                    raw = bytes.fromhex(v)
                except ValueError:
                    continue
                if len(raw) < 3:
                    raw = raw + b"\x00" * (3 - len(raw))
                ins = sm83.decode(raw, 0, a)
                if key not in info:
                    info[key] = (ins.length, ins.flow, ins.text(), ins.target)
                check(key, ins, addrs, 0, 0x10000, False)
    for k, fl in flags.items():
        for x in fl:
            stats[x.split("@")[0].split("(")[0]] += 1
    return flags, info, stats


def forced_union(traces, rom, natural):
    """FORCED scenarios (traces/forced/coverage_*.tsv, macro directives force/ramset): kept apart from the natural union.
    -> (rows [(key, count, [scenarios], first_scenario, first_frame, (len, flow, text), key in natural)], scenario names)"""
    fdir = traces / "forced"
    if not fdir.is_dir():
        return [], []
    cov, scen = load(fdir)
    rows = []
    for k in sorted(cov, key=lambda k: (0, int(k[0], 16), k[1]) if len(k[0]) == 2 and k[0] not in ("WRAM", "HRAM") else (1, k[0], k[1])):
        e = cov[k]
        if len(k[0]) == 2 and k[0] not in ("WRAM", "HRAM"):
            b = int(k[0], 16)
            lo = 0 if b == 0 else 0x4000
            ins = sm83.decode(rom_window(rom, b), k[1] - lo, k[1])
            desc = (ins.length, ins.flow, ins.text())
        else:
            desc = ("?", "?", "?")
        rows.append((k, e[0], e[1], e[2], e[3], desc, k in natural))
    return rows, scen


def union_stats(traces=TRACES):
    cov, _ = load(traces)
    banks = set()
    rom = ram = 0
    for (bank, addr) in cov:
        if bank in ("WRAM", "HRAM", "VRAM", "SRAM", "OTHER"):
            ram += 1
        else:
            rom += 1
            banks.add(int(bank, 16))
    return {"rom_addrs": rom, "ram_addrs": ram, "banks": banks}


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--traces", default=str(TRACES))
    ap.add_argument("--rom", default=str(ROOT / "baserom.gbc"))
    ap.add_argument("--out", default=str(ROOT / "analysis" / "coverage_union.tsv"))
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--quiet", action="store_true")
    a = ap.parse_args(argv)
    traces = Path(a.traces)
    rom = Path(a.rom).read_bytes()
    cov, scen = load(traces)
    if not cov:
        sys.exit("no coverage_*.tsv in %s" % traces)
    ramvar = ram_variants(traces)
    flags, info, stats = validate(cov, rom, ramvar)

    def sortkey(k):
        b = k[0]
        return (0, int(b, 16), k[1]) if len(b) == 2 and b[0] in "0123456789ABCDEF" and b not in ("WRAM", "HRAM") else (1, b, k[1])

    keys = sorted(cov, key=sortkey)
    sidx = {n: i for i, n in enumerate(scen)}       # first_scenario is written as this index (keeps the file below 4 MB)
    out = Path(a.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    nerr = sum(v for k, v in stats.items() if k in ("ILLEGAL", "OVERLAP", "CROSSBANK", "BADADDR"))
    nwarn = sum(v for k, v in stats.items() if k in ("FALL_MISSING", "TARGET_MISSING"))
    ninfo = stats.get("COND_ALWAYS_TAKEN", 0)
    with open(out, "w") as f:
        f.write("# Union of executed instruction starts over %d scenarios (index = value of the first_scenario column): %s\n" % (
            len(scen), " ".join("%d=%s" % (i, n) for i, n in enumerate(scen))))
        f.write("# generated by tools/trace/merge_coverage.py from traces/coverage_*.tsv - do not edit. Coverage is evidence of code;\n")
        f.write("# absence proves nothing. bank = ROM bank actually mapped when executed, or WRAM/HRAM (code copied to RAM).\n")
        f.write("# validation: %d ERROR flags (%s), %d WARN flags (%s), %d INFO (COND_ALWAYS_TAKEN); see traces/coverage_validation.txt\n" % (
            nerr, ", ".join("%s=%d" % (k, v) for k, v in sorted(stats.items()) if k in ("ILLEGAL", "OVERLAP", "CROSSBANK", "BADADDR")) or "none",
            nwarn, ", ".join("%s=%d" % (k, v) for k, v in sorted(stats.items()) if k in ("FALL_MISSING", "TARGET_MISSING")) or "none", ninfo))
        f.write("# bank\taddr\tcount\tscenarios\tfirst_scenario\tfirst_frame\tlen\tflow\tinsn\tflags\n")
        for k in keys:
            e = cov[k]
            ln, flow, text = info.get(k, ("?", "?", "?", None))[:3]
            f.write("%s\t%04X\t%d\t%d\t%d\t%d\t%s\t%s\t%s\t%s\n" % (
                k[0], k[1], e[0], len(e[1]), sidx[e[2]], e[3], ln, flow, text, ",".join(flags.get(k, [])) or "-"))
    frows, fscen = forced_union(traces, rom, cov)
    fout = Path(a.out).parent / "coverage_forced.tsv"
    if frows:
        with open(fout, "w") as f:
            f.write("# FORCED coverage (NOT part of coverage_union.tsv, never used to promote code to CONFIRMED): scenarios that jump into code with the\n")
            f.write("# harness directives `force BB:AAAA` / `ramset` (tools/trace/mgba_trace.c) because no natural path reaches it. Union over %d scenarios: %s\n" % (len(fscen), " ".join(fscen)))
            nnat = sum(1 for r in frows if r[6])
            f.write("# generated by tools/trace/merge_coverage.py from traces/forced/coverage_*.tsv - do not edit. Only addresses that NO natural scenario executed are listed\n")
            f.write("# (%d further addresses of the forced runs are also in coverage_union.tsv and are omitted); the forced runs executed %d addresses in all.\n" % (nnat, len(frows)))
            f.write("# bank\taddr\tcount\tscenarios\tfirst_scenario\tfirst_frame\tlen\tflow\tinsn\n")
            for (k, cnt, sc, first, ff, (ln, flow, text), nat) in frows:
                if not nat:
                    f.write("%s\t%04X\t%d\t%d\t%s\t%d\t%s\t%s\t%s\n" % (k[0], k[1], cnt, len(sc), first, ff, ln, flow, text))
    elif fout.exists():
        fout.unlink()
    rep = traces / "coverage_validation.txt"
    with open(rep, "w") as f:
        f.write("# Coverage validation report (tools/trace/merge_coverage.py)\n")
        f.write("# %d unique executed instruction starts from %d scenarios\n" % (len(cov), len(scen)))
        f.write("# ERROR = inconsistent with the SM83 decoding chain, WARN = expected in some situations, see the tool's --help\n\n")
        f.write("## counts\n")
        for k, v in sorted(stats.items()):
            f.write("%-16s %d\n" % (k, v))
        if not stats:
            f.write("(none: every executed address decodes as an instruction start consistent with all others)\n")
        f.write("\n## ERRORs\n")
        for k in keys:
            fl = [x for x in flags.get(k, []) if x.split("@")[0] in ("ILLEGAL", "OVERLAP", "CROSSBANK", "BADADDR")]
            if fl:
                ln, flow, text = info.get(k, ("?", "?", "?", None))[:3]
                f.write("%s:%04X  %-28s %s  [%s]\n" % (k[0], k[1], text, " ".join(fl), ",".join(cov[k][1][:4])))
        f.write("\n## WARN / INFO (grouped; at most 200 addresses listed per group)\n")
        grp = defaultdict(list)
        for k in keys:
            for x in flags.get(k, []):
                base = x.split("@")[0]
                if base.startswith(("FALL_MISSING", "TARGET_MISSING", "COND_ALWAYS_TAKEN")):
                    name = base.split("(")[0] + ("(" + base.split("(")[1] if "(" in base and base.startswith("FALL") else "")
                    grp[name].append(k)
        callees = defaultdict(int)
        for k in grp.get("FALL_MISSING(call)", []):
            t = info.get(k, (0, 0, 0, None))[3]
            callees[t] += 1
        if callees:
            f.write("\n### FALL_MISSING(call) grouped by callee (a callee that pops its return address, e.g. to read inline\n")
            f.write("### argument bytes placed after the call, makes every call site show up here)\n")
            for t, c in sorted(callees.items(), key=lambda x: -x[1])[:25]:
                f.write("callee %s : %d call sites\n" % ("%04X" % t if t is not None else "?", c))
        for g, ks in sorted(grp.items()):
            f.write("\n### %s : %d\n" % (g, len(ks)))
            for k in ks[:200]:
                ln, flow, text = info.get(k, ("?", "?", "?", None))[:3]
                f.write("%s:%04X  %s\n" % (k[0], k[1], text))
            if len(ks) > 200:
                f.write("... %d more\n" % (len(ks) - 200))
    if not a.quiet:
        print("union: %d executed instruction starts (%d ROM in %d banks, %d RAM); %d ERROR flags, %d WARN flags, %d INFO -> %s" % (
            len(cov), sum(1 for k in cov if len(k[0]) == 2 and k[0] not in ('WRAM', 'HRAM')),
            len({k[0] for k in cov if len(k[0]) == 2 and k[0] not in ('WRAM', 'HRAM')}),
            sum(1 for k in cov if k[0] in ("WRAM", "HRAM")), nerr, nwarn, ninfo, out))
    return 1 if (a.strict and nerr) else 0


if __name__ == "__main__":
    sys.exit(main())
