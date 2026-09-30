#!/usr/bin/env python3
"""sprite_chain_check.py -- walk every sprite object table of the ROM and check the names of the blocks it reaches.

Independent of tools/data_consumers.py.  Formats used (re-derived from home/sprites.asm, Sprite_InitSlot 00:0A82,
Sprite_LoadObjectEntry 00:0AB8, Sprite_StepAndDrawSlot 00:0AE8; all pointers are 16-bit, in the ROM bank given as A to Sprite_InitSlot
[slot+0E], there is no bank byte in the table):

  object table  : 4-byte entries  dw frame_table, dw script          entry = DE + 4*(B & $7F)
  frame table   : array of dw, one record pointer per frame index (no count byte: its length is not stored anywhere)
  frame record  : db n ; n x (db y, x, tile, attribute)                 (1 + 4n bytes)
  script        : db n ; n x (db frame_index, delay)                    (1 + 2n bytes)

Procedure
  1. roots: every `call|farcall Sprite_InitSlot` of the source (712, the same number as the `CD xx xx 82 0A 00` byte patterns of the ROM) is
     resolved to (bank, address) from its `ld de,X` and `ld a,$BB` of the preceding straight-line window; the bank of a label operand must equal
     A (otherwise reported); every root must also be a possible `ld de,imm16`/`ld a,imm8` pair in the ROM bytes before a far call.
  2. walk: root -> entries (the run of plausible 4-byte entries from the label, NOT limited to the label's extent because a table may continue in the
     next label; cut at the next root of the bank and at the lowest pointer target after the table start) -> frame table -> records; script.
     Frame-table length: distance to its first record (tables are directly followed by their first record); cross-checked against the highest frame
     index used by the scripts paired with it (every script frame index must be smaller: reported as a violation otherwise).
  3. names: every symbol that looks like <Stem>_Anim<N>Frames / _Anim<N>Frame<k>[To<m>] / _Anim<N>Script / _ObjAnimData* / *_ObjTable is checked
     against what the walk reaches (address equality, extent, N = entry index, k = frame index, sharing between roots).

Hard mismatches (exit status 1): a name whose address is not the start of the structure it names, wrong extent, N/k not the entry/frame index,
a block shared by several roots but named after one, an ObjTable name that no Sprite_InitSlot site loads, a stem unrelated to the root's names.
Informational (-v): shared entries/records inside one root, scripts followed by zero padding, how much of each *_ObjAnimData block is reached.
--explain NAME... prints the decoded chain of the named blocks.  Not checked here: whether the stem of a name is the right *screen* (read the
consumers printed in the root table).

Usage:  python3 tools/sprite_chain_check.py [--rom FILE] [--sym FILE] [-v] [--explain NAME...]      (run `make` first: needs build/mobile_trainer.sym)
"""
import argparse
import collections
import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def rom_off(bank, addr):
    return addr if bank == 0 else bank * 0x4000 + (addr - 0x4000)


class Rom:
    def __init__(self, path):
        self.d = open(path, 'rb').read()

    def b(self, bank, a):
        return self.d[rom_off(bank, a)]

    def w(self, bank, a):
        o = rom_off(bank, a)
        return self.d[o] | (self.d[o + 1] << 8)


def load_sym(path):
    names = collections.defaultdict(list)     # (bank, addr) -> [names]
    by_name = {}
    for line in open(path):
        m = re.match(r'^([0-9a-f]{2}):([0-9a-f]{4}) (\S+)$', line.strip())
        if not m:
            continue
        bank, addr, nm = int(m.group(1), 16), int(m.group(2), 16), m.group(3)
        if '.' in nm or addr >= 0x8000:
            continue
        names[(bank, addr)].append(nm)
        by_name[nm] = (bank, addr)
    per_bank = collections.defaultdict(list)
    for (bank, addr) in names:
        per_bank[bank].append(addr)
    for b in per_bank:
        per_bank[b].sort()
    return names, by_name, per_bank


class Syms:
    def __init__(self, path):
        self.names, self.by_name, self.per_bank = load_sym(path)

    def next_addr(self, bank, addr):
        """address of the next global symbol after addr in the bank (end of the group)"""
        import bisect
        l = self.per_bank[bank]
        i = bisect.bisect_right(l, addr)
        return l[i] if i < len(l) else (0x8000 if bank else 0x4000)

    def group_at_or_before(self, bank, addr):
        import bisect
        l = self.per_bank[bank]
        i = bisect.bisect_right(l, addr) - 1
        return l[i] if i >= 0 else None


