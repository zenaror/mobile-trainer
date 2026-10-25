; data/text/sample_mail_english_tail.asm
; bank 2D, selected fixed English sample-body/subject strings in $7ED1-$8000; gaps retain original bytes
; Referenced functional sample body and subject text; source allocations and gaps retain their byte extents.

; ---- text $7ED1-$7EDA (9 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/mail/sample_data/english/MailSample4_Subject", ROMX[$7ED1], BANK[$2D]
PUSHC sjis
MailSample4_Subject:: ; 2D:7ED1
	db "Untitled", 0
POPC

; ---- text $7EDA-$7F6F (149 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/mail/sample_data/english/MailSample3_Body", ROMX[$7EDA], BANK[$2D]
PUSHC sjis
MailSample3_Body:: ; 2D:7EDA
	db "The mail center will be undergoing maintenance from 7/14 until 7/20 and the email servic"
	db "e will not be available. We apologize for the inconvenience.", 0
POPC

; ---- text $7F81-$7F93 (18 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/mail/sample_data/english/MailSample1_Subject", ROMX[$7F81], BANK[$2D]
PUSHC sjis
MailSample1_Subject:: ; 2D:7F81
	db "Playing Baseball!", 0
POPC

; ---- text $7F93-$7FD4 (65 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/mail/sample_data/english/MailSample1_Body", ROMX[$7F93], BANK[$2D]
PUSHC sjis
MailSample1_Body:: ; 2D:7F93
	db "I'm playing baseball on the first Sunday of July, come visit me!", 0
POPC

; ---- text $7FD4-$7FE5 (17 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/mail/sample_data/english/MailSample0_Subject", ROMX[$7FD4], BANK[$2D]
PUSHC sjis
MailSample0_Subject:: ; 2D:7FD4
	db "Let's play again", 0
POPC

; ---- text $7FE5-$8000 (27 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/mail/sample_data/english/MailSample0_Body", ROMX[$7FE5], BANK[$2D]
PUSHC sjis
MailSample0_Body:: ; 2D:7FE5
	db "Let's play again next time", 0
POPC
