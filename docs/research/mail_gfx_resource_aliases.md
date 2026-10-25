# Mail screen resource alias contracts —2026-10-17

## Follow-up: bank 2D body-editor zero-fill label — 2026-10-21

The 64-byte interval `2D:5E80–5EC0` is now named `Gfx_MailBody_HDMALoadZeroFill`. This records only its **CONFIRMED transfer role**; it does not claim the bytes are visible or semantically referenced as tiles. In the immutable Japanese ROM (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`), the interval is exactly 64 zero bytes (physical offset `0xB5E80`, SHA-256 `f5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b`).

`MailBody_SetupScreen` starts an HDMA from `2D:5AC0`, with `C=$40` (1024 bytes), to VRAM bank 1 at `$9300`; the bytes at `5E80–5EC0` are its final 64 zero-filled bytes. `MailBody_ReloadTiles` starts a 768-byte transfer at `2D:5CC0` to VRAM bank 1 at `$9500`, which also crosses the same zero-fill before continuing into `Gfx_MailBody_Tiles2`. `home/gfx_upload.asm:7–28` confirms the helper's 16-byte block unit and destination-bank handling. Existing trace/dataaccess records show the encompassing banked range was read; these do not establish a reference to the resulting tile indices.

The former phrase “neutral KEEP unit” remains correct for **unknown tile semantics**, while the exact source/transfer identity is now named. The tilemap is copied separately at `2D:5FC0`; no evidence in this bounded chain associates the zero-fill with a displayed tile or sprite. No PNG or asset-catalog entry is created for these bytes.

This finite original-ROM proposal retires20 redundant position aliases in four maintained gfx/mail owners: body editor5, address editor3, received-mail grid6 and viewer6. Existing descriptive identities remain. Each old/proper pair has identical frozen linked position, its declared resource backing reemits original bytes, and a positive banked load sequence independently matches original-ROM instructions. Unit means backing slice, paired map/attr rows, or RGB555 palette; it does not infer an application association from appearance. No status is upgraded.

All20 alias rows become blank physical rows, with0 local labels beneath the aliases,0 active old operands/comments/metadata references in the declared readset, and0 asset moves or byte changes. No generic frame/script/animation unit is retired. The DATA/ALIAS_MAP20.json contract in the retained private package records old→proper bank/address/end/backings/status; POSITIVE_LOAD_PROOFS.json gives finite source lines, exact ROM instruction bytes, bank and requested extents. This note preserves the mapping for integration review rather than asserting a fresh linked result.

The body5AC0 resource is960B; the setup site requests64 blocks/1024B and therefore also reads64 adjacent inline zero bytes. Other sites request60blocks/960B or32blocks/512B. The second reload slice starts at5CC0 (+200h), uses C=$30 (48 blocks/768B), and ends at5FC0:448B of the main960B backing,64 adjacent neutral zero bytes, then256B of Gfx_MailBody_Tiles2. The independently maintained5E80 neutral inline unit remains neutral. The address7E20 palette backing is64B, while the selected setup copy requests48B only; no full-palette usage claim follows. Other selected HDMA transfers use C in1..80,16-byte blocks, destination Ebit0 for VRAM bank and DE&FFF0 destination. Tilemap helpers consume18x20 map bytes and18x20 attributes. Palette helpers stage bounded BC bytes into WRAM7 buffers; this is not itself a direct hardware palette write.

Banked helpers select ROM by H/A; far calls depend on the initialized HRAM trampoline and preserved mapper state. LCD-on HDMA waits require91<=LY<B; service variants call frame service. Shared scratch, WRAM7, IRQ/waits and caller context remain conditional; retirement supplies no general ABI, IRQ immunity, persistence, natural caller or display guarantee. Grid headers retain their forced-only/non-natural caveat. Body/Address resource confidence and viewer mixed CONFIRMED/PROBABLE headers remain exactly as inherited.

The selected owners belong to none of the ROOT31V2 changed ASM set and are disjoint from pending Mail20 lib/mobile/mail.asm. The frozen ROOT31 parent map has14890 total entries including51 constants. Removing only these20 globals predicts14870 symbols with all surviving values held. After a separately integrated disjoint Mail20 parent14870, the arithmetic forecast is14850. Neither forecast is a fresh linked/native result; ROOT must rebase and verify the actual map.

The token census covers maintained home/engine/gfx/audio/lib/ram ASM plus gfx and analysis/naming2 TSVs, with frozen config literals recorded as history. It does not open account/sample-mail payload or data ASM; no universal old-reference absence claim is made outside this declared readset. Manual RAM metadata are also read independently from the frozen31 source view using split('\n'):594 manual records,156/300/138 already,0context/value/bank skips. The existing optional empty context and four physical EOF-empty neighbors remain preserved; no new rows or inferred NOTICE records are created. No metadata or RAM field changes. A successful exit code from an apply tool would not establish these counters; no apply tool is executed here.

The eight KEEP frame views,25names/25windows/27selectorwords and unknown species/selector/name associations remain outside this cohort. Unselected neutrals and HYPOTHESIS units remain. Existing PNG paths/bytes are hashed as backings, without render, export/import or pixel inversion. No new natural runtime, emulator, hardware, English, gate, compiler, source publication, Git operation occurs. Old evidence stays sealed; retain this proposal for independent review and ROOT-only gates.

## Finite old-to-current map

| Old alias | Maintained identity | Bank:interval | Bytes | Held status |
|---|---|---|---:|---|
| `Data_2D_5AC0` | `Gfx_MailBody_Tiles` | 2D:5AC0–5E80 | 960 | PROBABLE |
| `Data_2D_5FC0` | `Tilemap_MailBody` | 2D:5FC0–6290 | 720 | CONFIRMED |
| `Data_2D_6290` | `Palette_MailBody_Bg` | 2D:6290–62D0 | 64 | PROBABLE |
| `Data_2D_62D0` | `Gfx_MailBody_ObjTiles` | 2D:62D0–6570 | 672 | PROBABLE |
| `Data_2D_6570` | `Palette_MailBody_Obj` | 2D:6570–65B0 | 64 | CONFIRMED |
| `Data_2D_7120` | `Gfx_MailAddr_Tiles` | 2D:7120–7520 | 1024 | CONFIRMED |
| `Data_2D_7B50` | `Tilemap_MailAddr` | 2D:7B50–7E20 | 720 | CONFIRMED |
| `Data_2D_7E20` | `Palette_MailAddr_Bg` | 2D:7E20–7E60 | 64 | PROBABLE |
| `Data_2B_59C0` | `Gfx_MailGrid_Tiles9000Vb1` | 2B:59C0–5DC0 | 1024 | PROBABLE |
| `Data_2B_5DC0` | `Gfx_MailGrid_Tiles9400Vb1` | 2B:5DC0–5FF0 | 560 | PROBABLE |
| `Data_2B_5FF0` | `Data_MailGrid_TilemapAttr` | 2B:5FF0–62C0 | 720 | PROBABLE |
| `Data_2B_62C0` | `Palette_MailGrid_Bg` | 2B:62C0–6300 | 64 | PROBABLE |
| `Data_2B_6300` | `Gfx_MailGrid_Tiles8000` | 2B:6300–63F0 | 240 | PROBABLE |
| `Palette_2B_63F0` | `Palette_MailGrid_Obj` | 2B:63F0–6430 | 64 | PROBABLE |
| `Tiles_2B_6DD0` | `Gfx_MailView_Tiles9000Vb1` | 2B:6DD0–71D0 | 1024 | CONFIRMED |
| `Tiles_2B_71D0` | `Gfx_MailView_Tiles9400Vb1` | 2B:71D0–73D0 | 512 | PROBABLE |
| `Data_2B_73D0` | `Data_MailView_TilemapAttr` | 2B:73D0–76A0 | 720 | CONFIRMED |
| `Palette_2B_76A0` | `Palette_MailView_Bg` | 2B:76A0–76E0 | 64 | PROBABLE |
| `Tiles_2B_76E0` | `Gfx_MailView_Tiles8000` | 2B:76E0–7860 | 384 | PROBABLE |
| `Palette_2B_7860` | `Palette_MailView_Obj` | 2B:7860–78A0 | 64 | PROBABLE |

Some repeated load patterns occur twice inside one source global scope. The evidence lists both exact ROM matches rather than inventing a unique source-line-to-PC assignment; each matching pattern has the same resource, bank, extent and helper.

## Documentary rebase and finite extent qualifications —2026-10-17

V1's alias mechanics were independently accepted, but V1 was documentary BLOCKED
by GFXMAIL-DOC-01: its second reload was incorrectly described as32 blocks. The
corrected sentence above follows the independently checked C=$30/48-block ROM
sequence. The old V1 note/report and finding seals remain historical and unchanged;
this rebase does not retroactively mark V1 fully accepted.

The inherited clipped grid palette header still mentions40words/10groups from a larger heuristic region; its current backing is64B/32words. The neutral7940 header mentions34tiles from the earlier proposal, while its clipped528B backing has33tiles. These historical heuristic phrases do not enlarge the current intervals, change inherited PROBABLE status or rename either KEEP unit.

These are note-only qualifications. The four ASM owners, their20 definition blanks,
all inherited CONFIRMED/PROBABLE headers, all assets/paths and all46 frozen-config
literals are byte-for-byte V1. The reload uses Gfx_StartHDMA with A=$2D, HL=$5CC0,
DE=$9501 (VRAM$9500, bank1), B=$94 and C=$30:48 blocks/768B in the helper's
C=$01..$80 domain. LCD-on wait remains$91<=LY<$94; LCD-off skips it. Far-call
stack/trampoline, selected mapper state, shared scratch, IRQ and caller conditions
remain conditional. This is not a new natural runtime or universal ABI result.

The producer verified11632B of resource prefixes. The independent review verified
12324B across the four complete owners. Their692B difference is retained animation
tails:82B at2B:[6430,6482) in received_mail_grid and610B at2B:[78A0,7B02) in
mail_viewer. Those tails and their37 animation aliases stay KEEP, without retirement
or a new interpretation. They are neither missing bytes nor part of the selected20
backing units. The separate neutral KEEP units5E80–5EC0 (64B) and7940–7B50 (528B)
already lie within the producer prefixes; they are not the692B difference. Neither
finite scope proves whole-ROM completeness.

The independent review additionally scanned373 tracked ASM files including DATA,
with quoted strings/comments excluded from code-token matching:20 definitions and
0 active old references. Its sealed scan supplements the producer's narrower
readset; no account/sample-mail payload is opened by this rebase. All original
scans,594 manual RAM checks and symbol maps are retained as prior static evidence,
not rerun here. No SDKMail20 metadata is integrated. Isolated14870 and the future
disjoint Mail20+GFX forecast14850 remain predictions requiring ROOT rebase/gates.


## Current integration baseline —2026-10-17

The ROOT31 and pending-SDKMail20 arithmetic above is retained as historical
proposal provenance. This new private rebase uses the published original-source
baseline109d57ac523294e7acccf7e3af36e15e1dff9c2f: its frozen accepted FRESH SYM
has14870 total entries, including51 exported constants. SDKMail20 is already
present in that baseline. Removing exactly this GFX20 cohort predicts14850 total
entries (14799 address symbols and51 constants), with every surviving value held.
This is a prediction from the frozen SYM, not a new linked/native result.

The four maintained ASM owners match the accepted proposal BEFORE byte for byte.
The only proposed ASM changes are the same20 blanked redundant alias rows;
proper names, physical rows, local scopes (zero locals), comments, instructions,
assets and paths are unchanged. The inherited6CONFIRMED and14PROBABLE statuses
are preserved. The corrected reload remains C=$30/48blocks/768B and spans
448B+64B+256B; the neutral64B/528B regions,692B animation tails and their37
KEEP aliases remain outside the retirement. The separate eight KEEP frame views
and25names/25windows/27selectorwords retain their uncertain associations.

The queued UNCLASS scope-comment proposal changes none of these four ASM owners.
ROOT must integrate this note and these ASM changes into its current documents,
preserving that proposal's newer scope accounting. No stale copy of
REVERSE_ENGINEERING.md is supplied. No confidence upgrade, new English build or
translation, compiler, emulator, natural runtime, display or hardware claim is
part of this private source-only rebase. Independent review and ROOT validation
remain separate; retiring redundant aliases does not close all unknown units.

## Follow-up: bank 2D MailAddr transfer tail (2026-10-21)

The former neutral label `Data_2D_7940` is now
`Gfx_MailAddr_ObjHDMALoadTail`. Its 528 bytes (`2D:7940–7B50`) are
**CONFIRMED** as the tail of an OBJ-tile HDMA load from `2D:7880`, ending at
VRAM0 `$82D0`. Static setup initializes object frames that associate 240 of
those bytes with frame records. The other 288 bytes are only confirmed as
transferred in this call chain; their display/use remains unknown. This
supersedes the old neutral-label wording and the clipped `34 tiles` heuristic
as a naming basis, without asserting that the whole interval is displayed.
The exact 528-byte ROM slice hash is
`c938b9927040205d4877aace6460753083534d28b0394e85a4a85d37c1f92744`.
