# Japanese name and graphics-path follow-up

The bounded follow-up now names 33 Save Sender Address sprite symbols by repeated entry groups and one of the 15 audited `Data_BB_AAAA` spans as a confirmed static tile-transfer slice.

## Function and generic-symbol census

The safe source set contains zero definitions named Function_BB_AAAA, Func_BB_AAAA, Sub_BB_AAAA, or Label_BB_AAAA, and zero exact address-only Font_, Tiles_, Tilemap_, Palette_, or Attrmap_ definitions. The prior examples are now MobileSDK_CopyBytes at 75:4000, Config_DefaultImage2 at 68:6960, and Font_GlyphRun_824F at 48:4ADB; their 7, 192, and 160 emitted bytes match the corresponding ROM spans.

Static table entries and the `Sprite_InitSlot` call arguments support those group names; the existing PROBABLE classifications were preserved, and no visual identity or natural-use claim is added.

Nine names contain Unknown: six correspond to the literal ????? display in MailServerStatus; three ReadData_UnknownContent spans remain content-unknown.

## Static graphics-path names

The HelpMenu assets now identify the three selected map families as help_menu_page1_background, help_menu_page2_background, and help_menu_page3_background, plus six tile uploads by VRAM destination and VBK. Page 1 names the default path used whenever the page value is neither 2 nor 3; it does not claim a strict ==1 branch. The three screen reconstructions remain HYPOTHESIS at 320/360 resolved cells; their classifications and preview models were preserved.

The Time Summary and connection-icon paths now name four Summary A/B tile uploads, the Summary A BG palette, two connection-icon request-2 tile uploads, and the request-2 OBJ palette loaded to slots 4-7. The two palette payloads have direct static loads into their BG/OBJ buffers; the code comments now record those consumers while retaining PROBABLE for the grouping/format interpretation. The Summary A/B render model in gfx/screens.tsv was left unchanged because the routine contains both branches.

The stale inventory locator for the separately classified Summary candidate tiles at 51:5EE1 now points to time_summary_candidate_tiles_5ee1.2bpp; its candidate classification is unchanged.

These are static source/ROM findings. They do not establish natural execution, visual identification, hardware behavior, full function closure, or absence of other sprite/data/RAM names needing semantic work.
