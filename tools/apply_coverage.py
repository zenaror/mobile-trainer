#!/usr/bin/env python3
"""Cross-check the dynamic coverage union against config/regions and (optionally) promote fully executed code.

Inputs
  analysis/coverage_union.tsv   executed instruction starts (tools/trace/merge_coverage.py; ROM rows keyed by the bank that
                                was really mapped, plus WRAM/HRAM rows for code that runs from RAM)
  <config>/regions/bankNN.tsv   region tables (docs/FORMATS.md); conventions/xrefs of the same config dir are used so the
                                inline-data bytes after `call $06D1` & co. are NOT counted as instruction starts
  baserom.gbc                   read only (instruction decoding uses the generator's own scanner, tools/lib/conv.py)

What it reports (always; written to analysis/coverage_report.md, or --report FILE, or '-' for stdout only)
  A. per-bank counts: code bytes by status, instruction starts, executed instruction starts, fully executed regions
  B. executed instruction starts OUTSIDE code regions of the right bank ("outside-code list"): the executed byte lies in a
     data/text/gfx/words/ptrtable/zero/raw region (data-as-code or wrongly classified data), or inside a code region but
     not on the instruction boundaries of that region's decode ("misaligned": the region is decoded from a wrong start, or
     inline data/self-modifying code).  Consecutive addresses are merged into runs.
  C. code regions whose status is not CONFIRMED but whose every instruction start was executed (candidates for CONFIRMED)
  D. informational: CONFIRMED code regions with unexecuted instructions (confirmed by other evidence), ramcode regions vs
     executed WRAM/HRAM rows, never-executed code.
  E. executed rows of the union that no code region can explain: WRAM/HRAM rows (code that runs from RAM) not covered by a
     `ramcode` region, and rows of any other kind (VRAM/SRAM/OTHER or an unparsable bank), each with the config/ram symbol at
     that address when one exists.  These are reported, never rewritten.

--apply
  Rewrites ONLY the status column (-> CONFIRMED) and appends ' [executed in N scenarios]' to the note of the regions of
  list C, in the config dir given by --config-dir DIR (a COPY: the tool refuses when DIR is the repository's config dir,
  also through symlinks/relative paths) or, with --in-place, in <repo>/config itself.  Nothing else in any file changes
  (boundaries, kinds, labels, other lines are copied byte for byte).  A region is promoted ONLY when it is kind `code`,
  not CONFIRMED yet, its scan has no trouble (no instruction or inline-data run crossing the region end), EVERY
  instruction start of it (inline-data bytes of convention calls excluded) is an executed start of the union, and no
  executed address inside it lies off its instruction boundaries (such a region is listed as 'withheld' in section C):
  one unexecuted start keeps the whole region as it is.  N = the smallest number of scenarios in which any single instruction
  start of the region was executed.  The scenarios are NOT independent evidence (many start from the saved state of an
  earlier one and the monkey campaigns re-walk the same screens); N only says how often the same code was seen.  Regions
  that are already CONFIRMED are never touched (so a second --apply changes nothing).  ramcode regions are reported but
  never rewritten.

Without --apply the tool only reads (a dry run).  Nothing is written outside --report.

usage: apply_coverage.py [--union FILE] [--config-dir DIR] [--rom FILE] [--report FILE|-] [--apply] [--in-place] [--max-list N]
Exit status: 0 (a report, not a gate); 2 on usage/config errors.
"""
import argparse
import os
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import sm83  # noqa: E402
from lib import conv, mtcfg  # noqa: E402

BANK_SIZE = 0x4000
EXEC_SUFFIX = re.compile(r"\s*\[executed in \d+ scenarios?\]\s*$")
RAM_ROWS = ("WRAM", "HRAM")


def die(msg):
    sys.stderr.write("apply_coverage: %s\n" % msg)
    sys.exit(2)


