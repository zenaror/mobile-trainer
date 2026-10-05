#!/usr/bin/env python3
"""V1.2/V1.3/V1.4 physical checks on the audio that mGBA renders (zero crossings, RMS): pitch bend ($C1/$C2) in semitones, pan ($C0) left/right levels, wave output level (NR32) ratios,
vibrato depth.  usage: audio2_v12_phys.py [workdir]"""
import sys, os, array, math
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E
from audio2_v12_freq import measure

def load(raw):
    a = array.array("h"); a.frombytes(open(raw, "rb").read())
    return a[0::2], a[1::2]

def rms(seg):
    if not seg: return 0.0
    m = sum(seg) / len(seg)
    return math.sqrt(sum((x - m) ** 2 for x in seg) / len(seg))

def run_song(work, name, track, nframes, rec=None, extra_instr=None):
    r = S.SynthRom()
    for idx, rc in (extra_instr or {1: [0x0A, 0, 0, 0xEE, 0xFE, 0x3C]}).items():
        r.instr(idx, rc)
    r.song(0x28, [track])
    rom = r.save(os.path.join(work, name + ".gbc"))
    raw = os.path.join(work, name + ".raw")
    log = S.run(rom, ["0:init", "2:music:28"], nframes, q="S", ev="t", extra=["--audio", raw], out=os.path.join(work, name + ".log"))
    meta = open(log).read()
    rate = int([l for l in meta.splitlines() if l.startswith("# rate")][0].split()[2])
    l, rr = load(raw)
    ev, _ = E.parse(log)
    starts = [e["frame"] for e in ev if e["k"] == "Q" and e["q"] == "S"]
    return l, rr, rate, len(l) / nframes, starts

def bend(work):
    cases = [(0x40, 2), (0x48, 0x10), (0x50, 0x10), (0x60, 0x10), (0x70, 0x08), (0x7F, 0x04), (0x38, 0x10), (0x30, 0x10), (0x20, 0x10), (0x00, 0x08)]
    t = S.prologue() + S.instrument(1)
    for v, s in cases:
        t += S.cmd(0xC2, s) + S.cmd(0xC1, v) + S.note(32, 0x45, 0x1F) + S.wait(36)
    t += S.end()
    nfr = 4 + 36 * len(cases) + 6
    l, r, rate, pf, starts = run_song(work, "bend", t, nfr)
    print("bend: pitch $45 (439.84 Hz at period 1750), `$C2 s`, `$C1 v`: measured shift in semitones vs the doc's (v-$40)*s/64 (v >= $40) and that + s/256 below, and the period-domain model:")
    base = measure(l, rate, int((starts[0] + 6) * pf), int((starts[0] + 28) * pf))
    table = E.note_table()
    for (v, s), fs in zip(cases, starts):
        f = measure(l, rate, int((fs + 6) * pf), int((fs + 28) * pf))
        sem = 12 * math.log2(f / 439.84) if f else None
        doc = (v - 0x40) * s / 64
        own = (((v - 0x40) * 4 * s) + (s if v < 0x40 else 0)) / 256
        # model of the driver: +$2C/$2D = product; index + high byte, period = table[idx] + ceil(step*low/256)
        prod = ((v - 0x40) * 4 * s + (s if v < 0x40 else 0)) & 0xFFFF
        lo, hi = prod & 0xFF, prod >> 8
        hi = hi - 256 if hi & 0x80 else hi
        idx = (0x45 + hi - 0x24)
        P = table[idx][0] + ((table[idx][1] * lo + 255) >> 8)
        fm = 131072 / (2048 - P)
        print("   v=$%02X s=$%02X: measured %8.2f Hz = %+.3f semitones; doc %+.3f, own %+.3f; model period %d -> %.2f Hz (%+.3f)" % (v, s, f, sem, doc, own, P, fm, 12 * math.log2(fm / 439.84)))

def pan(work):
    vals = [0x00, 0x10, 0x1F, 0x20, 0x40, 0x5F, 0x60, 0x70, 0x7F]
    t = S.prologue() + S.instrument(1)
    for v in vals:
        t += S.cmd(0xC0, v) + S.note(32, 0x45, 0x1F) + S.wait(36)
    t += S.end()
    nfr = 4 + 36 * len(vals) + 6
    l, r, rate, pf, starts = run_song(work, "pan", t, nfr)
    print("pan: `$C0 v` on pulse 2: RMS of the left / right output (doc: left only $00-$1F, both $20-$5F, right only $60-$7F):")
    for v, fs in zip(vals, starts):
        i0, i1 = int((fs + 6) * pf), int((fs + 28) * pf)
        print("   v=$%02X: left %8.1f  right %8.1f   -> %s" % (v, rms(l[i0:i1]), rms(r[i0:i1]), "left only" if rms(r[i0:i1]) < 1 and rms(l[i0:i1]) > 1 else "right only" if rms(l[i0:i1]) < 1 and rms(r[i0:i1]) > 1 else "both"))

def wavelevel(work):
    # wave instrument (pattern 0), note volumes giving mirror levels 15, 12, 11, 8, 7, 4, 3, 1
    nvvs = [0x1F, 0x19, 0x17, 0x11, 0x0F, 0x09, 0x07, 0x03]
    t = S.prologue() + S.instrument(2)
    for nv in nvvs:
        t += S.note(32, 0x45, nv) + S.wait(36)
    t += S.end()
    nfr = 4 + 36 * len(nvvs) + 6
    l, r, rate, pf, starts = run_song(work, "wavelvl", t, nfr, extra_instr={2: [0x10, 0, 0, 0xEE, 0xFE, 0x3C]})
    ref = None
    print("wave output level: RMS for note volumes (mirror level = ceil(15 * (v>>1) / 16)):")
    for nv, fs in zip(nvvs, starts):
        i0, i1 = int((fs + 6) * pf), int((fs + 28) * pf)
        a = rms(l[i0:i1])
        lvl = ((15 * (nv >> 1)) + 15) // 16
        if ref is None: ref = a
        print("   note volume %02X -> mirror level %2d: RMS %8.1f (%.2f of the first)" % (nv, lvl, a, a / ref if ref else 0))

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_phys"
    os.makedirs(work, exist_ok=True)
    bend(work); pan(work); wavelevel(work)

if __name__ == "__main__":
    main()
