# Shared text-entry VRAM source paths, bank 5E

2026-10-18 — private original-only path proposal, queued after Notice4B; not adopted or runtime validated.

## The bounded collection

The owner `gfx/settings/screens_bank5e.asm` holds two contiguous sources, 5E:4000–4400 and 5E:4400–4800, each 1024 bytes. Its existing labels are `Gfx_SharedTextEntry_Vram8800Vb1` and `Gfx_SharedTextEntry_Vram8C00Vb1`. This proposal names the owner/folder `gfx/settings/shared_text_entry_tiles_bank5e` and the paired binary/PNG stems `shared_text_entry_vram8800_vb1` and `shared_text_entry_vram8c00_vb1`.

The collection name is **PROBABLE**, bounded by the four positive text-entry reader contexts below. Both existing data headers remain **CONFIRMED** without changes to their evidence text. Names describe a shared source and its demonstrated transfer destination; they do not classify every tile as a glyph, recover original terminology, or assign an exclusive phone/account screen purpose. The existing research note `settings_text_entry_and_confirm_resource_names.md` documents the shared contract; its alias-retirement evidence remains separate from this path unit.

## Source and original ROM evidence

| Context | First call: source 5E:4000 | Second call: source 5E:4400 |
|---|---|---|
| `PhoneKeypad_Setup` | 67:4370 | 67:4382 |
| `PhoneComment_KeyboardSetup` | 67:49E5 | 67:49F7 |
| `Account_LoginIdEntry_Setup` | 68:5351 | 68:5363 |
| `Account_MailAddressEntry_Setup` | 68:5804 | 68:5816 |

Each of the eight literal source blocks matches the original ROM instructions immediately before and through its inline FarCall. It sets A=$5E, B=$92, C=$40 and HL=$4000/$4400; DE=$8801/$8C01. FarCall invokes `Gfx_StartHDMAWithService` at 00:0787, preserving the incoming A/HL under its existing trampoline contract. That helper selects the ROM bank through `BankSwitch_H`, writes the source/destination HDMA registers, masks E with $F0 for the aligned destination, and uses E bit0 for VRAM bank. C=$40 is 64 blocks of 16 bytes, within its existing legal general-purpose domain $01..$80. The destination extents are therefore VRAM1:$8800–8C00 and $8C00–9000. When LCD is enabled the helper waits for $91<=LY<B; B=$92 is not a new universal timing guarantee.

Both 1024-byte binaries match their exact original ROM slices. There are two global labels and no local labels in this owner; their order, addresses and names stay unchanged, as do the two headers and all emissions. This unit does not establish new natural reachability, enumerate every possible computed reader, or execute a new trace.

## Narrow path migration and editing views

Five file renames form this unit: one ASM owner, two `.2bpp` binaries and their two existing `.png` counterparts. The owner header, SECTION, INCBINs and single `layout.link` section name move together at unchanged bank $5E/org $4000. The binaries are copied without byte changes; each PNG is copied with exactly equal encoded bytes. Pixel invariance follows from that equality, without any decode, render or re-export in this task. No PNG is created or removed, and no independent screen PNG/model identity is renamed.

The two catalogue rows change only `path` and `asm`. The two PNG-rule rows change only `out` and `png`; kinds, sizes, padding and binary baseline hashes stay held. Four lines of `gfx/png.mk` update the two output-list entries and two PNG_SIZE assignments; the common `%.2bpp: %.png` rule resolves the matched new stems. No editing-tool code needs a resource-specific change.

Five current `gfx/screens.tsv` rows each have two binary paths inside the `tiles` cell. Only those ten path components change. The screen name, screen PNG, tilemap and attribute paths, all dest/first/count components, dimensions, palette loads, signed-addressing choice, resolved/cell counts, evidence and every **HYPOTHESIS** qualifier remain exact. The affected models are account login/mail entry plus two PhoneKeypad compositions and one PhoneComment composition. A renamed tile source does not make these partly resolved compositions confirmed. `screen_png.Screen` parses these components as dest:asset:first:count; catalogue-backed reads continue to use the new paths. All conditional editing limitations remain inherited.

Three lines of the current `gfx/README.md` asset index follow the migration. No shared `docs/README.md` or `REVERSE_ENGINEERING.md` snapshot is included.

## Historical paths and future rebase

The canonical path map appends five exact old/current file pairs, including both PNGs. The standalone snapshot preserves all previous 235 rows byte-for-byte; this is not a forecast of a future integration total. Notice4B may already have appended three rows by adoption time. ROOT must apply this append-only plan by unique key and preserve those rows, rather than overwrite the future parent with this snapshot. The catalogue, PNG rules, make fragment, layout and README likewise require keyed/line-bounded rebasing.

Frozen config, legacy generator/layout data, the 22 historical analysis/preview metadata files and dated naming records are not rewritten. The old 5E paths in `analysis/naming2/neutral_code_worklist.tsv` and historical image-text inventory remain provenance; use the path map for present navigation (the inventory uses gfx-relative PNG stems). This unit does not validate or adopt that inventory's visual classifications or suggested translations. Existing `gfx/previews/screen_ops.tsv` records refer to the unchanged labels and remain held. The historical tree check constructs an independent tree from ROM/config/layout, so its old layout paths do not require the maintained owner to remain at the old location. That is a static source finding, not an executed tree-check result.

English manifest, overrides, payloads and fallback maintenance remain suspended and unchanged. No language-specific path closure or English build is claimed. No other pending proposal is modified, and this package does not depend on Notice4B being adopted.

## Validation boundary

This package contains exact BEFORE pins, source snapshots, five rename/deletion entries, keyed cell edits, append-only/line edit plans and a finite source/AST/ROM hash readset. It is not self-accepted or adopted. Only private static Python analysis ran; no repository helper was imported or executed, no unit test, make, compiler, emulator, renderer, Git or OMM operation ran. The predicted symbol-set delta is zero, without a fixed future parent or total. Actual rebuild/ROM identity and editing pipeline checks belong to ROOT after independent review. Equal source slices and PNG hashes alone are not an assembled-ROM comparison.

## ROOT integration ordering follow-up

The first private integration built an original-byte-identical ROM and passed the
symbol check, then stopped at `png-check`: the renamed rule rows retained their
old positions. `build_rules` sorts by output path, and `mk_text` follows that order.
The correction sorts the same 951 rule records and reserializes the make fragment;
all rule field values, binary baseline hashes and PNG bytes stay unchanged.
The original failed candidate, logs and static approvals remain preserved. This
version still requires its own independent review and complete integration checks;
no ACTUAL adoption or successful corrected battery is claimed here.

The intervening screen71 records are non-tile rules. The filtered tile order
already agrees, so the reserialized `gfx/png.mk` is byte-identical and is retained.
