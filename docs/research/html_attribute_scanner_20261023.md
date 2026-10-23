# ROM0 HTML attribute scanner contract (2026-10-23)

## Scope and evidence

This note records the static contract visible in `home/keyword_scan.asm` at `Html_ScanAttributes` (`00:1119-131A`) and its helper `Html_MatchKeyword` (`00:10E9-1118`). It was checked against all ten current call sites under `engine/html/` and the keyword tables in `data/html/keywords.asm`. The source is the maintained Japanese reconstruction at commit `8a32d886d946bfb392b0c246b4d4fcb75b8e2c41`; the ROM identity remains the repository's documented Japanese target. This is a static source/disassembly claim, not a new execution or full HTML-conformance claim.

## Inputs, outputs, and cursor

`HL` is the current source cursor. `BC` points to a zero-terminated array of little-endian pointers. Each pointed-to item is an ASCII keyword followed by NUL and one metadata byte; the tables in bank 74 use this layout. `DE` is saved as caller state and restored before return. `BC` is also preserved. `A` returns the matched item's metadata, or zero when the scan finds no value for a listed keyword. On termination by `>` or NUL, the scanner leaves `HL` on that terminator. After a completed value, it leaves `HL` after the closing quote or at the value delimiter.

The keyword helper folds only ASCII uppercase bytes in the input to lowercase. The table text itself must already be lowercase. It treats the table item's NUL as the end of a matched keyword and returns the following metadata byte. The outer scanner retries from the next input byte when a position does not match, so this is a byte-stream search, not a grammar that first tokenizes an attribute name.

## Scan behavior

- The outer loop ends at NUL or `>`; `=` encountered outside a recognized name dispatches to the unmatched-value skipper. Bytes below `$21` are skipped. For bytes in the configured Shift-JIS lead ranges (`$81-$9F`, `$E0-$EF`, `$F8-$F9`), the scanner also advances over the following byte. These lead/trail branches are marked PROBABLE in the source because the existing traces did not execute them.
- When a keyword matches, the routine searches forward for `=`. It skips bytes below `$21`; `>` or NUL means no value and returns zero. A visible non-`=` byte abandons that candidate and resumes the outer scan after that byte.
- After `=`, bytes below `$21` are skipped. A value may be unquoted, double-quoted, or single-quoted. Unquoted values end at a byte below `$21`, `>`, or NUL. Quoted values end at their matching quote; `>` and NUL also terminate them. Bytes below `$20` inside quotes are omitted from the output. The code has no visible escape-sequence handling.
- A recognized value is copied to `wAttrUrlBuf` (`$C380`) and NUL-terminated. The 8-bit length counter permits at most 255 copied bytes, including a Shift-JIS trail byte when present; the next byte ends the copy before it is stored. A matched quoted value terminated by `>` or NUL still returns its metadata and copied prefix. If no `=`/value is found for a matched keyword, the routine returns zero.
- For an unrecognized `=` value, the scanner skips the value (including single- or double-quoted forms) and resumes after the closing quote or whitespace delimiter. `>` and NUL stop the scan. This path does not copy the value.

## Call-site boundary

The ten calls are in `engine/html/count_pass.asm:298`, `engine/html/parser.asm:491`, and `engine/html/tags.asm:369,470,1024,1133,1348,1550,1586,1751`. They pass `Html_NoKeywords`, `Html_MetaAttrPtrs`, `Html_AlignAttrPtrs`, `Html_AnchorAttrPtrs`, `Html_BrAttrPtrs`, `Html_HrAttrPtrs`, or `Html_ImgAttrPtrs`. The tag handlers interpret returned metadata and `wAttrUrlBuf` for their own fields; the scanner itself does not validate URLs, enforce a tag-specific grammar, bound the input source, or establish safe buffer capacity for arbitrary callers. Some paths skip attributes with the empty keyword list, and image scan-only mode repeatedly calls the scanner to find `src`.

Static mechanics above are CONFIRMED by the instructions and current call/table structure. The Shift-JIS pair paths remain PROBABLE as marked in the source. Existing coverage comments report execution in prior trace scenarios, but this pass did not rerun them and does not upgrade unexecuted branches or establish natural reachability for every handler.
