#!/usr/bin/env python3
"""Generate constants/sjis_charmap.asm, the RGBDS charmaps used to write the ROM's text as readable strings.

Why: the Mobile Trainer's text is Shift-JIS (docs/research/text_encoding.md).  With a multi-byte RGBDS charmap
`charmap "メ", $83, $81` the source can say  db "メール", 0  and rgbasm produces the original bytes.

What is generated (only characters that occur in the ROM's text regions; nothing else is invented):

  sjis     ASCII 20-7E identity (0x5C = yen sign and 0x7E = overline as in the 6x12 Latin font, text_encoding.md
           section 3) + every JIS X 0208 double-byte character that occurs in a text region
  sjis_hw  sjis + the single bytes A1-DF as half-width katakana in JIS X 0201 order, for bank 6C
           (the "second convention", text_encoding.md section 6: PROBABLE that the strings read as Japanese
           this way, HYPOTHESIS which glyph the byte draws; the charmap only names the bytes)

Bytes that are not a plain character (control bytes < 20, 7F, gaiji F8-FF, unknown singles, undecodable pairs) get NO charmap
entry: the sources write them as explicit  $xx  tokens between the quoted parts:  db "ホーム", $FA, "みます", 0

Input: the ROM (bytes) and the region headers of the source files (`; ---- text $4000-$4F53 (..)`, `; bank 3E, ...`);
the ROM is only read: baserom.gbc, "Mobile Trainer (Japan).gbc" or, if neither is there, mobile_trainer.gbc
(identical by SHA-256).  Deterministic: same ROM + same headers -> same file.

    python3 tools/gen_sjis_charmap.py              # write constants/sjis_charmap.asm
    python3 tools/gen_sjis_charmap.py --check      # exit 1 if the file on disk differs from what would be generated
    python3 tools/gen_sjis_charmap.py --stats      # per-file / per-row statistics, nothing written

The tokenizer and the region rules live here and are shared with tools/text_to_strings.py.
"""
import argparse
import collections
import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, 'constants', 'sjis_charmap.asm')
ROM_CANDIDATES = ['baserom.gbc', 'Mobile Trainer (Japan).gbc', 'mobile_trainer.gbc']

# source files that contain text (relative to the repository root); data/fonts/** belongs to the graphics side
TEXT_GLOBS = ['data/text/*.asm', 'data/html/*.asm', 'data/keyboard/*.asm']

REGION_RE = re.compile(r'^; ---- (\w+) \$([0-9A-F]{4})-\$([0-9A-F]{4}) \((\d+) bytes\) \[(\w+)\]')
BANK_RE = re.compile(r'^; bank ([0-9A-F]{2}),')

HW_BANKS = {0x6C}  # the bank(s) that use the single-byte A1-DF convention


# ------------------------------------------------------------------------------------------------ tokenizer
# Token = (kind, value, nbytes):  ('c', 'メ', 2)  a character with a charmap entry;  ('b', 0x0D, 1)  a raw byte.

def lead_ok(b):
    """Lead bytes of JIS X 0208 rows 1-84 (81-84 rows 1-8, 88-9F, E0-EA) and NEC row 13 (87).  85/86 (empty rows) and
    EB-EF (rows 85+), F0-F9 (user/gaiji) are not characters."""
    return 0x81 <= b <= 0x84 or b == 0x87 or 0x88 <= b <= 0x9F or 0xE0 <= b <= 0xEA


def trail_ok(b):
    return 0x40 <= b <= 0x7E or 0x80 <= b <= 0xFC


def decode_pair(b1, b2, hw=False):
    """The character of a Shift-JIS pair, or None if it is not a plain JIS X 0208 character that round-trips."""
    if not (lead_ok(b1) and trail_ok(b2)) or (hw and b1 >= 0xA0):
        return None
    try:
        ch = bytes([b1, b2]).decode('cp932')
    except UnicodeDecodeError:
        return None
    if len(ch) != 1:
        return None
    o = ord(ch)
    if 0xE000 <= o <= 0xF8FF:  # private use
        return None
    if ch.encode('cp932') != bytes([b1, b2]):  # duplicate code points (NEC/IBM extensions): keep one spelling
        return None
    return ch


