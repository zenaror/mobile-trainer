# Image text inventory: which graphics carry language-bound content

Purpose: a translator needs to know which pictures contain Japanese text (or other language-bound content), what it says, where the pixels live and what else must change.
This document lists every tile PNG under `gfx/` (409 exact tile sheets), the font data, and the screens that show them.  Method, evidence and limits are in section 1; the practical guide is
[`docs/TRANSLATION.md`](../TRANSLATION.md).

## 1. How this was made, and how far to trust it

* **What was looked at**: all 409 tile PNGs (contact sheets at 3x), the 39 font / bitmap view sheets, and 125 composed screens (`gfx/previews/screens/`, `tools/render_screens.py`; 87 of them confirmed against emulator screenshots, see `gfx/previews/README.md`), plus emulator screenshots of the help, browser, registration and mail screens.
* **Transcriptions** are read by eye from the rendered images.  CONFIRMED here means only: the string is visible in a composed screen whose static cells match an emulator screenshot pixel for pixel (section 2, "screen" table) *and* was read there.  Readings from the tile sheets of section 3 are **pieces**: the text images are stored as continuous streams cut into tiles (16 tiles per PNG row, a line of text wraps across rows), so a sheet shows fragments; where a fragment could not be read the row says so.  Nothing in a "reading" column was OCR-ed by a program.
* **English renderings are suggestions** (marked "suggestion"); they carry no evidence about the original intent beyond the literal meaning of the kana.
* `tile` counts: one tile = 8x8 pixels = 16 bytes.  `WxH` = the PNG layout (16 tiles per row where possible), not the on-screen shape.
* Classes: **TXT** text baked into tiles (185); **MIX** text and art (10); **FRM** frame art with legend text (33); **KBD** keyboard glyph page (40); **NUM** digits / numbers (9); **ART** art, no text seen (73); **LAT** Latin text in image (1); **ERR** not tile art (typed as tiles) (4); **UNK** not classified / unreadable (54).

Two separate text systems exist (details in `docs/TRANSLATION.md`): (1) text **baked into tile pictures** (this inventory), edited by editing the PNG; (2) text **drawn at run time from font data** (strings under `data/text/`, the HTML store, tickers, dialogs), edited in the `.asm` strings, see `data/fonts/` for the glyph sets.  The hatched checker cells in `gfx/previews/screens/*.png` mark where system (2) draws into a screen.

## 2. Screens with text or language-bound art in their pictures

One row per composed screen (the routine that loads its graphics).  "Pictures" lists the tile PNGs the routine loads (`gfx/` relative, without extension), the tilemap asset, and the palette.  "Text in the images" is what the pictures say; text drawn at run time is named as such.  Status of the composition (confirmed by emulator / static only) is in `gfx/previews/screens.tsv` (`best_capture`, `pix_static_pct`).

