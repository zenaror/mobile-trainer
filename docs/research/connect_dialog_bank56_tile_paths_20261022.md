# Connect-dialog Bank 56 tile paths

| Old stem | New stem |
| --- | --- |
| `tiles_52c0` | `connect_dialog_connect_confirm_tiles_9000_vb1` |
| `tiles_56c0` | `connect_dialog_connect_confirm_tiles_9400_vb1` |
| `tiles_5ac0` | `connect_dialog_password_entry_and_save_confirm_tiles_8800_vb0` |
| `tiles_5dc0` | `connect_dialog_password_entry_and_save_confirm_tiles_9100_vb1` |
| `tiles_60c0` | `connect_dialog_password_entry_and_save_confirm_tiles_9400_vb1` |
| `tiles_64c0` | `connect_dialog_stored_password_tiles_shared_source` |
| `tiles_68c0` | `connect_dialog_stored_password_tiles_9200_vb1_continuation` |
| `tiles_6ac0` | `connect_dialog_stored_password_tiles_9400_vb1` |
| `tiles_6ec0` | `connect_dialog_password_saved_tiles_9100_vb1` |
| `tiles_71c0` | `connect_dialog_password_saved_tiles_9400_vb1` |
| `tiles_75c0` | `connect_dialog_common_finish_tiles_8000_vb0` |

The destination/VBK decoding is supported by the loader at ROM0 `$0787`: E bit 0 selects VRAM bank, E masked with `$F0` supplies the destination, and C encodes the transfer length. These names do not claim natural execution, rendered appearance, or behavior on hardware. In particular, the split `64C0/68C0` source and its transfer overlap are preserved exactly; do not merge or reorder these slices.