# --------------------------------------------------------------------------------------------- load
def load_union(path):
    """-> ({(bank int, addr): (nscen, length)}, {(region, addr): nscen}, header lines)
    Also fills the module-level UNION_EXTRA = {"ramtext": {(region, addr): decoded text}, "other": [(bank, addr, nscen)]}."""
    rom, ram = {}, {}
    extra = {"ramtext": {}, "other": []}
    globals()["UNION_EXTRA"] = extra
    head = []
    for ln in Path(path).read_text().splitlines():
        if not ln:
            continue
        if ln.startswith("#"):
            head.append(ln)
            continue
        f = ln.split("\t")
        bank, addr, nsc = f[0], int(f[1], 16), int(f[3])
        if bank in RAM_ROWS:
            ram[(bank, addr)] = nsc
            extra["ramtext"][(bank, addr)] = f[8] if len(f) > 8 else "?"
        elif len(bank) == 2:
            try:
                ram_or_rom = int(bank, 16)
            except ValueError:
                extra["other"].append((bank, addr, nsc))
                continue
            rom[(ram_or_rom, addr)] = (nsc, int(f[6]) if f[6].isdigit() else 1)
        else:
            extra["other"].append((bank, addr, nsc))
    return rom, ram, head


def load_config(cfgdir, rom):
    diag = mtcfg.Diag(False)
    hw = mtcfg.load_hardware(None)
    nbanks = len(rom) // BANK_SIZE
    cfg = mtcfg.load_config(str(cfgdir), nbanks, hw, diag)
    if diag.errors:
        die("config errors in %s:\n  %s" % (cfgdir, "\n  ".join(diag.errors[:20])))
    branch = {(x.bank, x.addr): (x.tbank, x.taddr) for x in cfg.xrefs
              if x.kind == "branch" and isinstance(x.tbank, int)}
    table = conv.ConvTable(cfg.conventions, branch)
    return cfg, table


def region_starts(r, rom, table):
    """Instruction start addresses (CPU) of one code region, inline-convention bytes excluded.
    -> (starts list, inline byte set, note-string or None on trouble)"""
    chunk = rom[r.off:r.off + r.size]
    res = conv.scan(chunk, r.start, r.start, r.bank, "code", table)
    starts, inline = [], set()
    for store, it in res.items:
        if isinstance(it, conv.InlineData):
            inline.update(range(store, store + it.length))
        else:
            starts.append(store)
    trouble = None
    if res.cross:
        trouble = "instruction crosses the region end at %04X" % res.cross[0]
    elif res.overflow and res.overflow.have:
        trouble = "inline data of a convention call is cut by the region end (%d of %d bytes inside)" % (
            res.overflow.have, res.overflow.conv.size)
    # overflow.have == 0: the call ends exactly at the region end and its inline bytes sit in the following
    # data region (the generator's tolerated 'adopted' case): nothing to report, no instruction start is missed.
    return starts, inline, trouble


