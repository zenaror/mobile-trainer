# Original-ROM closure follow-up — 2026-10-21

## Natural-entry status recheck for four descriptive code roots

Disposition: keep the four operation names descriptive at **PROBABLE** for
their bounded local mechanics, and record natural entry as **UNKNOWN /
unproved**. This is not evidence that the code or containing resources are
unused, nor does it establish a safe caller ABI. No function bytes or labels
changed in this recheck.

## Settings Bank 71 mixed registration animation and password-save owner

The owner begins with two frame records and an animation script for the Registration Delete Execute object, then the probable 20x18 tilemap pair for Password Save Confirm at `71:6F6F`, followed by a 50-byte probable 2bpp fragment at `71:723F` and 1,231 confirmed-read bytes of unknown content at `71:7271–7740`.

## Natural-entry trace interval census

Disposition: retain descriptive labels only for the bounded local mechanics;
natural entry remains **UNKNOWN / unproved** for all five addresses. No
function or caller names were inferred, and no source bytes changed.

The fragment `55:5DF5–5E02` follows a handler ending in an unconditional jump
to `5E5A`; the Select branch goes to `5E02`, skipping it. The fragment's own
CALL to `6EEC` is an outgoing edge, not proof of entry. At `29:511E`, the
selected call at `5120` does not prove bank `7D`; the apparent matching window
`29:7BB7–8000` is 1,097 zero bytes, so code at `7D:7BB7` cannot be assigned to
that call absent separate bank/relocation evidence. These findings narrow the
static hypotheses but do not exclude computed control flow, RAM-built targets,
stack transfers, or copying/relocation. No labels or bytes changed.

## Bank 71 unknown-content read span: expanded trace corpus

The neutral `Settings_ReadData_UnknownContent_7271` name and unknown content class are therefore retained.

## Bank 7F browser prototype page-list candidate paths

`PageListProto_InitScreen` in `engine/unreferenced/page_list_prototype.asm` provides static transfer evidence, but the prototype's natural entry, displayed composition, and semantic meaning remain unproved.

A fresh instruction-only scan of maintained Japanese ASM/INC sources finds
seven numeric CALL sites with six distinct ROM targets. Four references in
`home/farcall.asm` formerly used `$FFA8`; that address is the confirmed HRAM
trampoline `hFarCallTrampoline` defined at `$FFA8`, so the CALL/JP operands now
use that symbol. The four instruction encodings and the full ROM remain
unchanged.

These operands preserve the observed source mechanics and unresolved bank or
entry status. They are not generic function labels. Existing evidence and
confidence limits remain in `docs/research/code_map.md`,
`docs/research/typing_29_leaf_lcdc_ly_limits.md`, and the bounded function
reviews; no target is relabeled by guesswork.
