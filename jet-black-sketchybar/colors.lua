-- Jet Black — SketchyBar colors (0xAARRGGBB)
-- Scheme author: rudra (derived from Pitch Black by Viktor Qvarfordt)
-- Drop-in replacement for colors.lua. NOTE: this is an OPAQUE jet-black bar —
-- it replaces a translucent/liquid-glass design if you have one.
local colors = {}

colors.white       = 0xffffffff
colors.transparent = 0x00000000
colors.red         = 0xffff827a
colors.orange      = 0xffff9652
colors.charging    = 0xffd0c590

colors.bar_color         = 0xff000000
colors.accent_color      = 0xff70b7f6
colors.secondary_accent  = 0xff64c1b0
colors.disabled_color    = 0xff808080
colors.background        = 0xff1a1a1a
colors.background_border = 0xff2a2a2a
colors.popup_background  = 0xee000000
colors.popup_border      = 0xff666666

return colors
