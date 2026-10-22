# T78 keyboard candidate tail paths (2026-10-21)

Renamed the four 192-byte graphics chunks following the confirmed T78 page 0–3 VRAM uploads in bank 62. Each owner symbol identifies its page and labels the 12-tile block as a candidate tail. New basenames use that existing bounded description rather than only a byte address; the PROBABLE classification is unchanged.

The neighboring 1024-byte and 576-byte page uploads are CONFIRMED at the documented bank-55 call sites. The 192-byte blocks are classified as coherent 2bpp tile data by the existing heuristic, but their own direct loader references and exact display role are not established. The rename therefore makes no claim that a tail is loaded or displayed. SHA-256 for all four binary payloads and four PNGs matches before and after the rename.
