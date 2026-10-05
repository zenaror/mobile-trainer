#!/usr/bin/env python3
"""Rewrite the sound data of the source tree (audio/music/*.asm, audio/sfx.asm, audio/music_pointers.asm) into macro form.

    python3 tools/audio_to_macros.py [options]

  --root DIR        tree to edit (default: the repository root; use it to work in a copy)
  --rom FILE        the original ROM (default: baserom.gbc, else "Mobile Trainer (Japan).gbc", in --root); it is only READ, and
                    must match roms.sha256
  --check           decode and verify only; write nothing; exit 1 when the files are not in the form this tool writes
  --dry-run         like the default run, but write nothing and build nothing (prints what would change)
  --no-build        write the files but skip the build / SHA-256 / sym_check verification (no rollback then!)
  --no-symcheck     run the build and the SHA-256 check but not tools/sym_check.py
  -v                list the labels that were created

What it does
  1. Decodes every sound stream of the ROM with the rules of the driver (docs/research/audio_format.md): the song table
     Table_SoundDrv_Songs (04:551D, 70 records), the stream headers, and each track by simulating the control flow of
     SoundDrv_ReadNextCommand (04:459B) - waits, notes with their optional bytes, running status, the one-byte commands,
     call / return / jump / end - starting at every track pointer of every header (and at the address behind each track's
     final jump, which is listed in the header but never reached).  It refuses to continue when a byte is unknown, when
     two decodings of the same address disagree, when streams overlap, or when a stream byte of banks 04/05 is left over.
  2. Re-encodes every decoded item from its fields and compares with the ROM (round trip).
  3. Rewrites the data blocks of the audio files: the bytes of each block are regenerated as macro lines
     (constants/audio_macros.inc) plus `dw Label` lines for the header pointer sets; block headers (`; ---- data ...`),
     labels and the pinning by layout.link are kept.  Jump/call/header targets are written as labels; a target that has no
     label gets `Data_BB_AAAA:: ; BB:AAAA` (only targets get one).  A construct that cannot be written as a macro (none at
     present) is left as `db` bytes.
  4. Builds (`make`), checks the SHA-256 against roms.sha256 and runs tools/sym_check.py; on any failure every file is restored.

The tool is deterministic and idempotent: the new text depends only on the ROM and on the labels that exist; a second run
changes nothing (`--check` verifies that).
"""
import argparse
import glob
import hashlib
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# --------------------------------------------------------------------------------------------------------------------
# ROM access
# --------------------------------------------------------------------------------------------------------------------

SONG_TABLE = 0x551D          # bank 04: Table_SoundDrv_Songs, record of id n at 0x5515 + 8*n (SoundDrv_LoadSongHeader)
SONG_COUNT = 0x46            # ids 1..0x46 (LoadSongHeader refuses others)
DUR_TABLE = 0x5044           # bank 04: Table_SoundDrv_Durations (49 bytes)
CMD_TABLE = 0x46E8           # bank 04: Table_SoundDrv_Commands (31 words, index = opcode - $B1)
STREAM_RANGES = {4: (0x574D, 0x7E8C), 5: (0x4000, 0x68C3)}    # sound streams of the two banks (file ranges of audio/music, sfx)

# handler entry points that the decoding rules rely on (04:46E8 table, index = opcode - $B1), checked against the ROM
EXPECT_HANDLER = {0xB1: 0x45DB, 0xB2: 0x479B, 0xB3: 0x4777, 0xB4: 0x47A3, 0xB5: 0x47C5, 0xBC: 0x47E3, 0xBE: 0x484E,
                  0xBF: 0x492A, 0xCD: 0x473E, 0xCE: 0x4A27, 0xCF: 0x4B66}
END_HANDLERS = (0x45DB, 0x4A24)          # SoundDrv_CmdEnd and the `jp SoundDrv_CmdEnd` stub: opcodes without a real handler
NO_HANDLER = (0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xC7, 0xC8, 0xCB, 0xCC)
ONE_BYTE = (0xBC, 0xBD, 0xBE, 0xBF, 0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC9, 0xCA)   # each handler does one `inc de`
# macro names of the one-byte commands; the ones with an opcode in the name are the commands whose effect is not demonstrated
# (docs/research/audio_format.md section 5)
CMD_NAME = {0xBC: 'sound_tempo', 0xBD: 'sound_pitch_add', 0xBE: 'sound_instrument', 0xBF: 'sound_volume',
            0xC0: 'sound_pan', 0xC1: 'sound_pitch_bend', 0xC2: 'sound_pitch_bend_scale', 0xC3: 'sound_vibrato_rate',
            0xC4: 'sound_vibrato_delay', 0xC5: 'sound_vibrato_depth', 0xC6: 'sound_vibrato_disable', 0xC9: 'sound_detune',
            0xCA: 'sound_cmd_CA'}
MAX_CALL_DEPTH = 5                        # SoundDrv_CmdCall: the depth counter goes up by 2 and must be < $0A

# the values written by `_sound_dur_def` in constants/audio_macros.inc (checked against the ROM table and the include)
DUR_VALUES = list(range(25)) + [28, 30, 32, 36, 40, 42, 44, 48, 52, 54, 56, 60, 64, 66, 68, 72, 76, 78, 80, 84, 88, 90, 92, 96]


class Rom:
    def __init__(self, path):
        self.data = open(path, 'rb').read()

    def b(self, bank, addr):
        if not 0x4000 <= addr < 0x8000:
            raise ValueError('address $%04X is not in ROMX' % addr)
        return self.data[bank * 0x4000 + addr - 0x4000]

    def w(self, bank, addr):
        return self.b(bank, addr) | self.b(bank, addr + 1) << 8


class DecodeError(Exception):
    pass


# --------------------------------------------------------------------------------------------------------------------
# decoder (the rules of SoundDrv_ReadNextCommand / SoundDrv_CmdNote / the command handlers, see docs/research/audio_format.md)
# --------------------------------------------------------------------------------------------------------------------

