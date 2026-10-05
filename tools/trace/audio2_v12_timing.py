#!/usr/bin/env python3
"""V1.2 (timing): (1) tempo: ticks per frame vs the claimed accumulator model (step = tempo*scale/64 added to a 16-bit accumulator per frame, one tick per $4A in it);
(2) gate: a note of duration d ticks is released exactly d ticks after it started (G event = NoteGateExpired), d = 0 never.
usage: audio2_v12_timing.py LOGDIR"""
import sys, os, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_ev as E

def chan_of(b0):
    return 0 if b0 < 0x08 else 1 if b0 < 0x10 else 2 if b0 < 0x40 else 3

def main():
    stats = collections.Counter()
    bad = []
    tempos = collections.Counter()
    for path in sorted(glob.glob(os.path.join(sys.argv[1], "song_*.log"))):
        ev, _ = E.parse(path)
        sid = int(os.path.basename(path)[5:7], 16)
        music = sid <= 0x28
        # ---- (1) tempo
        step = 0x4A
        acc = 0
        pending_step = None
        frames = [e for e in ev if e["k"] == "T"]
        by_frame_bc = collections.defaultdict(list)
        for e in ev:
            if e["k"] == "C" and e["op"] == 0xBC:
                by_frame_bc[e["frame"]].append(e["b1"])
        prev_t = 0
        ok_t = bad_t = 0
        key = "tM" if music else "tS"
        for e in frames:
            f = e["frame"]
            # accumulate at the start of this frame's tick with the step in force
            acc += step
            n = 0
            while acc >= 0x4A:
                acc -= 0x4A
                n += 1
            # observed ticks this frame: T line is written before the frame's tick is run?  (T of frame f is logged AFTER the tick of frame f)
            obs = e[key] - prev_t
            prev_t = e[key]
            if obs == n:
                ok_t += 1
            else:
                bad_t += 1
                if len(bad) < 8:
                    bad.append((os.path.basename(path), f, "ticks %d, model %d (step %02X acc %d)" % (obs, n, step, acc)))
            for v in by_frame_bc.get(f, []):
                step = max(1, (v * 0x40 * 4) >> 8) if (v * 0x40) < 0x4000 else 0x3F
                tempos[v] += 1
        stats["tempo_frames_ok"] += ok_t
        stats["tempo_frames_bad"] += bad_t
        # ---- (2) gates
        pend = {}
        last_cf = None
        for e in ev:
            k = e["k"]
            if k == "Q" and e["q"] == "S":
                trk = e["trk"]
                ch = chan_of(trk[0x0C])     # instrument class AFTER the per-note instrument copy (hook 04:4ABE)
                d = trk[0x0B]
                grp = "tM" if e["track"] >= 4 else "tS"
                if ch in pend and pend[ch] is not None:
                    pass  # earlier note preempted (no G expected)
                pend[ch] = (e[grp], d, grp, e["frame"], e["track"])
                stats["notes"] += 1
            elif k == "C" and e["op"] == 0xCF:
                last_cf = (e["frame"], e["tM"], e["tS"])
            elif k == "G":
                ch = e["chan"]
                p = pend.get(ch)
                if last_cf and (e["frame"], e["tM"], e["tS"]) == last_cf:
                    stats["g_from_note_off"] += 1
                    pend[ch] = None
                    continue
                if p is None:
                    stats["g_without_note"] += 1
                    continue
                t0, d, grp, f0, trk = p
                dt = e[grp] - t0
                if d == 0:
                    stats["g_for_duration0"] += 1
                elif dt == d:
                    stats["gate_ok"] += 1
                else:
                    stats["gate_bad"] += 1
                    if len(bad) < 16:
                        bad.append((os.path.basename(path), e["frame"], "channel %d note started tick %d (frame %d) duration %d, G after %d ticks" % (ch, t0, f0, d, dt)))
                pend[ch] = None
    print(dict(stats))
    print("tempo values that occurred:", sorted(tempos))
    for b in bad:
        print("BAD", b)

if __name__ == "__main__":
    main()
