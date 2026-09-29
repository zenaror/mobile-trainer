#!/usr/bin/env bash
# Idempotent, GUI-free setup of GhidraBoy (SM83 / Game Boy support) for Ghidra.
#
#   tools/ghidra/setup.sh            # fetch (if needed), build, install
#   tools/ghidra/setup.sh --force    # rebuild even if the stamp says it is current
#
# What it does (all inside .cache/, which is git-ignored):
#   1. git clone/fetch $GHIDRABOY_URL and check out the pinned $GHIDRABOY_COMMIT
#   2. compile data/languages/sm83.slaspec with the *installed* Ghidra's SleighCompile
#   3. javac the loader/analyzer sources (fi.gekkio.ghidraboy.*) against the installed
#      Ghidra jars (no gradle, no kotlin, no maven downloads: only the git fetch needs network)
#   4. assemble an extension directory and install it into the isolated Ghidra user dir
#      .cache/ghidra-user/<user>-ghidra/ghidra_<ver>/Extensions/GhidraBoy  (NOT into the Ghidra install, NOT ~/.config)
#   5. write .cache/ghidra-setup.json with versions and sha256s of what was built
#
# Why not upstream's gradle build: it needs gradle 9 + Kotlin 2.2 + ktlint plugins from the
# network only to run unit tests / lint; the shipped artifact is just javac output + sleigh.
# The direct build installs the same class set, the same sm83.* language files (sm83.sla sha256 identical to the gradle
# build) but NOT upstream's ghidra_scripts/ directory (mgbdis sym import/export helpers); jar bytecode is not byte-identical
# to gradle's (different javac flags). See docs/research/ghidra.md.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"

FORCE=0; [ "${1:-}" = "--force" ] && FORCE=1
gh_check_install
[ -n "$JAVAC" ] && [ -n "$JAR" ] || gh_die "javac/jar not found: a JDK (not just a JRE) is required"
mkdir -p "$CACHE_DIR"

# ---- 1. source -------------------------------------------------------------
if [ ! -d "$GHIDRABOY_SRC/.git" ]; then
    git clone --quiet "$GHIDRABOY_URL" "$GHIDRABOY_SRC"
fi
if ! git -C "$GHIDRABOY_SRC" cat-file -e "$GHIDRABOY_COMMIT^{commit}" 2>/dev/null; then
    git -C "$GHIDRABOY_SRC" fetch --quiet origin
fi
git -C "$GHIDRABOY_SRC" checkout --quiet --detach "$GHIDRABOY_COMMIT"
HEAD_SHA="$(git -C "$GHIDRABOY_SRC" rev-parse HEAD)"
[ "$HEAD_SHA" = "$GHIDRABOY_COMMIT" ] || gh_die "checkout mismatch: $HEAD_SHA != $GHIDRABOY_COMMIT"
TREE_SHA256="$(git -C "$GHIDRABOY_SRC" archive --format=tar HEAD | sha256sum | cut -d' ' -f1)"

STAMP="$CACHE_DIR/ghidra-setup.json"
JAVA_VER="$("$JAVA" -version 2>&1 | head -1 | tr -d '"')"
WANT="$GHIDRABOY_COMMIT|$GHIDRA_VERSION|$JAVA_VER"
if [ "$FORCE" = 0 ] && [ -f "$STAMP" ] && grep -qF "\"stamp_key\": \"$WANT\"" "$STAMP" \
   && [ -f "$GHIDRA_EXT_DIR/data/languages/sm83.sla" ]; then
    echo "GhidraBoy $GHIDRABOY_COMMIT already built for Ghidra $GHIDRA_VERSION (use --force to rebuild)"
    exit 0
fi

