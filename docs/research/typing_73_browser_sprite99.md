# Original browser sprite chain at 73:5E60

CONFIRMED within original bank 73: the 99-byte chain consists of a four-byte frame table at 5E60, two 45-byte frames at 5E64 and 5E91, and a five-byte animation script at 5EBE. Each frame contains count 11 and eleven four-byte OAM records. The second frame has signed Y offsets -1, 7 and 15. These are emitted with existing sprite macros; the table uses literal original pointers to avoid adding labels.

The first object-root entry at 5F0F selects existing Data_73_5E60 and script 5EBE. Its existing macro now emits the same four bytes. The script bytes are 02 00 14 01 14: two steps, frame 0 waiting 20 and frame 1 waiting 20. Existing `BrowserStart_ObjAnimScriptTail_5EC0` points inside the first step delay. Raw slices of two and three bytes retain that alias exactly; no whole-step macro or extra label replaces it. The old comments claiming an absent pointer label or unread tail are contradicted by existing source and original natural data reads.

Existing sprite consumers follow the selected bank, root pointer, frame table, count-controlled four-byte OAM records and count-controlled two-byte animation steps. Their interpretation, not RGB555 appearance, establishes the bounded format. The full first chain and each semantic component are consumed in 19 whole/19 union natural scenarios. The second 76-byte chain at 5EC3-5F0F is unchanged and has 18 whole/19 union coverage; the eight-byte root at 5F0F-5F17 has 19 whole/19 union. Consequently the mixed physical 87-byte header at 5EC0-5F17 has 18 whole/19 union, including the first script tail, second chain and root. Physical intervals and semantic units are kept distinct.

The former palette_5e60.pal remains unchanged as historical evidence. It contains an incorrect RGB555 rendering of the first 96 emitted bytes. Exactly one existing row in each active asset catalogue and PNG rules file receives a comment prefix; line counts and the original row text remain preserved. Active totals become 948 files / 607752 ROM bytes, including 143 palettes / 11504 ROM bytes. PNG make rules are unchanged because palette rows emit no tile/font conversion target. Frozen generator configuration and unrelated bootstrap Still db tables remain historical.

A fresh actual baseline follows publication of the four browser rectangles. Full original owners, macros, evidence traces and prior correction seals precede this bounded format pass. All 289 metadata TSVs, 649 active file/line records and 1947 broad colon locators are audited. None of the locators targets this source, so its 25 extra lines require no locator update. Existing labels and all symbol bytes must remain exact.

This is original reconstruction evidence, not a new runtime or hardware observation. Arbitrary selector safety, whole-bank semantic closure, the unread tile/tail blocks and English translation remain outside these format claims.

## Mechanical first-frame-table alias

The neutral mechanical alias SpriteFrameTable_73_5E60 reuses the blank physical line159 before existing Data_73_5E60 at line160. Object-root entry0 at73:5F0F names that table alias while retaining the literal script pointer5EBE. The owner stays230 lines; the existing table pointers, two frames, split script and `BrowserStart_ObjAnimScriptTail_5EC0` remain unchanged. Existing CONFIRMED storage and finite historical natural-read evidence are retained. This alias provides no new visual identity, species, reachability or runtime evidence. This owner is outside the initial65-row naming ledger, whose counters are unchanged.

## Redundant generic alias retirement (2026-10-21)

The current Japanese source retires the redundant `Data_73_5E60` export while
retaining `SpriteFrameTable_73_5E60` at the same address. A path-safe search of
all tracked non-language files found no consumer of the generic spelling
outside its declaration. The object-root entry already uses the descriptive
table label; the pointers, frames, script, macro expansion and ROM bytes are
unchanged. This removes only a duplicate generic export and adds no visual,
species, reachability or runtime claim.
