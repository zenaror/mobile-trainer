# Japanese name and graphics-path follow-up (2026-10-22)

## Scope and controls

This static pass used the Japanese source at be627911718ee6512ab687c2521c9b578d1cfb4c and the original ROM whose SHA-256 is 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570. English-language sources and operator ZIP inputs were excluded. The private source census covered 349 maintained ASM/INC files, excluding protected engine/mail/sample_data.asm; its ordered source-manifest SHA-256 is 2cd19e3efef49b552f21745d5bfa5f7da3db4052f2e2e0ddbbb6006cf429ff21.

## Function and generic-symbol census

The safe source set contains zero definitions named Function_BB_AAAA, Func_BB_AAAA, Sub_BB_AAAA, or Label_BB_AAAA, and zero exact address-only Font_, Tiles_, Tilemap_, Palette_, or Attrmap_ definitions. The prior examples are now MobileSDK_CopyBytes at 75:4000, Config_DefaultImage2 at 68:6960, and Font_GlyphRun_824F at 48:4ADB; their 7, 192, and 160 emitted bytes match the corresponding ROM spans.

Fifteen Data_BB_AAAA labels remain, covering 145 ROM-exact bytes: 1C_401C, 23_46CC, 24_4BCC, 24_6520, 26_5062, 2F_4094, 48_69AB, 4B_5400, 4E_5390, 5F_6980, 72_63D7, 72_6711, 75_6D62, 7F_4C77, and 7F_51ED. The census found no nominal use beyond each declaration and did not establish new meanings. Keep these neutral until a byte-range owner and consumer support a safer name.

The broader census found 595 typed but address-only sprite symbols: 133 SpriteFrameTable_*, 303 SpriteFrame_*, and 159 SpriteScript_*. Their structural type is known, while the object owner/purpose is not resolved by this count. Nine names contain Unknown: six correspond to the literal ????? display in MailServerStatus; three ReadData_UnknownContent spans remain content-unknown.

There are 625 address-based RAM definitions: 42 hRam_* and 583 wRam_*. A lexical scan found 134 used outside their definitions and 491 wRam_* definitions with no lexical use in the scanned code. This is not proof that they are unused: indirect banked access, overlays, or generated accesses may be involved. RAM hash controls: ram/hram.asm 74bbd78134dd49ec1cde4c735d88943206bc179b8ff25f32749d1fa8c4ba58f5; ram/wram.asm 23194356c1b33c82c61b5d7fb9baef17c05de0a3914c2080ee49b538f62eeabf. Full census manifest for file/line/name/address/non-definition-use: d47471252b4cefc97a5b77fcb85caaa09ee499845ec6b484eb4ba85d2645ac53.

## Static graphics-path names

Two independent static reviews approved 17 names (20 payloads, 35 physical files, 24,349 bytes) in gfx/help/help_screens_a/ and gfx/comm/time_summary/. The 20 payloads equal their original ROM slices; the 12 tile PNGs independently decode to their .2bpp sources.

The HelpMenu assets now identify the three selected map families as help_menu_page1_background, help_menu_page2_background, and help_menu_page3_background, plus six tile uploads by VRAM destination and VBK. Page 1 names the default path used whenever the page value is neither 2 nor 3; it does not claim a strict ==1 branch. The three screen reconstructions remain HYPOTHESIS at 320/360 resolved cells; their classifications and preview models were preserved.

The Time Summary and connection-icon paths now name four Summary A/B tile uploads, the Summary A BG palette, two connection-icon request-2 tile uploads, and the request-2 OBJ palette loaded to slots 4-7. The two palette payloads have direct static loads into their BG/OBJ buffers; the code comments now record those consumers while retaining PROBABLE for the grouping/format interpretation. The Summary A/B render model in gfx/screens.tsv was left unchanged because the routine contains both branches.

All path-only catalog changes preserve the existing addresses, emitted payload hashes, sizes, and asset confidence cells. Thirty-five old-to-current physical path pairs are recorded in gfx_resource_path_map.tsv. The stale inventory locator for the separately classified Summary candidate tiles at 51:5EE1 now points to time_summary_candidate_tiles_5ee1.2bpp; its candidate classification is unchanged.

These are static source/ROM findings. They do not establish natural execution, visual identification, hardware behavior, full function closure, or absence of other sprite/data/RAM names needing semantic work.
