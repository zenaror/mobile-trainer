# Original browser sprite chain at 73:5E60

CONFIRMED within original bank 73: the 99-byte chain consists of a four-byte frame table at 5E60, two 45-byte frames at 5E64 and 5E91, and a five-byte animation script at 5EBE. Each frame contains count 11 and eleven four-byte OAM records. The second frame has signed Y offsets -1, 7 and 15. These are emitted with existing sprite macros; the table uses literal original pointers to avoid adding labels.

Existing `BrowserStart_ObjAnimScriptTail_5EC0` points inside the first step delay.

This is original reconstruction evidence, not a new runtime or hardware observation. Arbitrary selector safety, whole-bank semantic closure, the unread tile/tail blocks and English translation remain outside these format claims.

## Mechanical first-frame-table alias

The owner stays230 lines; the existing table pointers, two frames, split script and `BrowserStart_ObjAnimScriptTail_5EC0` remain unchanged.
