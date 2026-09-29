#!/usr/bin/env bash
# Shared environment for the project-local Ghidra pipeline (sourced, not executed).
#
# Nothing here touches ~/.config/ghidra: Ghidra is started by invoking the JVM
# directly (same command line that support/launch.sh builds) with
#   -Dapplication.settingsdir / cachedir / tempdir
# pointing into .cache/ghidra-user, so extensions, preferences, logs and the
# compiled-script (OSGi) cache are all project-local and git-ignored.
#
# Overridable environment variables:
#   GHIDRA_INSTALL_DIR  Ghidra installation (default: the Open-GBP copy below)
#   GHIDRA_MAXMEM       JVM heap for Ghidra (default 4G)
#   JAVA_HOME           JDK to use (default: `java` from PATH; Ghidra 12 needs 21+)

_gh_here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$_gh_here/../.." && pwd)"
GHIDRA_TOOLS="$_gh_here"

GHIDRA_INSTALL_DIR="${GHIDRA_INSTALL_DIR:-/home/rafael/Tools/Open-GBP/ghidra_12.1.3_PUBLIC}"
GHIDRA_MAXMEM="${GHIDRA_MAXMEM:-4G}"

CACHE_DIR="$REPO_ROOT/.cache"
GHIDRABOY_SRC="$CACHE_DIR/GhidraBoy"                # git checkout of the extension source
GHIDRABOY_BUILD="$CACHE_DIR/ghidraboy-build"        # scratch build dir
GHIDRA_USER_DIR="$CACHE_DIR/ghidra-user"            # isolated -Dapplication.settingsdir
GHIDRA_USER_CACHE="$CACHE_DIR/ghidra-user-cache"    # isolated -Dapplication.cachedir
GHIDRA_USER_TMP="$CACHE_DIR/ghidra-user-tmp"        # isolated -Dapplication.tempdir
GHIDRA_PROJECT_DIR="$GHIDRA_TOOLS/project"          # git-ignored
GHIDRA_PROJECT_NAME="MobileTrainer"
GHIDRA_LANG_ID="SM83:LE:16:default"
ROM="$REPO_ROOT/baserom.gbc"

# Pinned GhidraBoy revision (fork of Gekkio/GhidraBoy with the bank-switch analyzer).
GHIDRABOY_URL="${GHIDRABOY_URL:-https://github.com/kabili207/GhidraBoy.git}"
GHIDRABOY_COMMIT="${GHIDRABOY_COMMIT:-cc9f5652c57f9c429a0d961a34fa836e98e20d7d}"

if [ -n "${JAVA_HOME:-}" ] && [ -x "$JAVA_HOME/bin/java" ]; then
    JAVA="$JAVA_HOME/bin/java"; JAVAC="$JAVA_HOME/bin/javac"; JAR="$JAVA_HOME/bin/jar"
else
    JAVA="$(command -v java || true)"; JAVAC="$(command -v javac || true)"; JAR="$(command -v jar || true)"
fi

gh_die() { echo "ERROR: $*" >&2; exit 1; }

gh_check_install() {
    [ -f "$GHIDRA_INSTALL_DIR/Ghidra/application.properties" ] \
        || gh_die "GHIDRA_INSTALL_DIR='$GHIDRA_INSTALL_DIR' is not a Ghidra installation"
    [ -n "$JAVA" ] || gh_die "java not found (need JDK 21+)"
    local props="$GHIDRA_INSTALL_DIR/Ghidra/application.properties"
    GHIDRA_VERSION="$(sed -n 's/^application.version=//p' "$props")"
    GHIDRA_RELEASE="$(sed -n 's/^application.release.name=//p' "$props")"
    # With -Dapplication.settingsdir=X Ghidra really uses X/<user>-ghidra/ghidra_<ver>_<rel>
    # (ApplicationUtilities.getDefaultUserSettingsDir; the "<user>-" prefix is added because X is
    # outside $HOME). Extensions are discovered in <that dir>/Extensions.
    GHIDRA_SETTINGS_DIR="$GHIDRA_USER_DIR/$(id -un)-ghidra/ghidra_${GHIDRA_VERSION}_${GHIDRA_RELEASE}"
    GHIDRA_EXT_DIR="$GHIDRA_SETTINGS_DIR/Extensions/GhidraBoy"
}

# ghidra_launch <main-class> [args...]  -- run any Ghidra main class in the isolated user dir.
ghidra_launch() {
    gh_check_install
    mkdir -p "$GHIDRA_USER_DIR" "$GHIDRA_USER_CACHE" "$GHIDRA_USER_TMP"
    "$JAVA" \
        -Djava.system.class.loader=ghidra.GhidraClassLoader \
        -Dfile.encoding=UTF8 -Duser.country=US -Duser.language=en -Duser.variant= \
        -Djava.awt.headless=true -Xshare:off -XX:+IgnoreUnrecognizedVMOptions \
        -Xmx"$GHIDRA_MAXMEM" \
        -Dapplication.settingsdir="$GHIDRA_USER_DIR" \
        -Dapplication.cachedir="$GHIDRA_USER_CACHE" \
        -Dapplication.tempdir="$GHIDRA_USER_TMP" \
        -cp "$GHIDRA_INSTALL_DIR/Ghidra/Framework/Utility/lib/Utility.jar" \
        ghidra.Ghidra "$@"
}

# ghidra_headless [analyzeHeadless args...]
ghidra_headless() { ghidra_launch ghidra.app.util.headless.AnalyzeHeadless "$@"; }

gh_require_setup() {
    gh_check_install
    [ -f "$GHIDRA_EXT_DIR/data/languages/sm83.sla" ] \
        || gh_die "GhidraBoy is not installed; run tools/ghidra/setup.sh first"
}
