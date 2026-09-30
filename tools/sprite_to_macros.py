#!/usr/bin/env python3
"""Rewrite the sprite-object data of the source tree (object tables, frame tables, frame records, animation scripts) into macro form.

    python3 tools/sprite_to_macros.py [options]

  --root DIR        tree to edit (default: the repository root; use it to work in a copy)
  --rom FILE        the original ROM (default: baserom.gbc, else "Mobile Trainer (Japan).gbc", in --root); it is only READ, and
                    must match roms.sha256
  --check           decode and verify only; write nothing; exit 1 when the files are not in the form this tool writes
  --dry-run         like the default run, but write nothing and build nothing (prints what would change)
  --no-build        write the files but skip the build / SHA-256 / sym_check verification (no rollback then!)
  --no-symcheck     run the build and the SHA-256 check but not tools/sym_check.py
  --no-new-labels   strict mode: never add a label; an item whose pointer target has no label stays `db`
  -v                list the labels that were created and every block or item that stays `db`

What it does
  1. Finds the sprite structures of the ROM with the walk of tools/sprite_chain_check.py (formats in docs/research/sprite_format.md):
     every `call|farcall Sprite_InitSlot` site gives an object table (bank, address); its 4-byte entries give the frame tables and scripts;
     a frame table (length = distance to its first record, every script index below it) gives the frame records.  Two items never overlap.
  2. Parses every region block (`; ---- kind $a-$b (n bytes)` + labels + db/dw/ds/macro lines) of home/ engine/ lib/ gfx/ data/ *.asm and
     regenerates the bytes of each block that holds sprite items: items become macro lines (constants/sprite_macros.inc), everything else in the
     block stays `db` (unreached bytes) or `ds` (zero runs).  Block headers, labels (also the aliases), comment lines between the data and the
     pinning by layout.link are kept.  Pointer words are written `dw Label` through the macros; a target without a label gets a neutral label
     (`Table_BB_AAAA:: ; BB:AAAA` for a frame table, `Data_BB_AAAA:: ; BB:AAAA` otherwise) unless --no-new-labels.
  3. An item stays `db`, with a comment saying why, when: the block has other content than db/dw/ds/macro lines (INCBIN, code), a label lies inside
     the item, the item crosses the end of its block, or a pointer target has no label and cannot get one.
  4. Builds (`make`), checks the SHA-256 against roms.sha256, requires a warning-free build and runs tools/sym_check.py; on any failure every
     file is restored.

The tool is deterministic and idempotent: the new text depends only on the ROM and on the labels that exist; a second run changes nothing
(`--check` verifies that).
"""
import argparse
import bisect
import collections
import glob
import hashlib
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sprite_chain_check as chain      # noqa: E402  (the walk is shared with the checker, so both always agree)

SRCDIRS = ('home', 'engine', 'lib', 'gfx', 'data')

REGION = re.compile(r'^; ---- (\w+) \$([0-9A-Fa-f]{4})-\$([0-9A-Fa-f]{4}) \((\d+) bytes\)')
LABEL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::(?P<rest>.*)$')
LABEL_ADDR = re.compile(r';\s*([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\b')
BANKLINE = re.compile(r'^; bank ([0-9A-Fa-f]{2}), \$([0-9A-Fa-f]{4})-\$([0-9A-Fa-f]{4})')
NEUTRAL = re.compile(r'^(Function|Label|Data|Table|String)_[0-9A-F]{2}_[0-9A-F]{4}$')
NUM = re.compile(r'^(\$[0-9A-Fa-f]+|-?[0-9]+|%[01]+)$')

