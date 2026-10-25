# Shared text-entry VRAM source paths, bank 5E

## The bounded collection

The collection name is **PROBABLE**, bounded by the four positive text-entry reader contexts below. Both existing data headers remain **CONFIRMED** without changes to their evidence text. Names describe a shared source and its demonstrated transfer destination; they do not classify every tile as a glyph, recover original terminology, or assign an exclusive phone/account screen purpose. The existing research note `settings_text_entry_and_confirm_resource_names.md` documents the shared contract; its alias-retirement evidence remains separate from this path unit.

| Context | First call: source 5E:4000 | Second call: source 5E:4400 |
|---|---|---|
| `PhoneKeypad_Setup` | 67:4370 | 67:4382 |
| `PhoneComment_KeyboardSetup` | 67:49E5 | 67:49F7 |
| `Account_LoginIdEntry_Setup` | 68:5351 | 68:5363 |
| `Account_MailAddressEntry_Setup` | 68:5804 | 68:5816 |

Each of the eight literal source blocks matches the original ROM instructions immediately before and through its inline FarCall. It sets A=$5E, B=$92, C=$40 and HL=$4000/$4400; DE=$8801/$8C01. FarCall invokes `Gfx_StartHDMAWithService` at 00:0787, preserving the incoming A/HL under its existing trampoline contract. That helper selects the ROM bank through `BankSwitch_H`, writes the source/destination HDMA registers, masks E with $F0 for the aligned destination, and uses E bit0 for VRAM bank. C=$40 is 64 blocks of 16 bytes, within its existing legal general-purpose domain $01..$80. The destination extents are therefore VRAM1:$8800–8C00 and $8C00–9000. When LCD is enabled the helper waits for $91<=LY<B; B=$92 is not a new universal timing guarantee.

## Narrow path migration and editing views

The owner header, SECTION, INCBINs and single `layout.link` section name move together at unchanged bank $5E/org $4000.

The two catalogue rows change only `path` and `asm`. The two PNG-rule rows change only `out` and `png`; kinds, sizes, padding and binary baseline hashes stay held. Four lines of `gfx/png.mk` update the two output-list entries and two PNG_SIZE assignments; the common `%.2bpp: %.png` rule resolves the matched new stems. No editing-tool code needs a resource-specific change.

`screen_png.Screen` parses these components as dest:asset:first:count; catalogue-backed reads continue to use the new paths.

The intervening screen71 records are non-tile rules. The filtered tile order
already agrees, so the reserialized `gfx/png.mk` is byte-identical and is retained.
