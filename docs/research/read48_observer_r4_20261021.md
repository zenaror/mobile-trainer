# R4 observer capacity and Japanese replay validation — 2026-10-21

This checkpoint validates the private mGBA read-observer harness used for
original-ROM tracing. It does not change the Mobile Trainer source or ROM.
All runtime claims below are limited to the pinned build, library and replay
profiles; they do not establish general emulator correctness, full memory
coverage, hardware behavior the semantic purpose of Data48.

## Build identity and synthetic controls

The FIX2 harness binary is SHA-256
`4168c6fbd1fcc0efd370f085d7e88e7a4e1d4b7241e894049f928ebe4674f41f`
(124,720 bytes), built against the pinned mGBA library
`65c5bfc12d3fb27cfbe651c782ea3543080f9dffcedce6849be3883a90d24d26`
(2,178,888 bytes). The final source seal is
`8eb903314de6bdb722519a7bea513d90c3c36308fe90b5c18597654da6c78293`;
the static-review receipt is
`a6018854b96dba5821ac3764598d8102de9c8a50e3c484fe29b198d4f02c62c0`
and records ACCEPT. The ELF receipt confirms the same 37 expected mGBA
imports. These identities are also pinned in the runtime receipts below.

Four private synthetic-ROM controls passed with actual module-map and binding
closure (`RUN_FIX2_20261021/RESULT.json`, SHA-256
`c61a1fc242186e239177f82bd2465ef45b5bba855c5201969c407ed0e30c510f`). They
ran CGB for two frames with mobile disabled and a stub network; the original
Japanese ROM was not executed in these controls.

| Control | Observed result |
|---|---|
| `max_gdma2048` | Capacity and high-water were both 4,097; no drops or API error. |
| `target_cap4160` | 4,160 synthetic CPU reads produced 4,224 attempts, 4,096 written records, 128 dropped records and API error 1; return code 3 and incomplete stream were the expected fail-closed outcome. |
| `owned_then_direct_reuse` | 32 target records were written with no drops; the owned context was reused and closed under the pinned case checks. |
| `max_gdma_then_fresh_owned` | The 4,097 high-water was reached, then a fresh owned context wrote 16 target records with no drops. |

The accepted controls establish these four finite capacity, overflow and
state-reuse outcomes only. They do not test a 65th per-step target, a 4,098th
memory entry, or a natural Data48 call.

## Six fixed Japanese-ROM replays

After the controls, two existing replay profiles were each run with the
canonical harness, FULL observer off and FULL observer on. The Japanese ROM
remained pinned at SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`
(2,097,152 bytes). The six-process aggregate is
`root-r4-natural-replay-fix2-20261021/RESULT.json`, SHA-256
`d629f5e59afeacc8c3017b3188216b0b4baf184060f23e1806e22d80670b78ab`.
An independent review accepted the receipt consistency and the stated limits.

All six processes returned 0 and reached their fixed frame budgets. For each
profile, the ordinary trace, RAM, save, configuration and screenshot outputs
matched byte for byte across canonical, FULL-off and FULL-on runs, and matched
the pinned baseline: `register_neterr` produced 29 ordinary files including
12 PNGs over 5,924 frames; `kbd_compose` produced 33 files including 16 PNGs
over 21,567 frames. Each captured map contained the executable and six pinned
providers. Both canonical runs closed 20 imports to the pinned library; all
four FULL-off/on runs closed 37.

The FULL-on `register_neterr` stream contained 201 events and 64/64 target
attempts/writes, with four joined candidates. The `kbd_compose` stream
contained 495 events and 160/160 attempts/writes, with ten joined candidates
and 14 invalidated contexts. Both streams completed with capacity 4,097,
high-water 2,049, and zero dropped records, API/library/write/close errors or
unknown events. The invalidations remain part of the result; candidate joins
and target writes do not prove a universal call convention or semantic
meaning.

The aggregate intentionally retains `accepted=false`,
`independent_review_required=true`, and `FULL_Data48_natural_hardware_claim=false`.
The separate review accepted receipt integrity, byte equality and the bounded
runtime observations; `FULL_proof_accepted` remains false. These emulator
replays are not hardware tests and do not establish the ROM's general
semantics.

## Reproducibility receipts

Private supporting files are retained under `.tmp` (review artifact):

- `jp-zero48-memory-cap-native-fix2-20261021` (review artifact) — source seal, build,
  ELF metadata and static review.
- `RUN_FIX2_20261021` (review artifact)
  — four synthetic runtime controls.
- `root-r4-natural-replay-fix2-20261021` (review artifact)
  — six original-ROM replay receipts and independent-review target.

Earlier incomplete runs and their failure receipts remain preserved beside
these FIX2 results; they are not used as the accepted FIX2 evidence.
