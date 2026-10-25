# Independent reference of the joypad mask pass (pad1)

## 1. Verdicts

| item | verdict |
|---|---|
| the 305 rewrites | **UPHELD 305, CORRECTED 0, DROPPED 0**: every chain decoded from the ROM bytes (`F0 A4|A5|A6`, then only `bit n, a` and `jr cc`; no `push af`, `jp cc`, `ret cc`, call or label inside a window); 136 sites also checked frame by frame against the traces |
| the names | each new name equals its old number under the reader's own table (305 of 305); the 18 constants are right; the three variable names are true at all 254 reads (58 / 95 / 101), with the caveat of the five injections into `hJoyPressed` (`naming2_pad1.md` section 2) |
| the tool | build identical, `sym_check` OK, no false rewrite on the tree; five latent defects found (section 3) |
| one more rule (`xor a, $NN` before an equality branch) | proposed by the reader, integrated: it names `engine/main/navigation.asm` (`PADF_SELECT \| PADF_LEFT`, `7C:7D08`, run 89 times in 15 scenarios; the equal path ran in `mail_server_hidden`, `mail_server_hidden2` and `time_warnings` with Select + Left held) |

## 2. Answers of the reader to the questions of the brief

Rare classes, all upheld: `$16` 3 + 3, `$C0` 6, `$F0` 18, `$04` 2, Select bit tests 2, Start bit    tests 4, non-first tests in a chain 66 (63 `bit` + 3 `cp`). 3.

**What stays numeric**: 15 of the 254 reads get no name (list in `naming2_pad1.md` section 5); the only one nameable with the same local proof was `navigation.asm` `xor a, $24` (now done); 30 + 10 more need an interprocedural or register-copy proof. 6.
