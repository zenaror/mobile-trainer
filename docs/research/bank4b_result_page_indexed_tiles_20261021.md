# Bank 4B result-page indexed tile bytes (2026-10-21)

## Finding

The 1,456-byte span `4B:4AD0–5080` is now represented as an exact 2bpp asset, `gfx/account/screens_bank4b/account_result_page_tiles4ad0.2bpp`, with editable PNG `account_result_page_tiles4ad0.png`. Its source bytes are unchanged from the Japanese original (SHA-256 `2e765aa56d98571122f8eb811a7d7ba17f5c93158de8b33dd81c60cbbf128a2b`). The block contains 91 whole tiles. Its exact source PNG is a distinct path, bringing the current editable source PNG count to 450. The PNG is a reversible tile view; its grayscale pixels do not imply a palette or screen composition.

Static caller code and descriptor records provide positive transfer evidence. `Account_ResultPage_LoadBanner` at `68:77D6` reads 3-byte source/bank records (16-bit source address plus 8-bit ROM bank) from `Data_Account_ResultPage_BannerTables` at `68:7831`. The descriptors select 4B source addresses `4970`, `4BF0`, and `4E70`, whose upload intervals intersect the asset by 288, 640, and 528 bytes respectively: `[4AD0,4BF0)`, `[4BF0,4E70)`, and `[4E70,5080)`. The combined 1,456 bytes are covered with no gap. The descriptor table and arithmetic establish the transfer bounds; existing trace data aggregates ROM reads and cannot demonstrate a per-byte runtime event. For the `4E70` record, bank `$4B`, count `$28`, and destination `$9001` reach the shared HDMA helper; the descriptor count `$28` gives `$280` bytes under the helper's 16-byte count units, with destination VRAM bank 1 at `$9000`; aggregate trace reads correlate with this transfer but do not timestamp or identify each byte access. The byte triplet at `4B:4FE9` is inside that uploaded stream at offset `$179`. This proves the bytes are included in transferred tile data, not that the triplet is a far pointer.

The data class `tiles` and inclusion in the descriptor-derived VRAM transfer ranges are CONFIRMED. Their higher-level association with a result-page indexed banner is PROBABLE from the caller/table names. No natural on-screen composition, translated text, Pokémon species, or missing/unused-frame relation is established. No generated screenshot or palette claim is included. The nearby `Data_4B_5400` 32-byte interval is a separate follow-up.

## Follow-up: `4B:5400–5420`

The 32 bytes remain `Data_4B_5400` and are confirmed to be read as data by executed code in at most 4 of the 18 recorded scenarios (`gfx/account/screens_bank4b.asm`). A source search across the tracked assembly roots found no direct symbolic or numeric consumer for this exact interval; the established bank-68 banner descriptors end at `4B:5080`. The adjacent `4B:5420` span is separately classified as probable tile data. The 32 bytes can be divided into two 16-byte units that are compatible with 2bpp tile encoding, but this alone does not establish that they are graphics or that they are uploaded.

No producer/consumer chain or stronger format evidence was recovered in this pass. Keep the content class unknown and the neutral label unchanged. The tile interpretation remains a hypothesis pending a positive source or transfer reference; no asset, PNG, or semantic name is warranted yet.

## Reproduction and retained evidence

The independent audit compared each descriptor-derived intersection with original ROM bytes and the complete upload source; the extraction SHA-256 is also recorded by `gfx/png_rules.tsv`. Read-only reports are retained under `.tmp/agent-bank4b-positive-consumer-20261021/`: `REPORT.md` SHA-256 `076a1e1140d5a50064b200328d1f0e69b6cfd626d4a2be638d2cadb74b85c69a`; `ADDENDUM.md` SHA-256 `c3c1beef31a92f265b5a2718c6182d67ff870d112c5f8d6a8c72413981ef87b9`; `ADDENDUM_RESULT.json` SHA-256 `4b19a1635efd32d905566d562074b8033d44c42cfa587b41f6990a9bd8267908`. The audit base was `d1ad7596e84f04262e790d39e678a1b75e56e8ad`; subsequent checkout changes affected the same-address menu aliases and the graphics representation, not the bank 68 descriptors or ROM bytes.


## Addendum (2026-10-22): second-banner transfer

The earlier follow-up above is superseded for the exact interval `4B:5400–5420`. The second descriptor list at `68:7840–7849` contains source `4B:5370` at index 1. `Account_ResultPage_LoadBanner` sets destination `$9281`, bank `$95`, and count `$28`; the shared upload helper transfers `C*16` bytes, masks the destination low nibble, and selects VRAM bank from bit 0. The resulting static range is `4B:5370–55F0` to VRAM1 `$9280–$9500`, placing this 32-byte slice at VRAM1 `$9310–$9330`.

The source label is now `Gfx_Account_ResultPage_SecondBanner1_Tiles9310Vb1`. This confirms a two-tile 2bpp transfer association from the static descriptor/caller chain. It does not establish natural execution, visible composition, or visual meaning. The earlier 18-scenario trace association does not identify this particular caller and is not used as the basis for the rename.

## 2026-10-22 candidate asset paths

The two existing PROBABLE owner spans retain their candidate qualifiers and
now use filenames derived from `AccountResultPage_CandidateTiles_5080` and
`AccountResultPage_CandidateTiles_5420`: `account_result_page_candidate_tiles_5080`
(896 bytes) and `account_result_page_candidate_tiles_5420` (1,104 bytes). The
matching exact PNG sources moved with them. All four payload/source hashes match
the pre-move manifest at
`.tmp/jp-bank4b-candidate-asset-paths-20261022/PRE_MOVE.json` (SHA-256
`b58ad27ecac7dd328a05e51c96a8094231643e5c88af4900bbd6e4778e5fef94`). The
rename does not promote their PROBABLE classifications or claim complete-screen
composition, natural selection, or Pokémon/frame identity.
