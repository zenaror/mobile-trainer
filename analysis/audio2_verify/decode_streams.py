#!/usr/bin/env python3
"""Independent decoder of the sound streams of Mobile Trainer (banks 04 and 05), written from the driver code
(audio/engine.asm: SoundDrv_LoadSongHeader 04:430A, SoundDrv_StartTrack 04:434C, SoundDrv_InitTrackRuntime 04:4386,
SoundDrv_ReadNextCommand 04:459B, Table_SoundDrv_Commands 04:46E8, SoundDrv_CmdExtended 04:473E, SoundDrv_CmdCall/Jump/Return/Repeat
04:4777-47E3, SoundDrv_ReadNoteBytes 04:4A36, SoundDrv_CmdNoteOff 04:4B66) and NOT from tools/audio_to_macros.py.

What the code does (re-derived by reading, see docs/research/audio2_verify_static.md):
  * song record of id n (1..$46): 8 bytes at 04:$5515 + 8n: dw header, dw bank (9 bit), db priority, db flags, db track count, db spare (never read)
  * header: [2 bytes skipped by the driver], then one word per track (the stream start), read from HeaderPtr = header + 2 + 2k
  * command byte c = [pc]; if bit 7 set: opcode = c, argument byte prefetched = [pc+1], and an opcode >= $BE is stored as the running status;
    if bit 7 clear: opcode = running status (initially 0), the byte is the first argument (not consumed yet).
  * dispatch: opcode >= $D0 note; opcode < $B1 wait ($80: no-op); else table index opcode - $B1.
Usage: python3 decode_streams.py          (A2V_ROOT=DIR to point at another tree, A2V_QUIET=1 to silence the summary)
"""
import sys, os, json, collections

ROOT = os.environ.get('A2V_ROOT') or os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))   # repository root (env A2V_ROOT overrides)
QUIET = bool(os.environ.get('A2V_QUIET'))
ROM = open(os.path.join(ROOT, 'Mobile Trainer (Japan).gbc'), 'rb').read()
assert len(ROM) == 0x200000

def rb(bank, addr):
    assert 0x4000 <= addr < 0x8000, (bank, hex(addr))
    return ROM[bank * 0x4000 + addr - 0x4000]
def rw(bank, addr): return rb(bank, addr) | (rb(bank, addr + 1) << 8)

# ---------------------------------------------------------------- the song table, as LoadSongHeader reads it
TABLE_BASE = 0x5515           # `ld bc,$5515 ; add hl,bc` after id*8 (04:4326)
records = {}
for n in range(1, 0x47):      # `cp $47 ; jr nc` : ids 1..$46 accepted
    a = TABLE_BASE + 8 * n
    records[n] = dict(id=n, header=rw(4, a), bank=rw(4, a + 2), prio=rb(4, a + 4), flags=rb(4, a + 5), count=rb(4, a + 6), spare=rb(4, a + 7))

# ---------------------------------------------------------------- command decoding
class Cmd:
    __slots__ = ('bank', 'addr', 'size', 'op', 'rs', 'args', 'kind', 'text')
    def __init__(s, **k):
        for a in s.__slots__: setattr(s, a, k.get(a))

END_OPS = {0xB1, 0xB6, 0xB7, 0xB8, 0xB9, 0xBA, 0xBB, 0xC7, 0xC8, 0xCB, 0xCC}
ONE_BYTE = {0xBC, 0xBD, 0xBE, 0xBF, 0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC9, 0xCA}

def decode(bank, addr, rs):
    """Decode one command at addr with running status rs.  Returns (Cmd, new_rs, successors)
    successors: list of ('next', addr) fallthrough, ('jump', addr), ('call', target, return), ('ret',)"""
    c = rb(bank, addr)
    if c & 0x80:
        op, hdr = c, 1
        new_rs = op if op >= 0xBE else rs
    else:
        op, hdr = rs, 0
        new_rs = rs
    p = addr + hdr            # position of the first argument byte (= DE after the dispatch)
    cmd = Cmd(bank=bank, addr=addr, op=op, rs=(hdr == 0), args=())
    succ = []
    if hdr == 0 and rs == 0:  # a data byte with running status 0: the driver would index the duration table with 0-$B1 ... (never in the data)
        cmd.kind, cmd.size, cmd.text = 'badrs', 1, 'BADRS'
        return cmd, new_rs, []
    if op >= 0xD0 or op == 0xCE:                       # note (CE: duration field 0)
        dur_idx = None if op == 0xCE else op - 0xCF
        seen = 0; pitch = vol = adj = None; q = p
        while True:
            v = rb(bank, q)
            if v & 0x80: break
            if v >= 0x24:
                if seen & 1: break
                seen |= 1; pitch = v
            elif v >= 0x20:
                if seen & 4: break
                seen |= 4; adj = v - 0x20
            else:
                if seen & 2: break
                seen |= 2; vol = v
            q += 1
        cmd.kind, cmd.size, cmd.args = 'note', q - addr, (dur_idx, pitch, vol, adj)
        succ = [('next', addr + cmd.size)]
    elif op == 0xCF:                                   # note off, optional pitch byte >= $24 (bit 7 clear)
        v = rb(bank, p)
        has = (not (v & 0x80)) and v >= 0x24
        cmd.kind, cmd.size, cmd.args = 'noteoff', hdr + (1 if has else 0), ((v if has else None),)
        succ = [('next', addr + cmd.size)]
    elif op < 0xB1:                                    # waits ($80: no-op)
        cmd.kind, cmd.size, cmd.args = ('wait0' if op == 0x80 else 'wait'), 1, (op - 0x80,)
        succ = [('next', addr + 1)]
    elif op == 0xB2:
        t = rw(bank, p); cmd.kind, cmd.size, cmd.args = 'jump', hdr + 2, (t,); succ = [('jump', t)]
    elif op == 0xB3:
        t = rw(bank, p); cmd.kind, cmd.size, cmd.args = 'call', hdr + 2, (t,); succ = [('call', t, addr + hdr + 2)]
    elif op == 0xB4:
        cmd.kind, cmd.size = 'ret', hdr; succ = [('ret',)]
    elif op == 0xB5:
        n = rb(bank, p); t = rw(bank, p + 1)
        cmd.kind, cmd.size, cmd.args = 'loop', hdr + 3, (n, t)
        succ = [('jump', t)] + ([] if n == 0 else [('next', addr + cmd.size)])
    elif op in END_OPS:
        cmd.kind, cmd.size = 'end', hdr; succ = []
    elif op in ONE_BYTE:
        cmd.kind, cmd.size, cmd.args = 'cmd1', hdr + 1, (rb(bank, p),)
        succ = [('next', addr + cmd.size)]
    elif op == 0xCD:
        sub = rb(bank, p)
        if sub >= 0x0C or sub in (0, 8, 9):
            cmd.kind, cmd.size, cmd.args = 'cd_end', hdr + 1, (sub,); succ = []
        else:
            cmd.kind, cmd.size, cmd.args = 'cd', hdr + 2, (sub, rb(bank, p + 1)); succ = [('next', addr + cmd.size)]
    else:
        raise RuntimeError(f'unhandled opcode {op:02X} at {bank:02X}:{addr:04X}')
    return cmd, new_rs, succ

