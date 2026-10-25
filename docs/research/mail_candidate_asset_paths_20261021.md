# Mail graphics asset paths

Three Japanese mail asset files now use paths aligned with their source labels: the confirmed mail-address OBJ HDMA tail at 2D:7940 (binary and exact PNG view), and the candidate connect-screen palette at 29:5376. All three hashes match before and after renaming. Source references and generated catalog/PNG metadata were updated.

The mail-address tail is part of the transfer from 2D:7880 to VRAM bank 0 $80C0-$82CF; 240 bytes have static frame associations and the remaining 288 are transfer-only in this call chain. The connect-screen palette remains PROBABLE; its candidate status and lack of an established natural consumer are unchanged.