OAMF = ((0x80, 'OAMF_PRI'), (0x40, 'OAMF_YFLIP'), (0x20, 'OAMF_XFLIP'), (0x10, 'OAMF_PAL1'), (0x08, 'OAMF_BANK1'))
# role names of the labels this tool creates (the kind of the structure is CONFIRMED by the engine code, nothing is said about the screen);
# tools/sprite_chain_check.py ignores exactly these names when it computes the extent of the named groups
GENERATED = {'ft': 'SpriteFrameTable_%02X_%04X', 'rec': 'SpriteFrame_%02X_%04X', 'sc': 'SpriteScript_%02X_%04X'}
MACRO_LINES = ('sprite_object_entry', 'sprite_frame_table', 'sprite_frame', 'sprite_oam', 'sprite_anim', 'sprite_anim_step')


class ToolError(Exception):
    pass


def hx(v):
    return '$%02X' % v


def num(tok):
    tok = tok.strip()
    if tok.startswith('$'):
        return int(tok[1:], 16)
    if tok.startswith('%'):
        return int(tok[1:], 2)
    return int(tok)


# --------------------------------------------------------------------------------------------------------------------
# source files
# --------------------------------------------------------------------------------------------------------------------

def split_args(s):
    s = s.split(';', 1)[0].strip()
    return [a.strip() for a in s.split(',')] if s else []


def line_bytes(line):
    """Number of bytes a data line emits, or None when it is not a data line this tool understands."""
    st = line.strip()
    m = re.match(r'^(db|dw|ds)\s+(.*)$', st)
    if m:
        op, rest = m.groups()
        args = split_args(rest)
        if not args or any(a == '' for a in args):
            return None
        if op == 'ds':
            if len(args) > 2 or not NUM.match(args[0]):
                return None
            return num(args[0])
        return len(args) * (1 if op == 'db' else 2)
    m = re.match(r'^(\w+)(?:\s+(.*))?$', st)
    if not m or m.group(1) not in MACRO_LINES:
        return None
    name, rest = m.group(1), m.group(2) or ''
    args = split_args(rest)
    if name == 'sprite_object_entry':
        return 4 if len(args) == 2 else None
    if name == 'sprite_frame_table':
        return 2 * len(args) if args else None
    if name in ('sprite_frame', 'sprite_anim'):
        return 1 if len(args) == 1 else None
    if name == 'sprite_oam':
        return 4 if len(args) == 4 else None
    if name == 'sprite_anim_step':
        return 2 if len(args) == 2 else None
    return None


class Block:
    def __init__(self, f, hdr, kind, start, end):
        self.file, self.hdr, self.kind, self.start, self.end = f, hdr, kind, start, end
        self.i0 = self.i1 = None        # line range that is regenerated (first line after the blank line(s) of the header .. end of the data)
        self.pre = collections.defaultdict(list)     # address -> label/comment lines found there, in order
        self.ok = False
        self.why = ''
        self.new = None                 # regenerated lines


