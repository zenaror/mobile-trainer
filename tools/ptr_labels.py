#!/usr/bin/env python3
"""Write documented pointer tables of the code files as `dw Label` instead of numbers / `db` bytes.

    python3 tools/ptr_labels.py --dry-run      # report what would change and what is skipped (and why), write nothing
    python3 tools/ptr_labels.py                # convert, then `make checkhash`, restore every file if the SHA-256 differs
    python3 tools/ptr_labels.py --no-verify

Needs build/mobile_trainer.sym (run `make` first): the symbol file is where the labels and their bank:address come from.

What is converted (nothing else):

  1. `ptrtable` regions (header kind `ptrtable`, or `words` whose note says "pointers" and not RAM/ROM-bank hedges) whose `dw $XXXX` lines
     are numeric: an entry becomes `dw Label` when a global label sits at the same address of the SAME bank (the .sym file) or the
     address is the start of a `db` line of a text block of that bank (such a line gets a generic `String_BB_AAAA::` label, the
     convention of STYLE.md "Writing strings").  ALL-OR-NOTHING per table: if one entry has no target, the table stays as it is.
  2. Record tables that a region note documents field by field (RECORDS below: the note is the evidence, the header is checked with a
     regex before anything is touched): the pointer fields become `dw Label`, the other bytes stay `db $xx`.  Same rule: every pointer
     of the table must resolve, else the table stays.

Why the bytes cannot change: `dw Label` is the little-endian address of a label that the SYM file places at exactly the number that was
there.  The assembler and the SHA-256 (`make`) prove it; the script restores the files if the hash differs.  The bank of a pointer is
the file's own bank, except where the note names another one (RECORDS 'far'); `dw Label` carries the address only, so the note (own-bank
targets: "code pointers hit own-bank code starts", "pointer to a dialogue string", "glyph-run pointer16, bank byte $48") is what
says the target is that label and not a coincidence.

Idempotent: converted lines are `dw Label` / `db $xx` records; a second run finds no numeric pointer left that it may convert.
"""
import argparse
import collections
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gen_sjis_charmap as G  # noqa: E402

ROOT = G.ROOT
GENERIC = re.compile(r'^(Data|Tiles|Tilemap|Attrmap|Palette|Font|Table|String|Function|Label)_([0-9A-F]{2})_([0-9A-F]{4})$')
DW_NUM = re.compile(r'^\tdw (\$[0-9A-F]{4}(?:, \$[0-9A-F]{4})*)(?: ;.*)?$')
DW_ANY = re.compile(r'^\tdw (.*?)(?: ;.*)?$')
DB_NUM = re.compile(r'^\tdb ((?:\$[0-9A-F]{2})(?:, \$[0-9A-F]{2})*)(?: ;.*)?$')
DB_ANY = re.compile(r'^\tdb (.*?)(?: ;.*)?$')
LABEL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::?(?: ;.*)?$')
PTR_WORDS = re.compile(r'pointer', re.I)
PTR_WORDS_NO = re.compile(r'not ROM pointer|SRAM|WRAM|BANK \d|other bank|far pointer|HYPOTHESIS', re.I)

# Record tables whose region note states the layout.  key = (file, start address of the region);  layout = one record as fields:
#   'p' = own-bank pointer (2 bytes -> dw Label), 'b' = one plain byte (db $xx), 'q' = far pointer `dw addr ; db bank` (3 bytes) whose bank
#   the note names (`far_bank`): written `dw Label` + `db BANK(Label)`.  `note` = regex the region header must still match;
#   `tail` = trailing bytes that stay `db` (a terminator).
RECORDS = [
    dict(file='engine/startup/notice_pages.asm', start=0x4BE2, layout='pbbbb', note=r'23 records x 6 bytes: 16-bit pointer to a dialogue string',
         why='23 records x 6 bytes: 16-bit pointer to a dialogue string + 4 bytes'),
    dict(file='engine/startup/notice_pages.asm', start=0x4C6C, layout='p', note=r'the 24th string pointer of Data_65_4BE2',
         why='"24 56 = word 5624, the 24th string pointer of Data_65_4BE2"'),
    dict(file='engine/text/font_8x16.asm', start=0x4810, layout='bbbp', note=r'27 five-byte records \(key16 little-endian = SJIS code where a glyph run starts, bank byte \$48, glyph-run pointer16\)',
         why='27 five-byte records (key16, bank byte $48, glyph-run pointer16) + $FFFF terminator', tail=2),
    dict(file='engine/browser/menus.asm', start=0x6AEC, layout='bbbbbp', note=r'2 records of 7 bytes \(dw, db, dw, dw\).*last word of each record points at the strings 72:6AFA',
         why='2 records of 7 bytes (dw, db, dw, dw): last word points at the strings 72:6AFA / 72:6B23'),
    dict(file='engine/browser/menus.asm', start=0x6B4C, layout='bbbbbp', note=r'4 records of 7 bytes \(dw, db, dw, dw\).*last word of every record points into the strings at 72:6B68',
         why='4 records of 7 bytes (dw, db, dw, dw): last word of every record points into the strings at 72:6B68..'),
]
for _i, _start in enumerate((0x6581, 0x65A0, 0x65BF, 0x65DE, 0x65FD)):
    RECORDS.append(dict(file='engine/browser/frame_graphics.asm', start=_start, layout='qqqqq' + 'b' * 16, far_bank=0x47,
                        note=r'screen descriptor of the table 4E:654B \(31 bytes = 5 far pointers `dw addr ; db bank` \(15 bytes\) \+ 16 bytes of parameters\).*inside bank 47 blocks',
                        why='screen descriptor: 5 far pointers `dw addr ; db bank` into bank 47 + 16 parameter bytes'))


