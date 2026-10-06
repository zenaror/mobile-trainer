#!/usr/bin/env python3
"""Shared helpers of the graphics retyping scripts (tools/retype_blobs.py, tools/retype_palettes.py).

Run them from the root of a built repository copy that holds `Mobile Trainer (Japan).gbc` (`make` first: build/mobile_trainer.sym is read).
Everything a header states about a load is taken from the code, not typed by hand: the loading calls are the rows of gfx/previews/screen_ops.tsv
(written by tools/render_screens.py ops), their ROM addresses come from tools/line_addresses.py (one build of a marked copy, cached per commit) and
whether a call ran in the natural scenarios comes from analysis/coverage_union.tsv.
"""
import hashlib
import json
import os
import re
import subprocess
import sys

HDR = re.compile(r'^; ---- (\w+) \$([0-9A-F]+)-\$([0-9A-F]+) \((\d+) bytes\) \[(\w+)\] ?(.*)$')
LABEL_LINE = re.compile(r'^([A-Za-z_]\w*)::(?: *; ([0-9A-F]{2}):([0-9A-F]{4}))?\s*$')
NEUTRAL = re.compile(r'^(?:Data|Palette|Table|Tilemap|Gfx|String|Words|Attrmap)_[0-9A-F]{2}_[0-9A-F]{4}$')

ROM = open('Mobile Trainer (Japan).gbc', 'rb').read()


def rom(bank, a, n):
    off = bank * 0x4000 + (a - 0x4000)
    assert 0x4000 <= a and a + n <= 0x8000, (bank, a, n)
    return ROM[off:off + n]


def db_lines(data, cuts=()):
    """`db` lines of 16 bytes (a list of lines); a line also ends at every offset in `cuts`, where the caller puts a label."""
    cuts = sorted(set(c for c in cuts if 0 < c < len(data)))
    out, pos = [], 0
    for end in cuts + [len(data)]:
        for i in range(pos, end, 16):
            out.append('\tdb ' + ', '.join('$%02X' % b for b in data[i:min(i + 16, end)]))
        pos = end
    return out


def words(data):
    return [data[i] | (data[i + 1] << 8) for i in range(0, len(data) - 1, 2)]


def valid_palette(data):
    return len(data) >= 2 and len(data) % 2 == 0 and all(w < 0x8000 for w in words(data))