class Item:
    """One command of a stream: `size` bytes at `addr`, starting with the opcode byte unless `rs` (running status)."""
    __slots__ = ('bank', 'addr', 'size', 'kind', 'op', 'rs', 'dur', 'ext', 'sub', 'par', 'target', 'count')

    def __init__(self, bank, addr, op, rs):
        self.bank, self.addr, self.op, self.rs = bank, addr, op, rs
        self.size = 0
        self.kind = None
        self.dur = self.ext = self.sub = self.par = self.target = self.count = None

    def sig(self):                       # what two decodings of the same address must agree on (the opcode may differ only if unused)
        return (self.kind, self.size, self.rs, self.ext, self.sub, self.par, self.target, self.count, self.dur)


def read_durations(rom):
    return [rom.b(4, DUR_TABLE + i) for i in range(49)]


def decode_one(rom, bank, p, last, dur):
    """Decode the command at p with running status `last`.  Returns (item, new_last, terminates)."""
    c = rom.b(bank, p)
    if c & 0x80:
        op, pa, rs = c, p + 1, False
        if c >= 0xBE:
            last = c
    else:
        op, pa, rs = last, p, True            # a data byte: the driver re-uses the last opcode >= $BE
    it = Item(bank, p, op, rs)
    term = False
    if op >= 0xD0 or op == 0xCE:              # note: duration from the table (0 for $CE), then optional bytes, each class once
        it.dur = dur[op - 0xCF] if op >= 0xD0 else 0
        q, seen, ext = pa, set(), []
        while True:
            v = rom.b(bank, q)
            if v & 0x80:
                break
            cls = 'pitch' if v >= 0x24 else ('adj' if v >= 0x20 else 'mod')
            if cls in seen:
                break
            seen.add(cls)
            ext.append((cls, v))
            q += 1
        it.kind, it.ext, it.size = 'note', tuple(ext), q - p
    elif op == 0xCF:                          # $4B66: one optional pitch byte ($24-$7F)
        v = rom.b(bank, pa)
        ext = (('pitch', v),) if (not v & 0x80 and v >= 0x24) else ()
        it.kind, it.ext, it.size = 'cf', ext, pa + len(ext) - p
    elif op < 0xB1:
        if op < 0x80:
            raise DecodeError('$%04X: data byte with no opcode to repeat (running status $%02X)' % (p, op))
        it.kind, it.dur, it.size = 'wait', dur[op - 0x80] if op > 0x80 else 0, pa - p
    elif op in NO_HANDLER:
        raise DecodeError('$%04X: opcode $%02X has no handler (it would end the track)' % (p, op))
    elif op == 0xB1:
        it.kind, it.size, term = 'end', pa - p, True
    elif op in (0xB2, 0xB3):
        it.kind, it.target, it.size = ('jump' if op == 0xB2 else 'call'), rom.w(bank, pa), pa + 2 - p
    elif op == 0xB4:
        it.kind, it.size = 'ret', pa - p
    elif op == 0xB5:
        it.kind, it.count, it.target, it.size = 'loop', rom.b(bank, pa), rom.w(bank, pa + 1), pa + 3 - p
    elif op == 0xCD:
        sub = rom.b(bank, pa)
        if sub == 0 or sub >= 0x0C or sub in (8, 9):
            raise DecodeError('$%04X: extended command with sub-command $%02X ends the track' % (p, sub))
        it.kind, it.sub, it.par, it.size = 'ext', sub, rom.b(bank, pa + 1), pa + 2 - p
    elif op in ONE_BYTE:
        it.kind, it.par, it.size = 'cmd', rom.b(bank, pa), pa + 1 - p
    else:
        raise DecodeError('$%04X: unhandled opcode $%02X' % (p, op))
    if it.size == 0:
        raise DecodeError('$%04X: command of size 0 (the driver would loop on it forever)' % p)
    return it, last, term


def decode_stream(rom, bank, start, items, dur, tag):
    """Follow every path of the stream starting at `start` (state: address, running status, call stack)."""
    seen = set()
    work = [(start, 0, ())]
    while work:
        p, last, stack = work.pop()
        while True:
            key = (p, last, stack)
            if key in seen:
                break
            seen.add(key)
            try:
                it, last, term = decode_one(rom, bank, p, last, dur)
            except DecodeError as e:
                raise DecodeError('%s: %s' % (tag, e))
            old = items.get(p)
            if old is None:
                items[p] = it
            elif old.sig() != it.sig():
                raise DecodeError('%s: $%04X decodes differently in two states: %s vs %s' % (tag, p, old.sig(), it.sig()))
            elif old.op != it.op:
                raise DecodeError('%s: $%04X is decoded with two different opcodes ($%02X, $%02X)' % (tag, p, old.op, it.op))
            nxt = p + it.size
            if term:
                break
            if it.kind == 'jump':
                p = it.target
            elif it.kind == 'call':
                if len(stack) >= MAX_CALL_DEPTH:
                    raise DecodeError('%s: $%04X call nesting deeper than the driver allows' % (tag, p))
                stack = stack + (nxt,)
                p = it.target
            elif it.kind == 'ret':
                if stack:
                    p, stack = stack[-1], stack[:-1]
                else:
                    p = nxt                   # return with an empty stack is a no-op
            elif it.kind == 'loop':
                work.append((nxt, last, stack))       # counter reached: fall through
                p = it.target                         # otherwise jump
            else:
                p = nxt


def encode_item(it, dur):
    """Bytes of an item from its fields (independent of the ROM)."""
    out = []
    if not it.rs:
        out.append(it.op)
    if it.kind == 'note':
        for _cls, v in it.ext:
            out.append(v)
    elif it.kind == 'cf':
        for _cls, v in it.ext:
            out.append(v)
    elif it.kind in ('jump', 'call'):
        out += [it.target & 0xFF, it.target >> 8]
    elif it.kind == 'loop':
        out += [it.count, it.target & 0xFF, it.target >> 8]
    elif it.kind == 'ext':
        out += [it.sub, it.par]
    elif it.kind == 'cmd':
        out.append(it.par)
    return out