# ---- 2. sleigh --------------------------------------------------------------
rm -rf "$GHIDRABOY_BUILD"; mkdir -p "$GHIDRABOY_BUILD/classes"
cp -r "$GHIDRABOY_SRC/data" "$GHIDRABOY_BUILD/data"
echo "[sleigh] compiling sm83.slaspec"
# Flags copied from upstream build.gradle.kts (compileSleigh).
ghidra_launch ghidra.pcodeCPort.slgh_compile.SleighCompileLauncher \
    -u -l -n -t -e -c -f "$GHIDRABOY_BUILD/data/languages/sm83.slaspec" 2>&1 | grep -v "^\[.*cds\]" || true
[ -f "$GHIDRABOY_BUILD/data/languages/sm83.sla" ] || gh_die "sleigh compilation failed"

# ---- 3. java ----------------------------------------------------------------
echo "[javac] compiling loader + analyzer against Ghidra $GHIDRA_VERSION"
GCP="$(find "$GHIDRA_INSTALL_DIR/Ghidra/Framework" "$GHIDRA_INSTALL_DIR/Ghidra/Features" -name '*.jar' | tr '\n' ':')"
"$JAVAC" --release 17 -nowarn -cp "$GCP" -d "$GHIDRABOY_BUILD/classes" \
    "$GHIDRABOY_SRC"/src/main/java/fi/gekkio/ghidraboy/*.java
"$JAR" --create --file "$GHIDRABOY_BUILD/GhidraBoy.jar" --date 2000-01-01T00:00:00Z -C "$GHIDRABOY_BUILD/classes" .

# ---- 4. install into the isolated user dir ---------------------------------
EXT="$GHIDRA_EXT_DIR"
rm -rf "$EXT"; mkdir -p "$EXT/lib" "$EXT/data/languages"
cp "$GHIDRABOY_BUILD/GhidraBoy.jar" "$EXT/lib/GhidraBoy.jar"
cp "$GHIDRABOY_BUILD"/data/languages/sm83.{sla,slaspec,ldefs,pspec,cspec,sinc} \
   "$GHIDRABOY_BUILD"/data/languages/sm83_instructions.sinc "$EXT/data/languages/"
cp "$GHIDRABOY_SRC/data/sleighArgs.txt" "$EXT/data/"
cp "$GHIDRABOY_SRC/Module.manifest" "$GHIDRABOY_SRC/LICENSE" "$GHIDRABOY_SRC/README.markdown" "$EXT/"
cat > "$EXT/extension.properties" <<PROPS
name=GhidraBoy
description=Support for Sharp SM83 / Game Boy (project-local build, pinned commit $GHIDRABOY_COMMIT)
author=Gekkio (fork: kabili207)
createdOn=$(date +%Y-%m-%d)
version=$GHIDRA_VERSION
PROPS

# ---- 5. record ---------------------------------------------------------------
sha() { sha256sum "$1" | cut -d' ' -f1; }
cat > "$STAMP" <<JSON
{
  "stamp_key": "$WANT",
  "ghidraboy_url": "$GHIDRABOY_URL",
  "ghidraboy_commit": "$GHIDRABOY_COMMIT",
  "ghidraboy_tree_tar_sha256": "$TREE_SHA256",
  "ghidra_install_dir": "$GHIDRA_INSTALL_DIR",
  "ghidra_version": "$GHIDRA_VERSION",
  "ghidra_revision": "$(sed -n 's/^application.revision.ghidra=//p' "$GHIDRA_INSTALL_DIR/Ghidra/application.properties")",
  "java": "$JAVA_VER",
  "sm83_sla_sha256": "$(sha "$EXT/data/languages/sm83.sla")",
  "sm83_slaspec_sha256": "$(sha "$EXT/data/languages/sm83.slaspec")",
  "sm83_instructions_sinc_sha256": "$(sha "$EXT/data/languages/sm83_instructions.sinc")",
  "ghidraboy_jar_sha256": "$(sha "$EXT/lib/GhidraBoy.jar")",
  "extension_dir": "$EXT"
}
JSON
echo "installed: $EXT"
cat "$STAMP"
