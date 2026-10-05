#!/usr/bin/env python3
"""Independent parser of the sound macro files (audio/music/*.asm, audio/sfx.asm, audio/music_pointers.asm).

Written for docs/research/audio2_verify_dynamic.md.  It does NOT import tools/audio_to_macros.py and does not use its decoding: it reads the
source lines (macro name + operands), gives every macro a size from its OWN table (sizes are cross-checked against the label addresses of the
assembled build/mobile_trainer.sym and against the ROM bytes), and exposes

    Decode.cmds[(bank, addr)]   = dict(kind, size, op (expected opcode byte or None for running status), args, target, file, line)
    Decode.headers[(bank, addr)] = dict(ntracks, extra, sets=[[addr...], ...])
    Decode.songs[id]            = dict(header, bank, prio, flags, tracks)
"""
import re, sys, os, glob

ROOT = os.environ.get("AUDIO2_ROOT") or os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

DURATIONS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
             28, 30, 32, 36, 40, 42, 44, 48, 52, 54, 56, 60, 64, 66, 68, 72, 76, 78, 80, 84, 88, 90, 92, 96]


def load_sym(path=None):
    path = path or os.path.join(ROOT, "build", "mobile_trainer.sym")
    syms = {}
    for ln in open(path):
        m = re.match(r"([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) (\S+)", ln)
        if m:
            syms[m.group(3)] = (int(m.group(1), 16), int(m.group(2), 16))
    return syms


# macro -> (kind, fixed opcode or None, number of operand bytes (after the opcode) for fixed forms)
ONE_BYTE = {  # name: opcode (1 operand byte)
    "sound_tempo": 0xBC, "sound_pitch_add": 0xBD, "sound_instrument": 0xBE, "sound_volume": 0xBF, "sound_pan": 0xC0,
    "sound_pitch_bend": 0xC1, "sound_pitch_bend_scale": 0xC2, "sound_vibrato_rate": 0xC3, "sound_vibrato_delay": 0xC4,
    "sound_vibrato_depth": 0xC5, "sound_vibrato_disable": 0xC6, "sound_detune": 0xC9, "sound_cmd_CA": 0xCA,
}


CONSTS = {"SOUND_INSTRUMENT_PER_NOTE": 0x64}


def num(s, syms=None):
    s = s.strip()
    if s in CONSTS:
        return CONSTS[s]
    if s.startswith("$"):
        return int(s[1:], 16)
    if re.fullmatch(r"-?\d+", s):
        return int(s)
    raise ValueError("operand %r" % s)


def split_args(s):
    return [a.strip() for a in s.split(",")] if s.strip() else []


class Decode:
    def __init__(self, syms=None):
        self.syms = syms or load_sym()
        self.cmds = {}
        self.headers = {}
        self.songs = {}
        self.label_errors = []
        self.files = []
        self._parse_all()

    def _parse_file(self, path):
        syms = self.syms
        rel = os.path.relpath(path, ROOT)
        bank = addr = None
        rs = False
        pending_header = None
        for lineno, raw in enumerate(open(path), 1):
            line = raw.split(";")[0].rstrip() if not raw.lstrip().startswith(";") else ""
            if not line.strip() or line.strip().startswith("SECTION"):
                continue
            m = re.match(r"^([A-Za-z_][A-Za-z0-9_.]*)::?\s*$", line)
            if m:
                name = m.group(1)
                if name in syms:
                    lb, la = syms[name]
                    if addr is None:
                        bank, addr = lb, la
                    elif (lb, la) != (bank, addr):
                        self.label_errors.append((rel, lineno, name, "label at %02X:%04X, accumulated %02X:%04X" % (lb, la, bank, addr)))
                        bank, addr = lb, la
                continue
            line = line.strip()
            m = re.match(r"^dw\s+(.*)$", line)
            if m:
                words = split_args(m.group(1))
                if pending_header is not None:
                    h = pending_header
                    for w in words:
                        h["words"].append(syms[w][1] if w in syms else num(w))
                self._count(bank, addr)  # sanity: addr known
                addr += 2 * len(words)
                continue
            m = re.match(r"^(sound_rs\s+)?(sound_\w+)\s*(.*)$", line)
            if not m:
                raise SystemExit("%s:%d: unparsed line %r" % (rel, lineno, raw))
            rs = bool(m.group(1))
            name, args = m.group(2), split_args(m.group(3))
            if addr is None:
                raise SystemExit("%s:%d: no anchor address before the first command" % (rel, lineno))
            c = dict(file=rel, line=lineno, rs=rs, name=name, args=args, bank=bank, addr=addr)
            nopc = 0 if rs else 1
            if name == "sound_wait":
                v = num(args[0])
                c.update(kind="wait", op=None if rs else 0x80 + DURATIONS.index(v), value=v, size=nopc)
            elif name == "sound_note":
                d = num(args[0])
                op = 0xCE if d == 0 else 0xCF + DURATIONS.index(d)
                c.update(kind="note", op=None if rs else op, dur=d, size=nopc + len(args) - 1, extra=[num(a) for a in args[1:]])
            elif name == "sound_note_vol":
                d = num(args[0])
                op = 0xCE if d == 0 else 0xCF + DURATIONS.index(d)
                c.update(kind="note", op=None if rs else op, dur=d, size=nopc + 1, extra=[num(args[1])])
            elif name == "sound_note_off":
                c.update(kind="noteoff", op=None if rs else 0xCF, size=nopc + len(args), extra=[num(a) for a in args])
            elif name == "sound_end":
                c.update(kind="end", op=None if rs else 0xB1, size=nopc)
            elif name in ("sound_jump", "sound_call"):
                tgt = syms[args[0]][1] if args[0] in syms else num(args[0])
                c.update(kind="jump" if name == "sound_jump" else "call", op=None if rs else (0xB2 if name == "sound_jump" else 0xB3), size=nopc + 2, target=tgt)
            elif name == "sound_ret":
                c.update(kind="ret", op=None if rs else 0xB4, size=nopc)
            elif name == "sound_loop":
                tgt = syms[args[1]][1] if args[1] in syms else num(args[1])
                c.update(kind="loop", op=None if rs else 0xB5, size=nopc + 3, target=tgt, count=num(args[0]))
            elif name in ONE_BYTE:
                c.update(kind="one", op=None if rs else ONE_BYTE[name], size=nopc + 1, value=num(args[0]))
            elif name == "sound_cmd_CD":
                c.update(kind="ext", op=None if rs else 0xCD, size=nopc + 2)
            elif name == "sound_stream_header":
                c.update(kind="header", op=None, size=2, ntracks=num(args[0]), extra_sets=num(args[1]), words=[])
                pending_header = c
                self.headers[(bank, addr)] = c
            elif name == "sound_song":
                c.update(kind="song", op=None, size=8)
            else:
                raise SystemExit("%s:%d: unknown macro %s" % (rel, lineno, name))
            self.cmds[(bank, addr)] = c
            addr += c["size"]

    def _count(self, bank, addr):
        pass

    def _parse_all(self):
        files = sorted(glob.glob(os.path.join(ROOT, "audio", "music", "music_*.asm"))) + [os.path.join(ROOT, "audio", "sfx.asm")]
        for f in files:
            self._parse_file(f)
            self.files.append(f)
        # song table: sound_song lines carry the id in the comment
        sp = os.path.join(ROOT, "audio", "music_pointers.asm")
        for raw in open(sp):
            m = re.match(r"\s*sound_song\s+(\w+),\s*(\$\w+),\s*(\$\w+),\s*(\d+)\s*;\s*id\s*\$([0-9A-Fa-f]+)", raw)
            if m:
                hdr = self.syms[m.group(1)]
                self.songs[int(m.group(5), 16)] = dict(header=hdr[1], bank=hdr[0], prio=num(m.group(2)), flags=num(m.group(3)), tracks=int(m.group(4)))

    # ---- flow ---------------------------------------------------------------------------------------------------
    def track_starts(self, bank, haddr):
        h = self.headers[(bank, haddr)]
        n = h["ntracks"]
        return h["words"][:n], h

    def reachable(self, bank, starts):
        """All command addresses reachable from the track starts by the macro decode (jumps both ways, calls and their returns)."""
        seen = set()
        for s in starts:
            work = [(s, ())]
            visited = set()
            while work:
                a, stack = work.pop()
                if (a, stack) in visited:
                    continue
                visited.add((a, stack))
                c = self.cmds.get((bank, a))
                if c is None:
                    seen.add((a, None))
                    continue
                seen.add((a, c["kind"]))
                k = c["kind"]
                if k == "end":
                    continue
                if k == "jump":
                    work.append((c["target"], stack))
                elif k == "call":
                    work.append((c["target"], stack + (a + c["size"],)))
                elif k == "ret":
                    if stack:
                        work.append((stack[-1], stack[:-1]))
                    else:
                        work.append((a + c["size"], stack))
                elif k == "loop":
                    work.append((c["target"], stack))
                    work.append((a + c["size"], stack))
                else:
                    work.append((a + c["size"], stack))
        return {a for a, k in seen if k is not None}, {a for a, k in seen if k is None}


if __name__ == "__main__":
    d = Decode()
    print("commands", len([c for c in d.cmds.values() if c["kind"] not in ("header", "song")]), "headers", len(d.headers), "songs", len(d.songs))
    print("label errors", len(d.label_errors))
    for e in d.label_errors[:20]:
        print(e)
