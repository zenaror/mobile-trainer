#!/usr/bin/env python3
"""Control entry points of the driver (the stubs 00:20A0-20E8 and their SoundDrv_* bodies, names of commit b939965): stop by id, stop all, pause, resume, play-or-resume, play-if-not-playing,
get active masks, get playing id.  Observed on mGBA through the track records and the registers returned.  usage: audio2_v13_ctrl.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

BASE = [0x0A, 0, 0, 0xEE, 0xFE, 0x3C]

def rom(work, nm, music_ids=(0x28,), sfx_ids=(0x27, 0x26)):
    r = S.SynthRom(); r.instr(1, BASE)
    for k, sid in enumerate(music_ids):
        r.song(sid, [S.prologue() + S.instrument(1) + S.note(0, 0x45 + k, 0x1F) + S.wait(96) + S.wait(96) + S.end(), S.prologue() + S.instrument(1) + S.note(0, 0x49 + k, 0x1F) + S.wait(96) + S.wait(96) + S.end()])
    for k, sid in enumerate(sfx_ids):
        r.song(sid, [S.prologue() + S.instrument(1) + S.note(0, 0x55 + k, 0x1F) + S.wait(96) + S.wait(96) + S.end()])
    return r.save(os.path.join(work, nm + ".gbc"))

def act(ev, frame):
    s = {e["frame"]: e for e in ev if e["k"] == "F"}[frame]
    return [i for i in range(8) if s["trk"][i * 0x3C] & 0x80], s

def run(rom_path, calls, frames, work, name):
    log = S.run(rom_path, calls, frames, ev="tx", snap=True, out=os.path.join(work, name + ".log"))
    return E.parse(log)[0] if False else parse_x(log)

def parse_x(log):
    ev, _ = E.parse(log)
    xs = []
    for ln in open(log):
        if ln.startswith("X "):
            p = ln.split(); xs.append((int(p[1]), int(p[2], 16), int(p[3], 16), int(p[4], 16), int(p[5], 16), int(p[6], 16)))
    return ev, xs

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_ctrl"
    os.makedirs(work, exist_ok=True)
    rp = rom(work, "ctrl")
    # music + two sfx
    ev, xs = run(rp, ["0:init", "2:music:28", "2:sfx:27", "2:sfx:26", "10:stopsfx:27"], 16, work, "c1")
    print("StopSfxById(id $27): before %s after %s  (sfx $27 was track 0, sfx $26 track 1; music $28 on tracks 4, 5)" % (act(ev, 8)[0], act(ev, 14)[0]))
    ev, xs = run(rp, ["0:init", "2:music:28", "2:sfx:27", "2:sfx:26", "10:sfx:0"], 16, work, "c2")
    print("Sound_PlaySfx(0) = StopAllSfx: before %s after %s" % (act(ev, 8)[0], act(ev, 14)[0]))
    ev, xs = run(rp, ["0:init", "2:music:28", "2:sfx:27", "10:pause"], 20, work, "c3")
    a_before, s0 = act(ev, 8); a_after, s1 = act(ev, 14)
    ptr = lambda s, i: s["trk"][i * 0x3C + 2] | s["trk"][i * 0x3C + 3] << 8
    print("Sound_PauseMusic: before %s after %s; music track 4 stream pointer %04X -> %04X (kept) ; flags %02X -> %02X" % (a_before, a_after, ptr(s0, 4), ptr(s1, 4), s0["trk"][4 * 0x3C], s1["trk"][4 * 0x3C]))
    ev, xs = run(rp, ["0:init", "2:music:28", "10:pause", "16:resume"], 24, work, "c4")
    print("Sound_PauseMusic then Sound_ResumeMusic: frame 8 %s, frame 13 %s, frame 20 %s" % (act(ev, 8)[0], act(ev, 13)[0], act(ev, 20)[0]))
    ev, xs = run(rp, ["0:init", "2:music:28", "10:music:0"], 20, work, "c5")
    print("Sound_PlayMusic(0) (= PauseMusic): frame 8 %s, frame 14 %s" % (act(ev, 8)[0], act(ev, 14)[0]))
    # play-or-resume: same id when paused -> resume (stream continues, same pitch); different id -> restarts
    ev, xs = run(rp, ["0:init", "2:music:28", "10:pause", "16:musicresume:28"], 24, work, "c6")
    a, s = act(ev, 20)
    print("PlayMusicOrResume($28) after pause: active %s, stream pointer of track 4 %04X (a restart would give 4003 or so)" % (a, ptr(s, 4)))
    ev, xs = run(rp, ["0:init", "2:music:28", "10:musicresume:28"], 16, work, "c7")
    a, s7 = act(ev, 14); a8, s8 = act(ev, 8)
    print("PlayMusicOrResume($28) while playing: stream pointer track 4 %04X (frame 8) -> %04X (frame 14): unchanged = not restarted" % (ptr(s8, 4), ptr(s7, 4)))
    ev, xs = run(rp, ["0:init", "2:music:28", "10:musicifnot:28", "12:musicifnot:1"], 20, work, "c8")
    a8, s8 = act(ev, 8); a11, s11 = act(ev, 11); a14, s14 = act(ev, 14)
    print("PlayMusicIfNotPlaying($28) while playing: track 4 pointer %04X -> %04X (unchanged); then ($01) different id: active tracks %s (song 1 has 4 tracks)" % (ptr(s8, 4), ptr(s11, 4), a14))
    # masks and playing id
    ev, xs = run(rp, ["0:init", "2:music:28", "2:sfx:27", "2:sfx:26", "8:mask", "9:playing:A=0", "10:playing:A=1", "11:playing:A=2", "12:playing:A=3", "13:playing:A=5"], 16, work, "c9")
    for x in xs:
        print("   stub %04X at frame %d returned A=%02X BC=%04X DE=%04X" % (x[1], x[0], x[2], x[3], x[4]))
    print("   (Sound_GetActiveMasks 00:20D0 -> D = sfx mask, E = music mask; Sound_GetPlayingId 00:20E2 with A = 0 music / 1-4 sfx track -> BC = song id)")

if __name__ == "__main__":
    main()
