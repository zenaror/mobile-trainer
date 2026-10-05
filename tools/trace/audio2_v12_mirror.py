#!/usr/bin/env python3
"""V1.2 (software mirror vs the emulator's hardware envelope): per frame, the driver's mirror (channel +$11 high nibble, from the end-of-frame snapshot)
against mGBA's internal envelope volume of the same channel (A event).  Uses a subset of the envelope sweep.  usage: audio2_v12_mirror.py [workdir]"""
import sys, os, collections, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E
import audio2_v12_env_sweep as W   # builds the same ROMs

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_mirror"
    os.makedirs(work, exist_ok=True)
    allc = W.combos_ext(n=300, seed=777)
    chunk = [c for c in allc if c["gate"] >= 9][:36]
    rom = W.build(chunk, os.path.join(work, "mirror.gbc"))
    frames = 4 + W.NOTE_SPACING * len(chunk) + 10
    log = S.run(rom, ["0:init", "2:music:28"], frames, q="S", ev="wgt", apu=True, snap=True, out=os.path.join(work, "mirror.log"))
    ev, _ = E.parse(log)
    starts = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    snaps = {e["frame"]: e for e in ev if e["k"] == "F"}
    apu = S.parse_apu(log)
    # per note: mirror level from the snapshot of channel 1 (+$11 >> 4) vs hw volume (ch2.currentVolume), frames until the next note
    dev = collections.Counter()
    worst = []
    per_state = collections.defaultdict(collections.Counter)
    for i, s in enumerate(starts):
        fs = s["frame"]
        fn = starts[i + 1]["frame"] if i + 1 < len(starts) else fs + W.NOTE_SPACING
        for f in range(fs, fn):
            if f not in snaps or f not in apu:
                continue
            ch = snaps[f]["ch"][0x18:0x30]     # channel record 1
            state = (ch[0] >> 4) & 3
            if not (ch[0] & 0x80):
                continue
            mirror = ch[0x11] >> 4
            hw = apu[f]["ch2"][1]
            d = mirror - hw
            dev[d] += 1
            per_state[state][d] += 1
    print("mirror - hardware volume over", sum(dev.values()), "frames of", len(chunk), "notes:", dict(sorted(dev.items())))
    for st in sorted(per_state):
        print(" channel state %s (11 attack, 10 decay/sustain, 01 release, 00 tail): %s" % (format(st, "02b"), dict(sorted(per_state[st].items()))))

if __name__ == "__main__":
    main()
