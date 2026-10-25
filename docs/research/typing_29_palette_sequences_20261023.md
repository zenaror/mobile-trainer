# Bank 29 palette sequence names

Each sequence saves/restores SVBK and calls existing candidate helpers. The 36-byte variants repeatedly read
current BG/OBJ palettes, apply eight steps toward the named endpoint per round, and write the buffer for
four rounds. The 54-byte variants copy a block from HL into the buffer. Their outer pass count descends
from four to one; each pass runs that many groups of eight steps, so the helper call counts are 32, 24,
16, and 8 (80 total if every helper returns), before writing the round. After the loop they copy and
write the source block once more without fading. This last
reload is retained in the two names because omitting it would misdescribe the decoded operation. Exact
buffer source/bank contracts remain unknown.

The four named globals changed the assembler owner of ten pre-existing address-only locals in the
two block routines. The local labels at 29:515E and 51B8 are now `.fade_pass`; 29:5167 and 51C1 are `.fade_step`.
The block variants use `.fade_pass` at 29:5182 and 51DC, `.fade_group` at 29:518B and 51E5, and
`.fade_step` at 29:518D and 51E7. All ten former address-only labels now have these role names. The
row-level review and old-to-new mapping is in
[`japanese_palette_candidate_local_label_mapping_20261023.tsv`](japanese_palette_candidate_local_label_mapping_20261023.tsv).
Instruction bytes and transfer targets must remain unchanged. This semantic naming/comment change
does not establish natural reachability or purpose.
