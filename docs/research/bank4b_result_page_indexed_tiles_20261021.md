# Bank 4B result-page indexed tile bytes

## Finding

The 1,456-byte span `4B:4AD0–5080` is now represented as an exact 2bpp asset, `gfx/account/screens_bank4b/account_result_page_tiles4ad0.2bpp`, with editable PNG `account_result_page_tiles4ad0.png`.

`Account_ResultPage_LoadBanner` at `68:77D6` reads 3-byte source/bank records (16-bit source address plus 8-bit ROM bank) from `Data_Account_ResultPage_BannerTables` at `68:7831`.

The byte triplet at `4B:4FE9` is inside that uploaded stream at offset `$179`.

The data class `tiles` and inclusion in the descriptor-derived VRAM transfer ranges are CONFIRMED. Their higher-level association with a result-page indexed banner is PROBABLE from the caller/table names. No natural on-screen composition, translated text, Pokémon species, or missing/unused-frame relation is established. No generated screenshot or palette claim is included. The nearby `Data_4B_5400` 32-byte interval is a separate follow-up.

The 32 bytes remain `Data_4B_5400` and are confirmed to be read as data by executed code in at most 4 of the 18 recorded scenarios (`gfx/account/screens_bank4b.asm`).

The adjacent `4B:5420` span is separately classified as probable tile data.

## Addendum: second-banner transfer

The second descriptor list at `68:7840–7849` contains source `4B:5370` at index 1.

`Account_ResultPage_LoadBanner` sets destination `$9281`, bank `$95`, and count `$28`; the shared upload helper transfers `C*16` bytes, masks the destination low nibble, and selects VRAM bank from bit 0.

The resulting static range is `4B:5370–55F0` to VRAM1 `$9280–$9500`, placing this 32-byte slice at VRAM1 `$9310–$9330`.

## 2026-10-22 candidate asset paths

The two existing PROBABLE owner spans retain their candidate qualifiers and now use filenames derived from `AccountResultPage_CandidateTiles_5080` and `AccountResultPage_CandidateTiles_5420`: `account_result_page_candidate_tiles_5080` (896 bytes) and `account_result_page_candidate_tiles_5420` (1,104 bytes).
