# Independent reference of the sound effect names and the macro (sfx1)

S2 also converted the 367 sites to `play_sfx` in a scratch copy (ROM identical).

## 3. Decisions of the coordinator

* Prototype sites (`engine/unreferenced/`) and `[HYPOTHESIS]` stubs keep their numbers whatever the id (the tool does it: `NUMERIC_DIRS`, `hypothesis_above`); `SFX_DELETE` stays at the unreachable site of `connect_dialog_screen.asm` with a comment.
* Both readers accept a name that is true only at some sites of an id when the other sites are provably unreachable and say why (the mixed ones: `$2C` for Select / Start / the 10 s timer are the same outcome reached by another trigger).
* The constants are UPPER_CASE words (STYLE.md section 4), defined in `consts.asm` with `EXPORT`; the header of that file no longer says "never substituted into operands" for the sound ids.
