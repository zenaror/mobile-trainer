#!/usr/bin/env python3
"""V1.3 synthetic: `$CD` extended command (doc 4.2, 5.1): sub-commands 1-7, 10, 11 store the argument in track fields (+$0C, +$0F/+$10 nibbles, +$27, +$28, +$0D, +$0E),
0, 8, 9 and >= 12 end the track; and what the patched fields do to the registers (duty, length, byte 2, envelope bytes 3/4).  usage: audio2_v13_ext.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E, audio2_envmodel as M

BASE = [0x0A, 0, 0, 0xEC, 0xFA, 0x3C]     # pulse 2 duty 2

def expected_fields(prev, sub, val):
    f = dict(prev)
    if sub == 1: f["c"] = val
    elif sub == 10: f["d"] = val
    elif sub == 11: f["e"] = val
    elif sub == 2: f["f"] = (f["f"] & 0x0F) | ((val & 0x0F) << 4)
    elif sub == 3: f["f"] = (f["f"] & 0xF0) | (val & 0x0F)
    elif sub == 4: f["g"] = (f["g"] & 0x0F) | ((val & 0x0F) << 4)
    elif sub == 5: f["g"] = (f["g"] & 0xF0) | (val & 0x0F)
    elif sub == 6: f["p27"] = val
    elif sub == 7: f["p28"] = val
    return f

def part_a(work):
    r = S.SynthRom()
    r.instr(1, BASE)
    subs = [1, 2, 3, 4, 5, 6, 7, 10, 11]
    vals = [0x00, 0x5A, 0xA5, 0xFF, 0x0F, 0xF0, 0x37]
    plan = [(s, v) for s in subs for v in vals]
    t = S.prologue() + S.instrument(1) + S.wait(2)
    for s, v in plan:
        t += S.ext(s, v) + S.wait(2)
    t += S.end()
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "ext_a.gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], 4 + 2 * len(plan) + 10, ev="ct", snap=True, out=os.path.join(work, "ext_a.log"))
    ev, _ = E.parse(log)
    snaps = {e["frame"]: e for e in ev if e["k"] == "F"}
    cmdf = [e for e in ev if e["k"] == "C" and e["op"] == 0xCD]
    assert len(cmdf) == len(plan), (len(cmdf), len(plan))
    # field state before the first CD: after the instrument command
    f0 = cmdf[0]["frame"]
    t0 = snaps[f0 - 1]["trk"][4 * 0x3C:5 * 0x3C] if (f0 - 1) in snaps else None
    fields = dict(c=BASE[0], d=BASE[1], e=BASE[2], f=BASE[3], g=BASE[4], p27=0, p28=0)
    ok = bad = 0
    msgs = []
    for (s, v), c in zip(plan, cmdf):
        fields = expected_fields(fields, s, v)
        t = snaps[c["frame"]]["trk"][4 * 0x3C:5 * 0x3C]
        got = dict(c=t[0x0C], d=t[0x0D], e=t[0x0E], f=t[0x0F], g=t[0x10], p27=t[0x27], p28=t[0x28])
        if got == fields:
            ok += 1
        else:
            bad += 1
            if len(msgs) < 6: msgs.append(("sub", s, "val %02X" % v, "got", {k: "%02X" % x for k, x in got.items()}, "expected", {k: "%02X" % x for k, x in fields.items()}))
    print("A. fields after `$CD sub val`: %d cases, equal to the doc's field map: %d, different: %d" % (len(plan), ok, bad))
    for m in msgs: print("  ", m)

def part_b(work):
    subs = [0, 8, 9, 12, 13, 14, 15, 0x20, 0x7F, 0xFF, 1, 11]
    res = {}
    for s in subs:
        r = S.SynthRom()
        r.instr(1, BASE)
        t = S.prologue() + S.instrument(1) + S.wait(2) + S.ext(s, 0x11) + S.wait(2) + S.note(1, 0x40, 0x1F) + S.wait(2) + S.end()
        r.song(0x28, [t])
        rom = r.save(os.path.join(work, "ext_b%02X.gbc" % s))
        log = S.run(rom, ["0:init", "2:music:28"], 20, ev="ct", snap=True, out=os.path.join(work, "ext_b%02X.log" % s))
        ev, _ = E.parse(log)
        cmds = [e for e in ev if e["k"] == "C"]
        snaps = {e["frame"]: e for e in ev if e["k"] == "F"}
        last = cmds[-1]
        active_after = [snaps[f]["trk"][4 * 0x3C] >> 7 for f in sorted(snaps) if f > last["frame"]]
        res[s] = (len(cmds), "%02X" % last["op"], last["frame"], active_after[:2])
    print("B. `$CD sub 11` then a note: (number of commands decoded, last opcode, frame, track-active flag in the next frames):")
    for s, v in res.items():
        print("   sub %02X: %s  -> %s" % (s, v, "track ENDED at the CD (note never decoded)" if v[1] == "CD" and v[3] and v[3][0] == 0 else "track continued"))

def part_c(work):
    """sub 2,3,4,5 set the envelope bytes 3 and 4 nibble by nibble; compare the NRx2 sequence with the envelope model for b3 = (hv,lv), b4 = (sv,rv)"""
    combos = []
    import random
    rnd = random.Random(99)
    for _ in range(30):
        combos.append(tuple(rnd.randrange(16) for _ in range(4)))
    r = S.SynthRom()
    r.instr(1, BASE)
    t = S.prologue() + S.instrument(1)
    for hv, lv, sv, rv in combos:
        t += S.ext(2, hv) + S.ext(3, lv) + S.ext(4, sv) + S.ext(5, rv) + S.note(96, 0x45, 0x1F) + S.wait(96) + S.wait(96)
    t += S.end()
    assert len(t) < 0x3F00
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "ext_c.gbc"))
    nframes = 4 + 192 * len(combos) + 10
    log = S.run(rom, ["0:init", "2:music:28"], nframes, q="VS", ev="wgt", out=os.path.join(work, "ext_c.log"))
    ev, _ = E.parse(log)
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    gates = [e for e in ev if e["k"] == "G"]
    writes = [e for e in ev if e["k"] == "W" and e["addr"] == 0xFF17 and e["pc"] in (0x4FB9, 0x4FDE)]
    vev = [e for e in ev if e["k"] == "Q" and e["q"] == "V" and e["chan"] == 1]
    ok = 0
    for i, (cmb, s) in enumerate(zip(combos, starts)):
        hv, lv, sv, rv = cmb
        b3, b4 = (hv << 4) | lv, (sv << 4) | rv
        fs = s["frame"]; fn = starts[i + 1]["frame"] if i + 1 < len(starts) else fs + 192
        fg = next((g["frame"] for g in gates if g["chan"] == 1 and fs < g["frame"] <= fn), None)
        obs = [(w["frame"], w["val"]) for w in writes if fs <= w["frame"] < fn]
        if obs and obs[0][0] == fs and obs[0][1] == 0x08: obs = obs[1:]
        v0 = next((v for v in vev if v["frame"] == fs), None)
        trkout = v0["trk"][0x2F] if v0 else s["trk"][0x2F]
        got_b3, got_b4 = (v0["ch"][0x0B], v0["ch"][0x0C]) if v0 else (None, None)
        exp = M.simulate(b3, b4, ((0x1F << 3) | 7) & 0xFF, trkout, fs, fg, fn - fs)
        if obs == [(f, v) for f, v, k in exp] and (got_b3, got_b4) == (b3, b4):
            ok += 1
    print("C. `$CD 2/3/4/5` build bytes 3 and 4 nibble by nibble: %d of %d notes: instrument bytes and NRx2 sequence equal the envelope model" % (ok, len(combos)))

def part_d(work):
    """sub 1 (byte 0), sub 10 (length), sub 11 (byte 2) and their register effects"""
    r = S.SynthRom()
    r.instr(1, BASE)
    t = S.prologue() + S.instrument(1)
    cases = []
    for b0 in (0x08, 0x09, 0x0B, 0x00, 0x03, 0x10, 0x12, 0x41, 0x40):
        t += S.ext(1, b0) + S.note(2, 0x45, 0x1F) + S.wait(6)
        cases.append(("b0", b0))
    t += S.ext(1, 0x0A)
    for ln in (0x01, 0x10, 0x20, 0x3F, 0x40, 0xFF, 0x00):
        t += S.ext(10, ln) + S.note(24, 0x45, 0x1F) + S.wait(24) + S.wait(12)
        cases.append(("len", ln))
    t += S.ext(10, 0)
    for b2 in (0x00, 0x5A, 0xFF):
        t += S.ext(11, b2) + S.note(2, 0x45, 0x1F) + S.wait(6)
        cases.append(("b2", b2))
    t += S.end()
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "ext_d.gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], 4 + 6 * 9 + 36 * 7 + 6 * 3 + 20, q="BS", ev="wt", apu=True, out=os.path.join(work, "ext_d.log"))
    ev, _ = E.parse(log)
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    bs = {}
    for e in ev:
        if e["k"] == "Q" and e["q"] == "B": bs.setdefault(e["frame"], e)
    apu = S.parse_apu(log)
    for (kind, v), s in zip(cases, starts):
        b = bs.get(s["frame"])
        if kind == "b0":
            cls = "pulse1" if v < 8 else "pulse2" if v < 0x10 else "wave" if v < 0x40 else "noise"
            print("D. sub 1 byte0=%02X -> class %s, channel register $%02X seen at WriteChannelParams: %s" % (v, cls, b["reg"] if b else 0, "ok" if b and {"pulse1": 0x12, "pulse2": 0x17, "wave": 0x1C, "noise": 0x21}[cls] == b["reg"] else "MISMATCH"))
        elif kind == "len":
            fs = s["frame"]
            # frames until the channel stops playing (playingCh2 drops)
            stop = next((f for f in range(fs, fs + 40) if f in apu and apu[f]["ch2"][0] == 0), None)
            ws = [(w["addr"], w["val"]) for w in ev if w["k"] == "W" and w["frame"] == fs and w["addr"] in (0xFF16, 0xFF19) and 0x4E4B <= w["pc"] < 0x4ECA]
            exp_ticks = (v if v else None)
            print("D. sub 10 length=%02X -> writes at note start %s ; mGBA ch2 playing flag drops after %s frames (length/256 s = %s frames)" % (v, [("%04X" % a, "%02X" % x) for a, x in ws], None if stop is None else stop - fs, "-" if not v else "%.1f (NR21 gets (-len)&$3F = %d -> %d/256 s)" % (((-v) & 0x3F and (64 - ((-v) & 0x3F)) or 64) / 256 * 60, (-v) & 0x3F, 64 - ((-v) & 0x3F) if (-v) & 0x3F else 64)))
        else:
            ws = [(w["addr"], w["val"]) for w in ev if w["k"] == "W" and w["frame"] == s["frame"] and w["addr"] in (0xFF15, 0xFF10) and 0x4E4B <= w["pc"] < 0x4ECA]
            print("D. sub 11 byte2=%02X -> writes at note start %s" % (v, [("%04X" % a, "%02X" % x) for a, x in ws]))

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_v13ext"
    os.makedirs(work, exist_ok=True)
    part_a(work); part_b(work); part_c(work); part_d(work)

if __name__ == "__main__":
    main()
