# Japanese tile-resource ordinal follow-up

## Result

**All 41 labels now name their statically proven VRAM destination and CGB VRAM bank**: 38 single-destination labels and three explicit multi-destination labels.

`CONFIRMED` here means the source symbol is statically tied to a transfer whose destination/bank arguments are explicit. It does not claim the transfer executed naturally, identify the picture's visual subject, or establish hardware behavior. The common transfer decoding is in `home/gfx_upload.asm:7–40`: C counts 16-byte blocks, `E & $F0` supplies the destination low byte, and `E & 1` selects VRAM bank 0/1.

## Renamed tiles

| Old symbol | Current symbol | Source bytes | VRAM destination | Static consumers |
|---|---|---:|---|---|
| `BrowserMenu3_Tiles0` | `BrowserMenu3_Tiles8800Vb1` | `72:6C10–7010` (1024) | `$8800`, VB1 | `engine/browser/frame_graphics.asm:29,153`; `engine/browser/menus.asm:425` |
| `BrowserMenu3_Tiles1` | `BrowserMenu3_Tiles8F00Vb1` | `72:7010–7110` (256) | `$8F00`, VB1 | `engine/browser/menus.asm:431` |
| `BrowserMenu2_Tiles0` | `BrowserMenu2_Tiles8800Vb1` | `72:7220–7620` (1024) | `$8800`, VB1 | `engine/browser/menus.asm:29` |
| `BrowserMenu2_Tiles1` | `BrowserMenu2_Tiles8F00Vb1` | `72:7620–7720` (256) | `$8F00`, VB1 | `engine/browser/menus.asm:23` |
| `BrowserStart_Tiles0` | `BrowserStart_Tiles8000Vb0` | `73:45E0–49E0` (1024) | `$8000`, VB0 | `engine/browser/start_choice.asm:42` |
| `BrowserStart_Tiles1` | `BrowserStart_Tiles8800Vb0` | `73:4DE0–51E0` (1024) | `$8800`, VB0 | `engine/browser/start_choice.asm:48` |
| `BrowserStart_Tiles2` | `BrowserStart_Tiles8C00Vb0` | `73:51E0–55E0` (1024) | `$8C00`, VB0 | `engine/browser/start_choice.asm:54` |
| `BrowserStart_Tiles3` | `BrowserStart_Tiles9000Vb1` | `73:55E0–59E0` (1024) | `$9000`, VB1 | `engine/browser/start_choice.asm:60` |
| `BrowserStart_Tiles4` | `BrowserStart_Tiles9400Vb1` | `73:59E0–5DE0` (1024) | `$9400`, VB1 | `engine/browser/start_choice.asm:66` |
| `ConnIcon_Tiles0` | `ConnIcon_Tiles8200Vb0` | `69:4160–4560` (1024) | `$8200`, VB0 | `engine/comm/connection_icon.asm:184` |
| `ConnIcon_Tiles1` | `ConnIcon_Tiles8600Vb0` | `69:4560–4760` (512) | `$8600`, VB0 | `engine/comm/connection_icon.asm:190` |
| `Gfx_MobileDict_Tiles0` | `Gfx_MobileDict_Tiles8000Vb0` | `1A:4A90–4C90` (512) | `$8000`, VB0 | `engine/help/mobile_dictionary.asm:37` |
| `Gfx_MobileDict_Tiles1` | `Gfx_MobileDict_Tiles8B00Vb1` | `1A:4C90–5090` (1024) | `$8B00`, VB1 | `engine/help/mobile_dictionary.asm:43` |
| `Gfx_MobileDict_Tiles2` | `Gfx_MobileDict_Tiles8F00Vb1` | `1A:5090–5390` (768) | `$8F00`, VB1 | `engine/help/mobile_dictionary.asm:49` |
| `Gfx_MailAddr_Tiles2` | `Gfx_MailAddr_Tiles9700Vb1` | `2D:7520–75D0` (176) | `$9700`, VB1 | `engine/mail/address_editor.asm:475` |
| `Gfx_MailAddr_Tiles3` | `Gfx_MailAddr_Tiles8800Vb0` | `2D:75D0–7880` (688) | `$8800`, VB0 | `engine/mail/address_editor.asm:481` |
| `Gfx_MailBody_Tiles2` | `Gfx_MailBody_Tiles9700Vb1` | `2D:5EC0–5FC0` (256) | `$9700`, VB1 | `engine/mail/body_editor.asm:439,3112` |
| `Gfx_MailMenu_Tiles0` | `Gfx_MailMenu_Tiles8000Vb0` | `1D:4D20–4EB0` (400) | `$8000`, VB0 | `engine/menus/mail_menu.asm:44` |
| `Gfx_MailMenu_Tiles1` | `Gfx_MailMenu_Tiles8800Vb0` | `1D:4EB0–52B0` (1024) | `$8800`, VB0 | `engine/menus/mail_menu.asm:50` |
| `Gfx_MailMenu_Tiles2` | `Gfx_MailMenu_Tiles8C00Vb0` | `1D:52B0–56B0` (1024) | `$8C00`, VB0 | `engine/menus/mail_menu.asm:56` |
| `Gfx_MailMenu_Tiles4` | `Gfx_MailMenu_TileSlice9080Vb1` | `1D:5AB0–5E30` (896) | `$9080`, VB1; transfer starts in preceding chunk | `engine/menus/mail_menu.asm:68` |
| `Gfx_MailMenu_Tiles5` | `Gfx_MailMenu_Tiles9400Vb1` | `1D:5E30–6230` (1024) | `$9400`, VB1 | `engine/menus/mail_menu.asm:74` |
| `Gfx_MailSrvDelProgress_Tiles0` | `Gfx_MailSrvDelProgress_Tiles9000Vb1` | `23:6FE0–73E0` (1024) | `$9000`, VB1 | `engine/mail_server/delete_progress.asm:34` |
| `Gfx_MailSrvDelProgress_Tiles1` | `Gfx_MailSrvDelProgress_Tiles9400Vb1` | `23:73E0–74E0` (256) | `$9400`, VB1 | `engine/mail_server/delete_progress.asm:40` |
| `Gfx_MailSrvDelProgress_Tiles2` | `Gfx_MailSrvDelProgress_Tiles8000Vb0` | `23:74E0–7640` (352) | `$8000`, VB0 | `engine/mail_server/delete_progress.asm:46` |
| `Gfx_MailServerMgr_Tiles0` | `Gfx_MailServerMgr_Tiles9000Vb1` | `2E:56E0–5AE0` (1024) | `$9000`, VB1 | `engine/mail_server/tidy_screen.asm:35,141` |
| `Gfx_MailServerMgr_Tiles1` | `Gfx_MailServerMgr_Tiles9400Vb1_Prefix` | `2E:5AE0–5AF0` (16) | `$9400`, VB1 | `engine/mail_server/tidy.asm:92`; screen transfers also read 1024 bytes from this start |
| `Gfx_MailServerMgr_Tiles2` | `Gfx_MailServerMgr_Tiles8800Vb1` | `2E:5EE0–6000` (288) | `$8800`, VB1 | `engine/mail_server/tidy_screen.asm:47,153` |
| `Gfx_MailServerMgr_Tiles3` | `Gfx_MailServerMgr_Tiles8A80Vb0` | `2E:6000–6400` (1024) | `$8A80`, VB0 | `engine/mail_server/tidy_screen.asm:59,165` |
| `Gfx_MailServerMgr_Tiles4` | `Gfx_MailServerMgr_Tiles8E80Vb0` | `2E:6400–6560` (352) | `$8E80`, VB0 | `engine/mail_server/tidy_screen.asm:65,171` |
| `Gfx_MailServerMgr_Tiles5` | `Gfx_MailServerMgr_Tiles8000Vb0` | `2E:6560–6960` (1024) | `$8000`, VB0 | `engine/mail_server/tidy_screen.asm:53,159` |
| `Gfx_TitleLogo_Tiles0` | `Gfx_TitleLogo_Tiles9000Vb1` | `0E:60A0–64A0` (1024) | `$9000`, VB1 | `engine/title/title_screen.asm:448` |
| `Gfx_TitleLogo_Tiles1` | `Gfx_TitleLogo_Tiles9400Vb1` | `0E:64A0–68A0` (1024) | `$9400`, VB1 | `engine/title/title_screen.asm:454` |
| `Gfx_Title_Tiles0` | `Gfx_Title_Tiles8000Vb0` | `0E:43C0–47C0` (1024) | `$8000`, VB0 | `engine/title/title_screen.asm:314` |
| `Gfx_Title_Tiles3` | `Gfx_Title_TileSlice8A00Vb1` | `0E:4DC0–4FC0` (512) | `$8A00`, VB1; transfer starts at prior chunk | `engine/title/title_screen.asm:332` |
| `Gfx_Title_Tiles4` | `Gfx_Title_Tiles8C00Vb1` | `0E:4FC0–53C0` (1024) | `$8C00`, VB1 | `engine/title/title_screen.asm:338` |
| `Gfx_Title_Tiles5` | `Gfx_Title_Tiles9000Vb1` | `0E:53C0–57C0` (1024) | `$9000`, VB1 | `engine/title/title_screen.asm:344` |
| `Gfx_Title_Tiles6` | `Gfx_Title_Tiles9400Vb1` | `0E:57C0–5BC0` (1024) | `$9400`, VB1 | `engine/title/title_screen.asm:350` |
| `Gfx_MailMenu_Tiles3` | `Gfx_MailMenu_Tiles9000Vb0_SharedTail9000Vb1` | `1D:56B0–5AB0` (1024) | full block `$9000`, VB0; final `$80` bytes also begin a transfer to `$9000`, VB1 | `engine/menus/mail_menu.asm:58,64` |
| `Gfx_Title_Tiles1` | `Gfx_Title_Tiles8800Vb0_SharedTail8000Vb1` | `0E:47C0–4BC0` (1024) | full block `$8800`, VB0; final `$200` bytes also begin a transfer to `$8000`, VB1 | `engine/title/title_screen.asm:316,322` |
| `Gfx_Title_Tiles2` | `Gfx_Title_Tiles8200And8800Vb1` | `0E:4BC0–4DC0` (512) | full block at `$8200` and `$8800`, VB1; the `$8200` load is the latter half of a transfer beginning at `$8000` | `engine/title/title_screen.asm:328`; the transfer starting at `Gfx_Title_Tiles8800Vb0_SharedTail8000Vb1 + $200` |

## Multi-destination names and deliberate KEEP decisions

| Retained name | Why it remains owner-qualified |
|---|---|
| `Tilemap_MailServerMgr_Main` | Already identifies the main 20×18 tilemap/attribute pair and its `$D000` destination. |
| `Tilemap_MailServerMgr_Footer` | Already identifies the 20×6 footer pair and its `$D0A0` destination. |
| `Tilemap_MailServerMgr_InfoB/C/D` | Keep the three owner-qualified variants. They share format/destination; content semantics are not established strongly enough to replace the variant names. Existing confidence on C/D remains `PROBABLE`. |

The MailServerMgr prefix row is deliberately bounded: `Gfx_MailServerMgr_Tiles1` is exactly 16 bytes and is read alone by `engine/mail_server/tidy.asm:92`. Two screen transfers request 1024 bytes from the same start and include the separately named 1008-byte tail. The new name applies only to the 16-byte definition span.
