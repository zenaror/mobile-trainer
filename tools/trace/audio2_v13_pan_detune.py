#!/usr/bin/env python3
"""V1.3 synthetic: `$C0` pan (all 256 values on all four channels -> NR51), `$C9` detune (all 256 values) and `$CA` (stores a byte nobody reads; flags the pitch as changed).
usage: audio2_v13_pan_detune.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

def rotl8(x): return ((x << 1) | (x >> 7)) & 0xFF

# instrument records: 0 pulse1, 1 pulse2, 2 wave (pattern 0), 3 noise
INSTR = {0: [0x02, 0, 0, 0xEC, 0xFA, 0x3C], 1: [0x0A, 0, 0, 0xEC, 0xFA, 0x3C], 2: [0x10, 0, 0, 0xEC, 0xFA, 0x3C], 3: [0x41, 0, 0, 0xEC, 0xFA, 0x3C]}
NR51_D = {0: 0xEE, 1: 0xDD, 2: 0xBB, 3: 0x77}
NR51_E = {0: 0x11, 1: 0x22, 2: 0x44, 3: 0x88}

def pan_model(v, pan_off=0):
    plus17 = (rotl8(v) - 0x80) & 0xFF
    plus2e = (plus17 + pan_off) & 0xFF
    return plus17, plus2e

def nr51_bits(ch, plus2e):
    e = NR51_E[ch]
    b7, b6 = (plus2e >> 7) & 1, (plus2e >> 6) & 1
    if b7 == 0 and b6 == 1:
        e &= 0x0F
    elif b7 == 1 and b6 == 0:
        e &= 0xF0
    return e

def run_pan(work):
    r = S.SynthRom()
    for i, rec in INSTR.items():
        r.instr(i, rec)
    tracks = []
    for ch in range(4):
        t = S.prologue() + S.instrument(ch)
        for v in range(256):
            t += S.cmd(0xC0, v) + S.note(1, 0x40, 0x1F) + S.wait(3)
        t += S.end()
        tracks.append(t)
    r.song(0x28, tracks)
    rom = r.save(os.path.join(work, "pan.gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], 4 + 4 * 256 + 20, q="AS", ev="wt", out=os.path.join(work, "pan.log"))
    ev, _ = E.parse(log)
    return ev

def check_pan(ev):
    stats = collections.Counter()
    bad = []
    # per channel: the sequence of v values: notes start at frame 2 + 4*k (wait 3 + note tick) -> use S events per track
    starts = collections.defaultdict(list)
    for e in ev:
        if e["k"] == "Q" and e["q"] == "S":
            starts[e["track"]].append(e["frame"])
    pans = collections.defaultdict(list)
    for e in ev:
        if e["k"] == "Q" and e["q"] == "A":
            pans[e["track"]].append(e)
    nr51 = 0xFF
    writes = [(e["frame"], e["val"], e["pc"]) for e in ev if e["k"] == "W" and e["addr"] == 0xFF25 and e["frame"] >= 1]
    for trk in range(4, 8):
        ch = trk - 4
        evs = pans[trk]
        stats["pan_calls_ch%d" % ch] = len(evs)
        # the k-th call of this channel belongs to value v = k (the track plays v = 0..255 in order)
        for k, e in enumerate(evs):
            v = k
            if v > 255:
                break
            p17, p2e = pan_model(v)
            t = e["trk"]
            ok17 = t[0x17] == p17
            ok2e = True   # +$2E is computed by ComputeTrackOutput before UpdateChannel: check it too
            ok2e = t[0x2E] == p2e
            stats["f17_ok"] += ok17
            stats["f2e_ok"] += ok2e
            stats["total"] += 1
            if not (ok17 and ok2e) and len(bad) < 8:
                bad.append((ch, v, "+17 %02X exp %02X; +2E %02X exp %02X" % (t[0x17], p17, t[0x2E], p2e)))
    # NR51 writes: the value written by each call = (old & D) | E'
    # replay: iterate writes in order with the call list merged by frame/track
    calls = []
    for trk in range(4, 8):
        for k, e in enumerate(pans[trk]):
            calls.append((e["frame"], trk, k, e))
    calls.sort(key=lambda x: (x[0], x[1]))
    # map each FF25 write at pc 4F95 (WriteChannelPan) to the call at the same frame in order
    pan_writes = [w for w in writes if 0x4F4F <= w[2] <= 0x4F9A]
    stats["nr51_writes"] = len(pan_writes)
    cur = 0xFF
    # initial value written by Sound_Init is $FF
    for (f, trk, k, e), (wf, val, pc) in zip(calls, pan_writes):
        ch = trk - 4
        p17, p2e = pan_model(k)
        exp = (cur & NR51_D[ch]) | nr51_bits(ch, p2e)
        cur = val
        stats["nr51_total"] += 1
        if val == exp and wf == f:
            stats["nr51_ok"] += 1
        elif len(bad) < 16:
            bad.append((ch, k, "NR51 written %02X expected %02X (frames %d/%d)" % (val, exp, wf, f)))
    print("pan:", dict(stats))
    for b in bad: print("  BAD", b)
    # table of the mapping observed for the value ranges
    seen = collections.defaultdict(set)
    for (f, trk, k, e), (wf, val, pc) in zip(calls, pan_writes):
        ch = trk - 4
        seen[(ch, (rotl8(k) - 0x80) & 0xC0)].add(val & NR51_E[ch])
    print("  bits 7/6 of +$2E (00 both, 01 right, 10 left, 11 both) -> channel bits written (pulse1 mask $11): ",
          {("ch%d" % c, "%02X" % b): sorted("%02X" % x for x in s) for (c, b), s in sorted(seen.items()) if c == 0})

def run_detune(work):
    r = S.SynthRom()
    r.instr(1, INSTR[1])
    t = S.prologue() + S.instrument(1)
    for v in range(256):
        t += S.cmd(0xC9, v) + S.note(1, 0x40, 0x1F) + S.wait(3)
    t += S.end()
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "detune.gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], 4 + 4 * 256 + 20, q="PS", ev="wt", out=os.path.join(work, "detune.log"))
    return E.parse(log)[0]

def check_detune(ev):
    stats = collections.Counter(); bad = []
    table = E.note_table()
    ps = {}
    for e in ev:
        if e["k"] == "Q" and e["q"] == "P":
            ps.setdefault(e["frame"], e)
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    for v, st in enumerate(starts):
        p = ps.get(st["frame"])
        if not p: stats["noP"] += 1; continue
        t = p["trk"]
        d = (rotl8(v) - 0x80) & 0xFF
        sd = d - 256 if d & 0x80 else d
        exp = (2 * sd) & 0xFFFF
        got = t[0x2C] | t[0x2D] << 8
        stats["total"] += 1
        stats["+1D_ok"] += (t[0x1D] == d)
        stats["+2C_ok"] += (got == exp)
        if v <= 0x7F: stats["v<=7F_total"] += 1; stats["v<=7F_(+2C == (v-$40)*4)"] += (got == ((v - 0x40) * 4) & 0xFFFF)
        if got != exp and len(bad) < 6: bad.append((v, "+1D %02X exp %02X; +2C/2D %04X exp %04X" % (t[0x1D], d, got, exp)))
    print("detune:", dict(stats))
    for b in bad: print("  BAD", b)

def run_ca(work):
    r = S.SynthRom()
    r.instr(1, INSTR[1])
    t = S.prologue() + S.instrument(1) + S.note(0, 0x40, 0x1F)       # held note
    for v in range(256):
        t += S.cmd(0xCA, v) + S.wait(2)
    t += S.cmd(0xCF) + S.wait(2) + S.end()
    r.song(0x28, [t])
    rom = r.save(os.path.join(work, "ca.gbc"))
    watch = ",".join("%04X" % (0xD040 + k * 0x3C + 0x1E) for k in range(8))
    log = S.run(rom, ["0:init", "2:music:28"], 4 + 3 * 256 + 20, q="P", ev="wct", snap=True, rwatch=watch, out=os.path.join(work, "ca.log"))
    return E.parse(log)[0]

def check_ca(ev):
    reads = [e for e in ev if e["k"] == "R"]
    ps = [e for e in ev if e["k"] == "Q" and e["q"] == "P"]
    snaps = {e["frame"]: e for e in ev if e["k"] == "F"}
    vals = {}
    for f, s in snaps.items():
        vals[f] = s["trk"][4 * 0x3C + 0x1E]
    seen = sorted(set(vals.values()))
    print("$CA: values of +$1E seen in the end-of-frame snapshots:", len(seen), "(256 expected incl. 0);  CPU reads of +$1E (all 8 tracks, WRAM bank 1):", len(reads))
    periods = collections.Counter()
    for e in ps:
        t = e["trk"]
        periods[t[0x2C] | t[0x2D] << 8] += 1
    print("   WriteChannelPitch calls during the run:", len(ps), " distinct +$2C/$2D values in them:", dict(periods), " (a call per `$CA` = the pitch flag, same value)")
    # frames with a P call vs frames of $CA commands
    cmd_frames = sorted({e["frame"] for e in ev if e["k"] == "C" and e["op"] == 0xCA})
    pframes = {e["frame"] for e in ps}
    print("   `$CA` executed in %d frames; WriteChannelPitch called in %d of them" % (len(cmd_frames), len(pframes & set(cmd_frames))))

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_v13a"
    os.makedirs(work, exist_ok=True)
    check_pan(run_pan(work))
    check_detune(run_detune(work))
    check_ca(run_ca(work))

if __name__ == "__main__":
    main()
