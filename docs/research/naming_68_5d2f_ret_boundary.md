# 68:5D2F — RET boundary and the following unlabelled candidate

## PROBABLE boundary

| Bank: CPU range | Original ROM range | Bytes | Interpretation |
|---|---|---:|---|
| 68: `[5D2E,5D2F)` | `[1A1D2E,1A1D2F)` | 1 | preceding screen routine's `RET` |
| 68: `[5D2F,5D30)` | `[1A1D2F,1A1D30)` | 1 | `Function_68_5D2F`: `$C9`, `RET` |
| 68: `[5D30,5D9C)` | `[1A1D30,1A1D9C)` | 108 | unlabelled candidate sequence; `RET` at 5D9B |
| 68: 5D9C | 1A1D9C | — | next labelled setup routine |

## PROBABLE shape of the 108-byte candidate

For that bounded path, with terminating helpers and no intervening scratch
overwrite, A is zero on equality and is the updated mask value on inequality, carried through the shared scratch byte. A zero updated
mask can also arise on inequality: A is not a Boolean "changed" result. The
three `POP AF` operations restore saved flag bytes under normal stack/callee
completion assumptions. No universal ABI, domain or natural contract is
assigned to this unproven entry.

Existing RAM names connect `$B07F` to `sSettingsPassword` and `$DED4` to
`wAcctPasswordEntry`. These names and sibling login/mail sequences support a
field-comparison interpretation, but do not establish the intended use of the
neutral RET entry. No runtime field values, account data or sampled credentials
are used here.

The displayed path enables RAMG0A, selects SRAMbank1 and WRAMbank3, then restores saved HRAM shadows in reverse order. Physical register restoration requires synchronized initial shadows, stable scratch/stack and completed helpers without interfering changes. Equal strings yield A0 before restoration; unequal strings set C2790 and C278=old&FB. FinalA on inequality is that updated mask and can also be0; this is not a Boolean result. The last POPAF restores the first savedF, equal to entryF under the displayed uninterrupted load/stack path; no universal ABI is asserted. Original first savedA is the prior RAM-enable shadow, while finalA comes from scratch. Source names and sibling comparisons are context, not proof of purpose. Entry/purpose/natural reachability remain HYPOTHESIS; bounded structure remains PROBABLE.

## Return-only operation alias and separate comparison fragment

`ReturnOnly_68_5D2F` is a PROBABLE operation alias for the existing `Function_68_5D2F`. It replaces the prior neutral-name recommendation for that one opcode only; entry, caller and application purpose remain HYPOTHESIS. The original byte at68:5D2F isC9. Under a valid conventional return stack it consumes the saved return address, advances SP by2 and leaves AF/BC/DE/HL unchanged. It has no sequential edge to5D30 and no password-comparison, mapper, scratch or field operation of its own. It does not promise a particular return destination or exclude computed control. The alias occupies preceding blank25; neutral26 and all instruction/locator positions remain unchanged.

A hypothetical full entry there saves three AF pairs containing incoming SRAM-enable, SRAM-bank and WRAM-bank software shadows.

It programs RAMG0A/SRAM1/WRAM3, then uses ROM0 DecodeXorA5(14EA) to copy SRAM1:B07F XORA5 through the decodedNUL into fixed WRAM C28F.

The common restore tail uses FFF2 scratch and three balanced POPAFs, restoring saved shadow/register pairs in reverse order: WRAM, SRAM-bank, SRAM-enable. Ordinary completion returnsA0 on equality or the updatedC278 mask on inequality and restores entryF. A zero mask can result from inequality, so this is not a Boolean changed result. C is unchanged by the shown code/callees; B is assigned the oldC278 value on the inequality path. HL/DE are working string pointers, not preserved inputs. The three localAF saves use6 stack bytes; the two ROM0 helpers require conventional balanced returns, and CompareString's temporaryPUSH adds to that depth. There is no separate farcall/trampoline here.

This fragment requires stable ROM68 fetching, valid SRAM/WRAM fields and writable buffer extents, a terminating decodedNUL, readable compare extents and nonaliasing stack/scratch without relevant IRQ/mapper interference. Decode emits no length bound; field-size annotations do not guarantee safety. Restore means programming hardware from saved software shadows, not sampling or recovering an inconsistent initial hardware state. The explicit SRAM/WRAM selections and restoredF do not imply arbitrary reentrancy or a universal ABI. Existing login/mail comparison relatives and executed ROM0 string helpers support the local operations but establish neither this fragment's entry nor a password feature attached to5D2F. No sampled credentials, new runtime or natural caller is supplied.

## Source label update

The current hand-maintained source labels the 108-byte sequence beginning at 68:5D30 as `Account_PasswordEntry_CompareStoredPassword`.

The preceding `RET` at 68:5D2F remains a separate return-only operation and has no sequential edge into the candidate.