class Song:
    def __init__(self, sid, rec):
        self.sid = sid
        self.ptr = rec[0] | rec[1] << 8
        self.bank = rec[2] | rec[3] << 8
        self.prio, self.flags, self.count, self.spare = rec[4:8]


class Header:
    """Stream header at (bank, addr): db tracks, db extra; then (extra+1) sets of `tracks` words."""
    def __init__(self, rom, bank, addr):
        self.bank, self.addr = bank, addr
        self.tracks = rom.b(bank, addr)
        self.extra = rom.b(bank, addr + 1)
        self.sets = [[rom.w(bank, addr + 2 + 2 * (s * self.tracks + i)) for i in range(self.tracks)] for s in range(self.extra + 1)]
        self.size = 2 + 2 * self.tracks * (self.extra + 1)


def decode_all(rom, log):
    dur = read_durations(rom)
    if dur != DUR_VALUES:
        raise DecodeError('Table_SoundDrv_Durations differs from the values of constants/audio_macros.inc')
    for k in range(31):
        w = rom.w(4, CMD_TABLE + 2 * k)
        op = 0xB1 + k
        if op in EXPECT_HANDLER and w != EXPECT_HANDLER[op]:
            raise DecodeError('command table: opcode $%02X goes to $%04X, expected $%04X' % (op, w, EXPECT_HANDLER[op]))
        if op in NO_HANDLER and w not in END_HANDLERS:
            raise DecodeError('command table: opcode $%02X goes to $%04X, expected an end handler' % (op, w))
    songs = {}
    for sid in range(1, SONG_COUNT + 1):
        a = 0x5515 + 8 * sid
        songs[sid] = Song(sid, [rom.b(4, a + i) for i in range(8)])
    headers = {}
    for s in songs.values():
        if s.bank not in STREAM_RANGES:
            raise DecodeError('song %02X: bank %d is not a sound bank' % (s.sid, s.bank))
        key = (s.bank, s.ptr)
        if key not in headers:
            headers[key] = Header(rom, *key)
        h = headers[key]
        if h.tracks != s.count:
            raise DecodeError('song %02X: header says %d tracks, record says %d' % (s.sid, h.tracks, s.count))
        if s.spare != 0:
            raise DecodeError('song %02X: spare byte is not 0' % s.sid)
    items = {4: {}, 5: {}}
    for (bank, addr), h in sorted(headers.items()):
        if h.extra not in (0, 2):
            raise DecodeError('header %02X:%04X: extra sets = %d' % (bank, addr, h.extra))
        for i, t in enumerate(h.sets[0]):
            decode_stream(rom, bank, t, items[bank], dur, 'header %02X:%04X track %d' % (bank, addr, i))
    # the third set: address after each track's final jump (never reached by the driver): decode those tails as well
    for (bank, addr), h in sorted(headers.items()):
        if h.extra == 2:
            for i in range(h.tracks):
                st, lp, en = h.sets[0][i], h.sets[1][i], h.sets[2][i]
                before = [it for it in items[bank].values() if it.addr + it.size == en]
                if not any(it.kind == 'jump' and it.target == lp for it in before):
                    raise DecodeError('header %02X:%04X track %d: set 1/2 words %04X/%04X are not (target, address after) of a jump' % (bank, addr, i, lp, en))
                if lp not in items[bank]:
                    raise DecodeError('header %02X:%04X track %d: loop word %04X is not the start of a command' % (bank, addr, i, lp))
                decode_stream(rom, bank, en, items[bank], dur, 'header %02X:%04X track %d tail' % (bank, addr, i))
    # every byte of the stream ranges is now an item, a header byte, or an error
    cover = {4: {}, 5: {}}
    for bank in (4, 5):
        for it in items[bank].values():
            for k in range(it.size):
                if it.addr + k in cover[bank]:
                    raise DecodeError('%02X:%04X: overlapping items' % (bank, it.addr + k))
                cover[bank][it.addr + k] = it
    for (bank, addr), h in headers.items():
        for k in range(h.size):
            if addr + k in cover[bank]:
                raise DecodeError('%02X:%04X: header overlaps a stream' % (bank, addr + k))
            cover[bank][addr + k] = h
    for bank, (lo, hi) in STREAM_RANGES.items():
        left = [a for a in range(lo, hi) if a not in cover[bank]]
        if left:
            raise DecodeError('%02X: %d stream bytes are not decoded, first at $%04X' % (bank, len(left), left[0]))
        outside = [a for a in cover[bank] if not lo <= a < hi]
        if outside:
            raise DecodeError('%02X: decoded bytes outside the stream range, first at $%04X' % (bank, min(outside)))
    # round trip: decode -> encode -> identical bytes
    n = 0
    for bank in (4, 5):
        for it in items[bank].values():
            enc = encode_item(it, dur)
            rom_bytes = [rom.b(bank, it.addr + k) for k in range(it.size)]
            if enc != rom_bytes:
                raise DecodeError('%02X:%04X: re-encoded item differs from the ROM: %s vs %s' % (bank, it.addr, enc, rom_bytes))
            n += it.size
    log('decoded %d songs (%d distinct headers), %d items (%d stream bytes) in banks 04/05, round trip identical'
        % (len(songs), len(headers), sum(len(v) for v in items.values()), n))
    return songs, headers, items, dur


# --------------------------------------------------------------------------------------------------------------------
# text of the macro form
# --------------------------------------------------------------------------------------------------------------------

def hx(v):
    return '$%02X' % v


