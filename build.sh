#!/usr/bin/env bash
# Render schemes/jet-black.yaml into every per-tool publishable folder.
#
# Requires: tinted-builder-rust  (brew install tinted-theming/tinted/tinted-builder-rust)
#
# Each tinted template repo under templates/ is built against our scheme, then
# the single jet-black output is copied into its jet-black-<tool>/ folder.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
ROOT="$PWD"
SCHEMES="$ROOT/schemes"
SLUG="base24-jet-black"

command -v tinted-builder-rust >/dev/null || {
  echo "error: tinted-builder-rust not found (brew install tinted-theming/tinted/tinted-builder-rust)" >&2
  exit 1
}

build_template() { # <template-dir>
  tinted-builder-rust build "$1" --schemes-dir "$SCHEMES" --quiet 2>&1 \
    | grep -iE "error|fail" >&2 || true
}

echo "→ validating palette"
python3 dev/validate-contrast.py >/dev/null || {
  echo "error: palette fails contrast validation (see: python3 dev/validate-contrast.py)" >&2
  exit 1
}

echo "→ ghostty"
build_template templates/tinted-terminal
cp "templates/tinted-terminal/themes/ghostty/$SLUG" jet-black-ghostty/jet-black.conf

echo "→ tmux"
build_template templates/tinted-tmux
cp "templates/tinted-tmux/colors/$SLUG.conf" jet-black-tmux/jet-black.tmux

echo "→ vscode + cursor"
build_template templates/tinted-vscode
for ed in vscode cursor; do
  dest="jet-black-$ed/themes/jet-black-color-theme.json"
  cp "templates/tinted-vscode/themes/base24/$SLUG.json" "$dest"
  # Clean the display name in the generated JSON: "Base24 Jet Black" -> "Jet Black"
  python3 -c "import json,sys; p=sys.argv[1]; d=json.load(open(p)); d['name']='Jet Black'; json.dump(d, open(p,'w'), indent=2)" "$dest"
done

echo "→ starship"
if [ -f templates/starship/templates/config.yaml ]; then
  build_template templates/starship
  cp "templates/starship/themes/$SLUG.toml" jet-black-starship/jet-black.toml
else
  echo "  (skipped: templates/starship not set up yet)"
fi

echo "✓ build complete — see jet-black-*/ folders"