def find_sites(syms):
    """(file, line, function, bank_a, target (bank, addr), offset_inside, b_imm, raw_operand)"""
    sites, problems = [], []
    for f in sorted(glob.glob(os.path.join(ROOT, '**', '*.asm'), recursive=True)):
        if '/build/' in f:
            continue
        L = open(f).read().split('\n')
        fn = None
        grp, prev_label = [], False
        for i, l in enumerate(L):
            m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*)::?', l)
            if m:
                grp = (grp if prev_label else []) + [m.group(1)]
                prev_label = True
                good = [g for g in grp if not re.match(r'^(Function|Label|Data|Table)_[0-9A-F]{2}_[0-9A-F]{4}$', g)]
                fn = (good or grp)[0]
            elif l.strip() and not l.strip().startswith(';'):
                prev_label = False
            if not re.match(r'^\s*(call|farcall)\s+Sprite_InitSlot\b', l):
                continue
            de = a = b = None
            for x in reversed(L[max(0, i - 14):i]):
                if de is None and re.match(r'\s*ld de,', x):
                    de = x.split(',', 1)[1].split(';')[0].strip()
                if a is None and re.match(r'\s*ld a,', x):
                    a = x.split(',', 1)[1].split(';')[0].strip()
                if b is None and re.match(r'\s*ld b,', x):
                    b = x.split(',', 1)[1].split(';')[0].strip()
            rel = os.path.relpath(f, ROOT)
            if de is None or a is None:
                problems.append('%s:%d no ld de / ld a in window' % (rel, i + 1))
                continue
            if not a.startswith('$'):
                problems.append('%s:%d bank operand %r is not an immediate' % (rel, i + 1, a))
                continue
            bank = int(a[1:], 16)
            off = 0
            mm = re.match(r'^(.*?)\s*\+\s*(\$?[0-9A-Fa-f]+)$', de)
            base = de
            if mm:
                base, off = mm.group(1), int(mm.group(2).replace('$', '0x'), 16 if not mm.group(2).startswith('$') else 16)
            if base.startswith('$'):
                addr = int(base[1:], 16)
                tb = bank
            elif base in syms.by_name:
                tb, addr = syms.by_name[base]
                if tb != bank:
                    problems.append('%s:%d BANK MISMATCH: %s is in bank %02X, A=$%02X' % (rel, i + 1, base, tb, bank))
            else:
                problems.append('%s:%d unresolved operand %r' % (rel, i + 1, de))
                continue
            addr += off
            bimm = int(b[1:], 16) if b and re.match(r'^\$[0-9A-Fa-f]{1,2}$', b) else None
            sites.append((rel, i + 1, fn, bank, (bank, addr), de, bimm))
    return sites, problems


def rom_site_pairs(rom):
    """all (bank, addr) that occur as `ld de,imm16` + `ld a,imm8` within 40 bytes before a `call FARCALL_FN; dw 0A82; db 00` in the ROM"""
    out = set()
    d = rom.d
    for m in re.finditer(rb'\xcd..\x82\x0a\x00', d, re.S):
        p = m.start()
        window = range(max(0, p - 40), p)
        des = [(d[q + 1] | (d[q + 2] << 8)) for q in window if d[q] == 0x11 and q + 2 < p]
        As = [d[q + 1] for q in window if d[q] == 0x3E and q + 1 < p]
        for x in des:
            for a in As:
                out.add((a, x))
    n = len(re.findall(rb'\xcd..\x82\x0a\x00', d, re.S))
    return out, n