def esc_len(s):
    """Byte length of the content of a quoted string of the source (cp932; \\" \\\\ \\{ \\} are one byte)."""
    out = 0
    i = 0
    while i < len(s):
        if s[i] == '\\' and i + 1 < len(s):
            i += 2
            out += 1
            continue
        out += len(s[i].encode('cp932'))
        i += 1
    return out


def db_size(args):
    """Bytes of a `db` argument list (quoted strings and numbers), or None if it has something else."""
    n = 0
    for tok in re.findall(r'"(?:\\.|[^"\\])*"|[^,\s][^,]*', args):
        tok = tok.strip()
        if tok.startswith('"'):
            n += esc_len(tok[1:-1])
        elif re.match(r'^\$[0-9A-Fa-f]{1,2}$|^\d+$', tok):
            n += 1
        else:
            return None
    return n


def load_sym(path):
    """{(bank, addr): [names]} of the global labels, in file order."""
    d = collections.defaultdict(list)
    for line in open(path, encoding='utf-8'):
        m = re.match(r'^([0-9a-f]{2}):([0-9a-f]{4}) (\S+)$', line.strip())
        if m and '.' not in m.group(3) and m.group(3)[0] != '@':
            d[(int(m.group(1), 16), int(m.group(2), 16))].append(m.group(3))
    return d


def pick(names):
    sem = [n for n in names if not GENERIC.match(n)]
    return (sem or names)[0]


class File:
    def __init__(self, path):
        self.path = path
        self.rel = os.path.relpath(path, ROOT).replace(os.sep, '/')
        self.lines = open(path, encoding='utf-8').read().split('\n')
        self.bank = None
        for l in self.lines[:5]:
            m = G.BANK_RE.match(l)
            if m:
                self.bank = int(m.group(1), 16)
                break
        self.regions = []       # dict(kind, start, end, hi, note, first, last)  first/last = line span of the region up to the next header
        self.strings = {}       # address -> line index of a `db` line of a text block that starts there
        self._scan()

    def _scan(self):
        hdr = [i for i, l in enumerate(self.lines) if G.REGION_RE.match(l)]
        for n, hi in enumerate(hdr):
            m = G.REGION_RE.match(self.lines[hi])
            note = self.lines[hi][len(m.group(0)):]
            end_line = hdr[n + 1] if n + 1 < len(hdr) else len(self.lines)
            reg = dict(kind=m.group(1), start=int(m.group(2), 16), end=int(m.group(3), 16), size=int(m.group(4)), hi=hi, note=note,
                       status=m.group(5), stop=end_line)
            self.regions.append(reg)
            if reg['kind'] == 'text':
                addr = reg['start']
                for j in range(hi + 1, end_line):
                    md = DB_ANY.match(self.lines[j])
                    if md:
                        n_b = db_size(md.group(1))
                        if n_b is None:
                            break
                        if addr < reg['end']:
                            self.strings[addr] = j
                        addr += n_b
                        if addr >= reg['end']:
                            break
                    elif self.lines[j].startswith('\tds '):
                        break


def label_at(f, j):
    """The global label directly above line j (labels and address comments only), or None."""
    k = j - 1
    names = []
    while k >= 0 and (LABEL.match(f.lines[k]) or f.lines[k] == 'PUSHC sjis'):
        m = LABEL.match(f.lines[k])
        if m:
            names.append(m.group(1))
        k -= 1
    return names