| screen (routine) | preview | text in the images (Japanese, as read) | suggestion (English, NOT from the game) | tile PNGs loaded | tilemap | capture-checked |
|---|---|---|---|---|---|---|
| `Title_LoadLogoScreen` | [png](../../gfx/previews/screens/Title_LoadLogoScreen.png) | GB MOBILE SYSTEM GB (logo, Latin) | (no change needed; logo picture) | `title/logo/title_logo_tiles0`<br>`title/logo/title_logo_tiles1` | `title/logo/title_logo_screen` | yes (100.0 % of static pixels) |
| `Title_LoadTitleScreen` | [png](../../gfx/previews/screens/Title_LoadTitleScreen.png) | モバイルトレーナー (logo lettering), スタート, モバイルせってい, (C)2001 Nintendo | Mobile Trainer; Start; Mobile Settings | `title/title_screen/title_tiles0`<br>`title/title_screen/title_tiles1`<br>`title/title_screen/title_tiles2`<br>`title/title_screen/title_tiles4`<br>`title/title_screen/title_tiles5`<br>`title/title_screen/title_tiles6` | `title/title_screen/title_screen` | yes (100.0 % of static pixels) |
| `TopMenu_Run` | [png](../../gfx/previews/screens/TopMenu_Run.png) | メール, ホームページ, ヘルプ (button labels); bottom ticker text is font text | Mail; Home Page; Help | `top_menu/top_menu/tiles_49a0`<br>`top_menu/top_menu/tiles_4da0`<br>`top_menu/top_menu/tiles_51a0`<br>`top_menu/top_menu/tiles_55a0`<br>`top_menu/top_menu/tiles_59a0`<br>`top_menu/top_menu/tiles_5ba0`<br>`top_menu/top_menu/tiles_5fa0` | `top_menu/top_menu/tilemap_40d7` | yes (100.0 % of static pixels) |
| `MailMenu_Run` | [png](../../gfx/previews/screens/MailMenu_Run.png) | メール (banner); おくる/うけとる, メールをかく, メールボックス, アドレスちょう, プロフィール, メールサーバ (buttons) | Mail; Send/Receive; Write Mail; Mailbox; Address Book; Profile; Mail Server | `mail_menu/mail_menu/mail_menu_tiles0`<br>`mail_menu/mail_menu/mail_menu_tiles1`<br>`mail_menu/mail_menu/mail_menu_tiles2`<br>`mail_menu/mail_menu/mail_menu_tiles3`<br>`mail_menu/mail_menu/mail_menu_tiles5` | `mail_menu/mail_menu/mail_menu_screen` | yes (100.0 % of static pixels) |
| `Profile_InitScreen` | [png](../../gfx/previews/screens/Profile_InitScreen.png) | プロフィール (banner); ニックネーム, アドレス (labels); A キーボード, B もどる (legend) | Profile; Nickname; Address; A: Keyboard, B: Back | `profile/profile_editor/profile_tiles9300`<br>`profile/profile_editor/profile_tiles9700`<br>`profile/profile_editor/profile_tiles8800` | `profile/profile_editor/data_profile_tilemap_attr` | yes (100.0 % of static pixels) |
| `AbookAddr_SetupScreen` | [png](../../gfx/previews/screens/AbookAddr_SetupScreen.png) | アドレスちょう (banner); ともだちのアドレスをかいてね; アドレス (label); A キーボード, B もどる | Address Book; Write your friend's address; Address; A: Keyboard, B: Back | `address_book/entry_screen_bank29/tiles_5b10` | `address_book/address_editor/abook_addr` | yes (100.0 % of static pixels) |
| `AbookName_SetupScreen` | [png](../../gfx/previews/screens/AbookName_SetupScreen.png) | アドレスちょう; ニックネームをかいてね; ニックネーム; A キーボード, B もどる | Address Book; Write the nickname; Nickname | `address_book/name_editor/tiles_61f0`<br>`address_book/name_editor/tiles_65f0`<br>`address_book/name_editor/tiles_66f0`<br>`address_book/entry_screen_bank29/tiles_5b10` | `address_book/name_editor/abook_name` | yes (100.0 % of static pixels) |
| `AbookView_SetupScreen` | [png](../../gfx/previews/screens/AbookView_SetupScreen.png) | アドレスちょう; ニックネーム; アドレス; B もどる | Address Book; Nickname; Address; B: Back | `address_book/entry_screen_bank29/tiles_5e50`<br>`address_book/entry_screen_bank29/tiles_6250`<br>`address_book/entry_screen_bank2a/addr_book_entry_tiles8f00`<br>`address_book/entry_screen_bank2a/addr_book_entry_tiles8000` | `address_book/unreferenced_confirm_screen/data_addr_book_entry_tilemap_attr` | yes (100.0 % of static pixels) |
| `AbookList_SetupScreen` | [png](../../gfx/previews/screens/AbookList_SetupScreen.png) | アドレスちょう (banner); list markers and four icon buttons (no text) | Address Book | `address_book/address_picker/addr_book_tiles8f00`<br>`address_book/shared_tiles_bank28/tiles_4bd0`<br>`address_book/shared_tiles_bank28/tiles_4fd0` | `address_book/list/abook_list` | yes (100.0 % of static pixels) |
| `AddrPick_InitScreen` | [png](../../gfx/previews/screens/AddrPick_InitScreen.png) | アドレスちょう (banner); list markers (no text) | Address Book | `address_book/address_picker/addr_book_tiles8f00`<br>`address_book/address_picker/addr_pick_tiles9300`<br>`address_book/address_picker/addr_pick_tiles9700`<br>`address_book/shared_tiles_bank28/tiles_4bd0`<br>`address_book/shared_tiles_bank28/tiles_4fd0` | `address_book/address_picker/data_addr_pick_tilemap_attr` | yes (100.0 % of static pixels) |
| `SaveSenderAddr_InitScreen` | [png](../../gfx/previews/screens/SaveSenderAddr_InitScreen.png) | アドレスちょう (banner); list markers (no text) | Address Book | `address_book/save_sender_address/save_sender_addr_tiles9300`<br>`address_book/shared_tiles_bank28/tiles_4bd0`<br>`address_book/shared_tiles_bank28/tiles_4fd0` | `address_book/save_sender_address/data_save_sender_addr_tilemap_attr` | yes (100.0 % of static pixels) |
| `AddrBook_SaveConfirm_InitScreen` | [png](../../gfx/previews/screens/AddrBook_SaveConfirm_InitScreen.png) | アドレスちょう; ニックネーム; アドレス (labels) | Address Book; Nickname; Address | `address_book/save_confirm/addr_save_confirm_tiles9300`<br>`address_book/save_confirm/addr_save_confirm_tiles9700` | `address_book/save_confirm/data_addr_save_confirm_tilemap_attr` | yes (100.0 % of static pixels) |
| `AddrScreenUnused_InitScreen` | [png](../../gfx/previews/screens/AddrScreenUnused_InitScreen.png) | みる, START, かく (top row; unused screen) | View; START; Write | `address_book/unreferenced_confirm_screen/tiles_7740`<br>`address_book/unreferenced_confirm_screen/tiles_7b70` | `address_book/unreferenced_confirm_screen/tilemap_7860` | yes (100.0 % of static pixels) |
| `MailAddr_SetupScreen` | [png](../../gfx/previews/screens/MailAddr_SetupScreen.png) | メールアドレス (header); ともだちのアドレスをかいてね; セレクト アドレスちょう; A キーボード; B もどる | Mail Address; Write your friend's address; Select: Address Book | `mail/address_editor/mail_addr_tiles`<br>`mail/address_editor/mail_addr_tiles2`<br>`mail/address_editor/mail_addr_tiles3`<br>`mail/address_editor/mail_addr_obj_tiles` | `mail/address_editor/mail_addr` | yes (100.0 % of static pixels) |
| `MailBody_SetupScreen` | [png](../../gfx/previews/screens/MailBody_SetupScreen.png) | メールほんぶん (header); line numbers 1-8; A キーボード B もどる | Mail Body | `mail/body_editor/mail_body_tiles`<br>`mail/body_editor/mail_body_tiles2`<br>`mail/body_editor/mail_body_obj_tiles` | `mail/body_editor/mail_body` | yes (100.0 % of static pixels) |
| `MailBody_InitScreen` | [png](../../gfx/previews/screens/MailBody_InitScreen.png) | B もどる (airmail border) | B: Back | `mail/body_view/mail_body_tiles_42c0`<br>`mail/body_view/mail_body_tiles_44d0` | `mail/body_view/mail_body_tilemap` | yes (100.0 % of static pixels) |
| `MailTitle_InitScreen` | [png](../../gfx/previews/screens/MailTitle_InitScreen.png) | メールタイトル (header); メールのタイトルをかいてね; A キーボード B もどる | Mail Title; Write the title of the mail | `mail/mail_title_entry/mail_title_tiles9300`<br>`mail/mail_title_entry/mail_title_tiles8800`<br>`mail/mail_title_entry/mail_title_tiles8000` | `mail/mail_title_entry/data_mail_title_tilemap_attr` | yes (100.0 % of static pixels) |
| `MailView_BodyPage_InitScreen` | [png](../../gfx/previews/screens/MailView_BodyPage_InitScreen.png) | A つぎへ | A: Next | `mail/body_view/mail_body_tiles_42c0`<br>`mail/body_view/mail_body_tiles_44d0` | `mail/body_view/tilemap_4550` | yes (100.0 % of static pixels) |
| `MailView_SenderPage_InitScreen` | [png](../../gfx/previews/screens/MailView_SenderPage_InitScreen.png) | 年 月 日 時 分 (date labels); アドレス; セレクト アドレスをセーブ; A つぎへ | Y M D h m; Address; Select: Save address; A: Next | `mail/mail_viewer/mail_view_tiles8000`<br>`mail/mail_viewer/mail_view_tiles9000`<br>`mail/mail_viewer/mail_view_tiles9400` | `mail/mail_viewer/data_mail_view_tilemap_attr` | yes (100.0 % of static pixels) |
| `MailDraft_Menu_InitScreen` | [png](../../gfx/previews/screens/MailDraft_Menu_InitScreen.png) | icon buttons only (no text in the image) | - | `mail/draft_menu/mail_draft_menu_tiles8000`<br>`mail/draft_menu/mail_draft_menu_tiles9300` | `mail/draft_menu/data_mail_draft_menu_tilemap_attr` | yes (100.0 % of static pixels) |
| `MailGrid_InitScreen` | [png](../../gfx/previews/screens/MailGrid_InitScreen.png) | もらったメール (banner); 年 月 日 時 分 (labels) | Received Mail | `mail/received_mail_grid/mail_grid_tiles9000`<br>`mail/received_mail_grid/mail_grid_tiles9400`<br>`mail/received_mail_grid/mail_grid_tiles8000` | `mail/received_mail_grid/data_mail_grid_tilemap_attr` | yes (100.0 % of static pixels) |
| `Mailbox_LoadScreen` | [png](../../gfx/previews/screens/Mailbox_LoadScreen.png) | メールボックス (banner); ニックネーム, 年月日時分, row numbers | Mailbox | `mailbox/mailbox/mailbox_tiles_5a10`<br>`mailbox/mailbox/mailbox_tiles_5e10`<br>`mailbox/mailbox/mailbox_tiles_69f0`<br>`mailbox/mailbox/mailbox_tiles_6cf0`<br>`mailbox/mailbox/mailbox_tiles_5f10`<br>`mailbox/mailbox/mailbox_tiles_6310` | `mailbox/mailbox/mailbox_tilemap_normal`<br>`mailbox/mailbox/mailbox_tilemap_delete_select` | yes (100.0 % of static pixels) |
| `MailResult_InitScreen` | [png](../../gfx/previews/screens/MailResult_InitScreen.png) | つうしんけっかはっぴょう (banner); おくったメール; とどいたメール | Communication Results; Sent mail; Received mail | `mail/comm_result/mail_result_tiles_6bf0`<br>`mail/comm_result/mail_result_tiles_6ff0`<br>`mail/comm_result/mail_result_tiles_73f0`<br>`mail/comm_result/mail_result_tiles_7490` | `mail/comm_result/mail_result_tilemap` | yes (100.0 % of static pixels) |
| `MailServerStatus_InitScreen` | [png](../../gfx/previews/screens/MailServerStatus_InitScreen.png) | メールサーバじょうきょう; チェックしたメール; けしおわったメール; サーバにあるメール; つう (counter); A メニューにもどる | Mail Server Status; Mails checked; Mails deleted; Mails on the server; A: Back to menu | `mail/server_status_bank26/mail_server_status_tiles_7420`<br>`mail/server_status/mail_server_status_tiles_6f30`<br>`mail/server_status/mail_server_status_tiles_7330`<br>`mail/result_screens/mail_server_status_tiles_5060` | `mail/server_status/mail_server_status_tilemap_received`<br>`mail/server_status/mail_server_status_tilemap_none_received`<br>`mail/server_status/mail_server_status_tilemap_server_mgmt` | yes (100.0 % of static pixels) |
| `MailSession_InitScreen` | [png](../../gfx/previews/screens/MailSession_InitScreen.png) | EXIT (sign, Latin); B キャンセル | (Latin); B: Cancel | `mail/session_scenery/mail_session_tiles_59e0`<br>`mail/session_scenery/mail_session_tiles_5de0`<br>`mail/session_scenery/mail_session_tiles_61e0`<br>`mail/session_scenery/mail_session_tiles_62e0`<br>`mail/session_scenery/mail_session_tiles_66e0`<br>`mail/session_scenery/mail_session_tiles_67e0`<br>`mail/session_scenery/mail_session_tiles_6be0`<br>`mail/session_scenery/mail_session_tiles_6fe0` | `mail/comm_progress_scene/comm_progress_screen` | yes (100.0 % of static pixels) |
| `MailConnect_InitScreen` | [png](../../gfx/previews/screens/MailConnect_InitScreen.png) | しゅうりょうしています (status bar; the other status messages of this screen, e.g. キャンセルしています, are in the same tile pools, see the inventory rows) | Finishing | `mail/connect_screen/mail_connect_tiles_5060`<br>`mail/connect_screen/mail_connect_tiles_5460`<br>`mail/connect_screen/mail_connect_tiles_5e60`<br>`mail/connect_screen/mail_connect_tiles_6260`<br>`mail/connect_screen/mail_connect_tiles_6660`<br>`mail/connect_screen/mail_connect_tiles_5860`<br>`mail/connect_screen/mail_connect_tiles_5c60`<br>`mail/connect_screen/mail_connect_tiles_6860`<br>`mail/connect_screen/mail_connect_tiles_6c60` | `mail/connect_screen/mail_connect_tilemap`<br>`mail/connect_screen/mail_connect_win_msg_connecting`<br>`mail/connect_screen/mail_disconnect_win_msg_ending` | yes (100.0 % of static pixels) |
| `MailSrvDelHidden_MenuInit` | [png](../../gfx/previews/screens/MailSrvDelHidden_MenuInit.png) | メールのけしかたをえらんでね; かくにんしてからけす; じどうでぜんぶけす; かんぜんにけす | Choose how to delete mail; Confirm, then delete; Delete all automatically; Delete completely | `mail_server/delete_method_screen/mail_server_delete_method_tiles_5f20`<br>`mail_server/delete_method_screen/mail_server_delete_method_tiles_6150`<br>`mail_server/delete_method_screen/mail_server_delete_method_tiles_6550`<br>`mail_server/delete_method_screen/mail_server_delete_method_tiles_67e0` | `mail_server/delete_menu_hidden/mail_srv_del_hidden_button1`<br>`mail_server/delete_menu_hidden/mail_srv_del_hidden_button0`<br>`mail_server/delete_menu_hidden/mail_srv_del_hidden_button2` | yes (100.0 % of static pixels) |
| `MailSrvDel_MenuInit` | [png](../../gfx/previews/screens/MailSrvDel_MenuInit.png) | メールのけしかたをえらんでね; かくにんしてからけす; じどうでぜんぶけす | Choose how to delete mail; Confirm, then delete; Delete all automatically | `mail_server/delete_method_screen/mail_server_delete_method_tiles_5f20`<br>`mail_server/delete_method_screen/mail_server_delete_method_tiles_6150`<br>`mail_server/delete_method_screen/mail_server_delete_method_tiles_6550`<br>`mail_server/delete_method_screen/mail_server_delete_method_tiles_67e0` | `mail_server/delete_method_screen/mail_server_delete_method_tilemap_first`<br>`mail_server/delete_method_screen/mail_server_delete_method_tilemap_second` | yes (100.0 % of static pixels) |
| `MailSrvDelHidden_Confirm` | [png](../../gfx/previews/screens/MailSrvDelHidden_Confirm.png) | サーバのメールをすべてけします; はい; いいえ | Delete all mail on the server; Yes; No | `mail_server/delete_all_screen/mail_server_delete_all_tiles_54b0`<br>`mail_server/delete_all_screen/mail_server_delete_all_tiles_58b0`<br>`mail_server/delete_all_screen/mail_server_delete_all_tiles_5b50` | `mail_server/delete_all_screen/mail_server_delete_all_tilemap` | yes (100.0 % of static pixels) |
| `MailSrvDel_Confirm` | [png](../../gfx/previews/screens/MailSrvDel_Confirm.png) | サーバのメールをすべてけします; はい; いいえ | Delete all mail on the server; Yes; No | `mail_server/delete_all_screen/mail_server_delete_all_tiles_54b0`<br>`mail_server/delete_all_screen/mail_server_delete_all_tiles_58b0`<br>`mail_server/delete_all_screen/mail_server_delete_all_tiles_5b50` | `mail_server/delete_all_screen/mail_server_delete_all_tilemap` | yes (100.0 % of static pixels) |
| `MailSrvDel_ProgressInit` | [png](../../gfx/previews/screens/MailSrvDel_ProgressInit.png) | じどうでぜんぶけす; B キャンセル | Delete all automatically; B: Cancel | `mail_server/delete_progress/mail_srv_del_progress_tiles0`<br>`mail_server/delete_progress/mail_srv_del_progress_tiles1`<br>`mail_server/delete_progress/mail_srv_del_progress_tiles2` | `mail_server/delete_progress/mail_srv_del_progress_screen` | no capture |
| `MailServerMgr_SetupScreen` | [png](../../gfx/previews/screens/MailServerMgr_SetupScreen.png) | メールサーバ (header); このソフトのメール; 年 月 日 時 分 (labels); B でキャンセル; END icon | Mail Server; Mail of this software; B: Cancel | `mail_server/tidy_screen/mail_server_mgr_tiles0`<br>`mail_server/tidy_screen/mail_server_mgr_tiles1`<br>`mail_server/tidy_screen/mail_server_mgr_tiles2`<br>`mail_server/tidy_screen/mail_server_mgr_tiles5`<br>`mail_server/tidy_screen/mail_server_mgr_tiles3`<br>`mail_server/tidy_screen/mail_server_mgr_tiles4` | `mail_server/tidy_screen/mail_server_mgr_main`<br>`mail_server/tidy_screen/mail_server_mgr_footer` | yes (100.0 % of static pixels) |
| `MailServerMgr_RedrawScreen` | [png](../../gfx/previews/screens/MailServerMgr_RedrawScreen.png) | (same as MailServerMgr_SetupScreen) | (same) | `mail_server/tidy_screen/mail_server_mgr_tiles0`<br>`mail_server/tidy_screen/mail_server_mgr_tiles1`<br>`mail_server/tidy_screen/mail_server_mgr_tiles2`<br>`mail_server/tidy_screen/mail_server_mgr_tiles5`<br>`mail_server/tidy_screen/mail_server_mgr_tiles3`<br>`mail_server/tidy_screen/mail_server_mgr_tiles4` | `mail_server/tidy_screen/mail_server_mgr_main`<br>`mail_server/tidy_screen/mail_server_mgr_footer` | yes (100.0 % of static pixels) |
| `CommTime_DrawSummaryScreen` | [png](../../gfx/previews/screens/CommTime_DrawSummaryScreen.png) | つうしんがしゅうりょうしました。 こんかいのつうしんじかんは　ふん　びょうでした。 A つぎへ | Communication finished. This session took _ min _ sec. A: Next | `comm/time_summary/tiles_4db0`<br>`comm/time_summary/tiles_51b0`<br>`comm/time_summary/tiles_42a0`<br>`comm/time_summary/tiles_46a0` | `comm/time_summary/comm_time_summary_b`<br>`comm/time_summary/comm_time_summary_a` | yes (100.0 % of static pixels) |
| `CommTime_DrawHMSScreen` | [png](../../gfx/previews/screens/CommTime_DrawHMSScreen.png) | (same sentence, hours/minutes/seconds variant) A すすむ | (same) | `mail/connect_screen_bank29/tiles_5400`<br>`comm/time_summary/tiles_4db0`<br>`comm/time_summary/tiles_51b0` | `mail/connect_screen_bank29/tilemap_5800`<br>`comm/time_summary/comm_time_summary_b` | no capture |
| `Account_ResultPage` | [png](../../gfx/previews/screens/Account_ResultPage.png) | 通信を終了しました 通信時間は　分　秒でした | Communication ended. Communication time: _ min _ sec | `account/screens_bank4b/tiles_42d0`<br>`account/screens_bank4b/tiles_46d0` | `account/screens_bank4b/tilemap_5898` | yes (100.0 % of static pixels) |
| `Account_ActionConfirmPage_Setup` | [png](../../gfx/previews/screens/Account_ActionConfirmPage_Setup.png) | 通信開始確認 (banner); DIONに接続します よろしいですか?; はい いいえ; ＋選ぶ A決定 | Confirm start of communication; Connect to DION. OK?; Yes; No; D-pad: Select, A: OK | `account/screens_bank5e/tiles_6ba0`<br>`account/screens_bank5e/tiles_6fa0`<br>`keyboard/panels_bank5f/tiles_49d0` | `account/screens_bank5e/tilemap_75d0`<br>`account/screens_bank5e/tiles_6fa0` | yes (100.0 % of static pixels) |
| `CommPanel_StateDraw` | [png](../../gfx/previews/screens/CommPanel_StateDraw.png) | DIONに接続中 (banner); 注意 (tag) | Connecting to DION; Caution | `account/screens_bank71/tiles_4000`<br>`account/screens_bank71/tiles_4300`<br>`account/screens_bank71/tiles_4890` | `account/screens_bank71/tilemap_4c98`<br>`account/screens_bank71/tilemap_4f68` | yes (100.0 % of static pixels) |
| `Account_ConfirmScreen_Setup` | [png](../../gfx/previews/screens/Account_ConfirmScreen_Setup.png) | 『次の情報をモバイルアダプタGBに登録します』; ログインID; メールアドレス; よろしいですか?; はい いいえ; ＋選ぶ A決定 B戻る | The following will be registered to the Mobile Adapter GB; Login ID; Mail address; OK? | `account/screens_bank5d/tiles_5df0`<br>`account/screens_bank5d/tiles_61f0`<br>`account/screens_bank5d/tiles_63f0`<br>`keyboard/panels_bank5f/tiles_49d0` | `account/screens_bank5d/tilemap_6630` | yes (100.0 % of static pixels) |
| `Account_ConfirmManualScreen_Setup` | [png](../../gfx/previews/screens/Account_ConfirmManualScreen_Setup.png) | (same banner); ログインID; メールアドレス; インターネット用; セルフページ用; コメント; よろしいですか? | (same); For the Internet; For the self page; Comment | `account/screens_bank5d/tiles_5df0`<br>`account/screens_bank5d/tiles_61f0`<br>`account/screens_bank4a/tiles_5870`<br>`keyboard/panels_bank5f/tiles_49d0` | `account/screens_bank4a/tilemap_5cb0` | yes (100.0 % of static pixels) |
| `Registration_DeleteConfirm_Setup` | [png](../../gfx/previews/screens/Registration_DeleteConfirm_Setup.png) | 削除再確認 (banner); 削除した情報は元に戻せません 本当によろしいですか?; はい いいえ | Confirm deletion again; Deleted information cannot be restored. Really OK? | `account/screens_bank71/tiles_5340`<br>`account/screens_bank71/tiles_5740`<br>`account/screens_bank71/tiles_5dc0`<br>`keyboard/panels_bank5f/tiles_49d0` | `account/screens_bank71/tilemap_66c8`<br>`account/screens_bank71/tilemap_6998` | no capture |
| `Registration_DeleteExecute_Setup` | [png](../../gfx/previews/screens/Registration_DeleteExecute_Setup.png) | 削除中 (banner); 登録情報を削除中です; 注意 | Deleting; Deleting the registration information | `account/screens_bank71/tiles_5dc0`<br>`account/screens_bank71/tiles_6580` | `account/screens_bank71/tilemap_6c68` | no capture |
| `Registration_WriteConfig_Setup` | [png](../../gfx/previews/screens/Registration_WriteConfig_Setup.png) | アダプタ登録中 (banner); 設定情報を登録中です; 注意 | Registering to adapter; Registering the settings | `account/screens_bank5d/tiles_6900`<br>`account/screens_bank5d/tiles_6e00` | `account/screens_bank5d/tiles_6e00` | no capture |
| `Account_LoginIdEntry_Setup` | [png](../../gfx/previews/screens/Account_LoginIdEntry_Setup.png) | ログインIDを入力してください | Enter the login ID | `settings/screens_bank5e/tiles_4000`<br>`settings/screens_bank5e/tiles_4400`<br>`account/screens_bank5e/tiles_4800`<br>`account/screens_bank5e/tiles_4c00` | `account/screens_bank5e/tilemap_4d40` | yes (100.0 % of static pixels) |
| `Account_LoginIdIntro_Draw` | [png](../../gfx/previews/screens/Account_LoginIdIntro_Draw.png) | ログインID入力 (banner); 例 g123456789; A次へ B戻る | Login ID entry; Example; A: Next, B: Back | `account/screens_bank5e/tiles_4e10`<br>`account/screens_bank5e/tiles_5210` | `account/screens_bank5e/tiles_5210` | yes (100.0 % of static pixels) |
| `Account_MailAddressEntry_Setup` | [png](../../gfx/previews/screens/Account_MailAddressEntry_Setup.png) | メールアドレスを入力してください; .dion.ne.jp | Enter the mail address | `settings/screens_bank5e/tiles_4000`<br>`settings/screens_bank5e/tiles_4400`<br>`account/screens_bank5e/tiles_5800`<br>`account/screens_bank5e/tiles_5c00` | `account/screens_bank5e/tilemap_6000` | no capture |
| `Account_MailIntro_Draw` | [png](../../gfx/previews/screens/Account_MailIntro_Draw.png) | メールアドレス入力 (banner); 例 ninten88@gbaa.dion.ne.jp | Mail address entry | `account/screens_bank5e/tiles_60d0`<br>`account/screens_bank5e/tiles_64d0` | `account/screens_bank5e/tilemap_68d0` | yes (100.0 % of static pixels) |
| `Account_PasswordIntro_Draw` | [png](../../gfx/previews/screens/Account_PasswordIntro_Draw.png) | パスワード入力 (banner); 例 AbCd1234 | Password entry | `account/screens_bank5d/tiles_5320`<br>`account/screens_bank5d/tiles_5720` | `account/screens_bank5d/tilemap_5b20` | yes (100.0 % of static pixels) |
| `PwSaveConfirm_Setup` | [png](../../gfx/previews/screens/PwSaveConfirm_Setup.png) | パスワード保存の確認 (banner); パスワードを保存します よろしいですか?; はい いいえ | Confirm saving the password | `settings/screens_bank5d/tiles_7360`<br>`settings/screens_bank5d/tiles_7760`<br>`keyboard/panels_bank5f/tiles_49d0` | `settings/screens_bank5d/tilemap_7ba0`<br>`settings/screens_bank71/tilemap_6f6f` | yes (100.0 % of static pixels) |
| `SettingsPhone_ChoiceMenu_Setup` | [png](../../gfx/previews/screens/SettingsPhone_ChoiceMenu_Setup.png) | 電話番号入力方法選択 (banner); 自動で入力する; 手動で入力する; ＋選ぶ A決定 B戻る | Select phone number entry method; Enter automatically; Enter manually | `settings/screens_bank4d/tiles_4000`<br>`settings/screens_bank4d/tiles_4510`<br>`settings/screens_bank4d/tiles_4610`<br>`settings/screens_bank4d/tiles_4a10`<br>`settings/screens_bank4d/tiles_5010`<br>`settings/screens_bank4d/tiles_5110`<br>`settings/screens_bank4d/tiles_5510` | `settings/screens_bank4d/tiles_5510`<br>`settings/screens_bank4d/tilemap_5810` | yes (100.0 % of static pixels) |
| `SettingsPhone_ConfirmScreen_Setup` | [png](../../gfx/previews/screens/SettingsPhone_ConfirmScreen_Setup.png) | 次のように電話番号を変更します; 登録場所 1; インターネット用; セルフページ用; コメント; よろしいですか? | Change the phone numbers as follows; Registration slot 1; For the Internet; For the self page; Comment | `settings/screens_bank4b/tiles_6a90`<br>`settings/screens_bank4b/tiles_6e90`<br>`keyboard/panels_bank5f/tiles_49d0` | `settings/screens_bank4b/tiles_70b0` | yes (100.0 % of static pixels) |
| `SettingsPhone_ContinuePrompt_Setup` | [png](../../gfx/previews/screens/SettingsPhone_ContinuePrompt_Setup.png) | 電話番号変更終了 (banner); 続けて登録をしますか?; はい いいえ | Phone number change finished; Continue registering? | `settings/screens_bank4b/tiles_76d0`<br>`settings/screens_bank4b/tiles_7ad0`<br>`keyboard/panels_bank5f/tiles_49d0` | `settings/screens_bank4b/tiles_7ad0` | yes (100.0 % of static pixels) |
| `SettingsPhone_SlotMenu_Setup` | [png](../../gfx/previews/screens/SettingsPhone_SlotMenu_Setup.png) | 変更用電話番号選択 (banner); 変更する場所を選択してください; 登録場所 1 2 3; インターネット用; セルフページ用; コメント | Select the phone number to change; Select the place to change; Slot 1 2 3 | `settings/screens_bank4d/tiles_5d70`<br>`settings/screens_bank4d/tiles_6170`<br>`settings/screens_bank4d/tiles_6870`<br>`settings/screens_bank4d/tiles_6d70`<br>`settings/screens_bank4d/tiles_7470`<br>`settings/screens_bank4d/tiles_5d50` | `settings/screens_bank4d/tiles_7470` | yes (100.0 % of static pixels) |
| `PhoneComment_KeyboardSetup` | [png](../../gfx/previews/screens/PhoneComment_KeyboardSetup.png) | コメントを入力してください | Enter a comment | `settings/screens_bank5e/tiles_4000`<br>`settings/screens_bank5e/tiles_4400`<br>`settings/screens_bank4a/tiles_6920`<br>`settings/screens_bank4a/tiles_6d20` | `settings/screens_bank4a/tilemap_72b0` | yes (100.0 % of static pixels) |
| `PhoneKeypad_Setup` | [png](../../gfx/previews/screens/PhoneKeypad_Setup.png) | セルフページ電話番号を入力してください | Enter the self-page phone number | `settings/screens_bank5e/tiles_4000`<br>`settings/screens_bank5e/tiles_4400`<br>`settings/screens_bank4a/tiles_6920`<br>`settings/screens_bank4a/tiles_6d20` | `settings/screens_bank4a/tilemap_7120`<br>`settings/screens_bank4a/tilemap_71e8` | yes (100.0 % of static pixels) |
| `AdapterCheck_DrawScreen` | [png](../../gfx/previews/screens/AdapterCheck_DrawScreen.png) | モバイルアダプタGBを チェックしています | Checking the Mobile Adapter GB | `settings/screens_bank4a/tiles_5f80`<br>`settings/screens_bank4a/tiles_6080`<br>`settings/screens_bank4a/tiles_6480` | `settings/screens_bank4a/tiles_6480` | yes (100.0 % of static pixels) |
| `NoAdapter_DrawScreen` | [png](../../gfx/previews/screens/NoAdapter_DrawScreen.png) | モバイルアダプタGBがささっていません (banner); でんげんスイッチをOFFにして モバイルアダプタGBをさしこみ もういちどONにしてください。 | The Mobile Adapter GB is not plugged in; Turn the power OFF, insert the Mobile Adapter GB, turn the power ON again. | `error/no_adapter/no_adapter_gfx_8000`<br>`error/no_adapter/no_adapter_gfx_8800`<br>`error/no_adapter/no_adapter_gfx_8c00`<br>`error/no_adapter/no_adapter_gfx_9000`<br>`error/no_adapter/no_adapter_gfx_9400` | - | yes (100.0 % of static pixels) |
| `ConnectDialog_Draw_ConnectConfirm` | [png](../../gfx/previews/screens/ConnectDialog_Draw_ConnectConfirm.png) | つうしんせつぞくします (banner); (message is font text); はい いいえ | Connect for communication; Yes; No | `comm/connect_dialog_bank56/tiles_52c0`<br>`comm/connect_dialog_bank56/tiles_56c0` | `comm/connect_dialog_bank56/tilemap_4f9a`<br>`comm/connect_dialog_bank56/tiles_526a` | yes (100.0 % of static pixels) |
| `ConnectDialog_Draw_PasswordEntry` | [png](../../gfx/previews/screens/ConnectDialog_Draw_PasswordEntry.png) | パスワードをにゅうりょくしてください (banner) | Enter the password | `comm/connect_dialog_bank56/tiles_5ac0`<br>`comm/connect_dialog_screen/connect_dialog_blank_tile`<br>`comm/connect_dialog_bank56/tiles_5dc0`<br>`comm/connect_dialog_bank56/tiles_60c0` | `comm/connect_dialog_bank56/tilemap_418a` | yes (97.5 % of static pixels) |
| `ConnectDialog_Draw_SavePasswordConfirm` | [png](../../gfx/previews/screens/ConnectDialog_Draw_SavePasswordConfirm.png) | パスワードをほぞんします (banner); する しない | Save the password; Yes; No | `comm/connect_dialog_bank56/tiles_5ac0`<br>`comm/connect_dialog_screen/connect_dialog_blank_tile`<br>`comm/connect_dialog_bank56/tiles_5dc0`<br>`comm/connect_dialog_bank56/tiles_60c0` | `comm/connect_dialog_bank56/tilemap_418a`<br>`comm/connect_dialog_bank56/tilemap_49fa` | yes (91.4 % of static pixels) |
| `ConnectDialog_Draw_PasswordSaved` | [png](../../gfx/previews/screens/ConnectDialog_Draw_PasswordSaved.png) | パスワードをほぞんしました (banner); B もどる | Password saved; B: Back | `comm/connect_dialog_bank56/tiles_6ec0`<br>`comm/connect_dialog_bank56/tiles_71c0` | `comm/connect_dialog_bank56/tilemap_4cca` | no capture |
| `ConnectDialog_Draw_StoredPassword` | [png](../../gfx/previews/screens/ConnectDialog_Draw_StoredPassword.png) | パスワードがほぞんされています (banner); セレクト パスワードのほぞんをやめる | A password is stored; Select: stop saving the password | `comm/connect_dialog_bank56/tiles_64c0`<br>`comm/connect_dialog_bank56/tiles_6ac0` | `comm/connect_dialog_bank56/tilemap_445a` | yes (100.0 % of static pixels) |
| `HelpMenu_ShowPage` | [png](../../gfx/previews/screens/HelpMenu_ShowPage.png) | ヘルプ (banner); topic buttons モバイルトレーナー, メールって?, ???? (locked), モバイルじてん (seen in emulator screenshots; the buttons are drawn by HelpMenu_DrawItem*, which the static scene does not resolve); the ticker at the bottom is font text | Help; Mobile Trainer; What is mail?; ????; Mobile Dictionary | `help/help_screens_a/tiles_4e90`<br>`help/help_screens_a/tiles_5290`<br>`help/help_screens_a/tiles_5690`<br>`help/help_screens_a/tiles_5a90`<br>`help/help_screens_a/tiles_5ab0`<br>`help/help_screens_a/tiles_5eb0` | `help/help_screens_a/tilemap_4000`<br>`help/help_screens_a/tilemap_42d0`<br>`help/help_screens_a/tilemap_45a0` | yes (100.0 % of static pixels) |
| `HelpScript_Run` | [png](../../gfx/previews/screens/HelpScript_Run.png) | A すすむ B もどる セレクト おわる | A: Next, B: Back, Select: Quit | `help/help_screens_b/tiles_69f0`<br>`help/help_screens_b/tiles_6a10`<br>`help/help_screens_b/tiles_6a20` | `help/help_screens_b/tilemap_6716` | yes (100.0 % of static pixels) |
| `MobileDict_Redraw` | [png](../../gfx/previews/screens/MobileDict_Redraw.png) | モバイルじてん (banner); ア カ サ タ ナ ハ マ ヤ ラ ワ ABC (tabs); A すすむ B もどる | Mobile Dictionary; tabs; A: Next, B: Back | `help/mobile_dictionary/mobile_dict_tiles0`<br>`help/mobile_dictionary/mobile_dict_tiles1`<br>`help/mobile_dictionary/mobile_dict_tiles2` | `help/mobile_dictionary/mobile_dict_screen` | yes (100.0 % of static pixels) |
| `Browser_StartChoiceScreen` | [png](../../gfx/previews/screens/Browser_StartChoiceScreen.png) | ホームページ (banner and button); ページリスト (button) | Home Page; Page List | `browser/start_choice/browser_start_tiles0`<br>`browser/start_choice/browser_start_tiles1`<br>`browser/start_choice/browser_start_tiles2`<br>`browser/start_choice/browser_start_tiles3`<br>`browser/start_choice/browser_start_tiles4` | `browser/start_choice/browser_start_map` | yes (100.0 % of static pixels) |
| `BrowserMenu_OpenThreeItem` | [png](../../gfx/previews/screens/BrowserMenu_OpenThreeItem.png) | icons (page-list, X, END); captions in the tile sheet (see inventory) | - | `browser/menus/browser_menu3_tiles0`<br>`browser/menus/browser_menu3_tiles1` | `browser/menus/browser_menu3_map` | yes (100.0 % of static pixels) |
| `BrowserFrame_Styles0` | [png](../../gfx/previews/screens/BrowserFrame_Styles0.png) | スタート メニュー B 戻る (legend) | Start: Menu, B: Back | (table-driven or none) | - | yes (100.0 % of static pixels); descriptor-driven |
| `BrowserFrame_Styles1` | [png](../../gfx/previews/screens/BrowserFrame_Styles1.png) | スタート メニュー B もどる (legend) | Start: Menu, B: Back | (table-driven or none) | - | yes (100.0 % of static pixels); descriptor-driven |
| `BrowserFrame_Styles2` | [png](../../gfx/previews/screens/BrowserFrame_Styles2.png) | A すすむ B もどる セレクト おわる (legend) | A: Next, B: Back, Select: Quit | (table-driven or none) | - | yes (100.0 % of static pixels); descriptor-driven |
| `BrowserFrame_Styles3_to_22` | [png](../../gfx/previews/screens/BrowserFrame_Styles3_to_22.png) | A すすむ B もどる セレクト おわる (legend) | (same) | (table-driven or none) | - | yes (100.0 % of static pixels); descriptor-driven |
| `BrowserFrame_Styles23_to_26` | [png](../../gfx/previews/screens/BrowserFrame_Styles23_to_26.png) | スタート メニュー B もどる (legend) | (same as style 1) | (table-driven or none) | - | yes (100.0 % of static pixels); descriptor-driven |
| `PageList_InitScreen` | [png](../../gfx/previews/screens/PageList_InitScreen.png) | icons only | - | `browser/page_list/page_list_tiles_5400`<br>`browser/page_list/page_list_tiles_5800` | `browser/page_list/page_list_tilemap_5900`<br>`browser/page_list/page_list_tilemap_5bd0` | yes (100.0 % of static pixels) |
| Help_TutorialWelcome (no scene) | - | "ようこそ!" (welcome picture, tutorial page; seen in a screenshot); the explanation text is font text | Welcome! | - | - | see note |

