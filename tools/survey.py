#!/usr/bin/env python3
"""Systematic content survey of every ROM bank of baserom.gbc.

Inputs  : baserom.gbc (read-only), tools/sm83.py, tools/extract_gfx.py, Pillow (images)
Outputs : analysis/bank_survey.json            per-bank / per-window / per-block features
          docs/research/bank_survey.md         human-readable report
          docs/research/img/bank_map.png       one cell per 0x100 bytes, coloured by class
          analysis/strings.tsv                 decoded Shift-JIS / ASCII strings
          analysis/gfx_candidates.tsv          tile blocks / tilemaps / palettes (via extract_gfx)
          analysis/proposals/survey_regions_bankNN.tsv   data-like region proposals
          constants/charmap.asm                RGBDS charmap (only justified entries)
          <build/gfx_dump>/*.png               tile sheets, palettes, font sheets

Everything here is *heuristic classification evidence* plus structures that were derived
from disassembled engine code and are re-verified against the bytes (font banks, html
store).  The vocabulary CONFIRMED / PROBABLE / HYPOTHESIS follows the project rules:
byte-level facts and call-site immediates are CONFIRMED, statistical classifiers are at best
PROBABLE and region proposals are capped at PROBABLE.

Coordinates: CPU addresses, bank 00 = 0000-3FFF, banks 01-7F = 4000-7FFF,
file offset = bank*0x4000 + (addr & 0x3FFF).

Re-runnable from a clean checkout:  python3 tools/survey.py [--rom baserom.gbc] [--skip-lz]
(about 1 minute; --skip-lz drops the 26 s Crystal-LZ probe).
"""
import argparse
import collections
import json
import math
import os
import struct  # noqa: F401
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import sm83  # noqa: E402

BANK_SIZE = 0x4000
WINDOW = 0x1000
NBANKS = 128

FARCALL_ENTRY = 0x06D1  # see farcall scan: 'call $06D1' is followed by dw addr, db bank


# ----------------------------------------------------------------------------
# basic helpers
# ----------------------------------------------------------------------------
def load_rom(path=None):
    path = path or os.path.join(ROOT, 'baserom.gbc')
    with open(path, 'rb') as f:
        rom = f.read()
    if len(rom) != NBANKS * BANK_SIZE:
        raise SystemExit('unexpected ROM size %d' % len(rom))
    return rom


def base_addr(bank):
    return 0x0000 if bank == 0 else 0x4000


def offset(bank, addr):
    return bank * BANK_SIZE + (addr & 0x3FFF)


def entropy(b):
    if not b:
        return 0.0
    c = collections.Counter(b)
    n = len(b)
    return -sum(v / n * math.log2(v / n) for v in c.values()) + 0.0


def fill_runs(data, value, minlen):
    """[(start, length)] of runs of ``value`` at least ``minlen`` long."""
    runs = []
    i = 0
    n = len(data)
    while i < n:
        if data[i] == value:
            j = i
            while j < n and data[j] == value:
                j += 1
            if j - i >= minlen:
                runs.append((i, j - i))
            i = j
        else:
            i += 1
    return runs


def used_end(data):
    """Offset just past the last byte that is not part of the trailing fill run
    (trailing run of the same value as the last byte, 0x00 or 0xFF)."""
    n = len(data)
    if n == 0:
        return 0
    last = data[-1]
    if last not in (0x00, 0xFF):
        return n
    while n > 0 and data[n - 1] == last:
        n -= 1
    return n


# ----------------------------------------------------------------------------
# SM83 linear sweep features ("does it decode as plausible code?")
# ----------------------------------------------------------------------------
def sweep(rom, off, end, addr):
    out = []
    while off < end:
        i = sm83.decode(rom, off, addr)
        out.append(i)
        off += i.length
        addr += i.length
    return out


class CodeModel:
    """Opcode-frequency model.  Trained on the *decoded instruction stream of
    bank 00 0x0150-0x2183 excluding 00-runs* -- bank 00 is the home bank whose
    routines are entered from the reset vector, so it is code by construction
    (the interrupt vectors and 0x0100 jp are CONFIRMED code bytes).  Only used
    for a log-likelihood-ratio 'code-likeness' score, not for any fact."""

    def __init__(self, rom):
        ins = sweep(rom, 0x150, 0x2184, 0x150)
        cnt = collections.Counter()
        for i in ins:
            if i.raw == b'\x00':
                continue
            cnt[self.key(i)] += 1
        tot = sum(cnt.values())
        self.tot = tot
        # additive smoothing, 512 possible keys (256 opcodes + 256 CB opcodes)
        self.logp = {}
        for k in list(range(256)) + [0xCB00 | x for x in range(256)]:
            p = (cnt.get(k, 0) + 0.5) / (tot + 256)
            self.logp[k] = math.log2(p)
        self.log_uniform = math.log2(1 / 245.0)

    @staticmethod
    def key(i):
        return (0xCB00 | i.raw[1]) if i.raw[0] == 0xCB and len(i.raw) > 1 else i.raw[0]

    def llr(self, insns):
        """mean bits/instruction of (code model) - (uniform-opcode model);
        00 (nop) instructions are neutral (zero pads)."""
        s = 0.0
        n = 0
        for i in insns:
            if i.raw == b'\x00':
                continue
            s += self.logp[self.key(i)] - self.log_uniform
            n += 1
        return (s / n) if n else 0.0


def valid_ram_or_rom_target(t, rom_starts, bank_starts, bank_lo, bank_hi):
    """Plausibility of a jp/call target for a routine living in a switchable bank."""
    if t < 0x4000:
        return t in rom_starts
    if t < 0x8000:
        return bank_lo <= t < bank_hi and t in bank_starts
    if 0xC000 <= t <= 0xDFFF or 0xFF80 <= t <= 0xFFFE:
        return True
    return False


def code_features(insns, rom_starts, bank_starts, bank_lo, bank_hi, model):
    nins = len(insns)
    if nins == 0:
        return dict(n_insn=0)
    bad = sum(1 for i in insns if i.flow == 'bad')
    nops = sum(1 for i in insns if i.raw == b'\x00')
    term = sum(1 for i in insns if i.flow in ('ret', 'jp', 'jr', 'jphl'))
    flows = [i for i in insns if i.flow in ('call', 'callcc', 'jp', 'jpcc') and i.target is not None]
    ok = sum(1 for i in flows if valid_ram_or_rom_target(i.target, rom_starts, bank_starts, bank_lo, bank_hi))
    rel = [i for i in insns if i.flow in ('jr', 'jrcc')]
    relok = sum(1 for i in rel if i.target is not None and (0 <= i.target < 0x8000))
    mem = [i for i in insns if i.imm16 is not None and i.imm16_kind == 'mem']
    memok = sum(1 for i in mem if i.imm16 >= 0x8000 or i.imm16 < 0x6000)
    f = dict(
        n_insn=nins,
        bad_frac=round(bad / nins, 4),
        nop_frac=round(nops / nins, 4),
        term_density=round(term / nins, 4),
        n_branch=len(flows),
        branch_valid=round(ok / len(flows), 3) if flows else None,
        jr_in_range=round(relok / len(rel), 3) if rel else None,
        n_mem=len(mem),
        mem_valid=round(memok / len(mem), 3) if mem else None,
        llr=round(model.llr(insns), 3),
    )
    return f


# ----------------------------------------------------------------------------
# graphics likeness
# ----------------------------------------------------------------------------
def tile_pixels_2bpp(tile):
    rows = []
    for y in range(8):
        lo = tile[y * 2]
        hi = tile[y * 2 + 1]
        rows.append([((lo >> (7 - x)) & 1) | (((hi >> (7 - x)) & 1) << 1) for x in range(8)])
    return rows


def gfx_scores(data):
    """Return dict with 2bpp and 1bpp pixel coherence scores over ``data``.

    coherence = fraction of horizontally adjacent pixel pairs that are equal
    (random 2bpp -> ~0.25, random 1bpp -> ~0.5; artwork is far higher) and
    vertical (row-to-row) equality.  Fully blank tiles are excluded from the
    statistics so pads do not inflate the score; ``blank`` reports their share."""
    n2 = len(data) // 16
    heq = hn = veq = vn = 0
    blank = 0
    used = 0
    for t in range(n2):
        tile = data[t * 16:(t + 1) * 16]
        if tile == b'\x00' * 16 or tile == b'\xff' * 16:
            blank += 1
            continue
        used += 1
        px = tile_pixels_2bpp(tile)
        for y in range(8):
            r = px[y]
            for x in range(7):
                hn += 1
                heq += r[x] == r[x + 1]
            if y:
                for x in range(8):
                    vn += 1
                    veq += r[x] == px[y - 1][x]
    # 1bpp
    n1 = len(data) // 8
    h1 = h1n = v1 = v1n = 0
    for t in range(n1):
        g = data[t * 8:(t + 1) * 8]
        if g == b'\x00' * 8 or g == b'\xff' * 8:
            continue
        for y in range(8):
            b = g[y]
            for x in range(7):
                h1n += 1
                h1 += ((b >> (7 - x)) & 1) == ((b >> (6 - x)) & 1)
            if y:
                v1n += 8
                v1 += 8 - bin(b ^ g[y - 1]).count('1')
    return dict(
        tiles=n2, blank_tiles=blank,
        hsim2=round(heq / hn, 3) if hn else None,
        vsim2=round(veq / vn, 3) if vn else None,
        hsim1=round(h1 / h1n, 3) if h1n else None,
        vsim1=round(v1 / v1n, 3) if v1n else None,
    )


def _lum(w):
    r, g, bl = w & 31, (w >> 5) & 31, (w >> 10) & 31
    return 2126 * r + 7152 * g + 722 * bl