class Walk:
    def __init__(self, rom, syms):
        self.rom, self.syms = rom, syms
        self.ft_at = collections.defaultdict(list)       # (bank, addr) -> [(root, entry)]
        self.rec_at = collections.defaultdict(list)      # (bank, addr) -> [(root, entry, ft_addr, k)]
        self.sc_at = collections.defaultdict(list)       # (bank, addr) -> [(root, entry)]
        self.entries = {}                                # root -> [(j, f, s)]
        self.ftlen = {}                                  # (bank, f) -> dict of length estimates
        self.violations = []
        self.notes = []

    def table_entries(self, root, roots=()):
        """entries of the object table at root: the run of plausible 4-byte entries from the label (the extent of the label is NOT used: a table may
        continue in the next label), cut at the next known root of the bank and at the lowest pointer target after the table start (data that follows it)"""
        bank, base = root
        r = self.rom
        nxt = [b for (bk, b) in roots if bk == bank and b > base]
        n = min(400, (0x8000 - base) // 4, ((min(nxt) - base) // 4) if nxt else 400)
        ents = []
        for j in range(n):
            f, s = r.w(bank, base + 4 * j), r.w(bank, base + 4 * j + 2)
            if not (f == 0 and s == 0) and not self.plausible(bank, f, s):
                break          # followed by other data / the end of its section: stop at the first implausible entry
            ents.append((j, f, s))
        while True:
            ts = [t for (_, f, s) in ents for t in (f, s) if t >= base + 4]
            m = min(len(ents), (min(ts) - base) // 4) if ts else len(ents)
            if m == len(ents):
                break
            ents = ents[:m]
        while ents and ents[-1][1] == 0 and ents[-1][2] == 0:
            ents.pop()
        return ents

    def plausible(self, bank, f, s):
        r = self.rom
        if not (0x4000 <= f < 0x7FFE and 0x4000 <= s < 0x7FFE):
            return False
        r0 = r.w(bank, f)
        if not (0x4000 <= r0 < 0x8000) or r.b(bank, r0) > 40:
            return False
        n = r.b(bank, s)
        return 1 <= n <= 64

    def run(self, roots):
        r, sy = self.rom, self.syms
        scripts = collections.defaultdict(list)     # (bank, f) -> [(root, j, s)]
        for root in sorted(roots):
            bank = root[0]
            ents = self.table_entries(root, roots)
            self.entries[root] = ents
            for (j, f, s) in ents:
                if f == 0 and s == 0:
                    continue
                if not (0x4000 <= f < 0x8000 and 0x4000 <= s < 0x8000):
                    self.notes.append('%02X:%04X entry %d: pointer outside ROMX (%04X,%04X)' % (root[0], root[1], j, f, s))
                    continue
                self.ft_at[(bank, f)].append((root, j))
                self.sc_at[(bank, s)].append((root, j))
                scripts[(bank, f)].append((root, j, s))
        for (bank, f), lst in sorted(self.ft_at.items()):
            # length estimates: (a) extent to next symbol, (b) distance to the first record when the table is directly followed by it,
            # (c) 1 + max frame index of all scripts paired with this table (lower bound)
            ext = (sy.next_addr(bank, f) - f) // 2
            r0 = r.w(bank, f)
            est_b = (r0 - f) // 2 if f < r0 <= f + 256 else None
            mx = -1
            for (root, j, s) in scripts[(bank, f)]:
                n = r.b(bank, s)
                for i in range(n):
                    mx = max(mx, r.b(bank, s + 1 + 2 * i))
            self.ftlen[(bank, f)] = dict(ext=ext, first_rec=est_b, script_min=mx + 1)
            L = est_b if est_b is not None else ext
            for (root, j, s) in scripts[(bank, f)]:
                n = r.b(bank, s)
                for i in range(n):
                    fi = r.b(bank, s + 1 + 2 * i)
                    if fi >= L:
                        self.violations.append('script %02X:%04X (root %02X:%04X entry %d) pair %d: frame index %d >= frame table length %d (%02X:%04X)' %
                                               (bank, s, root[0], root[1], j, i, fi, L, bank, f))
            for k in range(L):
                rp = r.w(bank, f + 2 * k)
                for (root, j) in lst:          # every entry that uses this frame table reaches the record
                    self.rec_at[(bank, rp)].append((root, j, f, k))


def rec_len(rom, bank, a):
    return 1 + 4 * rom.b(bank, a)


def scr_len(rom, bank, a):
    return 1 + 2 * rom.b(bank, a)


def coverage(W, rom, bank, addr, size, syms):
    """(covered bytes, size, unexplained non-zero bytes) of the group [addr, addr+size) by structures of the walk (object-table entries of a root
    inside the block, frame tables with their records, scripts)"""
    cov = set()
    for root, ents in W.entries.items():
        if root[0] == bank and addr <= root[1] < addr + size:
            for (j, f, s_) in ents:
                cov.update(range(root[1] + 4 * j, root[1] + 4 * j + 4))
    for (b, f), ln in W.ftlen.items():
        if b != bank:
            continue
        L = ln['first_rec'] if ln['first_rec'] is not None else ln['ext']
        if addr <= f < addr + size:
            cov.update(range(f, f + 2 * L))
            for kk in range(L):
                rp = rom.w(bank, f + 2 * kk)
                cov.update(range(rp, rp + rec_len(rom, bank, rp)))
    for (b, sa) in W.sc_at:
        if b == bank and addr <= sa < addr + size:
            cov.update(range(sa, sa + scr_len(rom, bank, sa)))
    inside = [a for a in range(addr, addr + size) if a in cov]
    unexpl = [a for a in range(addr, addr + size) if a not in cov and rom.b(bank, a) != 0]
    return (len(inside), size, len(unexpl))


def explain(nm, W, rom, syms):
    k = syms.by_name.get(nm)
    if k is None:
        print('explain: unknown symbol', nm)
        return
    bank, addr = k
    print('\n== %s  %02X:%04X  (group extent to the next symbol: %d bytes)' % (nm, bank, addr, syms.next_addr(bank, addr) - addr))
    for (b, f), lst in W.ft_at.items():
        if b != bank:
            continue
        L = W.ftlen[(b, f)]
        L = L['first_rec'] if L['first_rec'] is not None else L['ext']
        inside = f == addr
        recs = [rom.w(bank, f + 2 * i) for i in range(L)]
        if inside or addr in recs or any(r <= addr < r + rec_len(rom, bank, r) for r in recs):
            for root, j in lst[:1]:
                eb = rom_off(bank, root[1] + 4 * j)
                print('  root %02X:%04X entry %d bytes %s -> frame table %04X (%d words): %s' % (root[0], root[1], j, rom.d[eb:eb + 4].hex(' '), f, L, ' '.join('%04X' % r for r in recs)))
            for r in recs:
                print('    record %04X: count %d, %d bytes%s' % (r, rom.b(bank, r), rec_len(rom, bank, r), '  <-- this block' if r == addr else ''))
    for (b, sa), lst in W.sc_at.items():
        if b == bank and sa <= addr < sa + scr_len(rom, bank, sa):
            n = rom.b(bank, sa)
            pairs = [(rom.b(bank, sa + 1 + 2 * i), rom.b(bank, sa + 2 + 2 * i)) for i in range(n)]
            root, j = lst[0]
            print('  script %04X: entries %s; count %d, %d bytes, (frame,delay) %s' % (sa, ['%02X:%04X#%d' % (r[0], r[1], jj) for r, jj in lst], n, scr_len(rom, bank, sa), pairs))


NAME_RE = re.compile(r'^(?P<stem>.+?)_Anim(?P<n>\d+)(?:(?P<ft>Frames)|Frame(?P<k>\d+)(?:To(?P<m>\d+))?|(?P<sc>Script))$')


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', default=None)
    ap.add_argument('--sym', default=os.path.join(ROOT, 'build', 'mobile_trainer.sym'))
    ap.add_argument('-v', '--verbose', action='store_true')
    ap.add_argument('--explain', nargs='*', default=[], metavar='NAME', help='print the decoded chain (root entry, table words, records, script) of the named blocks')
    a = ap.parse_args(argv)
    rompath = a.rom
    if rompath is None:
        for c in ('Mobile Trainer (Japan).gbc', 'baserom.gbc', 'mobile_trainer.gbc'):
            if os.path.exists(os.path.join(ROOT, c)):
                rompath = os.path.join(ROOT, c)
                break
    rom = Rom(rompath)
    syms = Syms(a.sym)
    hard = 0

    sites, problems = find_sites(syms)
    pairs, nrom = rom_site_pairs(rom)
    print('Sprite_InitSlot call sites: %d in the source, %d `call FARCALL_FN; dw 0A82; db 00` patterns in the ROM' % (len(sites), nrom))
    for p in problems:
        print('  site problem:', p)
    hard += len(problems) + (len(sites) != nrom)

    # roots: group containing each target
    root_sites = collections.defaultdict(list)
    for (f, ln, fn, bank, (tb, addr), op, bimm) in sites:
        g = syms.group_at_or_before(tb, addr)
        root_sites[(tb, g)].append((f, ln, fn, addr - g, bimm))
        if (bank, addr) not in pairs:
            print('  site %s:%d: (%02X,%04X) is not a possible ld a/ld de pair of the ROM bytes' % (f, ln, bank, addr))
            hard += 1
    roots = sorted(root_sites)
    print('roots (distinct object-table groups): %d' % len(roots))
    W = Walk(rom, syms)
    W.run(roots)

    # ---- per root report
    print('\n%-7s %-46s %4s %4s %-s' % ('root', 'names', 'ents', 'sites', 'consumer routines'))
    for rt in roots:
        cons = sorted(set(x[2] for x in root_sites[rt]))
        interior = sorted(set(x[3] for x in root_sites[rt] if x[3]))
        print('%02X:%04X %-46s %4d %4d %s%s' % (rt[0], rt[1], ','.join(syms.names[rt])[:46], len(W.entries[rt]), len(root_sites[rt]),
                                              ','.join(cons)[:150], ('  interior offsets %s' % interior) if interior else ''))

    print('\nscript frame-index violations over %d frame tables: %d' % (len(W.ft_at), len(W.violations)))
    for v in W.violations:
        print('  ', v)
    hard += len(W.violations)
    for n in W.notes:
        print('  note:', n)

    # frame-table length: a frame table named ..._Anim<N>Frames must extend exactly to its first record (checked again per name below); blocks
    # that only *contain* a frame table (*_ObjAnimData) are not expected to match
    named = [k for k in W.ftlen if any(n.endswith('Frames') and NAME_RE.match(n) for n in syms.names.get(k, []))]
    dis = [k for k in named if W.ftlen[k]['first_rec'] is not None and W.ftlen[k]['first_rec'] != W.ftlen[k]['ext']]
    print('frame tables named ..._Anim<N>Frames: %d, of which extent != 2 x distance to the first record: %d' % (len(named), len(dis)))
    hard += len(dis)

    for nm in a.explain:
        explain(nm, W, rom, syms)

    # ---- names
    stats = collections.Counter()
    bad = []
    info = []
    role_names = []
    for (bank, addr), nms in sorted(syms.names.items()):
        for nm in nms:
            m = NAME_RE.match(nm)
            if m or 'ObjAnimData' in nm or nm.endswith('ObjTable') or 'ObjTableAndAnimData' in nm:
                role_names.append(((bank, addr), nm, m))
    end = lambda k: syms.next_addr(*k)
    for k, nm, m in role_names:
        bank, addr = k
        size = end(k) - addr
        if m is None:
            if nm.endswith('ObjTable'):
                stats['root-name'] += 1
                if k not in root_sites:
                    bad.append((nm, k, 'named ObjTable but no Sprite_InitSlot site loads it'))
            else:
                stats['objanimdata'] += 1
                reach = [t for t in (list(W.ft_at) + list(W.sc_at)) if t[0] == bank and addr <= t[1] < addr + size]
                cov = coverage(W, rom, bank, addr, size, syms)
                if cov is not None:
                    info.append((nm, k, 'ObjAnimData coverage: %d of %d bytes are object entries / frame tables / records / scripts reached by a chain, %d non-zero bytes unexplained' % cov))
                if not reach:
                    bad.append((nm, k, 'ObjAnimData block reached by no chain'))
                elif min(t[1] for t in reach) != addr and k not in W.rec_at:
                    info.append((nm, k, 'ObjAnimData: first chain target at +%X (block starts with unreached bytes)' % (min(t[1] for t in reach) - addr)))
            continue
        n = int(m.group('n'))
        stem = m.group('stem')
        if m.group('ft'):
            stats['Frames'] += 1
            lst = W.ft_at.get(k)
            if not lst:
                bad.append((nm, k, 'address is not a frame table of any entry'))
                continue
            js = sorted(set((root, j) for root, j in lst))
            if not any(j == n for root, j in js):
                bad.append((nm, k, 'entry index differs: reached as %s' % ['%02X:%04X#%d' % (r[0], r[1], j) for r, j in js]))
            elif n != min(j for r, j in js):
                info.append((nm, k, 'N=%d is not the lowest entry that reaches the frame table: %s' % (n, [j for r, j in js])))
            roots_ = sorted(set(r for r, j in js))
            if len(roots_) > 1:
                bad.append((nm, k, 'shared by several roots %s' % ['%02X:%04X' % r for r in roots_]))
            ln = W.ftlen[k]
            L = ln['first_rec'] if ln['first_rec'] is not None else ln['ext']
            if size != 2 * L:
                bad.append((nm, k, 'extent %d != 2 x %d words' % (size, L)))
            if len(js) > 1:
                info.append((nm, k, 'frame table shared by entries %s' % ['%02X:%04X#%d' % (r[0], r[1], j) for r, j in js]))
        elif m.group('k') is not None:
            stats['Frame'] += 1
            kk = int(m.group('k'))
            mm_ = m.group('m')
            lst = W.rec_at.get(k)
            if not lst:
                bad.append((nm, k, 'address is not a frame record of any walked table'))
                continue
            if not any(j == n and kidx == kk for (root, j, f, kidx) in lst):
                # the first index that references the record is what the name should carry
                bad.append((nm, k, 'reached as %s' % [('%02X:%04X#%d frame %d' % (r[0], r[1], j, kidx)) for (r, j, f, kidx) in lst]))
            if mm_ is None:
                if size != rec_len(rom, bank, addr):
                    bad.append((nm, k, 'extent %d != record length %d' % (size, rec_len(rom, bank, addr))))
            else:
                mm2 = int(mm_)
                a_, cnt = addr, 0
                ok = True
                idx = []
                while a_ < addr + size:
                    e = W.rec_at.get((bank, a_))
                    if not e:
                        ok = False
                        break
                    idx.append(e[0][3])
                    a_ += rec_len(rom, bank, a_)
                if not ok or a_ != addr + size or idx != list(range(kk, mm2 + 1)):
                    bad.append((nm, k, 'FrameKToM does not tile: indices %s, end %04X vs %04X' % (idx, a_, addr + size)))
            mk = min(kidx for (r, j, f, kidx) in lst if j == n) if any(j == n for (r, j, f, kidx) in lst) else None
            if mk is not None and mk != kk:
                bad.append((nm, k, 'k=%d but the record is first used as frame %d of the same table' % (kk, mk)))
            if len(set((x[0], x[1]) for x in lst)) > 1:
                info.append((nm, k, 'record shared: %s' % [('%02X:%04X#%d' % (r[0], r[1], j)) for (r, j, f, kidx) in lst]))
        else:
            stats['Script'] += 1
            lst = W.sc_at.get(k)
            if not lst:
                bad.append((nm, k, 'address is not a script of any entry'))
                continue
            js = sorted(set((root, j) for root, j in lst))
            if not any(j == n for root, j in js):
                bad.append((nm, k, 'entry index differs: reached as %s' % ['%02X:%04X#%d' % (r[0], r[1], j) for r, j in js]))
            if len(set(r for r, j in js)) > 1:
                bad.append((nm, k, 'shared by several roots %s' % ['%02X:%04X' % r for r, j in js]))
            sl = scr_len(rom, bank, addr)
            pad = size - sl
            # the script must fit in its group; what follows up to the next symbol must be zero padding (a group may end in unlabeled padding)
            nz = [i for i in range(min(max(pad, 0), 16)) if rom.b(bank, addr + sl + i)]
            if pad < 0 or nz:
                bad.append((nm, k, 'extent %d vs script length %d (non-zero bytes after the script)' % (size, sl)))
            elif pad > 1:
                info.append((nm, k, 'script followed by %d byte(s) of zero padding before the next symbol' % pad))
            if len(js) > 1:
                info.append((nm, k, 'script shared by entries %s' % ['%02X:%04X#%d' % (r[0], r[1], j) for r, j in js]))
        # stem check against the names of the root(s)
        rts = set()
        for tbl in (W.ft_at, W.sc_at):
            for (r, j) in tbl.get(k, []):
                rts.add(r)
        for (r, j, f, kidx) in W.rec_at.get(k, []):
            rts.add(r)
        okstem = False
        for r in rts:
            for rn in syms.names.get(r, []):
                s = re.sub(r'^Table_', '', rn)
                s = re.sub(r'(_?ObjTables?|_?ObjectEntries|_?ObjAnims|_?Anims|_?Objects)$', '', s)
                if s == stem or stem.startswith(s) or s.startswith(stem):
                    okstem = True
        if rts and not okstem:
            bad.append((nm, k, 'stem %s does not match root names %s' % (stem, sorted(syms.names.get(r, ['?'])[0] for r in rts))))

    print('\nnames checked: %s' % dict(stats))
    print('hard mismatches: %d' % len(bad))
    for nm, k, why in bad:
        print('  MISMATCH %-55s %02X:%04X %s' % (nm, k[0], k[1], why))
    if a.verbose:
        print('\nnotes (not errors): %d' % len(info))
        for nm, k, why in info:
            print('  info %-55s %02X:%04X %s' % (nm, k[0], k[1], why))
    else:
        print('notes (not errors): %d (use -v)' % len(info))
    return 1 if (bad or hard) else 0


if __name__ == '__main__':
    sys.exit(main())