# ------------------------------------------------------------------------------------------ analysis
def analyse(cfg, table, rom, exec_rom, exec_ram):
    """Returns a dict with all report material."""
    R = {"banks": {}, "outside": [], "candidates": [], "confirmed_partial": [], "ramcode": [], "trouble": [], "unexecuted": [], "withheld": []}
    exec_by_bank = defaultdict(set)
    for (b, a) in exec_rom:
        exec_by_bank[b].add(a)
    for b in range(len(rom) // BANK_SIZE):
        regs = cfg.regions[b]
        st = {"code_bytes": 0, "code_by_status": defaultdict(int), "starts": 0, "executed_starts": 0,
              "code_regions": 0, "full_regions": 0, "candidate_regions": 0, "candidate_bytes": 0,
              "exec_total": len(exec_by_bank.get(b, ()))}
        covered_exec = set()                    # executed addresses explained by a code region start
        code_regions = []
        for r in regs:
            if r.kind != "code":
                continue
            starts, inline, trouble = region_starts(r, rom, table)
            if trouble:
                R["trouble"].append((b, r, trouble))
            sset = set(starts)
            ex = [a for a in starts if a in exec_by_bank.get(b, ())]
            covered_exec.update(ex)
            st["code_regions"] += 1
            st["code_bytes"] += r.size
            st["code_by_status"][r.status or "-"] += r.size
            st["starts"] += len(starts)
            st["executed_starts"] += len(ex)
            full = bool(starts) and len(ex) == len(starts)
            if full:
                st["full_regions"] += 1
            code_regions.append((r, sset, inline, starts, ex))
            if starts and len(ex) < len(starts):
                win = rom[b * BANK_SIZE:(b + 1) * BANK_SIZE]
                base = 0 if b == 0 else 0x4000
                ub = sum(sm83.decode(win, a - base, a).length for a in starts if a not in exec_by_bank.get(b, ()))
                R["unexecuted"].append((ub, b, r, len(starts) - len(ex), len(starts)))
            if full and r.status != "CONFIRMED" and not trouble:
                nmin = min(exec_rom[(b, a)][0] for a in starts)
                R["candidates"].append((b, r, len(starts), nmin))
                st["candidate_regions"] += 1
                st["candidate_bytes"] += r.size
            elif r.status == "CONFIRMED" and starts and not full:
                R["confirmed_partial"].append((b, r, len(starts), len(ex)))
        # executed addresses that are not instruction starts of any code region
        outs = sorted(a for a in exec_by_bank.get(b, ()) if a not in covered_exec)
        for a in outs:
            rr = mtcfg.region_at(regs, a)
            why = "outside code"
            if rr is not None and rr.kind == "code":
                inl = next((i2 for (r2, _s2, i2, _st, _ex) in code_regions if r2 is rr), set())
                why = "inline-data byte of a convention call" if a in inl else "inside code region, not an instruction boundary"
            R["outside"].append((b, a, rr, why))
        # a region contradicted by execution (an executed address inside it that is not one of its instruction starts) is
        # not promoted: its decode is not the decode the CPU followed
        if outs:
            keep = []
            for cand in R["candidates"]:
                if cand[0] == b and any(cand[1].start <= a < cand[1].end for a in outs):
                    R["withheld"].append((b, cand[1], "an executed address inside it is not an instruction start of its decode"))
                    st["candidate_regions"] -= 1
                    st["candidate_bytes"] -= cand[1].size
                else:
                    keep.append(cand)
            R["candidates"] = keep
        R["banks"][b] = st
    # ramcode regions vs executed WRAM/HRAM rows
    explained = set()
    for b in range(len(rom) // BANK_SIZE):
        for r in cfg.regions[b]:
            if r.kind != "ramcode" or r.runaddr is None:
                continue
            starts, _, _ = region_starts(r, rom, table)
            run = [r.runaddr + (a - r.start) for a in starts]
            ex = [a for a in run if (("HRAM" if a >= 0xFF80 else "WRAM"), a) in exec_ram]
            explained.update((("HRAM" if a >= 0xFF80 else "WRAM"), a) for a in run)
            R["ramcode"].append((b, r, len(run), len(ex)))
    extra = globals().get("UNION_EXTRA", {"ramtext": {}, "other": []})
    ramvars = sorted(cfg.ram, key=lambda v: v.addr)
    def ramsym(a):
        for v in ramvars:
            if v.addr <= a < v.addr + max(1, v.size):
                return "%s (%s)" % (v.name, v.status)
        return "no symbol in config/ram"
    R["ram_unexplained"] = [(reg, a, exec_ram[(reg, a)], extra["ramtext"].get((reg, a), "?"), ramsym(a))
                            for (reg, a) in sorted(exec_ram, key=lambda k: (k[0], k[1])) if (reg, a) not in explained]
    R["other_rows"] = list(extra["other"])
    return R


def runs(items):
    """merge consecutive addresses -> [(bank, start, end_inclusive, [entries])] (items = (bank, addr, region, why))"""
    out = []
    for it in items:
        b, a, rr, why = it
        if out and out[-1][0] == b and a - out[-1][2] <= 3 and out[-1][4] == (rr.idx if rr else None) and out[-1][5] == why:
            out[-1][2] = a
            out[-1][3] += 1
        else:
            out.append([b, a, a, 1, rr.idx if rr else None, why, rr])
    return out


# --------------------------------------------------------------------------------------------- report
def fmt_region(r):
    if r is None:
        return "no region"
    lab = r.label or "-"
    return "%s %04X-%04X %s %s [%s]" % (r.kind, r.start, r.end, lab, r.status or "-", r.note[:70].replace("|", "/"))


def write_report(R, union_head, union_n, args, cfgdir):
    L = []
    L.append("# Coverage vs region map report\n")
    L.append("Generated by `tools/apply_coverage.py` (do not edit; deterministic). Union: `%s` (%s). Config: `%s`." % (
        args.union_rel, union_head[0].lstrip("# ").split(":")[0] if union_head else "?", args.config_rel))
    L.append("Coverage is evidence that code exists and runs; absence proves nothing. Inline-data bytes of convention calls are not instruction starts.\n")
    tot = defaultdict(int)
    for b, st in R["banks"].items():
        for k in ("code_bytes", "starts", "executed_starts", "code_regions", "full_regions", "candidate_regions", "candidate_bytes", "exec_total"):
            tot[k] += st[k]
        for s, n in st["code_by_status"].items():
            tot["bytes_" + s] += n
    L.append("## Summary\n")
    L.append("* executed ROM instruction starts in the union: **%d**" % union_n)
    L.append("* code regions: %d, %d bytes (CONFIRMED %d, PROBABLE %d, HYPOTHESIS %d, other %d)" % (
        tot["code_regions"], tot["code_bytes"], tot["bytes_CONFIRMED"], tot["bytes_PROBABLE"], tot["bytes_HYPOTHESIS"],
        tot["code_bytes"] - tot["bytes_CONFIRMED"] - tot["bytes_PROBABLE"] - tot["bytes_HYPOTHESIS"]))
    L.append("* instruction starts inside code regions: %d, of which executed: %d" % (tot["starts"], tot["executed_starts"]))
    L.append("* code regions whose every instruction start was executed: %d" % tot["full_regions"])
    L.append("* **candidates for CONFIRMED** (not CONFIRMED yet, fully executed): %d regions, %d bytes" % (tot["candidate_regions"], tot["candidate_bytes"]))
    L.append("* executed instruction starts outside code regions / off instruction boundaries: **%d** in %d runs" % (
        len(R["outside"]), len(runs(R["outside"]))))
    L.append("* CONFIRMED code regions with unexecuted instructions (confirmed by other evidence): %d" % len(R["confirmed_partial"]))
    L.append("* executed WRAM/HRAM rows not explained by a ramcode region: %d; rows of other memory kinds: %d (section E)" % (
        len(R["ram_unexplained"]), len(R["other_rows"])))
    if R["trouble"]:
        L.append("* code regions whose scan had trouble (crossing / overflow): %d (listed below)" % len(R["trouble"]))
    L.append("")
    L.append("## A. Per bank\n")
    L.append("| bank | code bytes | CONFIRMED | PROBABLE | HYPOTH. | insn starts | executed | full regions | candidates (regions/bytes) | executed outside code |")
    L.append("|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
    outb = defaultdict(int)
    for (b, a, rr, why) in R["outside"]:
        outb[b] += 1
    for b in sorted(R["banks"]):
        st = R["banks"][b]
        if not (st["code_bytes"] or st["exec_total"]):
            continue
        cs = st["code_by_status"]
        L.append("| %02X | %d | %d | %d | %d | %d | %d | %d/%d | %d/%d | %d |" % (
            b, st["code_bytes"], cs.get("CONFIRMED", 0), cs.get("PROBABLE", 0), cs.get("HYPOTHESIS", 0), st["starts"],
            st["executed_starts"], st["full_regions"], st["code_regions"], st["candidate_regions"], st["candidate_bytes"], outb.get(b, 0)))
    L.append("")
    L.append("## B. Executed instruction starts outside code regions (or off instruction boundaries)\n")
    rs = runs(R["outside"])
    if not rs:
        L.append("None: every executed ROM instruction start is an instruction start of a `code` region of the bank that was mapped.\n")
    else:
        L.append("Each row: bank:first-last (n starts), the reason, the region that holds the first address. A row here means either data classified "
                 "as data/unclassified but executed (reclassify as code), or a code region decoded from the wrong start.\n")
        L.append("| where | starts | reason | region |")
        L.append("|---|---:|---|---|")
        for (b, a0, a1, n, _, why, rr) in rs[:args.max_list]:
            L.append("| %02X:%04X-%04X | %d | %s | %s |" % (b, a0, a1, n, why, fmt_region(rr)))
        if len(rs) > args.max_list:
            L.append("| ... | | | %d more runs |" % (len(rs) - args.max_list))
        L.append("")
    L.append("## C. Code regions not CONFIRMED whose every instruction start was executed\n")
    if not R["candidates"]:
        L.append("None.\n")
    else:
        L.append("| region | bytes | insns | status now | min scenarios per insn | note (start) |")
        L.append("|---|---:|---:|---|---:|---|")
        for (b, r, n, nmin) in R["candidates"][:args.max_list]:
            L.append("| %02X:%04X-%04X %s | %d | %d | %s | %d | %s |" % (b, r.start, r.end, r.label or "-", r.size, n, r.status or "-", nmin, r.note[:60].replace("|", "/")))
        if len(R["candidates"]) > args.max_list:
            L.append("| ... | | | | | %d more |" % (len(R["candidates"]) - args.max_list))
        L.append("")
    if R["withheld"]:
        L.append("Fully executed regions withheld from promotion (%d):\n" % len(R["withheld"]))
        for (b, r, why) in R["withheld"]:
            L.append("* %02X:%04X-%04X %s: %s" % (b, r.start, r.end, r.label or "-", why))
        L.append("")
    L.append("## D. Informational\n")
    L.append("### D1. CONFIRMED code regions with unexecuted instructions (%d)\n" % len(R["confirmed_partial"]))
    L.append("These are CONFIRMED by other evidence (byte-exact match, documented code, ...) and are not touched by --apply.\n")
    for (b, r, n, e) in R["confirmed_partial"][:args.max_list]:
        L.append("* %02X:%04X-%04X %s: %d/%d instruction starts executed" % (b, r.start, r.end, r.label or "-", e, n))
    if len(R["confirmed_partial"]) > args.max_list:
        L.append("* ... %d more" % (len(R["confirmed_partial"]) - args.max_list))
    L.append("")
    L.append("### D2. ramcode regions (executed at their run address; never rewritten by --apply)\n")
    for (b, r, n, e) in R["ramcode"]:
        L.append("* %02X:%04X-%04X %s runaddr=$%04X status %s: %d/%d instruction starts seen executing in WRAM/HRAM rows" % (
            b, r.start, r.end, r.label or "-", r.runaddr, r.status or "-", e, n))
    if not R["ramcode"]:
        L.append("* none")
    L.append("")
    ub = sum(x[0] for x in R["unexecuted"])
    L.append("### D4. Never-executed code (instruction bytes of unexecuted instruction starts inside code regions: %d)\n" % ub)
    L.append("Per bank (bytes): " + ", ".join("%02X:%d" % (b, n) for b, n in sorted(((b, sum(x[0] for x in R["unexecuted"] if x[1] == b)) for b in {x[1] for x in R["unexecuted"]}), key=lambda t: -t[1])[:30]) + "\n")
    L.append("Largest regions with unexecuted instructions:\n")
    L.append("| region | status | unexecuted bytes | unexecuted / total insns | note (start) |")
    L.append("|---|---|---:|---:|---|")
    for (nb, b, r, nu, nt) in sorted(R["unexecuted"], key=lambda x: (-x[0], x[1], x[2].start))[:40]:
        L.append("| %02X:%04X-%04X %s | %s | %d | %d/%d | %s |" % (b, r.start, r.end, r.label or "-", r.status or "-", nb, nu, nt, r.note[:70].replace("|", "/")))
    L.append("")
    if R["trouble"]:
        L.append("### D3. code regions with scan trouble (never promoted by --apply)\n")
        for (b, r, t) in R["trouble"]:
            L.append("* %02X:%04X-%04X %s: %s" % (b, r.start, r.end, r.label or "-", t))
        L.append("")
    L.append("## E. Executed rows that no code region explains\n")
    L.append("Code that runs from RAM (written there at run time, so the ROM bytes of the copy are not the executed bytes) and rows of any other memory kind. "
             "Only `ramcode` regions with a `runaddr=` explain a RAM row; the decode column is the instruction seen at first execution.\n")
    if R["ram_unexplained"]:
        L.append("| area | addr | scenarios | decode (first execution) | config/ram symbol |")
        L.append("|---|---|---:|---|---|")
        for (reg, a, n, txt, sym) in R["ram_unexplained"]:
            L.append("| %s | %04X | %d | `%s` | %s |" % (reg, a, n, txt, sym))
    else:
        L.append("No unexplained WRAM/HRAM rows.")
    L.append("")
    if R["other_rows"]:
        L.append("Rows of another kind (VRAM/SRAM/OTHER/unparsable bank): %d, first: %s" % (
            len(R["other_rows"]), ", ".join("%s:%04X" % (b, a) for (b, a, n) in R["other_rows"][:20])))
    else:
        L.append("Rows of another kind (VRAM/SRAM/OTHER/unparsable bank): none.")
    L.append("")
    return "\n".join(L) + "\n"


# --------------------------------------------------------------------------------------------- apply
def apply_changes(R, cfgdir):
    """Rewrite status/note of the candidate regions in <cfgdir>/regions/bankNN.tsv. -> number of regions changed"""
    by_bank = defaultdict(dict)
    for (b, r, n, nmin) in R["candidates"]:
        by_bank[b][(r.start, r.end)] = nmin
    changed = 0
    for b, want in sorted(by_bank.items()):
        path = Path(cfgdir) / "regions" / ("bank%02X.tsv" % b)
        if not path.exists():
            path = Path(cfgdir) / "regions" / ("bank%02x.tsv" % b)
        data = path.read_bytes().decode("utf-8")
        out = []
        left = dict(want)
        for ln in data.splitlines(True):
            body = ln.rstrip("\r\n")
            eol = ln[len(body):]
            s = body.strip()
            if not s or s.startswith("#"):
                out.append(ln)
                continue
            f = body.split("\t")
            try:
                key = (mtcfg.parse_hex(f[0]), mtcfg.parse_hex(f[1]))
            except (ValueError, IndexError):
                out.append(ln)
                continue
            if key in left and len(f) >= 5 and f[2].strip() == "code":
                nmin = left.pop(key)
                f[4] = "CONFIRMED"
                suffix = " [executed in %d scenarios]" % nmin
                if len(f) < 6:
                    f.append(suffix.strip())
                else:
                    f[-1] = EXEC_SUFFIX.sub("", f[-1]) + suffix
                out.append("\t".join(f) + eol)
                changed += 1
            else:
                out.append(ln)
        if left:
            die("bank %02X: could not find region line(s) %s for rewriting" % (b, ", ".join("%04X-%04X" % k for k in left)))
        path.write_bytes("".join(out).encode("utf-8"))
    return changed


# ------------------------------------------------------------------------------------------------ main
def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--union", default=str(ROOT / "analysis" / "coverage_union.tsv"))
    ap.add_argument("--config-dir", default=None, help="config dir to read (default: repo config, read only) and, with --apply, to rewrite (must be a copy)")
    ap.add_argument("--rom", default=str(ROOT / "baserom.gbc"))
    ap.add_argument("--report", default=str(ROOT / "analysis" / "coverage_report.md"), help="report file, '-' = stdout only")
    ap.add_argument("--apply", action="store_true", help="rewrite status/note of the candidate regions (see --help)")
    ap.add_argument("--in-place", action="store_true", help="allow --apply on the repository's own config/regions")
    ap.add_argument("--max-list", type=int, default=400)
    a = ap.parse_args(argv)

    real_cfg = (ROOT / "config").resolve()
    cfgdir = Path(a.config_dir).resolve() if a.config_dir else real_cfg
    if a.apply:
        if cfgdir == real_cfg and not a.in_place:
            die("refusing to rewrite the repository's config/regions without --in-place (use --config-dir DIR with a copy)")
        if a.in_place and cfgdir != real_cfg:
            die("--in-place applies to the repository config; do not combine it with --config-dir")
    if not (cfgdir / "regions").is_dir():
        die("no regions dir in %s" % cfgdir)
    rom = Path(a.rom).read_bytes()
    if len(rom) % BANK_SIZE:
        die("ROM size is not a multiple of 16 KiB")
    exec_rom, exec_ram, head = load_union(a.union)
    cfg, table = load_config(cfgdir, rom)
    R = analyse(cfg, table, rom, exec_rom, exec_ram)

    try:
        a.union_rel = str(Path(a.union).resolve().relative_to(ROOT))
    except ValueError:
        a.union_rel = Path(a.union).name
    a.config_rel = "config" if cfgdir == real_cfg else "a copy of config (%s)" % cfgdir.name
    text = write_report(R, head, len(exec_rom), a, cfgdir)
    if a.report == "-":
        sys.stdout.write(text)
    else:
        Path(a.report).parent.mkdir(parents=True, exist_ok=True)
        Path(a.report).write_text(text)
    nb = sum(1 for _ in R["candidates"])
    print("union rows (ROM): %d; candidates for CONFIRMED: %d regions; executed outside code: %d starts in %d runs; report: %s" % (
        len(exec_rom), nb, len(R["outside"]), len(runs(R["outside"])), "stdout" if a.report == "-" else a.report))
    if a.apply:
        n = apply_changes(R, cfgdir)
        print("applied: %d region(s) rewritten in %s/regions" % (n, cfgdir))
    return 0


if __name__ == "__main__":
    sys.exit(main())
