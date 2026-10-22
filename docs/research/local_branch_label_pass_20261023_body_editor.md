# Japanese mail body editor local-label pass (2026-10-23)

This static pass names local control-flow labels in engine/mail/body_editor.asm. Labels describe instruction-level roles visible in this file; they do not establish natural reachability, product purpose, or complete callees/contracts.

## Scope and result

The proposal covers all 129 numeric local-label definitions in the 2D mail body editor. It renames 127 definitions and their 195 branch references; two labels and their two references remain neutral. The exact reviewed mapping, including owner/address, references, instruction evidence and limits, is preserved in local_label_mapping_20261023_body_editor.tsv.

The source SHA-256 changed from 57dd982b8a36ac649445ffb5ca13b01ac12b0cfbfe40a8aa292f708aac8eb689 to 1c5e75525e6498f28fc1c50c233975f5cfb10ebd081fc801e4898d85d19d5294. The deterministic rewrite changes label tokens in code only; comments and non-label operands remain untouched. Reverse normalization by lexical owner reconstructs the exact source.

## Review findings and limits

An independent adversarial review examined all rows and corrected evidence for the eight init_slot4_base_entryN labels: the base entry is indexed by the later $81 selection, which addresses entry N+1. At 2D:5189 and 2D:528E, the copy loop transfers two bytes while each pointer has net movement of one byte per iteration; successive copy windows overlap. These corrections were re-reviewed. The two retained labels remain neutral where the proposal did not establish a unique useful name.

No runtime or product-purpose claim follows from this naming pass. See the verification record local_branch_label_pass_20261023_body_editor_verify.md.
