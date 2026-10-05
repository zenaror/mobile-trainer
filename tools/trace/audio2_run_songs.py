#!/usr/bin/env python3
"""Run every distinct sound header of the ROM on the real mGBA through tools/trace/apu_probe.c and write one raw event log per header.

usage: audio2_run_songs.py PROBE_BINARY OUT_DIR [--rom ROM] [--jobs N] [--loops K] [--frames N] [--ev wcngejt] [--q LETTERS] [--ids 1,2,..]

The ids are taken from the song table that audio/music_pointers.asm describes (parsed with tools/trace/audio2_macros.py); one id per distinct
(header, bank): the lowest id.  Ids <= $28 are started with Sound_PlayMusic (tracks 4-7), ids >= $29 with Sound_PlaySfx (tracks 0-3), as the ROM's callers do.
"""
import argparse, os, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_macros as M


def distinct_ids(dec):
    seen = {}
    for sid in sorted(dec.songs):
        s = dec.songs[sid]
        key = (s["bank"], s["header"])
        seen.setdefault(key, sid)
    return sorted(seen.values())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("probe")
    ap.add_argument("outdir")
    ap.add_argument("--rom", default=os.path.join(M.ROOT, "Mobile Trainer (Japan).gbc"))
    ap.add_argument("--jobs", type=int, default=12)
    ap.add_argument("--loops", type=int, default=2)
    ap.add_argument("--frames", type=int, default=40000)
    ap.add_argument("--ev", default="wcngejt")
    ap.add_argument("--q", default="")
    ap.add_argument("--ids", default="")
    ap.add_argument("--boot", type=int, default=300)
    ap.add_argument("--romread-dir", default="")
    args = ap.parse_args()
    os.makedirs(args.outdir, exist_ok=True)
    dec = M.Decode()
    ids = [int(x, 16) for x in args.ids.split(",")] if args.ids else distinct_ids(dec)

    def run(sid):
        out = os.path.join(args.outdir, "song_%02X.log" % sid)
        kind = "music" if sid <= 0x28 else "sfx"
        cmd = [args.probe, "--rom", args.rom, "--out", out, "--boot", str(args.boot), "--frames", str(args.frames),
               "--call", "0:init", "--call", "2:%s:%X" % (kind, sid), "--stop-loops", str(args.loops), "--ev", args.ev]
        if args.q:
            cmd += ["--q", args.q]
        if args.romread_dir:
            os.makedirs(args.romread_dir, exist_ok=True)
            cmd += ["--romread", os.path.join(args.romread_dir, "song_%02X.rd" % sid)]
        r = subprocess.run(cmd, capture_output=True, text=True)
        return sid, r.returncode, r.stderr.strip()

    with ThreadPoolExecutor(args.jobs) as ex:
        for sid, rc, err in ex.map(run, ids):
            print("id %02X rc=%d %s" % (sid, rc, err), flush=True)


if __name__ == "__main__":
    main()