class SrcFile:
    def __init__(self, root, rel):
        self.rel = rel
        self.path = os.path.join(root, rel)
        with open(self.path, encoding='utf-8', newline='') as fh:
            self.text = fh.read()
        self.lines = self.text.split('\n')
        self.bank = None
        m = BANKLINE.match(self.lines[1]) if len(self.lines) > 1 else None
        if m:
            self.bank = int(m.group(1), 16)
        self.blocks = []
        self.labels = []                # (name, bank, addr) of every label with an address
        if self.bank is None:
            return
        self._scan_labels()
        self._parse_blocks()

    def _scan_labels(self):
        last = None
        for l in self.lines:
            m = LABEL.match(l)
            if not m:
                if l.strip() and not l.strip().startswith(';'):
                    last = None
                continue
            am = LABEL_ADDR.search(m.group('rest'))
            if am:
                last = (int(am.group(1), 16), int(am.group(2), 16))
            if last:
                self.labels.append((m.group(1), last[0], last[1]))

    def _parse_blocks(self):
        L = self.lines
        for i, l in enumerate(L):
            m = REGION.match(l)
            if not m:
                continue
            start, end = int(m.group(2), 16), int(m.group(3), 16)
            b = Block(self, i, m.group(1), start, end)
            self.blocks.append(b)
            if end - start != int(m.group(4)):
                b.why = 'the size in the header disagrees with the range'
                continue
            if m.group(1) == 'zero':
                b.why = 'a `zero` padding region (kept as ds)'
                continue
            self._parse_block(b)

    def _parse_block(self, b):
        L = self.lines
        j = b.hdr + 1
        while j < len(L) and L[j].strip() == '':
            j += 1
        b.i0 = j
        pos = b.start
        while pos < b.end:
            if j >= len(L):
                b.why = 'the file ends inside the block'
                return
            l = L[j]
            st = l.strip()
            if st == '':
                j += 1
                continue
            m = LABEL.match(l)
            if m:
                am = LABEL_ADDR.search(m.group('rest'))
                if am and (int(am.group(1), 16) != self.bank or int(am.group(2), 16) != pos):
                    b.why = 'label %s: address comment does not match its position $%04X' % (m.group(1), pos)
                    return
                b.pre[pos].append(l)
                j += 1
                continue
            if st.startswith(';'):
                if REGION.match(l):
                    b.why = 'the next region header starts before the block ends'
                    return
                b.pre[pos].append(l)
                j += 1
                continue
            n = line_bytes(l)
            if n is None or not l.startswith('\t'):
                b.why = 'line %d is not db/dw/ds/sprite macro data: %r' % (j + 1, st[:50])
                return
            pos += n
            j += 1
        if pos != b.end:
            b.why = 'data lines run past the end of the block'
            return
        b.i1 = j
        b.ok = True

    def render(self):
        L = list(self.lines)
        for b in sorted(self.blocks, key=lambda b: -b.hdr):
            if b.new is not None:
                L[b.i0:b.i1] = b.new
        return '\n'.join(L)


def source_files(root):
    out = []
    for d in SRCDIRS:
        for p in sorted(glob.glob(os.path.join(root, d, '**', '*.asm'), recursive=True)):
            out.append(os.path.relpath(p, root))
    return sorted(out)


def label_name_of(line):
    return LABEL.match(line).group(1)


# --------------------------------------------------------------------------------------------------------------------
# the sprite structures of the ROM
# --------------------------------------------------------------------------------------------------------------------

class Item:
    __slots__ = ('kind', 'bank', 'addr', 'size', 'words', 'entry_no', 'root')

    def __init__(self, kind, bank, addr, size):
        self.kind, self.bank, self.addr, self.size = kind, bank, addr, size
        self.words = None
        self.entry_no = None
        self.root = None


