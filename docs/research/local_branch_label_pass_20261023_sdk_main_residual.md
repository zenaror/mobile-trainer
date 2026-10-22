# Japanese Mobile SDK main residual local-label pass (2026-10-23)

This static pass names instruction-local branch roles in the residual numeric labels of lib/mobile/main.asm. It does not claim natural reachability, external callers, product purpose, buffer safety, termination, or complete protocol contracts.

## Scope and result

The reviewed proposal covers 413 numeric local-label definitions: 376 renames and 37 KEEP decisions. It updates 482 references to renamed labels; 52 references associated with KEEP labels remain unchanged. The complete mapping, including owners, addresses, branch evidence and limitations, is preserved in local_label_mapping_20261023_sdk_main_residual.tsv.

Source SHA-256 changed from dc50b8badf2cc12d6f91e91105b183bf879d2bb3a6422abb49c129b72dc3c904 to 95d4d27de264c20f6a5f8429bbe4306f8fd49a215061e337faa57fb902255867. Only local-label tokens in code changed; the deterministic transformation reverses exactly by lexical owner.

The three address-local decisions highlighted by review remain KEEP at 75:418E, 75:7EC5, and 75:7F11; the evidence does not support more specific names within this pass. Other retained cases are listed in the mapping.

See the verification record local_branch_label_pass_20261023_sdk_main_residual_verify.md for review and build gates.