Screens composed but without text pictures of their own (only art, icons, frames or text drawn at run time): `SettingsMenu_DrawItems`, `BrowserMenu_OpenTwoItem`, `BrowserStart_DrawButtons`, `CommScene_LoadGraphics`, `ConnectDialog_Draw_ForgetConfirm`, `ConnectDialog_DrawPasswordField`, `Dialog_Open`, `Dialog_OpenTall`, `CommErr_FindRecord`, `CommErr_DrawMessage_TimerVariant`, `CommErr_DrawMessage_PlainVariant`, `CommErr_PrintMessage`, `CommErr_UpdateCommFooter`, `Kbd_LoadPageGraphics_TypeTable`, `Table_Kbd_T6_PageLoaders_Page3`, `Table_Kbd_T78_PageLoaders_Page3`, `MailConnect_Screen_Loop`, `MailDisconnect_Screen`, `MailDisconnect_ScreenNoTimer`, `MailSrvDelHidden_MenuSelect`, `MailSrvDel_MenuSelect`, `MailServerMgr_Run`, `MailServerMgr_DrawMailInfo`, `MailMenu_AnimateIcon`, `TopMenu_LoadPanel`, `TopMenu_AnimatePanel`, `Notice_ShowPage`, `PageListProto_InitScreen`.

### 2.1 Unused frame records (banks 41-46) and bank-47 record 3

Twenty-four records of the same layout as the browser frame styles exist in banks 41-46 and one more in bank 47 (`47:68F0`); nothing loads them (the frame descriptors `4E:654B` reference only bank-47 records; the layout for 41-46 is **HYPOTHESIS by analogy**, `gfx/previews/screens/BrowserFrameUnused_*.png`).  Their legends mix three languages of ink: Japanese kana (スタート ▶メニュー / B ▶モドル, スタート メニュー / B もどる), Latin (START MENU / B BACK) and mixed forms.  Per record (reading of the previews): see the rows 67-104 and 140 of section 3.  They are pure picture data; changing them changes nothing the game shows unless something selects them.

## 3. All tile assets

Columns: `#` = order of the listing (path order); `asset` = PNG under `gfx/` (the `.2bpp` next to it is what the ROM contains); `bank:addr` = original ROM position; `tiles` = tile count (PNG layout in tiles); `loaded` = loader routine, VRAM destination (`@8800b1` = VRAM $8800, bank 1; `src+N` = the block is read from an offset inside a larger loaded block), or `-` when no load site is known; `class` and `what it shows` as described in section 1.

