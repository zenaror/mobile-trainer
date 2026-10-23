# Body keyboard scroll-reset branch trace (2026-10-23)

## Finding

The local branch `.reset_scroll_return` at physical bank `2D`, CPU address
`5A6F`, executed once in a bounded scripted-input mGBA replay of the Japanese
ROM. The captured instruction starts were `2D:5A6F`, `5A70`, `5A71`, `5A73`,
`5A76` and `5A77`, all first observed at frame 14927. This is **CONFIRMED**
execution of this branch in this one scenario. It does not prove a complete
keyboard route inventory, behavior on hardware, or a conventional return
contract.

The maintained source at `engine/mail/body_editor.asm` compares the result of
`Kbd_Run` with `$08` and jumps to `.reset_scroll_return`. That block saves BC,
zeros `rSCY` and `wSplitScrollY`, restores BC, and executes RET. The same trace
records `ret_unmatched 2D:5A77 -> 2D:477A`; keep that anomaly explicit rather
than inferring a conventional ABI or stack discipline from the source shape.

## Reproduction and provenance

Repository: `zenaror/mobile-trainer`, revision
`227b72be0ac52425fa0bfed329edd6bc4a24e594`. The immutable Japanese ROM is
2,097,152 bytes with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The run used the saved `kbd_abook` SRAM/configuration, a macro suffix emitted
by a three-minute coverage-guided input search, mGBA's fake network mode, and
no forced PC or RAM entry. It was a scripted-input emulator run, not a
hardware observation.

The ordinary replay command was:

```sh
.cache/trace/mgba_trace --rom 'Mobile Trainer (Japan).gbc' --scenario jp_body_key_replay --outdir .tmp/jp-body-editor-targeted-explore-20261023/replay --frames 25000 --mobile on --net fake --net-opt latency=2 --save-in .cache/trace/state/kbd_abook.sav --mobile-config-in .cache/trace/state/kbd_abook.cfg --macro .tmp/jp-body-editor-targeted-explore-20261023/search/corpus/e45.macro
```

The input macro SHA-256 is
`a4a9c06735ce5c53a16cbbde3132e53dee897f78a1a98103fda99455c22621b0`; the
seed SRAM and adapter config hashes are `92aa0fb1ad93e30d66d9f045bc41c54f8c54905dcb78bdbc18da4a041fde0881` and
`45fdd476f1adf5c1d87aedaeda675d11f610ab7d7d056231f955aff71c4769ef`.
The tracer hash is
`bcfc16de9e07a8acb81b52e4f843ab0cf2beba6e26a1a134e25a3e6f714dc280` and
the loaded `libmgba.so.0.11` hash is
`b44dfd7edb816fefa892c10dc2563d5d4bbe871d68702a8dcc3dde2532959719`.

The captured outputs for this pass remain in the ignored task directory
`.tmp/jp-body-editor-targeted-explore-20261023/`. The replay's
`RESULT.json` records the command, environment inputs, counts and output
hashes. The coverage and callgraph files have SHA-256
`078944c3315b96fd1b724637aaef418de3cb989d41daadabde22be0ebf0ab682` and
`beae8fa27ffc9fac2e301ce5271a51433e7fb9dac5710f7f50c0438c81c174d2`.
The relevant callgraph rows are one `call 2D:4777 -> 2D:5691` at frame 13227
and the unmatched return described above. The replay stats report 15,052
frames; 12 `waitstable` directives hit their 600-frame cap, which limits
scenario completion but does not erase the exact recorded branch execution.

## Source checkpoint verification

After adding the evidence-qualified source comment, the standard `make`
completed: SHA-256 OK for the original ROM and `RESULT: IDENTICAL`. The
standard `make sym-check` passed with 335 source files, 12,212 labels and 51
constants. The byte identity remains a build result, not evidence of
hardware behavior or universal keyboard coverage.

The search yielded 2,911 trials, 400 entries and 11 new instruction starts;
the replay macro was one of three strong corpus entries. Its exact search
settings and hashes are in the retained `MANIFEST.json`. The operation roots
`2D:4E42` and `2D:4E54` remain unresolved; this result supplies no entry
evidence for either one. English/ZIP work remained paused and untouched.