class Tool:
    def __init__(self, sym):
        self.sym = sym
        self.files = [File(p) for p in G.source_files() if G.is_code_file(p)]
        self.by_bank_strings = collections.defaultdict(dict)     # bank -> {addr: (File, line)}
        for f in self.files:
            for a, j in f.strings.items():
                self.by_bank_strings[f.bank][a] = (f, j)
        self.new_labels = {}     # (bank, addr) -> name  (assigned in this run)
        self.edits = collections.defaultdict(dict)   # path -> {line index: [replacement lines]}
        self.inserts = collections.defaultdict(lambda: collections.defaultdict(list))   # path -> {line index: [lines before it]}
        self.report = []
        self.skipped = []

    def resolve(self, bank, addr, may_add=True):
        """(name, new_label_plan) for the target bank:addr, or (None, why)."""
        names = self.sym.get((bank, addr))
        if names:
            return pick(names), None
        if (bank, addr) in self.new_labels:
            return self.new_labels[(bank, addr)], None
        if may_add and addr in self.by_bank_strings.get(bank, {}):
            name = 'String_%02X_%04X' % (bank, addr)
            f, j = self.by_bank_strings[bank][addr]
            return name, (f, j, name)
        return None, 'no label at %02X:%04X and not the start of a string line' % (bank, addr)

    def add_label(self, plan):
        f, j, name = plan
        bank = f.bank
        addr = [a for a, jj in f.strings.items() if jj == j][0]
        if (bank, addr) in self.new_labels:
            return
        self.new_labels[(bank, addr)] = name
        self.inserts[f.path][j].append('%s:: ; %02X:%04X' % (name, bank, addr))

    # ------------------------------------------------------------------ ptrtable / words
    def do_ptr_regions(self):
        for f in self.files:
            for reg in f.regions:
                pointerish = reg['kind'] == 'ptrtable' or (reg['kind'] == 'words' and PTR_WORDS.search(reg['note'])
                                                           and not PTR_WORDS_NO.search(reg['note']))
                if not pointerish:
                    continue
                dws = []
                bad = False
                for j in range(reg['hi'] + 1, reg['stop']):
                    l = f.lines[j]
                    m = DW_ANY.match(l)
                    if m:
                        for k, tok in enumerate(m.group(1).split(', ')):
                            dws.append((j, tok))
                    elif l.startswith('\tdb ') or (l.startswith('\t') and l.strip() and not l.startswith('\t;')):
                        break
                num = [(j, t) for j, t in dws if re.match(r'^\$[0-9A-F]{4}$', t)]
                if not num:
                    continue
                if sum(len(DW_ANY.match(f.lines[j]).group(1).split(', ')) for j in {j for j, _ in dws}) != len(dws):
                    continue
                total = reg['size'] // 2
                where = '%s %02X:%04X' % (f.rel, f.bank, reg['start'])
                if len(dws) != total:
                    self.skipped.append((where, 'ptrtable: %d dw entries, header says %d bytes' % (len(dws), reg['size'])))
                    continue
                plans, names_for, why = [], {}, None
                for j, t in num:
                    name, plan = self.resolve(f.bank, int(t[1:], 16))
                    if name is None:
                        why = plan
                        break
                    names_for[(j, t)] = name
                    if plan:
                        plans.append(plan)
                if why:
                    self.skipped.append((where, '%s (%d numeric entries, first unresolved: %s)' % (why, len(num), next(t for j, t in num if (j, t) not in names_for))))
                    continue
                for plan in plans:
                    self.add_label(plan)
                for j in {j for j, _ in num}:
                    m = DW_ANY.match(f.lines[j])
                    toks = m.group(1).split(', ')
                    newt = [names_for.get((j, t), t) for t in toks]
                    tail = f.lines[j][len('\tdw ' + m.group(1)):]
                    self.edits[f.path][j] = ['\tdw ' + ', '.join(newt) + tail]
                self.report.append((where, reg['kind'], '%d entries -> labels (%d new String labels)' % (len(num), len(plans))))

    # ------------------------------------------------------------------ record tables
    def do_records(self):
        for spec in RECORDS:
            f = next((x for x in self.files if x.rel == spec['file']), None)
            reg = next((r for r in f.regions if r['start'] == spec['start']), None) if f else None
            where = '%s %02X:%04X' % (spec['file'], f.bank if f else 0, spec['start'])
            if reg is None or reg['kind'] != 'data' or not re.search(spec['note'], reg['note']):
                self.skipped.append((where, 'record table: header no longer matches the documented note (already converted, or edited)'))
                continue
            idx, data = [], bytearray()
            for j in range(reg['hi'] + 1, reg['stop']):
                m = DB_NUM.match(f.lines[j])
                if m:
                    idx.append(j)
                    data += bytes(int(x[1:], 16) for x in m.group(1).split(', '))
                elif f.lines[j].startswith('\t') and f.lines[j].strip() and not f.lines[j].startswith('\t;'):
                    break
                if len(data) >= reg['size']:
                    break
            if len(data) != reg['size'] or not idx:
                self.skipped.append((where, 'record table: %d db bytes, header says %d' % (len(data), reg['size'])))
                continue
            layout = spec['layout']
            rec_len = sum({'p': 2, 'q': 3, 'b': 1}[c] for c in layout)
            tail = spec.get('tail', 0)
            n_rec = (len(data) - tail) // rec_len
            if n_rec * rec_len + tail != len(data):
                self.skipped.append((where, 'record table: %d bytes do not fit %d records of %d + %d' % (len(data), n_rec, rec_len, tail)))
                continue
            new, plans, why = [], [], None
            for r in range(n_rec):
                rec = data[r * rec_len:(r + 1) * rec_len]
                run, pos = [], 0
                for c in layout:
                    if c == 'b':
                        run.append(rec[pos])
                        pos += 1
                        continue
                    if run:
                        new.append('\tdb ' + ', '.join('$%02X' % x for x in run))
                        run = []
                    addr = rec[pos] | rec[pos + 1] << 8
                    bank = f.bank if c == 'p' else spec['far_bank']
                    if c == 'q' and rec[pos + 2] != spec['far_bank']:
                        why = 'record %d: bank byte $%02X is not the documented $%02X' % (r, rec[pos + 2], spec['far_bank'])
                        break
                    name, plan = self.resolve(bank, addr)
                    if name is None:
                        why = '%s (record %d pointer $%04X)' % (plan, r, addr)
                        break
                    if plan:
                        plans.append(plan)
                    new.append('\tdw ' + name)
                    if c == 'q':
                        new.append('\tdb BANK(%s)' % name)
                        pos += 3
                    else:
                        pos += 2
                if why:
                    break
                if run:
                    new.append('\tdb ' + ', '.join('$%02X' % x for x in run))
            if why:
                self.skipped.append((where, 'record table: ' + why))
                continue
            if tail:
                new.append('\tdb ' + ', '.join('$%02X' % x for x in data[len(data) - tail:]))
            for plan in plans:
                self.add_label(plan)
            self.edits[f.path][idx[0]] = new
            for j in idx[1:]:
                self.edits[f.path][j] = []
            self.report.append((where, 'records', '%d records -> dw Label + db (%d new String labels); %s' % (n_rec, len(plans), spec['why'])))

    def apply(self):
        changed = {}
        for f in self.files:
            if f.path not in self.edits and f.path not in self.inserts:
                continue
            out = []
            for j, l in enumerate(f.lines):
                out += self.inserts.get(f.path, {}).get(j, [])
                out += self.edits.get(f.path, {}).get(j, [l])
            changed[f.path] = '\n'.join(out)
        return changed


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--dry-run', action='store_true')
    ap.add_argument('--no-verify', action='store_true')
    ap.add_argument('-v', '--verbose', action='store_true')
    a = ap.parse_args()
    sympath = os.path.join(ROOT, 'build', 'mobile_trainer.sym')
    if not os.path.exists(sympath):
        sys.exit('build/mobile_trainer.sym is missing: run make first')
    t = Tool(load_sym(sympath))
    t.do_ptr_regions()
    t.do_records()
    for w, k, msg in t.report:
        print('%-56s %-9s %s' % (w, k, msg))
    if a.verbose or a.dry_run:
        for w, why in t.skipped:
            print('skipped %-50s %s' % (w, why))
    changed = t.apply()
    print('%d tables converted, %d skipped, %d files' % (len(t.report), len(t.skipped), len(changed)))
    if not changed or a.dry_run:
        return 0
    old = {p: open(p, encoding='utf-8').read() for p in changed}
    for p, s in changed.items():
        open(p, 'w', encoding='utf-8').write(s)
    if a.no_verify:
        return 0
    r = subprocess.run(['make', '-j8', 'checkhash'], cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    import hashlib
    want = open(os.path.join(ROOT, 'roms.sha256')).read().split()[0]
    got = hashlib.sha256(open(os.path.join(ROOT, 'mobile_trainer.gbc'), 'rb').read()).hexdigest() if r.returncode == 0 else None
    warn = [l for l in r.stdout.split('\n') if ': warning' in l or ': error' in l or l.startswith(('warning', 'error'))]
    if warn:
        print('\n'.join(warn[:20]))
    if got != want:
        print(r.stdout[-2000:])
        print('VERIFY FAILED: restoring the files')
        for p, s in old.items():
            open(p, 'w', encoding='utf-8').write(s)
        return 1
    print('SHA-256 OK: the pointer tables assemble to the original ROM')
    return 0


if __name__ == '__main__':
    sys.exit(main())