def ascii_char(b):
    """Character for a single byte 20-7E (yen/overline for 5C/7E as in the Latin font), else None."""
    if b == 0x5C:
        return '¥'
    if b == 0x7E:
        return '‾'
    if 0x20 <= b <= 0x7D:
        return chr(b)
    return None


def hw_char(b):
    """JIS X 0201 half-width katakana for A1-DF (U+FF61..U+FF9F)."""
    if 0xA1 <= b <= 0xDF:
        return chr(0xFF61 + b - 0xA1)
    return None


def tokenize(data, hw=False, arg1=False):
    """Split bytes into characters and raw bytes, left to right.

    Default convention (text_encoding.md sections 1-2, the engine's lead-byte rule at 00:0F31): single bytes 20-7E are
    characters, lead 81-9F / E0-EA + trail is a double-byte character.
    hw convention (bank 6C, section 6): single bytes A1-DF are half-width katakana, lead 81-9F + trail is a double-byte
    character, and every other byte (20-7E singles, E0-FF singles, control bytes, the 6-byte `06 xx yy 03 aa bb` string
    header) is a raw byte: the note infers that E0-FF are extra kana (HYPOTHESIS), so no character is claimed for them.
    arg1 (data/keyboard/): the byte after $01 is its argument (`01 20`, `01 0D` are inline controls there), so it stays raw."""
    out = []
    i = 0
    n = len(data)
    while i < n:
        b = data[i]
        if arg1 and b == 0x01 and i + 1 < n:
            out += [('b', 0x01, 1), ('b', data[i + 1], 1)]
            i += 2
            continue
        if hw:
            if b == 0x06 and i + 5 < n and data[i + 3] == 0x03:
                out += [('b', x, 1) for x in data[i:i + 6]]
                i += 6
                continue
            c = hw_char(b)
            if c is not None:
                out.append(('c', c, 1))
                i += 1
                continue
        else:
            c = ascii_char(b)
            if c is not None:
                out.append(('c', c, 1))
                i += 1
                continue
        if i + 1 < n:
            c = decode_pair(b, data[i + 1], hw)
            if c is not None:
                out.append(('c', c, 2))
                i += 2
                continue
        out.append(('b', b, 1))
        i += 1
    return out


def strict_text(tokens):
    """A run is a 'clean string' when it is only characters (>= 1 double-byte or half-width one) and NUL terminators."""
    if not tokens or tokens[-1] != ('b', 0, 1):
        return False
    wide = False
    prev_nul = True
    for t in tokens:
        if t[0] == 'b':
            if t[1] != 0 or prev_nul:  # any other raw byte, or an empty string, is not clean text
                return False
            prev_nul = True
        else:
            prev_nul = False
            if t[2] == 2 or ord(t[1]) >= 0xFF61:
                wide = True
    return wide


def parse_items(data):
    """[ASCII name][NUL][value byte] items that tile `data` exactly (data/html/keywords.asm), or None."""
    items = []
    i = 0
    while i < len(data):
        j = data.find(b'\0', i)
        if j <= i or j + 1 >= len(data):
            return None
        name = data[i:j]
        if not all(0x21 <= c <= 0x7D for c in name):
            return None
        items.append((name.decode('ascii'), data[j + 1]))
        i = j + 2
    return items or None


# ------------------------------------------------------------------------------------------------ regions of the source files

class Region:
    def __init__(self, path, bank, kind, start, end, header, status):
        self.path, self.bank, self.kind, self.start, self.end = path, bank, kind, start, end
        self.header, self.status = header, status

    @property
    def size(self):
        return self.end - self.start

    @property
    def hw(self):
        return self.bank in HW_BANKS

    @property
    def arg1(self):
        return os.path.relpath(self.path, ROOT).replace(os.sep, '/').startswith('data/keyboard/')

    @property
    def where(self):
        return '%02X:%04X' % (self.bank, self.start)


def source_files(root=ROOT):
    files = []
    for g in TEXT_GLOBS:
        files += glob.glob(os.path.join(root, g))
    return sorted(files)


def file_regions(path):
    """Regions announced by `; ---- kind $a-$b (n bytes) [STATUS]` headers of one source file."""
    bank = None
    regs = []
    for line in open(path, encoding='utf-8'):
        line = line.rstrip('\n')
        m = BANK_RE.match(line)
        if m and bank is None:
            bank = int(m.group(1), 16)
            continue
        m = REGION_RE.match(line)
        if m:
            regs.append(Region(path, bank, m.group(1), int(m.group(2), 16), int(m.group(3), 16), line, m.group(5)))
    return regs