def read_sym():
    sym = {}
    for l in open('build/mobile_trainer.sym', encoding='utf-8'):
        m = re.match(r'^([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) (\S+)$', l.strip())
        if m:
            sym[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    return sym


class Op:
    """One loading call of gfx/previews/screen_ops.tsv: kind 'palette' (n = bc) or 'tilemap' (n = bytes of the pair)."""

    def __init__(self, routine, file, line, kind, lab, bank, addr, n, dest, text):
        self.routine, self.file, self.line, self.kind, self.lab = routine, file, line, kind, lab
        self.bank, self.addr, self.n, self.dest, self.text = bank, addr, n, dest, text

    def __repr__(self):
        return 'Op(%s:%d %s %02X:%04X n=%d dest=%s)' % (self.file, self.line, self.kind, self.bank, self.addr, self.n, self.dest and '$%04X' % self.dest)


def read_ops(sym):
    ops = []
    for l in open('gfx/previews/screen_ops.tsv', encoding='utf-8'):
        if l.startswith('#') or not l.strip():
            continue
        c = l.rstrip('\n').split('\t')
        if len(c) < 6 or c[2] not in ('palette', 'tilemap'):
            continue
        routine, site, kind, lab, bank, det = c[:6]
        f, ln = site.rsplit(':', 1)
        if kind == 'palette':
            n = int(re.search(r'n=(\d+)', det).group(1))
        else:
            n = int(re.search(r'rows=(\d+)', det).group(1)) * int(re.search(r'cols=(\d+)', det).group(1)) * 2
        m = re.match(r'^(\S+?)(?: \+ \$([0-9A-Fa-f]+))?$', lab.strip())
        name, off = m.group(1), (int(m.group(2), 16) if m.group(2) else 0)
        if name in sym:
            b, a = sym[name][0], sym[name][1] + off
        else:
            m2 = re.match(r'^\$([0-9A-Fa-f]{4})$', name)
            if not m2:
                continue
            b, a = int(bank, 16), int(m2.group(1), 16) + off
        md = re.search(r'dest=\$([0-9A-Fa-f]{4})', det)
        ops.append(Op(routine, f, int(ln), kind, lab, b, a, n, int(md.group(1), 16) if md else None, det))
    return ops


def read_cov():
    cov = {}
    for l in open('analysis/coverage_union.tsv', encoding='utf-8'):
        if l.startswith('#'):
            continue
        c = l.rstrip('\n').split('\t')
        if len(c) >= 4 and re.match(r'^[0-9A-F]{2}$', c[0]):
            cov[(int(c[0], 16), int(c[1], 16))] = (int(c[2]), int(c[3]))
    return cov


def _norm(v):
    """(bank, addr) as integers (tools/line_addresses.py gives hex strings)."""
    return tuple(int(x, 16) if isinstance(x, str) else x for x in v)


def load_sites(ops, cache=None):
    """{'file:line': (bank, addr)} of every load call: one build of a marked copy (tools/line_addresses.py), cached per commit and per ops table."""
    head = subprocess.run(['git', 'rev-parse', 'HEAD'], capture_output=True, text=True).stdout.strip()
    key = head + ':' + hashlib.sha256(open('gfx/previews/screen_ops.tsv', 'rb').read()).hexdigest()[:16]
    cache = cache or os.environ.get('RETYPE_SITES_CACHE') or '/tmp/retype_sites_cache.json'
    if os.path.exists(cache):
        j = json.load(open(cache))
        if j.get('key') == key:
            return {k: _norm(v) for k, v in j['sites'].items()}
    sys.path.insert(0, 'tools')
    import line_addresses as la
    want = sorted(set((o.file, o.line) for o in ops))
    got = la.addresses('.', want)
    sites = {'%s:%d' % k: _norm(v) for k, v in got.items() if v}
    json.dump({'key': key, 'sites': {k: list(v) for k, v in sites.items()}}, open(cache, 'w'))
    return sites


def buf_name(dest):
    if dest is None:
        return 'a buffer'
    if 0xD800 <= dest < 0xD840:
        name, base = 'wPaletteBufBg', 0xD800
    elif 0xD840 <= dest < 0xD880:
        name, base = 'wPaletteBufObj', 0xD840
    else:
        return '$%04X' % dest
    return name if dest == base else '%s + $%02X' % (name, dest - base)


class Ctx:
    """Everything a pass needs: symbols, load calls, call addresses, coverage."""

    def __init__(self):
        self.sym = read_sym()
        self.ops = read_ops(self.sym)
        self.cov = read_cov()
        self.sites = load_sites(self.ops)

    def call_addr(self, op):
        return self.sites.get('%s:%d' % (op.file, op.line))

    def executed(self, op):
        """(executed in a natural scenario?, text) of the loading call of an op."""
        ad = self.call_addr(op)
        if not ad:
            return False, 'call address unknown'
        c = self.cov.get(ad)
        if c and c[0] > 0:
            return True, 'call %02X:%04X executed %d hits in %d scenarios (analysis/coverage_union.tsv)' % (ad[0], ad[1], c[0], c[1])
        return False, 'call %02X:%04X not executed in the traced runs (analysis/coverage_union.tsv)' % ad

    def reads_in(self, kind, bank, a, b):
        return [o for o in self.ops if o.kind == kind and o.bank == bank and a <= o.addr < b]

    def palette_note(self, bank, a, b, reads, overread_comment=None, max_sites=3):
        """(status, text after the status) of the palette block [a, b): what loads it, how many bytes each call takes, whether the calls ran.
        CONFIRMED when every load of it ran in a natural scenario and no call takes more bytes than the block has; PROBABLE otherwise."""
        n = b - a
        parts, all_ran = [], True
        over = 0
        for o in sorted(reads, key=lambda o: (o.addr, o.file, o.line)):
            ran, ct = self.executed(o)
            all_ran &= ran
            over = max(over, o.addr + o.n - b)
            if len(parts) < max_sites:
                parts.append('+$%02X bc=$%02X into %s (%s:%d, %s)' % (o.addr - a, o.n, buf_name(o.dest), o.file, o.line, ct))
        if len(reads) > max_sites:
            parts.append('and %d more load(s)' % (len(reads) - max_sites))
        text = 'palette-rgb555: %d colours (%d palettes) read by Palette_LoadToBuffer: %s' % (n // 2, n // 8, '; '.join(parts))
        if over > 0:
            first = sorted(reads, key=lambda o: (o.addr, o.file, o.line))[0]
            text += ('; the call takes %d bytes past the end of this block (%s); the length of %d bytes is by adjacency, not by the call'
                     % (over, overread_comment or 'the bytes behind it', n))
            return 'PROBABLE', text
        return ('CONFIRMED' if all_ran and reads else 'PROBABLE'), text


def read_lines(path):
    return open(path, encoding='utf-8').read().split('\n')


def write_lines(path, lines):
    open(path, 'w', encoding='utf-8').write('\n'.join(lines))
