# Japanese mail body editor local-label pass

This static pass names local control-flow labels in engine/mail/body_editor.asm. Labels describe instruction-level roles visible in this file; they do not establish natural reachability, product purpose, or complete callees/contracts.

At 2D:5189 and 2D:528E, the copy loop transfers two bytes while each pointer has net movement of one byte per iteration; successive copy windows overlap.