def walk_items(root, rom, log):
    """(items {(bank, addr): Item}) from the sites of Sprite_InitSlot, read from the ROM."""
    chain.ROOT = root
    syms = chain.Syms(os.path.join(root, 'build', 'mobile_trainer.sym'))
    sites, problems = chain.find_sites(syms)
    if problems:
        raise ToolError('sprite_chain_check cannot resolve all Sprite_InitSlot sites:\n  ' + '\n  '.join(problems[:10]))
    root_sites = collections.defaultdict(list)
    for (f, ln, fn, bank, (tb, addr), op, bimm) in sites:
        g = syms.group_at_or_before(tb, addr)
        root_sites[(tb, g)].append((tb, addr))
    roots = sorted(root_sites)
    W = chain.Walk(rom, syms)
    W.run(roots)
    # a site whose operand is inside a bigger group (`ld de,$7318` in the group at 5D:7200) makes the group the root; when that finds no
    # entries the operand itself is tried as the start of the table (only two sites: 5D:7318 and 6A:64AE)
    extra = sorted(set(t for r in roots if not W.entries[r] for t in root_sites[r]))
    if extra:
        roots = sorted(set(roots) | set(extra))
        W = chain.Walk(rom, syms)
        W.run(roots)
        roots = [r for r in roots if W.entries[r] or r not in root_sites]
    if W.violations:
        raise ToolError('a script index is not below its frame-table length: run tools/sprite_chain_check.py')

    items = {}

    def add(it):
        items[(it.bank, it.addr)] = it

    for rt, ents in W.entries.items():
        for (j, f, s) in ents:
            it = Item('entry', rt[0], rt[1] + 4 * j, 4)
            it.words = (f, s)
            it.entry_no = j
            it.root = rt
            add(it)
    for (bank, f), ln in W.ftlen.items():
        n = ln['first_rec'] if ln['first_rec'] is not None else ln['ext']
        it = Item('ft', bank, f, 2 * n)
        it.words = tuple(rom.w(bank, f + 2 * k) for k in range(n))
        add(it)
    for (bank, a) in W.rec_at:
        add(Item('rec', bank, a, 1 + 4 * rom.b(bank, a)))
    for (bank, a) in W.sc_at:
        add(Item('sc', bank, a, 1 + 2 * rom.b(bank, a)))
    # no two items may overlap, and every pointer must land on an item of the right kind
    per_bank = collections.defaultdict(list)
    for (bank, a), it in items.items():
        per_bank[bank].append(it)
    for bank, lst in per_bank.items():
        lst.sort(key=lambda i: i.addr)
        for x, y in zip(lst, lst[1:]):
            if x.addr + x.size > y.addr:
                raise ToolError('sprite items overlap: %02X:%04X (%s) and %02X:%04X (%s)' % (bank, x.addr, x.kind, bank, y.addr, y.kind))
    for it in items.values():
        if it.kind == 'entry':
            f, s = it.words
            if f or s:
                if items.get((it.bank, f), Item('?', 0, 0, 0)).kind != 'ft' or items.get((it.bank, s), Item('?', 0, 0, 0)).kind != 'sc':
                    raise ToolError('entry %02X:%04X does not point at a frame table and a script' % (it.bank, it.addr))
        elif it.kind == 'ft':
            for w in it.words:
                if items.get((it.bank, w), Item('?', 0, 0, 0)).kind != 'rec':
                    raise ToolError('frame table %02X:%04X: word %04X is not a frame record' % (it.bank, it.addr, w))
    return items, roots


# --------------------------------------------------------------------------------------------------------------------
# text of the macro form
# --------------------------------------------------------------------------------------------------------------------

def signed(v):
    return str(v - 256 if v >= 0x80 else v)


def attr_text(v):
    parts = [n for bit, n in OAMF if v & bit]
    pal = v & 7
    if pal or not parts:
        parts.append(str(pal))
    return ' | '.join(parts)


def item_lines(it, rom, name):
    """Lines of the macro form of an item.  `name(bank, addr)` returns the label text of a pointer target or raises KeyError."""
    b, a = it.bank, it.addr
    if it.kind == 'entry':
        f, s = it.words
        fs = name(b, f) if f else '0'
        ss = name(b, s) if s else '0'
        return ['\tsprite_object_entry %s, %s ; entry %d' % (fs, ss, it.entry_no)]
    if it.kind == 'ft':
        names = [name(b, w) for w in it.words]
        return ['\tsprite_frame_table ' + ', '.join(names[i:i + 4]) for i in range(0, len(names), 4)]
    if it.kind == 'rec':
        n = rom.b(b, a)
        out = ['\tsprite_frame %d' % n]
        for k in range(n):
            y, x, t, at = (rom.b(b, a + 1 + 4 * k + i) for i in range(4))
            out.append('\tsprite_oam %s, %s, %s, %s' % (signed(y), signed(x), hx(t), attr_text(at)))
        return out
    n = rom.b(b, a)
    out = ['\tsprite_anim %d' % n]
    for k in range(n):
        out.append('\tsprite_anim_step %d, %d' % (rom.b(b, a + 1 + 2 * k), rom.b(b, a + 2 + 2 * k)))
    return out


