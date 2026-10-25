# reference scope for 73:6143 split returns

The neighboring CALL6093 dispatch and its ten-byte table6096 are separate code/data. Its five targets6114/614F/617A/617D/60A0 do not include6143 or6149. ROM0 JumpTableInline and JoypadDispatch explain that format. FillBytes00:04D8 with A0, BC00FC and HLC0D4 clears [C0D4,C1D0), including both fields; this indexed write refutes global writer absence but does not establish their complete domains. Other field readers62D2/62DA test the whole byte and do not call these fragments. Address-word occurrences and same numeric targets in other banks are not bank73 callers. Computed, interior overlapping entries remain open.

FillBytes00:04D8 supplied A0,BC00FC,HLC0D4 at73:5F33 clears252 bytes in[C0D4,C1D0), including both fields by indexed stores.

Seven comments describe two independent6-byte/3-start fragments at73:6143 and6149.
