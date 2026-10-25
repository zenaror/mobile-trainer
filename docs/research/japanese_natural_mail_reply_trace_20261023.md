# Japanese natural mail-reply trace

## Positive observations

- The ordinary mail path executed 74 previously unseen instruction starts in   bank 25, interval `25:4594–4659`.

## Static operation contract for the Bank 2D fragment

The source at `2D:66CD` selects `wMailComposeMode`.

The remaining branch block at `2D:6726` loads dialog ID `$020F` and calls `Dialog_Show`.

The cataloged text for `$020F` asks whether an unfinished reply will be discarded, and the reply path writes mode 3 before entering `MailAddr_Edit` (`engine/mail/mailbox_screen.asm`, reply setup).

## Third-record reply route

A separate ordinary-input run started from the saved `mail_receive` SRAM and adapter configuration, opened the third mailbox record, then selected Reply.
