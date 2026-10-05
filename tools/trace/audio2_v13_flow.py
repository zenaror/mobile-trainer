#!/usr/bin/env python3
"""V1.3 synthetic: flow and note-byte constructs the data does not use (doc 4.1-4.3).
 F1 `$B5` counted loop (count 0, 1, 2, 3, 5)         F2 call depth 1-7 (limit 5: the sixth nested call ends the track)       F3 `$B4` on an empty stack
 F4 the ten opcodes without handler end the track    F5 `$80` (wait 0) is a no-op                                            F6 running status after `$BC`/`$BD`/waits keeps the last opcode >= $BE
 F7 note bytes: adjust ($20-$23), any order, duplicate class ends the note and re-triggers by running status, `$CE` held note
 F8 `$CF` note-off: same pitch / bare / other pitch / with pitch add / on a note with a gate / second `$CF`
usage: audio2_v13_flow.py [workdir]"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audio2_synth as S, audio2_ev as E

BASE = [0x0A, 0, 0, 0xEC, 0xFA, 0x3C]

def build(work, name, track, extra_tracks=(), frames=60, q="S", ev="cgtw", snap=False, rwatch=None):
    r = S.SynthRom()
    r.instr(1, BASE)
    r.song(0x28, [track] + list(extra_tracks))
    rom = r.save(os.path.join(work, name + ".gbc"))
    log = S.run(rom, ["0:init", "2:music:28"], frames, q=q, ev=ev, snap=snap, rwatch=rwatch, out=os.path.join(work, name + ".log"))
    return E.parse(log)[0]

def cevents(ev, track=4):
    return [e for e in ev if e["k"] == "C" and e["track"] == track]

def org(r_org=0x4000):
    return r_org

def f1_loop(work):
    out = []
    for n in (0, 1, 2, 3, 5):
        base = 0x4000
        # layout: prologue(3+... ) computed by building bytes in order and fixing the loop address
        pre = S.prologue() + S.instrument(1)
        loop_addr = base + len(pre)
        body = S.note(1, 0x40, 0x1F) + S.wait(2)
        t = pre + body + S.loop(n, loop_addr) + S.note(1, 0x50, 0x1F) + S.wait(2) + S.end()
        ev = build(work, "loop%d" % n, t, frames=80)
        c = cevents(ev)
        body_runs = sum(1 for e in c if e["de"] == loop_addr)
        after = sum(1 for e in c if e["op"] in range(0xCF, 0x100) and e["b1"] == 0x50)
        ended = any(e["op"] == 0xB1 for e in c)
        out.append((n, body_runs, after, ended))
    print("F1 `$B5 count Label`: (count, body executions, executions of the note after the loop, reached $B1):", out)
    print("   doc: count 0 always jumps; count n = n passes then falls through.  observed passes:", {n: b for n, b, a, e in out})

def f2_depth(work):
    # a chain f1 -> f2 -> ... -> fk, each does note+wait then calls the next; after the deepest returns, everything returns
    res = {}
    for depth in range(1, 8):
        base = 0x4000
        pre = S.prologue() + S.instrument(1)
        # functions laid out after main; compute addresses
        main_len = len(pre) + 3 + len(S.note(1, 0x60, 0x1F) + S.wait(2)) + 1
        funcs = []
        addr = base + main_len
        sizes = []
        for k in range(depth):
            # f_k: note(pitch 0x40+k), wait(2), [call f_{k+1}], ret
            sz = len(S.note(1, 0x40 + k, 0x1F)) + len(S.wait(2)) + (3 if k < depth - 1 else 0) + 1
            sizes.append(sz)
        starts = []
        a = addr
        for sz in sizes:
            starts.append(a); a += sz
        main = pre + S.call(starts[0]) + S.note(1, 0x60, 0x1F) + S.wait(2) + S.end()
        assert len(main) == main_len
        body = b""
        for k in range(depth):
            body += S.note(1, 0x40 + k, 0x1F) + S.wait(2)
            if k < depth - 1:
                body += S.call(starts[k + 1])
            body += S.ret()
        t = main + body
        ev = build(work, "depth%d" % depth, t, frames=60)
        c = cevents(ev)
        notes_seen = [e["b1"] for e in c if e["op"] >= 0xCF and e["op"] <= 0xFF]
        ended_by_b1 = any(e["op"] == 0xB1 for e in c)
        reached_back = any(e["op"] >= 0xCF and e["b1"] == 0x60 for e in c)
        res[depth] = (len([x for x in notes_seen if 0x40 <= x < 0x48]), reached_back, ended_by_b1)
    print("F2 nested calls to depth d: (notes of the called functions played, main continues after the first call returned, reached the final $B1):")
    for d, v in res.items():
        print("   depth %d: %s" % (d, v))

def f3_to_f6(work):
    # F3: ret on empty stack
    t = S.prologue() + S.instrument(1) + S.ret() + S.note(1, 0x40, 0x1F) + S.wait(2) + S.end()
    c = cevents(build(work, "ret_empty", t, frames=20))
    print("F3 `$B4` on an empty stack: decoded", [("%02X" % e["op"]) for e in c], "-> the next command (the note) was decoded:", any(e["op"] >= 0xCF for e in c))
    # F4: opcodes without handler
    res = {}
    for op in (0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xC7, 0xC8, 0xCB, 0xCC):
        t = S.prologue() + S.instrument(1) + S.wait(2) + bytes([op]) + S.note(1, 0x40, 0x1F) + S.wait(2) + S.end()
        ev = build(work, "op%02X" % op, t, frames=20, snap=True)
        c = cevents(ev)
        after = [e["trk"][4 * 0x3C] >> 7 for e in ev if e["k"] == "F" and e["frame"] > c[-1]["frame"]]
        res[op] = ("%02X" % c[-1]["op"], len(c), after[:1])
    print("F4 opcodes without handler: (last decoded opcode, number of commands, track-active flag after):", {("%02X" % k): v for k, v in res.items()})
    # control: handled opcodes next to them continue (BC, BD)
    # F5: $80
    t = S.prologue() + S.instrument(1) + bytes([0x80]) + S.note(1, 0x40, 0x1F) + S.wait(2) + S.end()
    ev = build(work, "wait0", t, frames=20)
    c = cevents(ev)
    d = [(e["op"], e["tM"]) for e in c]
    print("F5 `$80`: commands (opcode, tM):", [("%02X" % o, t_) for o, t_ in d], " -> same tick as the next command:", len(d) >= 5 and d[3][1] == d[4][1])
    # F6: running status after $BC / $BD / wait
    t = S.prologue() + S.instrument(1) + S.note(3, 0x40, 0x1F) + S.tempo(0x4A) + bytes([0x45]) + S.pitch_add(0) + bytes([0x47]) + S.wait(2) + bytes([0x49]) + S.wait(2) + S.end()
    ev = build(work, "rs_bc", t, frames=30, q="S")
    ss = [(e["trk"][9], e["trk"][0x0B]) for e in ev if e["k"] == "Q" and e["q"] == "S"]
    print("F6 running status after `$BC` / `$BD` / a wait (notes: pitch, duration):", [("%02X" % p, d) for p, d in ss], " expected pitches 40 45 47 49 with duration 3 each")

def f7_notebytes(work):
    cases = {}
    t = S.prologue() + S.instrument(1)
    plan = []
    # (a) adjust byte $22 after pitch
    t += S.note(4, 0x40, None, order="pva", adjust=0x22) + S.wait(8); plan.append("adjust $22 after pitch (duration 4 + 2 = 6 expected)")
    t += S.note(4, 0x48, 0x0C, order="pva", adjust=0x23) + S.wait(8); plan.append("pitch, volume, adjust $23 (4 + 3 = 7 expected)")
    t += S.note(4, 0x49, None, order="pva", adjust=0x20) + S.wait(8); plan.append("adjust $20 (+0)")
    # (b) volume before pitch
    t += S.note(4, 0x41, 0x1A, order="vp") + S.wait(8); plan.append("volume then pitch")
    # (c) adjust, volume, pitch
    t += S.note(4, 0x42, 0x0B, order="avp", adjust=0x21) + S.wait(8); plan.append("adjust $21, volume $0B, pitch")
    # (d) duplicate pitch: second pitch byte ends the note and re-triggers by running status
    t += S.note(4, 0x43) + bytes([0x44]) + S.wait(8); plan.append("pitch $43 then pitch $44 (duplicate class)")
    # (e) duplicate volume
    t += S.note(4, 0x45, 0x10) + bytes([0x11]) + S.wait(8); plan.append("pitch $45, volume $10, volume $11")
    # (f) $CE held note
    t += S.cmd(0xCE, 0x46, 0x1F) + S.wait(8); plan.append("$CE held note pitch $46")
    t += S.cmd(0xCF, 0x46) + S.wait(4); plan.append("$CF $46 releases it")
    # (g) note with no bytes (pitch of the last note, volume of the last note)
    t += S.note(2) + S.wait(8); plan.append("note without bytes")
    t += S.end()
    ev = build(work, "notebytes", t, frames=120, q="S", ev="cgtw")
    ss = [e for e in ev if e["k"] == "Q" and e["q"] == "S"]
    gates = [e for e in ev if e["k"] == "G"]
    print("F7 note bytes (S event = note start: pitch, note volume byte, duration, frame):")
    for s in ss:
        t_ = s["trk"]
        g = next((g["frame"] for g in gates if g["frame"] > s["frame"] and g["chan"] == 1), None)
        print("   frame %3d: pitch %02X vol %02X dur %2d  (gate expired at +%s)" % (s["frame"], t_[9], t_[0xA], t_[0xB], None if g is None else g - s["frame"]))
    print("   plan:", plan)

def f8_noteoff(work):
    def case(name, body, frames=60):
        t = S.prologue() + S.instrument(1) + body + S.end()
        ev = build(work, name, t, frames=frames, q="S", ev="cgtw")
        gs = [(g["frame"], g["chan"]) for g in ev if g["k"] == "G"]
        ss = [(e["frame"], e["trk"][9]) for e in ev if e["k"] == "Q" and e["q"] == "S"]
        cf = [(e["frame"], e["b1"]) for e in ev if e["k"] == "C" and e["op"] == 0xCF]
        print("F8 %-34s note starts %s  $CF at %s  gate events %s" % (name, ss, cf, gs))
    case("held, $CF same pitch", S.cmd(0xCE, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF, 0x46) + S.wait(6))
    case("held, bare $CF", S.cmd(0xCE, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF) + S.wait(6))
    case("held, $CF other pitch", S.cmd(0xCE, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF, 0x47) + S.wait(6))
    case("gate 24, $CF same pitch at 6", S.note(24, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF, 0x46) + S.wait(30))
    case("pitch add 12, held, $CF 0x46", S.pitch_add(12) + S.cmd(0xCE, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF, 0x46) + S.wait(6) + S.cmd(0xCF, 0x52) + S.wait(6))
    case("held, $CF twice", S.cmd(0xCE, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF, 0x46) + S.wait(3) + S.cmd(0xCF, 0x46) + S.wait(6))
    case("add 12, held $46, $CF $52", S.pitch_add(12) + S.cmd(0xCE, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF, 0x52) + S.wait(6) + S.cmd(0xCF, 0x46) + S.wait(6))
    # a data byte < $24 after $CF is not consumed as a pitch and re-dispatches $CF by running status: the driver cannot leave the track step
    try:
        t = S.prologue() + S.instrument(1) + S.cmd(0xCE, 0x46, 0x1F) + S.wait(6) + S.cmd(0xCF, 0x10) + S.wait(6) + S.end()
        build(work, "cf_lt24", t, frames=30)
        print("F8 `$CF $10`: the driver returned (no hang)")
    except RuntimeError as e:
        print("F8 `$CF` followed by a byte < $24 (here $10): HANG - the frame tick never returns:", str(e).strip().splitlines()[-1])

def main():
    work = sys.argv[1] if len(sys.argv) > 1 else "synth_v13flow"
    os.makedirs(work, exist_ok=True)
    f1_loop(work); f2_depth(work); f3_to_f6(work); f7_notebytes(work); f8_noteoff(work)

if __name__ == "__main__":
    main()