def classify(region, data):
    """How the converter treats a region: 'text', 'items' or None (left as it is).

    * kind `text` (analysis/strings.tsv strings, whole region as tokens);
    * kind `data` in data/text/: only when the bytes are clean NUL-terminated strings (strict_text), e.g. a ticker entry
      that was clipped out of a text block by executed-read evidence;
    * kind `data` in data/html/keywords.asm whose header states the [ASCII name][NUL][value byte] item format and whose
      bytes tile exactly as such items.
    Everything else (tables, records, keyboard cell data, images) is not provably text and stays db."""
    rel = os.path.relpath(region.path, ROOT).replace(os.sep, '/')
    if region.kind == 'text':
        return 'text'
    if region.kind == 'data':
        if rel.startswith('data/text/') and strict_text(tokenize(data, region.hw, region.arg1)):
            return 'text'
        if rel == 'data/html/keywords.asm' and 'items [ASCII name][NUL][value byte]' in region.header \
                and parse_items(data) is not None:
            return 'items'
    return None


def find_rom(root=ROOT, explicit=None):
    if explicit:
        return explicit
    for name in ROM_CANDIDATES:
        p = os.path.join(root, name)
        if os.path.exists(p):
            return p
    sys.exit('no ROM found (%s)' % ', '.join(ROM_CANDIDATES))


def rom_bytes(rom, region):
    off = region.bank * 0x4000 + (region.start - 0x4000)
    return rom[off:off + region.size]


def collect(rom):
    """{path: [(region, mode, bytes)]} for every source region that is converted."""
    res = collections.OrderedDict()
    for path in source_files():
        for r in file_regions(path):
            data = rom_bytes(rom, r)
            mode = classify(r, data)
            if mode:
                res.setdefault(path, []).append((r, mode, data))
    return res


# ------------------------------------------------------------------------------------------------ charmap file

def esc(ch):
    """Character as it is written between the quotes of an RGBDS string."""
    if ch == '"':
        return '\\"'
    if ch == '\\':
        return '\\\\'
    if ch in '{}':
        return '\\' + ch
    return ch


ROW_NAMES = {
    1: 'symbols', 2: 'symbols', 3: 'digits and Latin letters', 4: 'hiragana', 5: 'katakana', 6: 'Greek', 7: 'Cyrillic',
    8: 'box drawing', 13: 'NEC row 13',
}


def section_of(code):
    """(sort key, title) of a double-byte code: its JIS X 0208 row (1-94) or NEC row 13."""
    b1, b2 = code >> 8, code & 0xFF
    if b1 >= 0xE0:
        row = (b1 - 0xC1) * 2 + 1 + (b2 >= 0x9F)
    else:
        row = (b1 - 0x81) * 2 + 1 + (b2 >= 0x9F)
    if row in ROW_NAMES:
        title = 'JIS X 0208 row %d (%s)' % (row, ROW_NAMES[row])
    elif 16 <= row <= 47:
        title = 'JIS X 0208 row %d (kanji level 1)' % row
    elif 48 <= row <= 84:
        title = 'JIS X 0208 row %d (kanji level 2)' % row
    else:
        title = 'JIS X 0208 row %d' % row
    return row, title