def item_text(it, name):
    """Macro line for an item, or None when it cannot be written as a macro."""
    k = it.kind
    if k == 'wait':
        t = 'sound_wait %d' % it.dur
    elif k == 'note':
        cls = tuple(c for c, _ in it.ext)
        vals = [v for _, v in it.ext]
        if cls == ():
            t = 'sound_note %d' % it.dur
        elif cls == ('pitch',):
            t = 'sound_note %d, %s' % (it.dur, hx(vals[0]))
        elif cls == ('pitch', 'mod'):
            t = 'sound_note %d, %s, %s' % (it.dur, hx(vals[0]), hx(vals[1]))
        elif cls == ('mod',):
            t = 'sound_note_vol %d, %s' % (it.dur, hx(vals[0]))
        else:
            return None
    elif k == 'cf':
        t = 'sound_note_off' + (' ' + hx(it.ext[0][1]) if it.ext else '')
    elif k == 'end':
        t = 'sound_end'
    elif k == 'ret':
        t = 'sound_ret'
    elif k == 'jump':
        t = 'sound_jump ' + name(it.bank, it.target)
    elif k == 'call':
        t = 'sound_call ' + name(it.bank, it.target)
    elif k == 'loop':
        t = 'sound_loop %d, %s' % (it.count, name(it.bank, it.target))
    elif k == 'ext':
        t = 'sound_cmd_CD %s, %s' % (hx(it.sub), hx(it.par))
    elif k == 'cmd':
        arg = hx(it.par)
        if it.op == 0xBE and it.par == 0x64:
            arg = 'SOUND_INSTRUMENT_PER_NOTE'
        t = '%s %s' % (CMD_NAME[it.op], arg)
    else:
        return None
    if it.rs:
        t = 'sound_rs ' + t
    return t


# --------------------------------------------------------------------------------------------------------------------
# source files
# --------------------------------------------------------------------------------------------------------------------

REGION = re.compile(r'^; ---- (\w+) \$([0-9A-Fa-f]{4})-\$([0-9A-Fa-f]{4}) \((\d+) bytes\)')
LABEL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)::(?P<rest>.*)$')
LABEL_ADDR = re.compile(r';\s*([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\b')
BANKLINE = re.compile(r'^; bank ([0-9A-Fa-f]{2}), \$([0-9A-Fa-f]{4})-\$([0-9A-Fa-f]{4})')
NEUTRAL = re.compile(r'^Data_[0-9A-F]{2}_[0-9A-F]{4}$')


class Block:
    def __init__(self):
        self.header = None          # the `; ---- kind $a-$b (n bytes) ...` line
        self.kind = None
        self.start = self.end = 0
        self.start_labels = []      # raw label lines right after the header (first one carries the address comment)
        self.mid_labels = {}        # addr -> [label lines] found inside the content
        self.content = []
        self.new_content = None


class SrcFile:
    def __init__(self, root, rel):
        self.rel = rel
        self.path = os.path.join(root, rel)
        self.text = open(self.path, encoding='utf-8').read()
        self.lines = self.text.split('\n')
        if self.lines and self.lines[-1] == '':
            self.lines.pop()
        m = BANKLINE.match(self.lines[1])
        if not m:
            raise DecodeError('%s: line 2 is not `; bank BB, $start-$end`' % rel)
        self.bank = int(m.group(1), 16)
        self.lo, self.hi = int(m.group(2), 16), int(m.group(3), 16)
        sec = [i for i, l in enumerate(self.lines) if l.startswith('SECTION ')]
        if len(sec) != 1:
            raise DecodeError('%s: expected exactly one SECTION' % rel)
        self.prefix = self.lines[:sec[0] + 1]
        self.blocks = []
        self._parse(self.lines[sec[0] + 1:])

    def _parse(self, body):
        cur = None
        last_mid = None
        for line in body:
            m = REGION.match(line)
            if m:
                cur = Block()
                cur.header, cur.kind = line, m.group(1)
                cur.start, cur.end = int(m.group(2), 16), int(m.group(3), 16)
                if cur.end - cur.start != int(m.group(4)):
                    raise DecodeError('%s: %s: size in the header disagrees with the range' % (self.rel, line[:40]))
                self.blocks.append(cur)
                continue
            if cur is None:
                if line.strip():
                    raise DecodeError('%s: text before the first region header: %r' % (self.rel, line))
                continue
            lm = LABEL.match(line)
            if not cur.content and lm:
                cur.start_labels.append(line)
            elif lm:
                am = LABEL_ADDR.search(lm.group('rest'))
                if am:
                    last_mid = int(am.group(2), 16)
                elif not (cur.content and LABEL.match(cur.content[-1]) and last_mid is not None):
                    raise DecodeError('%s: label %s inside a block has no address comment' % (self.rel, lm.group(1)))
                # a label without address comment right below another label is an alias of it (apply_renames.py writes them)
                cur.mid_labels.setdefault(last_mid, []).append(line)
                cur.content.append(line)
            elif line.strip() == '':
                continue
            elif line.startswith('\t') or line.startswith(';'):
                cur.content.append(line)
            else:
                raise DecodeError('%s: unexpected line %r' % (self.rel, line))
        for b in self.blocks:
            if b.start_labels and not LABEL_ADDR.search(LABEL.match(b.start_labels[0]).group('rest')):
                raise DecodeError('%s: the first label of block $%04X has no address comment' % (self.rel, b.start))

    def render(self):
        out = list(self.prefix)
        for b in self.blocks:
            out.append('')
            out.append(b.header)
            out.append('')
            out += b.start_labels
            out += b.new_content if b.new_content is not None else b.content
        return '\n'.join(out) + '\n'


def label_names(line):
    return LABEL.match(line).group(1)


# --------------------------------------------------------------------------------------------------------------------
# main rewrite
# --------------------------------------------------------------------------------------------------------------------

def audio_files(root):
    rels = sorted(os.path.relpath(p, root) for p in glob.glob(os.path.join(root, 'audio', 'music', 'music_*.asm')))
    return rels + ['audio/sfx.asm'], 'audio/music_pointers.asm'


STATUS = re.compile(r'\[(CONFIRMED|PROBABLE|HYPOTHESIS)\]')
HEADER_SIZE = re.compile(r'^(; ---- \w+ \$[0-9A-Fa-f]{4}-\$)([0-9A-Fa-f]{4}) \((\d+) bytes\)(.*)$')


