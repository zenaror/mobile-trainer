# Mobile-dictionary generic table aliases (2026-10-21)

Retired 12 generic `Table_1A_AAAA` aliases from
`engine/help/mobile_dictionary.asm`. Each was an exact-address duplicate of an
existing `Table_MobileDict_*` label: the button dispatch list, category
directory, or category string-pointer list. Maintained-assembly token searches
found no consumers beyond those declarations and explanatory comments. Those
comments now refer to the retained descriptive labels. Table words, targets,
extents, and confidence levels are unchanged; the category/string directory
interpretations remain PROBABLE where the source headers say PROBABLE.
