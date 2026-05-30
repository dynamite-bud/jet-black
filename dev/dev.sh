#!/usr/bin/env bash
# jet-black DEV harness — preview the theme in ISOLATION, without touching your
# real ~/dotfiles configs or system appearance.
#
#   ./dev/dev.sh            build + show palette swatches + usage
#   ./dev/dev.sh ansi       true-color + ANSI swatches
#   ./dev/dev.sh ghostty    open a ghostty window using the built theme
#   ./dev/dev.sh tmux       throwaway tmux server (socket: jetblack-dev)
#   ./dev/dev.sh starship   subshell with the jet-black starship prompt
#   ./dev/dev.sh editor     symlink the extension into ~/.cursor + ~/.vscode (DEV)
#   ./dev/dev.sh editor-off remove those DEV symlinks
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
ROOT="$PWD"
GEN="$ROOT/dev/.gen"; mkdir -p "$GEN"   # ephemeral generated configs (gitignored)

build() { "$ROOT/build.sh" >/dev/null && echo "✓ built"; }

case "${1:-help}" in
  ansi)
    build; bash dev/preview-ansi.sh ;;

  ghostty)
    build
    cat > "$GEN/ghostty-dev.conf" <<EOF
# Ephemeral jet-black DEV config — does not affect your main ghostty config.
theme = $ROOT/jet-black-ghostty/jet-black.conf
window-title-font-family =
EOF
    echo "→ opening ghostty with jet-black (close the window when done)"
    open -na Ghostty --args --config-file="$GEN/ghostty-dev.conf" 2>/dev/null \
      || ghostty --config-file="$GEN/ghostty-dev.conf" ;;

  tmux)
    build
    cat > "$GEN/tmux-dev.conf" <<EOF
source-file $ROOT/jet-black-tmux/jet-black.tmux
set -g status on
set -g status-right "jet-black DEV  %H:%M"
EOF
    echo "→ tmux DEV server (socket jetblack-dev). Detach: C-b d. Kill: ./dev/dev.sh tmux-off"
    tmux -L jetblack-dev -f "$GEN/tmux-dev.conf" new-session 2>/dev/null \
      || tmux -L jetblack-dev attach ;;
  tmux-off)
    tmux -L jetblack-dev kill-server 2>/dev/null && echo "✓ killed jetblack-dev" || echo "no dev server" ;;

  starship)
    build
    echo "→ subshell with jet-black starship prompt. Type 'exit' to leave."
    STARSHIP_CONFIG="$ROOT/jet-black-starship/jet-black.toml" exec "${SHELL:-/bin/zsh}" -i ;;

  editor)
    build
    for pair in "vscode $HOME/.vscode/extensions" "cursor $HOME/.cursor/extensions"; do
      set -- $pair
      [ -d "$2" ] || { echo "skip $1 ($2 not found)"; continue; }
      ln -sfn "$ROOT/jet-black-$1" "$2/jet-black-theme-dev"
      echo "✓ linked jet-black-$1 → $2/jet-black-theme-dev"
    done
    echo "Restart Cursor/VS Code, then: Command Palette → Color Theme → Jet Black" ;;
  editor-off)
    rm -f "$HOME/.vscode/extensions/jet-black-theme-dev" "$HOME/.cursor/extensions/jet-black-theme-dev"
    echo "✓ removed DEV editor symlinks (restart editor)" ;;

  *)
    build; bash dev/preview-ansi.sh
    sed -n '2,12p' "$ROOT/dev/dev.sh" | sed 's/^# \{0,1\}//' ;;
esac
