#!/usr/bin/env python3
"""A model of the envelope part of SoundDrv_UpdateChannel (04:4C14-4DCD) for ONE pulse/noise channel, written from my own reading of engine.asm
(not from tools/audio_driver_check.py).  It predicts the NRx2 values that the driver writes and the frames in which it writes them, given

    b3, b4         instrument bytes 3 and 4 (channel +$0B, +$0C)
    nv             note volume byte (channel +6 = (v<<3)|7)
    trkout         the track's volume output (+$2F, a multiple of $40 or $FF)
    fs             frame in which StartNote ran (the first UpdateChannel of the note is in the same frame)
    fg             frame in which NoteGateExpired was called (observed G event), or None
    tail           (plus27, plus28) note-end fields or (0, 0)

The doc's section 7 is used for the comparison of the *formulas* (a, d, S, r, T), this model for the *timing* (counter steps).
"""


def hi(x):
    return (x >> 4) & 0xF


def ceil16(x):
    return (x + 15) >> 4


def codes(b3, b4):
    a = (~b3 >> 5) & 7
    d = (~b3 >> 1) & 7
    sc = (b4 >> 4) & 0xF
    r = (~b4 >> 1) & 7
    return a, d, sc, r


def target(trkout, nv):
    # ComputeTargetVolume: MulNibbles(hi(trkout) * hi(nv)), add $0F, and $F0  -> level nibble
    p = hi(trkout) * hi(nv)
    return ceil16(p)


def sustain(trkout, b4, nv):
    # ComputeSustainVolume: MulNibbles(hi(b4) * hi(nv)) + $0F -> hi nibble, then MulNibbles(hi(trkout) * that) + $0F and $F0
    p1 = hi(b4) * hi(nv)
    c = (p1 + 15) & 0xFF
    p2 = hi(trkout) * hi(c)
    return ceil16(p2)


def simulate(b3, b4, nv, trkout, fs, fg, frames, tail=(0, 0), phase0=0):
    """Returns the list of (frame, value, kind) NRx2 writes (kind: 'attack','decay','sustain','release','cut','tail') up to `frames` frames after fs.
    The double counter increment happens in frames k with (k + phase0) % 15 == 0 (phase0 = 0 for frame 0 = the first tick after Sound_Init)."""
    a, d, sc, r = codes(b3, b4)
    T = target(trkout, nv)
    S = sustain(trkout, b4, nv)
    out = []
    state = 3          # bits 5-4
    pending = True
    M = 0
    C = 0
    gate_pending = False
    alive = True
    gate_done = False
    for k in range(fs, fs + frames):
        if not alive:
            break
        # tick phase: gate expiry (observed)
        if fg is not None and k == fg and not gate_done:
            gate_done = True
            if pending:
                # NoteGateExpired with the pending bit set -> StopChannel
                out.append((k, 0x08, "cut"))
                alive = False
                break
            state = 1
            pending = True
            gate_release = True
        else:
            gate_release = False
        # UpdateChannel
        if pending:
            pending = False
            if state >= 2:          # note start (state 11)
                if a != 0:
                    M = 0x08 | a
                    C = 0
                    out.append((k, M, "attack"))
                    state = 3
                else:
                    state, M, C, w = decay_setup(T, S, d, b4, trkout, tail)
                    if w is None:
                        out.append((k, 0x08, "cut"))
                        alive = False
                    else:
                        out.append((k, w[0], w[1]))
            else:                   # release start
                L = M & 0xF0
                rr = r
                if L == 0 or rr == 0:
                    t = tail_path(trkout, tail, S, T)
                    if t is None:
                        out.append((k, 0x08, "cut"))
                        alive = False
                    else:
                        out.append((k, t[0], "tail"))
                        state = 0
                        M = t[0]
                        C = t[1]
                else:
                    M = L | rr
                    C = 0
                    out.append((k, M, "release"))
                    state = 1
            continue
        # counter increment (+1, +1 more every 15th frame)
        C = (C + 1 + (1 if (k + phase0) % 15 == 0 else 0)) & 0xFF
        if state == 3:
            p = M & 7
            if not ((p - 1) & 0xFF) >= C:
                C = 0
                vol = (M >> 4) + 1
                if vol > 15:
                    # carry -> decay setup
                    state, M, C, w = decay_setup(T, S, d, b4, trkout, tail)
                    if w is None:
                        out.append((k, 0x08, "cut")); alive = False
                    else:
                        out.append((k, w[0], w[1]))
                    continue
                M = (vol << 4) | (M & 0x0F)
            if M >= (T << 4) and not ((M & 0xFF) < (T << 4)):
                state, M, C, w = decay_setup(T, S, d, b4, trkout, tail)
                if w is None:
                    out.append((k, 0x08, "cut")); alive = False
                else:
                    out.append((k, w[0], w[1]))
        elif state == 2:
            p = M & 7
            if p == 0:
                continue
            if not ((p - 1) & 0xFF) >= C:
                C = 0
                if (M >> 4) == 0:
                    # underflow -> sustain reached with level 0
                    if (b4 & 0xF0) == 0:
                        t = tail_path(trkout, tail, S, T)
                        if t is None:
                            out.append((k, 0x08, "cut")); alive = False
                        else:
                            out.append((k, t[0], "tail")); state = 0; M = t[0]; C = t[1]
                    else:
                        M = S << 4
                        out.append((k, M, "sustain"))
                    continue
                M = M - 0x10
            if not ((S << 4 | 0x0F) < M):
                if (b4 & 0xF0) == 0:
                    t = tail_path(trkout, tail, S, T)
                    if t is None:
                        out.append((k, 0x08, "cut")); alive = False
                    else:
                        out.append((k, t[0], "tail")); state = 0; M = t[0]; C = t[1]
                else:
                    M = S << 4
                    out.append((k, M, "sustain"))
        elif state == 1:
            p = M & 7
            if not ((p - 1) & 0xFF) >= C:
                C = 0
                if (M >> 4) == 0:
                    t = tail_path(trkout, tail, S, T)
                    if t is None:
                        out.append((k, 0x08, "cut")); alive = False
                    else:
                        out.append((k, t[0], "tail")); state = 0; M = t[0]; C = t[1]
                    continue
                M = M - 0x10
        elif state == 0:
            C = (C - 1) & 0xFF
            if C == 0:
                out.append((k, 0x08, "cut")); alive = False
    return out


def tail_path(trkout, tail, S, T):
    p27, p28 = tail
    if trkout == 0 or p27 == 0 or p28 == 0:
        return None
    lvl = ceil16(hi(trkout) * hi(p27))
    return (lvl << 4, p28)


def decay_setup(T, S, d, b4, trkout, tail):
    """returns (state, M, C, (write value, kind) or None for 'channel ends')"""
    if d != 0:
        M = (T << 4) | d
        return 2, M, 0, (M, "decay")
    if (b4 & 0xF0) == 0:
        t = tail_path(trkout, tail, S, T)
        if t is None:
            return 0, 0, 0, None
        return 0, t[0], t[1], (t[0], "tail")
    M = S << 4
    return 2, M, 0, (M, "sustain")
