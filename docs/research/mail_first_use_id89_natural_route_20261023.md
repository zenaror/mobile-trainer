# Natural first-use Mail HelpScript route, ID `$89`

## Finding

Starting SRAM bank 1 has `sTutorialGateMailMenu` (`$A89A`) = 0 and Mail help flag `$A686` = 0.

`Tutorial_GateMailMenu` at `48:49DB` takes its zero-counter branch at `48:49F8`, passes HelpScript ID `$89`, and calls `HelpScript_Run`.

Ordinary inputs render the Mail topic and its first-use-only nickname prompt; the existing flow then reaches `Profile_Edit` and advances the gate counter.

This run directly demonstrates the persisted flag transition: bank-1 `$A686` changes `00 -> 01`, and the first-use counter `$A89A` changes `00 -> 01`. Bytes `$A684–$A68B` change from `81 00 00 00 00 00 00 00` to `89 01 01 00 00 00 00 00`.
