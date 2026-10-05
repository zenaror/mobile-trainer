#!/usr/bin/env python3
"""Parsing of apu_probe event logs and a few helpers shared by the audio2 verification scripts (see tools/trace/apu_probe.c for the format)."""
import os, collections

ROOT = os.environ.get("AUDIO2_ROOT") or os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
ROM_PATH = os.path.join(ROOT, "Mobile Trainer (Japan).gbc")

_rom = None


def rom(path=None):
    global _rom
    if path:
        return open(path, "rb").read()
    if _rom is None:
        _rom = open(ROM_PATH, "rb").read()
    return _rom


def rb(bank, addr, r=None):
    r = r or rom()
    return r[bank * 0x4000 + (addr - 0x4000)] if addr >= 0x4000 else r[addr]


def note_table(r=None):
    """Table_SoundDrv_NoteFreq: 120 records of (period word, step byte) at 04:5075 - read from the ROM bytes."""
    r = r or rom()
    out = []
    for i in range(120):
        a = 0x5075 + 3 * i
        out.append((rb(4, a, r) | rb(4, a + 1, r) << 8, rb(4, a + 2, r)))
    return out


def durations(r=None):
    r = r or rom()
    return [rb(4, 0x5044 + i, r) for i in range(49)]


def instruments(r=None):
    r = r or rom()
    return [bytes(rb(4, 0x51DD + 6 * i + j, r) for j in range(6)) for i in range(112)]


class Ev:
    """One event.  kind: W C N G E J Q T F R"""
    __slots__ = ("kind", "frame", "tM", "tS", "f")

    def __init__(self, kind, frame, tM, tS, f):
        self.kind, self.frame, self.tM, self.tS, self.f = kind, frame, tM, tS, f

    def __repr__(self):
        return "Ev(%s f=%d tM=%d tS=%d %s)" % (self.kind, self.frame, self.tM, self.tS, self.f)


def parse(path):
    """Returns a chronological list of dict events and a dict of '#' meta lines."""
    ev = []
    meta = {}
    with open(path) as fh:
        for ln in fh:
            if not ln:
                continue
            k = ln[0]
            if k == "W":
                p = ln.split()
                bk, pc = p[4].split(":")
                ev.append(dict(k="W", frame=int(p[1]), tM=int(p[2]), tS=int(p[3]), bank=int(bk, 16), pc=int(pc, 16), addr=int(p[5], 16), val=int(p[6], 16)))
            elif k == "C":
                p = ln.split()
                ev.append(dict(k="C", frame=int(p[1]), tM=int(p[2]), tS=int(p[3]), track=int(p[4]), bank=int(p[5]), de=int(p[6], 16), op=int(p[7], 16), b1=int(p[8], 16)))
            elif k == "N":
                p = ln.split()
                ev.append(dict(k="N", frame=int(p[1]), tM=int(p[2]), tS=int(p[3]), track=int(p[4]), de=int(p[5], 16), trk=bytes.fromhex(p[6]), flags=int(p[7], 16)))
            elif k == "G":
                p = ln.split()
                ev.append(dict(k="G", frame=int(p[1]), tM=int(p[2]), tS=int(p[3]), chan=int(p[4]), chptr=int(p[5], 16)))
            elif k == "E":
                p = ln.split()
                ev.append(dict(k="E", frame=int(p[1]), tM=int(p[2]), tS=int(p[3]), chan=int(p[4])))
            elif k == "J":
                p = ln.split()
                ev.append(dict(k="J", frame=int(p[1]), tM=int(p[2]), tS=int(p[3]), track=int(p[4])))
            elif k == "T":
                p = ln.split()
                ev.append(dict(k="T", frame=int(p[1]), tM=int(p[2]), tS=int(p[3])))
            elif k == "Q":
                p = ln.split()
                ev.append(dict(k="Q", q=p[1], frame=int(p[2]), tM=int(p[3]), tS=int(p[4]), chan=int(p[5]), track=int(p[6]), A=int(p[7], 16), BC=int(p[8], 16), DE=int(p[9], 16), HL=int(p[10], 16),
                               ch=bytes.fromhex(p[11]) if p[11] != "-" else b"", trk=bytes.fromhex(p[12]) if p[12] != "-" else b"", flags=int(p[13], 16), reg=int(p[14], 16)))
            elif k == "F":
                p = ln.split()
                ev.append(dict(k="F", frame=int(p[1]), glob=bytes.fromhex(p[2]), trk=bytes.fromhex(p[3]), ch=bytes.fromhex(p[4])))
            elif k == "R":
                p = ln.split()
                bk, pc = p[2].split(":")
                ev.append(dict(k="R", frame=int(p[1]), bank=int(bk, 16), pc=int(pc, 16), addr=int(p[3], 16), val=int(p[4], 16), svbk=int(p[5])))
            elif k == "#":
                meta.setdefault("lines", []).append(ln.strip())
    return ev, meta


# register helpers
NRX2 = {0: 0xFF12, 1: 0xFF17, 2: 0xFF1C, 3: 0xFF21}   # by channel index (the driver's "channel register" is the NRx2 address; wave uses NR32)


def u8(x):
    return x & 0xFF


def s8(x):
    x &= 0xFF
    return x - 256 if x & 0x80 else x
