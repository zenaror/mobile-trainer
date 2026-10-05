# Previews

Generated pictures (not ROM data, not needed by `make`): what the game draws, composed from the repository assets by `tools/render_screens.py` (screens) and
`tools/render_sprites.py` (sprites), and checked against emulator captures.  Method, validation and limits: `docs/TRANSLATION.md` (section 4) and the docstrings of the tools.

* `screens/<routine>.png`  160x144 composition of the tile / tilemap / palette loads of one routine (grey checker = tile data the scene does not load or that the game rewrites at run time, e.g. text drawn by the text engine);
  `<routine>_map.png` = the whole 256x256 BG map when the scene draws outside the visible 20x18 cells.
* `evidence/<routine>.png`  [scene | emulator screenshot | difference (red = differs; dimmed = cells the scene does not draw)] for scenes that an emulator capture confirms.
* `sprites/<root>_<bank>_<addr>.png`  sheet of one object table: rows = entries, columns = frame indices.  `sprite_evidence/`: frame drawn from the context vs the screenshot.
* `screens.tsv`, `sprites.tsv`, `sprite_anims.tsv`, `screen_ops.tsv`  the numbers behind the pictures (column meanings in the header comments).

## Screens

| routine | kind | tiles ok | map ok | pal ok | static cells | dynamic cells | pixels equal (static cells) | capture |
|---|---|---|---|---|---|---|---|---|
| [Account_ActionConfirmPage_Setup](screens/Account_ActionConfirmPage_Setup.png) | loader | 176/176 | 496/720 | 44/44 | 252 | 108 | 15872/15872 (100.0 %) | [evidence](evidence/Account_ActionConfirmPage_Setup.png) register/register_f04832_connect_confirm |
| [CommPanel_StateDraw](screens/CommPanel_StateDraw.png) | loader | 224/224 | 262/400 | 36/36 | 222 | 138 | 13632/13632 (100.0 %) | [evidence](evidence/CommPanel_StateDraw.png) settings_redirect/settings_redirect_f25999_r302rel_pw_change |
| [Account_ConfirmScreen_Setup](screens/Account_ConfirmScreen_Setup.png) | loader | 176/176 | 309/360 | 44/44 | 308 | 52 | 19456/19456 (100.0 %) | [evidence](evidence/Account_ConfirmScreen_Setup.png) register/register_f04208_register_summary |
| [Account_ConfirmManualScreen_Setup](screens/Account_ConfirmManualScreen_Setup.png) | loader | 208/208 | 234/360 | 44/44 | 234 | 126 | 14720/14720 (100.0 %) | [evidence](evidence/Account_ConfirmManualScreen_Setup.png) register_hidden_manual/register_hidden_manual_f06534_register_summary |
| [Registration_DeleteConfirm_Setup](screens/Registration_DeleteConfirm_Setup.png) | loader | 207/304 | 356/720 | 44/44 | - | - | - | no capture |
| [Registration_DeleteExecute_Setup](screens/Registration_DeleteExecute_Setup.png) | loader | 112/128 | 0/360 | 17/36 | - | - | - | no capture |
| [Account_LoginIdEntry_Setup](screens/Account_LoginIdEntry_Setup.png) | loader | 208/208 | 86/100 | 32/32 | 86 | 14 | 5504/5504 (100.0 %) | [evidence](evidence/Account_LoginIdEntry_Setup.png) register/register_f01138_login_id_keypad |
| [Account_LoginIdIntro_Draw](screens/Account_LoginIdIntro_Draw.png) | loader | 128/128 | 216/360 | 32/32 | 216 | 144 | 13824/13824 (100.0 %) | [evidence](evidence/Account_LoginIdIntro_Draw.png) monkey_camp_blank/monkey_camp_blank_f43744_seg7_end |
| [Account_MailAddressEntry_Setup](screens/Account_MailAddressEntry_Setup.png) | loader | 196/256 | 0/100 | 32/32 | - | - | - | no capture |
| [Account_MailIntro_Draw](screens/Account_MailIntro_Draw.png) | loader | 128/128 | 216/360 | 32/32 | 216 | 144 | 13824/13824 (100.0 %) | [evidence](evidence/Account_MailIntro_Draw.png) register/register_f01449_mail_intro |
| [Account_PasswordIntro_Draw](screens/Account_PasswordIntro_Draw.png) | loader | 128/128 | 216/360 | 32/32 | 216 | 144 | 13824/13824 (100.0 %) | [evidence](evidence/Account_PasswordIntro_Draw.png) register/register_f01956_password_intro |
| [Registration_WriteConfig_Setup](screens/Registration_WriteConfig_Setup.png) | loader | 112/176 | 0/360 | 24/36 | - | - | - | no capture |
| [Account_ResultPage](screens/Account_ResultPage.png) | loader | 128/128 | 244/360 | 20/20 | 164 | 196 | 10496/10496 (100.0 %) | [evidence](evidence/Account_ResultPage.png) register/register_f05577_registration_result |
| [SettingsMenu_DrawItems](screens/SettingsMenu_DrawItems.png) | loader | - | 600/720 | - | 0 | 360 | - | [evidence](evidence/SettingsMenu_DrawItems.png) settings_cgi/settings_cgi_f08963_cgb_empty_menu |
| [AbookAddr_SetupScreen](screens/AbookAddr_SetupScreen.png) | loader | 178/178 | 360/360 | 64/64 | 297 | 63 | 18864/18864 (100.0 %) | [evidence](evidence/AbookAddr_SetupScreen.png) addressbook_full/addressbook_full_f03837_edit_address |
| [AddrPick_InitScreen](screens/AddrPick_InitScreen.png) | loader | 185/185 | 347/360 | 64/64 | 281 | 79 | 16416/16416 (100.0 %) | [evidence](evidence/AddrPick_InitScreen.png) kbd_compose/kbd_compose_f05317_pick |
| [AbookList_SetupScreen](screens/AbookList_SetupScreen.png) | loader | 185/185 | 360/360 | 64/64 | 306 | 54 | 18016/18016 (100.0 %) | [evidence](evidence/AbookList_SetupScreen.png) addressbook_full/addressbook_full_f02648_list |
| [AbookName_SetupScreen](screens/AbookName_SetupScreen.png) | loader | 176/176 | 360/360 | 64/64 | 342 | 18 | 21696/21696 (100.0 %) | [evidence](evidence/AbookName_SetupScreen.png) addressbook_full/addressbook_full_f04613_edit_name_intro |
| [AddrBook_SaveConfirm_InitScreen](screens/AddrBook_SaveConfirm_InitScreen.png) | loader | 68/68 | 180/360 | 25/32 | 132 | 228 | 8448/8448 (100.0 %) | [evidence](evidence/AddrBook_SaveConfirm_InitScreen.png) addressbook_full/addressbook_full_f06023_edit_confirm |
| [SaveSenderAddr_InitScreen](screens/SaveSenderAddr_InitScreen.png) | loader | 131/131 | 360/360 | 64/64 | 291 | 69 | 17232/17232 (100.0 %) | [evidence](evidence/SaveSenderAddr_InitScreen.png) mail_inbox/mail_inbox_f03441_m1_save_place |
| [AddrScreenUnused_InitScreen](screens/AddrScreenUnused_InitScreen.png) | loader | 27/27 | 360/360 | 16/64 | 360 | 0 | 22272/22272 (100.0 %) | [evidence](evidence/AddrScreenUnused_InitScreen.png) forced_dead/forced_dead_f04334_f_2C_741C_b [forced run] |
| [AbookView_SetupScreen](screens/AbookView_SetupScreen.png) | loader | 93/93 | 360/360 | 64/64 | 318 | 42 | 19744/19744 (100.0 %) | [evidence](evidence/AbookView_SetupScreen.png) addressbook_full/addressbook_full_f02925_view |
| [BrowserMenu_OpenTwoItem](screens/BrowserMenu_OpenTwoItem.png) | loader | 64/80 | 51/120 | 10/12 | - | - | - | no capture |
| [BrowserMenu_OpenThreeItem](screens/BrowserMenu_OpenThreeItem.png) | loader | 80/80 | 80/120 | 12/12 | 80 | 40 | 4664/4664 (100.0 %) | [evidence](evidence/BrowserMenu_OpenThreeItem.png) browser_pages/browser_pages_f51722_menu |
| [PageList_InitScreen](screens/PageList_InitScreen.png) | loader | 176/176 | 683/720 | 64/64 | 266 | 94 | 15528/15528 (100.0 %) | [evidence](evidence/PageList_InitScreen.png) browser_bookmarks/browser_bookmarks_f07151_empty_list |
| [Browser_StartChoiceScreen](screens/Browser_StartChoiceScreen.png) | loader | 320/320 | 270/360 | 64/64 | 270 | 50 | 16740/16740 (100.0 %) | [evidence](evidence/Browser_StartChoiceScreen.png) browser_bookmarks/browser_bookmarks_f09207_back_prompt |
| [BrowserStart_DrawButtons](screens/BrowserStart_DrawButtons.png) | loader | - | 70/140 | - | 0 | 70 | - | [evidence](evidence/BrowserStart_DrawButtons.png) browser_bookmarks/browser_bookmarks_f06900_prompt |
| [CommScene_LoadGraphics](screens/CommScene_LoadGraphics.png) | loader | 512/512 | 448/448 | 11/64 | 448 | 0 | 17920/17920 (100.0 %) | [evidence](evidence/CommScene_LoadGraphics.png) browser_r2/browser_r2_f16853_s4200 |
| [ConnectDialog_Draw_ConnectConfirm](screens/ConnectDialog_Draw_ConnectConfirm.png) | loader | 128/128 | 272/400 | 32/32 | 264 | 0 | 16640/16640 (100.0 %) | [evidence](evidence/ConnectDialog_Draw_ConnectConfirm.png) browser_bookmarks/browser_bookmarks_f10215_confirm |
| [ConnectDialog_Draw_PasswordEntry](screens/ConnectDialog_Draw_PasswordEntry.png) | loader | 145/161 | 264/360 | 26/32 | 250 | 110 | 5533/5672 (97.5 %) | [evidence](evidence/ConnectDialog_Draw_PasswordEntry.png) monkey_camp_reg/monkey_camp_reg_f103608_seg15_end |
| [ConnectDialog_Draw_SavePasswordConfirm](screens/ConnectDialog_Draw_SavePasswordConfirm.png) | loader | 145/161 | 330/720 | 26/32 | 52 | 212 | 1469/1608 (91.4 %) | [evidence](evidence/ConnectDialog_Draw_SavePasswordConfirm.png) monkey_camp_reg/monkey_camp_reg_f103608_seg15_end |
| [ConnectDialog_Draw_PasswordSaved](screens/ConnectDialog_Draw_PasswordSaved.png) | loader | 32/112 | 126/360 | 32/32 | - | - | - | no capture |
| [ConnectDialog_Draw_StoredPassword](screens/ConnectDialog_Draw_StoredPassword.png) | loader | 176/176 | 256/360 | 32/32 | 256 | 104 | 16384/16384 (100.0 %) | [evidence](evidence/ConnectDialog_Draw_StoredPassword.png) mail_receive/mail_receive_f02801_password_saved |
| [ConnectDialog_Draw_ForgetConfirm](screens/ConnectDialog_Draw_ForgetConfirm.png) | loader | - | 96/360 | 32/32 | - | - | - | no capture |
| [ConnectDialog_DrawPasswordField](screens/ConnectDialog_DrawPasswordField.png) | loader | - | 630/1800 | - | - | - | - | no capture |
| [CommTime_DrawSummaryScreen](screens/CommTime_DrawSummaryScreen.png) | loader | 244/256 | 674/720 | 58/64 | 316 | 44 | 20224/20224 (100.0 %) | [evidence](evidence/CommTime_DrawSummaryScreen.png) mail_errors/mail_errors_f32676_smtp_rcpt_2 |
| [Dialog_Open](screens/Dialog_Open.png) | loader | 64/64 | 76/180 | 12/12 | 76 | 104 | 1536/1536 (100.0 %) | [evidence](evidence/Dialog_Open.png) browser_pages/browser_pages_f52804_menu_end |
| [Dialog_OpenTall](screens/Dialog_OpenTall.png) | loader | 64/64 | 112/220 | 12/12 | 112 | 108 | 3760/3760 (100.0 %) | [evidence](evidence/Dialog_OpenTall.png) browser_r2/browser_r2_f17249_s4200_c |
| [CommErr_FindRecord](screens/CommErr_FindRecord.png) | loader | - | 216/360 | - | 0 | 360 | - | [evidence](evidence/CommErr_FindRecord.png) monkey_3/monkey_3_f24460_end |
| [CommErr_DrawMessage_TimerVariant](screens/CommErr_DrawMessage_TimerVariant.png) | loader | - | 216/360 | 3/32 | 0 | 360 | - | [evidence](evidence/CommErr_DrawMessage_TimerVariant.png) monkey_3/monkey_3_f24460_end |
| [CommErr_DrawMessage_PlainVariant](screens/CommErr_DrawMessage_PlainVariant.png) | loader | - | 216/360 | - | 0 | 360 | - | [evidence](evidence/CommErr_DrawMessage_PlainVariant.png) monkey_3/monkey_3_f24460_end |
| [CommErr_PrintMessage](screens/CommErr_PrintMessage.png) | loader | - | 216/360 | - | 0 | 360 | - | [evidence](evidence/CommErr_PrintMessage.png) monkey_3/monkey_3_f24460_end |
| [CommErr_UpdateCommFooter](screens/CommErr_UpdateCommFooter.png) | loader | - | 40/40 | - | 0 | 40 | - | [evidence](evidence/CommErr_UpdateCommFooter.png) boot_states/boot_states_f05472_bank0_page1_boot |
| [NoAdapter_DrawScreen](screens/NoAdapter_DrawScreen.png) | loader | 320/320 | 360/360 | 64/64 | 360 | 0 | 22912/22912 (100.0 %) | [evidence](evidence/NoAdapter_DrawScreen.png) hotplug/hotplug_f00700_no_adapter_screen |
| [HelpMenu_ShowPage](screens/HelpMenu_ShowPage.png) | loader | 322/322 | 866/1080 | 64/64 | 283 | 37 | 17088/17088 (100.0 %) | [evidence](evidence/HelpMenu_ShowPage.png) help/help_f08687_entry_3 |
| [HelpScript_Run](screens/HelpScript_Run.png) | loader | 67/67 | 168/360 | 64/64 | 168 | 0 | 10752/10752 (100.0 %) | [evidence](evidence/HelpScript_Run.png) monkey_camp_full/monkey_camp_full_f51780_seg7_end |
| [MobileDict_Redraw](screens/MobileDict_Redraw.png) | loader | 144/144 | 200/360 | 15/64 | 200 | 0 | 12544/12544 (100.0 %) | [evidence](evidence/MobileDict_Redraw.png) monkey_camp_reg2/monkey_camp_reg2_f103552_seg15_end |
| [Kbd_LoadPageGraphics_TypeTable](screens/Kbd_LoadPageGraphics_TypeTable.png) | loader | 156/274 | 0/1560 | 21/24 | - | - | - | no capture |
| [Table_Kbd_T6_PageLoaders_Page3](screens/Table_Kbd_T6_PageLoaders_Page3.png) | loader | 276/656 | 0/220 | - | - | - | - | no capture |
| [Table_Kbd_T78_PageLoaders_Page3](screens/Table_Kbd_T78_PageLoaders_Page3.png) | loader | 276/810 | 0/560 | - | - | - | - | no capture |
| [MailAddr_SetupScreen](screens/MailAddr_SetupScreen.png) | loader | 163/163 | 360/360 | 44/44 | 312 | 48 | 19840/19840 (100.0 %) | [evidence](evidence/MailAddr_SetupScreen.png) kbd_compose/kbd_compose_f05144_compose_intro |
| [MailBody_SetupScreen](screens/MailBody_SetupScreen.png) | loader | 224/224 | 720/720 | 128/128 | 216 | 144 | 13648/13648 (100.0 %) | [evidence](evidence/MailBody_SetupScreen.png) kbd_compose/kbd_compose_f13227_body_intro |
| [MailBody_InitScreen](screens/MailBody_InitScreen.png) | loader | 41/41 | 360/360 | 64/64 | 344 | 16 | 21504/21504 (100.0 %) | [evidence](evidence/MailBody_InitScreen.png) mail_compose/mail_compose_f10238_s4 |
| [MailDraft_Menu_InitScreen](screens/MailDraft_Menu_InitScreen.png) | loader | 96/96 | 360/360 | 64/64 | 287 | 73 | 16220/16220 (100.0 %) | [evidence](evidence/MailDraft_Menu_InitScreen.png) kbd_compose/kbd_compose_f03060_saved_mail |
| [MailSession_InitScreen](screens/MailSession_InitScreen.png) | loader | 416/416 | 357/360 | 90/96 | 332 | 28 | 20480/20480 (100.0 %) | [evidence](evidence/MailSession_InitScreen.png) mail_timeout/mail_timeout_f09135_w2 |
| [MailTitle_InitScreen](screens/MailTitle_InitScreen.png) | loader | 147/147 | 360/360 | 64/64 | 345 | 15 | 21952/21952 (100.0 %) | [evidence](evidence/MailTitle_InitScreen.png) kbd_compose/kbd_compose_f07277_title_intro |
| [MailView_BodyPage_InitScreen](screens/MailView_BodyPage_InitScreen.png) | loader | 41/41 | 360/360 | 64/64 | 292 | 68 | 18176/18176 (100.0 %) | [evidence](evidence/MailView_BodyPage_InitScreen.png) mail_inbox/mail_inbox_f03771_m1_saved_2 |
| [MailView_SenderPage_InitScreen](screens/MailView_SenderPage_InitScreen.png) | loader | 120/120 | 347/360 | 64/64 | 280 | 80 | 16704/16704 (100.0 %) | [evidence](evidence/MailView_SenderPage_InitScreen.png) mail_inbox/mail_inbox_f03303_m1_sender |
| [Mailbox_LoadScreen](screens/Mailbox_LoadScreen.png) | loader | 314/352 | 642/720 | 192/192 | 256 | 104 | 16384/16384 (100.0 %) | [evidence](evidence/Mailbox_LoadScreen.png) mail_mailbox/mail_mailbox_f03225_mailbox_1 |
| [MailGrid_InitScreen](screens/MailGrid_InitScreen.png) | loader | 114/114 | 333/360 | 64/64 | 333 | 27 | 20096/20096 (100.0 %) | [evidence](evidence/MailGrid_InitScreen.png) forced_screens/forced_screens_f01298_grid2 [forced run] |
| [MailResult_InitScreen](screens/MailResult_InitScreen.png) | loader | 186/186 | 360/360 | 64/64 | 315 | 45 | 18176/18176 (100.0 %) | [evidence](evidence/MailResult_InitScreen.png) mail_errors/mail_errors_f106197_pop_dele_2 |
| [MailServerStatus_InitScreen](screens/MailServerStatus_InitScreen.png) | loader | 195/195 | 1035/1080 | 32/32 | 333 | 27 | 21312/21312 (100.0 %) | [evidence](evidence/MailServerStatus_InitScreen.png) mail_send/mail_send_f05053_result_2 |
| [MailConnect_Screen_Loop](screens/MailConnect_Screen_Loop.png) | loader | - | 262/300 | - | 20 | 80 | - | [evidence](evidence/MailConnect_Screen_Loop.png) monkey_camp_tut/monkey_camp_tut_f51768_seg7_end |
| [MailDisconnect_Screen](screens/MailDisconnect_Screen.png) | loader | - | 192/200 | - | 20 | 80 | - | [evidence](evidence/MailDisconnect_Screen.png) tutorial_profile/tutorial_profile_f17897_ending_connection |
| [MailDisconnect_ScreenNoTimer](screens/MailDisconnect_ScreenNoTimer.png) | loader | - | 192/200 | - | 20 | 80 | - | [evidence](evidence/MailDisconnect_ScreenNoTimer.png) tutorial_profile/tutorial_profile_f17897_ending_connection |
| [MailConnect_InitScreen](screens/MailConnect_InitScreen.png) | loader | 512/512 | 642/776 | 96/96 | 542 | 34 | 2944/2944 (100.0 %) | [evidence](evidence/MailConnect_InitScreen.png) mail_receive/mail_receive_f03135_connecting |
| [CommTime_DrawHMSScreen](screens/CommTime_DrawHMSScreen.png) | loader | 128/192 | 357/720 | 45/96 | - | - | - | no capture |
| [MailSrvDelHidden_MenuSelect](screens/MailSrvDelHidden_MenuSelect.png) | loader | - | 950/1080 | - | 57 | 303 | 3336/3336 (100.0 %) | [evidence](evidence/MailSrvDelHidden_MenuSelect.png) mail_server_hidden2/mail_server_hidden2_f16582_menu_down |
| [MailSrvDelHidden_MenuInit](screens/MailSrvDelHidden_MenuInit.png) | loader | 148/148 | 950/1080 | 64/64 | 204 | 156 | 12725/12725 (100.0 %) | [evidence](evidence/MailSrvDelHidden_MenuInit.png) mail_server_hidden2/mail_server_hidden2_f17316_down_refused |
| [MailSrvDelHidden_Confirm](screens/MailSrvDelHidden_Confirm.png) | loader | 88/114 | 360/360 | 64/64 | 280 | 80 | 17664/17664 (100.0 %) | [evidence](evidence/MailSrvDelHidden_Confirm.png) mail_server_full/mail_server_full_f15135_all_confirm |
| [MailSrvDel_MenuSelect](screens/MailSrvDel_MenuSelect.png) | loader | - | 655/720 | - | 98 | 262 | 5957/5957 (100.0 %) | [evidence](evidence/MailSrvDel_MenuSelect.png) mail_server/mail_server_f04628_mailserver_3 |
| [MailSrvDel_MenuInit](screens/MailSrvDel_MenuInit.png) | loader | 148/148 | 655/720 | 64/64 | 269 | 91 | 16792/16792 (100.0 %) | [evidence](evidence/MailSrvDel_MenuInit.png) mail_server_full/mail_server_full_f15266_all_refused |
| [MailSrvDel_Confirm](screens/MailSrvDel_Confirm.png) | loader | 88/114 | 360/360 | 64/64 | 280 | 80 | 17664/17664 (100.0 %) | [evidence](evidence/MailSrvDel_Confirm.png) mail_server_full/mail_server_full_f15135_all_confirm |
| [MailSrvDel_ProgressInit](screens/MailSrvDel_ProgressInit.png) | loader | 11/102 | 0/360 | 35/64 | - | - | - | no capture |
| [MailServerMgr_Run](screens/MailServerMgr_Run.png) | loader | 1/1 | 674/960 | - | 86 | 274 | 5404/5404 (100.0 %) | [evidence](evidence/MailServerMgr_Run.png) mail_server_many/mail_server_many_f08597_mail2 |
| [MailServerMgr_SetupScreen](screens/MailServerMgr_SetupScreen.png) | loader | 296/296 | 337/480 | 64/64 | 198 | 162 | 12228/12228 (100.0 %) | [evidence](evidence/MailServerMgr_SetupScreen.png) mail_server_many/mail_server_many_f08597_mail2 |
| [MailServerMgr_RedrawScreen](screens/MailServerMgr_RedrawScreen.png) | loader | 296/296 | 337/480 | 64/64 | 198 | 162 | 12228/12228 (100.0 %) | [evidence](evidence/MailServerMgr_RedrawScreen.png) mail_server_many/mail_server_many_f08597_mail2 |
| [MailServerMgr_DrawMailInfo](screens/MailServerMgr_DrawMailInfo.png) | loader | - | 1312/1440 | - | 83 | 277 | 5212/5212 (100.0 %) | [evidence](evidence/MailServerMgr_DrawMailInfo.png) mail_server_full/mail_server_full_f08395_check_mail3 |
| [MailMenu_Run](screens/MailMenu_Run.png) | loader | 345/345 | 315/360 | 64/64 | 289 | 31 | 18112/18112 (100.0 %) | [evidence](evidence/MailMenu_Run.png) mail_server/mail_server_f07882_mailserver_11 |
| [MailMenu_AnimateIcon](screens/MailMenu_AnimateIcon.png) | loader | - | 83/96 | - | 0 | 48 | - | [evidence](evidence/MailMenu_AnimateIcon.png) kbd_compose/kbd_compose_f21567_end_yes |
| [TopMenu_Run](screens/TopMenu_Run.png) | loader | 400/400 | 284/320 | 64/64 | 284 | 36 | 16080/16080 (100.0 %) | [evidence](evidence/TopMenu_Run.png) boot_states/boot_states_f01618_control_a1 |
| [TopMenu_LoadPanel](screens/TopMenu_LoadPanel.png) | loader | - | 284/320 | - | 0 | 320 | - | [evidence](evidence/TopMenu_LoadPanel.png) boot_states/boot_states_f01618_control_a1 |
| [TopMenu_AnimatePanel](screens/TopMenu_AnimatePanel.png) | loader | - | 108/108 | - | 0 | 108 | - | [evidence](evidence/TopMenu_AnimatePanel.png) help/help_f01792_help_hover |
| [Profile_InitScreen](screens/Profile_InitScreen.png) | loader | 174/174 | 360/360 | 64/64 | 313 | 47 | 19104/19104 (100.0 %) | [evidence](evidence/Profile_InitScreen.png) kbd_profile/kbd_profile_f04430_profile |
| [AdapterCheck_DrawScreen](screens/AdapterCheck_DrawScreen.png) | loader | 144/144 | 360/360 | 64/64 | 360 | 0 | 22912/22912 (100.0 %) | [evidence](evidence/AdapterCheck_DrawScreen.png) hotplug/hotplug_f01464_retry_without_adapter |
| [SettingsPhone_ChoiceMenu_Setup](screens/SettingsPhone_ChoiceMenu_Setup.png) | loader | 272/416 | 424/720 | 36/36 | 224 | 136 | 14080/14080 (100.0 %) | [evidence](evidence/SettingsPhone_ChoiceMenu_Setup.png) register_hidden/register_hidden_f02085_phone_method |
| [SettingsPhone_ConfirmScreen_Setup](screens/SettingsPhone_ConfirmScreen_Setup.png) | loader | 210/210 | 288/360 | 44/44 | 288 | 72 | 18176/18176 (100.0 %) | [evidence](evidence/SettingsPhone_ConfirmScreen_Setup.png) settings_phone/settings_phone_f04820_auto_confirm |
| [SettingsPhone_ContinuePrompt_Setup](screens/SettingsPhone_ContinuePrompt_Setup.png) | loader | 160/160 | 252/360 | 44/44 | 252 | 108 | 15872/15872 (100.0 %) | [evidence](evidence/SettingsPhone_ContinuePrompt_Setup.png) settings_phone/settings_phone_f05454_auto_register |
| [PwSaveConfirm_Setup](screens/PwSaveConfirm_Setup.png) | loader | 176/176 | 496/720 | 44/44 | 244 | 116 | 15360/15360 (100.0 %) | [evidence](evidence/PwSaveConfirm_Setup.png) register/register_f03584_password_save_confirm |
| [PhoneComment_KeyboardSetup](screens/PhoneComment_KeyboardSetup.png) | loader | 256/256 | 76/100 | 32/32 | 76 | 24 | 4864/4864 (100.0 %) | [evidence](evidence/PhoneComment_KeyboardSetup.png) register_hidden_manual/register_hidden_manual_f03803_manual_comment_intro |
| [PhoneKeypad_Setup](screens/PhoneKeypad_Setup.png) | loader | 256/256 | 140/200 | 32/32 | 64 | 36 | 4096/4096 (100.0 %) | [evidence](evidence/PhoneKeypad_Setup.png) register_hidden_manual/register_hidden_manual_f02483_manual_keypad_1 |
| [SettingsPhone_SlotMenu_Setup](screens/SettingsPhone_SlotMenu_Setup.png) | loader | 396/514 | 288/360 | 36/36 | 288 | 72 | 18304/18304 (100.0 %) | [evidence](evidence/SettingsPhone_SlotMenu_Setup.png) settings_phone/settings_phone_f03252_auto_place |
| [Notice_ShowPage](screens/Notice_ShowPage.png) | loader | 29/29 | 576/720 | 3/20 | 0 | 360 | - | [evidence](evidence/Notice_ShowPage.png) monkey_3/monkey_3_f24460_end |
| [Title_LoadTitleScreen](screens/Title_LoadTitleScreen.png) | loader | 448/448 | 326/360 | 64/64 | 326 | 34 | 16832/16832 (100.0 %) | [evidence](evidence/Title_LoadTitleScreen.png) boot_states/boot_states_f01000_control_boot |
| [Title_LoadLogoScreen](screens/Title_LoadLogoScreen.png) | loader | 128/128 | 360/360 | 32/32 | 360 | 0 | 23040/23040 (100.0 %) | [evidence](evidence/Title_LoadLogoScreen.png) boot_combos/boot_combos_f00414_combo_1 |
| [PageListProto_InitScreen](screens/PageListProto_InitScreen.png) | loader | 0/123 | 30/360 | 17/64 | - | - | - | no capture |
| [BrowserFrame_Styles0](screens/BrowserFrame_Styles0.png) | descriptor | 224/224 | 103/360 | 64/64 | 102 | 258 | 5312/5312 (100.0 %) | [evidence](evidence/BrowserFrame_Styles0.png) settings_cgi/settings_cgi_f35170_cgb_ascii_time |
| [BrowserFrame_Styles1](screens/BrowserFrame_Styles1.png) | descriptor | 224/224 | 102/360 | 64/64 | 102 | 258 | 5272/5272 (100.0 %) | [evidence](evidence/BrowserFrame_Styles1.png) browser_bookmarks/browser_bookmarks_f12996_index |
| [BrowserFrame_Styles2](screens/BrowserFrame_Styles2.png) | descriptor | 224/224 | 102/360 | 64/64 | 102 | 258 | 6528/6528 (100.0 %) | [evidence](evidence/BrowserFrame_Styles2.png) monkey_camp_tut/monkey_camp_tut_f103500_seg15_end |
| [BrowserFrame_Styles3_to_22](screens/BrowserFrame_Styles3_to_22.png) | descriptor | 224/224 | 102/360 | 64/64 | 102 | 258 | 6528/6528 (100.0 %) | [evidence](evidence/BrowserFrame_Styles3_to_22.png) monkey_camp_tut/monkey_camp_tut_f103500_seg15_end |
| [BrowserFrame_Styles23_to_26](screens/BrowserFrame_Styles23_to_26.png) | descriptor | 224/224 | 102/360 | 64/64 | 102 | 258 | 5272/5272 (100.0 %) | [evidence](evidence/BrowserFrame_Styles23_to_26.png) browser_bookmarks/browser_bookmarks_f12996_index |
| [BrowserFrameUnused_41_0](screens/BrowserFrameUnused_41_0.png) | hypothesis | 98/224 | 1/360 | 41/64 | - | - | - | no capture |
| [BrowserFrameUnused_41_1](screens/BrowserFrameUnused_41_1.png) | hypothesis | 92/224 | 0/360 | 38/64 | - | - | - | no capture |
| [BrowserFrameUnused_41_2](screens/BrowserFrameUnused_41_2.png) | hypothesis | 1/224 | 216/360 | 14/64 | - | - | - | no capture |
| [BrowserFrameUnused_41_3](screens/BrowserFrameUnused_41_3.png) | hypothesis | 134/224 | 3/360 | 41/64 | - | - | - | no capture |
| [BrowserFrameUnused_42_0](screens/BrowserFrameUnused_42_0.png) | hypothesis | 118/224 | 0/360 | 43/64 | - | - | - | no capture |
| [BrowserFrameUnused_42_1](screens/BrowserFrameUnused_42_1.png) | hypothesis | 85/224 | 0/360 | 38/64 | - | - | - | no capture |
| [BrowserFrameUnused_42_2](screens/BrowserFrameUnused_42_2.png) | hypothesis | 100/224 | 38/360 | 34/64 | - | - | - | no capture |
| [BrowserFrameUnused_42_3](screens/BrowserFrameUnused_42_3.png) | hypothesis | 125/224 | 1/360 | 43/64 | - | - | - | no capture |
| [BrowserFrameUnused_43_0](screens/BrowserFrameUnused_43_0.png) | hypothesis | 145/224 | 1/360 | 41/64 | - | - | - | no capture |
| [BrowserFrameUnused_43_1](screens/BrowserFrameUnused_43_1.png) | hypothesis | 134/224 | 4/360 | 46/64 | - | - | - | no capture |
| [BrowserFrameUnused_43_2](screens/BrowserFrameUnused_43_2.png) | hypothesis | 98/224 | 3/360 | 45/64 | - | - | - | no capture |
| [BrowserFrameUnused_43_3](screens/BrowserFrameUnused_43_3.png) | hypothesis | 1/224 | 212/360 | 13/64 | - | - | - | no capture |
| [BrowserFrameUnused_44_0](screens/BrowserFrameUnused_44_0.png) | hypothesis | 123/224 | 0/360 | 39/64 | - | - | - | no capture |
| [BrowserFrameUnused_44_1](screens/BrowserFrameUnused_44_1.png) | hypothesis | 72/224 | 7/360 | 32/64 | - | - | - | no capture |
| [BrowserFrameUnused_44_2](screens/BrowserFrameUnused_44_2.png) | hypothesis | 90/224 | 0/360 | 38/64 | - | - | - | no capture |
| [BrowserFrameUnused_44_3](screens/BrowserFrameUnused_44_3.png) | hypothesis | 142/224 | 3/360 | 43/64 | - | - | - | no capture |
| [BrowserFrameUnused_45_0](screens/BrowserFrameUnused_45_0.png) | hypothesis | 91/224 | 0/360 | 36/64 | - | - | - | no capture |
| [BrowserFrameUnused_45_1](screens/BrowserFrameUnused_45_1.png) | hypothesis | 1/224 | 205/360 | 16/64 | - | - | - | no capture |
| [BrowserFrameUnused_45_2](screens/BrowserFrameUnused_45_2.png) | hypothesis | 73/224 | 170/360 | 14/64 | - | - | - | no capture |
| [BrowserFrameUnused_45_3](screens/BrowserFrameUnused_45_3.png) | hypothesis | 90/224 | 0/360 | 40/64 | - | - | - | no capture |
| [BrowserFrameUnused_46_0](screens/BrowserFrameUnused_46_0.png) | hypothesis | 108/224 | 2/360 | 40/64 | - | - | - | no capture |
| [BrowserFrameUnused_46_1](screens/BrowserFrameUnused_46_1.png) | hypothesis | 87/224 | 0/360 | 40/64 | - | - | - | no capture |
| [BrowserFrameUnused_46_2](screens/BrowserFrameUnused_46_2.png) | hypothesis | 99/224 | 2/360 | 40/64 | - | - | - | no capture |
| [BrowserFrameUnused_46_3](screens/BrowserFrameUnused_46_3.png) | hypothesis | 86/224 | 107/360 | 16/64 | - | - | - | no capture |

