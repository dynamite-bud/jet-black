# Base24 Jet Black
# Scheme author: rudra (derived from Pitch Black by Viktor Qvarfordt)
# Template author: Tinted Theming: (https://github.com/tinted-theming)

# default statusbar colors
set-option -g status-style "fg=#808080,bg=#1a1a1a"

# default window title colors
set-window-option -g window-status-style "fg=#808080,bg=#1a1a1a"

# active window title colors
set-window-option -g window-status-current-style "fg=#fff04d,bg=#1a1a1a"

# pane border
set-option -g pane-border-style "fg=#1a1a1a"
set-option -g pane-active-border-style "fg=#808080"

# message text
set-option -g message-style "fg=#e8e8e8,bg=#2a2a2a"

# pane number display
set-option -g display-panes-active-colour "#808080"
set-option -g display-panes-colour "#1a1a1a"

# clock
set-window-option -g clock-mode-colour "#50b4ff"

# copy mode highlight
set-window-option -g mode-style "fg=#808080,bg=#2a2a2a"

# bell
set-window-option -g window-status-bell-style "fg=#000000,bg=#ff6360"

# style for window titles with activity
set-window-option -g window-status-activity-style "fg=#d4d4d4,bg=#1a1a1a"

# style for command messages
set-option -g message-command-style "fg=#e8e8e8,bg=#2a2a2a"

# Optional active/inactive pane state
if-shell '[ "$TINTED_TMUX_OPTION_ACTIVE" = "1" ]' {
  set-window-option -g window-active-style "fg=#d4d4d4,bg=#000000"
  set-window-option -g window-style "fg=#d4d4d4,bg=#1a1a1a"
}

# Optional statusbar
if-shell '[ "$TINTED_TMUX_OPTION_STATUSBAR" = "1" ]' {
  set-option -g status "on"
  set-option -g status-justify "left"
  set-option -g status-left "#[fg=#d4d4d4,bg=#666666] #S #[fg=#666666,bg=#1a1a1a,nobold,noitalics,nounderscore]"
  set-option -g status-left-length "80"
  set-option -g status-left-style none
  set-option -g status-right "#[fg=#2a2a2a,bg=#1a1a1a nobold, nounderscore, noitalics]#[fg=#808080,bg=#2a2a2a] %Y-%m-%d  %H:%M #[fg=#d4d4d4,bg=#2a2a2a,nobold,noitalics,nounderscore]#[fg=#1a1a1a,bg=#d4d4d4] #h "
  set-option -g status-right-length "80"
  set-option -g status-right-style none
  set-window-option -g window-status-current-format "#[fg=#1a1a1a,bg=#ffe14d,nobold,noitalics,nounderscore]#[fg=#2a2a2a,bg=#ffe14d] #I #[fg=#2a2a2a,bg=#ffe14d,bold] #W#{?window_zoomed_flag,*Z,}} #[fg=#ffe14d,bg=#1a1a1a,nobold,noitalics,nounderscore]"
  set-window-option -g window-status-format "#[fg=#1a1a1a,bg=#2a2a2a,noitalics]#[fg=#e8e8e8,bg=#2a2a2a] #I #[fg=#e8e8e8,bg=#2a2a2a] #W#{?window_zoomed_flag,*Z,}} #[fg=#2a2a2a,bg=#1a1a1a,noitalics]"
  set-window-option -g window-status-separator ""
}

# vim: set ft=tmux tw=0:
