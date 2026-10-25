# Residual local cases at 2B:687C

Own original-ROM reencoding covers `[687C,691A)`: 158 bytes, 60 CPU instruction starts and four separate three-byte farcall operands (146 CPU bytes plus 12 inline bytes). The preceding `[6863,687C)` is twelve words (24 bytes) followed by RET687B, not an immediately preceding JR NZ into687C. The next entry, `MailView_DrawDateTime` at691A, is outside this returning family.

DE6810/6830/6850/6870 passed to00:0A65 supplies D/E coordinates, not a source-ROM pointer.

## Local sprite-position and initialization operation alias

`Sprite_SetSlots1And2Y68XByC_InitSlot2` is a PROBABLE operation alias for `Function_2B_687C`.

The complete original[2B:687C,691A) remains158 bytes/60 CPU starts, including four separate three-byte farcall operands. The prior twelve-word table6863..687B and lone RET687B do not supply ordinary entry. The default case includes farcall6909 and the suffix through RET6919; neither the older141-byte prefix nor the next entry691A replaces that full boundary. The internal JRs6880/68A8/68D0 target68A6/68CE/68F6.

|Entry C|DE coordinate supplied to both position calls|DE base supplied to slot initialization|Normal return|
|---|---|---|---|
|0|6810 (Y68,X10)|78D0|68A5|
|1|6830 (Y68,X30)|7910|68CD|
|2|6850 (Y68,X50)|78E0|68F5|
|3..FF|6870 (Y68,X70)|78F0|6919|

InitSlot explicitly selects WRAM7, zeroes sixteen slot bytes, records the table bank and invokes Sprite_LoadObjectEntry00:0AB8.