| # | asset | bank:addr | tiles (WxH) | loaded by | class | what it shows (reading; pieces unless stated) |
|---:|---|---|---|---|---|---|
| 1 | `account/screens_bank4a/tiles_4040` | 4A:4040 | 32 (16x2) | SettingsMenu_StateInit@8000b1 | ART | cursor arrow + blank tiles |
| 2 | `account/screens_bank4a/tiles_4240` | 4A:4240 | 64 (16x4) | SettingsMenu_StateInit@8800b1 | TXT | settings-menu item labels, outlined text, one stream over 4240/4640/4A40: パスワードの変更 / ご利用時間の確認 / ご利用額の確認 / 登録情報の削除 / 電話番号の変更 (reading of the stream, PROBABLE) |
| 3 | `account/screens_bank4a/tiles_4640` | 4A:4640 | 64 (16x4) | SettingsMenu_StateInit@8C00b1 | TXT | continuation of the settings-menu label stream (see 4A:4240): ...報の削除 / 電話番号の変更 / パスワードの変更 ... |
| 4 | `account/screens_bank4a/tiles_4a40` | 4A:4A40 | 64 (16x4) | SettingsMenu_StateInit@9000b1 | TXT | continuation of the settings-menu label stream (4A:4240 .. 4A:4A40) |
| 5 | `account/screens_bank4a/tiles_4e40` | 4A:4E40 | 64 (16x4) | SettingsMenu_StateInit@9400b1 | MIX | title image "モバイルせってい" + button legend "＋選ぶ" "A決定" "B戻る" + small icons |
| 6 | `account/screens_bank4a/tiles_5860` | 4A:5860 | 1 (1x1) | - | UNK | 1 tile, not classified |
| 7 | `account/screens_bank4a/tiles_5870` | 4A:5870 | 64 (16x4) | Account_ConfirmManualScreen_Setup@9000b1 | TXT | labels "ログインID" "メールアドレス" "コメント" "インターネット用" "セルフページ用" (confirm page of manual registration) |
| 8 | `account/screens_bank4a/tiles_5c70` | 4A:5C70 | 4 (4x1) | - | ERR | typed as tiles, label says palette (Palette_Account_ConfirmManualScreen_Bg): palette bytes, not art |
| 9 | `account/screens_bank4b/tiles_42d0` | 4B:42D0 | 64 (16x4) | Account_ResultPage@8800b1 | TXT | "通信を終了しました" / "通信時間は　分　秒でした" text + digits 0-9 (result page; digits are placed by the code) |
| 10 | `account/screens_bank4b/tiles_46d0` | 4B:46D0 | 64 (16x4) | Account_ResultPage@8C00b1 | TXT | title banners "初期登録終了" and "パスワード…変更終了" (partly read) |
| 11 | `account/screens_bank4b/tiles_5080` | 4B:5080 | 56 (14x4) | - | TXT | fragments "モバイルせってい" "メニュー" (PROBABLE), frame art |
| 12 | `account/screens_bank4b/tiles_5420` | 4B:5420 | 69 (16x5) | - | MIX | "A WELCOMEメッセージ" label (A button icon + text) and frame art |
| 13 | `account/screens_bank4b/tiles_5878` | 4B:5878 | 2 (2x1) | - | UNK | 2 tiles, not classified |
| 14 | `account/screens_bank5d/tiles_4800` | 5D:4800 | 64 (16x4) | Account_PasswordEntry_Setup@9000b1 | TXT | button legend "＋選ぶ A書く B消す 戻る / OK 次へ" + prompt "パスワードを入力してください" |
| 15 | `account/screens_bank5d/tiles_4c00` | 5D:4C00 | 64 (16x4) | Account_PasswordEntry_Setup@9400b1 | TXT | "確認のため同じパスワードを入力してください" (confirmation prompt); more fragments unreadable |
| 16 | `account/screens_bank5d/tiles_5320` | 5D:5320 | 64 (16x4) | Account_PasswordIntro_Draw@9000b1 | TXT | legend "A次へ B戻る", example "例 AbCd1234", title "パスワード…" |
| 17 | `account/screens_bank5d/tiles_5720` | 5D:5720 | 64 (16x4) | Account_PasswordIntro_Draw@9400b1 | UNK | almost empty (few fragments) |
| 18 | `account/screens_bank5d/tiles_5df0` | 5D:5DF0 | 64 (16x4) | Account_ConfirmScreen_Setup@8800b1 | TXT | legend "＋選ぶ A決定 B戻る" + banner "次の情報をモバイルアダプタGBに登録します" |
| 19 | `account/screens_bank5d/tiles_61f0` | 5D:61F0 | 32 (16x2) | Account_ConfirmScreen_Setup@8C00b1 | TXT | buttons "はい" "いいえ" + "よろしいですか?" |
| 20 | `account/screens_bank5d/tiles_63f0` | 5D:63F0 | 32 (16x2) | Account_ConfirmScreen_Setup@9000b1 | TXT | labels "ログインID" "メールアドレス" |
| 21 | `account/screens_bank5d/tiles_65f0` | 5D:65F0 | 4 (4x1) | - | ERR | typed as tiles, label says palette (Palette_Account_ConfirmScreen_Bg) |
| 22 | `account/screens_bank5d/tiles_6900` | 5D:6900 | 48 (16x3) | Registration_WriteConfig_Setup@8800b1 (src+100) | TXT | title banner "アダプタ登録中" |
| 23 | `account/screens_bank5d/tiles_6c00` | 5D:6C00 | 32 (16x2) | - | TXT | "設定情報を登録中です" + "注意" tag |
| 24 | `account/screens_bank5d/tiles_6e00` | 5D:6E00 | 64 (16x4) | Registration_WriteConfig_Setup@9000b1 | ART | progress-bar pattern tiles + fragments |
| 25 | `account/screens_bank5e/tiles_4800` | 5E:4800 | 64 (16x4) | Account_LoginIdEntry_Setup@9000b1 | TXT | legend "＋選ぶ A書く B消す 戻る / OK 次へ" + prompt "ログインIDを入力してください" |
| 26 | `account/screens_bank5e/tiles_4c00` | 5E:4C00 | 16 (16x1) | Account_LoginIdEntry_Setup@9400b1 | TXT | tail of the prompt ("…ださい") |
| 27 | `account/screens_bank5e/tiles_4e10` | 5E:4E10 | 64 (16x4) | Account_LoginIdIntro_Draw@9000b1 | TXT | legend "A次へ B戻る", example "例 g123456789", banner "ログインID入力" |
| 28 | `account/screens_bank5e/tiles_5210` | 5E:5210 | 64 (16x4) | Account_LoginIdIntro_Draw@9400b1 | TXT | banner tail "…ンID入力" |
| 29 | `account/screens_bank5e/tiles_57e0` | 5E:57E0 | 2 (2x1) | Kbd_LoadPageGraphics_TypeTable@8800 | KBD | 2 tiles of keyboard type 1 (Gfx_Kbd_T1_Tiles8800) |
| 30 | `account/screens_bank5e/tiles_5800` | 5E:5800 | 64 (16x4) | Account_MailAddressEntry_Setup@9000b1 | TXT | legend + prompt "メールアドレスを入力してください" |
| 31 | `account/screens_bank5e/tiles_5c00` | 5E:5C00 | 64 (16x4) | Account_MailAddressEntry_Setup@9400b1 | TXT | prompt tail "してください" + ".dion.ne.jp" and "@" |
| 32 | `account/screens_bank5e/tiles_60d0` | 5E:60D0 | 64 (16x4) | Account_MailIntro_Draw@9000b1 | TXT | legend "A次へ B戻る", example "例 ninten88@gbaa.dion.ne.jp" |
| 33 | `account/screens_bank5e/tiles_64d0` | 5E:64D0 | 64 (16x4) | Account_MailIntro_Draw@9400b1 | TXT | "ne.jp", banner "メールアドレス入力" |
| 34 | `account/screens_bank5e/tiles_6ba0` | 5E:6BA0 | 64 (16x4) | Account_ActionConfirmPage_Setup@9000b1 | TXT | legend "＋選ぶ A決定 B戻る" + banner "通信開始確認" |
| 35 | `account/screens_bank5e/tiles_6fa0` | 5E:6FA0 | 64 (16x4) | Account_ActionConfirmPage_Setup@9400b1 | TXT | "DIONに接続します" "よろしいですか?" + buttons "はい" "いいえ" |
| 36 | `account/screens_bank71/tiles_4000` | 71:4000 | 48 (16x3) | CommPanel_StateDraw@8800b1 (src+200) | ART | panel art of the connection screen (ball, frame); no readable text |
| 37 | `account/screens_bank71/tiles_4300` | 71:4300 | 32 (16x2) | CommPanel_StateDraw@9000b1 (src+190) | TXT | fragments of the banner "DIONに接続中" |
| 38 | `account/screens_bank71/tiles_4500` | 71:4500 | 57 (16x4) | - | TXT | status texts "電話をかけています" "DIONに接続中です" (partly read) + "注意" tag |
| 39 | `account/screens_bank71/tiles_4890` | 71:4890 | 64 (16x4) | CommPanel_StateDraw@9400b1 | TXT | status-label fragments (partly: 切断, パスワード, 変更, 利用時間); unreadable as a sheet |
| 40 | `account/screens_bank71/tiles_5340` | 71:5340 | 64 (16x4) | Registration_DeleteConfirm_Setup@9000b1 | TXT | legend + banner "削除確認" + "よろしいですか?" |
| 41 | `account/screens_bank71/tiles_5740` | 71:5740 | 64 (16x4) | Registration_DeleteConfirm_Setup@9400b1 | TXT | "登録情報を削除します" + button "はい" |
| 42 | `account/screens_bank71/tiles_5b40` | 71:5B40 | 40 (10x4) | - | TXT | "削除確認" / "削除した情報" fragments |
| 43 | `account/screens_bank71/tiles_5dc0` | 71:5DC0 | 64 (16x4) | Registration_DeleteConfirm_Setup@9400b1 | TXT | "…は元に戻せません" "本当によろしいですか?" + buttons "はい" "いいえ" |
| 44 | `account/screens_bank71/tiles_61c0` | 71:61C0 | 40 (10x4) | - | TXT | "削除中" / "情報を削除中です" fragments |
| 45 | `account/screens_bank71/tiles_6440` | 71:6440 | 20 (10x2) | - | TXT | fragments of "登録情報を削除…" |
| 46 | `account/screens_bank71/tiles_6580` | 71:6580 | 16 (16x1) | Registration_DeleteExecute_Setup@9000b1 | ART | animation strip, no text seen |
| 47 | `address_book/address_picker/addr_book_tiles8f00` | 2C:6C30 | 9 (9x1) | AddrPick_InitScreen@8F00 | ART | mostly blank tiles |
| 48 | `address_book/address_picker/addr_pick_tiles9300` | 2C:6730 | 64 (16x4) | AddrPick_InitScreen@9300b1 | TXT | banner "アドレスちょう" + list/frame art |
| 49 | `address_book/address_picker/addr_pick_tiles9700` | 2C:6B30 | 16 (16x1) | AddrPick_InitScreen@9700b1 | ART | blank tiles |
| 50 | `address_book/address_picker/tiles_6fd0` | 2C:6FD0 | 32 (16x2) | - | ART | icons |
| 51 | `address_book/entry_screen_bank29/tiles_5b10` | 29:5B10 | 48 (16x3) | AbookAddr_SetupScreen@8000 | ART | pen icons, small label fragments (unreadable) |
| 52 | `address_book/entry_screen_bank29/tiles_5e50` | 29:5E50 | 64 (16x4) | AbookView_SetupScreen@9300b1 | TXT | banner "アドレスちょう" + labels "ニックネーム" "アドレス" |
| 53 | `address_book/entry_screen_bank29/tiles_6250` | 29:6250 | 4 (4x1) | AbookView_SetupScreen@9700b1 | UNK | 4 tiles, not classified |
| 54 | `address_book/entry_screen_bank2a/addr_book_entry_tiles8000` | 2A:7DD0 | 11 (11x1) | AbookView_SetupScreen@8000 | TXT | footer strip (legend "B もどる" of the view screen, PROBABLE) |
| 55 | `address_book/entry_screen_bank2a/addr_book_entry_tiles8f00` | 2A:7CF0 | 14 (14x1) | AbookView_SetupScreen@8F00 | TXT | footer strip (legend, PROBABLE) |
| 56 | `address_book/name_editor/tiles_61f0` | 2F:61F0 | 64 (16x4) | AbookName_SetupScreen@9300b1 | TXT | banner "アドレスちょう" + label "ニックネーム" |
| 57 | `address_book/name_editor/tiles_65f0` | 2F:65F0 | 16 (16x1) | AbookName_SetupScreen@9700b1 | TXT | fragments (unreadable) |
| 58 | `address_book/name_editor/tiles_66f0` | 2F:66F0 | 48 (16x3) | AbookName_SetupScreen@8800 | TXT | legend "A キーボード" "B もどる" (round A/B icons) |
| 59 | `address_book/save_confirm/addr_save_confirm_tiles9300` | 2A:75E0 | 64 (16x4) | AddrBook_SaveConfirm_InitScreen@9300b1 | TXT | banner "アドレスちょう" + labels "ニックネーム" "アドレス" |
| 60 | `address_book/save_confirm/addr_save_confirm_tiles9700` | 2A:79E0 | 4 (4x1) | AddrBook_SaveConfirm_InitScreen@9700b1 | UNK | 4 tiles, not classified |
| 61 | `address_book/save_sender_address/save_sender_addr_tiles9300` | 2A:4AA0 | 35 (16x3) | SaveSenderAddr_InitScreen@9300b1 | TXT | banner "アドレスちょう" (parts) + icons |
| 62 | `address_book/save_sender_address/tiles_4fe0` | 2A:4FE0 | 32 (16x2) | - | ART | icons |
| 63 | `address_book/shared_tiles_bank28/tiles_4bd0` | 28:4BD0 | 64 (16x4) | AddrPick_InitScreen@8000 | ART | address-book list icons, buttons |
| 64 | `address_book/shared_tiles_bank28/tiles_4fd0` | 28:4FD0 | 32 (16x2) | AddrPick_InitScreen@8400 | TXT | one text strip, unreadable |
| 65 | `address_book/unreferenced_confirm_screen/tiles_7740` | 2C:7740 | 18 (9x2) | AddrScreenUnused_InitScreen@9300b1 | TXT | labels "みる" "かく" "START" (unused confirm screen) |
| 66 | `address_book/unreferenced_confirm_screen/tiles_7b70` | 2C:7B70 | 9 (9x1) | AddrScreenUnused_InitScreen@8000 | UNK | 9 tiles of the unused screen, not classified |
| 67 | `bank41/tiles_4000` | 41:4000 | 160 (16x10) | - | FRM | unused frame record 41/0: katakana legend "スタート▶メニュー / B ▶モドル"; digits font 0-9 and ":" |
| 68 | `bank41/tiles_4d50` | 41:4D50 | 160 (16x10) | - | FRM | unused frame record 41/1: Latin legend "START MENU / B BACK"; digits |
| 69 | `bank41/tiles_5aa0` | 41:5AA0 | 160 (16x10) | - | FRM | unused frame record 41/2: legend "START メニュー B モドル"; digits |
| 70 | `bank41/tiles_67f0` | 41:67F0 | 160 (16x10) | - | FRM | unused frame record 41/3: legend "START メニュー B モドル"; digits |
| 71 | `bank42/tiles_4000` | 42:4000 | 84 (14x6) | - | FRM | unused frame block 42 (first, 1344 bytes): Latin legend "START MENU / B BACK" (Latin text seen at 42:4000) |
| 72 | `bank42/tiles_4802` | 42:4802 | 10 (10x1) | - | UNK | tile pieces of bank 42 (HYPOTHESIS typing): digits-like strip |
| 73 | `bank42/tiles_4900` | 42:4900 | 11 (11x1) | - | UNK | tile pieces of bank 42 (HYPOTHESIS typing): digits-like strip |
| 74 | `bank42/tiles_4d50` | 42:4D50 | 27 (9x3) | - | FRM | unused frame record 42/1 (part): art and legend "スタート メニュー / Bボタンもどる" (reading of the preview) |
| 75 | `bank42/tiles_4f00` | 42:4F00 | 60 (15x4) | - | FRM | unused frame record 42/1 (part) |
| 76 | `bank42/tiles_52c0` | 42:52C0 | 2 (2x1) | - | UNK | 2 tiles (HYPOTHESIS typing) |
| 77 | `bank42/tiles_52e0` | 42:52E0 | 71 (16x5) | - | FRM | unused frame record 42/1 (part): digits "012345678" + art |
| 78 | `bank42/tiles_5aa0` | 42:5AA0 | 59 (16x4) | - | FRM | unused frame record 42/2: legend "スタート メニュー / B もどる" |
| 79 | `bank42/tiles_5e90` | 42:5E90 | 13 (13x1) | - | UNK | tile pieces of bank 42 (HYPOTHESIS typing) |
| 80 | `bank42/tiles_5f92` | 42:5F92 | 26 (13x2) | - | FRM | unused frame record 42/2 (part): "もどる" legend piece |
| 81 | `bank42/tiles_62a0` | 42:62A0 | 10 (10x1) | - | UNK | tile pieces of bank 42 (HYPOTHESIS typing): digits-like strip |
| 82 | `bank42/tiles_63a0` | 42:63A0 | 1 (1x1) | - | UNK | 1 tile (HYPOTHESIS typing) |
| 83 | `bank42/tiles_63b0` | 42:63B0 | 15 (15x1) | - | FRM | unused frame record 42/3 (part) |
| 84 | `bank42/tiles_67f0` | 42:67F0 | 1 (1x1) | - | UNK | 1 tile (HYPOTHESIS typing) |
| 85 | `bank42/tiles_6810` | 42:6810 | 25 (16x2) | - | FRM | unused frame record 42/3 (part): art |
| 86 | `bank42/tiles_69b0` | 42:69B0 | 49 (16x4) | - | FRM | unused frame record 42/3: legend "START メニュー B モドル" |
| 87 | `bank42/tiles_6ff2` | 42:6FF2 | 10 (10x1) | - | UNK | tile pieces of bank 42 (HYPOTHESIS typing): digits-like strip |
| 88 | `bank42/tiles_70f0` | 42:70F0 | 10 (10x1) | - | UNK | tile pieces of bank 42 (HYPOTHESIS typing): digits-like strip |
| 89 | `bank43/tiles_4000` | 43:4000 | 160 (16x10) | - | FRM | unused frame record 43/0: legend "START メニュー B もどる"; digits |
| 90 | `bank43/tiles_4d50` | 43:4D50 | 160 (16x10) | - | FRM | unused frame record 43/1: Latin legend "START MENU B BACK"; digits |
| 91 | `bank43/tiles_5aa0` | 43:5AA0 | 160 (16x10) | - | FRM | unused frame record 43/2: legend "スタート メニュー B もどる"; digits |
| 92 | `bank43/tiles_67f0` | 43:67F0 | 160 (16x10) | - | FRM | unused frame record 43/3: Latin legend "START MENU B BACK"; digits |
| 93 | `bank44/tiles_4000` | 44:4000 | 160 (16x10) | - | FRM | unused frame record 44/0: Latin legend "START ▶MENU / B ▶BACK"; digits |
| 94 | `bank44/tiles_4d50` | 44:4D50 | 160 (16x10) | - | FRM | unused frame record 44/1: katakana legend "メニュー / B モドル"; digits |
| 95 | `bank44/tiles_5aa0` | 44:5AA0 | 160 (16x10) | - | FRM | unused frame record 44/2: legend "スタート▶メニュー / B ▶モドル"; digits |
| 96 | `bank44/tiles_67f0` | 44:67F0 | 160 (16x10) | - | FRM | unused frame record 44/3: Latin legend "START MENU / B BACK"; digits |
| 97 | `bank45/tiles_4000` | 45:4000 | 160 (16x10) | - | FRM | unused frame record 45/0: legend "スタート▶メニュー B▶モドル"; digits |
| 98 | `bank45/tiles_4d50` | 45:4D50 | 160 (16x10) | - | FRM | unused frame record 45/1: mixed legend ("START" + "メニュー" "モドル"); digits |
| 99 | `bank45/tiles_5aa0` | 45:5AA0 | 160 (16x10) | - | FRM | unused frame record 45/2: Latin legend "START MENU / B BACK"; digits |
| 100 | `bank45/tiles_67f0` | 45:67F0 | 160 (16x10) | - | FRM | unused frame record 45/3: legend "スタート▶メニュー / B ▶モドル"; digits |
| 101 | `bank46/tiles_4000` | 46:4000 | 160 (16x10) | - | FRM | unused frame record 46/0: legend "スタート▶メニュー B▶もどる"; digits |
| 102 | `bank46/tiles_4d50` | 46:4D50 | 160 (16x10) | - | FRM | unused frame record 46/1: legend "スタート メニュー / B モドル"; digits |
| 103 | `bank46/tiles_5aa0` | 46:5AA0 | 160 (16x10) | - | FRM | unused frame record 46/2: mixed legend ("メニュー" "START" "もどる" B); digits |
| 104 | `bank46/tiles_67f0` | 46:67F0 | 160 (16x10) | - | FRM | unused frame record 46/3: Latin legend "START ▶MENU B ▶BACK"; digits |
| 105 | `bank52/tiles_4080` | 52:4080 | 184 (8x23) | PageListProto_ShowMessage@9580b1 | TXT | four pre-rendered message images (40 tiles each + 8 padding tiles) copied by the unreferenced PageListProto_ShowMessage; kana fragments only, tile order inside an image not reconstructed (unreadable) |
| 106 | `bank5b/tiles_4000` | 5B:4000 | 288 (16x18) | - | MIX | logo/credit-like sheet: the Latin word "GAMEFREAK" (small, repeated), katakana fragments ("モバイル…ム…"), window frames; no loader found |
| 107 | `bank5b/tiles_5200` | 5B:5200 | 72 (12x6) | - | MIX | box labelled "メールサーバ" (PROBABLE) + frames; no loader found |
| 108 | `bank60/tiles_4360` | 60:4360 | 15 (15x1) | - | UNK | strip, unreadable; no loader found |
| 109 | `bank60/tiles_4455` | 60:4455 | 71 (16x5) | - | ART | scenery-like art with fragments; no loader found |
| 110 | `bank60/tiles_4b50` | 60:4B50 | 35 (16x3) | - | UNK | unreadable; no loader found |
| 111 | `bank60/tiles_4dd0` | 60:4DD0 | 74 (16x5) | - | UNK | frames + text fragments, unreadable; no loader found |
| 112 | `bank60/tiles_52c0` | 60:52C0 | 1 (1x1) | - | UNK | 1 tile (HYPOTHESIS typing) |
| 113 | `bank60/tiles_52d0` | 60:52D0 | 55 (11x5) | - | UNK | frames + text fragments, unreadable; no loader found |
| 114 | `bank60/tiles_5640` | 60:5640 | 11 (11x1) | - | UNK | strip, unreadable; no loader found |
| 115 | `bank60/tiles_5740` | 60:5740 | 7 (7x1) | - | UNK | HYPOTHESIS typing |
| 116 | `bank60/tiles_5800` | 60:5800 | 48 (16x3) | - | UNK | text fragments, unreadable; no loader found |
| 117 | `bank60/tiles_5d50` | 60:5D50 | 44 (11x4) | - | UNK | frames with text fragments, unreadable; no loader found |
| 118 | `bank60/tiles_6010` | 60:6010 | 5 (5x1) | - | UNK | HYPOTHESIS typing |
| 119 | `bank60/tiles_6060` | 60:6060 | 37 (16x3) | - | UNK | text fragments, unreadable; no loader found |
| 120 | `bank60/tiles_62b0` | 60:62B0 | 28 (14x2) | - | UNK | art fragments, unreadable; no loader found |
| 121 | `bank60/tiles_64c0` | 60:64C0 | 7 (7x1) | - | UNK | HYPOTHESIS typing |
| 122 | `bank60/tiles_6580` | 60:6580 | 8 (8x1) | - | UNK | strip, unreadable; no loader found |
| 123 | `bank60/tiles_6640` | 60:6640 | 166 (16x11) | - | MIX | help/tutorial-like sheet with the button label "A ジャンプ" (A jump), boxes and kana fragments; no loader found |
| 124 | `bank60/tiles_70a0` | 60:70A0 | 101 (16x7) | - | MIX | sheet with the button label "B もどる" and "XXXさん" (placeholder-like name, PROBABLE reading) and kana fragments; no loader found |
| 125 | `bank60/tiles_76f0` | 60:76F0 | 57 (16x4) | - | UNK | art, unreadable; no loader found |
| 126 | `bank61/tiles_4cc0` | 61:4CC0 | 42 (14x3) | - | MIX | fragment "＋ボタン" (+ button) and frames; no loader found |
| 127 | `bank61/tiles_4f63` | 61:4F63 | 41 (16x3) | - | UNK | art/text fragments, unreadable; no loader found |
| 128 | `bank61/tiles_58b0` | 61:58B0 | 41 (16x3) | - | UNK | art/text fragments, unreadable; no loader found |
| 129 | `bank61/tiles_65c0` | 61:65C0 | 50 (10x5) | - | UNK | frames with text fragments, unreadable; no loader found |
| 130 | `browser/frames_0_1/tiles_4000` | 47:4000 | 1 (1x1) | Browser_LoadScrollbarGfx@8FF0 | ART | scrollbar piece |
| 131 | `browser/frames_0_1/tiles_4010` | 47:4010 | 3 (3x1) | Browser_LoadScrollbarGfx@97D0 | ART | scrollbar piece |
| 132 | `browser/frames_0_1/tiles_4040` | 47:4040 | 4 (4x1) | - | UNK | 4 tiles, not classified |
| 133 | `browser/frames_0_1/tiles_4080` | 47:4080 | 1 (1x1) | Browser_LoadScrollbarGfx@8FF0 | ART | scrollbar piece |
| 134 | `browser/frames_0_1/tiles_4090` | 47:4090 | 3 (3x1) | Browser_LoadScrollbarGfx@97D0 | ART | scrollbar piece |
| 135 | `browser/frames_0_1/tiles_40c0` | 47:40C0 | 1 (1x1) | Browser_LoadScrollbarGfx@8FF0 | ART | scrollbar piece |
| 136 | `browser/frames_0_1/tiles_40d0` | 47:40D0 | 3 (3x1) | Browser_LoadScrollbarGfx@97D0 | ART | scrollbar piece |
| 137 | `browser/frames_0_1/tiles_4100` | 47:4100 | 160 (16x10) | - | FRM | browser frame style 0 (grey): legend "スタート メニュー B 戻る"; digits 0-9 ":" and a triangle |
| 138 | `browser/frames_0_1/tiles_4e50` | 47:4E50 | 160 (16x10) | - | FRM | browser frame style 1 and 23-26 (blue): legend "スタート メニュー B もどる"; digits |
| 139 | `browser/frames_2_3/tiles_5ba0` | 47:5BA0 | 160 (16x10) | - | FRM | browser frame styles 2-22 (green): legend "A すすむ B もどる セレクト おわる"; digits |
| 140 | `browser/frames_2_3/tiles_68f0` | 47:68F0 | 160 (16x10) | - | FRM | frame record 3 of bank 47, not used by any descriptor: katakana legend "スタート メニュー B モドル" |
| 141 | `browser/menus/browser_menu2_tiles0` | 72:7220 | 64 (16x4) | BrowserMenu_OpenTwoItem@8800b1 | TXT | browser menu captions "ブックマーク" "せつ…" "やめる" (middle one not certain) + icons (page-list, X, END) |
| 142 | `browser/menus/browser_menu2_tiles1` | 72:7620 | 16 (16x1) | BrowserMenu_OpenTwoItem@8F00b1 | ART | arrows |
| 143 | `browser/menus/browser_menu3_tiles0` | 72:6C10 | 64 (16x4) | Browser_LoadFrameGraphics@8800b1 | TXT | browser menu captions "ページリスト" "せつ…" "やめる" + icons (page-list, X, "END") |
| 144 | `browser/menus/browser_menu3_tiles1` | 72:7010 | 16 (16x1) | BrowserMenu_OpenThreeItem@8F00b1 | ART | arrows |
| 145 | `browser/page_list/page_list_tiles_5400` | 24:5400 | 29 (16x2) | PageList_InitScreen@9300b1 | TXT | title image "ページリスト" |
| 146 | `browser/page_list/page_list_tiles_5800` | 24:5800 | 1 (1x1) | PageList_InitScreen@9700b1 | UNK | 1 tile |
| 147 | `browser/page_list/tiles_55d0` | 24:55D0 | 35 (16x3) | - | ART | icons |
| 148 | `browser/page_list/tiles_5810` | 24:5810 | 10 (10x1) | - | UNK | 10 tiles, not classified |
| 149 | `browser/page_list/tiles_5ef1` | 24:5EF1 | 62 (16x4) | - | ART | icons and list art |
| 150 | `browser/page_list/tiles_6301` | 24:6301 | 12 (12x1) | - | UNK | 12 tiles, not classified |
| 151 | `browser/page_list/tiles_63e0` | 24:63E0 | 16 (16x1) | - | ART | icon strip |
| 152 | `browser/start_choice/browser_start_tiles0` | 73:45E0 | 64 (16x4) | Browser_StartChoiceScreen@8000 | ART | start-menu scenery (globe etc.), no text |
| 153 | `browser/start_choice/browser_start_tiles1` | 73:4DE0 | 64 (16x4) | Browser_StartChoiceScreen@8800 | ART | start-menu scenery |
| 154 | `browser/start_choice/browser_start_tiles2` | 73:51E0 | 64 (16x4) | Browser_StartChoiceScreen@8C00 | ART | start-menu scenery |
| 155 | `browser/start_choice/browser_start_tiles3` | 73:55E0 | 64 (16x4) | Browser_StartChoiceScreen@9000b1 | TXT | button images "ホームページ" and "ページリスト" + frame art |
| 156 | `browser/start_choice/browser_start_tiles4` | 73:59E0 | 64 (16x4) | Browser_StartChoiceScreen@9400b1 | TXT | button/caption art; text fragments (unreadable) |
| 157 | `browser/start_choice/tiles_4530` | 73:4530 | 11 (11x1) | - | UNK | 11 tiles, not classified |
| 158 | `browser/start_choice/tiles_49e0` | 73:49E0 | 64 (16x4) | - | ART | blank / background tiles |
| 159 | `comm/comm_scene/tiles_5490` | 70:5490 | 64 (16x4) | CommScene_LoadGraphics@8000 | ART | scenery (figures), no text |
| 160 | `comm/comm_scene/tiles_5890` | 70:5890 | 64 (16x4) | CommScene_LoadGraphics@8400 | ART | scenery (figures), no text |
| 161 | `comm/comm_scene/tiles_5c90` | 70:5C90 | 64 (16x4) | CommScene_LoadGraphics@8800 | ART | scenery, no text |
| 162 | `comm/comm_scene/tiles_6090` | 70:6090 | 64 (16x4) | CommScene_LoadGraphics@8C00 | ART | scenery, no text |
| 163 | `comm/comm_scene/tiles_6490` | 70:6490 | 32 (16x2) | CommScene_LoadGraphics@9000 | ART | scenery pieces |
| 164 | `comm/comm_scene/tiles_6690` | 70:6690 | 32 (16x2) | CommScene_LoadGraphics@9000b1 | TXT | "B キャンセル" button + "キャンセルしています" (Cancelling) |
| 165 | `comm/comm_scene/tiles_6890` | 70:6890 | 32 (16x2) | CommScene_LoadGraphics@8400b1 | TXT | text fragments ("ます" ...) of status messages |
| 166 | `comm/comm_scene/tiles_6a90` | 70:6A90 | 32 (16x2) | CommScene_LoadGraphics@9400b1 | TXT | text fragments of status messages (ダウンロード…? unreadable) |
| 167 | `comm/connect_dialog_bank56/tiles_526a` | 56:526A | 5 (5x1) | - | ERR | typed as tiles, label says tilemap (Tilemap_ConnectDialog_ConnectConfirm_56_526A) |
| 168 | `comm/connect_dialog_bank56/tiles_52c0` | 56:52C0 | 64 (16x4) | ConnectDialog_Draw_ConnectConfirm@9000b1 | TXT | banner "つうしんせつぞくします" + fragments of the dialog text |
| 169 | `comm/connect_dialog_bank56/tiles_56c0` | 56:56C0 | 64 (16x4) | ConnectDialog_Draw_ConnectConfirm@9400b1 | TXT | dialog text fragments + buttons "はい" "いいえ" + "うけとり" icon label |
| 170 | `comm/connect_dialog_bank56/tiles_5ac0` | 56:5AC0 | 48 (16x3) | ConnectDialog_Draw_PasswordEntry@8800 | TXT | password dialog texts (fragments: "パスワードをにゅうりょくしてください") |
| 171 | `comm/connect_dialog_bank56/tiles_5dc0` | 56:5DC0 | 48 (16x3) | ConnectDialog_Draw_PasswordEntry@9100b1 | TXT | "パスワードをほぞんします" fragments |
| 172 | `comm/connect_dialog_bank56/tiles_60c0` | 56:60C0 | 64 (16x4) | ConnectDialog_Draw_PasswordEntry@9400b1 | TXT | "パスワードをにゅうりょくしてください" banner |
| 173 | `comm/connect_dialog_bank56/tiles_64c0` | 56:64C0 | 64 (16x4) | ConnectDialog_Draw_StoredPassword@8800 | TXT | "パスワードがほぞんされています" banner |
| 174 | `comm/connect_dialog_bank56/tiles_68c0` | 56:68C0 | 32 (16x2) | - | TXT | frame / button art with small text (unreadable) |
| 175 | `comm/connect_dialog_bank56/tiles_6ac0` | 56:6AC0 | 64 (16x4) | ConnectDialog_Draw_StoredPassword@9400b1 | TXT | "パスワードのほぞんをやめる" (SELECT hint) fragments |
| 176 | `comm/connect_dialog_bank56/tiles_6ec0` | 56:6EC0 | 48 (16x3) | ConnectDialog_Draw_PasswordSaved@9100b1 | TXT | "パスワードをほぞんしました" banner |
| 177 | `comm/connect_dialog_bank56/tiles_71c0` | 56:71C0 | 64 (16x4) | ConnectDialog_Draw_PasswordSaved@9400b1 | TXT | "パスワードをほぞんしました" (continued) + "B もどる" |
| 178 | `comm/connect_dialog_bank56/tiles_75c0` | 56:75C0 | 32 (16x2) | ConnectDialog_Draw_Finish@8000 | ART | animation strip (feathers) |
| 179 | `comm/connect_dialog_screen/connect_dialog_blank_tile` | 57:4D30 | 1 (1x1) | ConnectDialog_Draw_PasswordEntry@8C10 | UNK | 1 blank tile |
| 180 | `comm/connection_icon/conn_icon_tiles0` | 69:4160 | 64 (16x4) | ConnIcon_GfxTable@8200 | ART | connection-icon animation frames |
| 181 | `comm/connection_icon/conn_icon_tiles1` | 69:4560 | 32 (16x2) | ConnIcon_GfxTable@8600 | ART | connection-icon animation frames |
| 182 | `comm/notice_dialog/tiles_5a20` | 50:5A20 | 64 (16x4) | CommNotice_RunDialog@9000 | TXT | notice dialog A text image (read across the two lines: "…ふん…せつぞくしています" "…Aボタンをおして…"; order of glyph halves interleaved, unreadable in detail) |
| 183 | `comm/notice_dialog/tiles_5e20` | 50:5E20 | 26 (13x2) | CommNotice_RunDialog@9400 | TXT | notice dialog A text image (continued) |
| 184 | `comm/notice_dialog/tiles_5fc0` | 50:5FC0 | 1 (1x1) | CommNotice_RunDialog@8000b1 | UNK | 1 tile |
| 185 | `comm/notice_dialog/tiles_5fd0` | 50:5FD0 | 50 (10x5) | CommNotice_RunDialog@9000b1 | MIX | notice dialog A: buttons "はい" "いいえ" + digits |
| 186 | `comm/notice_dialog/tiles_62f0` | 50:62F0 | 64 (16x4) | CommNotice_RunDialog@9000 | TXT | notice dialog B text image (see 182) |
| 187 | `comm/notice_dialog/tiles_66f0` | 50:66F0 | 26 (13x2) | CommNotice_RunDialog@9400 | TXT | notice dialog B text image (continued) |
| 188 | `comm/notice_dialog/tiles_6890` | 50:6890 | 1 (1x1) | CommNotice_RunDialog@8000b1 | UNK | 1 tile |
| 189 | `comm/notice_dialog/tiles_68a0` | 50:68A0 | 50 (10x5) | CommNotice_RunDialog@9000b1 | MIX | notice dialog B: buttons + digits |
| 190 | `comm/time_summary/tiles_42a0` | 51:42A0 | 64 (16x4) | CommTime_DrawSummaryScreen@9000b1 | TXT | summary page A: button "A 次へ" + "すすむ" hints; frame art |
| 191 | `comm/time_summary/tiles_46a0` | 51:46A0 | 64 (16x4) | CommTime_DrawSummaryScreen@9400b1 | TXT | summary page A: "つうしんがしゅうりょうしました / こんかいのつうしんじかんは ふん びょうでした" + digits |
| 192 | `comm/time_summary/tiles_4db0` | 51:4DB0 | 64 (16x4) | CommTime_DrawSummaryScreen@9000b1 | TXT | summary page B: button "A すすむ" + frame art |
| 193 | `comm/time_summary/tiles_51b0` | 51:51B0 | 64 (16x4) | CommTime_DrawSummaryScreen@9400b1 | TXT | summary page B: same sentence as 191 + digits |
| 194 | `comm/time_summary/tiles_58c0` | 51:58C0 | 64 (16x4) | ConnIcon_GfxTable@8200 | ART | connection-icon (globe) animation frames |
| 195 | `comm/time_summary/tiles_5cc0` | 51:5CC0 | 32 (16x2) | ConnIcon_GfxTable@8600 | ART | connection-icon frames |
| 196 | `comm/time_summary/tiles_5ee1` | 51:5EE1 | 287 (16x18) | - | ART | large scenery / animation frames (creatures), no text |
| 197 | `dialog/dialog_window/dialog_window_tiles` | 72:48C0 | 64 (16x4) | Dialog_Open@8800b1 | TXT | dialog window: buttons "はい" "いいえ" "OK" + frame art |
| 198 | `error/comm_error_screen/comm_err_gfx_bg9000` | 5C:5DD0 | 64 (16x4) | CommErr_ShowScreen@9000b1 | TXT | title "通信エラー" + "A もどる" + "No." + digits 0-9 |
| 199 | `error/comm_error_screen/comm_err_gfx_bg9400` | 5C:61D0 | 24 (12x2) | CommErr_ShowScreen@9400b1 | TXT | text/glyph strip (letters-like pieces), unreadable |
| 200 | `error/comm_error_screen/comm_err_gfx_obj8000` | 5C:5D90 | 2 (2x1) | CommErr_ShowScreen@8000b1 | ART | error icon sprites |
| 201 | `error/comm_error_screen/comm_err_gfx_obj8100` | 5C:5DB0 | 2 (2x1) | CommErr_ShowScreen@8100b1 | ART | error icon sprites |
| 202 | `error/no_adapter/no_adapter_gfx_8000` | 63:6080 | 4 (4x1) | NoAdapter_DrawScreen@8000 | ART | small icon tiles |
| 203 | `error/no_adapter/no_adapter_gfx_8800` | 63:60C0 | 60 (15x4) | NoAdapter_DrawScreen@8800b1 | TXT | "でんげんスイッチをOFFにして" / "モバイルアダプタGBをさしこみ" |
| 204 | `error/no_adapter/no_adapter_gfx_8c00` | 63:64C0 | 64 (16x4) | NoAdapter_DrawScreen@8C00b1 | TXT | "もういちどONにしてください。" + "モバイルアダプタGB…" banner part |
| 205 | `error/no_adapter/no_adapter_gfx_9000` | 63:68C0 | 64 (16x4) | NoAdapter_DrawScreen@9000b1 | TXT | banner "モバイルアダプタGBがささっていません" part + frame |
| 206 | `error/no_adapter/no_adapter_gfx_9400` | 63:6CC0 | 48 (16x3) | NoAdapter_DrawScreen@9400b1 | ART | adapter and cable picture |
| 207 | `error/no_adapter/tiles_6480` | 63:6480 | 4 (4x1) | - | UNK | 4 tiles, not classified |
| 208 | `error/non_cgb_screen/non_cgb_tiles` | 6B:4480 | 123 (16x8) | - | TXT | non-CGB error text in a DMG-style image: "このカートリッジはゲームボーイカラー せんようです。ゲームボーイカラーでしようしてください。【モバイルトレーナー】" |
| 209 | `error/non_cgb_screen/tiles_4060` | 6B:4060 | 66 (11x6) | - | UNK | 11x6 tiles, tile-like noise (probably not tile art) |
| 210 | `help/help_screens_a/tiles_4e90` | 6A:4E90 | 64 (16x4) | HelpMenu_ShowPage@8000 | ART | help menu art (book, boxes) |
| 211 | `help/help_screens_a/tiles_5290` | 6A:5290 | 64 (16x4) | HelpMenu_ShowPage@8800 | TXT | help topic labels: "ホームページって?" "モバイルトレーナーって?" "メールって?" "モバイルじてん" "アドレスちょう" "ページリスト" |
| 212 | `help/help_screens_a/tiles_5690` | 6A:5690 | 64 (16x4) | HelpMenu_ShowPage@8C00 | TXT | help topic labels (same set, other tiles) |
| 213 | `help/help_screens_a/tiles_5a90` | 6A:5A90 | 2 (2x1) | HelpMenu_ShowPage@9000 | UNK | 2 tiles |
| 214 | `help/help_screens_a/tiles_5ab0` | 6A:5AB0 | 64 (16x4) | HelpMenu_ShowPage@9000b1 | TXT | banner "ヘルプ" + button art |
| 215 | `help/help_screens_a/tiles_5eb0` | 6A:5EB0 | 64 (16x4) | HelpMenu_ShowPage@9400b1 | TXT | help topic buttons / labels (unreadable in detail) |
| 216 | `help/help_screens_b/tiles_69f0` | 6A:69F0 | 2 (2x1) | HelpScript_Run@8000 | UNK | 2 tiles |
| 217 | `help/help_screens_b/tiles_6a10` | 6A:6A10 | 1 (1x1) | HelpScript_Run@8AF0b1 | UNK | 1 tile |
| 218 | `help/help_screens_b/tiles_6a20` | 6A:6A20 | 64 (16x4) | HelpScript_Run@8B00b1 | TXT | footer legend "A すすむ B もどる セレクト おわる" (help pages) |
| 219 | `help/help_screens_b/tiles_6e20` | 6A:6E20 | 64 (16x4) | - | TXT | footer legend pieces + frame art |
| 220 | `help/mobile_dictionary/mobile_dict_tiles0` | 1A:4A90 | 32 (16x2) | MobileDict_Redraw@8000 | TXT | tab row "ア カ サ タ ナ ハ マ ヤ ラ ワ ABC" (mobile dictionary) |
| 221 | `help/mobile_dictionary/mobile_dict_tiles1` | 1A:4C90 | 64 (16x4) | MobileDict_Redraw@8B00b1 | TXT | banner "モバイルじてん" + tab pieces |
| 222 | `help/mobile_dictionary/mobile_dict_tiles2` | 1A:5090 | 48 (16x3) | MobileDict_Redraw@8F00b1 | TXT | list row art / text pieces |
| 223 | `keyboard/panels_bank5d/tiles_4000` | 5D:4000 | 64 (16x4) | Account_PasswordEntry_Setup@8800b1 | KBD | keyboard type 4 glyphs: Latin upper/lower case, digits (A-J a-j 0-9 ...) |
| 224 | `keyboard/panels_bank5d/tiles_4400` | 5D:4400 | 64 (16x4) | Account_PasswordEntry_Setup@8C00b1 | KBD | keyboard type 4 glyphs: Latin (K-Z ... @ etc.), "OK" key |
| 225 | `keyboard/panels_bank5f/tiles_4000` | 5F:4000 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8800b1 | KBD | keyboard type 9 glyphs: Latin upper/lower, digits |
| 226 | `keyboard/panels_bank5f/tiles_4400` | 5F:4400 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8C00b1 | KBD | keyboard type 9 glyphs: Latin, digits, symbols, key art |
| 227 | `keyboard/panels_bank5f/tiles_4800` | 5F:4800 | 1 (1x1) | Table_Kbd_T78_PageLoaders_Page3@9000b1 | KBD | 1 tile (type 9) |
| 228 | `keyboard/panels_bank5f/tiles_49d0` | 5F:49D0 | 48 (16x3) | Account_ActionConfirmPage_Setup@8000b1 | KBD | key-cap art (8000 bank 1) |
| 229 | `keyboard/panels_bank5f/tiles_5900` | 5F:5900 | 64 (16x4) | Kbd_LoadPageGraphics_TypeTable@8800b1 | KBD | keyboard type 5 glyphs: Latin upper/lower |
| 230 | `keyboard/panels_bank5f/tiles_5d00` | 5F:5D00 | 64 (16x4) | Kbd_LoadPageGraphics_TypeTable@8C00b1 | KBD | keyboard type 5 glyphs: Latin lower, digits, symbols |
| 231 | `keyboard/panels_bank5f/tiles_6100` | 5F:6100 | 16 (16x1) | Kbd_LoadPageGraphics_TypeTable@9000b1 | KBD | keyboard type 5: one row with "SELECT" key art and kana caption ("…" hint) |
| 232 | `keyboard/tiles_bank62/tiles_4000` | 62:4000 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8800b1 | KBD | keyboard page 0 (types 7/8, hiragana): あいうえおかきくけこさしすせそた / ちつてとなにぬねのはひふへほまみ |
| 233 | `keyboard/tiles_bank62/tiles_4400` | 62:4400 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8C00b1 | KBD | keyboard page 0 (hiragana): むめもやゆよらりるれろわをん + small kana, dakuten, ー |
| 234 | `keyboard/tiles_bank62/tiles_4800` | 62:4800 | 36 (12x3) | Table_Kbd_T78_PageLoaders_Page3@9000b1 | KBD | keyboard page 0 key caps (12x3) |
| 235 | `keyboard/tiles_bank62/tiles_4a40` | 62:4A40 | 12 (12x1) | - | KBD | strip of key caps |
| 236 | `keyboard/tiles_bank62/tiles_4b00` | 62:4B00 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8800b1 | KBD | keyboard page 1 (types 7/8, katakana): アイウエオカキクケコサシスセソタ / チツテトナニヌネノハヒフヘホマミ |
| 237 | `keyboard/tiles_bank62/tiles_4f00` | 62:4F00 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8C00b1 | KBD | keyboard page 1 (katakana): ムメモヤユヨラリルレロワヲン + small kana |
| 238 | `keyboard/tiles_bank62/tiles_5300` | 62:5300 | 36 (12x3) | Table_Kbd_T78_PageLoaders_Page3@9000b1 | KBD | keyboard page 1 key caps |
| 239 | `keyboard/tiles_bank62/tiles_5540` | 62:5540 | 12 (12x1) | - | KBD | strip of key caps |
| 240 | `keyboard/tiles_bank62/tiles_5600` | 62:5600 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8800b1 | KBD | keyboard page 2 (Latin): A-P / Q-Z a-g |
| 241 | `keyboard/tiles_bank62/tiles_5a00` | 62:5A00 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8C00b1 | KBD | keyboard page 2 (Latin): h-z, digits 0-9, marks |
| 242 | `keyboard/tiles_bank62/tiles_5e00` | 62:5E00 | 36 (12x3) | Table_Kbd_T78_PageLoaders_Page3@9000b1 | KBD | keyboard page 2 key caps |
| 243 | `keyboard/tiles_bank62/tiles_6040` | 62:6040 | 12 (12x1) | - | KBD | strip of key caps |
| 244 | `keyboard/tiles_bank62/tiles_6100` | 62:6100 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8800b1 | KBD | keyboard page 3 (symbols): + - = # $ * ' " : { } [ ] < 「 」 『 』 ... |
| 245 | `keyboard/tiles_bank62/tiles_6500` | 62:6500 | 64 (16x4) | Table_Kbd_T78_PageLoaders_Page3@8C00b1 | KBD | keyboard page 3 (symbols and digits): , ( ) > ~ _ ^ | × ÷ ... |
| 246 | `keyboard/tiles_bank62/tiles_6900` | 62:6900 | 36 (12x3) | Table_Kbd_T78_PageLoaders_Page3@9000b1 | KBD | keyboard page 3 key caps |
| 247 | `keyboard/tiles_bank62/tiles_6b40` | 62:6B40 | 12 (12x1) | - | KBD | strip of key caps |
| 248 | `keyboard/tiles_bank66/tiles_4000` | 66:4000 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8800b1 | KBD | keyboard type 6 page 0 (hiragana) |
| 249 | `keyboard/tiles_bank66/tiles_4400` | 66:4400 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8C00b1 | KBD | keyboard type 6 page 0 (hiragana, small kana) |
| 250 | `keyboard/tiles_bank66/tiles_4800` | 66:4800 | 36 (12x3) | Table_Kbd_T6_PageLoaders_Page3@9000b1 | KBD | keyboard type 6 page 0 key caps |
| 251 | `keyboard/tiles_bank66/tiles_4a40` | 66:4A40 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8800b1 | KBD | keyboard type 6 page 1 (katakana) |
| 252 | `keyboard/tiles_bank66/tiles_4e40` | 66:4E40 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8C00b1 | KBD | keyboard type 6 page 1 (katakana, small kana) |
| 253 | `keyboard/tiles_bank66/tiles_5240` | 66:5240 | 36 (12x3) | Table_Kbd_T6_PageLoaders_Page3@9000b1 | KBD | keyboard type 6 page 1 key caps |
| 254 | `keyboard/tiles_bank66/tiles_5480` | 66:5480 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8800b1 | KBD | keyboard type 6 page 2 (Latin) |
| 255 | `keyboard/tiles_bank66/tiles_5880` | 66:5880 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8C00b1 | KBD | keyboard type 6 page 2 (Latin lower, digits) |
| 256 | `keyboard/tiles_bank66/tiles_5c80` | 66:5C80 | 36 (12x3) | Table_Kbd_T6_PageLoaders_Page3@9000b1 | KBD | keyboard type 6 page 2 key caps |
| 257 | `keyboard/tiles_bank66/tiles_5ec0` | 66:5EC0 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8800b1 | KBD | keyboard type 6 page 3 (symbols) |
| 258 | `keyboard/tiles_bank66/tiles_62c0` | 66:62C0 | 64 (16x4) | Table_Kbd_T6_PageLoaders_Page3@8C00b1 | KBD | keyboard type 6 page 3 (symbols, digits) |
| 259 | `keyboard/tiles_bank66/tiles_66c0` | 66:66C0 | 36 (12x3) | Table_Kbd_T6_PageLoaders_Page3@9000b1 | KBD | keyboard type 6 page 3 key caps |
| 260 | `keyboard/tiles_bank66/tiles_6900` | 66:6900 | 25 (16x2) | Table_Kbd_T78_PageLoaders_Page3@8A80b1 | MIX | keyboard type 10 tiles: key caps / arrows |
| 261 | `keyboard/tiles_bank66/tiles_6a90` | 66:6A90 | 112 (16x7) | - | TXT | mail-draft exit menu images: "メールをセーブしてしゅうりょうします" "かいたメールをみることができます" "メールをかくのをやめます" (reading) |
| 262 | `mail/address_editor/mail_addr_obj_tiles` | 2D:7880 | 12 (12x1) | MailAddr_SetupScreen@8000 | TXT | object tiles of the mail-address screen: small labels ("セレクト アドレスちょう" legend pieces) |
| 263 | `mail/address_editor/mail_addr_tiles` | 2D:7120 | 64 (16x4) | MailAddr_SetupScreen@9300b1 | TXT | header "メールアドレス" + text "ともだちのアドレスをかいてね" (pieces) |
| 264 | `mail/address_editor/mail_addr_tiles2` | 2D:7520 | 11 (11x1) | MailAddr_SetupScreen@9700b1 | TXT | footer pieces ("セレクト アドレスちょう" legend) |
| 265 | `mail/address_editor/mail_addr_tiles3` | 2D:75D0 | 43 (16x3) | MailAddr_SetupScreen@8800 | TXT | legend pieces ("A キーボード B もどる") |
| 266 | `mail/address_editor/tiles_7940` | 2D:7940 | 33 (11x3) | - | ART | pen / icon art |
| 267 | `mail/body_editor/mail_body_obj_tiles` | 2D:62D0 | 42 (14x3) | MailBody_SetupScreen@8000 | TXT | digits 1-8 (line numbers) + pen icons |
| 268 | `mail/body_editor/mail_body_tiles` | 2D:5AC0 | 60 (15x4) | MailBody_SetupScreen@9300b1 | TXT | header "メールほんぶん" + pieces |
| 269 | `mail/body_editor/mail_body_tiles2` | 2D:5EC0 | 16 (16x1) | MailBody_SetupScreen@9700b1 | UNK | 16 tiles, blank |
| 270 | `mail/body_view/mail_body_tiles_42c0` | 28:42C0 | 33 (11x3) | MailBody_InitScreen@9300b1 | TXT | "B もどる" legend + airmail border pieces |
| 271 | `mail/body_view/mail_body_tiles_44d0` | 28:44D0 | 8 (8x1) | MailBody_InitScreen@8000 | TXT | legend pieces |
| 272 | `mail/comm_result/mail_result_tiles_6bf0` | 24:6BF0 | 64 (16x4) | MailResult_InitScreen@8800b1 | TXT | banner "つうしんけっかはっぴょう" |
| 273 | `mail/comm_result/mail_result_tiles_6ff0` | 24:6FF0 | 64 (16x4) | MailResult_InitScreen@8C00b1 | TXT | labels "おくったメール" "とどいたメール" |
| 274 | `mail/comm_result/mail_result_tiles_73f0` | 24:73F0 | 10 (10x1) | MailResult_InitScreen@9000b1 | TXT | label piece "とどいたメール" |
| 275 | `mail/comm_result/mail_result_tiles_7490` | 24:7490 | 48 (16x3) | MailResult_InitScreen@8000 | NUM | digits 0-9 + "A すすむ" legend pieces |
| 276 | `mail/connect_screen/mail_connect_tiles_5060` | 27:5060 | 64 (16x4) | MailConnect_InitScreen@8000b1 | ART | scenery figures (mail session) |
| 277 | `mail/connect_screen/mail_connect_tiles_5460` | 27:5460 | 64 (16x4) | MailConnect_InitScreen@8400b1 | ART | scenery figures |
| 278 | `mail/connect_screen/mail_connect_tiles_5860` | 27:5860 | 64 (16x4) | MailConnect_InitScreen@9000b1 | TXT | "B キャンセル" button + "キャンセルしています" (Cancelling) |
| 279 | `mail/connect_screen/mail_connect_tiles_5c60` | 27:5C60 | 32 (16x2) | MailConnect_InitScreen@9400b1 | TXT | text pieces of status messages ("ダウンロード…", unreadable) |
| 280 | `mail/connect_screen/mail_connect_tiles_5e60` | 27:5E60 | 64 (16x4) | MailConnect_InitScreen@8800 | ART | scenery pieces |
| 281 | `mail/connect_screen/mail_connect_tiles_6260` | 27:6260 | 64 (16x4) | MailConnect_InitScreen@8C00 | ART | scenery pieces |
| 282 | `mail/connect_screen/mail_connect_tiles_6660` | 27:6660 | 32 (16x2) | MailConnect_InitScreen@9000 | UNK | blank |
| 283 | `mail/connect_screen/mail_connect_tiles_6860` | 27:6860 | 64 (16x4) | MailConnect_InitScreen@8000 | ART | scenery figures |
| 284 | `mail/connect_screen/mail_connect_tiles_6c60` | 27:6C60 | 64 (16x4) | MailConnect_InitScreen@8400 | ART | scenery figures |
| 285 | `mail/connect_screen_bank29/tiles_5400` | 29:5400 | 64 (16x4) | CommTime_DrawHMSScreen@9000b1 | TXT | "こんかいのつうしじかんは ふんびょうでした" + digits |
| 286 | `mail/draft_menu/mail_draft_menu_tiles8000` | 2B:4E60 | 51 (16x4) | MailDraft_Menu_InitScreen@8000 | TXT | labels "チェック…" "けす" "タイトル" "アドレス" "さんへ" (draft menu, pieces) |
| 287 | `mail/draft_menu/mail_draft_menu_tiles9300` | 2B:4880 | 45 (15x3) | MailDraft_Menu_InitScreen@9300b1 | TXT | draft menu art and label pieces |
| 288 | `mail/mail_title_entry/mail_title_tiles8000` | 2C:5140 | 1 (1x1) | MailTitle_InitScreen@8000 | UNK | 1 tile |
| 289 | `mail/mail_title_entry/mail_title_tiles8800` | 2C:5410 | 37 (16x3) | MailTitle_InitScreen@8800 | TXT | title pieces "メールタイトル" (header) |
| 290 | `mail/mail_title_entry/mail_title_tiles9300` | 2C:4A30 | 64 (16x4) | MailTitle_InitScreen@9300b1 | TXT | "メールタイトル" header + "メールのタイトルをかいてね" |
| 291 | `mail/mail_viewer/mail_view_tiles8000` | 2B:76E0 | 24 (12x2) | MailView_SenderPage_InitScreen@8000 | TXT | labels "アドレス" "タイトル" (pieces) |
| 292 | `mail/mail_viewer/mail_view_tiles9000` | 2B:6DD0 | 64 (16x4) | MailView_SenderPage_InitScreen@9000b1 | TXT | legend "セレクト アドレスをセーブ" "A つぎへ" + digits + "年月日時" |
| 293 | `mail/mail_viewer/mail_view_tiles9400` | 2B:71D0 | 32 (16x2) | MailView_SenderPage_InitScreen@9400b1 | TXT | label pieces |
| 294 | `mail/received_mail_grid/mail_grid_tiles8000` | 2B:6300 | 15 (15x1) | MailGrid_InitScreen@8000 | ART | grid art |
| 295 | `mail/received_mail_grid/mail_grid_tiles9000` | 2B:59C0 | 64 (16x4) | MailGrid_InitScreen@9000b1 | TXT | header "もらったメール" + labels "年 月 日 時 分 送" |
| 296 | `mail/received_mail_grid/mail_grid_tiles9400` | 2B:5DC0 | 35 (16x3) | MailGrid_InitScreen@9400b1 | NUM | digits 0-9 + grid art |
| 297 | `mail/result_screens/mail_server_status_tiles_5060` | 29:5060 | 3 (3x1) | MailServerStatus_InitScreen@9300b1 | TXT | 3 tiles ("つう" counter unit, PROBABLE) |
| 298 | `mail/server_status/mail_server_status_tiles_6f30` | 25:6F30 | 64 (16x4) | MailServerStatus_InitScreen@8800 | TXT | banner "メールサーバじょうきょう" + labels "チェックしたメール" "けしおわったメール" |
| 299 | `mail/server_status/mail_server_status_tiles_7330` | 25:7330 | 64 (16x4) | MailServerStatus_InitScreen@8C00 | TXT | labels "このソフトのメール" "サーバにあるメール" "けしおわったメール" "つう" |
| 300 | `mail/server_status_bank26/mail_server_status_tiles_7420` | 26:7420 | 64 (16x4) | MailServerStatus_InitScreen@9400 | TXT | "メニューにもどる" legend + frame art |
| 301 | `mail/server_status_bank26/tiles_7840` | 26:7840 | 39 (13x3) | - | ART | feather/pen art |
| 302 | `mail/session_scenery/mail_session_tiles_59e0` | 26:59E0 | 64 (16x4) | MailSession_InitScreen@8000b1 | ART | scenery (session screen) |
| 303 | `mail/session_scenery/mail_session_tiles_5de0` | 26:5DE0 | 64 (16x4) | MailSession_InitScreen@8400b1 | ART | scenery |
| 304 | `mail/session_scenery/mail_session_tiles_61e0` | 26:61E0 | 16 (16x1) | MailSession_InitScreen@8800b1 | ART | blank |
| 305 | `mail/session_scenery/mail_session_tiles_62e0` | 26:62E0 | 64 (16x4) | MailSession_InitScreen@9000b1 | TXT | "B キャンセル" + "メールをおくっています" (Sending mail) |
| 306 | `mail/session_scenery/mail_session_tiles_66e0` | 26:66E0 | 1 (1x1) | MailSession_InitScreen@9400b1 | UNK | 1 tile |
| 307 | `mail/session_scenery/mail_session_tiles_67e0` | 26:67E0 | 64 (16x4) | MailSession_InitScreen@8000 | ART | scenery |
| 308 | `mail/session_scenery/mail_session_tiles_6be0` | 26:6BE0 | 64 (16x4) | MailSession_InitScreen@8400 | ART | scenery |
| 309 | `mail/session_scenery/mail_session_tiles_6fe0` | 26:6FE0 | 64 (16x4) | MailSession_InitScreen@8800 | ART | scenery |
| 310 | `mail/session_scenery/tiles_66f0` | 26:66F0 | 15 (15x1) | - | NUM | digits 1-9 and ":" |
| 311 | `mail_menu/mail_menu/mail_menu_tiles0` | 1D:4D20 | 25 (16x2) | MailMenu_Run@8000 | ART | pen icons (hand with pen) |
| 312 | `mail_menu/mail_menu/mail_menu_tiles1` | 1D:4EB0 | 64 (16x4) | MailMenu_Run@8800 | TXT | menu button labels "おくる/うけとる" "メールをかく" "メールボックス" "アドレスちょう" "プロフィール" "メールサーバ" |
| 313 | `mail_menu/mail_menu/mail_menu_tiles2` | 1D:52B0 | 64 (16x4) | MailMenu_Run@8C00 | ART | envelope / menu art |
| 314 | `mail_menu/mail_menu/mail_menu_tiles3` | 1D:56B0 | 64 (16x4) | MailMenu_Run@9000 | TXT | menu labels (same set, other tiles) |
| 315 | `mail_menu/mail_menu/mail_menu_tiles4` | 1D:5AB0 | 56 (14x4) | - | ART | frame art |
| 316 | `mail_menu/mail_menu/mail_menu_tiles5` | 1D:5E30 | 64 (16x4) | MailMenu_Run@9400b1 | TXT | menu button images: "おくる/うけとる" "メールをかく" "プロフィール" "メールボックス" "アドレスちょう" "メールサーバ" |
| 317 | `mail_server/delete_all_screen/mail_server_delete_all_tiles_54b0` | 28:54B0 | 64 (16x4) | MailSrvDelHidden_Confirm@9300b1 | TXT | banner "サーバのメールをすべてけします" |
| 318 | `mail_server/delete_all_screen/mail_server_delete_all_tiles_58b0` | 28:58B0 | 42 (14x3) | MailSrvDelHidden_Confirm@9700b1 | TXT | buttons "はい" "いいえ" |
| 319 | `mail_server/delete_all_screen/mail_server_delete_all_tiles_5b50` | 28:5B50 | 8 (8x1) | MailSrvDelHidden_Confirm@8000 | UNK | 8 tiles |
| 320 | `mail_server/delete_method_screen/mail_server_delete_method_tiles_5f20` | 28:5F20 | 35 (16x3) | MailSrvDelHidden_MenuInit@9300b1 | TXT | banner "メールのけしかたをえらんでね" |
| 321 | `mail_server/delete_method_screen/mail_server_delete_method_tiles_6150` | 28:6150 | 64 (16x4) | MailSrvDelHidden_MenuInit@8800 | TXT | option buttons "かくにんしてからけす" "じどうでぜんぶけす" |
| 322 | `mail_server/delete_method_screen/mail_server_delete_method_tiles_6550` | 28:6550 | 41 (16x3) | MailSrvDelHidden_MenuInit@8C00 | TXT | option button "かんぜんにけす" + "じどうでぜんぶけす" pieces |
| 323 | `mail_server/delete_method_screen/mail_server_delete_method_tiles_67e0` | 28:67E0 | 8 (8x1) | MailSrvDelHidden_MenuInit@8000 | UNK | 8 tiles |
| 324 | `mail_server/delete_progress/mail_srv_del_progress_tiles0` | 23:6FE0 | 64 (16x4) | MailSrvDel_ProgressInit@9000b1 | TXT | "B キャンセル" + "じどうでぜんぶけす" (progress screen) |
| 325 | `mail_server/delete_progress/mail_srv_del_progress_tiles1` | 23:73E0 | 16 (16x1) | MailSrvDel_ProgressInit@9400b1 | NUM | digits 0-9 and ":" |
| 326 | `mail_server/delete_progress/mail_srv_del_progress_tiles2` | 23:74E0 | 22 (11x2) | MailSrvDel_ProgressInit@8000 | NUM | digits / timer art |
| 327 | `mail_server/tidy_screen/mail_server_mgr_tiles0` | 2E:56E0 | 64 (16x4) | MailServerMgr_SetupScreen@9000b1 | TXT | labels "ほかのソフトのメール" / digits / date labels "年 月 日 時 分 法" |
| 328 | `mail_server/tidy_screen/mail_server_mgr_tiles1` | 2E:5AE0 | 1 (1x1) | MailServerMgr_Run@9400b1 | UNK | 1 tile |
| 329 | `mail_server/tidy_screen/mail_server_mgr_tiles2` | 2E:5EE0 | 18 (9x2) | MailServerMgr_SetupScreen@8800b1 | TXT | "つぎへ やめる" style button pieces |
| 330 | `mail_server/tidy_screen/mail_server_mgr_tiles3` | 2E:6000 | 64 (16x4) | MailServerMgr_SetupScreen@8A80 | TXT | header "メールサーバ" + labels "このソフトのメール" (pieces) |
| 331 | `mail_server/tidy_screen/mail_server_mgr_tiles4` | 2E:6400 | 22 (11x2) | MailServerMgr_SetupScreen@8E80 | NUM | digits 0-9 |
| 332 | `mail_server/tidy_screen/mail_server_mgr_tiles5` | 2E:6560 | 64 (16x4) | MailServerMgr_SetupScreen@8000 | TXT | button pieces ("けす" "つぎへ" "やめる") + digits |
| 333 | `mail_server/tidy_screen/tiles_5af0` | 2E:5AF0 | 63 (9x7) | - | TXT | frame/label pieces ("このソフト…") |
| 334 | `mailbox/mailbox/mailbox_tiles_5a10` | 25:5A10 | 64 (16x4) | Mailbox_LoadScreen@9300b1 | TXT | header "メールボックス" + pieces |
| 335 | `mailbox/mailbox/mailbox_tiles_5e10` | 25:5E10 | 16 (16x1) | Mailbox_LoadScreen@9700b1 | TXT | label pieces ("ニックネーム") |
| 336 | `mailbox/mailbox/mailbox_tiles_5f10` | 25:5F10 | 64 (16x4) | Mailbox_LoadScreen@9300b1 | TXT | "けすメールをえらんでね" + "ニックネーム" pieces |
| 337 | `mailbox/mailbox/mailbox_tiles_6310` | 25:6310 | 16 (16x1) | Mailbox_LoadScreen@9700b1 | TXT | label pieces |
| 338 | `mailbox/mailbox/mailbox_tiles_69f0` | 25:69F0 | 13 (13x1) | Mailbox_LoadScreen@8000 | NUM | digits 1-12 (row numbers) |
| 339 | `mailbox/mailbox/mailbox_tiles_6cf0` | 25:6CF0 | 24 (12x2) | Mailbox_LoadScreen@8D00 | NUM | digits + "年月日時分" labels |
| 340 | `mailbox/mailbox/tiles_6bd1` | 25:6BD1 | 17 (16x2) | - | TXT | arrow/label pieces |
| 341 | `profile/profile_editor/profile_tiles8800` | 2A:6800 | 52 (13x4) | Profile_InitScreen@8800 | TXT | banner "プロフィール" + labels "ニックネーム" "アドレス" |
| 342 | `profile/profile_editor/profile_tiles9300` | 2A:6300 | 64 (16x4) | Profile_InitScreen@9300b1 | TXT | legend "A キーボード B もどる" + "プロフィール" banner pieces |
| 343 | `profile/profile_editor/profile_tiles9700` | 2A:6700 | 16 (16x1) | Profile_InitScreen@9700b1 | UNK | 16 tiles |
| 344 | `registration/screens_bank58/tiles_4000` | 58:4000 | 29 (16x2) | Notice_ShowPage@9000b1 | NUM | digits 0-9 and "/" |
| 345 | `registration/screens_bank58/tiles_41d0` | 58:41D0 | 40 (10x4) | - | TXT | registration notice banners "初期登録…" (pieces; "開始/説明" readings not certain) |
| 346 | `registration/screens_bank58/tiles_4450` | 58:4450 | 40 (10x4) | - | TXT | registration notice banners (pieces) |
| 347 | `registration/screens_bank58/tiles_46d0` | 58:46D0 | 120 (15x8) | - | TXT | banners "初期登録のご注意" "初期登録中止" "WELCOMEメッセージ" (readings) |
| 348 | `registration/screens_bank58/tiles_4e50` | 58:4E50 | 80 (16x5) | - | TXT | banners "初期登録注意事項" "登録情報" "削除中止" |
| 349 | `registration/screens_bank58/tiles_5350` | 58:5350 | 80 (16x5) | - | TXT | banners "登録情報削除終了" "パスワード変更説明" |
| 350 | `registration/screens_bank58/tiles_5850` | 58:5850 | 40 (10x4) | - | TXT | banners "パスワード変更" (pieces) |
| 351 | `registration/screens_bank58/tiles_5ad0` | 58:5AD0 | 295 (16x19) | - | TXT | banners "パスワード変更中止" "ご利用時間の確認説明" "ご利用時間の確認中止" "ご利用額の確認説明" "ご利用額の確認中止" "登録情報削除説明" (and legend "A 次へ") |
| 352 | `registration/screens_bank58/tiles_6d40` | 58:6D40 | 114 (16x8) | - | TXT | legends "A 次へ" "A メインメニュー" and frame pieces |
| 353 | `registration/screens_bank58/tiles_7460` | 58:7460 | 31 (16x2) | - | TXT | legend "A 次の画面" |
| 354 | `registration/screens_bank58/tiles_7650` | 58:7650 | 20 (10x2) | - | TXT | legend pieces ("タイトル画面へ") |
| 355 | `registration/screens_bank58/tiles_7790` | 58:7790 | 60 (15x4) | - | TXT | legend "A 次の画面" "B タイトル画面へ" "メインメニュー" |
| 356 | `settings/screens_bank4a/tiles_5f80` | 4A:5F80 | 16 (16x1) | AdapterCheck_DrawScreen@8000 | ART | adapter icon pieces |
| 357 | `settings/screens_bank4a/tiles_6080` | 4A:6080 | 64 (16x4) | AdapterCheck_DrawScreen@9000b1 | TXT | "モバイルアダプタGBを / チェックしています" + adapter picture |
| 358 | `settings/screens_bank4a/tiles_6480` | 4A:6480 | 64 (16x4) | AdapterCheck_DrawScreen@9400b1 | TXT | text/pattern pieces (unreadable) |
| 359 | `settings/screens_bank4a/tiles_68d0` | 4A:68D0 | 5 (5x1) | - | ERR | typed as tiles; label AdapterCheck_ObjTableAndAnimData: sprite table data, not tile art |
| 360 | `settings/screens_bank4a/tiles_6920` | 4A:6920 | 64 (16x4) | PhoneComment_KeyboardSetup@9000b1 | TXT | legend "＋選ぶ A書く B消す 戻る / OK 次へ" + "インターネット電話番号" |
| 361 | `settings/screens_bank4a/tiles_6d20` | 4A:6D20 | 64 (16x4) | PhoneComment_KeyboardSetup@9400b1 | TXT | "セルフページコメントを入力してください" |
| 362 | `settings/screens_bank4b/tiles_5b90` | 4B:5B90 | 160 (16x10) | - | TXT | banners "電話番号入力説明" "電話番号変更終了" "電話番号変更中止" "新しいパスワードのご注意" (reading) |
| 363 | `settings/screens_bank4b/tiles_6a90` | 4B:6A90 | 64 (16x4) | SettingsPhone_ConfirmScreen_Setup@8800b1 | TXT | legend "＋選ぶ A決定 B戻る" + banner "次のように電話番号を変更します" |
| 364 | `settings/screens_bank4b/tiles_6e90` | 4B:6E90 | 34 (16x3) | SettingsPhone_ConfirmScreen_Setup@8C00b1 | TXT | buttons "はい" "いいえ" + "よろしいですか?" |
| 365 | `settings/screens_bank4b/tiles_70b0` | 4B:70B0 | 62 (16x4) | - | TXT | labels "インターネット用" "セルフページ用" "コメント" + digits |
| 366 | `settings/screens_bank4b/tiles_76d0` | 4B:76D0 | 64 (16x4) | SettingsPhone_ContinuePrompt_Setup@9000b1 | TXT | legend + banner "電話番号変更終了" + "続けて登録をしますか?" |
| 367 | `settings/screens_bank4b/tiles_7ad0` | 4B:7AD0 | 48 (16x3) | SettingsPhone_ContinuePrompt_Setup@9400b1 | TXT | "…録をしますか?" + buttons "はい" "いいえ" |
| 368 | `settings/screens_bank4d/tiles_4000` | 4D:4000 | 32 (16x2) | SettingsPhone_ChoiceMenu_Setup@8800b1 (src+110) | TXT | banner piece "電話番号変更" + frame |
| 369 | `settings/screens_bank4d/tiles_4200` | 4D:4200 | 49 (16x4) | - | TXT | title "電話番号入力方法選択" pieces + legend "内容選択" |
| 370 | `settings/screens_bank4d/tiles_4510` | 4D:4510 | 16 (16x1) | SettingsPhone_ChoiceMenu_Setup@8C00b1 | TXT | legend pieces "B 戻る" |
| 371 | `settings/screens_bank4d/tiles_4610` | 4D:4610 | 64 (16x4) | SettingsPhone_ChoiceMenu_Setup@9000b1 | TXT | option buttons "電話番号を変更する" / "通常使う電話番号を選択する" |
| 372 | `settings/screens_bank4d/tiles_4a10` | 4D:4A10 | 48 (16x3) | SettingsPhone_ChoiceMenu_Setup@9400b1 | TXT | "通常使う電話番号を選択する" + title "電話番号入力方法選択" pieces |
| 373 | `settings/screens_bank4d/tiles_4d10` | 4D:4D10 | 48 (16x3) | - | TXT | title pieces "方法選択" + legend "＋選ぶ A決定" |
| 374 | `settings/screens_bank4d/tiles_5010` | 4D:5010 | 16 (16x1) | SettingsPhone_ChoiceMenu_Setup@8C00b1 | TXT | legend pieces "B 戻る" |
| 375 | `settings/screens_bank4d/tiles_5110` | 4D:5110 | 64 (16x4) | SettingsPhone_ChoiceMenu_Setup@9000b1 | TXT | option buttons "自動で入力する" "手動で入力する" |
| 376 | `settings/screens_bank4d/tiles_5510` | 4D:5510 | 48 (16x3) | SettingsPhone_ChoiceMenu_Setup@9400b1 | TXT | fragments (typed as tiles; same address also loaded as a palette, HYPOTHESIS in naming notes) |
| 377 | `settings/screens_bank4d/tiles_5d50` | 4D:5D50 | 2 (2x1) | SettingsPhone_SlotMenu_Setup@8000b1 | ART | arrow tiles |
| 378 | `settings/screens_bank4d/tiles_5d70` | 4D:5D70 | 64 (16x4) | SettingsPhone_SlotMenu_Setup@8800b1 | TXT | title "通常使用電話番号選択" + text "通常使う電話番号を選択…" |
| 379 | `settings/screens_bank4d/tiles_6170` | 4D:6170 | 64 (16x4) | SettingsPhone_SlotMenu_Setup@8C00b1 | TXT | "…選択してください" + legend "＋選ぶ A決定 B戻る" |
| 380 | `settings/screens_bank4d/tiles_6570` | 4D:6570 | 48 (16x3) | - | TXT | labels "登録場所 1/2/3" + "インターネット用" (pieces) |
| 381 | `settings/screens_bank4d/tiles_6870` | 4D:6870 | 64 (16x4) | SettingsPhone_SlotMenu_Setup@9400b1 | TXT | title "変更用電話番号選択" |
| 382 | `settings/screens_bank4d/tiles_6c70` | 4D:6C70 | 16 (16x1) | - | TXT | text pieces |
| 383 | `settings/screens_bank4d/tiles_6d70` | 4D:6D70 | 64 (16x4) | SettingsPhone_SlotMenu_Setup@8C00b1 | TXT | "…してください" + legend |
| 384 | `settings/screens_bank4d/tiles_7170` | 4D:7170 | 48 (16x3) | - | TXT | labels "登録場所 1/2/3" + "インターネット用" |
| 385 | `settings/screens_bank4d/tiles_7470` | 4D:7470 | 64 (16x4) | SettingsPhone_SlotMenu_Setup@9400b1 | TXT | text / label pieces |
| 386 | `settings/screens_bank5d/tiles_7360` | 5D:7360 | 64 (16x4) | PwSaveConfirm_Setup@9000b1 | TXT | legend + banner "パスワード保存の確認" |
| 387 | `settings/screens_bank5d/tiles_7760` | 5D:7760 | 64 (16x4) | PwSaveConfirm_Setup@9400b1 | TXT | "パスワードを保存します" "よろしいですか?" + buttons "はい" "いいえ" |
| 388 | `settings/screens_bank5e/tiles_4000` | 5E:4000 | 64 (16x4) | Account_LoginIdEntry_Setup@8800b1 | KBD | Latin glyph tiles (A-Z, a-z, digits), shared by the account entry screens |
| 389 | `settings/screens_bank5e/tiles_4400` | 5E:4400 | 64 (16x4) | Account_LoginIdEntry_Setup@8C00b1 | KBD | Latin glyph tiles (K-Z ..., "OK" key, @) |
| 390 | `title/logo/title_logo_tiles0` | 0E:60A0 | 64 (16x4) | Title_LoadLogoScreen@9000b1 | LAT | logo "GB" + "MOBILE SYSTEM GB" (Latin, part of the logo picture) |
| 391 | `title/logo/title_logo_tiles1` | 0E:64A0 | 64 (16x4) | Title_LoadLogoScreen@9400b1 | ART | logo tiles (blank / logo pieces) |
| 392 | `title/title_screen/title_tiles0` | 0E:43C0 | 64 (16x4) | Title_LoadTitleScreen@8000 | ART | title screen art (globe etc.) |
| 393 | `title/title_screen/title_tiles1` | 0E:47C0 | 64 (16x4) | Title_LoadTitleScreen@8800 | TXT | title logo lettering pieces ("モバイルトレーナー") |
| 394 | `title/title_screen/title_tiles2` | 0E:4BC0 | 32 (16x2) | Title_LoadTitleScreen@8800b1 | TXT | title logo lettering pieces |
| 395 | `title/title_screen/title_tiles3` | 0E:4DC0 | 32 (16x2) | - | TXT | title logo lettering pieces |
| 396 | `title/title_screen/title_tiles4` | 0E:4FC0 | 64 (16x4) | Title_LoadTitleScreen@8C00b1 | TXT | title logo lettering pieces + "©2001 Nintendo" (Latin/digits, PROBABLE) |
| 397 | `title/title_screen/title_tiles5` | 0E:53C0 | 64 (16x4) | Title_LoadTitleScreen@9000b1 | ART | title screen art (phone, envelope, Game Boy) |
| 398 | `title/title_screen/title_tiles6` | 0E:57C0 | 64 (16x4) | Title_LoadTitleScreen@9400b1 | TXT | button images "モバイルせってい" "スタート" |
| 399 | `top_menu/top_menu/tiles_49a0` | 1E:49A0 | 64 (16x4) | TopMenu_Run@8000 | ART | top-menu art (pieces) |
| 400 | `top_menu/top_menu/tiles_4da0` | 1E:4DA0 | 64 (16x4) | TopMenu_Run@8400 | ART | top-menu art (pieces) |
| 401 | `top_menu/top_menu/tiles_51a0` | 1E:51A0 | 64 (16x4) | TopMenu_Run@8800 | TXT | top-menu art + label pieces |
| 402 | `top_menu/top_menu/tiles_55a0` | 1E:55A0 | 64 (16x4) | TopMenu_Run@8C00 | ART | top-menu art |
| 403 | `top_menu/top_menu/tiles_59a0` | 1E:59A0 | 32 (16x2) | TopMenu_Run@9000 | ART | top-menu art |
| 404 | `top_menu/top_menu/tiles_5ba0` | 1E:5BA0 | 64 (16x4) | TopMenu_Run@9000b1 | TXT | top-menu label images "メール" "ホームページ" "ヘルプ" (pieces) |
| 405 | `top_menu/top_menu/tiles_5fa0` | 1E:5FA0 | 48 (16x3) | TopMenu_Run@9400b1 | TXT | top-menu label pieces ("ヘルプ") |
| 406 | `unreferenced/page_list_prototype/tiles_62b0` | 7F:62B0 | 64 (16x4) | PageListProto_InitScreen@9000b1 | ART | unused page-list prototype art |
| 407 | `unreferenced/page_list_prototype/tiles_66b0` | 7F:66B0 | 18 (9x2) | PageListProto_InitScreen@9400b1 | ART | unused page-list prototype art |
| 408 | `unreferenced/page_list_prototype/tiles_6ae0` | 7F:6AE0 | 41 (16x3) | PageListProto_InitScreen@8000 | ART | unused page-list prototype art |
| 409 | `unreferenced/page_list_prototype_objects/tiles_7830` | 7F:7830 | 45 (15x3) | - | ART | unused prototype object tiles |

