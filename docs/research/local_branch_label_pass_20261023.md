# Japanese local operation labels: Mobile SDK and keyboard

| Source owner | Count | Address range | Examples of adopted operation labels |
|---|---:|---|---|
| `lib/mobile/main.asm` | 23 | Bank 75 | `.restore_bc_and_return`, `.compare_length_limit`, `.write_thousands_digit`, `.scan_leading_zeroes` |
| `lib/mobile/mail.asm` | 25 | Bank 0F | `.copy_header_byte`, `.return_output_length`, `.check_saved_paren_opener`, `.check_saved_quote_opener` |
| `engine/keyboard/keyboard.asm` | 24 | Bank 55 | `.set_up_window_and_panel`, `.check_instant_mode`, `.dispatch_buttons`, `.move_left`, `.check_type5_select_arg_b` |

The keyboard label at `55:5DF5`, `.CheckTypeThenContinueOrHide`, was not changed; its existing note that natural entry is unproved remains.
