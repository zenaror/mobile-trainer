#!/usr/bin/env python3
"""Synthetic ROM copies and a runner for tools/trace/apu_probe.c (adversarial dynamic verification of the sound driver).

A synthetic ROM is a COPY of `Mobile Trainer (Japan).gbc` held in memory, patched and written under another name in a private directory:
  - a song (header + track streams) is written into ROM bank 6 (entirely $00 in the original) at $4000+, and a song record of an unused id (default $28, a copy of
    song 1) is made to point at it;
  - instrument records (04:51DD + 6*id) can be replaced (the copy never plays another song, so every id may be reused);
  - any other bytes can be patched (`patch`).
The original ROM file is only read.

Stream helpers (bytes) follow the stream format of docs/research/audio_format.md section 4, written here again from the driver code (04:459B ...),
not from tools/audio_to_macros.py: wait(d), note(d, pitch, vol), end(), jump(addr), call(addr), ret(), tempo(v), pitch_add(v), instrument(i), volume(v) and the raw cmd(op, *args).
"""
import os, subprocess, sys, tempfile, hashlib
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_ev as E

DUR = E.durations()
PROBE = os.environ.get("APU_PROBE") or os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "apu_probe")


def wait(d):
    assert d in DUR, d
    return bytes([0x80 + DUR.index(d)])


def note_op(d):
    assert d in DUR, d
    return 0xCE if d == 0 else 0xCF + DUR.index(d)


def note(d, pitch=None, vol=None, rs=False, order="pv", adjust=None):
    """note with duration d (table value), optional pitch byte, optional volume byte value (0-$1F)"""
    out = [] if rs else [note_op(d)]
    for c in order:
        if c == "p" and pitch is not None:
            out.append(pitch)
        if c == "v" and vol is not None:
            out.append(vol)
        if c == "a" and adjust is not None:
            out.append(adjust)
    return bytes(out)


def end():
    return bytes([0xB1])


def jump(addr):
    return bytes([0xB2, addr & 0xFF, addr >> 8])


def call(addr):
    return bytes([0xB3, addr & 0xFF, addr >> 8])


def ret():
    return bytes([0xB4])


def loop(count, addr):
    return bytes([0xB5, count, addr & 0xFF, addr >> 8])


def tempo(v):
    return bytes([0xBC, v])


def pitch_add(v):
    return bytes([0xBD, v & 0xFF])


def instrument(i):
    return bytes([0xBE, i])


def volume(v):
    return bytes([0xBF, v])


def cmd(op, *args):
    return bytes([op] + list(args))


def ext(sub, val):
    return bytes([0xCD, sub, val])


def prologue(vol=0x7F, tmp=0x4A, add=0x00):
    return volume(vol) + pitch_add(add) + tempo(tmp)


class SynthRom:
    def __init__(self, base_path=None):
        self.base_path = base_path or E.ROM_PATH
        self.rom = bytearray(open(self.base_path, "rb").read())
        self.orig_sha = hashlib.sha256(self.rom).hexdigest()
        self.next_org = {}

    def put(self, bank, addr, data):
        off = bank * 0x4000 + (addr - 0x4000) if addr >= 0x4000 else addr
        self.rom[off:off + len(data)] = data

    def free(self, bank, addr, n):
        off = bank * 0x4000 + (addr - 0x4000)
        assert all(b == 0 for b in self.rom[off:off + n]), "synthetic data would overwrite non-zero ROM bytes in bank %d at %04X" % (bank, addr)

    def song(self, sid, tracks, bank=6, org=None, prio=0xC8, flags=0xFF, extra_sets=0, spare=0):
        """tracks: list of bytes; the streams are laid out back to back from org, then the header; returns (header addr, [track addrs])"""
        org = org if org is not None else self.next_org.get(bank, 0x4000)
        addrs = []
        a = org
        for t in tracks:
            self.free(bank, a, len(t))
            self.put(bank, a, t)
            addrs.append(a)
            a += len(t)
        hdr = a
        h = bytes([len(tracks), extra_sets])
        for ad in addrs:
            h += bytes([ad & 0xFF, ad >> 8])
        self.free(bank, hdr, len(h))
        self.put(bank, hdr, h)
        self.next_org[bank] = hdr + len(h)
        rec = bytes([hdr & 0xFF, hdr >> 8, bank & 0xFF, bank >> 8, prio, flags, len(tracks), spare])
        self.put(4, 0x5515 + 8 * sid, rec)
        return hdr, addrs

    def instr(self, idx, rec):
        assert len(rec) == 6
        self.put(4, 0x51DD + 6 * idx, bytes(rec))

    def patch(self, bank, addr, data):
        self.put(bank, addr, bytes(data))

    def save(self, path):
        assert os.path.abspath(path) != os.path.abspath(E.ROM_PATH)
        with open(path, "wb") as f:
            f.write(self.rom)
        return path


def run(rom_path, calls, frames, q="", ev="wcngejt", boot=300, out=None, apu=False, snap=False, extra=(), pokes=(), timeout=600, stop_idle=None, stop_loops=None, rwatch=None):
    out = out or tempfile.mktemp(suffix=".log", prefix="synth_")
    cmd_ = [PROBE, "--rom", rom_path, "--out", out, "--boot", str(boot), "--frames", str(frames), "--ev", ev]
    for c in calls:
        cmd_ += ["--call", c]
    for p in pokes:
        cmd_ += ["--poke", p]
    if q:
        cmd_ += ["--q", q]
    if apu:
        cmd_ += ["--apu"]
    if snap:
        cmd_ += ["--snap"]
    if stop_idle is not None:
        cmd_ += ["--stop-idle", str(stop_idle)]
    if stop_loops is not None:
        cmd_ += ["--stop-loops", str(stop_loops)]
    if rwatch:
        cmd_ += ["--rwatch", rwatch]
    cmd_ += list(extra)
    r = subprocess.run(cmd_, capture_output=True, text=True, timeout=timeout)
    if r.returncode != 0:
        raise RuntimeError("apu_probe failed: %s\n%s" % (" ".join(cmd_), r.stderr))
    return out


def parse_apu(path):
    """A events: dict frame -> dict of fields"""
    res = {}
    with open(path) as fh:
        for ln in fh:
            if ln.startswith("A "):
                parts = ln.replace("|", " ").split()
                f = int(parts[1])
                v = [int(x) for x in parts[2:2 + 8 + 8 + 5 + 8]] + [int(x, 16) for x in parts[2 + 29:2 + 32]]
                res[f] = dict(ch1=v[0:8], ch2=v[8:16], ch3=v[16:21], ch4=v[21:29], nr51=v[29], nr50l=v[30], nr50r=v[31])
    return res
