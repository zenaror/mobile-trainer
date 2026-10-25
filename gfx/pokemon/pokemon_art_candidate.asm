; gfx/pokemon/pokemon_art_candidate.asm
; bank 51, $5EE0-$70E0 (4608 bytes); pinned by layout.link
; Candidate Pokémon artwork tiles matched to the BetaP2 sprite sheet; reader and frame layout unknown

SECTION "gfx/pokemon/pokemon_art_candidate", ROMX

; ---- gfx $5EE0-$70D0 (4592 bytes) [PROBABLE] 287 aligned 2bpp tiles; 57 tile patterns match BetaP2.JPG under the documented 2x/JPEG model; no natural consumer or frame boundary is established

PokemonArt_CandidateTiles_51_5EE0:: ; 51:5EE0
	INCBIN "gfx/pokemon/pokemon_art_candidate/pokemon_art_candidate_tiles_51_5ee0.2bpp"

; ---- zero $70D0-$70E0 (16 bytes) [PROBABLE] zero-filled gap aligns the next code entry at 51:70E0; no reader is established

Padding_BmpValidateEntryAlignment_51_70D0:: ; 51:70D0
	ds $10, $00