def cut_points(bank, headers, items):
    """Addresses that lie strictly inside a command (or inside a word of a header pointer set) of the decoded streams."""
    cuts = set()
    for it in items[bank].values():
        cuts.update(range(it.addr + 1, it.addr + it.size))
    for (b, addr), h in headers.items():
        if b != bank:
            continue
        cuts.add(addr + 1)
        for si in range(len(h.sets)):
            base = addr + 2 + 2 * si * h.tracks
            cuts.update(base + 2 * k + 1 for k in range(h.tracks))
    return cuts


def mentions(root, name):
    """Number of source lines (.asm/.inc under root, not the build directory) that mention `name` other than as its own label line."""
    pat = re.compile(r'\b%s\b' % re.escape(name))
    own = re.compile(r'^%s::' % re.escape(name))
    n = 0
    for dp, dn, fn in os.walk(root):
        dn[:] = [d for d in dn if d not in ('build', '.git', 'traces', 'scratch')]
        for f in fn:
            if f.endswith(('.asm', '.inc')):
                with open(os.path.join(dp, f), encoding='utf-8', errors='replace') as fh:
                    for line in fh:
                        if pat.search(line) and not own.match(line):
                            n += 1
    return n


def merge_cut_blocks(root, files, headers, items, targets, log):
    """Join a block to its predecessor when the boundary between them cuts a command in two and the label that starts the block
    is not used anywhere (not by a stream pointer, a jump/call, or any source line): such a label is an artifact of the coverage
    pieces of the earlier analysis, and a command cut in two by it cannot be written as a macro.  The header of the second block is
    kept as text inside the header of the first (nothing of the earlier analysis is dropped).  A boundary whose label IS used stays
    (the command split is then real) and its bytes stay `db`.  Returns the number of merges."""
    cuts = {b: cut_points(b, headers, items) for b in (4, 5)}
    merged = 0
    for f in files:
        out = []
        for b in f.blocks:
            if out and b.start in cuts[f.bank] and b.kind == out[-1].kind and b.start == out[-1].end:
                names = [label_names(l) for l in b.start_labels]
                keep = (f.bank, b.start) in targets or any(mentions(root, n) for n in names)
                if names and not keep:
                    prev = out[-1]
                    mp, mb = HEADER_SIZE.match(prev.header), HEADER_SIZE.match(b.header)
                    if not (mp and mb):
                        raise DecodeError('%s: cannot merge the block at $%04X (header format)' % (f.rel, b.start))
                    old_second = b.header[len('; ---- '):]
                    note = ' | block boundary $%04X removed (it cut a command in two; its label %s was not referenced); the second part was: %s' % (
                        b.start, ', '.join(names), old_second)
                    order = ('CONFIRMED', 'PROBABLE', 'HYPOTHESIS')
                    sp, sb = STATUS.search(prev.header), STATUS.search(b.header)
                    tail = mp.group(4)
                    if sp and sb and order.index(sb.group(1)) > order.index(sp.group(1)):
                        tail = tail.replace('[%s]' % sp.group(1), '[%s]' % sb.group(1), 1)
                        note += ' (status of the merged block lowered to the weaker of the two parts)'
                    prev.header = '%s%04X (%d bytes)%s%s' % (mp.group(1), b.end, b.end - prev.start, tail, note)
                    prev.end = b.end
                    for a, lines in b.mid_labels.items():
                        prev.mid_labels.setdefault(a, []).extend(lines)
                    prev.content += b.content
                    merged += 1
                    log('  merged block $%04X-$%04X into $%04X (label %s unreferenced)' % (b.start, b.end, prev.start, ', '.join(names)))
                    continue
            out.append(b)
        f.blocks = out
    return merged


