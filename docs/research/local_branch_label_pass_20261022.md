# Structural local-label pass: arithmetic and HDMA loops

This Japanese-source pass replaces seven numeric local branch labels with
operation names in `home/multiply_divide.asm` and `home/gfx_upload.asm`, and
names the previously unlabelled conditional block at `55:5DF5` in
`engine/keyboard/keyboard.asm`. The changes are symbols/comments only; no
instruction or data bytes were changed.

| Address | Previous label | Current local label |
| --- | --- | --- |
| `00:0D62` | `.l0D62` | `.NextBit` in `Multiply16x16to32` |
| `00:0D86` | `.l0D86` | `.SetQuotientBit` in `Divide16` |
| `00:0D87` | `.l0D87` | `.NextBit` in `Divide16` |
| `00:0773` | `.l0773` | `.StartTransfer` in `Gfx_StartHDMA` |
| `00:077A` | `.l077A` | `.WaitForLyBelow91` in `Gfx_StartHDMA` |
| `00:07B1` | `.l07B1` | `.StartTransfer` in `Gfx_StartHDMAWithService` |
| `00:07BB` | `.l07BB` | `.WaitForLyBelow91` in `Gfx_StartHDMAWithService` |
| `55:5DF5` | unlabelled block | `.CheckTypeThenContinueOrHide` |

### audio/engine.asm

| Owner | Localizador no fonte | Nomes adotados |
|---|---|---|
| `SoundDrv_StepTrack` | `04:4582` `.l4582` → `.store_update_flags`, `04:458E` `.l458E` → `.load_stream_pointer` |
| `SoundDrv_ReadNextCommand` | `04:45C0` `.l45C0` → `.dispatch_command_byte` |
| `SoundDrv_UpdateTempoStep` | `04:480C` `.l480C` → `.scale_tempo_product`, `04:4816` `.l4816` → `.store_tempo_step` |
| `SoundDrv_ParamTempoScale` | `04:4829` `.l4829` → `.check_music_tempo_request` |
| `SoundDrv_CmdSetInstrument` | `04:487E` `.l487E` → `.set_update_flag4` |
| `SoundDrv_WriteChannelParams` | `04:4E78` `.l4E78` → `.trigger_noise_channel`, `04:4E7D` `.l4E7D` → `.write_pulse_params`, `04:4E8F` `.l4E8F` → `.write_pulse_registers`, `04:4E9B` `.l4E9B` → `.write_wave_params`, `04:4EA9` `.l4EA9` → `.write_wave_control` |
| `SoundDrv_WriteChannelPitch` | `04:4F24` `.l4F24` → `.store_trigger_control`, `04:4F2D` `.l4F2D` → `.write_noise_pitch` |
| `SoundDrv_WriteChannelVolume` | `04:4FC0` `.l4FC0` → `.write_wave_volume` |
| `SoundDrv_SilenceChannel` | `04:4FE5` `.l4FE5` → `.disable_wave_channel` |

### engine/browser/inline_image_blit.asm

| Owner | Localizador no fonte | Nomes adotados |
|---|---|---|
| `Bmp_ParseHeader` | `51:712E` `.l712E` → `.clear_top_down_flag`, `51:7157` `.l7157` → `.reject_header` |
| `Bmp_CheckSize` | `51:7175` `.l7175` → `.reject_size` |
| `Bmp_ConvertToTiles` | `51:726F` `.l726F` → `.invert_row_bytes`, `51:73CB` `.l73CB` → `.return_success`, `51:73CE` `.l73CE` → `.return_failure` |
| `Image_BlitToTileCanvas` | `51:7458` `.l7458` → `.skip_source_rows`, `51:749F` `.l749F` → `.add_canvas_row_strides`, `51:74AF` `.l74AF` → `.blit_rows` |
| `Image_MakeEdgeMasks` | `51:74F2` `.l74F2` → `.rotate_left_mask_bit`, `51:74F9` `.l74F9` → `.full_left_mask`, `51:74FB` `.l74FB` → `.store_left_mask`, `51:7509` `.l7509` → `.rotate_right_mask_bit`, `51:7511` `.l7511` → `.full_right_mask`, `51:7513` `.l7513` → `.store_right_mask` |

### engine/mail/body_editor.asm

