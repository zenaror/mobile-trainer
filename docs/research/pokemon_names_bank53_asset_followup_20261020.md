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
