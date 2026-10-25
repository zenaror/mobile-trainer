# Candidate routine contracts

Addresses below refer to physical ROM banks. A CPU address in `$4000–7FFF`
identifies bytes only when the selected bank is known. The routines are present
in the source; an uncertain natural entry does not mean an implementation is missing.

## Reply staging — `2B:6CF5`

`MailReply_ComposeFromRecord` selects WRAM1 and SRAM0, uses entry B to index
twelve SRAM record bases, and copies the recorded address/name into editor
buffers. It sets reply mode 3 and opens address, title and body editors.

The index is not checked against 0..11. Unlike `Mailbox_ReplyToRecord` in Bank25,
it uses B directly, clears only `$24` bytes at `$D400`, and initially enters
`MailAddr_Edit` with A=0. The success path at `$6D94–6D97` pops four words;
its `RET` uses the entry stack word at +8. Cancellation uses the entry return.
No natural caller or four-word unwind convention is established. The shared
reply operation does not establish ABI equivalence with the Bank25 implementation.

Source: [mail viewer](../../engine/mail/mail_viewer_sender.asm).

## Text-cell locator — `2D:4E42/4E54`

`MailBody_LocateCell` selects WRAM1 and calls `MailBody_LocateCellInMappedWram`.
The helper starts at `$D400`; B/C describe row/cell traversal in two-byte cells.
Prior rows end on `$0D` or twelve cells. The selected-row scan has no twelve-cell
bound. `$FF` requests 255 units rather than zero.

On the ordinary path, HL is the selected cell, A its first byte, E the traversed
cell offset, and BC is restored. The code does not enforce the `$C0`-byte buffer
extent. A NUL in prior-row cells 1..11 reaches `RET $4E72` without balancing the
saved BC: PC becomes entry BC and the real return remains on the stack. A NUL in
cell 12 instead follows width exhaustion. Natural entry and the intended early
return convention remain unknown.

The wrapper disables the SRAM gate only after an ordinary helper return and
leaves WRAM1 selected. It does not restore the prior mapper state.

Source: [body editor](../../engine/mail/body_editor.asm).

## Graphics/wait helper — `29:511E`

The known local caller at `$50CE` is itself without a demonstrated natural root.
It calls CPU `$7BB7` without selecting Bank7D, where `Joypad_Update` resides;
physical Bank29 contains zero bytes at that address. Subsequent LY waits are
conditional on a balanced return and the expected joypad state. A data transfer
from Bank29 does not supply an executable entry or a remapped callee.

## SRAM state bit — `70:4740`

The candidate queries bit 7 of SRAM1 `$A9ED` and preserves/restores the mapper
shadows through stack saves. Coherent shadows and a valid stack are required.
The preceding byte is a `RET`; normal table dispatch selects other handlers.
Save-block reset can produce the SRAM contents, but does not itself call this
query. Natural use and the field's intended meaning remain uncertain.

## Memory-write fragments — Banks26/28

`26:5344–537C` performs repeated VRAM1 and WRAM7 writes. The nearby active caller
calls the one-byte `RET` at `$5343` and resumes after it; this does not enter
`$5344`. Its required stack and WRAM/VRAM bank conditions remain unestablished.

`28:4BA6–4BC2` clears `$C000–C08F`, selects WRAM7 and fills `$DA00–DAFF` with `$FF`.
Its OAM-like clearing length and WRAM extent differ from `Sprite_ResetAll`.
The preceding animation script ends at `$4BA5` and supplies no entry. A reset-like
purpose is a hypothesis, not proof of a callable reset function.

## Resource selection

Bank53's 25 Pokémon strings have no established executable name-to-frame chain.
Bank23's four probable mail-status panels have no identified natural reader.
See [frame/name resources](assets_pokemon_frames_and_name_limits.md).

The eight Bank71 communication captions are selected by phase/variant rows
`0,0,0,0 / 2,5,6,7 / 4,4,4,4`. Phases are dial/operation/close; variants are
registration/password/usage time/usage fee. DION captions 1/3 are not selected by
these valid rows. Neither index is bounds-checked. Redrawing a caption does not
update the stored phase used by cancel-button logic.

The five settings highlights are password, usage time, usage fee, delete
registration and telephone number. Normal cursor movement cycles 0..3; hidden
mode adds item4. Confirmation returns cursor+1, so result5 enters the phone
handler. Saved cursor restoration is not bounds-checked.

## Sample-record names

The sample installers use fixed Bank2D sources: five nine-byte headers,
20 mail-string copies, twelve address-book string copies and two name/address
copies. Three name strings contain 16 nonzero bytes plus NUL, so their terminator
lands at the next field and is overwritten by its following copy. The named mail
and address-book display routines use 16-cell limits; the address-book loader
copies exactly 16 name bytes. These exact strings therefore do not require the
overwritten terminator in those paths. This is not an arbitrary-input guarantee
or proof of a natural sample-installer entry.

Source: [sample records](../../engine/mail/sample_data.asm).
