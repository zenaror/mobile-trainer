#!/bin/sh
# Build tools/trace/apu_probe.c against the mGBA fork that tools/trace/run_trace.py builds under .cache/trace/mgba (run it once first).
# Usage: tools/trace/build_apu_probe.sh [OUT]   (default OUT = $PWD/apu_probe)
# MGBA_SRC: the mGBA fork source tree (same default as run_trace.py); MGBA_BUILD: its build tree (default: <repo>/.cache/trace/mgba).
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MGBA_SRC="${MGBA_SRC:-/media/rafael/Dados/Arquivos/Projetos/Gameboy Projects/MobileAdapterGB/mgba/mgba}"
B="${MGBA_BUILD:-$ROOT/.cache/trace/mgba}"
OUT="${1:-$PWD/apu_probe}"
SRC="$ROOT/tools/trace/apu_probe.c"
DEFS=$(sed -n 's/^C_DEFINES = //p' "$B/CMakeFiles/mgba.dir/flags.make" | sed 's/-DMGBA_DLL//; s/-Dmgba_EXPORTS//')
# shellcheck disable=SC2086
gcc -O2 -fwrapv -Wall -Wno-unused-function $DEFS -o "$OUT" "$SRC" \
    -I"$MGBA_SRC/include" -I"$B/include" -I"$MGBA_SRC/src/third-party/libmobile" -I"$B/libmobile" \
    -L"$B" -lmgba -Wl,-rpath,"$B"
echo "built $OUT"
