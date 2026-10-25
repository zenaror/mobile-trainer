# Language builds

The language build interface keeps the default Japanese reconstruction separate
from the experimental English overlay.

```sh
make                 # Original Japanese ROM
make english         # English overlay
make english-check   # Overlay and selected-source checks
```

## Inputs and outputs

`tools/build_english.py` reads `languages/en/manifest.json`. Selected paths use
explicit English overrides; other selected paths use pinned Japanese inputs.
The manifest records hashes, expected outputs and the permitted source set.
Text, sprites, tiles, boxes, maps, attributes, palettes and editable PNGs can all
be selected by this mechanism.

The English source view, build outputs and cache are under `build/en/`.
Changing `DEBUG` or other effective inputs changes the cache key and can recreate
that source view. It is generated output, not the editable language source.

## Validation

The cache binds selected files, helper code, manifest bytes, tool identities
and options. A changed input, an invalid pin or a changed/missing output must not
silently reuse an accepted cache. Source and output pins are checked after
successful build/check operations.

The Make targets forward `RGBASM`, `RGBLINK`, `RGBGFX`, `PYTHON` and the
assembler/linker flags. Executable settings name one executable; pass options
through their corresponding flag settings. Some legacy checks invoke `python3`
from `PATH` directly.

A documentation-only change to a pinned input can require a manifest refresh;
the file's unchanged ROM semantics do not make its source hash equal. Do not
bypass pins to accept an unreviewed source set.

## Scope

The overlay does not provide complete English coverage. Its selected changes
and successful build checks do not establish every natural menu path, rendering
result or hardware behavior. The default Japanese target retains its original
hash and byte-comparison checks. See [text and graphics formats](TRANSLATION.md)
for editing constraints.
