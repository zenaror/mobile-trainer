; consts.asm -- numeric constants (record offsets, counts, sound effect ids); exported.  The sound effect ids are written as the argument of `play_sfx` (constants/macros.inc); the other constants
; are documentation and are not substituted into operands.
; The status word after each value is the evidence level (see STYLE.md).

DEF MAILREC_OFS_TIME EQU $0003 ; PROBABLE Record offset of the 6-byte BCD timestamp yyyy mm dd hh mm (sample headers 20 00 06 28 12 30 ...; 2E prints the same format as a date)
EXPORT MAILREC_OFS_TIME
DEF ABOOK_SLOT_COUNT EQU $0006 ; CONFIRMED Address-book slots: Abook_SlotAddrTable* have 6 words, AbookList_CursorDown wraps at 6
EXPORT ABOOK_SLOT_COUNT
DEF MAILREC_OFS_BODY EQU $0009 ; CONFIRMED Record offset of the body ($C0 bytes): sample installer target A12D = A124+9, staged with WRAM D400 (2D:403C)
EXPORT MAILREC_OFS_BODY
DEF MAILREC_COUNT EQU $000C ; CONFIRMED Number of mail records: 12 words in MailRecord_AddrTable, 12 in-use bytes scanned by 25:4A90, MailRecord_Delete loops B up to $0C (2D:4164)
EXPORT MAILREC_COUNT
DEF MAIL_NAME_SIZE EQU $0010 ; CONFIRMED Name buffer size: D514-D523, SRAM A114-A123 and address-book slot +0 (8 double-byte chars, AbookName_GetLength cap)
EXPORT MAIL_NAME_SIZE
DEF ABOOK_SLOT_OFS_ADDRESS EQU $0010 ; CONFIRMED Address-book slot offset of the $40-byte address (Abook_ProbeSlot adds $10 to the slot pointer)
EXPORT ABOOK_SLOT_OFS_ADDRESS
DEF MAIL_SUBJECT_SIZE EQU $0014 ; CONFIRMED Subject buffer size: D500-D513, SRAM A100-A113 (10 double-byte chars)
EXPORT MAIL_SUBJECT_SIZE
DEF MAIL_ADDRESS_SIZE EQU $0040 ; CONFIRMED Address buffer size: D4C0-D4FF, SRAM A000-A03F, MailAddr_GetLength cap
EXPORT MAIL_ADDRESS_SIZE
DEF ABOOK_SLOT_SIZE EQU $0050 ; CONFIRMED Address-book slot size: stride of A69D,A6ED,A73D,A78D,A7DD,A82D (name $10 + address $40)
EXPORT ABOOK_SLOT_SIZE
DEF TICKER_PAUSE_FRAMES EQU $00B4 ; CONFIRMED Frames the ticker waits before it starts scrolling and after each loop ($B4 = 180 stored in wTickerPauseFrames C0F3 by Ticker_Start/Ticker_Update)
EXPORT TICKER_PAUSE_FRAMES
DEF MAIL_BODY_SIZE EQU $00C0 ; CONFIRMED Body buffer size: 8 rows x 12 cells x 2 bytes; D400-D4BF, SRAM A040-A0FF, MailBody_GetLength cap
EXPORT MAIL_BODY_SIZE
DEF MAILREC_OFS_NAME EQU $00C9 ; CONFIRMED Record offset of the sender name ($10 bytes): sample installer A1ED = A124+$C9, receiver adds $C9 to the free record (54:4DB5), reply copies it to D514
EXPORT MAILREC_OFS_NAME
DEF MAILREC_OFS_SUBJECT EQU $00D9 ; CONFIRMED Record offset of the subject ($14 bytes): sample installer A1FD = A124+$D9, receiver adds $D9 to the free record (54:4E01)
EXPORT MAILREC_OFS_SUBJECT
DEF MAILREC_OFS_ADDRESS EQU $00ED ; CONFIRMED Record offset of the sender address ($40 bytes; $ED+$40 = MAILREC_SIZE): sample installer A211, receiver adds $ED (54:4DBD), reply copies it to D4C0
EXPORT MAILREC_OFS_ADDRESS
DEF MAILREC_SIZE EQU $012D ; CONFIRMED Bytes per mail record: stride of A124,A251,A37E..AE13 and the copy/zero length bc=$012D in MailRecord_Delete (2D:4153, 416B)
EXPORT MAILREC_SIZE
DEF MobileCmd_BeginSession EQU $0010 ; CONFIRMED BEGIN_SESSION (adapter start): template 75:5FFC, adapter.log 10 Start session
EXPORT MobileCmd_BeginSession
DEF MobileCmd_EndSession EQU $0011 ; CONFIRMED END_SESSION: template 75:600E
EXPORT MobileCmd_EndSession
DEF MobileCmd_DialTelephone EQU $0012 ; CONFIRMED DIAL_TELEPHONE: template 75:6018, adapter.log 12 Call
EXPORT MobileCmd_DialTelephone
DEF MobileCmd_HangUpTelephone EQU $0013 ; CONFIRMED HANG_UP_TELEPHONE: template 75:601E, adapter.log 13
EXPORT MobileCmd_HangUpTelephone
DEF MobileCmd_WaitForTelephoneCall EQU $0014 ; CONFIRMED WAIT_FOR_TELEPHONE_CALL: template 75:6063
EXPORT MobileCmd_WaitForTelephoneCall
DEF MobileCmd_TransferData EQU $0015 ; CONFIRMED TRANSFER_DATA: template 75:606D, adapter.log 15 Transfer data
EXPORT MobileCmd_TransferData
DEF MobileCmd_TelephoneStatus EQU $0017 ; CONFIRMED TELEPHONE_STATUS: template 75:6028, adapter.log 17 Status
EXPORT MobileCmd_TelephoneStatus
DEF MobileCmd_ReadConfigurationData EQU $0019 ; CONFIRMED READ_CONFIGURATION_DATA: templates 75:6041/604D, adapter.log 19 Read EEPROM
EXPORT MobileCmd_ReadConfigurationData
DEF MobileCmd_WriteConfigurationData EQU $001A ; CONFIRMED WRITE_CONFIGURATION_DATA: header 75:6059, adapter.log 1A Write EEPROM
EXPORT MobileCmd_WriteConfigurationData
DEF MobileCmd_TransferDataEnd EQU $001F ; CONFIRMED TRANSFER_DATA_END: reply command $9F = connection closed (accepted as $95 by SerialReceive 75:572E-5732)
EXPORT MobileCmd_TransferDataEnd
DEF MobileCmd_IspLogin EQU $0021 ; CONFIRMED ISP_LOGIN: header 75:6032, adapter.log 21 PPP connect
EXPORT MobileCmd_IspLogin
DEF MobileCmd_IspLogout EQU $0022 ; CONFIRMED ISP_LOGOUT: template 75:6037, adapter.log 22 PPP disconnect
EXPORT MobileCmd_IspLogout
DEF MobileCmd_OpenTcpConnection EQU $0023 ; CONFIRMED OPEN_TCP_CONNECTION: header 75:6078, adapter.log 23 TCP connect
EXPORT MobileCmd_OpenTcpConnection
DEF MobileCmd_CloseTcpConnection EQU $0024 ; CONFIRMED CLOSE_TCP_CONNECTION: header 75:607E, adapter.log 24 TCP disconnect
EXPORT MobileCmd_CloseTcpConnection
DEF MobileCmd_DnsQuery EQU $0028 ; CONFIRMED DNS_QUERY: header 75:605E, adapter.log 28 DNS request
EXPORT MobileCmd_DnsQuery
DEF MobileCmd_Error EQU $006E ; CONFIRMED ERROR: adapter error packet ($EE reply) parsed by Mobile_GetErrorCode 75:5E34
EXPORT MobileCmd_Error
; Sound effect ids that stay numbers (no name is true at every site; roles read from the code around the single call): $002F plays when a communication wait ends, for a completed step at three sites and for a cancel at four;
; $003A (keyboard page cycled by Select), $003B (newline accepted in the mail body), $003C (a mail is about to be retrieved), $0043 (the send phase starts), $003D (MailSession_Finish), $0040 and $0041 (help script
; page turns), $0042 (no mail / cannot receive): one site each; $0048 and the cursor / A / B ids of the dead page-list prototype follow an older table.  docs/research/naming2_sfx1.md.
DEF SFX_CURSOR_MOVE EQU $0029 ; PROBABLE selection cursor moved: Up/Down/Left/Right on menus, lists, Yes/No pairs, tabs and keyboard cells (also when nothing can move: settings/slot_menu.asm:244), Start jumps to the OK key (keyboard/keyboard.asm:294), list re-placed after a mail delete (mail/mailbox.asm:1413); menus/mail_menu.asm:282 1D:4284, keyboard/keyboard.asm:595 55:5F71
EXPORT SFX_CURSOR_MOVE
DEF SFX_TOP_MENU_LEFT_RIGHT EQU $002A ; PROBABLE top menu cursor moved Left to item 1 / Right to item 2, only when it changes (menus/top_menu.asm:297 1F:42B7, :313 1F:42D8)
EXPORT SFX_TOP_MENU_LEFT_RIGHT
DEF SFX_TOP_MENU_UP_DOWN EQU $002B ; PROBABLE top menu cursor moved Down to item 3 / Up from item 3 back to the icon it came from (menus/top_menu.asm:348 1F:431A, :328 1F:42F5)
EXPORT SFX_TOP_MENU_UP_DOWN
DEF SFX_CONFIRM EQU $002C ; PROBABLE accept cue: A on a menu entry, list row or Yes/No screen (played before the cursor is tested, so also on "No"), A on intro and notice pages, OK key of a text entry after validation, Start on the title menu, Select on the mail sender page (menus/mail_menu.asm:185 1D:41C7, account/action_confirm.asm:106 68:6F23, title/title_screen.asm:290 0E:41F0)
EXPORT SFX_CONFIRM
DEF SFX_DIALOG_CONFIRM EQU $002D ; PROBABLE A pressed in the message dialog service, Yes or No alike (dialog/dialog.asm:702 72:45F4, :864 72:46F6); same stream as $002C, which every other screen uses
EXPORT SFX_DIALOG_CONFIRM
DEF SFX_CANCEL EQU $002E ; PROBABLE back / cancel cue: B on menus, lists, Yes/No pages and dialogs; also the keyboard cancel key or erase on an empty field, "No" of the connect dialog (after $002C), Select in the help script and the dictionary view (menus/mail_menu.asm:204 1D:41F6, dialog/dialog.asm:728 72:4610)
EXPORT SFX_CANCEL
DEF SFX_DIALOG_OPEN EQU $0030 ; PROBABLE a dialog or prompt appeared: after Dialog_SlideIn (dialog/dialog.asm:182 72:41B2, :354 72:437B) and on entering the connect-dialog Yes/No prompts (comm/connect_dialog.asm:784 57:4589, :832 57:45DF)
EXPORT SFX_DIALOG_OPEN
DEF SFX_REJECT EQU $0031 ; PROBABLE input refused, nothing done: field full, kana mark not applicable, OK key with a too short or invalid entry, disabled key, empty / occupied / locked slot or item (keyboard/type_helpers.asm:239 55:6FBD, account/password_entry.asm:302 68:5F78); not at engine/unreferenced/page_list_prototype.asm:596 and :1864 (dead, an older table of ids)
EXPORT SFX_REJECT
DEF SFX_SAVE EQU $0032 ; PROBABLE a save is confirmed (Yes of a save or overwrite dialog, page save, password save), mostly before the write: address_book/save_confirm.asm:76 2A:7016 (dialog $020B), mail/body_editor.asm:2898 2D:58AE (draft, after MailDraft_SaveToSram)
EXPORT SFX_SAVE
DEF SFX_DELETE EQU $0033 ; PROBABLE an erase is confirmed (Yes of an erase dialog): address_book/list.asm:417 2F:429C (dialog $020D, after Abook_ClearSlot), mail/mailbox.asm:389 25:42E8 (dialog $0206, after MailRecord_Delete); comm/connect_dialog_screen.asm:1762 is unreachable
EXPORT SFX_DELETE
DEF SFX_POPUP_OPEN EQU $0034 ; PROBABLE an overlay panel starts to slide in (browser page menu, on-screen keyboard, type picker): browser/page_view.asm:441 4E:4D0E, keyboard/keyboard.asm:1145 55:632F; dialogs use $0030 after Dialog_SlideIn
EXPORT SFX_POPUP_OPEN
DEF SFX_POPUP_CLOSE EQU $0035 ; PROBABLE the same panels start to slide out: browser/page_view.asm:468 4E:4D4C (before BrowserMenu_Close), keyboard/keyboard.asm:1322 55:6465 (Kbd_SlideOut, only when rWY < $90)
EXPORT SFX_POPUP_CLOSE
DEF SFX_TEXT_CURSOR_MOVE EQU $0036 ; PROBABLE d-pad press on the text cursor of a text editor, played at entry before the edge test (also when it cannot move): address_book/address_editor.asm:309, mail/body_editor.asm:372; selection cursors use $0029
EXPORT SFX_TEXT_CURSOR_MOVE
DEF SFX_CHAR_ENTERED EQU $0038 ; PROBABLE a typed character or kana mark is accepted (13 inserts, 12 marks that rewrite the previous character in place): address_book/address_editor.asm:1186, address_book/name_editor.asm:1144 2F:5EEE
EXPORT SFX_CHAR_ENTERED
DEF SFX_CHAR_ERASED EQU $0039 ; PROBABLE the erase key was handled in a text field (editors: at entry of the Backspace routine; entry screens: after TextBuf_DeleteLast): mail/mail_title_entry.asm:991, account/login_id_entry.asm:254; it plays with nothing to erase at profile/profile_editor.asm:1506 and account/mail_address_entry.asm:336
EXPORT SFX_CHAR_ERASED
DEF SFX_LINK_FOLLOW EQU $003E ; PROBABLE A on the selected hyperlink, after the URL is resolved and before the page load: browser/page_view.asm:241 4E:4B61, help/mobile_dictionary_view.asm:131 4C:506E
EXPORT SFX_LINK_FOLLOW
DEF SFX_HISTORY_BACK EQU $003F ; PROBABLE B goes back one page of the history: browser/page_view.asm:301 4E:4BDA, help/mobile_dictionary_view.asm:159 4C:50B2 (an empty history plays $002E)
EXPORT SFX_HISTORY_BACK
DEF SFX_COMM_CLOSE_DONE EQU $0044 ; PROBABLE the communication scene closes after its success message ("Connected" / "Downloaded", decoded from the text boxes), the sprites leave to the right: comm/comm_scene.asm:287 70:41D3, mail/send_receive.asm:618 27:4483
EXPORT SFX_COMM_CLOSE_DONE
DEF SFX_COMM_CLOSE_ENDED EQU $0045 ; PROBABLE the communication scene closes after a cancel or an end finished ("Cancelling..." then "Cancelled", "Ending..." then "Ended"), the sprites leave to the left: comm/comm_scene.asm:680 70:446E, mail/send_receive.asm:804 27:4617
EXPORT SFX_COMM_CLOSE_ENDED
DEF SFX_ADAPTER_ANIM EQU $0046 ; PROBABLE plays once per animation cycle when the frame index of sprite slot 0 is 2 (a latch flag) on the adapter check, configuration and registration screens: settings/adapter_check.asm:127 67:648D, account/register_config.asm:102 68:6BD3; the 4 unreferenced prototype sites stay numeric
EXPORT SFX_ADAPTER_ANIM
