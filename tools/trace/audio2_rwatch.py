#!/usr/bin/env python3
"""Read watch over all 59 real runs: CPU data reads of +$1E, +$30, +$31 of the 8 track records (WRAM bank 1).  usage: audio2_rwatch.py PROBE OUTDIR [ROM]"""
import sys, os, subprocess, glob, collections
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_macros as M, audio2_run_songs as R, audio2_ev as E

def main():
    probe, out = sys.argv[1], sys.argv[2]
    rom = sys.argv[3] if len(sys.argv) > 3 else E.ROM_PATH
    os.makedirs(out, exist_ok=True)
    dec = M.Decode(); ids = R.distinct_ids(dec)
    watch = ",".join("%04X" % (0xD040 + k * 0x3C + off) for k in range(8) for off in (0x1E, 0x30, 0x31))
    def run(sid):
        kind = "music" if sid <= 0x28 else "sfx"
        cmd = [probe, "--rom", rom, "--out", os.path.join(out, "song_%02X.log" % sid), "--boot", "300", "--frames", "40000", "--call", "0:init", "--call", "2:%s:%X" % (kind, sid), "--stop-loops", "2", "--ev", "c", "--rwatch", watch]
        return subprocess.run(cmd, capture_output=True, text=True).returncode
    with ThreadPoolExecutor(12) as ex: rcs = list(ex.map(run, ids))
    cnt = collections.Counter()
    for f in glob.glob(os.path.join(out, "song_*.log")):
        for ln in open(f):
            if ln.startswith("R "): cnt[ln.split()[3]] += 1
    print("reads of +$1E / +$30 / +$31 (all 8 tracks) over %d real runs: %s (return codes ok: %s)" % (len(ids), dict(cnt) or "none", all(r == 0 for r in rcs)))

if __name__ == "__main__":
    main()