# ---------------------------------------------------------------- explore every track the driver can start
MAXDEPTH = 5      # `cp $0A` on the depth counter that grows by 2: a sixth call ends the track

def explore(bank, start):
    """All commands reachable from `start` (all flow choices); returns {addr: {(rs_in, size, kind, args, op)}} and the set of final addresses"""
    seen = set(); decodes = collections.defaultdict(dict); order = []
    stack = [(start, 0, ())]
    while stack:
        addr, rs, cs = stack.pop()
        if (addr, rs, cs) in seen: continue
        seen.add((addr, rs, cs))
        cmd, nrs, succ = decode(bank, addr, rs)
        key = (cmd.op, cmd.rs, cmd.size, cmd.kind, cmd.args)
        decodes[addr][key] = cmd
        for s in succ:
            if s[0] in ('next', 'jump'):
                stack.append((s[1], nrs, cs))
            elif s[0] == 'call':
                if len(cs) >= MAXDEPTH: continue            # the driver ends the track here
                stack.append((s[1], nrs, cs + (s[2],)))
            elif s[0] == 'ret':
                if cs: stack.append((cs[-1], nrs, cs[:-1]))
                else: stack.append((addr + cmd.size, nrs, cs))   # empty stack: no-op, continue
    return decodes

def main():
    out = {}
    # headers and tracks
    hdr_users = collections.defaultdict(list)       # (bank, header) -> [ids]
    for n, r in records.items(): hdr_users[(r['bank'], r['header'])].append(n)
    out['records'] = records
    P = (lambda *a, **k: None) if QUIET else print
    P(f"song records read: {len(records)} (ids 1..$46)")
    tracks = []   # (bank, header, k, start)
    headers = {}
    for (bank, h), ids in sorted(hdr_users.items()):
        counts = {records[i]['count'] for i in ids}
        assert len(counts) == 1, (bank, h, counts)
        cnt = counts.pop()
        b0, b1 = rb(bank, h), rb(bank, h + 1)
        headers[(bank, h)] = dict(ids=ids, count=cnt, byte0=b0, extra=b1, size=2 + 2 * cnt * (1 + b1))
        for k in range(cnt):
            tracks.append((bank, h, k, rw(bank, h + 2 + 2 * k)))
    P(f"distinct headers: {len(headers)}; tracks (set-0 pointers, with duplicates): {len(tracks)}; distinct stream starts: {len({(t[0], t[3]) for t in tracks})}")
    # explore
    per_track = {}
    cmds = {}                 # (bank, addr) -> Cmd (one decode per address; conflicts recorded)
    conflicts = []
    for bank, h, k, st in tracks:
        d = explore(bank, st)
        per_track[(bank, h, k)] = d
        for addr, variants in d.items():
            for key, cmd in variants.items():
                if (bank, addr) in cmds:
                    o = cmds[(bank, addr)]
                    if (o.op, o.size, o.kind, o.args) != (cmd.op, cmd.size, cmd.kind, cmd.args) or o.rs != cmd.rs:
                        conflicts.append((bank, addr, (o.op, o.rs, o.size, o.kind, o.args), (cmd.op, cmd.rs, cmd.size, cmd.kind, cmd.args)))
                else:
                    cmds[(bank, addr)] = cmd
    P(f"reachable commands (distinct addresses): {len(cmds)}; conflicting decodes at one address: {len(conflicts)}")
    for c in conflicts[:10]: P('  CONFLICT', c)
    # overlap check among reachable commands
    ivs = sorted((b, a, a + c.size) for (b, a), c in cmds.items())
    ov = [(x, y) for x, y in zip(ivs, ivs[1:]) if x[0] == y[0] and x[2] > y[1]]
    P(f"overlapping reachable commands: {len(ov)}")
    out['_cmds'] = cmds; out['_headers'] = headers; out['_tracks'] = tracks; out['_per_track'] = per_track
    return out

if __name__ == '__main__':
    o = main()
