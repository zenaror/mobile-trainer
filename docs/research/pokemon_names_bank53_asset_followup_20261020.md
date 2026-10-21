# Bank 53 names and PNG/frame follow-up (2026-10-20)

This is a bounded Japanese-original audit of the bank53 name table, the candidate
frame windows, and the active PNG extraction inventory. The detailed per-window
and per-ordinal matrices, commands, source locations, and hashes are retained in
`.tmp/parallel-jp-assets-20261020/BANK53_PNG_FOLLOWUP.md` (SHA-256
`3d34bd60cc6960cf687ea9bbdb95e74d0c1d2bd546808cfa38dd168cdbd54bf7`).

The report authenticated its private source snapshot against commit
`a3e01214e534394febc371e70759e492261822f0`: 4,356 Japanese-tree Git blobs
matched, with no missing or differing blobs. All 565 `languages/` blobs were
excluded. Comparing the repository changes since that commit shows only the
Song 03 alias source edit and documentation changes; no graphics or PNG-rule
inputs changed. The original ROM used by the audit is 2,097,152 bytes with
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

The 25 ordinal strings at `53:4000–4171` re-emit their original 369 bytes
exactly. No demonstrated reader/producer chain links a name ordinal to a frame
selection, so all 25 name-to-image relationships remain **HYPOTHESIS**. This
does not mean that 25 PNGs are missing.

For the finite physical-window inventory, all 24 legacy bank41–46 previews and
the editing view for `47:68F0` exist. Seventeen of the 25 candidate windows
have editing views; eight are intentionally omitted by current composition
admission rules and remain `KEEP`: `41:5AA0`, `41:67F0`, `42:5AA0`, `43:4D50`,
`43:67F0`, `44:4D50`, `45:4D50`, and `46:67F0`. Their maintained source bytes
and component assets are present. The omission policy does not prove whether
the original program uses these windows.

The authenticated active catalogue contains 979 assets and 978 PNG rules.
All rule outputs and referenced PNG inputs exist; all emitted hashes match the
registered original baselines. The report's standard-library signature/chunk/
CRC scan passed for all 856 PNG files under `gfx/` and `data/`. The current
checkout's separate `make png-check` also passes (408 tile sheets, four raw
byte views, 37 font sheets, 95 screen PNGs). These checks establish file/rule
integrity within their scopes, not a pixel-to-binary inverse for every PNG.

No candidate window is proven deliberately unused by the original program.
The descriptor table examined selects three bank47 resource families and does
not select these 25 candidate windows; that is a bounded static fact, not a
whole-program reachability result. Names, filenames, counts, and visual
similarity do not replace a producer-to-reader chain. Keep the eight omissions
and all 25 name/frame associations open until original selection state and
consumers are demonstrated.

## Eight KEEP placement recheck (2026-10-21)

An independent static placement audit fixed its inputs to
`bef896d02a0476acfc92d32dfe615f3dbd0b34fa` and the original ROM SHA above. It
checked only these eight KEEP windows. The existing descriptor table has 27
style words and five distinct descriptors whose far pointers select bank 47.
The loader preserves `LCDC.bit4`. No selector or source path was found for
these bank41–46 windows, and the scan found zero symbolic code references to
their labels.

| KEEP window | signed prefix model | after hypothetical clear/upload |
|---|---:|---:|
| `41:5AA0` | 144/360 cells | 360/360 |
| `41:67F0` | 144/360 | 360/360 |
| `42:5AA0` | 114/360 | 348/360 |
| `43:4D50` | 144/360 | 360/360 |
| `43:67F0` | 144/360 | 360/360 |
| `44:4D50` | 114/360 | 360/360 |
| `45:4D50` | 144/360 | 360/360 |
| `46:67F0` | 114/360 | 360/360 |

Counts are unchanged across title columns 2/4 and scrollbar states 0/1. The
clear/upload step is a **HYPOTHESIS**, not an observed original operation or
placement. At `42:5AA0`, the remaining 12 cells (rows 3–14, column 0) require
VRAM bank 1 tile `$E7` at `$8E70`. One contact in the 32 far-pattern checks,
`04:48B4`, is a false positive inside audio instruction bytes; it provides no
frame reference. No byte is missing from the maintained ROM-backed assets,
but none of the eight windows gains a justified original editing view. Preserve
their `KEEP` status and all 25 unproved name-to-image associations.

The detailed report, matrix and result are retained in the ignored
`.tmp/agent-keep-frame-placement-20261021/` directory; result SHA-256
`6cc28e19009428e51be45c56da1ec0c9963a952047bcabc9bc42fa37da2e001e`. The
audit made no source, build, emulator or tracked-file changes. This finite
negative result does not prove global reader absence or that any frame is
unused.