## 4. Fonts and other glyph data (language-bound, not pictures of screens)

| data | bank:addr | what it is | language-bound content | edit route |
|---|---|---|---|---|
| `data/fonts/jis12x12_rows_*.bin` (10 files, view sheets `*_view.png`/`.png`) | 76-7E | 12x12 1bpp JIS X 0208 glyphs, 18 bytes each; the main text engine (00:0ED3) draws Shift-JIS double-byte text with it (CONFIRMED, `text_encoding.md`) | every glyph: kana, kanji (levels 1-2), symbols, Greek, Cyrillic, full-width Latin and digits (JIS row 3) | edit the font PNG (`docs/EDITING_IMAGES.md` section 4); a glyph edit changes every string that uses that code |
| `data/fonts/ascii_6x12.bin` | 76:67A8 | 6x12 Latin font, ASCII 20-7F (`Glyph_AsciiAddr` returns `$67A8 + (c-$20)*12`), used for single bytes by the main text engine (CONFIRMED) | Latin letters, digits, punctuation (5C = yen sign, 7E = overline) | edit the PNG |
| `data/fonts/font_8x16_*.1bpp` (27 runs, 303 glyphs) | 48:4ADB-5DCB | 8x16 glyphs used by the bank-48 renderers (`Font_BlitGlyph8x16`, `TextTiles_RenderLine`, the ticker): one glyph per **pair** of bytes; the runs are keyed by Shift-JIS code: 824F digits (10), 8260 A-Z (26), 8281 a-z (26), 829F hiragana (83), 8340 katakana (85), 8140-81F4 punctuation/symbols, 83BF five dotted placeholders | **no kanji, no half-width ASCII, no half-width katakana**: only these 303 glyphs can be drawn by these renderers | edit the PNG (glyph cells); adding a glyph needs a new table entry (not editable as a PNG) |
| `data/fonts/sjis_valid_bitmap.bin` | 63:407A | 256x256-bit validity bitmap of Shift-JIS lead/trail pairs (8198 bytes, view-only PNG) | which codes the game accepts (keyboard / text input) | binary |
| keyboard glyph pages, bank 5D/5F/62/66 (`gfx/keyboard/**`, rows 223-260 above) | 5D/5F/62/66 | 8x8 tile fonts of the on-screen keyboards (hiragana, katakana, Latin upper/lower, digits, symbols) | hiragana and katakana pages; Latin and symbol pages | edit the tile PNGs |

## 5. What could not be read, and open questions

* Rows of section 3 with class `UNK` or "unreadable": text pools of banks 60/61 and 58 (partly), the notice-dialog images (banks 50/51; two glyph rows interleaved in the PNG layout), `bank52` (four 40-tile message images of the **unreferenced** page-list prototype; under row-major and column-pair reassembly of the 40 tiles no readable line emerged: HYPOTHESIS that they are two-line kana prompts about mail) and the mail-session status images (banks 26/27).  Reading them needs the tilemap that places the tiles (mostly loaded by table-driven code that the static extraction does not resolve: 99 unresolved loader calls, `gfx/previews/screen_ops.tsv`).
* 14 screens have load operations but no emulator capture (`gfx/previews/screens.tsv`, `best_capture = -`): they are composed from the assets only.
* The tile pools are laid out for the Japanese strings.  Whether an English text fits (glyph widths, number of tiles per line, tilemap cells) has to be decided screen by screen; see `docs/TRANSLATION.md`, section "Limits".
* bank-47 record 3 and banks 41-46 are unreferenced: if they are dead data, translating them has no visible effect (not proven: a table-driven reference could exist, all 27 style indices were traced only statically).