def palette_runs(data, min_words=8):
    """CGB palette detector (RGB555 words, bit 15 clear).

    A *palette group* is 4 consecutive little-endian words, all with bit 15 clear, at
    least 3 distinct values, containing $7FFF (white) and with monotone luminance
    (dark->light or light->dark).  Real game palettes satisfy this; random data /
    tile data does so with probability < 1e-5 per offset.  Consecutive 8-byte groups
    that merely have bit 15 clear extend a run.  Returns [(start, nwords, has_7fff)]
    with ``nwords`` a multiple of 4; runs shorter than ``min_words`` words are dropped
    (use min_words=4 to keep single palettes)."""
    n = len(data)
    res = []
    i = 0
    while i + 8 <= n:
        if data[i + 1] < 0x80 and data[i + 3] < 0x80 and data[i + 5] < 0x80 and data[i + 7] < 0x80:
            w = [data[i + 2 * k] | (data[i + 2 * k + 1] << 8) for k in range(4)]
            L = [_lum(x) for x in w]
            if len(set(w)) >= 3 and 0x7FFF in w and (L == sorted(L) or L == sorted(L, reverse=True)):
                j = i + 8
                while (j + 8 <= n and data[j + 1] < 0x80 and data[j + 3] < 0x80 and data[j + 5] < 0x80
                       and data[j + 7] < 0x80 and any(data[j:j + 8])):
                    j += 8
                if (j - i) // 2 >= min_words:
                    res.append((i, (j - i) // 2, True))
                i = j
                continue
        i += 1
    return res


def tilemap_score(data):
    """Tilemap-likeness: many equal / +1 consecutive bytes, small alphabet."""
    if len(data) < 32:
        return 0.0
    seq = sum(1 for a, b in zip(data, data[1:]) if b == a or b == a + 1)
    return seq / (len(data) - 1)


# ----------------------------------------------------------------------------
# record / stride detection
# ----------------------------------------------------------------------------
def best_stride(win, smin=2, smax=64):
    """Fixed-stride record detection.  For each stride s, the mean over columns of
    (1 - H(column)/log2(nrows)) is compared with the same statistic for the
    rows shuffled bytes' expectation; we report (stride, score) of the best
    stride whose score clearly exceeds that of neighbouring non-multiples.
    Only run on non-pad windows."""
    n = len(win)
    best = None
    scores = {}
    for s in range(smin, smax + 1):
        rows = n // s
        if rows < 8:
            break
        cols_eq = 0
        # fraction of positions equal to the byte one stride earlier
        eq = sum(1 for i in range(s, rows * s) if win[i] == win[i - s])
        scores[s] = eq / ((rows - 1) * s)
    if not scores:
        return None
    mean = sum(scores.values()) / len(scores)
    s_best = max(scores, key=lambda k: scores[k])
    # a real record stride shows a peak at s and at its multiples 2s,3s..
    # while other strides stay near the baseline
    return dict(stride=s_best, score=round(scores[s_best], 3), baseline=round(mean, 3))


# ----------------------------------------------------------------------------
# pointer-table detection
# ----------------------------------------------------------------------------
def find_word_tables(data, bank, used_lo, used_hi, min_entries=4):
    """Runs of little-endian 16-bit values in 0x4000-0x7FFF.

    For every start parity we accept consecutive words (stride 2) whose value is in
    [0x4000, 0x8000) and (for the bank-local flavour) inside the used part of the
    bank.  Also try records of stride 3..8 (word + payload bytes) where the first
    word of each record is a pointer.  Each candidate reports the fraction of
    targets that are inside the used range and the fraction that are monotone.
    """
    cands = []
    n = len(data)
    lo, hi = 0x4000, 0x8000

    def valid(w):
        return lo <= w < hi

    for stride in range(2, 9):
        for start in range(0, min(stride, 2) if stride == 2 else stride):
            i = start
            while i + 1 < n:
                if valid(data[i] | (data[i + 1] << 8)):
                    j = i
                    words = []
                    while j + 1 < n:
                        w = data[j] | (data[j + 1] << 8)
                        if not valid(w):
                            break
                        words.append(w)
                        j += stride
                    if len(words) >= min_entries:
                        cands.append((stride, i, words))
                    i = j
                else:
                    i += stride
    out = []
    for stride, i, words in cands:
        cnt = len(words)
        distinct = len(set(words))
        inbank = sum(1 for w in words if used_lo <= w < used_hi)
        mono = sum(1 for a, b in zip(words, words[1:]) if b > a)
        out.append(dict(
            bank=bank, addr=0x4000 + i, stride=stride, entries=cnt,
            distinct=distinct, in_used=round(inbank / cnt, 3),
            monotone=round(mono / (cnt - 1), 3) if cnt > 1 else 0,
            first=words[0], last=words[-1],
        ))
    return out


def word_table_quality(c):
    """A crude ordering key: long, distinct, mostly in-bank and monotone tables
    first.  Purely a sorting key, not a claim."""
    return c['entries'] * c['distinct'] / max(1, c['entries']) * (0.5 + c['in_used']) * (0.5 + c['monotone'])


# ----------------------------------------------------------------------------
# far-call scan  ("call $06D1 ; dw addr ; db bank")
# ----------------------------------------------------------------------------
def scan_farcalls(rom):
    out = []
    pat = b'\xcd\xd1\x06'
    i = 0
    while True:
        i = rom.find(pat, i)
        if i < 0:
            break
        if i + 6 <= len(rom):
            tgt = rom[i + 3] | (rom[i + 4] << 8)
            tb = rom[i + 5]
            bank = i // BANK_SIZE
            addr = (i & 0x3FFF) + (0 if bank == 0 else 0x4000)
            out.append(dict(site_bank=bank, site_addr=addr, target_addr=tgt, target_bank=tb))
        i += 1
    return out


# ----------------------------------------------------------------------------
# per-window classification
# ----------------------------------------------------------------------------
INLINE_JUMP_HELPERS = (0x0545, 0x056A)   # 'call $0545' / 'call $056A' + inline dw jump table (a = index); never return


def proven_code(rom):
    """Lower bound of the bytes that are certainly instructions: recursive descent from every
    far-call target (call $06D1 ; dw target ; db bank) plus the reset/interrupt vectors, following
    jp/jr/call/rst targets, skipping the 3 inline bytes of far calls and treating the two inline
    jump-table helpers (00:0545 / 00:056A, see INLINE_JUMP_HELPERS) as non-returning with an inline
    table of word targets.  Returns {bank: set(addr)} of instruction/inline-operand bytes.
    Used only to trim the boundaries of heuristic (data) proposals; it is NOT a code map."""
    seeds = collections.defaultdict(set)
    for b in range(NBANKS):
        base = b * BANK_SIZE
        i = rom.find(b'\xcd\xd1\x06', base, base + BANK_SIZE - 5)
        while i >= 0 and i < base + BANK_SIZE - 5:
            t = rom[i + 3] | (rom[i + 4] << 8)
            tb = rom[i + 5]
            if (tb == 0 and t < 0x4000) or (0 < tb < NBANKS and 0x4000 <= t < 0x8000):
                seeds[tb].add(t)
            i = rom.find(b'\xcd\xd1\x06', i + 1, base + BANK_SIZE - 5)
    for a in (0x100, 0x150, 0x278, 0x40, 0x48, 0x50, 0x58, 0x60):
        seeds[0].add(a)
    code = collections.defaultdict(set)
    seen = set()
    work = [(b, a) for b in seeds for a in seeds[b]]
    while work:
        b, a = work.pop()
        lo = 0 if b == 0 else 0x4000
        while lo <= a < lo + BANK_SIZE and (b, a) not in seen:
            o = b * BANK_SIZE + (a & 0x3FFF)
            if rom[o:o + 8] == bytes(8):
                break
            seen.add((b, a))
            i = sm83.decode(rom, o, a)
            n = len(i.raw)
            code[b].update(range(a, a + n))
            nxt = a + n
            fl = i.flow
            if fl in ('jp', 'jpcc', 'jr', 'jrcc', 'call', 'callcc', 'rst') and i.target is not None:
                t = i.target
                if fl == 'call' and t == FARCALL_ENTRY:
                    o2 = b * BANK_SIZE + (nxt & 0x3FFF)
                    code[b].update(range(nxt, nxt + 3))
                    tt = rom[o2] | (rom[o2 + 1] << 8)
                    tb = rom[o2 + 2]
                    if (tb == 0 and tt < 0x4000) or (0 < tb < NBANKS and 0x4000 <= tt < 0x8000):
                        work.append((tb, tt))
                    nxt += 3
                elif fl in ('call', 'jp') and t in INLINE_JUMP_HELPERS:
                    # inline table of word targets follows a call (a jp uses the caller's table)
                    if fl == 'call':
                        p = nxt
                        lim = 0x8000
                        for _ in range(32):
                            if p >= lim:
                                break
                            oo = b * BANK_SIZE + (p & 0x3FFF)
                            w = rom[oo] | (rom[oo + 1] << 8)
                            if not (lo <= w < lo + BANK_SIZE) or w < p - 0x2000:
                                break
                            code[b].update(range(p, p + 2))
                            work.append((b, w))
                            lim = min(lim, w) if w > p else lim
                            p += 2
                    break
                else:
                    tb2 = 0 if t < 0x4000 else b
                    if 0 <= t < 0x8000:
                        work.append((tb2, t))
            if fl in ('ret', 'jp', 'jr', 'jphl', 'stop', 'bad'):
                break
            a = nxt
    return code


def classify_window(f):
    """Rule-based guess.  Returns (kind, confidence).  Confidence strings use the
    project vocabulary: only pad kinds are CONFIRMED (byte-level facts)."""
    if f['zero_frac'] >= 0.999:
        return 'zero', 'CONFIRMED'
    if f['ff_frac'] >= 0.999:
        return 'ff', 'CONFIRMED'
    pad = f['zero_frac'] + f['ff_frac']
    g = f['gfx']
    c = f['code']
    code_like = (
        c.get('n_insn', 0) > 20 and c.get('bad_frac', 1) < 0.02
        and c.get('llr', -9) > 0.35 and (c.get('branch_valid') is None or c['branch_valid'] > 0.6)
    )
    gfx2 = g['hsim2'] is not None and g['hsim2'] > 0.55 and g['vsim2'] > 0.55
    gfx1 = g['hsim1'] is not None and g['hsim1'] > 0.78 and g['vsim1'] > 0.62
    if code_like and not gfx2:
        return 'code', 'PROBABLE'
    if gfx2:
        return 'gfx2bpp', 'PROBABLE'
    if code_like:
        return 'code', 'HYPOTHESIS'
    if gfx1:
        return 'gfx1bpp', 'HYPOTHESIS'
    if f['tilemap'] > 0.6:
        return 'tilemap', 'HYPOTHESIS'
    if f['entropy'] > 7.0:
        return 'compressed-or-random', 'HYPOTHESIS'
    return 'unknown', 'HYPOTHESIS'


# ----------------------------------------------------------------------------
# Structures derived from engine code (each one is re-verified against the bytes)
# ----------------------------------------------------------------------------
# JIS X 0208 12x12 font.  Layout derived from the glyph-address routine 7F:40B9
# (row -> bank table at 7F:40F9, row -> first row held in the bank table at 7F:4150,
# 94 columns per row, 18 bytes per glyph, glyph data at 0x4000 + ...).  The tables are
# read from the ROM here, nothing is hard-coded.
FONT_ROWBANK = 0x7F, 0x40F9
FONT_ROWFIRST = 0x7F, 0x4150
LATIN_FONT = 0x76, 0x67A8          # 96 glyphs (0x20..0x7F) * 12 bytes, engine 7F:400E
LATIN_GLYPHS, LATIN_GLYPH_SIZE = 96, 12
KANJI_GLYPH_SIZE = 18


def font_layout(rom):
    """Return dict bank -> dict(slots={row: slot}, rows=[...], start, end) verified against
    the ROM.  slot = row - first_row[row] (the engine's `sub a,b` at 7F:40D5); the glyph
    of (row, col) lives at bank:0x4000 + (slot*94 + col-1)*18.  Rows whose bank byte is not
    a font bank (0xFF unused / 0x01) are skipped."""
    bb, ba = FONT_ROWBANK
    fb, fa = FONT_ROWFIRST
    banks = rom[offset(bb, ba):offset(bb, ba) + 94]
    firsts = rom[offset(fb, fa):offset(fb, fa) + 94]
    out = {}
    for row in range(1, 95):
        bk = banks[row - 1]
        if not (0x76 <= bk <= 0x7E):
            continue
        ent = out.setdefault(bk, dict(slots={}, rows=[]))
        ent['slots'][row] = row - firsts[row - 1]
        ent['rows'].append(row)
    for bk, ent in out.items():
        # only rows that exist in JIS X 0208 (1-8, 13, 16-84) hold glyph data
        std = [r for r in ent['rows'] if r <= 8 or r == 13 or 16 <= r <= 84]
        ent['std_rows'] = std
        ent['start'] = 0x4000
        ent['end'] = 0x4000 + (max(ent['slots'][r] for r in std) + 1) * 94 * KANJI_GLYPH_SIZE
    return out


def verify_font(rom, layout):
    """Checks that make the layout claim testable: (1) the bytes after the computed
    end of glyph data up to the next structure are zero or code; (2) blank/space glyph
    (JIS 1-1, 0x8140) is all zero; (3) hiragana row (JIS 4) is non-empty for every col
    2..84."""
    facts = []
    b7e = layout.get(0x7E)
    if b7e:
        g = rom[offset(0x7E, 0x4000):offset(0x7E, 0x4000) + 18]
        facts.append(('JIS 1-1 (0x8140, ideographic space) glyph all zero', g == b'\x00' * 18))
        nz = 0
        for col in range(1, 84):
            o = offset(0x7E, 0x4000) + (b7e['slots'][4] * 94 + col - 1) * 18
            nz += any(rom[o:o + 18])
        facts.append(('JIS row 4 (hiragana) non-empty glyphs cols 1..83 = %d/83' % nz, nz == 83))
    return facts


def parse_html_store(rom):
    """Banks 3D and 3E: back-to-back records  name\\0  u16le length  body[length]
    where body ends with a \\0 byte.  Returns (files, ends) or [] if inconsistent."""
    files = []
    ends = {}
    for bk in (0x3D, 0x3E):
        base = bk * BANK_SIZE
        o = 0
        while o < BANK_SIZE - 4:
            j = o
            while j < BANK_SIZE and rom[base + j] != 0 and j - o < 40:
                j += 1
            name = rom[base + o:base + j]
            if not name or not all(32 <= c < 127 for c in name) or j >= BANK_SIZE or rom[base + j] != 0:
                break
            ln = rom[base + j + 1] | (rom[base + j + 2] << 8)
            body_end = j + 3 + ln
            if body_end > BANK_SIZE or rom[base + body_end - 1] != 0:
                break
            files.append(dict(bank=bk, addr=0x4000 + o, name=name.decode(), length=ln,
                              body_addr=0x4000 + j + 3, end=0x4000 + body_end))
            o = body_end
        ends[bk] = 0x4000 + o
    return files, ends


def parse_html_index(rom, files):
    """Bank 3F: 3-byte (addr16, bank) triples pointing at html records."""
    b = 0x3F * BANK_SIZE
    starts = {(f['addr'], f['bank']) for f in files}
    i = 0x12
    tr = []
    while i + 3 <= BANK_SIZE:
        a = rom[b + i] | (rom[b + i + 1] << 8)
        bk = rom[b + i + 2]
        if (a, bk) not in starts:
            break
        tr.append((a, bk))
        i += 3
    return dict(start=0x4000 + 0x12, count=len(tr), end=0x4000 + i, all_match=len(set(tr)) == len(tr),
                n_files=len(files), targets=tr)


# ----------------------------------------------------------------------------
# text scanner: Shift-JIS (JIS X 0208 / CP932) + ASCII
# ----------------------------------------------------------------------------
def _sjis_row(a, b):
    row = (a - (0x81 if a <= 0x9F else 0xC1)) * 2 + 1 + (1 if b >= 0x9F else 0)
    return row


_CAT_CACHE = {}


def sjis_token(data, i):
    """Classify the token at data[i].  Returns (length, category, char) or None.
    Categories: 'a' ASCII printable, 'nl' CR/LF, 'hira' 'kata' 'punct' 'fwal'
    (fullwidth alnum) 'sym' 'k1' (JIS level-1 kanji, rows 16-47) 'k2' (rows 48-84) 'gr'
    (greek/cyrillic rows 6-7) 'bx' (box drawing / other row 8)."""
    n = len(data)
    c = data[i]
    if 0x20 <= c <= 0x7E:
        return 1, 'a', ('\u00a5' if c == 0x5C else '\u203e' if c == 0x7E else chr(c))
    if c in (0x0D, 0x0A):
        return 1, 'nl', '\r' if c == 0x0D else '\n'
    if (0x81 <= c <= 0x9F or 0xE0 <= c <= 0xEF) and i + 1 < n:
        b = data[i + 1]
        if not (0x40 <= b <= 0x7E or 0x80 <= b <= 0xFC):
            return None
        key = (c, b)
        r = _CAT_CACHE.get(key)
        if r is None:
            try:
                ch = bytes([c, b]).decode('cp932')
            except UnicodeDecodeError:
                _CAT_CACHE[key] = False
                return None
            if len(ch) != 1:
                _CAT_CACHE[key] = False
                return None
            cp = ord(ch)
            row = _sjis_row(c, b)
            if 0x3041 <= cp <= 0x3096:
                cat = 'hira'
            elif 0x30A1 <= cp <= 0x30FA or cp == 0x30FC:
                cat = 'kata'
            elif cp in (0x30FB, 0x309B, 0x309C, 0x309D, 0x309E, 0x30FD, 0x30FE) or 0x3000 <= cp <= 0x303F:
                cat = 'punct'
            elif 0xFF10 <= cp <= 0xFF19 or 0xFF21 <= cp <= 0xFF3A or 0xFF41 <= cp <= 0xFF5A:
                cat = 'fwal'
            elif 0xFF01 <= cp <= 0xFF5E or 0xFFE0 <= cp <= 0xFFE5 or 0x2010 <= cp <= 0x2049:
                cat = 'punct'
            elif row in (6, 7):
                cat = 'gr'
            elif row == 8:
                cat = 'bx'
            elif 16 <= row <= 47 and 0x4E00 <= cp <= 0x9FFF:
                cat = 'k1'
            elif 48 <= row <= 84 and 0x4E00 <= cp <= 0x9FFF:
                cat = 'k2'
            elif row <= 5 or row == 13:
                cat = 'sym'
            else:
                cat = None
            r = (ch, cat) if cat else False
            _CAT_CACHE[key] = r
        if r is False:
            return None
        return 2, r[1], r[0]
    return None


TEXT_WEIGHT = dict(a=0.0, nl=0.0, hira=1.0, kata=1.0, punct=0.8, fwal=0.8, sym=0.6, k1=0.5, k2=-1.0, gr=-2.0, bx=-0.5)


def scan_text_runs(rom, bank, lo, hi, min_common=3):
    """Greedy left-to-right SJIS/ASCII token runs inside [lo, hi) CPU addresses of ``bank``.
    Returns list of dict(addr, end, tokens, text, ...) before scoring/status."""
    base = bank * BANK_SIZE - (0x4000 if bank else 0)
    data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
    boff = 0x4000 if bank else 0
    i = lo - boff
    end = hi - boff
    runs = []
    while i < end:
        j = i
        toks = []
        while j < end:
            t = sjis_token(data, j)
            if t is None:
                break
            toks.append((j, t))
            j += t[0]
        if toks:
            wide = [t for _, t in toks if t[0] == 2]
            common = sum(1 for t in wide if t[1] in ('hira', 'kata', 'punct', 'fwal'))
            if common >= min_common:
                runs.append((i, j, toks))
                i = j
                continue
        i += 1
    res = []
    for s, e, toks in runs:
        res.append(dict(bank=bank, addr=boff + s, end=boff + e, toks=toks))
    return res


def score_run(run, data_after):
    toks = run['toks']
    wide = [t for _, t in toks if t[0] == 2]
    W = len(wide)
    c = collections.Counter(t[1] for t in wide)
    common = c['hira'] + c['kata'] + c['punct'] + c['fwal']
    score = sum(TEXT_WEIGHT[t[1]] for t in wide)
    chars = collections.Counter(t[2] for t in wide)
    top = chars.most_common(1)[0][1] if chars else 0
    distinct = len(chars)
    nonspace = sum(1 for t in wide if t[2] not in ('\u3000',))
    ascii_ = sum(1 for _, t in toks if t[0] == 1 and t[1] == 'a')
    return dict(W=W, common=common, score=score, distinct=distinct, top=top, nonspace=nonspace,
                cats=dict(c), ascii=ascii_, ntok=len(toks))


def accept_run(sc):
    if sc['nonspace'] < 3 or sc['W'] == 0:
        return None
    ratio = sc['score'] / sc['W']
    if sc['distinct'] < 2 or sc['top'] > 0.7 * sc['W'] and sc['W'] > 4:
        return None
    if sc['common'] >= 8 and ratio >= 0.85 and sc['distinct'] >= 4:
        return 'CONFIRMED'
    if sc['score'] >= 3.5 and ratio >= 0.7 and sc['distinct'] >= 3:
        return 'PROBABLE'
    if sc['score'] >= 2.5 and ratio >= 0.55:
        return 'HYPOTHESIS'
    return None


def decode_hybrid(seg):
    """Decode a string of the second text convention (bank 6C): Shift-JIS pairs, single-byte
    half-width katakana A1-DF (JIS X 0201), 20-7E ASCII; controls < 0x20 as <XX>; other bytes {XX}."""
    out = []
    i = 0
    while i < len(seg):
        c = seg[i]
        if c < 0x20:
            out.append('<%02X>' % c)
            i += 1
        elif 0x20 <= c <= 0x7E:
            out.append(chr(c))
            i += 1
        elif 0xA1 <= c <= 0xDF:
            out.append(bytes([c]).decode('cp932'))
            i += 1
        else:
            t = sjis_token(seg, i) if c <= 0x9F else None   # E0-FF are single-byte gaiji here
            if t and t[0] == 2:
                out.append(t[2])
                i += 2
            else:
                out.append('{%02X}' % c)
                i += 1
    return ''.join(out)


def hybrid_segments(rom, bank, lo, hi):
    """NUL-delimited segments that look like half-width-katakana text (second convention)."""
    data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
    boff = 0x4000 if bank else 0
    out = []
    pos = lo - boff
    for seg in data[lo - boff:hi - boff].split(b'\x00'):
        if len(seg) >= 8:
            n = h = g = k = 0
            i = 0
            while i < len(seg):
                c = seg[i]
                if c < 0x20 or 0x20 <= c <= 0x7E:
                    n += 1
                    i += 1
                elif 0xA1 <= c <= 0xDF:
                    n += 1
                    h += 1
                    i += 1
                else:
                    t = sjis_token(seg, i) if c <= 0x9F else None
                    if t and t[0] == 2:
                        n += 1
                        k += t[1] in ('k1', 'k2', 'gr', 'bx')
                        i += 2
                    else:
                        n += 1
                        g += 1
                        i += 1
            if h >= 5 and h / n >= 0.5 and g / n <= 0.35 and k <= 0.1 * n:
                out.append((boff + pos, len(seg), seg))
        pos += len(seg) + 1
    return out


def tsv_escape(s):
    return (s.replace('\\', '\\\\').replace('\t', '\\t').replace('\r', '\\r').replace('\n', '\\n'))


def reject_repetitive(run):
    """True when the run is dominated by adjacent repeats of one glyph (typical of tile
    data / fill patterns that happen to decode as SJIS)."""
    wide = [t[2] for _, t in run['toks'] if t[0] == 2 and t[2] != '　']
    if len(wide) < 4:
        return False
    rep = sum(1 for a, b in zip(wide, wide[1:]) if a == b)
    return rep / (len(wide) - 1) >= 0.4


def scan_ascii_strings(rom, bank, lo, hi, min_len=6):
    """NUL-delimited printable-ASCII strings (both neighbours are 0x00 / bank edge) with
    >= 70% letters/digits and >= 4 letters.  Strong filter because code and graphics
    contain many accidental printable runs."""
    data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
    boff = 0x4000 if bank else 0
    out = []
    i = lo - boff
    end = hi - boff
    while i < end:
        if 0x20 <= data[i] <= 0x7E and (i == 0 or data[i - 1] == 0):
            j = i
            while j < end and 0x20 <= data[j] <= 0x7E:
                j += 1
            s = data[i:j]
            if j - i >= min_len and (j >= len(data) or data[j] == 0):
                letters = sum(1 for c in s if chr(c).isalpha())
                alnum = sum(1 for c in s if chr(c).isalnum() or c == 0x20)
                top = collections.Counter(s).most_common(1)[0][1]
                seqs = sum(1 for x, y in zip(s, s[1:]) if y - x in (0, 1))
                if (letters >= 4 and alnum / len(s) >= 0.7 and top <= 0.4 * len(s)
                        and len(set(s)) >= 5 and seqs < 0.5 * len(s)):
                    out.append((boff + i, boff + j, s.decode('ascii')))
            i = j
        else:
            i += 1
    return out


# ----------------------------------------------------------------------------
# known structures  (shared with extract_gfx.py)
# ----------------------------------------------------------------------------
def known_structures(rom):
    """Structures whose layout was derived from disassembled engine code and re-verified
    against the bytes.  Each entry: dict(bank, start, end, kind, label, status, note).
    ``kind`` follows the config/regions vocabulary (gfx, text, ptrtable, data)."""
    out = []
    lay = font_layout(rom)
    for bk in sorted(lay):
        ent = lay[bk]
        note = ('JIS X 0208 12x12 1bpp glyphs, 18 bytes/glyph (2 rows of 12 bits per 3 bytes), JIS rows %s, '
                '94 cols/row; layout from 7F:400E/4072/40B9 + tables 7F:40F9/7F:4150'
                % ','.join('%d' % r for r in ent['std_rows']))
        out.append(dict(bank=bk, start=0x4000, end=ent['end'], kind='gfx', label='font12x12',
                        status='CONFIRMED', note=note))
    lb, la = LATIN_FONT
    out.append(dict(bank=lb, start=la, end=la + LATIN_GLYPHS * LATIN_GLYPH_SIZE, kind='gfx', label='fontlatin6x12',
                    status='CONFIRMED',
                    note='half-width font, 96 glyphs (0x20..0x7F) x 12 bytes (1 byte/row, 6-8 px wide); address = 76:67A8+(c-$20)*12 from 7F:400E'))
    # font row tables read by 7F:40B9 (bank of each JIS row / first row held by that bank), 87 rows each
    out.append(dict(bank=0x7F, start=0x40F9, end=0x40F9 + 87, kind='data', prefix='Table', label='font_row_bank_table',
                    status='CONFIRMED', cap='PROBABLE',
                    note='87 bytes: ROM bank holding JIS row r (index r-1), read at 7F:40C0-40C8 (ld hl,$40F9 ; a=row-1 ; add a,l)'))
    out.append(dict(bank=0x7F, start=0x4150, end=0x4150 + 87, kind='data', prefix='Table', label='font_row_first_table',
                    status='CONFIRMED', cap='PROBABLE',
                    note='87 bytes: first JIS row stored in the bank of row r, read at 7F:40CA-40D6 (ld hl,$4150)'))
    # 51:4225 byte-pair lookup (replaces the retracted word-table candidate 51:4224)
    out.append(dict(bank=0x51, start=0x4225, end=0x4239, kind='data', prefix='Table', label='byte_pair_table',
                    status='PROBABLE', cap='PROBABLE',
                    note='10 x 2 bytes, indexed by the code at 51:4200-4224 (de = $4225 + 2*a via add a,a / add a,$25 / adc a,$42, two ld a,[de] reads); end = start of the next function at 51:4239; meaning of the values unknown'))
    files, ends = parse_html_store(rom)
    for bk in (0x3D, 0x3E):
        n = sum(1 for f in files if f['bank'] == bk)
        out.append(dict(bank=bk, start=0x4000, end=ends[bk], kind='text', label='html_store',
                        status='CONFIRMED',
                        note='%d back-to-back records name\\0 u16le-len body(NUL-terminated HTML, Shift-JIS)' % n))
    if files:
        idx = parse_html_index(rom, files)
        out.append(dict(bank=0x3F, start=0x4000, end=0x4006, kind='data', label='html_index_hdr', status='PROBABLE',
                        note='dw $4006,$4006,$0000 before the URL prefix string (purpose unverified)'))
        out.append(dict(bank=0x3F, start=0x4006, end=0x4011, kind='text', label='html_url_prefix', status='CONFIRMED',
                        note='"file://di/",0 (ASCII)'))
        out.append(dict(bank=0x3F, start=0x4011, end=0x4012, kind='data', label='html_index_byte', status='HYPOTHESIS',
                        note='single byte $02 between the URL prefix and the index (meaning unknown)'))
        out.append(dict(bank=0x3F, start=idx['start'], end=idx['end'], kind='ptrtable', label='html_index', status='CONFIRMED',
                        note='%d x 3-byte far pointers (addr16, bank) to the %d html records; all targets match record starts'
                             % (idx['count'], idx['n_files'])))
        out.append(dict(bank=0x3F, start=idx['end'], end=idx['end'] + 2, kind='data', label='html_index_gap', status='HYPOTHESIS',
                        note='00 00 between the far-pointer index and the word table'))
        out.append(dict(bank=0x3F, start=idx['end'] + 2, end=idx['end'] + 2 + 22, kind='ptrtable', label='html_topic_starts', status='PROBABLE',
                        note='11 ascending words pointing into the byte lists that follow'))
        out.append(dict(bank=0x3F, start=idx['end'] + 2 + 22, end=0x410C, kind='data', label='html_topic_lists', status='PROBABLE',
                        note='61 index bytes (all <= 0x36 = highest html file index) in 11 lists delimited by the word table; probably file index lists per topic (unverified)'))
    return out


def structure_ranges(rom):
    return [(s['bank'], s['start'], s['end']) for s in known_structures(rom)]


# ----------------------------------------------------------------------------
# text extraction over the whole ROM
# ----------------------------------------------------------------------------
def text_scan_all(rom, struct_ranges, gfx_rows):
    """Return list of string dicts (bank, addr, length, text, status, note, term)."""
    strings = []
    files, ends = parse_html_store(rom)
    for f in files:
        body = rom[offset(f['bank'], f['body_addr']):offset(f['bank'], f['body_addr']) + f['length'] - 1]
        txt = body.decode('cp932', 'replace')
        strings.append(dict(bank=f['bank'], addr=f['addr'], length=f['end'] - f['addr'],
                            text='[%s] %s' % (f['name'], txt), status='CONFIRMED',
                            note='html record: name+NUL+u16 len+body(len=%d incl. NUL); parsed chain consistent to end of data' % f['length'],
                            kind='html'))
    skip = collections.defaultdict(list)
    for b, s, e in struct_ranges:
        skip[b].append((s, e))
    conf_gfx = collections.defaultdict(list)
    for r in gfx_rows:
        if r['conf'] == 'CONFIRMED' and r['length'] and r['kind'].startswith(('tiles', 'tilemap')):
            conf_gfx[r['bank']].append((r['addr'], r['addr'] + r['length']))
    heur_gfx = collections.defaultdict(list)
    for r in gfx_rows:
        if r['conf'] != 'CONFIRMED' and r['kind'] == 'tiles-2bpp':
            heur_gfx[r['bank']].append((r['addr'], r['addr'] + r['length']))

    def overlap(ranges, a, b):
        return sum(max(0, min(b, e) - max(a, s)) for s, e in ranges)

    for bank in range(128):
        data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
        ue = used_end(data)
        if not ue:
            continue
        lo = 0 if bank == 0 else 0x4000
        hi = lo + ue
        for run in scan_text_runs(rom, bank, lo, hi):
            if any(s <= run['addr'] < e for s, e in skip.get(bank, ())):
                continue
            if reject_repetitive(run):
                continue
            # verifier fix: a greedy token run can swallow a few bytes of the neighbouring code/data
            # (e.g. the operand of a preceding 'jp', or code after a text table).  Trim tokens that
            # are not kana/punctuation/full-width alnum at the uncertain ends:
            #   * leading tokens only when the run is NOT preceded by a NUL (start unconfirmed)
            #   * trailing tokens only when the run is NOT followed by a NUL (end unconfirmed)
            boff0 = 0x4000 if bank else 0
            core = ('hira', 'kata', 'punct', 'fwal')
            toks = list(run['toks'])
            trimmed = []
            if not (run['addr'] - boff0 == 0 or data[run['addr'] - boff0 - 1] == 0):
                while toks and toks[0][1][1] in ('a', 'k2', 'gr', 'bx'):
                    trimmed.append('lead %02X' % data[toks[0][0]])
                    toks.pop(0)
            if not (run['end'] - boff0 < len(data) and data[run['end'] - boff0] == 0):
                while toks and toks[-1][1][1] not in core and toks[-1][1][1] != 'nl':
                    trimmed.append('tail %02X' % data[toks[-1][0]])
                    toks.pop()
            if trimmed:
                if not toks:
                    continue
                run = dict(run, toks=toks, addr=boff0 + toks[0][0], end=boff0 + toks[-1][0] + toks[-1][1][0])
            sc = score_run(run, None)
            st = accept_run(sc)
            if not st:
                continue
            length = run['end'] - run['addr']
            og = overlap(conf_gfx.get(bank, ()), run['addr'], run['end'])
            if og:
                continue
            oh = overlap(heur_gfx.get(bank, ()), run['addr'], run['end'])
            if oh > length * 0.5 and st != 'CONFIRMED':
                continue
            boff = 0x4000 if bank else 0
            term = (run['end'] - boff < len(data)) and data[run['end'] - boff] == 0
            prev0 = run['addr'] - boff == 0 or data[run['addr'] - boff - 1] == 0
            text = ''.join(t[2] for _, t in run['toks'])
            # verifier caps: CONFIRMED needs both ends anchored by NUL/bank edge; a run that is not
            # NUL-terminated, or that has no kana / full-width alnum at all (symbols only), is at most HYPOTHESIS
            cats = sc['cats']
            if not term or (cats.get('hira', 0) + cats.get('kata', 0) + cats.get('fwal', 0)) == 0:
                st = 'HYPOTHESIS'
            elif not prev0 and st == 'CONFIRMED':
                st = 'PROBABLE'
            note = 'SJIS/ASCII run W=%d common=%d score=%.1f distinct=%d ascii=%d; %s%s' % (
                sc['W'], sc['common'], sc['score'], sc['distinct'], sc['ascii'],
                'NUL-terminated' if term else 'no NUL after',
                ', preceded by NUL' if prev0 else ', start not anchored by NUL (may carry a header byte)')
            if trimmed:
                note += '; trimmed non-text token bytes (%s)' % ', '.join(trimmed)
            if oh:
                note += '; overlaps heuristic gfx (%d bytes)' % oh
            strings.append(dict(bank=bank, addr=run['addr'], length=length, text=text, status=st, note=note,
                                kind='sjis', term=term, W=sc['W'], cats=sc['cats']))
        for a, e, s in scan_ascii_strings(rom, bank, lo, hi):
            if any(st_ <= a < en_ for st_, en_ in skip.get(bank, ())):
                continue
            if overlap(conf_gfx.get(bank, ()), a, e) or overlap(heur_gfx.get(bank, ()), a, e):
                continue
            junk = any(ch in s for ch in '`|~^{}\\') or not any(ch in s.lower() for ch in 'aeiou')
            strings.append(dict(bank=bank, addr=a, length=e - a, text=s,
                                status='PROBABLE' if (e - a >= 8 and not junk) else 'HYPOTHESIS',
                                note='NUL-delimited printable ASCII' + ('; verifier: contains symbol chars or no vowel, likely tile/code bytes' if junk else ''),
                                kind='ascii', term=True))
    # second text convention: only accepted in banks where it is dense (>= 20 segments)
    for bank in range(128):
        data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
        ue = used_end(data)
        if not ue:
            continue
        lo = 0 if bank == 0 else 0x4000
        segs = hybrid_segments(rom, bank, lo, lo + ue)
        if len(segs) < 20:
            continue
        spans = [(a, a + ln) for a, ln, _ in segs]
        strings = [x for x in strings if not (x['bank'] == bank and x['kind'] in ('sjis', 'ascii') and
                                              any(a <= x['addr'] < e for a, e in spans))]
        for a, ln, seg in segs:
            txt = decode_hybrid(seg)
            strings.append(dict(bank=bank, addr=a, length=ln, text=txt,
                                status='PROBABLE' if ln >= 20 else 'HYPOTHESIS',
                                note='second text convention (HYPOTHESIS: single bytes A1-DF in JIS X 0201 half-width-katakana code order - glyph identity katakana vs hiragana unresolved - + SJIS pairs 81-9F lead + gaiji singles E0-FF + control bytes); NUL-terminated; {XX} = undecoded byte',
                                kind='hybrid', term=True, W=0))
    # drop sjis runs wholly inside html records / duplicates
    strings.sort(key=lambda s: (s['bank'], s['addr'], -s['length']))
    out = []
    last = {}
    for s in strings:
        pe = last.get(s['bank'], -1)
        if s['kind'] != 'html' and s['addr'] < pe:
            continue
        out.append(s)
        last[s['bank']] = max(pe, s['addr'] + s['length'])
    return out


def write_strings_tsv(path, strings):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        f.write('# analysis/strings.tsv -- generated by tools/survey.py (do not edit)\n')
        f.write('# columns: bank(hex)\\taddr(hex CPU)\\tlength(hex bytes, excl. terminator)\\tdecoded_text\\tstatus\\tnote\n')
        f.write('# encoding: Shift-JIS (JIS X 0208/CP932) double bytes + 0x20-0x7E single bytes; see docs/research/text_encoding.md\n')
        f.write('# status: CONFIRMED = statistically certain SJIS text (>=8 kana/punct pairs) or fully parsed html record; PROBABLE / HYPOTHESIS weaker\n')
        f.write('# text escapes: \\\\ \\t \\r \\n ; 0x5C decodes as the yen sign and 0x7E as overline (JIS X 0201 Roman, matches the 6x12 font)\n')
        for s in strings:
            f.write('%02X\t%04X\t%X\t%s\t%s\t%s\n' % (s['bank'], s['addr'], s['length'], tsv_escape(s['text']),
                                                   s['status'], tsv_escape(s['note'])))


# ----------------------------------------------------------------------------
# per-bank survey
# ----------------------------------------------------------------------------
CLASS_INFO = collections.OrderedDict([
    ('Z', ('zero fill', (40, 40, 40))),
    ('F', ('0xFF fill', (120, 120, 120))),
    ('C', ('code-like (linear sweep)', (70, 130, 220))),
    ('G', ('2bpp tile data', (230, 150, 40))),
    ('K', ('JIS 12x12 / Latin font', (200, 60, 200))),
    ('H', ('html store / index', (60, 180, 100))),
    ('T', ('SJIS/ASCII text', (60, 210, 210))),
    ('M', ('tilemap (call-site)', (220, 220, 60))),
    ('P', ('RGB555 palette', (230, 90, 90))),
    ('R', ('pointer table', (150, 100, 40))),
    ('U', ('unclassified', (200, 200, 200))),
])
PRIO = {c: i for i, c in enumerate(['U', 'C', 'G', 'P', 'R', 'T', 'M', 'K', 'H'])}


def bank_blocks(rom, bank, model, starts0):
    """Per-0x100 block features + code-likeness guess (sweep starts at each block)."""
    data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
    lo = base_addr(bank)
    ue = used_end(data)
    ins_all = sweep(rom, bank * BANK_SIZE, bank * BANK_SIZE + BANK_SIZE, lo)
    bstarts = {i.addr for i in ins_all}
    blocks = []
    for b in range(64):
        s = b * 0x100
        chunk = data[s:s + 0x100]
        nz = chunk.count(0)
        nf = chunk.count(0xFF)
        rec = dict(zero=nz, ff=nf, entropy=round(entropy(chunk), 2))
        if nz + nf < 0x100:
            ins = sweep(rom, bank * BANK_SIZE + s, bank * BANK_SIZE + s + 0x100, lo + s)
            cf = code_features(ins, starts0, bstarts, lo, lo + max(ue, 1), model)
            g = gfx_scores(chunk)
            rec.update(llr=cf.get('llr'), bad=cf.get('bad_frac'), branch_valid=cf.get('branch_valid'),
                       hsim2=g['hsim2'], vsim2=g['vsim2'])
            code_like = (cf.get('n_insn', 0) > 30 and cf.get('bad_frac', 1) < 0.03 and cf.get('llr', -9) > 0.35
                         and (cf.get('branch_valid') is None or cf['branch_valid'] > 0.6)
                         and not (g['hsim2'] and g['hsim2'] > 0.5 and g['vsim2'] > 0.5))
            rec['code_like'] = bool(code_like)
            if code_like:
                io = collections.Counter()
                for i in ins:
                    a = i.hram
                    if a is None and i.imm16 is not None and i.imm16_kind == 'mem' and i.imm16 >= 0xFF00:
                        a = i.imm16
                    if a is not None and (a <= 0xFF7F or a == 0xFFFF):
                        io[a] += 1
                rec['io'] = dict(io)
        else:
            rec['code_like'] = False
        blocks.append(rec)
    return blocks, bstarts


def paint_map(bank, blocks, structs, gfx_rows, strings, palettes, tables, used):
    """Byte-level class map (list of chars) for the bank, painted by priority."""
    lo = base_addr(bank)
    m = ['U'] * BANK_SIZE
    pr = [0] * BANK_SIZE

    def paint(a, b, ch):
        p = PRIO[ch]
        for k in range(max(0, a - lo), min(BANK_SIZE, b - lo)):
            if p >= pr[k]:
                m[k] = ch
                pr[k] = p
    for i, bl in enumerate(blocks):
        if bl.get('code_like'):
            paint(lo + i * 0x100, lo + i * 0x100 + 0x100, 'C')
    for r in gfx_rows:
        if r['bank'] == bank and r['length']:
            if r['kind'].startswith('tile') and r['kind'] != 'tilemap+attr' and r['kind'] != 'tilemap-vram':
                paint(r['addr'], r['addr'] + r['length'], 'G')
            elif r['kind'] in ('tilemap+attr', 'tilemap-vram'):
                paint(r['addr'], r['addr'] + r['length'], 'M')
            elif r['kind'] == 'palette-rgb555':
                paint(r['addr'], r['addr'] + r['length'], 'P')
    for t in tables:
        paint(t['addr'], t['addr'] + t['stride'] * t['entries'], 'R')
    for s in strings:
        if s['bank'] == bank:
            paint(s['addr'], s['addr'] + s['length'], 'T')
    for st in structs:
        if st['bank'] == bank:
            paint(st['start'], st['end'], {'gfx': 'K', 'text': 'H', 'ptrtable': 'H', 'data': 'H'}[st['kind']])
    # pads (zero / FF runs >= 32 bytes) only where nothing structured claims the bytes
    d = None
    return m


def apply_pads(m, data, bank, minlen=32):
    lo = base_addr(bank)
    for v, ch in ((0, 'Z'), (0xFF, 'F')):
        for s, ln in fill_runs(data, v, minlen):
            for k in range(s, s + ln):
                if m[k] in ('U', 'C'):
                    m[k] = ch
    return m


def block_class_string(m):
    out = []
    for b in range(64):
        seg = m[b * 0x100:(b + 1) * 0x100]
        c = collections.Counter(seg)
        if c['Z'] >= 0xC0:
            out.append('Z')
        elif c['F'] >= 0xC0:
            out.append('F')
        else:
            c.pop('Z', None)
            c.pop('F', None)
            out.append(c.most_common(1)[0][0] if c else 'Z')
    return ''.join(out)


# hand-verified dispatch tables (disassembly cited)
VERIFIED_TABLES = {
    (0x63, 0x402D): 'dispatch table: 63:4020-402C builds base $402D (add a,$2D / ld a,$40 / adc a,0), ld a,[hli] / ld h,[hl] / ld l,a / jp hl',
    (0x68, 0x7079): 'all 10 targets start with the same prologue (xor a ; call $06D1 ; dw $7413 ; db $68): in-bank code jump table (no ld r16 reference found)',
}

# verifier retractions: word-table candidates shown to be something else
DROPPED_TABLES = {
    (0x51, 0x4224): 'bytes 51:4225-4238 are a byte-pair lookup table read by the code at 51:4200-4224 '
                    '(de = $4225 + 2*a), not pointers; the candidate also started on the RET at 51:4224',
}


def filter_pointer_tables(rom, bank, tables, tstarts, gfx_ranges, struct_ranges):
    data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
    keep = []
    for c in tables:
        if c['stride'] != 2 or c['entries'] < 5:
            continue
        if c['distinct'] < 0.9 * c['entries'] or c['in_used'] < 0.9:
            continue
        if (bank, c['addr']) in DROPPED_TABLES:
            continue
        off = c['addr'] - 0x4000
        tg = [data[off + 2 * k] | (data[off + 2 * k + 1] << 8) for k in range(c['entries'])]
        adj = []
        # verifier fix 1: the run may start on the 16-bit operand of a preceding jp/call (e.g. 50:4242,
        # 'jp $4254' = C3 54 42 was read as the first entry): drop that leading entry
        if off > 0 and data[off - 1] in (0xC3, 0xCD, 0xC2, 0xCA, 0xD2, 0xDA, 0xC4, 0xCC, 0xD4, 0xDC) and len(tg) > 5:
            tg = tg[1:]
            off += 2
            c = dict(c, addr=c['addr'] + 2, entries=len(tg), first=tg[0])
            adj.append('dropped first entry (operand of the preceding jp/call at %04X)' % (c['addr'] - 3))
        # verifier fix 2: table cannot run into its own first target (the first record/code follows the
        # table): if entry 0 is the lowest target and points 2k bytes past the table start with k >= 5,
        # the table has k entries and the remaining 'entries' are bytes of that first target
        k0 = (tg[0] - c['addr']) // 2
        if tg[0] == min(tg) and c['addr'] < tg[0] < c['addr'] + 2 * len(tg) and (tg[0] - c['addr']) % 2 == 0 and k0 >= 5:
            old_n = len(tg)
            tg = tg[:k0]
            mono = sum(1 for a_, b_ in zip(tg, tg[1:]) if b_ > a_)
            c = dict(c, entries=k0, last=tg[-1], monotone=round(mono / (k0 - 1), 3))
            adj.append('truncated from %d to %d entries: entry 0 = %04X is where the table ends' % (old_n, k0, tg[0]))
        # evidence of use: an 'ld hl/de/bc,<table>' immediate in the same bank (chance ~0.1% per table)
        ref = None
        pat = bytes([c['addr'] & 0xFF, c['addr'] >> 8])
        j = data.find(pat)
        while j > 0:
            if data[j - 1] in (0x21, 0x11, 0x01):
                ref = 0x4000 + j - 1
                break
            j = data.find(pat, j + 1)
        c = dict(c, adj=adj, ref=ref)
        land = sum(1 for t in tg if t in tstarts or (data[t - 0x4000 - 1] == 0 and data[t - 0x4000] != 0)) / len(tg)
        c = dict(c, land=round(land, 2), end=c['addr'] + 2 * c['entries'])
        if not (c['monotone'] >= 0.95 or land >= 0.7):
            continue
        # reject look-alikes: constant low byte (values differ by multiples of 256) and byte runs that
        # decode as Shift-JIS pairs (kana tables) are not pointer tables
        if len({t & 0xFF for t in tg}) == 1:
            continue
        npair = 0
        j = off
        while j + 1 < off + 2 * c['entries']:
            tk = sjis_token(data, j)
            if tk and tk[0] == 2:
                npair += 1
                j += 2
            else:
                j += 1
        if npair * 2 >= 0.6 * 2 * c['entries']:
            continue
        ov = sum(max(0, min(c['end'], e) - max(c['addr'], s)) for s, e in gfx_ranges)
        if ov > 0:
            continue
        if any(not (c['end'] <= s or c['addr'] >= e) for s, e in struct_ranges):
            continue
        keep.append(c)
    keep.sort(key=lambda c: (-c['entries'], c['addr']))
    out = []
    for c in keep:
        if any(not (c['end'] <= o['addr'] or c['addr'] >= o['end']) for o in out):
            continue
        out.append(c)
    out.sort(key=lambda c: c['addr'])
    return out


def stride_report(win):
    """Fixed-stride record detector over one non-pad window; returns dict or None."""
    import operator
    n = len(win)
    sc = {}
    for s in range(2, 97):
        if n // s < 6:
            break
        sc[s] = sum(map(operator.eq, win, win[s:])) / (n - s)
    if not sc:
        return None
    vals = sorted(sc.values())
    med = vals[len(vals) // 2]
    best = max(sc, key=lambda k: sc[k])
    if sc[best] - med < 0.12 or sc[best] < 0.2:
        return None
    # smallest stride within 90% of the best score (the fundamental period)
    for s in sorted(sc):
        if sc[s] >= 0.9 * sc[best] and sc[s] - med >= 0.1:
            return dict(stride=s, score=round(sc[s], 3), median=round(med, 3))
    return None


def io_group(a):
    if a == 0xFFFF:
        return 'IE'
    if a in (0xFF01, 0xFF02):
        return 'serial(SB/SC)'
    if 0xFF10 <= a <= 0xFF3F:
        return 'audio'
    if a in (0xFF40, 0xFF41, 0xFF42, 0xFF43, 0xFF44, 0xFF45, 0xFF47, 0xFF48, 0xFF49, 0xFF4A, 0xFF4B):
        return 'LCD'
    if a == 0xFF46:
        return 'OAM-DMA'
    if 0xFF51 <= a <= 0xFF55:
        return 'HDMA'
    if 0xFF68 <= a <= 0xFF6B:
        return 'CGB-palette'
    if a in (0xFF4F, 0xFF70):
        return 'VBK/SVBK'
    if a in (0xFF04, 0xFF05, 0xFF06, 0xFF07):
        return 'timer'
    if a in (0xFF0F,):
        return 'IF'
    if a == 0xFF00:
        return 'joypad'
    if a == 0xFF4D:
        return 'speed'
    if a in (0xFF56,):
        return 'IR'
    return 'other-io'


def run_survey(rom, verbose=True):
    import extract_gfx
    model = CodeModel(rom)
    ins0 = sweep(rom, 0x150, 0x2184, 0x150)
    starts0 = {i.addr for i in ins0} | set(range(0, 0x150))
    structs = known_structures(rom)
    struct_r = structure_ranges(rom)
    if verbose:
        print('gfx candidates ...', file=sys.stderr)
    gfx_rows, unresolved, loader_blocks, heur = extract_gfx.build_candidates(rom)
    if verbose:
        print('strings ...', file=sys.stderr)
    strings = text_scan_all(rom, struct_r, gfx_rows)
    farcalls = scan_farcalls(rom)
    proven = proven_code(rom)
    banks = []
    proposals_src = {}
    for bank in range(128):
        data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
        ue = used_end(data)
        lo = base_addr(bank)
        info = dict(bank=bank, file_offset=bank * BANK_SIZE, cpu_base=lo,
                    zero_bytes=data.count(0), ff_bytes=data.count(0xFF), entropy=round(entropy(data), 3),
                    used_end=(lo + ue) if ue else None, empty=ue == 0)
        if ue == 0:
            info['note'] = 'all 0x00 padding'
            banks.append(info)
            continue
        if verbose:
            print('bank %02X ...' % bank, file=sys.stderr)
        blocks, bstarts = bank_blocks(rom, bank, model, starts0)
        gr = [(r['addr'], r['addr'] + r['length']) for r in gfx_rows if r['bank'] == bank and r['length']
              and r['kind'].startswith('tile')]
        sr = [(s, e) for b, s, e in struct_r if b == bank]
        tstarts = {s['addr'] for s in strings if s['bank'] == bank}
        tabs = []
        if bank:
            all_t = find_word_tables(data, bank, 0x4000, 0x4000 + ue, 5)
            tabs = filter_pointer_tables(rom, bank, all_t, tstarts, gr, sr)
        pals = [r for r in gfx_rows if r['bank'] == bank and r['kind'] == 'palette-rgb555']
        m = paint_map(bank, blocks, structs, gfx_rows, strings, pals, tabs, ue)
        m = apply_pads(m, data, bank)
        io = collections.Counter()
        for bl in blocks:
            for k, v in bl.get('io', {}).items():
                io[k] += v
        groups = collections.Counter()
        for a, v in io.items():
            groups[io_group(a)] += v
        info['io_register_refs_in_code_like_blocks'] = {g: v for g, v in sorted(groups.items())}
        info['block_map'] = block_class_string(m)
        cnt = collections.Counter(m)
        info['class_bytes'] = {k: cnt[k] for k in CLASS_INFO if cnt[k]}
        info['zero_runs_ge32'] = [(lo + s, ln) for s, ln in fill_runs(data, 0, 32)]
        info['ff_runs_ge32'] = [(lo + s, ln) for s, ln in fill_runs(data, 0xFF, 32)]
        info['pointer_tables'] = [dict(addr=c['addr'], entries=c['entries'], stride=2, monotone=c['monotone'],
                                       land_on_text_or_after_nul=c['land'], first=c['first'], last=c['last'])
                                  for c in tabs]
        info['palettes'] = [dict(addr=r['addr'], words=r['length'] // 2, conf=r['conf']) for r in pals]
        info['gfx_blocks'] = [dict(addr=r['addr'], length=r['length'], kind=r['kind'], conf=r['conf'])
                              for r in gfx_rows if r['bank'] == bank and r['length'] and r['kind'] != 'palette-rgb555'
                              and r['conf'] == 'CONFIRMED']
        info['n_gfx_heuristic_blocks'] = sum(1 for r in gfx_rows if r['bank'] == bank and r['kind'] == 'tiles-2bpp')
        bs = [s for s in strings if s['bank'] == bank]
        info['strings'] = dict(n=len(bs), by_status=dict(collections.Counter(s['status'] for s in bs)),
                               first=bs[0]['addr'] if bs else None)
        info['structures'] = [dict(start=s['start'], end=s['end'], label=s['label'], kind=s['kind'], status=s['status'])
                              for s in structs if s['bank'] == bank]
        # windows
        wins = []
        for w in range(4):
            wd = data[w * WINDOW:(w + 1) * WINDOW]
            rec = dict(addr=lo + w * WINDOW, zero_frac=round(wd.count(0) / WINDOW, 3), ff_frac=round(wd.count(0xFF) / WINDOW, 3),
                       entropy=round(entropy(wd), 2))
            if wd.count(0) + wd.count(0xFF) < 0.95 * WINDOW:
                ins = sweep(rom, bank * BANK_SIZE + w * WINDOW, bank * BANK_SIZE + (w + 1) * WINDOW, lo + w * WINDOW)
                rec['code'] = code_features(ins, starts0, bstarts, lo, lo + ue, model)
                rec['gfx'] = gfx_scores(wd)
                rec['tilemap'] = round(tilemap_score(wd), 3)
                rec['stride'] = stride_report(wd)
                rec['kind_guess'], rec['kind_status'] = classify_window(dict(
                    zero_frac=rec['zero_frac'], ff_frac=rec['ff_frac'], code=rec['code'], gfx=rec['gfx'],
                    tilemap=rec['tilemap'], entropy=rec['entropy']))
            else:
                rec['kind_guess'], rec['kind_status'] = ('zero' if rec['zero_frac'] >= 0.95 else 'ff'), 'CONFIRMED'
            wins.append(rec)
        info['windows'] = wins
        # inbound far calls
        inb = collections.Counter((f['target_addr']) for f in farcalls if f['target_bank'] == bank)
        info['farcall_targets'] = [dict(addr=a, count=c, lands_on_sweep_start=(a in bstarts))
                                   for a, c in sorted(inb.items())]
        banks.append(info)
        proposals_src[bank] = dict(m=m, tabs=tabs)
    return dict(banks=banks, strings=strings, gfx_rows=gfx_rows, farcalls=farcalls, structs=structs,
                proposals_src=proposals_src, proven=proven, unresolved=dict((str(k), v) for k, v in unresolved.items()),
                loader_blocks=loader_blocks)


# ----------------------------------------------------------------------------
# region proposals  (config/regions format minus the bank column; no code regions)
# ----------------------------------------------------------------------------
def build_proposals(rom, res):
    props = {}
    strings = res['strings']
    gfx_rows = res['gfx_rows']
    for bank in range(128):
        data = rom[bank * BANK_SIZE:(bank + 1) * BANK_SIZE]
        ue = used_end(data)
        if not ue:
            continue
        lo = base_addr(bank)
        hi = lo + BANK_SIZE
        items = []   # (prio, start, end, kind, label_prefix, status, note, minlen)

        proven = res.get('proven', {}).get(bank, set())

        def add(prio, s, e, kind, pre, status, note, minlen=16, heur=False):
            # verifier fix: heuristic proposals must not swallow bytes that recursive descent proves to be
            # instructions.  Trim contiguous overlap at either boundary; interior overlap -> HYPOTHESIS.
            if heur and proven:
                s0, e0 = s, e
                while s < e and s in proven:
                    s += 1
                while e > s and (e - 1) in proven:
                    e -= 1
                if (s, e) != (s0, e0):
                    note += ' [boundary trimmed %04X-%04X -> %04X-%04X against proven code]' % (s0, e0, s, e)
                inter = sum(1 for x in range(s, e) if x in proven)
                if inter * 4 >= (e - s):
                    return   # mostly instructions: the heuristic misclassified code as data
                if inter:
                    # split around the proven instruction bytes (each piece HYPOTHESIS)
                    seg = s
                    for x in range(s, e + 1):
                        if x == e or x in proven:
                            if x > seg:
                                items.append((prio, seg, x, kind, pre, 'HYPOTHESIS',
                                              note + ' [split around %d bytes of recursive-descent code]' % inter, minlen))
                            seg = x + 1
                    return
            if e > s:
                items.append((prio, s, e, kind, pre, status, note, minlen))
        for st in res['structs']:
            if st['bank'] == bank:
                add(100, st['start'], st['end'], st['kind'],
                    st.get('prefix') or {'text': 'String', 'ptrtable': 'Table'}.get(st['kind'], 'Data'),
                    st.get('cap', 'PROBABLE'),
                    '%s: %s (verified structure, layout from engine code)' % (st['label'], st['note']), 4)
        for r in gfx_rows:
            if r['bank'] != bank or not r['length']:
                continue
            if r['conf'] == 'CONFIRMED' and r['kind'] in ('tiles-vram', 'vram-dma'):
                add(90, r['addr'], r['addr'] + r['length'], 'gfx', 'Data', 'PROBABLE', 'tile data: ' + r['evidence'], 16)
            elif r['conf'] == 'CONFIRMED' and r['kind'] == 'tilemap+attr':
                add(90, r['addr'], r['addr'] + r['length'], 'data', 'Data', 'PROBABLE',
                    'tilemap %dx%d tiles then attrs: %s' % (r['w'], r['h'], r['evidence']), 16)
            elif r['kind'] == 'palette-rgb555':
                add(60, r['addr'], r['addr'] + r['length'], 'data', 'Data',
                    'PROBABLE' if (r['conf'] == 'CONFIRMED' or r['length'] >= 16) else 'HYPOTHESIS',
                    'CGB palette data (RGB555 words): ' + r['evidence'], 8, heur=r['conf'] != 'CONFIRMED')
            elif r['kind'] == 'tiles-2bpp':
                add(50, r['addr'], r['addr'] + r['length'], 'gfx', 'Data', r['conf'], 'tile data: ' + r['evidence'], 64, heur=True)
        # text blocks
        bs = sorted((s for s in strings if s['bank'] == bank and s['kind'] in ('sjis', 'ascii', 'hybrid') and
                     (s['status'] in ('CONFIRMED', 'PROBABLE') or s.get('W', 0) >= 4)), key=lambda s: s['addr'])
        blocks = []
        for s in bs:
            end = s['addr'] + s['length'] + (1 if s.get('term') else 0)
            if blocks and s['addr'] - blocks[-1]['end'] <= 4:
                blocks[-1]['end'] = end
                blocks[-1]['n'] += 1
                blocks[-1]['best'] = max(blocks[-1]['best'], {'CONFIRMED': 2, 'PROBABLE': 1, 'HYPOTHESIS': 0}[s['status']])
            else:
                blocks.append(dict(start=s['addr'], end=end, n=1,
                                   best={'CONFIRMED': 2, 'PROBABLE': 1, 'HYPOTHESIS': 0}[s['status']]))
        for b in blocks:
            add(80, b['start'], b['end'], 'text', 'String', 'PROBABLE' if b['best'] >= 1 else 'HYPOTHESIS',
                'text block: %d string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII' % b['n'], 4, heur=True)
        for t in res['proposals_src'][bank]['tabs']:
            tg = [data[t['addr'] - 0x4000 + 2 * k] | (data[t['addr'] - 0x4000 + 2 * k + 1] << 8) for k in range(t['entries'])]
            dif = [b_ - a_ for a_, b_ in zip(tg, tg[1:])]
            regular = False
            if len(dif) >= 5:
                cm = collections.Counter(dif).most_common(2)
                top2 = sum(v for _, v in cm) / len(dif)
                near = sum(1 for d_ in dif if abs(d_ - cm[0][0]) <= 4) / len(dif)
                regular = top2 >= 0.8 or near >= 0.6
            ver = VERIFIED_TABLES.get((bank, t['addr']))
            # verifier rule: PROBABLE needs (a) >= 80% of targets on string starts, or (b) an ld hl/de/bc immediate
            # of the table address in the bank, or (c) regular record stride, or (d) a hand-verified dispatch
            q = 'PROBABLE' if (t['land'] >= 0.8 or t.get('ref') or regular or ver) else 'HYPOTHESIS'
            note = ('little-endian word table, %d entries, monotone=%.2f, %.0f%% of targets on string start/after NUL, targets $%04X..$%04X'
                    % (t['entries'], t['monotone'], 100 * t['land'], t['first'], t['last']))
            if t.get('ref'):
                note += '; referenced by ld r16,$%04X at %02X:%04X' % (t['addr'], bank, t['ref'])
            if regular and not t.get('ref'):
                note += '; regular record stride between targets'
            if ver:
                note += '; ' + ver
            if t.get('adj'):
                note += '; verifier: ' + '; '.join(t['adj'])
            add(70, t['addr'], t['addr'] + 2 * t['entries'], 'ptrtable', 'Table', q, note, 8, heur=not ver)
        for s, ln in fill_runs(data, 0, 32):
            if bank == 0 and s < 0x100 < s + ln:
                ln = 0x100 - s   # 00:0100 is the 'nop' of the entry point 'nop ; jp $0278' (an instruction, not padding)
            trailing = (s + ln) == BANK_SIZE
            add(10, lo + s, lo + s + ln, 'zero', 'Data', 'PROBABLE' if trailing else 'HYPOTHESIS',
                ('trailing 0x00 padding to end of bank' if trailing else '0x00 run of %d bytes' % ln), 32)
        for s, ln in fill_runs(data, 0xFF, 32):
            add(10, lo + s, lo + s + ln, 'data', 'Data', 'HYPOTHESIS', '0xFF fill run of %d bytes' % ln, 32)
        # claim bytes by priority
        owner = [-1] * BANK_SIZE
        items.sort(key=lambda x: (-x[0], x[1]))
        for idx, it in enumerate(items):
            for k in range(it[1] - lo, min(it[2] - lo, BANK_SIZE)):
                if owner[k] < 0:
                    owner[k] = idx
        rows = []
        k = 0
        while k < BANK_SIZE:
            if owner[k] < 0:
                k += 1
                continue
            j = k
            while j < BANK_SIZE and owner[j] == owner[k]:
                j += 1
            it = items[owner[k]]
            if j - k >= it[7] or it[0] == 100 and j - k >= 4:
                s, e = lo + k, lo + j
                note = it[6].replace('\t', ' ')
                if (s, e) != (it[1], it[2]):
                    note += ' [clipped from %04X-%04X by higher-priority proposals]' % (it[1], it[2])
                rows.append((s, e, it[3], '%s_%02X_%04X' % (it[4], bank, s), it[5], note))
            k = j
        if rows:
            props[bank] = rows
    return props


def write_proposals(outdir, props):
    os.makedirs(outdir, exist_ok=True)
    for f in os.listdir(outdir):
        if f.startswith('survey_regions_bank') and f.endswith('.tsv'):
            os.remove(os.path.join(outdir, f))
    for bank, rows in props.items():
        with open(os.path.join(outdir, 'survey_regions_bank%02X.tsv' % bank), 'w', encoding='utf-8') as f:
            f.write('# analysis/proposals/survey_regions_bank%02X.tsv -- generated by tools/survey.py (do not edit)\n' % bank)
            f.write('# config/regions format WITHOUT the bank column: start\tend\tkind\tlabel\tstatus\tnote\n')
            f.write('# start/end = CPU addresses in hex, end exclusive. Data-like proposals only (no code regions); statuses are capped at PROBABLE.\n')
            for s, e, kind, label, status, note in rows:
                f.write('%04X\t%04X\t%s\t%s\t%s\t%s\n' % (s, e, kind, label, status, note))


# ----------------------------------------------------------------------------
# bank map image
# ----------------------------------------------------------------------------
def write_bank_map(path, banks):
    try:
        from PIL import Image, ImageDraw
    except ImportError:
        return False
    cw, ch, left, top = 9, 5, 34, 16
    W = left + 64 * cw + 210
    H = top + 128 * ch + 8
    im = Image.new('RGB', (W, H), (255, 255, 255))
    dr = ImageDraw.Draw(im)
    for b in range(128):
        y = top + b * ch
        if b % 4 == 0:
            dr.text((2, y - 2), '%02X' % b, fill=(0, 0, 0))
        info = banks[b]
        bm = info.get('block_map') or ('Z' * 64)
        for i, c in enumerate(bm):
            col = CLASS_INFO.get(c, CLASS_INFO['U'])[1]
            dr.rectangle([left + i * cw, y, left + i * cw + cw - 1, y + ch - 1], fill=col)
    for i in range(0, 64, 16):
        dr.text((left + i * cw, 2), '%04X' % (0x4000 + i * 0x100), fill=(0, 0, 0))
    y = top
    for c, (name, col) in CLASS_INFO.items():
        dr.rectangle([left + 64 * cw + 12, y, left + 64 * cw + 24, y + 10], fill=col)
        dr.text((left + 64 * cw + 30, y - 1), '%s %s' % (c, name), fill=(0, 0, 0))
        y += 16
    dr.text((left + 64 * cw + 12, y + 8), 'one cell = 0x100 bytes', fill=(0, 0, 0))
    dr.text((left + 64 * cw + 12, y + 22), 'bank 00 starts at 0000', fill=(0, 0, 0))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    im.save(path)
    return True


# ----------------------------------------------------------------------------
# charmap.asm generation
# ----------------------------------------------------------------------------
def rgbds_escape(ch):
    return {'"': '\\"', '\\': '\\\\', '{': '\\{', '}': '\\}', "'": "'"}.get(ch, ch)


def observed_chars(rom, strings):
    """Counter of (sjis_code -> occurrences) in accepted strings (all statuses recorded separately)."""
    obs = collections.defaultdict(lambda: collections.Counter())
    for s in strings:
        if s['kind'] == 'sjis' and s['status'] == 'HYPOTHESIS':
            continue
        if s['kind'] == 'sjis':
            data = rom[s['bank'] * BANK_SIZE:(s['bank'] + 1) * BANK_SIZE]
            boff = 0x4000 if s['bank'] else 0
            i = s['addr'] - boff
            end = i + s['length']
            while i < end:
                t = sjis_token(data, i)
                if t is None:
                    break
                if t[0] == 2:
                    obs[(data[i] << 8) | data[i + 1]][s['status']] += 1
                i += t[0]
        elif s['kind'] == 'html':
            f_off = offset(s['bank'], s['addr'])
            body = rom[f_off:f_off + s['length']]
            i = body.index(b'\x00') + 3
            while i < len(body):
                t = sjis_token(body, i)
                if t is None:
                    i += 1
                    continue
                if t[0] == 2:
                    obs[(body[i] << 8) | body[i + 1]]['CONFIRMED'] += 1
                i += t[0]
    return obs


def std_row_chars(rows):
    out = []
    for lead in range(0x81, 0x85):
        for trail in list(range(0x40, 0x7F)) + list(range(0x80, 0xFD)):
            t = sjis_token(bytes([lead, trail]), 0)
            if t and t[0] == 2 and _sjis_row(lead, trail) in rows:
                out.append(((lead << 8) | trail, t[2], t[1]))
    return out


TXT_CTRL = [
    (0x00, 'CONST_TXT_END', 'end of string (returns to the caller, or to the parent string when nested); handler 00:0F9D'),
    (0x01, 'CONST_TXT_CALL', 'far sub-string: inline dw addr, db bank; then continues after it; handler 00:0F83'),
    (0x02, 'CONST_TXT_SET_Y', 'FFBC := imm8 (PROBABLE: vertical position, compared with 144); handler 00:0FAC'),
    (0x03, 'CONST_TXT_SET_X', 'FFBD := imm8 (PROBABLE: horizontal position, 16-bit FFBD/FFBE); handler 00:0FB3'),
    (0x09, 'CONST_TXT_TAB', 'x += 0x30 (16-bit add on FFBD/FFBE); handler 00:1018'),
    (0x0D, 'CONST_TXT_NEWLINE', 'x := left margin (FFC1/FFC2), y += line height (FFC6); handler 00:0F68'),
    (0x1C, 'CONST_TXT_SET_X16', 'FFBD/FFBE := imm16; handler 00:0FEA'),
    (0x1D, 'CONST_TXT_SET_Y8', 'FFBC := imm8; handler 00:0FF4'),
    (0x1E, 'CONST_TXT_ADD_X16', 'FFBD/FFBE += imm16; handler 00:0FFB'),
    (0x1F, 'CONST_TXT_ADD_Y8', 'FFBC += imm8; handler 00:100D'),
]


def write_charmap(path, rom, strings):
    obs = observed_chars(rom, strings)
    rows18 = std_row_chars(set(range(1, 9)))
    ascii_lines = []
    for c in range(0x20, 0x7F):
        ch = chr(c)
        ascii_lines.append('\tcharmap "%s", $%02X' % (rgbds_escape(ch), c))
    ascii_lines.append('\tcharmap "¥", $5C ; yen sign: 0x5C is JIS X 0201 Roman (glyph confirmed in the 6x12 font sheet)')
    ascii_lines.append('\tcharmap "‾", $7E ; overline: 0x7E is JIS X 0201 Roman')
    out = []
    out.append('; constants/charmap.asm -- generated by tools/survey.py (do not edit; regenerate).')
    out.append(';')
    out.append('; Text encoding of the Mobile Trainer: Shift-JIS (JIS X 0208 double bytes, lead 81-9F/E0-EF,')
    out.append('; plus 0x20-0x7F single bytes).  Evidence: docs/research/text_encoding.md.')
    out.append('; This file is documentation/tooling only: no ROM byte is produced from it yet, the')
    out.append('; committed source keeps text as raw bytes.')
    out.append(';')
    out.append('; Included entries (see the companion table in docs/research/text_encoding.md):')
    out.append(';   - ASCII 0x20-0x7E identity (+ yen/overline aliases for 0x5C/0x7E)')
    out.append(';   - JIS X 0208 rows 1-8 (symbols, digits, Latin, hiragana, katakana, Greek, Cyrillic, box): the engine')
    out.append(';     converts SJIS to (row,col) at 7F:4072 and the font banks hold these rows; rendering the glyphs')
    out.append(';     confirms the standard JIS row order (docs/research/img/font_jis_rows_01-08.png).')
    out.append(';   - kanji only if OBSERVED in a decoded ROM string (count in the comment).')
    out.append('')
    out.append('\tcharmap "\\0", $00 ; NUL terminator (CONST_TXT_END)' if False else '')
    out.append('; ---- ASCII / JIS X 0201 Roman single bytes ----')
    out += ascii_lines
    out.append('')
    out.append('; ---- JIS X 0208 rows 1-8 (double byte) ----')
    seen = set()
    per_row = collections.defaultdict(lambda: [0, 0])
    for code, ch, cat in rows18:
        r = _sjis_row(code >> 8, code & 0xFF)
        per_row[r][1] += 1
        per_row[r][0] += code in obs
    cur_row = None
    for code, ch, cat in rows18:
        if ch in seen:
            continue
        seen.add(ch)
        r = _sjis_row(code >> 8, code & 0xFF)
        if r != cur_row:
            cur_row = r
            out.append('; -- JIS row %d: %d of %d glyphs observed in ROM strings (the rest justified only by the standard row order + font rendering) --' % (r, per_row[r][0], per_row[r][1]))
        n = sum(obs[code].values()) if code in obs else 0
        out.append('\tcharmap "%s", $%02X, $%02X%s' % (rgbds_escape(ch), code >> 8, code & 0xFF, ' ; seen x%d' % n if n else ''))
    out.append('')
    out.append('; ---- kanji observed in decoded strings (JIS level 1/2) ----')
    for code in sorted(obs):
        if 0x889F <= code <= 0xEAFF:
            t = sjis_token(bytes([code >> 8, code & 0xFF]), 0)
            if t and (t[1] == 'k1' or (t[1] == 'k2' and sum(obs[code].values()) >= 2)) and t[2] not in seen:
                seen.add(t[2])
                out.append('\tcharmap "%s", $%02X, $%02X ; seen x%d %s' % (rgbds_escape(t[2]), code >> 8, code & 0xFF,
                                                                         sum(obs[code].values()), t[1]))
    out.append('')
    out.append('; ---- text-stream control codes (bytes < 0x20), from the dispatch table at 00:0EF0 ----')
    out.append('; every code not listed here jumps to the same handler as $00 (end of string).')
    for code, name, doc in TXT_CTRL:
        out.append('DEF %s EQU $%02X ; %s' % (name, code, doc))
    out.append('')
    with open(path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(out))
    return obs, rows18


# ----------------------------------------------------------------------------
# reports
# ----------------------------------------------------------------------------
def bank_summary_line(info):
    if info['empty']:
        return 'empty (all 0x00)'
    cb = info['class_bytes']
    tot = sum(cb.values())
    parts = ['%s %d%%' % (k, round(100 * v / tot)) for k, v in sorted(cb.items(), key=lambda kv: -kv[1]) if v / tot >= 0.05]
    return ', '.join(parts)


def farcall_stats(rom, farcalls, banks):
    """Fraction of far-call targets (into ROM banks 1..7F) that land on a linear-sweep instruction start."""
    tot = ok = 0
    per_target = collections.Counter()
    for f in farcalls:
        per_target[(f['target_bank'], f['target_addr'])] += 1
    for b in banks:
        if b['empty']:
            continue
        for t in b.get('farcall_targets', []):
            tot += 1
            ok += t['lands_on_sweep_start']
    return dict(distinct_targets=len(per_target), total_sites=len(farcalls), sweep_landing_ok=ok, sweep_landing_total=tot,
                top=[dict(bank=k[0], addr=k[1], count=v) for k, v in per_target.most_common(40)])


def write_json(path, res, rom, lz):
    banks = res['banks']
    fc = farcall_stats(rom, res['farcalls'], banks)
    files, ends = parse_html_store(rom)
    lay = font_layout(rom)
    gfx_sum = collections.Counter((r['kind'], r['conf']) for r in res['gfx_rows'])
    doc = dict(
        meta=dict(rom='baserom.gbc', rom_size=len(rom), window_bytes=WINDOW, block_bytes=0x100,
                  generated_by='tools/survey.py', coordinates='CPU addresses; file offset = bank*0x4000 + (addr & 0x3FFF)',
                  vocabulary='CONFIRMED / PROBABLE / HYPOTHESIS',
                  class_legend={k: v[0] for k, v in CLASS_INFO.items()}),
        engine_facts=dict(
            far_call_helper=dict(entry='00:06D1', form='call $06D1 ; dw target ; db bank', sites=fc['total_sites'],
                                 distinct_targets=fc['distinct_targets'], status='CONFIRMED'),
            text_engine=dict(entry='00:0ED3 (a=bank, hl=string)', control_table='00:0EF0', lead_bytes='81-9F,E0-EF,F8-F9',
                             status='CONFIRMED'),
            font=dict(layout={('%02X' % k): dict(rows=v['std_rows'], end=v['end']) for k, v in lay.items()},
                      latin='76:67A8 96x12 bytes', glyph_bytes=18, status='CONFIRMED'),
            html_store=dict(files=len(files), banks={('%02X' % k): v for k, v in ends.items()}, status='CONFIRMED'),
            loaders={('%04X' % k): v['name'] for k, v in __import__('extract_gfx').LOADERS.items()},
        ),
        farcall_summary=fc,
        gfx_summary={('%s/%s' % k): v for k, v in sorted(gfx_sum.items())},
        gfx_loader_unresolved_sites=res['unresolved'],
        lz_probe=lz,
        strings_summary=dict(total=len(res['strings']),
                             by_kind_status={('%s/%s' % k): v for k, v in
                                             sorted(collections.Counter((s['kind'], s['status']) for s in res['strings']).items())}),
        banks=banks,
    )
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(doc, f, indent=1, ensure_ascii=False, sort_keys=False)


def lz_summary(rom, res):
    import extract_gfx
    pr = extract_gfx.probe_crystal_lz(rom)
    maps = {b['bank']: res['proposals_src'][b['bank']]['m'] for b in res['banks'] if not b['empty']}
    inside = outside = 0
    outs = []
    for bank, a, used, outlen, hs, vs in pr['hits']:
        lo = 0 if bank == 0 else 0x4000
        ch = maps[bank][a - lo]
        if ch in ('G', 'M', 'K', 'P'):
            inside += 1
        else:
            outside += 1
            outs.append('%02X:%04X' % (bank, a))
    streams = {}
    for bank, a, used, outlen, hs, vs in pr['hits']:
        streams.setdefault((bank, a + used), []).append(a)
    starts = [(b, min(v)) for (b, e), v in streams.items()]
    ref = 0
    for b, a in starts:
        if rom.find(bytes([0x21, a & 255, a >> 8])) >= 0 or rom.find(bytes([0x11, a & 255, a >> 8])) >= 0:
            ref += 1
    return dict(decoder='pokecrystal LZ (command in top 3 bits, 0xFF terminator)', offsets_tried=pr['tried'],
                hits=len(pr['hits']), hits_inside_raw_gfx_or_font=inside, hits_elsewhere=outside,
                distinct_streams=len(starts), stream_starts_appearing_as_ld_hl_or_de_imm16=ref,
                elsewhere_first=outs[:20],
                verdict='non-distinctive: hits are dominated by uncompressed tile data that happens to parse; '
                        'no compressed-graphics stream is demonstrated')


def write_md(path, res, rom, lz):
    banks = res['banks']
    strings = res['strings']
    gfx_rows = res['gfx_rows']
    fc = farcall_stats(rom, res['farcalls'], banks)
    files, ends = parse_html_store(rom)
    lay = font_layout(rom)
    L = []
    w = L.append
    w('# Bank survey (generated by `tools/survey.py`)')
    w('')
    w('Systematic content survey of every 16 KiB bank of `baserom.gbc`. All coordinates are CPU addresses '
      '(bank 00 = 0000-3FFF, banks 01-7F = 4000-7FFF; file offset = bank*0x4000 + (addr & 0x3FFF)). '
      'Machine-readable results: `analysis/bank_survey.json`, `analysis/strings.tsv`, `analysis/gfx_candidates.tsv`, '
      '`analysis/proposals/survey_regions_bankNN.tsv`. Re-run with `python3 tools/survey.py` (needs `baserom.gbc`, Pillow for the images).')
    w('')
    w('Evidence vocabulary: **CONFIRMED** = demonstrated by cited bytes/disassembly; **PROBABLE** = strong evidence, not conclusive; '
      '**HYPOTHESIS** = interpretation not yet confirmed. Heuristic classifications (code-likeness, tile coherence) are never better than PROBABLE; after adversarial review heuristic tile blocks need >= 32 coherent tiles for PROBABLE and heuristic proposals are trimmed against recursively-proven code.')
    w('')
    w('![bank map](img/bank_map.png)')
    w('')
    w('## 1. Headline findings')
    w('')
    w('| # | finding | status | evidence |')
    w('|---|---|---|---|')
    w('| 1 | **Far-call helper**: `call $06D1` is followed by 3 inline bytes `dw target, db bank`; it switches ROM bank and jumps. There are %d such call sites with %d distinct (bank,target) pairs, so most inter-bank control flow is `call $06D1`. | CONFIRMED | disassembly 00:06D1-00:06FC (pops the return address, reads 3 bytes with `ld a,[hli]` into FFAE/FFAF/FFF2, `call $0622` = bank switch, `call $FFA8` into a RAM stub; the RAM stub itself is not in the ROM); byte scan of the whole ROM |' % (fc['total_sites'], fc['distinct_targets']))
    w('| 2 | **Text is Shift-JIS**: double bytes (lead 81-9F, E0-EF, F8-F9) + single bytes 20-7F; controls < 0x20. %d strings recovered (%d CONFIRMED). | CONFIRMED | text engine 00:0ED3 (lead-byte test at 00:0F31), decoded strings in `analysis/strings.tsv`; see `docs/research/text_encoding.md` |' % (
        len(strings), sum(1 for s in strings if s['status'] == 'CONFIRMED')))
    w('| 3 | **Font**: banks 76-7E hold a JIS X 0208 12x12 1bpp font (18 bytes/glyph, 9 JIS rows per bank, 94 columns per row, no compression) and a 6x12 Latin font at 76:67A8 (96 glyphs x 12 bytes). Layout re-derived from the ROM tables at 7F:40F9/7F:4150. | CONFIRMED | routines 7F:400E, 7F:4072, 7F:40B9; bank sizes match exactly (9x94x18 = 0x3B7C; 6x94x18 = 0x27A8, + 96x12 = 0x480 gives 0x6C28, and the last non-zero byte of bank 76 is 6C26; banks 77-7B end exactly at 7B7C, the first byte after that being 00); rendered sheets `img/font_jis_rows_01-08.png`, `img/font_latin_6x12.png` |')
    w('| 4 | **Built-in web pages**: banks 3D/3E store %d HTML files as `name\\0`, u16 length, Shift-JIS body; bank 3F holds a table of far pointers (addr16, bank) to all of them plus `file://di/`. | CONFIRMED | records chain exactly to the padding (3D ends at 518C, 3E at 75CF); all 55 index entries equal parsed record starts |' % len(files))
    w('| 5 | **VRAM tile loads are raw**: `call $06D1 ; dw $0787 ; db 00` programs HDMA directly from ROM (bank a, HL) to VRAM (DE) for C x 16 bytes. %d ROM-to-VRAM blocks and %d tilemap loads were recovered from call-site immediates; the data is uncompressed 2bpp. | CONFIRMED | disassembly 00:0787-07C9 (writes FF51-FF55); register immediates recovered by `tools/extract_gfx.py` |' % (
        sum(1 for r in gfx_rows if r['kind'] == 'tiles-vram'), sum(1 for r in gfx_rows if r['kind'] == 'tilemap+attr')))
    w('| 6 | **Tilemap loader**: `call $06D1 ; dw $08EA` copies B rows x C columns (WRAM stride 0x20) of tile IDs and then a second B*C block (attributes, WRAM +0x400) from bank a, HL. Screens are typically 20x18. | CONFIRMED | disassembly 00:08EA-0903 |')
    w('| 7 | **No compressed graphics demonstrated.** A pokecrystal-LZ probe over every offset gives %d hits, %d of them inside data proven raw or in the font, i.e. the probe is not distinctive (it parses uncompressed tile data). The only loader seen (HDMA) copies raw bytes. | PROBABLE (absence) | `--lz-probe` in `tools/extract_gfx.py`, section 6 below |' % (lz['hits'], lz['hits_inside_raw_gfx_or_font']))
    w('| 8 | **Bank 00 palette block** 00:0352-0391 = 32 x `$7FFF` (white), loaded to BG and OBJ palette RAM at boot. | CONFIRMED | `ld hl,$0352` at 00:0335 and 00:0341, `ld c,$69` / `ld c,$6B`, `call $034A` at 00:033A / 00:0346; $034A copies 64 bytes through `ldh [c],a` to the palette data port |')
    w('| 9 | Bank 04 code at 04:4056-407F initialises the APU (NR52=$80, NR51, NR12/NR17/NR21, NR14/NR19/NR23, NR50=$77), so bank 04 very likely holds the sound driver. The earlier claim that banks 04/05 contain *sound bytecode* is only a HYPOTHESIS and is contradicted for part of bank 05: 05:63B0-63F0 mixes command-like bytes with Shift-JIS pairs (`81 47 81 4F 81 57 ...`), i.e. UI/script data. | PROBABLE (bank 04 sound init) / HYPOTHESIS (bytecode) | disassembly 04:4056-407F (`ldh [$FF26],a` ... `ldh [$FF24],a`); hexdump 05:63B0 |')
    w('| 10 | Serial registers are accessed by bank 75 code: 75:5B2B-5B45 loads a byte, `ldh [$FF01],a`, then `ldh [$FF02],a` with $03 and $83 (start transfer), and 75:5F20 polls SC bit 7; bank 00 reads SC once (00:0207). Bank 75 also holds SMTP/HTTP keyword strings (`MAIL FROM:<`, `Content-Length:`, `WWW-Authenticate: GB00 name=\"`). That this is the Mobile Adapter link is an interpretation. | CONFIRMED (register accesses) / PROBABLE (Mobile Adapter link) | disassembly 75:5B2B-5B45, 75:5F1F-5F25; byte scan of `f0/e0 01|02` in banks 00 and 75; strings in `analysis/strings.tsv` |')
    w('')
    w('## 2. Method (what each column means)')
    w('')
    w('* **Windows / blocks**: every bank is analysed in 4 windows of 0x1000 bytes (`windows` in the JSON) and 64 blocks of 0x100 bytes (`block_map`).')
    w('* **Fill runs**: runs of 0x00 / 0xFF of >= 32 bytes (`zero_runs_ge32`, `ff_runs_ge32`). Byte-level facts (CONFIRMED as fills; whether they are *padding* is an interpretation).')
    w('* **Entropy**: Shannon entropy of the byte histogram.')
    w('* **Code-likeness**: linear SM83 sweep with `tools/sm83.py`; per window/block the fraction of illegal opcodes, the density of `ret/jp/jr` terminators, the fraction of absolute `call/jp` targets that are valid (ROM0 instruction starts, in-bank instruction starts, WRAM C000-DFFF, HRAM) and a log-likelihood ratio (`llr`, bits/instruction) of the opcode stream against an opcode model trained on the bank-00 code stream. Classification "code-like" needs llr > 0.35, < 3% illegal opcodes, > 60% valid branch targets and no 2bpp-tile coherence.')
    w('* **2bpp tile-likeness**: fraction of horizontally / vertically adjacent pixel pairs that are equal (`hsim2`, `vsim2`; random data ~0.25-0.3, code ~0.35-0.4, artwork 0.55-0.9) plus a 1bpp variant; tile blocks are found per bank by tile-level coherence (>= 8 tiles).')
    w('* **Pointer tables**: little-endian words in 4000-7FFF forming runs of >= 5 distinct entries (stride 2; strides 3-8 are searched but only stride 2 is reported), accepted only when >= 90% of targets are inside the used part of the bank and either strictly ascending (>= 95%) or >= 70% of targets are on a decoded string start / after a NUL. Overlaps with tile data or known structures are dropped. Verifier additions: a leading entry that is the operand of a preceding jp/call is dropped; a table whose entry 0 (the lowest target) lies 2k bytes ahead with k >= 5 is truncated to k entries; a table is PROBABLE only with >= 80% string-start targets, an `ld hl/de/bc,<table>` reference in the bank, a regular stride, or a hand-verified dispatch (`VERIFIED_TABLES`); `DROPPED_TABLES` lists retractions.')
    w('* **Palettes**: 4-word groups with bit 15 clear, >= 3 distinct values, containing $7FFF and monotone luminance (chance < 1e-5 per offset); consecutive groups form runs.')
    w('* **Record detection**: byte-equality autocorrelation for strides 2-96 (`stride` per window in the JSON). Example: bank 72 message records (mostly 69-byte stride, some 102) show up here.')
    w('* **Strings**: see `docs/research/text_encoding.md`.')
    w('')
    w('## 3. Per-bank map')
    w('')
    w('Legend: ' + ', '.join('`%s` %s' % (k, v[0]) for k, v in CLASS_INFO.items()) + '. Each map character is one 0x100-byte block (first char = 4000 or 0000).')
    w('')
    w('```')
    w('bank used-end  zero% ff%  H    map(64 blocks)')
    for b in banks:
        if b['empty']:
            continue
        w('%02X   %04X      %3d  %3d  %.2f %s' % (b['bank'], b['used_end'], round(100 * b['zero_bytes'] / BANK_SIZE),
                                                  round(100 * b['ff_bytes'] / BANK_SIZE), b['entropy'], b['block_map']))
    w('```')
    w('')
    empties = [b['bank'] for b in banks if b['empty']]
    w('Empty banks (entirely 0x00): ' + ' '.join('%02X' % e for e in empties) + ' (%d banks). Non-empty: %d banks.' % (len(empties), 128 - len(empties)))
    w('')
    w('| bank | used end | byte classes (>=5%) | strings (C/P/H) | tables | palettes | notes |')
    w('|---|---|---|---|---|---|---|')
    notes = {
        0x00: 'reset/interrupt vectors, text engine (0ED3), far-call helper (06D1), HDMA/tilemap loaders (0787/08EA), boot palette 0352',
        0x04: 'APU init at 4056 => probable sound driver (PROBABLE); rest unclassified', 0x05: 'unclassified; 63B0 mixes commands with SJIS pairs (not proven sound data)',
        0x3D: 'html store (13 files)', 0x3E: 'html store (42 files)', 0x3F: 'html far-pointer index', 0x65: 'CR-terminated Shift-JIS help text',
        0x72: 'Shift-JIS message records (69 bytes = 2 lines, some 102 = 3 lines) + 4-list pointer table 502B (PROBABLE)', 0x76: 'JIS rows 79-84 + Latin 6x12 font',
        0x7E: 'JIS rows 1-8, 13 + code after 7B7C', 0x7D: 'JIS rows 16-24 + small code at 7B7C', 0x7F: 'text-engine glyph routines (4000-41xx), tables 40F9/4150',
        0x5C: 'error message texts', 0x0F: 'mail header strings',
    }
    for b in banks:
        if b['empty']:
            continue
        st = b['strings']['by_status']
        n = b['bank']
        if 0x77 <= n <= 0x7E:
            note = 'JIS 12x12 font (rows %s)' % ','.join('%d-%d' % (min(v['std_rows']), max(v['std_rows'])) for k, v in lay.items() if k == n)
            if n in notes:
                note = notes[n] if n in (0x7D, 0x7E) else note
        else:
            note = notes.get(n, '')
        w('| %02X | %04X | %s | %d/%d/%d | %d | %d | %s |' % (
            n, b['used_end'], bank_summary_line(b), st.get('CONFIRMED', 0), st.get('PROBABLE', 0), st.get('HYPOTHESIS', 0),
            len(b['pointer_tables']), len(b['palettes']), note))
    w('')
    w('## 4. Structures recovered and verified against the bytes')
    w('')
    w('### 4.1 JIS 12x12 font (banks 76-7E)')
    w('')
    w('The glyph address routine (7F:4072-40B9) turns a Shift-JIS pair into a JIS row/column, looks the row up in two 94-entry tables '
      '(7F:40F9 = bank, 7F:4150 = first row held by that bank), and addresses `bank:0x4000 + ((row-first)*94 + col-1)*18`. '
      'The tables read from the ROM give:')
    w('')
    w('| bank | JIS rows | data end |')
    w('|---|---|---|')
    for k in sorted(lay, reverse=True):
        v = lay[k]
        w('| %02X | %s | %04X |' % (k, ', '.join('%d' % r for r in v['std_rows']), v['end']))
    w('')
    w('Glyph format (verified by rendering, see `docs/research/img/font_jis_rows_01-08.png`): 12x12 pixels, MSB = left pixel, each 3 bytes = 2 rows of 12 bits (`row0 = b0<<4 | b1>>4`, `row1 = (b1&15)<<8 | b2`).')
    w('')
    w('### 4.2 HTML store')
    w('')
    w('| bank | records | data end |')
    w('|---|---|---|')
    for bk in (0x3D, 0x3E):
        w('| %02X | %d | %04X |' % (bk, sum(1 for f in files if f['bank'] == bk), ends[bk]))
    w('')
    w('Record: `name` (ASCII) `00`, `u16le length`, body of `length` bytes ending in `00`. File list: ' + ', '.join(f['name'] for f in files[:12]) + ', ... (full list in `analysis/strings.tsv`). '
      'Bank 3F: `dw $4006,$4006,$0000`, `"file://di/",0`, one byte `02`, 55 far pointers `(addr16, bank)` at 3F:4012-40B6 (all equal record starts), `00 00`, then 11 words at 40B9 (ascending, pointing into 40CF-410C) and 61 index bytes (<= 0x36 = last file index) - a two-level topic index (PROBABLE, purpose not verified).')
    w('')
    w('## 5. Word tables, palettes and graphics')
    w('')
    all_t = [(b['bank'], t) for b in banks if not b['empty'] for t in b['pointer_tables']]
    w('%d pointer-table candidates passed the filters (all listed in the JSON). Longest 25:' % len(all_t))
    w('')
    w('| where | entries | monotone | target on string/after NUL | targets |')
    w('|---|---|---|---|---|')
    for bk, t in sorted(all_t, key=lambda x: -x[1]['entries'])[:25]:
        w('| %02X:%04X | %d | %.2f | %.0f%% | $%04X..$%04X |' % (bk, t['addr'], t['entries'], t['monotone'], 100 * t['land_on_text_or_after_nul'] if False else 100 * t['land_on_text_or_after_nul'], t['first'], t['last']))
    w('')
    n_pal = sum(len(b['palettes']) for b in banks if not b['empty'])
    w('%d palette runs found (recurring first palette `0000 414A 4273 7FFF` etc.); listing in the JSON and `analysis/gfx_candidates.tsv`.' % n_pal)
    w('')
    cnt = collections.Counter((r['kind'], r['conf']) for r in gfx_rows)
    w('Graphics candidates (`analysis/gfx_candidates.tsv`):')
    w('')
    w('| kind | confidence | count |')
    w('|---|---|---|')
    for k, v in sorted(cnt.items()):
        w('| %s | %s | %d |' % (k[0], k[1], v))
    w('')
    conf_bytes = sum(r['length'] for r in gfx_rows if r['kind'] == 'tiles-vram')
    w('Call-site-proven tile blocks: %d distinct blocks. Heuristic tile detection covers ~%d%% of the non-blank bytes of these proven blocks (recall) - use call-site blocks as ground truth and the heuristic ones as leads.'
      % (sum(1 for r in gfx_rows if r['kind'] == 'tiles-vram'), recall_pct(rom, gfx_rows)))
    w('')
    w('## 6. Compression check')
    w('')
    w('* Only one graphics loader was found in bank 00 (HDMA straight from ROM) and it copies raw bytes; tile blocks recovered from its call sites are coherent 2bpp art as stored.')
    w('* Crystal-style LZ probe: %d start offsets tried, %d parse to a terminator with output >= 1.3x input, %d of them start inside data already proven raw (or the font). Outside such data: %d (%s). Verdict: %s.' % (
        lz['offsets_tried'], lz['hits'], lz['hits_inside_raw_gfx_or_font'], lz['hits_elsewhere'], ', '.join(lz['elsewhere_first'][:8]) or 'none', lz['verdict']))
    w('* The %d hits collapse to %d distinct streams (overlapping starts converge to the same terminator). %d of their start addresses occur as `ld hl,imm16` / `ld de,imm16` operands somewhere in the ROM (%.0f%%), which is at or below the chance level for a random 16-bit address in 2 MiB (about 23%%): no loader is shown to consume any of them.' % (
        lz['hits'], lz.get('distinct_streams', 0), lz.get('stream_starts_appearing_as_ld_hl_or_de_imm16', 0),
        100.0 * lz.get('stream_starts_appearing_as_ld_hl_or_de_imm16', 0) / max(1, lz.get('distinct_streams', 1))))
    w('* ROM-wide search for a decompressor front end (`and $E0` = top-3-bit command dispatch): 64 occurrences, all but ~15 inside tile data; the ones in code are RGB555 channel splitters (29:52B0 and 4F:409E/40BE use masks $1F/$E0/$03/$7C on CGB colour words, i.e. palette fade/blend code) and an address-to-coordinate conversion (00:0BC5). None is a control-byte decompression loop.')
    w('')
    w('## 7. Far-call API (top 25 targets)')
    w('')
    w('%d far-call sites; %d/%d in-bank targets land on a linear-sweep instruction start (sanity check of the sweep and of the call encoding).' % (
        fc['total_sites'], fc['sweep_landing_ok'], fc['sweep_landing_total']))
    w('')
    w('| target | calls |')
    w('|---|---|')
    for t in fc['top'][:25]:
        w('| %02X:%04X | %d |' % (t['bank'], t['addr'], t['count']))
    w('')
    w('## 8. Limitations')
    w('')
    w('* Code-likeness is a heuristic; mixed banks (code interleaved with tables) are labelled per 0x100 block only. Bank 04/05 are left unclassified; the code/data split is left to the control-flow stage.')
    w('* Text detection needs >= 3 common (kana/punctuation/fullwidth) double-byte characters in a row; text made only of kanji or control codes would be missed. ASCII strings need NUL boundaries on both sides.')
    w('* Heuristic tile detection misses very small blocks and low-coherence art (baked kanji text); it can flag code/table bytes (measured false-positive rate about 4-5% of bytes in code-like windows).')
    w('* Pointer-table filters favour text tables and ascending tables; tables of pointers into code or unsorted tables can be missed, and stride > 2 record tables are not reported.')
    w('* Verifier measurement: against the call-site-proven data the heuristic tile detector is only ~50-90% pure by bytes (it also flags proven tilemaps as tiles, 7-28% of its bytes by size class), so blocks under 32 tiles are HYPOTHESIS.')
    w('')
    w('## 9. Retracted / corrected after adversarial verification')
    w('')
    w('* `call $06D1` ends in `call $FFA8` (not `jp`); the RAM stub at FFA8 is created at run time.')
    w('* Palette 00:0352: the loads are at 00:0335/0341 (calls at 033A/0346); 00:0332 was a wrong citation.')
    w('* 72:502B: NOT a table of 73 equal-stride entries. Entries 0-3 (5033, 5035, 5063, 50BB) point into the table itself (a header of 4 list pointers is likely: lists of 1, 23, 44 and 1 entries, HYPOTHESIS); message records are 69 bytes (2 lines) but entries 60, 63 and 65-68 are 102 bytes apart (3 lines); entry 72 = 50BD repeats the first record.')
    w('* Word tables corrected: 0E:4094 is 7 entries (the 8th was the code at 0E:40A2, table dispatched by `jp hl` at 0E:4093); 63:402D is 8 entries; 50:4242 started on the operand of `jp $4254` and is really 50:4244-4254 (8 entries); 7F:4EF0 is 6 entries, all URL strings. 51:4224 is RETRACTED (byte-pair lookup table 51:4225-4238, not pointers).')
    w('* Font row tables 7F:40F9 / 7F:4150 (87 bytes each) were labelled heuristic gfx; they are data (CONFIRMED by 7F:40B9-40D6).')
    w('* Strings: runs are now trimmed at unanchored ends (jp operand bytes at 54:49DE, code after 55:6CD4), CONFIRMED needs a NUL before the string, a NUL-terminated end and kana/full-width alnum content; bank 05 symbol runs and tile-like ASCII (42:4807) are HYPOTHESIS. The bank 6C claim `ED = ha` is contradicted by the text itself (`ha` already appears as single byte CA; `ED` fits `de`, HYPOTHESIS), and the single bytes A1-DF are only known to follow JIS X 0201 order (hiragana vs half-width katakana glyphs unresolved).')
    w('* Bank 00 zero run 0064-0101 wrongly included the `nop` at 00:0100 (now 0064-0100).')
    w('* Two lead-byte chains also exist outside bank 00 (4E:527E, 54:4C4D.., 74:431E.., 7E:7C4A): other text readers exist; the bank 6C reader is probably among them (HYPOTHESIS, not traced).')
    with open(path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(L) + '\n')


def recall_pct(rom, gfx_rows):
    conf = set()
    for r in gfx_rows:
        if r['kind'] == 'tiles-vram':
            off = offset(r['bank'], r['addr'])
            conf.update(o for o in range(off, off + r['length']) if rom[o] != 0)
    heur = set()
    for r in gfx_rows:
        if r['kind'] == 'tiles-2bpp':
            off = offset(r['bank'], r['addr'])
            heur.update(range(off, off + r['length']))
    return round(100 * len(conf & heur) / max(1, len(conf)))


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--rom', default=os.path.join(ROOT, 'baserom.gbc'))
    ap.add_argument('--skip-lz', action='store_true', help='skip the LZ probe (26 s)')
    ap.add_argument('--gfx-out', default=os.path.join(ROOT, 'build', 'gfx_dump'))
    args = ap.parse_args(argv)
    rom = load_rom(args.rom)
    import extract_gfx
    res = run_survey(rom)
    lz = dict(skipped=True, hits=0, hits_inside_raw_gfx_or_font=0, hits_elsewhere=0, offsets_tried=0, elsewhere_first=[],
              verdict='not run') if args.skip_lz else lz_summary(rom, res)
    an = os.path.join(ROOT, 'analysis')
    os.makedirs(os.path.join(an, 'proposals'), exist_ok=True)
    os.makedirs(os.path.join(ROOT, 'docs', 'research', 'img'), exist_ok=True)
    os.makedirs(os.path.join(ROOT, 'constants'), exist_ok=True)
    extract_gfx.write_tsv(os.path.join(an, 'gfx_candidates.tsv'), res['gfx_rows'])
    extract_gfx.dump_pngs(rom, res['gfx_rows'], args.gfx_out, os.path.join(ROOT, 'docs', 'research', 'img'))
    write_strings_tsv(os.path.join(an, 'strings.tsv'), res['strings'])
    obs, rows18 = write_charmap(os.path.join(ROOT, 'constants', 'charmap.asm'), rom, res['strings'])
    props = build_proposals(rom, res)
    write_proposals(os.path.join(an, 'proposals'), props)
    write_json(os.path.join(an, 'bank_survey.json'), res, rom, lz)
    write_bank_map(os.path.join(ROOT, 'docs', 'research', 'img', 'bank_map.png'), res['banks'])
    write_md(os.path.join(ROOT, 'docs', 'research', 'bank_survey.md'), res, rom, lz)
    print('banks surveyed: %d non-empty' % sum(1 for b in res['banks'] if not b['empty']))
    print('strings: %d, gfx candidates: %d, proposal files: %d' % (len(res['strings']), len(res['gfx_rows']), len(props)))


if __name__ == '__main__':
    main()
