# Bank 53 names and PNG/frame follow-up

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

## Eight KEEP placement recheck

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
