#!/usr/bin/env python3
"""V1.2 (physical check of the pitch claim): the audio that mGBA's APU actually renders for a pitch byte, measured by zero crossings (DC removed), for pulse 1, pulse 2 and
the wave channel (+$0C octave compensation), against f = 440 * 2^((pitch - 69) / 12) (doc 4.3 / 8: the pitch byte is the MIDI note number, C4 = 60).
usage: audio2_v12_freq.py [workdir]"""
import sys, os, struct, math, array
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

def measure(samples, rate, i0, i1):
    seg = samples[i0:i1]
    if not seg: return None
    mean = sum(seg) / len(seg)
    prev = seg[0] - mean
    cross = 0
    first = last = None
    for k in range(1, len(seg)):
        v = seg[k] - mean
        if (prev < 0 <= v) or (prev >= 0 > v):
            cross += 1
            if first is None: first = k
            last = k
        prev = v
    if cross < 3: return None
    # use first..last crossing for sub-sample accuracy
    return (cross - 1) / 2 / ((last - first) / rate)

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_freq"
    os.makedirs(work, exist_ok=True)
    pitches = [0x24, 0x30, 0x3C, 0x45, 0x51, 0x5A]
    table = E.note_table()
    classes = [("pulse1", [0x02, 0, 0, 0xEE, 0xFE, 0x3C], 1), ("pulse2", [0x0A, 0, 0, 0xEE, 0xFE, 0x3C], 1), ("wave", [0x11, 0, 0, 0xEE, 0xFE, 0x3C], 2)]
    print("pitch  f(ET)    period(table) f(hardware formula)   measured pulse1  pulse2   wave")
    res = {}
    for name, rec, _ in classes:
        r = S.SynthRom()
        r.instr(1, rec)
        t = S.prologue() + S.instrument(1)
        for p in pitches:
            t += S.note(32, p, 0x1F) + S.wait(36)
        t += S.end()
        r.song(0x28, [t])
        rom = r.save(os.path.join(work, "freq_%s.gbc" % name))
        nfr = 4 + 36 * len(pitches) + 6
        raw = os.path.join(work, "freq_%s.raw" % name)
        log = S.run(rom, ["0:init", "2:music:28"], nfr, q="S", ev="t", extra=["--audio", raw], out=os.path.join(work, "freq_%s.log" % name))
        meta = open(log).read()
        rate = int([l for l in meta.splitlines() if l.startswith("# rate")][0].split()[2])
        a = array.array("h"); a.frombytes(open(raw, "rb").read())
        left = a[0::2]
        per_frame = len(left) / nfr
        ev, _ = E.parse(log)
        starts = [e["frame"] for e in ev if e["k"] == "Q" and e["q"] == "S"]
        vals = []
        for p, fs in zip(pitches, starts):
            i0 = int((fs + 6) * per_frame); i1 = int((fs + 28) * per_frame)
            vals.append(measure(left, rate, i0, i1))
        res[name] = vals
    for k, p in enumerate(pitches):
        f_et = 440 * 2 ** ((p - 69) / 12)
        P = table[p - 0x24][0]
        f_hw = 131072 / (2048 - P)
        print("$%02X  %8.2f   %4d          %8.2f           %s" % (p, f_et, P, f_hw, "  ".join("%8.2f" % res[n][k] if res[n][k] else "    none" for n in ("pulse1", "pulse2", "wave"))))

if __name__ == "__main__":
    main()
