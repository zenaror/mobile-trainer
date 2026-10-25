# Natural first-use Mail HelpScript route, ID `$89` (2026-10-23)

## Finding

The first-use Mail gate is **CONFIRMED** on the natural `register` → `tutorial_profile` path. Starting SRAM bank 1 has `sTutorialGateMailMenu` (`$A89A`) = 0 and Mail help flag `$A686` = 0. `Tutorial_GateMailMenu` at `48:49DB` takes its zero-counter branch at `48:49F8`, passes HelpScript ID `$89`, and calls `HelpScript_Run`. Ordinary inputs render the Mail topic and its first-use-only nickname prompt; the existing flow then reaches `Profile_Edit` and advances the gate counter.

The common Mail topic content matches the normal ID `$09` route's 31 pages in order: 29/31 screenshot pairs are exact RGBA matches; the two remaining pairs differ at 62 pixels each and were checked visually, with the same displayed page text/content. The `$89` route additionally displays `HelpScript_Page_5177`, the nickname prompt. At `6C:516F`, var 0 equal to `$09` branches to `6C:51A1` and skips that page; ID `$89` falls through and renders it. The final Mail-help capture is step 078; the next captured screen is the nickname editor.

This run directly demonstrates the persisted flag transition: bank-1 `$A686` changes `00 -> 01`, and the first-use counter `$A89A` changes `00 -> 01`. Bytes `$A684–$A68B` change from `81 00 00 00 00 00 00 00` to `89 01 01 00 00 00 00 00`.

## Reproduction and controls

The base macro is the tracked ordinary-input scenario `traces/inputs/tutorial_profile.macro`, starting from the natural `register` save/config. A private derivative adds 79 passive screenshots after input steps; no buttons, waits, save bytes, configuration values or ROM bytes were changed. The instrumented run's dynamic `dataaccess.tsv` and `callgraph.tsv` are byte-identical to canonical `tutorial_profile` outputs, and all 13 existing named screenshots match byte-for-byte. It completed at frame 18301 after 92,883,869 instructions with Mobile Adapter emulation and fake network.

ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. Local `libmgba.so.0.11.0` SHA-256: `4c221287ee524eeb8fcd21ae45c330a70fe10c162637b284e1f9d87fd7dc8923`. Natural starting save SHA-256: `606472c7b0f8817ed92e7a176b7da997740c5c457a4eabe0261ccbc689bd5fd5`. Adapter config SHA-256: `45fdd476f1adf5c1d87aedaeda675d11f610ab7d7d056231f955aff71c4769ef`.

Private evidence manifest: `MANIFEST.json` (review artifact), SHA-256 `e11ff6b077f7fde26bcc28c9e1877f8c6d94949fb1d47565814434c479963b58`. It records capture hashes, page correspondence, seed/output SRAM bytes, execution outputs, input/runtime hashes and limitations. This confirms the natural ID `$89` route for this saved state, not hardware behavior other first-use variants (`$8A`, `$91`, `$92`).
