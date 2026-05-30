#!/usr/bin/env bash
# Preview the jet-black palette in the terminal.
#   1. True-color (24-bit) swatches read straight from the scheme — shows the
#      REAL colors no matter what the current terminal theme is.
#   2. The 16 ANSI blocks — shows how your CURRENT terminal renders 0-15
#      (run this inside a jet-black-themed terminal to verify the mapping).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
SCHEME="schemes/jet-black.yaml"

hex() { grep -E "^\s*$1:" "$SCHEME" | sed -E 's/.*"([0-9a-fA-F]{6})".*/\1/'; }
swatch() { # <hex> <label>
  local r=$((16#${1:0:2})) g=$((16#${1:2:2})) b=$((16#${1:4:2}))
  printf "\033[48;2;%d;%d;%dm      \033[0m \033[38;2;%d;%d;%dm%-13s #%s\033[0m\n" \
    "$r" "$g" "$b" "$r" "$g" "$b" "$2" "$1"
}

echo
echo "  jet-black — true-color swatches (real palette)"
echo "  ───────────────────────────────────────────────"
swatch "$(hex base00)" "bg";        swatch "$(hex base05)" "fg"
for pair in "base08 red" "base09 orange" "base0A yellow" "base0B green" \
            "base0C cyan" "base0D blue" "base0E magenta" "base0F gold"; do
  set -- $pair; swatch "$(hex $1)" "$2"
done
for pair in "base12 br-red" "base13 br-yellow" "base14 br-green" \
            "base15 br-cyan" "base16 br-blue" "base17 br-magenta"; do
  set -- $pair; swatch "$(hex $1)" "$2"
done

echo
echo "  current terminal's ANSI 0-15 (verify inside a jet-black terminal)"
echo "  ───────────────────────────────────────────────"
printf "  "; for i in $(seq 0 7);  do printf "\033[4${i}m   \033[0m"; done; echo "  (0-7 normal)"
printf "  "; for i in $(seq 0 7);  do printf "\033[10${i}m   \033[0m"; done; echo "  (8-15 bright)"
echo
