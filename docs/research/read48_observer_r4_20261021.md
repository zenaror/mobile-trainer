# R4 observer capacity and Japanese replay validation — 2026-10-21

## Build identity and synthetic controls

| Control |
| --- |
| `max_gdma2048` |
| `target_cap4160` |
| `owned_then_direct_reuse` |
| `max_gdma_then_fresh_owned` |

## Six fixed Japanese-ROM replays

The FULL-on `register_neterr` stream contained 201 events and 64/64 target
attempts/writes, with four joined candidates. The `kbd_compose` stream
contained 495 events and 160/160 attempts/writes, with ten joined candidates
and 14 invalidated contexts. Both streams completed with capacity 4,097,
high-water 2,049, and zero dropped records, API/library/write/close errors or
unknown events. The invalidations remain part of the result; candidate joins
and target writes do not prove a universal call convention or semantic
meaning.
