; consts.asm -- numeric constants (record offsets, counts); exported, never substituted into operands.
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
