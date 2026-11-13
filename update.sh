#!/usr/bin/env bash
# Update this repository, the pinned darsia submodule and the Python environment.
#
# Usage:
#   ./update.sh            # users: get the darsia version this repository pins
#   ./update.sh --latest   # maintainers: move darsia to its newest upstream commit

set -euo pipefail
cd "$(dirname "$0")"

fail() {
    echo
    echo "ERROR: $1" >&2
    exit 1
}

for tool in git uv; do
    command -v "$tool" >/dev/null 2>&1 \
        || fail "'$tool' was not found. See the Prerequisites section of README.md."
done

echo "==> Fetching the latest version of this repository..."
git pull || fail "'git pull' failed. If you have local changes, commit or stash them and run this script again."

if [ "${1:-}" = "--latest" ]; then
    echo "==> Moving darsia to the newest upstream commit..."
    git submodule update --init --remote external/darsia || fail "Updating the darsia submodule failed."
else
    echo "==> Checking out the darsia version pinned by this repository..."
    git submodule update --init --recursive || fail "Updating the darsia submodule failed."
fi

echo "==> Updating the Python environment (uv sync)..."
uv sync || fail "'uv sync' failed."

echo
echo "Done. darsia version in use: $(git -C external/darsia describe --tags --always)"
echo "Start the GUI with:  uv run darsia"

if [ "${1:-}" = "--latest" ]; then
    echo
    echo "To make this darsia version the new default for everyone, run:"
    echo "  git add external/darsia uv.lock"
    echo "  git commit -m \"Update darsia submodule\""
    echo "  git push"
fi
