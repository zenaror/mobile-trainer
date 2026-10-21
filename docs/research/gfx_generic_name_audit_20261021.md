# Static GFX generic-name audit (2026-10-21)

An isolated read-only audit examined 85 maintained `gfx/**/*.asm` sources,
1,856 files under `gfx/`, and 2,817 global label definitions. It found no
current directory named `bankNN`; the historical bank41/bank42 paths map to
the descriptive owners `gfx/frame_designs/foliage_ribbon_and_beveled_panels_41.asm`
and `gfx/frame_designs/metal_flame_and_creature_borders_42.asm`.

The exact `Type_BB_AAAA` pattern matches 1,495 labels: 605 were classified as
lexically generic with evidence in the copied source context, 648 as legitimate
address provenance or co-located aliases, and 242 as indeterminate. Of these,
550 have an adjacent descriptive alias and 945 do not. The inventory separately
lists 62 semantic labels that retain a bank/address suffix. File-path inventory
covered 996 candidate assets: 598 type-plus-address basenames and 398
semantically qualified names with coordinates. The file candidates were
classified as 504 with clear lexical evidence, 14 semantically suggestive but
incomplete, 384 where address provenance is legitimate, and 94 indeterminate.
None of those classes is an automatic rename decision.

These counts are a lexical triage, not a completion claim. The source context
was copied from the same checkout before this audit; asset binaries were
inventoried by path but not decoded or viewed, and comments about consumers
were not revalidated in engine code. Keep names neutral where role is
unproven, and verify each candidate's bank, exact address, references, local
scope and file/path ownership before editing.

The complete 625,149-byte private report is retained at
`.tmp/agent-gfx-name-audit-private-20261021/REPORT.md` (SHA-256
`7b511ddde653b245b02623e8f0bf8fcb25d24b63728e9b4fa2887f65d68c576e`). Its
85-source aggregate SHA-256 is
`9ce4241d25bbff70fc454a9a3fdcb43814ab7b6c61bae6193fd60bde127e9c5c`.
