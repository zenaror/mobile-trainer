# Verification: Japanese mail body editor local labels (2026-10-23)

## Proposal review

The independently reviewed proposal contains 129 definitions: 127 renames and two KEEP decisions. The final proposal SHA-256 is 37207b34d75dc78c4e6f7df515e6ac3e67bc7d6721bba1e187d78d94e372c329. Review corrections covered eight base-entry labels and two overlapping two-byte copy loops; the corrected proposal was re-reviewed. The mapping retains instruction-local static limits and does not claim natural execution or complete callee contracts.

## Source integrity

Base SHA-256: 57dd982b8a36ac649445ffb5ca13b01ac12b0cfbfe40a8aa292f708aac8eb689.

Integrated SHA-256: 1c5e75525e6498f28fc1c50c233975f5cfb10ebd081fc801e4898d85d19d5294.

The transformation renamed 127 definitions and 195 references. Reversing the map by lexical owner reproduced the exact base source. The private combined validation tree also passed all project gates listed in the SDK residual verification; active-checkout gates are recorded after integration there.
