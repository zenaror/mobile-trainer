#!/usr/bin/env python3
"""Keyboard navigation planner for the scenario generators (tools/trace/make_round2.py).

The on-screen keyboards of the ROM are one engine (bank 55, Kbd_Run): keyboard type 0-10 (wKbdType), pages of cells (5 rows x 18 columns,
2 bytes per cell: Shift-JIS/ASCII value), and a per-type table of 6-byte neighbour records (left, right, up, down cell, two flag bytes;
55:4A42).  This module reads those tables from baserom.gbc (read only) and finds, by breadth-first search over the neighbour records, the
shortest D-pad sequence between two cells.  It ignores the "sticky column/row" refinement of the wide OK/back keys (55:6068), which only
matters for moves that start or end on those two keys; the generators verify the result with screenshots (`shot`) and the scenario
is only accepted after looking at them.

usage (self test / lookup): kbdnav.py TYPE PAGE TEXT      prints the tap sequence to type TEXT from the start cell
"""
import sys
from collections import deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
B = 0x55
DIRS = ["LEFT", "RIGHT", "UP", "DOWN"]
_rom = None


def rom():
    global _rom
    if _rom is None:
        _rom = (ROOT / "baserom.gbc").read_bytes()
    return _rom


def rb(addr):
    return rom()[B * 0x4000 + (addr & 0x3FFF)]


def rw(addr):
    return rb(addr) | (rb(addr + 1) << 8)


def start_cell(t):
    return rb(0x4000 + t)


def ok_cell(t):
    return rb(0x400A + t)


def cell_value(t, page, c):
    """-> (first byte, second byte) of cell c of page `page` (SJIS lead/trail, or (0,ascii), (1,ctrl), (0xFF,special))"""
    arr = rw(0x4014 + 2 * t)
    pg = rw(arr + 2 * page)
    a = pg + 2 * c
    return rb(a), rb(a + 1)


def neighbours(t, c):
    base = rw(0x4A42 + 2 * t)
    r = base + 6 * c
    return [rb(r + i) for i in range(4)]


def find_cell(t, page, value, ncells=90):
    """cell index holding `value` = (b0, b1) or a str (one char)"""
    if isinstance(value, str):
        if ord(value) < 0x80:
            value = (0, ord(value))
        else:
            v = value.encode("cp932")
            value = (v[0], v[1])
    for c in range(ncells):
        if cell_value(t, page, c) == value and neighbours(t, c) != [0, 0, 0, 0]:
            return c
    raise KeyError((t, page, value))


def _no_wrap(d, u, v):
    """True when the move is a plain step (the neighbour records also list wrap-around moves and the sticky wide-key moves, whose result depends on
    the remembered column/row; scenario routes avoid them, `path(..., wrap=True)` allows them)"""
    uc, ur, vc, vr = u % 18, u // 18, v % 18, v // 18
    return (vc < uc if d == 0 else vc > uc if d == 1 else vr < ur if d == 2 else vr > ur)


def path(t, a, b, wrap=False):
    """shortest list of direction names from cell a to cell b (plain steps only unless wrap=True; falls back to wrap moves when there is no other route)"""
    if a == b:
        return []
    prev = {a: None}
    dq = deque([a])
    while dq:
        u = dq.popleft()
        for d, v in enumerate(neighbours(t, u)):
            if not wrap and not _no_wrap(d, u, v):
                continue
            if v not in prev and neighbours(t, v) != [0, 0, 0, 0]:
                prev[v] = (u, d)
                if v == b:
                    seq = []
                    while prev[v] is not None:
                        v, d = prev[v][0], prev[v][1]
                        seq.append(DIRS[d])
                        # (v is the predecessor now)
                    return seq[::-1]
                dq.append(v)
    if not wrap:
        return path(t, a, b, True)
    raise ValueError("unreachable %d -> %d" % (a, b))


def type_lines(t, page, cur, values, comment=None):
    """macro lines that walk the cursor over the cells of `values` (list of str chars / (b0,b1)) pressing A on each;
    returns (lines, new_cursor_cell)"""
    lines = []
    for v in values:
        c = find_cell(t, page, v)
        for d in path(t, cur, c):
            lines.append("tap %s" % d)
        lines.append("tap A")
        cur = c
    return lines, cur


if __name__ == "__main__":
    t, p, text = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3]
    ls, cur = type_lines(t, p, start_cell(t), list(text))
    print("\n".join(ls))