## Sprites

| root | bank:addr | entries | records | context | size | found / identical records | pixel check exact / compared | (context identical to emulator) exact / compared | sheet |
|---|---|---|---|---|---|---|---|---|---|
| Objects_Title | 0E:5FB0 | 2 | 5 | assets | 8x16 (LCDC bit 2 set in 10/10 captures) | 4 / 4 | 10 / 10 | 10 / 10 | [png](sprites/Objects_Title_0E_5FB0.png) |
| Table_DebugFlags_Objects | 19:481D | 1 | 1 | emulator | 8x16 (LCDC bit 2 set in 6/11 captures) | 1 / 0 | 1 / 11 | 0 / 0 | [png](sprites/Table_DebugFlags_Objects_19_481D.png) |
| Objects_MobileDict | 1A:55A0 | 13 | 15 | emulator | 8x8 (LCDC bit 2 clear in 1/1 captures) | 1 / 0 | 0 / 1 | 0 / 0 | [png](sprites/Objects_MobileDict_1A_55A0.png) |
| Table_MailMenu_Objects | 1D:63B6 | 1 | 9 | assets | 8x8 (LCDC bit 2 clear in 48/48 captures) | 9 / 9 | 16 / 16 | 16 / 16 | [png](sprites/Table_MailMenu_Objects_1D_63B6.png) |
| TopMenu_ObjTable | 1E:656F | 6 | 30 | assets | 8x16 (LCDC bit 2 set in 31/36 captures) | 18 / 16 | 12 / 20 | 12 / 12 | [png](sprites/TopMenu_ObjTable_1E_656F.png) |
| Table_SpriteCounter_Digits | 23:7990 | 80 | 20 | emulator | 8x8 (LCDC bit 2 clear in 2348/2412 captures) | 20 / 0 | 6 / 40 | 0 / 0 | [png](sprites/Table_SpriteCounter_Digits_23_7990.png) |
| Table_MailSrvDel_ProgressObject | 23:7AD0 | 4 | 2 | partial | 8x8 (not observed) | 0 / 0 | 0 / 0 | 0 / 0 | [png](sprites/Table_MailSrvDel_ProgressObject_23_7AD0.png) |
| PageList_ObjTable | 24:6530 | 36 | 35 | assets | 8x8 (LCDC bit 2 clear in 430/430 captures) | 17 / 17 | 40 / 40 | 40 / 40 | [png](sprites/PageList_ObjTable_24_6530.png) |
| MailResult_ObjTable | 24:7B20 | 56 | 14 | assets | 8x8 (LCDC bit 2 clear in 279/279 captures) | 14 / 7 | 0 / 40 | 0 / 0 | [png](sprites/MailResult_ObjTable_24_7B20.png) |
| Mailbox_ObjTable | 26:7B00 | 56 | 19 | assets | 8x8 (LCDC bit 2 clear in 387/387 captures) | 18 / 18 | 24 / 40 | 24 / 24 | [png](sprites/Mailbox_ObjTable_26_7B00.png) |
| MailConnect_ObjTable | 27:7A10 | 56 | 22 | assets | 8x16 (LCDC bit 2 set in 32/32 captures) | 9 / 9 | 27 / 27 | 23 / 23 | [png](sprites/MailConnect_ObjTable_27_7A10.png) |
| MailBody_ObjTable | 28:4B70 | 4 | 1 | assets | 8x8 (LCDC bit 2 clear in 14/14 captures) | 1 / 1 | 7 / 14 | 7 / 7 | [png](sprites/MailBody_ObjTable_28_4B70.png) |
| AddrBookShared_ObjTable | 28:5210 | 28 | 18 | assets | 8x8 (LCDC bit 2 clear in 513/513 captures) | 10 / 10 | 4 / 4 | 4 / 4 | [png](sprites/AddrBookShared_ObjTable_28_5210.png) |
| MailServerDeleteMethod_ObjTable | 28:6E80 | 8 | 4 | assets | 8x8 (LCDC bit 2 clear in 14/14 captures) | 2 / 1 | 12 / 14 | 12 / 12 | [png](sprites/MailServerDeleteMethod_ObjTable_28_6E80.png) |
| MailSession_ObjTable_6F20 | 28:6F20 | 72 | 33 | assets | 8x16 (LCDC bit 2 set in 22/22 captures) | 13 / 9 | 12 / 12 | 12 / 12 | [png](sprites/MailSession_ObjTable_6F20_28_6F20.png) |
| MailSession_ObjTable_72FB | 28:72FB | 164 | 53 | emulator | 8x16 (LCDC bit 2 set in 37/37 captures) | 20 / 0 | 0 / 22 | 0 / 0 | [png](sprites/MailSession_ObjTable_72FB_28_72FB.png) |
| Table_MailBody_ObjectEntries | 29:6350 | 40 | 20 | emulator | 8x8 (LCDC bit 2 clear in 262/274 captures) | 12 / 0 | 0 / 40 | 0 / 0 | [png](sprites/Table_MailBody_ObjectEntries_29_6350.png) |
| Table_Profile_Anims | 2A:6E50 | 20 | 10 | assets | 8x8 (LCDC bit 2 clear in 68/68 captures) | 4 / 4 | 17 / 17 | 17 / 17 | [png](sprites/Table_Profile_Anims_2A_6E50.png) |
| Table_MailDraftMenu_Anims | 2B:51D0 | 28 | 14 | assets | 8x8 (LCDC bit 2 clear in 11/14 captures) | 6 / 6 | 12 / 12 | 12 / 12 | [png](sprites/Table_MailDraftMenu_Anims_2B_51D0.png) |
| Table_MailGrid_Anims | 2B:6430 | 4 | 1 | assets | 8x16 (LCDC bit 2 set in 2/2 captures) | 1 / 1 | 2 / 2 | 2 / 2 | [png](sprites/Table_MailGrid_Anims_2B_6430.png) |
| Table_MailView_Anims | 2B:78A0 | 32 | 16 | partial | 8x8 (LCDC bit 2 clear in 86/91 captures) | 5 / 4 | 40 / 40 | 40 / 40 | [png](sprites/Table_MailView_Anims_2B_78A0.png) |
| Table_AddrSlotIcon_Anims | 2C:7210 | 20 | 14 | assets | 8x8 (LCDC bit 2 clear in 351/351 captures) | 7 / 7 | 0 / 0 | 0 / 0 | [png](sprites/Table_AddrSlotIcon_Anims_2C_7210.png) |
| Table_AddrScreenUnused_Objects | 2C:7C40 | 4 | 1 | partial | 8x16 (LCDC bit 2 set in 2/2 captures) | 1 / 1 | 2 / 2 | 1 / 1 | [png](sprites/Table_AddrScreenUnused_Objects_2C_7C40.png) |
| Table_MailServerMgr_ObjAnims | 2E:76C0 | 20 | 10 | emulator | 8x8 (LCDC bit 2 clear in 24/24 captures) | 2 / 0 | 0 / 24 | 0 / 0 | [png](sprites/Table_MailServerMgr_ObjAnims_2E_76C0.png) |
| Table_Abook_ButtonCursorAnims | 2F:5010 | 16 | 4 | assets | 8x8 (LCDC bit 2 clear in 4/4 captures) | 2 / 2 | 2 / 2 | 2 / 2 | [png](sprites/Table_Abook_ButtonCursorAnims_2F_5010.png) |
| Table_Abook_ViewCursorAnims | 2F:57B0 | 4 | 1 | assets | 8x8 (LCDC bit 2 clear in 3/3 captures) | 1 / 1 | 3 / 3 | 3 / 3 | [png](sprites/Table_Abook_ViewCursorAnims_2F_57B0.png) |
| ConfirmPages_ObjTable | 4A:4000 | 1 | 2 | assets | 8x8 (LCDC bit 2 clear in 17/17 captures) | 2 / 2 | 17 / 17 | 17 / 17 | [png](sprites/ConfirmPages_ObjTable_4A_4000.png) |
| SettingsMenu_ObjTable | 4A:5838 | 1 | 2 | assets | 8x8 (LCDC bit 2 clear in 8/8 captures) | 2 / 2 | 8 / 8 | 8 / 8 | [png](sprites/SettingsMenu_ObjTable_4A_5838.png) |
| AdapterCheck_ObjTableAndAnimData | 4A:68D0 | 1 | 4 | assets | 8x8 (LCDC bit 2 clear in 1/1 captures) | 1 / 1 | 1 / 1 | 1 / 1 | [png](sprites/AdapterCheck_ObjTableAndAnimData_4A_68D0.png) |
| SettingsPhone_ChoiceMenu_ObjTable | 4D:5D10 | 1 | 2 | assets | 8x8 (LCDC bit 2 clear in 7/7 captures) | 2 / 2 | 7 / 7 | 7 / 7 | [png](sprites/SettingsPhone_ChoiceMenu_ObjTable_4D_5D10.png) |
| SettingsPhone_SlotMenu_ObjTable | 4D:7960 | 1 | 2 | assets | 8x8 (LCDC bit 2 clear in 38/38 captures) | 2 / 2 | 5 / 19 | 5 / 5 | [png](sprites/SettingsPhone_SlotMenu_ObjTable_4D_7960.png) |
| CommNotice_ObjTable | 50:6D16 | 2 | 4 | emulator | 8x8 (LCDC bit 2 clear in 2/2 captures) | 2 / 0 | 0 / 1 | 0 / 0 | [png](sprites/CommNotice_ObjTable_50_6D16.png) |
| ConnectDialog_ObjTable | 56:79B8 | 5 | 15 | assets | 8x8 (LCDC bit 2 clear in 15/15 captures) | 6 / 6 | 8 / 10 | 8 / 8 | [png](sprites/ConnectDialog_ObjTable_56_79B8.png) |
| CommErr_ObjTable | 5C:642B | 1 | 2 | assets | 8x8 (LCDC bit 2 clear in 14/14 captures) | 1 / 1 | 14 / 14 | 14 / 14 | [png](sprites/CommErr_ObjTable_5C_642B.png) |
| Kbd_ObjTable | 5F:4CF8 | 14 | 17 | assets | 8x8 (LCDC bit 2 clear in 140/140 captures) | 14 / 12 | 24 / 40 | 24 / 24 | [png](sprites/Kbd_ObjTable_5F_4CF8.png) |
| NoAdapter_ObjTable | 63:7310 | 1 | 2 | assets | 8x8 (LCDC bit 2 clear in 164/168 captures) | 2 / 2 | 0 / 40 | 0 / 0 | [png](sprites/NoAdapter_ObjTable_63_7310.png) |
| ConnIcon_ObjTable | 69:4778 | 7 | 26 | emulator | 8x8 (LCDC bit 2 clear in 219/219 captures) | 17 / 0 | 0 / 40 | 0 / 0 | [png](sprites/ConnIcon_ObjTable_69_4778.png) |
| Table_6A_72BB | 6A:72BB | 1 | 2 | assets | 8x8 (LCDC bit 2 clear in 92/96 captures) | 2 / 2 | 6 / 33 | 6 / 6 | [png](sprites/Table_6A_72BB_6A_72BB.png) |
| CommScene_ObjTable | 70:534C | 3 | 4 | assets | 8x16 (LCDC bit 2 set in 17/17 captures) | 3 / 3 | 17 / 17 | 13 / 13 | [png](sprites/CommScene_ObjTable_70_534C.png) |
| CommScene_SpriteObjTable | 70:53EB | 5 | 7 | assets | 8x16 (LCDC bit 2 set in 3/3 captures) | 1 / 1 | 3 / 3 | 3 / 3 | [png](sprites/CommScene_SpriteObjTable_70_53EB.png) |
| CommPanel_ObjTable | 71:4FB8 | 1 | 3 | assets | 8x8 (LCDC bit 2 clear in 1/1 captures) | 1 / 1 | 1 / 1 | 1 / 1 | [png](sprites/CommPanel_ObjTable_71_4FB8.png) |
| Registration_DeleteExecute_ObjTable | 71:6F38 | 1 | 2 | assets | 8x8 (not observed) | 0 / 0 | 0 / 0 | 0 / 0 | [png](sprites/Registration_DeleteExecute_ObjTable_71_6F38.png) |
| Dialog_CursorObjTable | 72:4E40 | 2 | 2 | assets | 8x8 (LCDC bit 2 clear in 36/37 captures) | 2 / 2 | 36 / 36 | 36 / 36 | [png](sprites/Dialog_CursorObjTable_72_4E40.png) |
| BrowserShared_ObjTable | 72:7828 | 17 | 23 | emulator | 8x8 (LCDC bit 2 clear in 672/676 captures) | 16 / 1 | 0 / 40 | 0 / 0 | [png](sprites/BrowserShared_ObjTable_72_7828.png) |
| BrowserStart_ObjTable | 73:5F0F | 2 | 9 | emulator | 8x8 (LCDC bit 2 clear in 31/36 captures) | 6 / 2 | 7 / 29 | 7 / 7 | [png](sprites/BrowserStart_ObjTable_73_5F0F.png) |
| PageListProto_ObjTable | 7F:6DB0 | 40 | 30 | emulator | 8x8 (LCDC bit 2 clear in 1/1 captures) | 1 / 0 | 0 / 1 | 0 / 0 | [png](sprites/PageListProto_ObjTable_7F_6DB0.png) |
| Table_TextCursor_ObjTables | 7F:7B40 | 20 | 15 | assets | 8x8 (LCDC bit 2 clear in 159/163 captures) | 9 / 9 | 10 / 11 | 10 / 10 | [png](sprites/Table_TextCursor_ObjTables_7F_7B40.png) |
