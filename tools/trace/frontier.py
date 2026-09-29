#!/usr/bin/env python3
"""Coverage frontier: which never-executed code hangs behind which executed branch/call ("gate")?

Reads analysis/coverage_union.tsv (executed instruction starts) and config/regions (+ conventions/xrefs of the same config), builds the
static control-flow graph over the instruction starts of all `code` regions (fall-through, jp/jr/call/rst targets, the inline far
pointers of convention calls such as `call $06D1 ; dw target ; db bank`, and the inline jump tables after `call $0545`/`call $056A`),
and for every executed instruction with a successor that was never executed (the gate) computes the unexecuted code reachable from
that successor without passing through executed code.  A greedy set cover then ranks the gates by the number of *new* code bytes
each one would open, which is the list to work down when designing scenarios (tools/trace/README.md, docs/research/dynamic_tracing.md
section 9).  Purely static and deterministic; it says what the map claims is reachable, not that a run can get there.

usage: frontier.py [--config-dir DIR] [--top N] [--out FILE] [--per-bank]
"""
import argparse
import sys
from collections import defaultdict, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
import apply_coverage as ac  # noqa: E402
import sm83  # noqa: E402
from lib import conv, mtcfg  # noqa: E402

TABLE_CALLEES = {(0, 0x0545), (0, 0x056A)}


def build(cfg, table, rom):
    """-> (nodes {(bank, addr): length}, succ {(bank, addr): [(bank, addr, kind)]})"""
    nodes = {}
    succ = defaultdict(list)
    items_by_region = {}
    for b in range(len(rom) // ac.BANK_SIZE):
        for r in cfg.regions[b]:
            if r.kind != "code":
                continue
            res = conv.scan(rom[r.off:r.off + r.size], r.start, r.start, b, "code", table)
            items_by_region[(b, r.start)] = (r, res.items)
            for st, it in res.items:
                if not isinstance(it, conv.InlineData):
                    nodes[(b, st)] = it.length

    def tgt(b, t):
        if t < 0x4000:
            return (0, t)
        if t < 0x8000 and b != 0:
            return (b, t)
        return None

    for (b, _), (r, items) in items_by_region.items():
        for i, (st, it) in enumerate(items):
            if isinstance(it, conv.InlineData):
                continue
            u = (b, st)
            nxt = None
            j = i + 1
            inl = None
            if j < len(items):
                if isinstance(items[j][1], conv.InlineData):
                    inl = items[j][1]
                    j += 1
                if j < len(items):
                    nxt = (b, items[j][0])
            fl = it.flow
            if fl in ("seq", "jrcc", "jpcc", "callcc", "retcc", "call", "rst", "halt", "stop") and nxt is not None:
                succ[u].append((nxt[0], nxt[1], "fall"))
            if it.target is not None and fl in ("jp", "jpcc", "jr", "jrcc", "call", "callcc", "rst"):
                t = tgt(b, it.target)
                if t is not None:
                    succ[u].append((t[0], t[1], "branch" if fl != "call" else "call"))
            if inl is not None and inl.conv.layout == "farptr":
                w = inl.word
                bk = inl.raw[2]
                succ[u].append((bk if w >= 0x4000 else 0, w, "far"))
            # inline jump table words after call $0545 / $056A
            if fl == "call" and it.target is not None and (0, it.target) in TABLE_CALLEES and it.target < 0x4000:
                after = st + it.length
                tr = mtcfg.region_at(cfg.regions[b], after)
                if tr is not None and tr.kind == "ptrtable" and tr.start == after:
                    for k in range(0, tr.size, 2):
                        w = rom[tr.off + k] | (rom[tr.off + k + 1] << 8)
                        t = tgt(b, w)
                        if t is not None:
                            succ[u].append((t[0], t[1], "table"))
    return nodes, succ


def rank(nodes, succ, executed, top):
    U = {n for n in nodes if n not in executed}
    gates = defaultdict(list)          # (from, kind) -> [targets in U]
    for u, es in succ.items():
        if u in executed:
            for (b, a, kind) in es:
                if (b, a) in U:
                    gates[(u, kind)].append((b, a))
    reach = {}
    for g, tg in gates.items():
        seen = set()
        dq = deque(tg)
        while dq:
            v = dq.popleft()
            if v in seen or v not in U:
                continue
            seen.add(v)
            for (b, a, _k) in succ.get(v, ()):
                if (b, a) in U and (b, a) not in seen:
                    dq.append((b, a))
        reach[g] = seen
    covered = set()
    out = []
    remaining = dict(reach)
    while remaining and len(out) < top:
        best, bestn = None, 0
        for g, s in remaining.items():
            n = sum(nodes[x] for x in s if x not in covered)
            if n > bestn or (n == bestn and best is not None and g < best):
                best, bestn = g, n
        if best is None or bestn == 0:
            break
        s = remaining.pop(best)
        newset = {x for x in s if x not in covered}
        covered |= newset
        out.append((best, bestn, len(newset), newset, len(s)))
    total_u = sum(nodes[n] for n in U)
    reachable = set()
    for s in reach.values():
        reachable |= s
    return out, total_u, sum(nodes[n] for n in reachable), len(gates)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--union", default=str(ROOT / "analysis" / "coverage_union.tsv"))
    ap.add_argument("--config-dir", default=str(ROOT / "config"))
    ap.add_argument("--rom", default=str(ROOT / "baserom.gbc"))
    ap.add_argument("--top", type=int, default=40)
    ap.add_argument("--out", default="-")
    a = ap.parse_args(argv)
    rom = Path(a.rom).read_bytes()
    exec_rom, _ram, _h = ac.load_union(a.union)
    cfg, table = ac.load_config(Path(a.config_dir), rom)
    nodes, succ = build(cfg, table, rom)
    executed = set(exec_rom)
    out, total_u, reachable_b, ngates = rank(nodes, succ, executed, a.top)
    L = ["# Coverage frontier (tools/trace/frontier.py)", ""]
    L.append("* instruction starts in code regions: %d; executed: %d; unexecuted code bytes: %d; of these reachable from an executed gate: %d (%d gates)" % (
        len(nodes), len(executed & set(nodes)), total_u, reachable_b, ngates))
    L.append("* greedy ranking: each row opens the most code bytes not opened by the rows above it")
    L.append("")
    L.append("| # | gate (executed insn) | kind | insn | runs in scenarios | new bytes | new insns | banks of the new code |")
    L.append("|---:|---|---|---|---:|---:|---:|---|")
    u_info = {}
    for line in Path(a.union).read_text().splitlines():
        if line.startswith("#"):
            continue
        f = line.split("\t")
        if len(f[0]) == 2 and f[0] not in ("WRAM", "HRAM"):
            u_info[(int(f[0], 16), int(f[1], 16))] = (int(f[3]), f[8])
    for i, ((u, kind), nb, ni, newset, _full) in enumerate(out, 1):
        banks = defaultdict(int)
        for (b, aa) in newset:
            banks[b] += nodes[(b, aa)]
        bs = " ".join("%02X:%d" % (b, n) for b, n in sorted(banks.items(), key=lambda x: -x[1])[:5])
        ns, txt = u_info.get(u, (0, "?"))
        L.append("| %d | %02X:%04X | %s | `%s` | %d | %d | %d | %s |" % (i, u[0], u[1], kind, txt, ns, nb, ni, bs))
    text = "\n".join(L) + "\n"
    if a.out == "-":
        sys.stdout.write(text)
    else:
        Path(a.out).write_text(text)
    return 0


if __name__ == "__main__":
    sys.exit(main())
