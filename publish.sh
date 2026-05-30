#!/usr/bin/env bash
# jet-black PROD publish — package + publish the editor extensions.
#   jet-black-vscode  → VS Code Marketplace   (vsce, needs $VSCE_PAT)
#   jet-black-cursor  → Open VSX (Cursor)      (ovsx, needs $OVSX_PAT)
#
# Tokens come from the environment only — never commit them.
#   VSCE_PAT=…  OVSX_PAT=…  ./publish.sh [--dry-run]
#
# Requires Node tooling, run on demand via npx: @vscode/vsce and ovsx.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
ROOT="$PWD"
DRY=""; [ "${1:-}" = "--dry-run" ] && DRY=1

command -v npx >/dev/null || { echo "error: npx (Node) required for vsce/ovsx" >&2; exit 1; }
"$ROOT/build.sh" >/dev/null
echo "✓ built"

# VS Code Marketplace
echo "→ jet-black-vscode → VS Code Marketplace"
if [ -n "$DRY" ]; then
  ( cd jet-black-vscode && npx --yes @vscode/vsce package -o "$ROOT/jet-black-vscode.vsix" )
  echo "  dry-run: packaged jet-black-vscode.vsix (not published)"
elif [ -n "${VSCE_PAT:-}" ]; then
  ( cd jet-black-vscode && npx --yes @vscode/vsce publish -p "$VSCE_PAT" )
else
  echo "  skipped: set VSCE_PAT to publish (or run with --dry-run to just package)"
fi

# Open VSX (Cursor)
echo "→ jet-black-cursor → Open VSX"
if [ -n "$DRY" ]; then
  ( cd jet-black-cursor && npx --yes ovsx create-namespace rudra 2>/dev/null || true )
  echo "  dry-run: skipping ovsx publish"
elif [ -n "${OVSX_PAT:-}" ]; then
  ( cd jet-black-cursor && npx --yes ovsx publish -p "$OVSX_PAT" )
else
  echo "  skipped: set OVSX_PAT to publish"
fi
echo "✓ publish step done"