def raw_lines(rom, bank, lo, hi, note, allow_ds=False):
    """db rows (16 bytes each) for the bytes lo..hi-1; with allow_ds a zero run of 8 or more becomes `ds` (no comment).  A row that
    holds a non-zero byte carries `note`."""
    data = [rom.b(bank, x) for x in range(lo, hi)]
    out, i, n = [], 0, len(data)
    run = []

    def flush():
        for k in range(0, len(run), 16):
            row = run[k:k + 16]
            out.append('\tdb ' + ', '.join(hx(v) for v in row) + (' ; ' + note if note and (any(row) or not allow_ds) else ''))
        run.clear()
    while i < n:
        if allow_ds and data[i] == 0:
            j = i
            while j < n and data[j] == 0:
                j += 1
            if j - i >= 8:
                flush()
                out.append('\tds $%X, $00' % (j - i))
                i = j
                continue
        run.append(data[i])
        i += 1
    flush()
    return out


# --------------------------------------------------------------------------------------------------------------------
# main rewrite
# --------------------------------------------------------------------------------------------------------------------

def rewrite(root, rom, items, new_labels, verbose):
    files = [SrcFile(root, r) for r in source_files(root)]
    files = [f for f in files if f.bank is not None]

    # every label of the tree with an address: (bank, addr) -> names in source order
    names_at = collections.defaultdict(list)
    defined = {}
    for f in files:
        for (n, bank, addr) in f.labels:
            names_at[(bank, addr)].append(n)
            defined[n] = (bank, addr)

    # the blocks that can be regenerated, and the block that holds every byte address
    block_of = {}
    for f in files:
        for b in f.blocks:
            if b.ok:
                for a in range(b.start, b.end):
                    block_of[(f.bank, a)] = b
    all_blocks = {}
    for f in files:
        for b in f.blocks:
            all_blocks.setdefault(f.bank, []).append(b)

    def pref(names):
        for n in names:
            if not NEUTRAL.match(n):
                return n
        return names[0]

    # pointer targets: label present, or label to be created
    created = {}                         # (bank, addr) -> (name, block)
    targets = set()
    for it in items.values():
        if it.kind == 'entry':
            for w in it.words:
                if w:
                    targets.add((it.bank, w))
        elif it.kind == 'ft':
            for w in it.words:
                targets.add((it.bank, w))
    if new_labels:
        for key in sorted(targets):
            if key in names_at:
                continue
            blk = block_of.get(key)
            if blk is None:
                continue
            nm = (GENERATED[items[key].kind]) % key
            if nm in defined:
                raise ToolError('label %s exists at another address' % nm)
            created[key] = (nm, blk)
            defined[nm] = key

    def name(bank, addr):
        if (bank, addr) in names_at:
            return pref(names_at[(bank, addr)])
        if (bank, addr) in created:
            return created[(bank, addr)][0]
        raise KeyError((bank, addr))

    report = {'raw': [], 'converted': collections.Counter(), 'bytes_conv': 0, 'bytes_raw_items': 0, 'bytes_unreached': 0, 'blocks': 0}
    item_block = {}
    for key, it in items.items():
        item_block[key] = block_of.get(key)

    # blocks that hold at least one item start
    used = {}
    for key, it in items.items():
        blk = item_block[key]
        if blk is None:
            # the item starts in a block that could not be parsed, or outside every region block
            cand = [b for b in all_blocks.get(it.bank, []) if b.start <= it.addr < b.end]
            why = ('block %s:$%04X-$%04X is not regenerable: %s' % (cand[0].file.rel, cand[0].start, cand[0].end, cand[0].why or 'unknown')) if cand else 'not inside a region block'
            report['raw'].append((key, it.kind, it.size, why))
            report['bytes_raw_items'] += it.size
            continue
        used.setdefault(id(blk), (blk, []))[1].append(it)

    for blk, its in used.values():
        bank = blk.file.bank
        itm = {it.addr: it for it in its}
        # items that start before this block but run into it are not converted in either block (see below)
        pos = blk.start
        out = []
        pre_addrs = sorted(blk.pre)
        new_here = {key[1]: v[0] for key, v in created.items() if v[1] is blk}

        def boundary_inside(lo, hi):
            return any(lo < a < hi for a in list(blk.pre) + list(new_here))

        starts = sorted(a for a in itm)
        while pos < blk.end:
            out += blk.pre.get(pos, [])
            if pos in new_here:
                out.append('%s:: ; %02X:%04X' % (new_here[pos], bank, pos))
            it = itm.get(pos)
            if it is not None:
                why = None
                if pos + it.size > blk.end:
                    why = 'the item crosses the end of its block'
                elif boundary_inside(pos, pos + it.size):
                    why = 'a label lies inside the item'
                if why is None:
                    try:
                        out += item_lines(it, rom, name)
                        report['converted'][it.kind] += 1
                        report['bytes_conv'] += it.size
                        pos += it.size
                        continue
                    except KeyError as e:
                        why = 'pointer target %02X:%04X has no label' % e.args[0]
                # stays db
                stop = min([blk.end, pos + it.size] + [a for a in list(blk.pre) + list(new_here) + starts if a > pos])
                note = 'sprite %s kept as db: %s' % ({'entry': 'object-table entry', 'ft': 'frame table', 'rec': 'frame record', 'sc': 'script'}[it.kind], why)
                out += raw_lines(rom, bank, pos, stop, note)
                if stop >= pos + it.size or stop == blk.end:
                    report['raw'].append(((bank, it.addr), it.kind, it.size, why))
                report['bytes_raw_items'] += stop - pos
                pos = stop
                continue
            stop = min([blk.end] + [a for a in list(blk.pre) + list(new_here) + starts if a > pos])
            zero = all(rom.b(bank, a) == 0 for a in range(pos, stop))
            out += raw_lines(rom, bank, pos, stop, '' if zero else 'not reached by any walked sprite chain', True)
            report['bytes_unreached'] += stop - pos
            pos = stop
        blk.new = out
        report['blocks'] += 1

    # labels that the plan wanted to create in a block must have been emitted there (every created target is an item start of a used block)
    for key, (nm, blk) in created.items():
        if blk.new is None or not any(l.startswith(nm + '::') for l in blk.new):
            raise ToolError('internal: label %s was not emitted' % nm)

    if verbose:
        for key in sorted(created):
            print('  new label %s' % created[key][0])
    return files, created, report


