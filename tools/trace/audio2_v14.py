#!/usr/bin/env python3
"""V1.4: what the doc admits not to have simulated.
  A. wave channel output level: NR32 as a function of the volume mirror (SoundDrv_WriteChannelVolume 04:4FC0) - steady state for all 16 levels, mGBA's own level as oracle
  B. wave channel: when is NR32 rewritten while the envelope runs (04:4E34 WaveLevelChanged flags only a change of the top two bits of the mirror)
  C. noise channel pitch (04:4F2D): NR43 for every value of (note pitch + pitch add) 0..255, and over the real data
usage: audio2_v14.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

def hi(x): return (x >> 4) & 0xF

def nr32_model(m):
    """04:4FC0: A = M - $40 ; A ^= $C0 ; rrca"""
    a = ((m - 0x40) & 0xFF) ^ 0xC0
    return ((a >> 1) | ((a & 1) << 7)) & 0xFF

def nr43_model(x, old=0):
    """04:4F2D: b = ~(x - $0D); d = b & 3; if b >= $C0: d |= ((b & $3C) << 2) | 4 ; NR43 = (old & 8) | d"""
    b = (~((x - 0x0D) & 0xFF)) & 0xFF
    d = b & 3
    if b >= 0xC0:
        d = (((b & 0x3C) << 2) & 0xFF) | d | 0x04
    return (old & 0x08) | d

def part_a(work):
    r = S.SynthRom()
    r.instr(0, [0x10, 0, 0, 0xEE, 0xFE, 0x3C])        # wave pattern 0, no attack, no decay, sustain code F, release code 7 (none)
    t = S.prologue() + S.instrument(0)
    for nvv in range(32):
        t += S.note(4, 0x45, nvv) + S.wait(8)
    t += S.end()
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "wave_a.gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], 4 + 8 * 32 + 20, q="VS", ev="wt", apu=True, out=os.path.join(work, "wave_a.log"))
    ev, _ = E.parse(log)
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    vs = {}
    for e in ev:
        if e["k"] == "Q" and e["q"] == "V" and e["reg"] == 0x1C:
            vs.setdefault(e["frame"], e)
    nr32 = {}
    for e in ev:
        if e["k"] == "W" and e["addr"] == 0xFF1C and e["pc"] == 0x4FC6:
            nr32.setdefault(e["frame"], e["val"])
    apu = S.parse_apu(log)
    rows = []
    ok = 0
    for nvv, s in zip(range(32), starts):
        f = s["frame"]
        v = vs.get(f)
        m = v["ch"][0x11] if v else None
        w = nr32.get(f)
        hw = apu[f]["ch3"][2] if f in apu else None          # mGBA ch3.volume = NR32 bits 6-5 as written
        exp = nr32_model(m) if m is not None else None
        rows.append((nvv, m, w, hw))
        if w is not None and exp == w and ((w >> 5) & 3) == hw:
            ok += 1
    print("A. wave NR32 (steady state): %d of 32 notes: NR32 == ((M - $40) ^ $C0) rotated right, and mGBA's level == bits 6-5" % ok)
    by_level = collections.defaultdict(set)
    for nvv, m, w, hw in rows:
        if m is not None and w is not None:
            by_level[m >> 4].add((w, hw))
    print("   mirror level (high nibble) -> (NR32 written, mGBA level code 0 mute / 1 100% / 2 50% / 3 25%):")
    for lvl in sorted(by_level):
        print("     level %2d: %s" % (lvl, sorted(("%02X" % w, hw) for w, hw in by_level[lvl])))

def part_b(work):
    """decay from 15 to sustain level 0..: the NR32 writes against the top two bits of the mirror (end-of-frame snapshots)"""
    combos = [(d, sc) for d in (1, 2, 3, 5, 7) for sc in (0, 2, 5, 9, 15)]
    r = S.SynthRom()
    t = S.prologue()
    for i, (d, sc) in enumerate(combos):
        r.instr(i, [0x10, 0, 0, 0xEE & ~0x0E | (((~d) & 7) << 1) | 0xE0, (sc << 4) | 0x0E, 0x3C])
        t += S.instrument(i) + S.note(96, 0x45, 0x1F) + S.wait(96) + S.wait(40)
    t += S.end()
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "wave_b.gbc"))
    nfr = 4 + 136 * len(combos) + 10
    log = S.run(rom, ["0:init", "2:music:28"], nfr, q="S", ev="wgt", snap=True, apu=True, out=os.path.join(work, "wave_b.log"))
    ev, _ = E.parse(log)
    snaps = {e["frame"]: e for e in ev if e["k"] == "F"}
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    wr = collections.defaultdict(list)
    for e in ev:
        if e["k"] == "W" and e["addr"] == 0xFF1C and e["pc"] == 0x4FC6:
            wr[e["frame"]].append(e["val"])
    bad = tot = 0
    notes = []
    for i, (cmb, s) in enumerate(zip(combos, starts)):
        fs = s["frame"]; fn = starts[i + 1]["frame"] if i + 1 < len(starts) else fs + 136
        prevtop = None
        prevlow = None
        seq = []
        for f in range(fs, fn):
            if f not in snaps: continue
            ch = snaps[f]["ch"][2 * 0x18:3 * 0x18]
            if not (ch[0] & 0x80): continue
            m = ch[0x11]
            top = m >> 6
            wrote = wr.get(f, [])
            low3 = m & 7
            should = (prevtop is None) or (top != prevtop) or (prevlow is not None and low3 != prevlow)
            tot += 1
            if bool(wrote) != should and not (f == fs):
                bad += 1
                if len(notes) < 8: notes.append((cmb, f - fs, "mirror %02X top %d prevtop %s low %d prevlow %s writes %s" % (m, top, prevtop, low3, prevlow, ["%02X" % x for x in wrote])))
            prevlow = low3
            if wrote:
                seq.append((f - fs, "%02X" % wrote[-1], "M=%02X" % m))
            prevtop = top
    print("B. wave channel, decays from level 15: frames compared %d, frames where `NR32 written <=> (top two bits of the mirror changed, or its low 3 bits changed (= an explicit NRx2-style write: decay start, sustain, release), or note start)` is violated: %d" % (tot, bad))
    for n in notes: print("   ", n)

def part_c(work):
    xs = list(range(256))
    # pitch byte $24 and pitch add x - $24 (so that note + add = x); the drum notes would use byte 5, not needed here
    r = S.SynthRom()
    r.instr(0, [0x41, 0, 0, 0xEE, 0xFA, 0x3C])      # noise, 7-bit counter bit0=1 -> NR43 bit 3 = 1
    r.instr(1, [0x40, 0, 0, 0xEE, 0xFA, 0x3C])      # noise, 15-bit counter -> NR43 bit 3 = 0
    chunks = []
    plan = []
    t = S.prologue() + S.instrument(0)
    for x in xs:
        add = (x - 0x24) & 0xFF
        t += S.pitch_add(add) + S.note(1, 0x24, 0x1F) + S.wait(2)
        plan.append((x, 1))
    t += S.instrument(1)
    for x in xs[::5]:
        add = (x - 0x24) & 0xFF
        t += S.pitch_add(add) + S.note(1, 0x24, 0x1F) + S.wait(2)
        plan.append((x, 0))
    t += S.end()
    assert len(t) < 0x3F00
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "noise.gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], 4 + 3 * len(plan) + 10, q="PS", ev="wt", apu=True, out=os.path.join(work, "noise.log"))
    ev, _ = E.parse(log)
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    ps = {}
    for e in ev:
        if e["k"] == "Q" and e["q"] == "P" and e["reg"] == 0x21:
            ps.setdefault(e["frame"], e)
    nr43 = collections.defaultdict(list)
    for e in ev:
        if e["k"] == "W" and e["addr"] == 0xFF22 and 0x4F2D <= e["pc"] <= 0x4F50:
            nr43[e["frame"]].append(e["val"])
    apu = S.parse_apu(log)
    ok = bad = 0
    table = {}
    msgs = []
    last_nr43 = 0
    for (x, width), s in zip(plan, starts):
        f = s["frame"]
        w = nr43.get(f)
        p = ps.get(f)
        # the register NR43 bit 3 was set by WriteChannelParams (width) just before; model with old = width<<3
        exp = nr43_model(x, width << 3)
        if w and w[-1] == exp:
            ok += 1
        else:
            bad += 1
            if len(msgs) < 8: msgs.append((x, width, "written %s model %02X" % (["%02X" % v for v in (w or [])], exp)))
        a = apu.get(f)
        if width == 1 and a and w:
            ch4 = a["ch4"]     # playing vol dead stepTime dir ratio shift power
            table[x] = (w[-1], ch4[5], ch4[6], ch4[7])
    print("C. noise NR43 for note + pitch add = 0..255 (and a sample with width bit 0): %d of %d equal to the model of 04:4F2D" % (ok, len(plan)))
    for m in msgs: print("   BAD", m)
    # mGBA's reading of the register: ratio / shift / power
    consistent = sum(1 for x, (w, ratio, shift, power) in table.items() if (w & 7) == ratio and (w >> 4) == shift and ((w >> 3) & 1) == power)
    print("   mGBA ch4 (ratio, shift, power) equals the register bits (bits 2-0, 7-4, 3) in %d of %d cases" % (consistent, len(table)))
    # frequency table for the musically used range and monotonicity
    def freq(w):
        r_ = w & 7; s_ = w >> 4
        return 262144 / ((r_ if r_ else 0.5) * 2 ** s_)
    rows = []
    for x in range(0x24, 0x80):
        if x in table:
            w = table[x][0]
            rows.append((x, w, freq(w)))
    mono_breaks = [(rows[i][0], rows[i + 1][0]) for i in range(len(rows) - 1) if rows[i + 1][2] < rows[i][2]]
    print("   x = pitch+add $24-$7F: NR43 and frequency (262144 / (r * 2^s) Hz) for x = $24,$30,$3C,$48,$4C,$4D,$54,$60,$7F:")
    for x, w, f in rows:
        if x in (0x24, 0x30, 0x3C, 0x48, 0x4C, 0x4D, 0x54, 0x60, 0x7F):
            print("      x=%02X NR43=%02X  s=%d r=%d  %.1f Hz" % (x, w, w >> 4, w & 7, f))
    print("   monotonic increase of the frequency with x over $24-$7F? breaks at:", mono_breaks[:8], "(x >= $4D selects the s = 0 branch)")
    # all 256 x: where is the frequency not increasing
    allrows = [(x, table[x][0], freq(table[x][0])) for x in sorted(table)]
    br = [(allrows[i][0], allrows[i + 1][0]) for i in range(len(allrows) - 1) if allrows[i + 1][2] < allrows[i][2]]
    print("   over x = 0..255 the frequency decreases between x and x+1 at:", br[:16], "... total", len(br))
    # real data
    return table

def real_noise(logdir):
    import glob
    ok = bad = 0
    xs = collections.Counter()
    for path in sorted(glob.glob(os.path.join(logdir, "song_*.log"))):
        ev, _ = E.parse(path)
        for i, e in enumerate(ev):
            if e["k"] == "Q" and e["q"] == "P" and e["reg"] == 0x21:
                x = (e["ch"][0x0E] + e["trk"][0x2D]) & 0xFF
                # channel +$8 bit 0 gives the width; NR43 old bit 3 = that
                width = e["ch"][8] & 1
                writes = []
                j = i + 1
                while j < len(ev) and ev[j]["k"] == "W" and 0x4ECA <= ev[j]["pc"] < 0x4F4F:
                    writes.append(ev[j]); j += 1
                w = [v["val"] for v in writes if v["addr"] == 0xFF22]
                xs[x] += 1
                if w and w[-1] == nr43_model(x, width << 3): ok += 1
                else: bad += 1
    print("   real data: noise pitch writes %d, equal to the model: %d, different: %d; distinct x values: %s" % (ok + bad, ok, bad, sorted("%02X" % k for k in xs)))

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_v14"
    os.makedirs(work, exist_ok=True)
    part_a(work); part_b(work); part_c(work)
    real_noise(sys.argv[2] if len(sys.argv) > 2 else "../work/songsq")

if __name__ == "__main__":
    main()
