"""Inline-data call conventions (config/conventions.tsv), shared by gen_asm.py and conventions_check.py.

A *convention* names the ENTRY ADDRESS of a routine that reads bytes stored right after the call that reached
it (`call $06D1 ; dw target ; db bank`).  Those bytes are data, not instructions.  This module holds

* the layouts (`farptr`, `inline_dw`, `inline_db`),
* `ConvTable.lookup`: does a decoded instruction call/jump to a convention entry?
* `scan`: the linear sweep of one code region that skips the inline bytes.  The generator and the checker both use
  it, so they cannot disagree about where inline data starts and ends.

Nothing here reads files or knows about labels; see docs/FORMATS.md ("Inline-data conventions").
"""
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

import sm83
from lib import mtcfg

LAYOUTS = mtcfg.LAYOUTS
CONSUMER_FLOWS = mtcfg.CONSUMER_FLOWS
Convention = mtcfg.Convention


class InlineData:
    """Pseudo instruction standing for the inline bytes that follow a convention call (never decoded)."""
    flow = 'inline'
    target = None
    imm16 = None
    imm16_kind = None
    hram = None

    def __init__(self, addr: int, slot: int, raw: bytes, conv: Convention, site: int):
        self.addr = addr            # CPU (run) address of the first inline byte
        self.slot = slot            # storage address of the first inline byte
        self.raw = raw
        self.conv = conv
        self.site = site            # storage address of the call/jp instruction

    @property
    def length(self) -> int:
        return len(self.raw)

    @property
    def word(self) -> int:
        return self.raw[0] | (self.raw[1] << 8)


class ConvTable:
    """Lookup of convention entries.  `branch_xrefs`: {(bank, storage addr): (target bank, target addr)} from the
    `branch` rows of config/xrefs.tsv, which give a call from ROM0/RAM code into $4000-$7FFF its bank."""

    def __init__(self, convs: List[Convention], branch_xrefs: Optional[Dict[Tuple[int, int], Tuple[int, int]]] = None):
        self.by_entry: Dict[Tuple[int, int], Convention] = {(c.bank, c.addr): c for c in convs}
        self.xrefs = branch_xrefs or {}

    def __bool__(self) -> bool:
        return bool(self.by_entry)

    def lookup(self, bank: int, kind: str, store_addr: int, ins) -> Optional[Convention]:
        """The convention whose entry `ins` (a decoded instruction stored at `bank`:`store_addr` in a `kind`
        region) transfers control to, or None.  The entry is compared as (bank, address): ROM0 addresses are bank 0,
        $4000-$7FFF belong to the caller's own bank (code in bank N cannot switch itself away) and have no known bank
        when called from ROM0 or RAM code, unless a `branch` xref row says which bank it is."""
        if ins.flow not in CONSUMER_FLOWS or ins.target is None or not self.by_entry:
            return None
        t = ins.target
        x = self.xrefs.get((bank, store_addr))
        if x is not None:
            return self.by_entry.get(x) if x[1] == t else None
        if t < 0x4000:
            return self.by_entry.get((0, t))
        if t < 0x8000 and bank != 0 and kind != 'ramcode':
            return self.by_entry.get((bank, t))
        return None


@dataclass
class Overflow:
    """A convention call whose inline bytes do not fit in the rest of the region."""
    index: int              # index in items of the call/jp instruction
    conv: Convention
    have: int               # inline bytes that are still inside the region (0 = the call ends exactly at the region end)


@dataclass
class ScanResult:
    items: List[Tuple[int, object]]                 # (storage address, sm83.Insn | InlineData)
    cross: Optional[Tuple[int, int, int]] = None    # (storage address, opcode, full length) of an instruction crossing the end
    overflow: Optional[Overflow] = None             # the scan stopped here: the region ended inside the inline data


def scan(chunk: bytes, run0: int, store0: int, bank: int, kind: str, table: Optional[ConvTable]) -> ScanResult:
    """Linear sweep of `chunk` (the bytes of a code/ramcode region, stored at store0, running at run0) that
    consumes the inline bytes after convention calls.  Stops at the first instruction that crosses the region end
    (`cross`) or at the first convention call whose inline bytes do not fit (`overflow`)."""
    res = ScanResult([])
    n = len(chunk)
    i = 0
    while i < n:
        ins = sm83.decode(chunk, i, (run0 + i) & 0xFFFF)
        if ins.flow == 'bad' and ins.raw[0] not in sm83.ILLEGAL:
            full = sm83.decode(chunk[i:i + 3] + b'\0\0\0', 0, 0)
            res.cross = (store0 + i, ins.raw[0], full.length)
            return res
        res.items.append((store0 + i, ins))
        i += ins.length
        conv = table.lookup(bank, kind, store0 + i - ins.length, ins) if table else None
        if conv is None:
            continue
        if i + conv.size > n:
            res.overflow = Overflow(len(res.items) - 1, conv, n - i)
            return res
        res.items.append((store0 + i, InlineData((run0 + i) & 0xFFFF, store0 + i, chunk[i:i + conv.size], conv, store0 + i - ins.length)))
        i += conv.size
    return res
