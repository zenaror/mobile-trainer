# Bank27 computed tile-pair table and bounded padding interpretation

## Computed reader and exact original pairs

Original ROM27:5048..505C contains ten two-byte pairs. CommTime_PutDigit_27_5021 at27:5021..5048 computes DE=$5048+((2*A)&$FF). It saves BC/DE, copies the input destination into HL, reads the first byte through DE and stores it at the destination, then reads DE+1 and stores it at destination+$20. It writes attribute$08 at destination+$400 and destination+$420. The selected code bank is27; no ROM-bank switch occurs inside this consumer. The computed address contradicts the former no-reference hypothesis. The two-byte-per-index access contradicts treating this table as one20-column tilemap row with established four-byte row padding.

| index | first | second | second = first +$10 |
|---:|---|---|---|
|0|67|77|yes|
|1|68|78|yes|
|2|69|79|yes|
|3|69|6F|no: +$06|
|4|6A|7A|yes|
|5|6B|7B|yes|
|6|6C|7C|yes|
|7|6D|7D|yes|
|8|6E|7E|yes|
|9|6E|7F|no: +$11|

Exactly8 of10 pairs have the stated+$10 relationship, correcting the former9/10 assertion. Both exceptions and the repeated first byte6E remain exact; visual digit appearance is unvalidated. The existing Table_CommTime_DigitTiles_27_5048 and Data_27_5048 aliases retain their names and addresses.

## Caller bounds and unchanged unknowns

The four zero bytes at27:505C..5060 are preserved between the pair table and the aligned tile block beginning5060.
