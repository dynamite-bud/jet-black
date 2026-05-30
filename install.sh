#!/usr/bin/env bash
# jet-black PROD install — place the built theme files where each tool finds
# them, then print the (manual) one-liners to activate them.
#
# Conservative by design: it copies theme files and symlinks the editor
# extensions, but does NOT edit your ghostty/tmux/starship configs — it prints
# exactly what to add so you stay in control of your dotfiles.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
ROOT="$PWD"
"$ROOT/build.sh" >/dev/null
echo "✓ built — installing…"
echo

# ── ghostty ──────────────────────────────────────────────────────────────
GHOSTTY_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes"
mkdir -p "$GHOSTTY_THEMES"
cp "$ROOT/jet-black-ghostty/jet-black.conf" "$GHOSTTY_THEMES/jet-black"
echo "ghostty   → installed $GHOSTTY_THEMES/jet-black"
echo "            add to your ghostty config:  theme = jet-black"
echo

# ── tmux ─────────────────────────────────────────────────────────────────
TMUX_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
mkdir -p "$TMUX_DIR"
cp "$ROOT/jet-black-tmux/jet-black.tmux" "$TMUX_DIR/jet-black.tmux"
echo "tmux      → installed $TMUX_DIR/jet-black.tmux"
echo "            add to your .tmux.conf:  source-file $TMUX_DIR/jet-black.tmux"
echo

# ── starship ───────────────────────────────────────────────────────────────
STAR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
cp "$ROOT/jet-black-starship/jet-black.toml" "$STAR_DIR/starship-jet-black.toml"
echo "starship  → installed $STAR_DIR/starship-jet-black.toml"
echo "            use it:  export STARSHIP_CONFIG=$STAR_DIR/starship-jet-black.toml"
echo "            or copy the [palettes.jet-black] block into your starship.toml"
echo

# ── editors (symlink the extensions) ───────────────────────────────────────
for pair in "vscode $HOME/.vscode/extensions" "cursor $HOME/.cursor/extensions"; do
  set -- $pair
  [ -d "$2" ] || { echo "$1     → skipped ($2 not found)"; continue; }
  ln -sfn "$ROOT/jet-black-$1" "$2/rudra.jet-black-theme-0.1.0"
  echo "$1     → linked into $2 (restart editor, pick 'Jet Black')"
done
echo
# Make the editors auto-switch with the OS: dark = Jet Black, light = GitHub Light Default.
echo "editors   → enabling OS auto-switch (dark=Jet Black, light=GitHub Light Default)"
python3 "$ROOT/dev/setup-editor-autoswitch.py"
echo

# ── atuin ──────────────────────────────────────────────────────────────────
ATUIN_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/atuin/themes"
if [ -d "$(dirname "$ATUIN_THEMES")" ]; then
  mkdir -p "$ATUIN_THEMES"
  cp "$ROOT/jet-black-atuin/jet-black.toml" "$ATUIN_THEMES/jet-black.toml"
  echo "atuin     → installed $ATUIN_THEMES/jet-black.toml"
  echo "            add to config.toml:  [theme]\\n            name = \"jet-black\""
  echo
fi

# ── sketchybar (opt-in) ──────────────────────────────────────────────────────
echo "sketchybar→ jet-black-sketchybar/colors.lua is an OPAQUE black palette."
echo "            opt in by replacing your sketchybar colors.lua with it (or"
echo "            sourcing it in your dark branch). Skipped by default."
echo
echo "✓ install complete. To PUBLISH the editor extensions, run ./publish.sh"
