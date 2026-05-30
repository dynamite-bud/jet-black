# Jet Black — Catppuccin-compatible @thm_* palette
# Scheme author: rudra (derived from Pitch Black by Viktor Qvarfordt)
#
# For tmux status bars built on catppuccin/tmux variable names. Source this
# AFTER catppuccin loads to override its palette with jet-black (uses `set -g`,
# not catppuccin's only-if-unset `-ogq`, so it wins). See jet-black wiring.

set -g @thm_bg "#000000"
set -g @thm_fg "#d4d4d4"
set -g @thm_red "#ff6360"
set -g @thm_maroon "#ff6360"
# UI fills (active window bg, last-window fg) use a DEEPER orange than the neon
# syntax orange (base09 #ff8c1f) — a bright fill glares on pure black.
set -g @thm_peach "#d9731f"
set -g @thm_orange "#d9731f"
set -g @thm_yellow "#ffe14d"
set -g @thm_green "#aef33f"
set -g @thm_teal "#25e6df"
set -g @thm_sky "#25e6df"
set -g @thm_blue "#50b4ff"
set -g @thm_sapphire "#50b4ff"
set -g @thm_lavender "#50b4ff"
set -g @thm_mauve "#c77dff"
set -g @thm_pink "#c77dff"
set -g @thm_flamingo "#ff6360"
set -g @thm_rosewater "#e8e8e8"
# Surfaces / overlays (mono ramp)
set -g @thm_surface_0 "#2a2a2a"
set -g @thm_surface_1 "#666666"
set -g @thm_surface_2 "#808080"
set -g @thm_overlay_0 "#666666"
set -g @thm_overlay_1 "#808080"
set -g @thm_overlay_2 "#808080"
