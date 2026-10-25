# Original mobile-library argument templates and task state

## Six decisions

|Original unit|Accepted alias / decision|Natural direct load|Whole storage|
|---|---|---|---|
|54:4FC3-4FCB,8 bytes|CONFIRMED Data_Pop3Retr_ParseBodyArgs|4D4F,33 hits/6 scenarios|PROBABLE preserved|
|54:4FCB-4FD2,7 bytes|CONFIRMED Data_Pop3Retr_DecodeFromHeaderArgs|4D73,33/6|PROBABLE preserved|
|54:4C44-4C47,3 bytes|CONFIRMED Data_MailScan_InputPrefix|5124,262/16|PROBABLE preserved|
|54:4C35-4C3D,8 bytes|CONFIRMED Data_Pop3Top_BytesCopiedBeforeHeaderArgs; downstream role HYPOTHESIS|4A35,34/7|PROBABLE preserved|
|54:4C3D-4C44,7 bytes|CONFIRMED Data_Pop3Top_DecodeHeaderArgs|4A44,34/7;4BEF,45/14|PROBABLE preserved|
|54:475A-4764,10 bytes|CONFIRMED Data_Smtp_HeaderComposeArgs|4593,15/6|PROBABLE preserved|

## Three-byte scan/check prefix and dynamic tail

On scan success, selector2 at515F runs260/16 using the same first three bytes. CheckGameMail reads that bank/address prefix to find the game-code header. Both consumers establish the role shared by this one physical prefix. Names do not claim a full five-byte argument object or combine the prefix with the neighboring unrelated bytes4C47 onward.

## SMTP ten-byte compose seed and all content units

Original475A is03 00 A1 00 0F 00 00 80 C4 00. The first five bytes describe SRAM3:A100 output with capacity0F00,3840 bytes. The next four are one mutable compose-item record [length00,bank00,pointerC480], followed by a00 item-list terminator. No omitted tail, padding merger or zero promotion.

That helper46E8 selects W5 and invokes selector8 through Mail_DispatchFar.

Initial length0 produces the fixed B6 header without a variable item; later Smtp_MeasureField writes measured length into C245 for address/subject fields using the existing C480 pointer.

Existing source directly reads/writes C241:C242 and C243:C244, and the composer consumes the item-length/pointer tail; the role is a reusable header-compose argument seed, not SMTP network command bytes or tile data.

C480 is fixed WRAM input, despite the supplied SRAM-bank field00.

## Task-state operation alias at 54:41C5

`Mobile_InitTaskStateKind1` is a PROBABLE descriptive alias for `Function_54_41C5`, which is preserved. It names only the initialization C1DB=3, C1D8=1, C1D9=0. Entry, caller and specific operation purpose remain HYPOTHESIS. The global neutral-group count is a separate naming ledger, not a measure of semantic completion.

Original offset0x1501C5 / bank54:41C5..41D4 exclusive contains `3e03eadbc13e01ead8c1afead9c1c9`, seven instructions/15 bytes.

| 14-byte prefix, end exclusive | Maintained source first instruction |
| --- | --- |
| 54:403D..404B | `engine/mobile/connection.asm:54` |
| 54:418C..419A | `engine/mobile/connection.asm:236` |
| 54:423C..424A | `engine/mobile/connection.asm:363` |
| 54:42A0..42AE | `engine/mobile/http.asm:21` |
| 54:4501..450F | `engine/mobile/smtp.asm:11` |
| 54:453B..4549 | `engine/mobile/smtp.asm:43` |
| 54:4578..4586 | `engine/mobile/smtp.asm:81` |
| 54:485F..486D | `engine/mobile/pop3_top.asm:12` |
| 54:4CBD..4CCB | `engine/mobile/pop3_retr.asm:18` |
| 54:53A4..53B2 | `engine/mobile/pop3_dele.asm:25` |

These are partial twins, not complete-function twins: the candidate immediately returns at41D3, whereas the siblings continue into distinct argument setup, SDK calls or state-dependent work. No prefix match establishes the candidate's caller or a connection/disconnect/cancel/protocol purpose. The parameterized HTTP POST prefix at54:4313 differs only in the immediate value3 stored to C1D8; it is not an exact match.

The consumers support a task-state interpretation independently of existing symbol names. Bank54:4071 increments C1D9 and branches by step (557 hits/38 scenarios);54:48B8 does the same in another poll (95/21). Bank54:409F..40A7 loads C1D8, clears bit0 and tests bit1 (130/37);54:4135 clears it (130/37), as do54:41BF (107/26) and54:4532 (12/6). Bank54:4393 tests C1DB against zero (10/2), then4399/439C select and decrement it when nonzero (9/2) before redirect processing. Kind1 is a numeric state value, not a unique operation identity. Existing RAM-name confidence is unchanged.
