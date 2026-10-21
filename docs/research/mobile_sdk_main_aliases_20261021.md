# Mobile SDK `main.asm` duplicate aliases (2026-10-21)

Removed 21 address-only exports from `lib/mobile/main.asm`. Each address already
had a semantic label in the same file; a fresh census and owner-local review
found no other-source, tool, code, or comment references to the generic names.
The semantic labels, bytes, table entries, comments, and assembled addresses
remain unchanged. This is a symbol-table cleanup, not a new semantic
identification claim.

| address | retired generic label | retained label |
|---|---|---|
| `75:4070` | `Table_75_4070` | `MobileSDK_ApiTable` |
| `75:4FB2` | `String_75_4FB2` | `MobileStr_HttpPrefix` |
| `75:4FDE` | `String_75_4FDE` | `MobileStr_UrlUpload` |
| `75:5001` | `String_75_5001` | `MobileStr_UrlUtility` |
| `75:5025` | `String_75_5025` | `MobileStr_UrlRanking` |
| `75:6099` | `String_75_6099` | `MobileStr_Helo` |
| `75:609F` | `String_75_609F` | `MobileStr_MailFrom` |
| `75:60B5` | `String_75_60B5` | `MobileStr_Data` |
| `75:611C` | `String_75_611C` | `MobileStr_UserAgent` |
| `75:6138` | `String_75_6138` | `MobileStr_ContentLength` |
| `75:61A7` | `Table_75_61A7` | `MobileSDK_StateTable` |
| `75:7039` | `String_75_7039` | `MobileStr_HdrDate` |
| `75:72DE` | `String_75_72DE` | `MobileStr_HdrGbStatus` |
| `75:72EA` | `String_75_72EA` | `MobileStr_HdrGbAuthId` |
| `75:7315` | `String_75_7315` | `MobileStr_HdrContentTypeCgb` |
| `75:7337` | `String_75_7337` | `MobileStr_HdrUriHeader` |
| `75:73AA` | `String_75_73AA` | `MobileStr_ContentLengthZero` |
| `75:7A17` | `String_75_7A17` | `MobileStr_Authorization` |
| `75:7A32` | `Table_75_7A32` | `MobileSDK_Md5StepTable` |
| `75:7B32` | `Table_75_7B32` | `MobileSDK_Md5StatePtrTable` |
| `75:7B50` | `Table_75_7B50` | `MobileSDK_Md5KTable` |

Evidence: census pinned to `1bfd44b50044f329b96ceb1d4ede1d86d154ae70`,
covering 347 tracked ASM/INC files while excluding `languages/` and the
protected `engine/mail/sample_data.asm`; source-set SHA-256
`1db5961e04aacd5fe9a42324faaef7f30d3cdf5e4490e65be6b75a5fa35d76fb`.
All 21 records map to exactly one existing same-address semantic label, have
zero references in other source files or tools, and zero local labels scoped
under the generic declaration. The independent reviewer also found no uses in
the owner file beyond each declaration. The receipt is retained in ignored
`.tmp/generic-coalias-post-1bfd44b5-20261021/RESULT.json`.

Confidence: **CONFIRMED** that these were redundant exports under the recorded
source set and owner-local inspection. No new claim is made about natural
execution or the meaning of the underlying SDK routines.