def rewrite(root, rom, songs, headers, items, dur, verbose):
    stream_rels, ptr_rel = audio_files(root)
    files = [SrcFile(root, r) for r in stream_rels]
    ptrfile = SrcFile(root, ptr_rel)

    # targets that need a name: header pointers, stream pointers, jump/call/loop targets
    targets = set()
    for (bank, addr), h in headers.items():
        targets.add((bank, addr))
        for st in h.sets:
            for w in st:
                targets.add((bank, w))
    for bank in (4, 5):
        for it in items[bank].values():
            if it.target is not None:
                targets.add((bank, it.target))
    merged = merge_cut_blocks(root, files, headers, items, targets, print if verbose else (lambda *_: None))

    # labels that exist: (bank, addr) -> names (block starts and labels inside blocks)
    labels = {}
    block_at = {}                                     # (bank, addr) -> (file, block) for every byte address
    for f in files:
        for b in f.blocks:
            names = [label_names(l) for l in b.start_labels]
            if names:
                labels.setdefault((f.bank, b.start), []).extend(names)
            for a, lines in b.mid_labels.items():
                labels.setdefault((f.bank, a), []).extend(label_names(l) for l in lines)
            for a in range(b.start, b.end):
                block_at[(f.bank, a)] = (f, b)

    created = {}                                      # (bank, addr) -> name, labels this run adds
    for key in sorted(targets):
        if key in labels:
            continue
        if key not in block_at:
            raise DecodeError('target %02X:%04X is not inside a data block of an audio file' % key)
        name = 'Data_%02X_%04X' % key
        for names in labels.values():
            if name in names:
                raise DecodeError('label %s exists at another address' % name)
        created[key] = name
        labels[key] = [name]

    def name(bank, addr):
        names = labels.get((bank, addr))
        if not names:
            raise DecodeError('no label for %02X:%04X' % (bank, addr))
        for n in names:                               # a song/track name given by tools/apply_renames.py (analysis/naming2/audio2_renames.tsv) ...
            if n.startswith(('SoundSong', 'SoundSfx')):
                return n
        for n in names:                               # ... else the neutral name (a semantic label such as Data_SoundDrv_Streams is not used)
            if NEUTRAL.match(n):
                return n
        return names[0]

    # segments: what starts at each address
    segs = {4: {}, 5: {}}
    for bank in (4, 5):
        for it in items[bank].values():
            segs[bank][it.addr] = ('item', it, it.size)
    for (bank, addr), h in headers.items():
        segs[bank][addr] = ('hinfo', h, 2)
        for si, s in enumerate(h.sets):
            segs[bank][addr + 2 + 2 * si * h.tracks] = ('hset', (h, si), 2 * h.tracks)

    def seg_desc(bank, seg):
        kind, obj, size = seg
        if kind == 'item':
            return item_text(obj, name)
        if kind == 'hinfo':
            return 'sound_stream_header %d, %d' % (obj.tracks, obj.extra)
        h, si = obj
        return 'dw ' + ', '.join(name(bank, w) for w in h.sets[si])

    cover_seg = {}
    for bank in (4, 5):
        for a0, sg in segs[bank].items():
            for k in range(sg[2]):
                cover_seg[(bank, a0 + k)] = (a0, sg)

    raw_bytes = 0
    SET_COMMENT = ['track stream pointers (read by the driver)',
                   'not read by the driver: target of each track\'s final sound_jump',
                   'not read by the driver: address after each track\'s final sound_jump']

    for f in files:
        for b in f.blocks:
            bank = f.bank
            out = []
            # addresses at which a label line must appear inside this block
            inner = {}
            if (bank, b.start) in created:
                b.start_labels = ['%s:: ; %02X:%04X' % (created[(bank, b.start)], bank, b.start)] + b.start_labels
            for a, lines in b.mid_labels.items():
                inner[a] = list(lines)
            for key, nm in created.items():
                if key[0] == bank and b.start < key[1] < b.end and key[1] not in inner:
                    inner[key[1]] = ['%s:: ; %02X:%04X' % (nm, bank, key[1])]
            pos = b.start
            while pos < b.end:
                if pos != b.start and pos in inner:
                    out += inner[pos]
                seg = segs[bank].get(pos)
                if seg is not None:
                    kind, obj, size = seg
                    text = seg_desc(bank, seg)
                    if text is not None and pos + size <= b.end and not any(pos < a < pos + size for a in inner):
                        out.append('\t' + text + (' ; ' + SET_COMMENT[obj[1]] if kind == 'hset' else ''))
                        pos += size
                        continue
                # cannot be written as a macro (a label or the end of the block lies inside the command): the bytes stay db
                cs = cover_seg.get((bank, pos))
                if cs is not None:
                    cstart, cseg = cs
                    desc = seg_desc(bank, cseg)
                    limit = cstart + cseg[2]
                    note = '%s `%s`' % ('start of' if pos == cstart else 'rest of', desc)
                    if pos == cstart:
                        note += '; a label lies inside this command'
                else:
                    limit = min([b.end] + [a for a in segs[bank] if pos < a < b.end])
                    note = 'not decoded'
                stop = min([b.end, limit] + [a for a in inner if a > pos])
                chunk = [rom.b(bank, a) for a in range(pos, stop)]
                for i in range(0, len(chunk), 16):
                    out.append('\tdb ' + ', '.join(hx(v) for v in chunk[i:i + 16]) + ' ; ' + note)
                raw_bytes += len(chunk)
                pos = stop
            b.new_content = out

    # the song table
    if len(ptrfile.blocks) != 1 or (ptrfile.bank, ptrfile.blocks[0].start) != (4, SONG_TABLE):
        raise DecodeError('audio/music_pointers.asm: unexpected block structure')
    pb = ptrfile.blocks[0]
    if pb.end - pb.start != 8 * SONG_COUNT or pb.mid_labels:
        raise DecodeError('audio/music_pointers.asm: unexpected block size')
    out = []
    for sid in range(1, SONG_COUNT + 1):
        s = songs[sid]
        out.append('\tsound_song %s, %s, %s, %d ; id $%02X' % (name(s.bank, s.ptr), hx(s.prio), hx(s.flags), s.count, sid))
    pb.new_content = out

    if verbose:
        for key, nm in sorted(created.items()):
            print('  new label %s' % nm)
    return files + [ptrfile], created, raw_bytes, merged, labels


# --------------------------------------------------------------------------------------------------------------------
# the tables of the driver (audio/notes.asm, audio/instruments.asm, audio/wave_samples.asm)
# --------------------------------------------------------------------------------------------------------------------

NOTE_TABLE = 0x5075          # 120 records of 3 bytes: dw period, db step (SoundDrv_LookupFrequency 04:4FF5)
NOTE_COUNT = 120
INSTR_TABLE = 0x51DD         # 112 records of 6 bytes (SoundDrv_GetInstrumentPtr 04:4889)
INSTR_COUNT = 112
WAVE_TABLE = 0x547D          # 10 patterns of 16 bytes (SoundDrv_WriteChannelParams 04:4EB3-4EC8)
WAVE_COUNT = 10
PITCH_BASE = 0x24            # SoundDrv_NoteToIndex: pitch byte - $24 = index into the note table
PER_NOTE_FIRST = 0x64        # per-note instrument mode reads record (pitch + $40); the data uses pitches $24-$2F
NOTE_NAMES = ('C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B')

TABLE_NOTE = {
    'notes.asm#0': ('[CONFIRMED] Table_SoundDrv_Durations: 49 bytes, the ticks of a wait (index = opcode - $80) or the gate time of a note (index = opcode - $CF); '
                    'read by the wait handler 04:4756 and by SoundDrv_CmdNote 04:4A2B; 00..18 step 1, then 1C 1E 20 24 28 2A 2C 30 34 36 38 3C 40 42 44 48 4C 4E 50 54 58 5A 5C 60'),
    'notes.asm#1': ('[CONFIRMED] Table_SoundDrv_NoteFreq: 120 records of 3 bytes (dw 11-bit period, db step), index = pitch byte - $24 (SoundDrv_NoteToIndex 04:4FEA), '
                    'one semitone per record; SoundDrv_WriteChannelPitch 04:4ECA adds step * (fraction of the pitch offset) / 256 to the period; every period is within 1 of the '
                    'equal-tempered value of MIDI note 36 + index (A4 = 440 Hz; $002C = 65.4 Hz = C2) and step is the next period minus this one, within 1'),
    'instruments.asm': ('[CONFIRMED] Table_SoundDrv_Instruments: 112 records of 6 bytes (layout and field evidence: docs/research/audio_format.md section 6); records $00-$63 are '
                        'selected by sound_instrument, $64-$6F by the per-note mode (record = pitch + $40; the data plays pitches $24-$2F there)'),
    'wave_samples.asm': ('[CONFIRMED] Table_SoundDrv_WavePatterns: 10 patterns of 16 bytes = 32 4-bit samples (high nibble first in wave RAM), copied unchanged to $FF30-$FF3F by '
                         'SoundDrv_WriteChannelParams 04:4EB3-4EC8 for a wave-channel instrument (byte 0 - $10 = pattern)'),
}


