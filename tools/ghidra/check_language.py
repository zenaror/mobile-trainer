#!/usr/bin/env python3
"""Compare Ghidra's SM83 decoding of every opcode with tools/sm83.py.

usage: check_language.py <ghidra_ops.tsv> <out.tsv>
(the input is produced by tools/ghidra/scripts/GbOpcodeDump.java via check_language.sh)

Checks per opcode: instruction length, flow class, and a normalised operand text.  tools/sm83.py is
the reference (re-assembled byte-exactly by tools/test_sm83.py); a difference here means the Ghidra
language definition disagrees with it, i.e. Ghidra's output for that opcode is NOT to be trusted.
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import sm83  # noqa: E402

# Ghidra FlowType -> sm83.py flow classes that are equivalent.
FLOW = {
    'FALL_THROUGH': {'seq', 'stop', 'halt'},
    'UNCONDITIONAL_JUMP': {'jp', 'jr'},
    'CONDITIONAL_JUMP': {'jpcc', 'jrcc'},
    'UNCONDITIONAL_CALL': {'call', 'rst'},
    'CONDITIONAL_CALL': {'callcc'},
    'TERMINATOR': {'ret'},
    'CONDITIONAL_TERMINATOR': {'retcc'},
    'COMPUTED_JUMP': {'jphl'},
}


def norm(t: str) -> str:
    t = t.lower().replace(' ', '')
    t = t.replace('(', '[').replace(')', ']')
    t = t.replace('[hl+]', '[hli]').replace('[hl-]', '[hld]')
    t = re.sub(r'\$([0-9a-f]+)', lambda m: str(int(m.group(1), 16)), t)
    t = re.sub(r'0x([0-9a-f]+)', lambda m: str(int(m.group(1), 16)), t)
    t = re.sub(r'^(sub|and|xor|or|cp)a,', r'\1', t)          # 'sub a,b' == 'sub b'
    t = re.sub(r'^(add|adc|sbc)a,', r'\1', t)               # 'add a,b' == 'add b'
    t = re.sub(r'^ldh(a,)?\[(\d+)\](,a)?$', lambda m: 'ldh%s[%d]%s' % (m.group(1) or '', int(m.group(2)) & 0xff, m.group(3) or ''), t)  # $FF34 vs 0x34
    return t


def main():
    src, out = sys.argv[1:3]
    rows = []
    for line in Path(src).read_text().splitlines():
        if line.startswith('#') or not line.strip():
            continue
        f = line.split('\t')
        rows.append(f)
    n_ok = 0
    bad = []
    lines = ['# opcode\tstatus\tghidra_len\tsm83_len\tghidra_text\tsm83_text\tghidra_flow\tsm83_flow\tnote']
    for name, glen, gmn, gtext, gflow, gft in rows:
        glen = int(glen)
        if name.startswith('CB'):
            raw = bytes([0xCB, int(name[2:], 16), 0x34, 0x12, 0, 0, 0, 0])
            kind = 1
            op = int(name[2:], 16)
        else:
            raw = bytes([int(name, 16), 0x34, 0x12, 0, 0, 0, 0, 0])
            kind = 0
            op = int(name, 16)
        addr = (kind * 256 + op) * 8     # probe address used by GbOpcodeDump
        ins = sm83.decode(raw, 0, addr)
        stext = ins.text()
        notes = []
        if ins.flow == 'bad':
            status = 'OK' if glen == 0 else 'MISMATCH'
            if glen != 0:
                notes.append('sm83 says illegal opcode, Ghidra decodes it')
        else:
            if glen != ins.length:
                notes.append('length')
            if ins.flow not in FLOW.get(gflow, set()):
                notes.append('flow')
            if norm(gtext) != norm(stext):
                notes.append('text')
            status = 'OK' if not notes else 'MISMATCH'
        if status == 'OK':
            n_ok += 1
        else:
            bad.append((name, notes, gtext, stext))
        lines.append('\t'.join([name, status, str(glen), str(ins.length), gtext, stext, gflow, ins.flow, ','.join(notes)]))
    Path(out).write_text('\n'.join(lines) + '\n')
    print(f'opcodes compared: {len(rows)}  identical (length, flow, normalised text): {n_ok}  mismatches: {len(bad)}')
    for name, notes, g, s in bad:
        print(f'  {name}: {",".join(notes)}   ghidra="{g}"   sm83="{s}"')
    print(f'wrote {out}')
    return 0 if not bad else 2


if __name__ == '__main__':
    sys.exit(main())