# --------------------------------------------------------------------------------------------------------------------
# verification
# --------------------------------------------------------------------------------------------------------------------

def run(cmd, root):
    p = subprocess.run(cmd, shell=True, cwd=root, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, errors='replace')
    return p.returncode, p.stdout


def sha_of(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        h.update(f.read())
    return h.hexdigest()


def verify_tree(root, symcheck):
    rc, log = run('make', root)
    if rc != 0:
        return False, 'make failed:\n' + log[-3000:]
    want = open(os.path.join(root, 'roms.sha256')).read().split()[0]
    got = sha_of(os.path.join(root, 'mobile_trainer.gbc'))
    if want != got:
        return False, 'SHA-256 mismatch: built %s, expected %s' % (got, want)
    warn = [l for l in log.splitlines() if 'warning' in l.lower()]
    if warn:
        return False, 'the build printed warnings:\n' + '\n'.join(warn[:20])
    if symcheck:
        rc, log = run('python3 tools/sym_check.py', root)
        if rc != 0:
            return False, 'sym_check failed:\n' + log[-3000:]
    return True, got


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--root', default=ROOT)
    ap.add_argument('--rom')
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-build', action='store_true')
    ap.add_argument('--no-symcheck', action='store_true')
    ap.add_argument('--no-new-labels', action='store_true')
    ap.add_argument('-v', '--verbose', action='store_true')
    a = ap.parse_args(argv)
    root = os.path.abspath(a.root)

    rom_path = a.rom
    if rom_path is None:
        for cand in ('baserom.gbc', 'Mobile Trainer (Japan).gbc'):
            if os.path.exists(os.path.join(root, cand)):
                rom_path = os.path.join(root, cand)
                break
    if rom_path is None:
        print('no reference ROM (baserom.gbc or "Mobile Trainer (Japan).gbc"); see INSTALL.md', file=sys.stderr)
        return 2
    want = open(os.path.join(root, 'roms.sha256')).read().split()[0]
    if sha_of(rom_path) != want:
        print('%s does not match roms.sha256' % rom_path, file=sys.stderr)
        return 2
    if 'constants/sprite_macros.inc' not in open(os.path.join(root, 'includes.asm')).read():
        print('includes.asm does not include constants/sprite_macros.inc', file=sys.stderr)
        return 2

    # the symbol file is needed to resolve the Sprite_InitSlot sites (tools/sprite_chain_check.py)
    ok, info = verify_tree(root, False)
    if not ok:
        print('the tree does not build to the reference ROM before any change:\n' + info, file=sys.stderr)
        return 2

    rom = chain.Rom(rom_path)
    try:
        items, roots = walk_items(root, rom, print)
        files, created, rep = rewrite(root, rom, items, not a.no_new_labels, a.verbose)
    except ToolError as e:
        print('error: %s' % e, file=sys.stderr)
        return 2

    changed = []
    for f in files:
        if any(b.new is not None for b in f.blocks) or True:
            r = f.render()
            if r != f.text:
                changed.append((f, r))
    kinds = collections.Counter(it.kind for it in items.values())
    print('sprite items in the ROM: %s (%d object tables, %d bytes)' % (', '.join('%s %d' % kv for kv in sorted(kinds.items())), len(roots),
                                                                     sum(it.size for it in items.values())))
    print('converted to macros: %s = %d bytes in %d block(s); kept as db: %d items (%d bytes); unreached bytes in those blocks: %d; labels created: %d; files that change: %d'
          % (', '.join('%s %d' % kv for kv in sorted(rep['converted'].items())), rep['bytes_conv'], rep['blocks'], len(rep['raw']),
             rep['bytes_raw_items'], rep['bytes_unreached'], len(created), len(changed)))
    if rep['raw']:
        cats = collections.defaultdict(list)

        def category(why):
            m = re.match(r'^block (\S+) is not regenerable: (.*)$', why)
            if m and m.group(2).startswith('a `zero`'):
                return 'in a `zero` padding region of %s (kept as ds)' % m.group(1)
            if m:
                return 'in a block of %s that is not db/dw/ds (INCBIN/INCLUDE asset)' % m.group(1)
            return re.sub(r'pointer target \S+ has no label', 'a pointer target has no label and cannot get one', why)
        for key, kind, size, why in sorted(rep['raw']):
            cats[category(why)].append((key, kind, size))
        print('kept as db (%d items):' % len(rep['raw']))
        for why, lst in sorted(cats.items()):
            print('  %3d x %s [%s]' % (len(lst), why, ', '.join(sorted(set('%02X:%04X' % (k[0], k[1]) for k, _, _ in lst)))[:160] + ('...' if a.verbose is False and len(lst) > 6 else '')))
        if a.verbose:
            for key, kind, size, why in sorted(rep['raw']):
                print('    %02X:%04X %s (%d bytes): %s' % (key[0], key[1], kind, size, why))
    if a.check:
        for f, _ in changed:
            print('not in macro form: ' + f.rel)
        return 1 if changed else 0
    if a.dry_run or not changed:
        return 0
    old = {f.path: f.text for f, _ in changed}
    for f, r in changed:
        with open(f.path, 'w', encoding='utf-8', newline='') as fh:
            fh.write(r)
    if a.no_build:
        print('written %d files (not verified)' % len(changed))
        return 0
    ok, info = verify_tree(root, not a.no_symcheck)
    if not ok:
        for p, t in old.items():
            with open(p, 'w', encoding='utf-8', newline='') as fh:
                fh.write(t)
        run('make', root)
        print('VERIFICATION FAILED, files restored:\n' + info, file=sys.stderr)
        return 1
    print('written %d files; build OK, SHA-256 %s' % (len(changed), info))
    return 0


if __name__ == '__main__':
    sys.exit(main())