def build_charmap(collected, rom):
    """(text of constants/sjis_charmap.asm, statistics)"""
    wide = collections.Counter()      # code -> uses
    hw = collections.Counter()        # byte -> uses
    for path, lst in collected.items():
        for r, mode, data in lst:
            if mode != 'text':
                continue
            for kind, val, n in tokenize(data, r.hw, r.arg1):
                if kind != 'c':
                    continue
                if n == 2:
                    wide[data_code(val)] += 1
                elif ord(val) >= 0xFF61:
                    hw[ord(val) - 0xFF61 + 0xA1] += 1
    out = []
    w = out.append
    w('; constants/sjis_charmap.asm -- generated by tools/gen_sjis_charmap.py (do not edit; regenerate).')
    w(';')
    w('; RGBDS charmaps that let the text of data/ be written as readable strings:  db "メール", 0')
    w('; The ROM text is Shift-JIS (docs/research/text_encoding.md).  Only characters that occur in the ROM\'s text regions are')
    w('; listed; a byte that is not a plain character (control codes, 7F, gaiji F8-FF, unknown singles) is written as $xx between')
    w('; the quoted parts, e.g.  db "ホーム", $FA, "みます", 0.')
    w(';')
    w(';   sjis     ASCII 20-7E (5C = yen sign, 7E = overline, as in the 6x12 Latin font) + the double-byte characters seen')
    w(';   sjis_hw  sjis + single bytes A1-DF as JIS X 0201 half-width katakana (bank 6C, the "second convention", section 6')
    w(';            of the text encoding note: PROBABLE that the strings read as Japanese this way, HYPOTHESIS which glyph')
    w(';            a byte draws; the charmap only names the bytes)')
    w(';')
    w('; Discipline: this file leaves the default charmap `main` active.  A data file that has strings starts with')
    w('; `PUSHC sjis` (or `sjis_hw`) and ends with `POPC`, so the charmap never leaks into code (STYLE.md, "Text").')
    w('')
    w('NEWCHARMAP sjis')
    w('')
    w('; ---- ASCII / JIS X 0201 Roman single bytes')
    for b in range(0x20, 0x7F):
        w('\tcharmap "%s", $%02X' % (esc(ascii_char(b)), b))
    cur = None
    for code in sorted(wide):
        row, title = section_of(code)
        if row != cur:
            cur = row
            w('')
            w('; ---- %s' % title)
        w('\tcharmap "%s", $%02X, $%02X' % (esc(code_char(code)), code >> 8, code & 0xFF))
    w('')
    w('NEWCHARMAP sjis_hw, sjis')
    w('')
    w('; ---- single bytes A1-DF as JIS X 0201 half-width katakana (order only; glyphs unproven)')
    for b in sorted(hw):
        w('\tcharmap "%s", $%02X' % (chr(0xFF61 + b - 0xA1), b))
    w('')
    w('; back to the default charmap: code and data without text see no mapping')
    w('SETCHARMAP main')
    stats = {'wide': len(wide), 'hw': len(hw), 'wide_uses': sum(wide.values()), 'hw_uses': sum(hw.values()),
             'wide_counter': wide, 'hw_counter': hw}
    return '\n'.join(out) + '\n', stats


def data_code(ch):
    b = ch.encode('cp932')
    return b[0] << 8 | b[1]


def code_char(code):
    return bytes([code >> 8, code & 0xFF]).decode('cp932')


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--rom', help='ROM to read (default: baserom.gbc, "Mobile Trainer (Japan).gbc", mobile_trainer.gbc)')
    ap.add_argument('--check', action='store_true', help='compare with the file on disk instead of writing')
    ap.add_argument('--stats', action='store_true', help='print statistics, write nothing')
    ap.add_argument('-o', '--out', default=OUT)
    args = ap.parse_args()
    romp = find_rom(explicit=args.rom)
    rom = open(romp, 'rb').read()
    collected = collect(rom)
    text, st = build_charmap(collected, rom)
    if args.stats:
        for path, lst in collected.items():
            print('%-40s %3d regions, %6d bytes' % (os.path.relpath(path, ROOT), len(lst), sum(len(d) for _, _, d in lst)))
        print('double-byte characters: %d distinct, %d uses; half-width katakana: %d distinct, %d uses'
              % (st['wide'], st['wide_uses'], st['hw'], st['hw_uses']))
        return 0
    if args.check:
        cur = open(args.out, encoding='utf-8').read() if os.path.exists(args.out) else ''
        if cur != text:
            print('%s is stale: run python3 tools/gen_sjis_charmap.py' % os.path.relpath(args.out, ROOT))
            return 1
        print('%s is up to date (%d double-byte + %d half-width characters)' % (os.path.relpath(args.out, ROOT), st['wide'], st['hw']))
        return 0
    with open(args.out, 'w', encoding='utf-8') as f:
        f.write(text)
    print('wrote %s: %d double-byte characters (%d uses), %d half-width katakana (%d uses), from %s'
          % (os.path.relpath(args.out, ROOT), st['wide'], st['wide_uses'], st['hw'], st['hw_uses'], os.path.basename(romp)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