| Owner | Localizador no fonte | Nomes adotados |
|---|---|---|
| `MailBody_Edit` | `2D:477A` `.l477A` → `.check_keyboard_result`, `2D:47F3` `.l47F3` → `.check_keyboard_result_04`, `2D:4847` `.l4847` → `.check_keyboard_result_05`, `2D:4862` `.l4862` → `.reopen_keyboard`, `2D:4868` `.l4868` → `.check_cancel_button`, `2D:4894` `.l4894` → `.handle_direction_buttons` |
| `MailBody_CursorLeft` | `2D:48D4` `.l48D4` → `.decrement_column` |
| `MailBody_CursorUp` | `2D:495B` `.l495B` → `.move_to_previous_row` |
| `MailBody_GetCharPtr` | `2D:4EB4` `.l4EB4` → `.return_ff`, `2D:4EBA` `.l4EBA` → `.return_cr` |
| `MailBody_KeyboardLoop` | `2D:5724` `.l5724` → `.insert_keyboard_char`, `2D:5737` `.l5737` → `.check_before_backspace`, `2D:5742` `.l5742` → `.backspace`, `2D:5761` `.l5761` → `.insert_newline` |

### engine/mail_server/delete_sprite_counters.asm

| Owner | Localizador no fonte | Nomes adotados |
|---|---|---|
| `SpriteCounter_A_DrawNumber` | `23:5925` `.l5925` → `.divide_by_1000`, `23:5960` `.l5960` → `.divide_by_100`, `23:598C` `.l598C` → `.divide_by_10`, `23:59A9` `.l59A9` → `.draw_ones_from_e`, `23:59AD` `.l59AD` → `.add_saved_a_to_slots` |
| `SpriteCounter_B_DrawNumber` | `23:601C` `.l601C` → `.divide_by_1000`, `23:6057` `.l6057` → `.divide_by_100`, `23:6083` `.l6083` → `.divide_by_10`, `23:60A0` `.l60A0` → `.draw_ones_from_e`, `23:60A4` `.l60A4` → `.add_saved_a_to_slots` |
| `SpriteCounter_C_DrawNumber` | `23:66E4` `.l66E4` → `.divide_by_1000`, `23:671F` `.l671F` → `.divide_by_100`, `23:674B` `.l674B` → `.divide_by_10`, `23:6768` `.l6768` → `.draw_ones_from_e`, `23:676C` `.l676C` → `.add_saved_a_to_slots` |

### lib/mobile/mail.asm

| Owner | Localizador no fonte | Nomes adotados |
|---|---|---|
| `Mail_Base64EncodeChar` | `0F:5A04` `.l5A04` → `.encode_uppercase`, `0F:5A07` `.l5A07` → `.encode_lowercase`, `0F:5A0A` `.l5A0A` → `.encode_digit`, `0F:5A0D` `.l5A0D` → `.encode_plus` |
| `Mail_Base64Decode` | `0F:5C8C` `.l5C8C` → `.decode_quartet_chars`, `0F:5CAA` `.l5CAA` → `.consume_line_break`, `0F:5CAE` `.l5CAE` → `.incomplete_quartet` |
| `Mail_Base64DecodeChar` | `0F:5D3C` `.l5D3C` → `.invalid_char`, `0F:5D44` `.l5D44` → `.decode_plus`, `0F:5D47` `.l5D47` → `.decode_slash`, `0F:5D4A` `.l5D4A` → `.decode_digit`, `0F:5D4D` `.l5D4D` → `.decode_padding`, `0F:5D62` `.l5D62` → `.decode_uppercase`, `0F:5D65` `.l5D65` → `.decode_lowercase` |
| `Mail_NextSramPage` | `0F:5DA0` `.l5DA0` → `.advance_sram_bank` |

### lib/mobile/main.asm

| Owner | Localizador no fonte | Nomes adotados |
|---|---|---|
| `MobileSDK_CopyStringLen` | `75:4020` `.l4020` → `.add_copied_length` |
| `MobileSDK_ApiDispatch` | `75:4047` `.l4047` → `.load_api_pointer` |
| `MobileAPI_SetTimer` | `75:40F9` `.l40F9` → `.write_timer_registers` |
| `MobileSDK_Base64Encode` | `75:7C62` `.l7C62` → `.encode_triplet`, `75:7C68` `.l7C68` → `.copy_triplet`, `75:7C85` `.l7C85` → `.zero_pad_triplet`, `75:7CFB` `.l7CFB` → `.write_padding_chars`, `75:7D05` `.l7D05` → `.terminate_output` |
| `MobileSDK_Base64EncodeChar` | `75:7D1C` `.l7D1C` → `.encode_uppercase`, `75:7D1F` `.l7D1F` → `.encode_lowercase`, `75:7D22` `.l7D22` → `.encode_digit`, `75:7D25` `.l7D25` → `.encode_plus` |
| `MobileSDK_Base64Decode` | `75:7D36` `.l7D36` → `.check_remaining_input`, `75:7D4A` `.l7D4A` → `.decode_quartet_chars`, `75:7D6C` `.l7D6C` → `.consume_line_break` |
