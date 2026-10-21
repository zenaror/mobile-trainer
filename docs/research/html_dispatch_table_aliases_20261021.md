# HTML dispatch-table aliases (2026-10-21)

Retired four generic `Table_74_AAAA` globals from the URL, tag-dispatch,
`<br clear>` dispatch, and count-pass owners (`engine/html/url.asm`,
`engine/html/tags.asm`, and `engine/html/count_pass.asm`). Each had an existing
same-address descriptive label: `HtmlUrl_SchemeTable`, `Html_TagHandlerTable`,
`Html_BrClearJumpTable`, or `Html_CountPassTagTable`. Exact-token scans found
only these declarations and comments; the comments now cite the retained
labels. The words, targets, table bounds, confidence and emitted bytes are
unchanged. The inferred 18-word extent of `Html_CountPassTagTable` remains
PROBABLE, as in its source header.