def dec_env(b3, b4):
    """Envelope fields of instrument bytes 3 and 4 as SoundDrv_UpdateChannel reads them (docs/research/audio_format.md section 7)."""
    att, dec, rel = (~b3 >> 5) & 7, (~b3 >> 1) & 7, (~b4 >> 1) & 7
    f = lambda v: '-' if v == 0 else str(v)
    return 'attack %s, decay %s, sustain %X, release %s' % (f(att), f(dec), b4 >> 4, f(rel))


def instr_text(rec):
    """Macro for a 6-byte instrument record: the form of its channel class (byte 0), or sound_instr_raw when no form fits exactly."""
    b0, b1, b2, b3, b4, b5 = rec
    if b0 < 4:
        return 'sound_instr_pulse1 %d, %d, %s, %s, %s, %s' % (b0, b1, hx(b2), hx(b3), hx(b4), hx(b5))
    if b2 == 0 and 0x08 <= b0 <= 0x0B:
        return 'sound_instr_pulse2 %d, %d, %s, %s, %s' % (b0 & 3, b1, hx(b3), hx(b4), hx(b5))
    if b2 == 0 and 0x10 <= b0 <= 0x19:
        return 'sound_instr_wave %d, %d, %s, %s, %s' % (b0 - 0x10, b1, hx(b3), hx(b4), hx(b5))
    if b2 == 0 and b0 in (0x40, 0x41):
        return 'sound_instr_noise %d, %d, %s, %s, %s' % (b0 & 1, b1, hx(b3), hx(b4), hx(b5))
    return 'sound_instr_raw ' + ', '.join(hx(v) for v in rec)


