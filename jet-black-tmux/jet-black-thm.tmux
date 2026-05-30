# Jet Black — Catppuccin-compatible @thm_* palette
# Scheme author: Rudra
#
# For tmux status bars built on catppuccin/tmux variable names. Source this
# AFTER catppuccin loads to override its palette with jet-black (uses `set -g`,
# not catppuccin's only-if-unset `-ogq`, so it wins). See jet-black wiring.

set -g @thm_bg "#000000"
set -g @thm_fg "#d4d4d4"
set -g @thm_red "#ff6360"
set -g @thm_maroon "#ff6360"
set -g @thm_peach "#ff8c1f"
set -g @thm_orange "#ff8c1f"
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

# Window status (dark-only): keep the active window's orange fill (it uses
# @thm_peach, the deeper UI orange above — left untouched). Only the last-active
# window changes: neutral grey + bold, so there's a single orange element, not
# two. Sourced AFTER .tmux.conf's window status so this wins.
set -g window-status-last-style "bg=default,fg=#808080,bold"
