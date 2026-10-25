# Japanese inline BMP record bounds

## Exhaustive accepted-dimension and declared-length classes

| Computed row bytes R | Accepted W | Source stride | Span at H=1 / W0 iteration | Span at H=96 / W0 union |
|---:|:---:|---:|---:|---:|
| 0 | 0 | 0 | 256 | 256 (same span repeated; no return) |
| 1 | 1–8 | 4 | 1 | 381 |
| 2 | 9–16 | 4 | 2 | 382 |
| 3 | 17–24 | 4 | 3 | 383 |
| 4 | 25–32 | 4 | 4 | 384 |
| 5 | 33–40 | 8 | 5 | 765 |
| 6 | 41–48 | 8 | 6 | 766 |
| 7 | 49–56 | 8 | 7 | 767 |
| 8 | 57–64 | 8 | 8 | 768 |
| 9 | 65–72 | 12 | 9 | 1149 |
| 10 | 73–80 | 12 | 10 | 1150 |
| 11 | 81–88 | 12 | 11 | 1151 |
| 12 | 89–96 | 12 | 12 | 1152 |
| 13 | 97–104 | 16 | 13 | 1533 |
| 14 | 105–112 | 16 | 14 | 1534 |
| 15 | 113–120 | 16 | 15 | 1535 |
| 16 | 121–128 | 16 | 16 | 1536 |
| 17 | 129–136 | 20 | 17 | 1917 |
| 18 | 137–144 | 20 | 18 | 1918 |

### Bottom-up converter `CopyBytes` intervals

| Sink | Read interval | Write interval | Exact caveat |
|---|---|---|---|
| First copy, source line 535 | `[T,T+K)` | `[0xD000+N,0xD000+N+K)` | `K=(M-N) mod 65536`; call is skipped only for `K=0`. Only if `M>=N` without wrap is `K=M-N` and the staging destination ends at `0xD000+M`. |
| Second copy, source line 541 | `[0xD000,0xD000+C(M))` | `[P+O,P+O+C(M))` | `C(M)=M` when `M!=0`; `C(0)=256` because `CopyBytes` treats `BC=0` as a 256-byte page when `B=0`. |
| Five following stores, lines 543–551 | — | `[P+O+C(M),P+O+C(M)+5)` | Writes five zero bytes without a separate capacity check. |

## HTTP body length and physical receive ceiling

The maintained inline-image route makes the resource length field precise.
`Browser_FetchInlineImages` passes `wBrowserRxPtr` (the cursor immediately
after the URL NUL, at the next record's 16-bit length word) as `DE` and passes
`BC = $BFFC - DE` to `Http_StartGet`. `MobileAPI_HttpGet` retains that base and
capacity. `MobileSDK_HttpPrepareRequestPackets` sets the HTTP result pointer to
the supplied base, starts body copies at base+2, and reserves those two bytes
by reducing the remaining capacity by two. `MobileSDK_HttpBodyStart` counts
copied response-body bytes after the HTTP headers; on completion the SDK writes
the accumulated `wMobileSDK_ReceivedLength` at the result pointer. Therefore
the nested record stores the body byte count, **excluding** the two-byte record
prefix. `Html_NextResourceRecord` returns body start at record+2 and end at
record+2+that count.

`Bmp_ConvertToTiles` still discards the `DE` end returned by `Html_NextResourceRecord`, and does not compare palette, row, metadata, or copy intervals against the recorded body length.

Its `$C0` high-byte test on `P+O+N` also has no carry check.

## Synthetic boundary witness for the five-byte tail

A second directed fake-HTTP run now reaches the converter's tail stores at the
top of SRAM3. The page route was entered through the original ROM; the local
adapter log records HTTP 200 for `/01/CGB-B9AJ/index.html` (30 bytes) and
`/01/CGB-B9AJ/x.bmp` (4,048 bytes). The synthetic bottom-up BMP has `W=144`,
`H=1`, pixel offset `$0EE0`, source stride 20, and converted extent 240. With
the fixture's postprocessed page length of 32, the observed BMP base is
`$B02C`; the converted pixel end is therefore `$B02C+$0EE0+240 = $BFFC`.

| Store | Address | PC |
|---|---:|---:|
| 1 | `$BFFC` | `51:73B7` |
| 2 | `$BFFD` | `51:73B9` |
| 3 | `$BFFE` | `51:73BB` |
| 4 | `$BFFF` | `51:73BD` |
| 5 | `$C000` | `51:73BF` |

Thus the five-byte tail can cross from the upper edge of the SRAM window into WRAM in this accepted, synthetically constructed response.

`home/sprites.asm:129-145` identifies that PC as the loop in `Sprite_ClearShadowOAM`, which clears all 160 shadow-OAM bytes.

The directed run used the canonical ROM and the existing `browser_bookmarks` saved state/config, replayed the resolved natural input prefix through the `a.html` image request, and replaced only `/img_a.bmp` with a copy of the existing 318-byte BMP whose width field at offsets 18-21 was set to zero.

Observed result: exit 0; 9,600 frames; 55,479,360 instructions; final PC `75:6149` (SDK state dispatcher; not a return from the converter); HTTP GET `/01/CGB-B9AJ/img_a.bmp` returned 200 with 318 bytes.

A second run with `--watch FFD4 --watch FFD6 --watch FFD7 --watch C332 --watch C333 --watch C334 --watch C33F` recorded width 0, height `$20`, bottom-up flag 0, converted-output row stride 0, and rounded height `$24`.

The instrumented branch probe then recorded 1,346 taken branches from `51:729C` to `51:7251` with `DE=$D000`, `F=$C0`, and stride 0; two sampled interrupts entered `$0050` and returned to the loop.

### Community archive BMP payloads

Static reproduction of the maintained `Bmp_ParseHeader` / `Bmp_CheckSize` predicates found that only `other3.bmp`, `other4.bmp`, and `other5.bmp` pass the header and dimension checks.

It did find the linked route: archived `index.html` points to `today_mobile/index01.html`, which points to `today_mobile3.html`.
