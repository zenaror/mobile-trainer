#!/bin/sh
# Reproduces every measurement of docs/research/audio2_verify_dynamic.md (adversarial dynamic verification of the sound driver, bank 04, on mGBA).
# usage: analysis/audio2_verify_dyn/reproduce.sh [WORKDIR]      (about 3 minutes on 16 cores; WORKDIR default /tmp/audio2_verify_work)
# needs: `make` done in this tree (build/mobile_trainer.sym), the pre-built mGBA fork (see tools/trace/build_apu_probe.sh for REAL_REPO / MGBA_SRC), python3 (no numpy).
# the original ROM file is only read; synthetic ROMs are written under WORKDIR.
set -e
HERE=$(cd "$(dirname "$0")/../.." && pwd)
cd "$HERE"
W="${1:-/tmp/audio2_verify_work}"
mkdir -p "$W"
OUT="$HERE/analysis/audio2_verify_dyn"
T="$HERE/tools/trace"
"$T/build_apu_probe.sh" "$W/apu_probe"
PROBE="$W/apu_probe"
export APU_PROBE="$PROBE"
run() { name=$1; shift; echo "== $name"; "$@" > "$OUT/$name.txt" 2>&1 || { echo "FAILED: $name"; tail -n 5 "$OUT/$name.txt"; return 1; }; tail -n 2 "$OUT/$name.txt" | cut -c1-200; }
# static (independent parser of the macro source, labels, ROM bytes)
run static_macros   python3 "$T/audio2_macros.py"
run static_stats    python3 "$T/audio2_stats.py"
run static_labels   python3 "$T/audio2_labels.py"
# the 59 headers on the emulator (events of every run: W C N G E J T and Q P V B A S)
python3 "$T/audio2_run_songs.py" "$PROBE" "$W/songs" --q PVBAS --romread-dir "$W/rd" > /dev/null
run v11_commands    python3 "$T/audio2_v11.py" "$W/songs" --summary "$OUT/v11_summary.tsv"
run v11_headers     python3 "$T/audio2_v11_headers.py" "$W/songs" "$W/rd"
run v11_rwatch      python3 "$T/audio2_rwatch.py" "$PROBE" "$W/rw"
run v12_pitch       python3 "$T/audio2_v12_pitch.py" "$W/songs"
run v12_params      python3 "$T/audio2_v12_params.py" "$W/songs"
run v12_pitchfields python3 "$T/audio2_v12_pitchfields.py" "$W/songs"
run v12_timing      python3 "$T/audio2_v12_timing.py" "$W/songs"
run v12_env_real    python3 "$T/audio2_v12_env_real.py" "$W/songs"
run v12_be          python3 "$T/audio2_v12_be.py" "$W/songs"
run v12_pernote     python3 "$T/audio2_v12_pernote.py" "$W/songs" "$W/s_pernote"
# synthetic ROMs (private copies of the ROM, written under WORKDIR)
run v12_env_grid    python3 "$T/audio2_v12_env_sweep.py" "$W/s_env_full"
run v12_env_random  python3 "$T/audio2_v12_env_sweep.py" "$W/s_env_ext" --ext
run v12_env_noise   python3 "$T/audio2_v12_env_sweep.py" "$W/s_env_noise" --ext --class noise
run v12_mirror      python3 "$T/audio2_v12_mirror.py" "$W/s_mirror"
run v12_volume      python3 "$T/audio2_v12_volume.py" "$W/s_vol"
run v12_bend        python3 "$T/audio2_v12_bend.py" "$W/s_bend"
run v12_vibrato     python3 "$T/audio2_v12_vibrato.py" "$W/s_vib"
run v12_clamp       python3 "$T/audio2_v12_clamp.py" "$W/s_clamp"
run v12_trackinit   python3 "$T/audio2_v12_trackinit.py" "$W/s_init"
run v12_freq        python3 "$T/audio2_v12_freq.py" "$W/s_freq"
run v12_phys        python3 "$T/audio2_v12_phys.py" "$W/s_phys"
run v13_pan_detune  python3 "$T/audio2_v13_pan_detune.py" "$W/s_v13a"
run v13_ext         python3 "$T/audio2_v13_ext.py" "$W/s_v13ext"
run v13_flow        python3 "$T/audio2_v13_flow.py" "$W/s_v13flow"
run v13_stack       python3 "$T/audio2_v13_stack.py" "$W/s_stack"
run v13_param       python3 "$T/audio2_v13_param.py" "$W/s_v13param"
run v13_len         python3 "$T/audio2_v13_len.py" "$W/s_len"
run v13_songrec     python3 "$T/audio2_v13_songrec.py" "$W/s_songrec"
run v13_ctrl        python3 "$T/audio2_v13_ctrl.py" "$W/s_ctrl"
run v14_wave_noise  python3 "$T/audio2_v14.py" "$W/s_v14" "$W/songs"
run v15_tail        python3 "$T/audio2_v15_tail.py" "$W/s_tail"
echo "done; outputs in $OUT"
