# Browser page-view table aliases (2026-10-21)

Retired nine generic `Table_4E_AAAA` globals from
`engine/browser/page_view.asm`. Each was an unreferenced same-address alias of
an existing `Browser_PageView_*` or `Browser_Menu_*_ResultTable` label. A
maintained-assembly exact-token search found only those declarations. The
descriptive labels name the tables' placement or dispatch/result role; no
stronger runtime claim is added here. All `dw` values, targets, comments,
confidence levels, and machine-code bytes remain unchanged.
