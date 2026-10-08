# Fresh bank 26 proposal on published original1004 (2026-10-08)

The following010c prepared note is retained as explicitly historical. The fresh OWN/rebase appendix below defines the current private proposal; no gate or integration result is claimed.

## Historical010c prepared note

# Bank 26: proposed word-delta comparison alias (2026-10-08)

Status: **PROBABLE; static proposal only.** `MailSession_CompareWordDeltas` is a restricted operation name for `Function_26_5106` at 26:5106–5168. The stable neutral name and its local labels remain. This proposal does not assign ACK, completion, payload or protocol-counter meaning. It is prepared from published original `010c`; adoption parent after the bank00 documentation publication is still unset and requires fresh direct OWN/rebase.

Let Wxx be the little-endian word at WRAM1[wMailSessionBlock+xx]. The 98 original bytes contain 72 instruction starts. With an ordinary valid nonaliasing stack and no relevant interrupt/bank interference, the arithmetic compares `(W05 - W03)` with `(W0B - W0D)`, modulo 65536. The `xor $FF`/`inc bc` pairs negate loaded words; they do not prove the stored fields use a one's-complement representation. Equality does not establish signed ordering or absence of wrap. Both paths explicitly select hWRAMBank/rSVBK 1 twice and leave 1 selected; they do not restore the incoming selector. Word reads and the two-byte copy are not atomic.

The observed unequal path returns A=0, restoring incoming HL/BC/DE. The equality arm 26:514D–5168 is a static PROBABLE contract: it copies W0B into W0D, returns HL=W05 and A=1, and restores BC/DE. It does not update W03. The caller at 26:4737 tests A with DEC A / JP Z 26:49FF, distinguishing the ordinary A=1 path. Coverage of 49FF from other entries does not demonstrate execution of the equality arm. Stack/data aliases and interrupts can break these ordinary contracts.

## Existing natural evidence and limits

Direct rereading of 69 natural coverage files, 69 merged data-access files and 50 available callgraphs plus the union reproduces 49 entries in seven scenarios, 52 observed starts and 20 unobserved starts in the equality arm. This repeats existing evidence; no new runtime scenario was executed. Available callgraphs show 39 calls from26:4737 and 39 normal returns at 26:514C in four scenarios. Callgraph files are absent for the other three entry scenarios: fuzz_browser, monkey_camp_reg and monkey_camp_reg2. These different corpus counts do not contradict each other. No equality return at 5167 is recorded. Merged data-access ranges do not establish temporal attribution or field values. Forced tracked artifacts were only inherited as opaque inventory bytes and were not analyzed or used.

The static operation supports the narrow PROBABLE alias, while the equality behavior and meanings of overlaid fields remain unresolved. Frozen config and earlier research retain historical counter/progress ideas; the alias does not promote those ideas or close the whole bank.

## Representation and chronology

The proposal replaces the blank at mail_session_screen.asm:92 with the new global alias, keeps Function_26_5106 at93 including its address comment, and changes only the CALL operand at mail_session.asm:867. Owner line counts remain 1,300/2,030. Existing globals, local scopes, instructions/data and aliases remain; the two strict source vectors change explicitly. Replacing precisely the new alias row with its original blank and the CALL operand with its original neutral target restores the original vectors. All other 346 vectors and all 289 tracked analysis/gfx TSV bytes remain exact; no locator remapping is performed.

Mandatory OMM and ROOT briefs were known before direct OWN and are disclosed. Direct owner/ROM/namespace/metadata and the complete 188 natural inputs were sealed before reading the historical ROOT/independent analytical packets. The broad source/Git/native baseline is explicitly inherited from the current project OWN and completed bank00 private guards; a redundant whole-project recapture was avoided. Historical `7fb` dirty and f450 proposals remain historical. This prepared `010c` overlay cannot silently become a post-bank00 candidate.

No build, comparison or new execution is claimed here. A future build must retain the original ROM bytes, add exactly the new symbol at 26:5106 and preserve every existing symbol/address and local scope. OBJ/SYM/MAP metadata can change because of the alias; their historical whole hashes are not post-alias expectations. Fresh OWN, ROOT review and a separately bound one-run protocol are required before gates or integration.


## Fresh OWN/rebase to published bank00 documentation (2026-10-08)

The base chain is010c→SOURCE9466→DOC1004c664dddcbaf9a046a8910f37dd6b4f785a57. New direct whole JP/EN source/Gitblobs/rawGit/types/ignored/references and bank26 owner/raw/188natural reads were sealed before updated DOC receipt8513. Current4,184tracked files derive a private4,186-file candidate; the six-path scope has4existing modifications and2new English notes, preserving4,180outside files. Both1300/2030-line owners are unchanged from historical OWN before precisely the blank92→PROBABLEalias and CALL867 operand changes; neutral93 including its addresscomment and all local scopes remain. Exactly2 strictvectors change, with exact scoped normalization back to current baseline; all289TSV bytes and locators remain unchanged.

A new canonical37 protocol is prepared privately, requiring new ROOT whole-read review and one-run marker before any command. Gates remainNULL. Expected36rc0 plus ordinal27 exact97-byte historicalschema rc2 are separate. The finite671-output plan permits compiler metadata changes only in the two modifiedowner objects and the exactly-one-alias SYM/MAP additions; all remaining outputs retain current bytes. FinalSYM must add only MailSession_CompareWordDeltas=26:5106, deriving15,536banked labels and preserving51constants and all old/local names. No historical wholeSYM/OBJ/MAP hash is required afteralias. The ROM must compare to the immutable original after authorizedmake; no equivalence is asserted now. Current native1,951files/2,091resolutions/ABI6 and62valid/8opaque actual caches were directly checked, using prospective PNG89 and future isolated no-write/no-user-site prefixes. Actual0777/Git100644/TAR0664/private0644/ref0444 are separate.