def table_files(root, rom, dur):
    """The three table files in macro form.  Returns (files, stats)."""
    stats = {}
    # --- notes.asm: durations + note frequencies
    f = SrcFile(root, 'audio/notes.asm')
    if [(b.start, b.end) for b in f.blocks] != [(0x5044, 0x5075), (0x5075, 0x51DD)]:
        raise DecodeError('audio/notes.asm: unexpected block structure')
    rows = []
    for i in range(0, 49, 16):
        chunk = dur[i:i + 16]
        rows.append('\tsound_durations %s ; index $%02X-$%02X' % (', '.join(str(v) for v in chunk), i, i + len(chunk) - 1))
    f.blocks[0].new_content = rows
    freq = [(rom.w(4, NOTE_TABLE + 3 * i), rom.b(4, NOTE_TABLE + 3 * i + 2)) for i in range(NOTE_COUNT)]
    # invariants the comments rely on (the claims of TABLE_NOTE['notes.asm#1'])
    for i, (per, step) in enumerate(freq):
        eq = 2048 - 131072 / (440.0 * 2 ** ((36 + i - 69) / 12.0))
        if abs(min(eq, 2047) - per) > 1.0:
            raise DecodeError('note table: record %d period $%03X is not within 1 of the equal-tempered value %.2f' % (i, per, eq))
        if i + 1 < NOTE_COUNT and abs(freq[i + 1][0] - per - step) > 1:
            raise DecodeError('note table: record %d step %d is not the difference to the next period' % (i, step))
    rows = []
    for i, (per, step) in enumerate(freq):
        midi = 36 + i
        rows.append('\tsound_note_freq $%04X, %s ; pitch %s %s%d' % (per, hx(step), hx(PITCH_BASE + i), NOTE_NAMES[midi % 12], midi // 12 - 1))
    f.blocks[1].new_content = rows
    out = [f]
    # --- instruments.asm
    g = SrcFile(root, 'audio/instruments.asm')
    if [(b.start, b.end) for b in g.blocks] != [(INSTR_TABLE, INSTR_TABLE + 6 * INSTR_COUNT)]:
        raise DecodeError('audio/instruments.asm: unexpected block structure')
    rows, raw = [], 0
    for i in range(INSTR_COUNT):
        rec = [rom.b(4, INSTR_TABLE + 6 * i + k) for k in range(6)]
        t = instr_text(rec)
        raw += t.startswith('sound_instr_raw')
        note = 'id %s: %s' % (hx(i), dec_env(rec[3], rec[4]))
        if i >= PER_NOTE_FIRST:
            note = 'id %s = per-note record of pitch %s: %s' % (hx(i), hx(i - 0x40), dec_env(rec[3], rec[4]))
        rows.append('\t' + t + ' ; ' + note)
    g.blocks[0].new_content = rows
    out.append(g)
    stats['instruments raw'] = raw
    # --- wave_samples.asm
    w = SrcFile(root, 'audio/wave_samples.asm')
    if [(b.start, b.end) for b in w.blocks] != [(WAVE_TABLE, WAVE_TABLE + 16 * WAVE_COUNT)]:
        raise DecodeError('audio/wave_samples.asm: unexpected block structure')
    rows = []
    for n in range(WAVE_COUNT):
        bs = [rom.b(4, WAVE_TABLE + 16 * n + k) for k in range(16)]
        smp = [v for by in bs for v in (by >> 4, by & 15)]
        rows.append('\tsound_wave_pattern \\')
        rows.append('\t\t' + ', '.join('$%X' % v for v in smp[:16]) + ', \\')
        rows.append('\t\t' + ', '.join('$%X' % v for v in smp[16:]) + ' ; wave %d (instrument byte 0 = %s)' % (n, hx(0x10 + n)))
    w.blocks[0].new_content = rows
    out.append(w)
    # headers: the new note first, the earlier one kept as text
    for fl, key_of in ((f, ('notes.asm#0', 'notes.asm#1')), (g, ('instruments.asm',)), (w, ('wave_samples.asm',))):
        for b, key in zip(fl.blocks, key_of):
            b.header = table_header(b.header, TABLE_NOTE[key])
    return out, stats


OLD_MARK = ' | superseded note: '


def table_header(header, note):
    m = HEADER_SIZE.match(header)
    if not m:
        raise DecodeError('table header format: ' + header[:60])
    rest = m.group(4).strip()
    if OLD_MARK in rest:
        old = rest.split(OLD_MARK, 1)[1]
    else:
        old = rest
    return '%s%s (%s bytes) %s%s%s' % (m.group(1), m.group(2), m.group(3), note, OLD_MARK, old)


# --------------------------------------------------------------------------------------------------------------------
# verification
# --------------------------------------------------------------------------------------------------------------------

def song_name_rows(songs, headers, labels):
    """Manifest rows (tools/apply_renames.py) that name the stream headers and track starts after the id of the first song record
    that uses them: SoundSongNN_Header, SoundSongNN_TrackK.  The song table (Table_SoundDrv_Songs) and the stream headers are the
    evidence (CONFIRMED: the driver reads both, decoder run on all of them)."""
    rows, first = [], {}
    for sid in sorted(songs):
        s = songs[sid]
        first.setdefault((s.bank, s.ptr), []).append(sid)

    def neutral(bank, addr):                      # the neutral name of the address, when it is the primary label (apply_renames.py renames
        names = labels.get((bank, addr), [])      # primary labels only; an alias cannot be the old name of a row)
        return names[0] if names and NEUTRAL.match(names[0]) else None
    used = set()
    for (bank, ptr), sids in sorted(first.items(), key=lambda kv: kv[1][0]):
        h = headers[(bank, ptr)]
        sid = sids[0]
        others = ', '.join('$%02X' % x for x in sids[1:])
        hn = neutral(bank, ptr)
        if hn and hn not in used:
            used.add(hn)
            rows.append('\t'.join([hn, '%s%02X_Header' % ('SoundSfx' if sid >= 0x29 else 'SoundSong', sid), 'data', 'CONFIRMED',
                                   'stream header of song id $%02X: song table record (04:5515 + 8*id) points here, %d track(s)%s; decoded by tools/audio_to_macros.py'
                                   % (sid, h.tracks, ('; the records of ' + others + ' point to the same header') if others else '')]))
        for k, t in enumerate(h.sets[0]):
            tn = neutral(bank, t)
            if tn and tn not in used:
                used.add(tn)
                rows.append('\t'.join([tn, '%s%02X_Track%d' % ('SoundSfx' if sid >= 0x29 else 'SoundSong', sid, k), 'data', 'CONFIRMED',
                                       'start of the stream of track %d of song id $%02X: word %d of the stream header, read by SoundDrv_InitTrackRuntime (04:4386); the stream reader of the driver was run on this track (tools/audio_driver_check.py, check_songs)' % (k, sid, k)]))
    return rows


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
    ap.add_argument('-v', '--verbose', action='store_true')
    ap.add_argument('--names', metavar='FILE', help='also write the manifest rows that name song headers and tracks (for tools/apply_renames.py)')
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
    inc = open(os.path.join(root, 'includes.asm')).read()
    if 'constants/audio_macros.inc' not in inc:
        print('includes.asm does not include constants/audio_macros.inc', file=sys.stderr)
        return 2
    macros = open(os.path.join(root, 'constants/audio_macros.inc')).read()
    vals = []
    for m in re.finditer(r'^\t_sound_dur_def ([0-9, ]+)$', macros, re.M):
        vals += [int(x) for x in m.group(1).split(',')]
    if vals != DUR_VALUES:
        print('the duration values of constants/audio_macros.inc differ from the table', file=sys.stderr)
        return 2

    rom = Rom(rom_path)
    try:
        songs, headers, items, dur = decode_all(rom, print)
        files, created, raw_bytes, merged, labels = rewrite(root, rom, songs, headers, items, dur, a.verbose)
    except DecodeError as e:
        print('error: %s' % e, file=sys.stderr)
        return 2

    try:
        tfiles, tstats = table_files(root, rom, dur)
    except DecodeError as e:
        print('error: %s' % e, file=sys.stderr)
        return 2
    files = files + tfiles
    if a.names:
        rows = song_name_rows(songs, headers, labels)
        with open(a.names, 'w') as fh:
            fh.write('\n'.join(rows) + '\n')
        print('%d song/track name rows written to %s' % (len(rows), a.names))
    changed = [f for f in files if f.render() != f.text]
    kinds = {}
    for bank in (4, 5):
        for it in items[bank].values():
            kinds[it.kind] = kinds.get(it.kind, 0) + 1
    print('items: ' + ', '.join('%s %d' % kv for kv in sorted(kinds.items())))
    print('tables: durations 49, note records %d, instrument records %d (%d raw), wave patterns %d' % (NOTE_COUNT, INSTR_COUNT, tstats['instruments raw'], WAVE_COUNT))
    print('labels created: %d; blocks merged: %d; bytes left as db: %d; files that change: %d of %d' % (len(created), merged, raw_bytes, len(changed), len(files)))
    if a.check:
        for f in changed:
            print('not in macro form: ' + f.rel)
        return 1 if changed else 0
    if a.dry_run or not changed:
        return 0
    old = {f.path: f.text for f in changed}
    for f in changed:
        with open(f.path, 'w', encoding='utf-8') as fh:
            fh.write(f.render())
    if a.no_build:
        print('written %d files (not verified)' % len(changed))
        return 0
    ok, info = verify_tree(root, not a.no_symcheck)
    if not ok:
        for p, t in old.items():
            with open(p, 'w', encoding='utf-8') as fh:
                fh.write(t)
        run('make', root)
        print('VERIFICATION FAILED, files restored:\n' + info, file=sys.stderr)
        return 1
    print('written %d files; build OK, SHA-256 %s' % (len(changed), info))
    return 0


if __name__ == '__main__':
    sys.exit(main())
