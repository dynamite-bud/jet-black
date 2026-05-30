-- Jet Black — SketchyBar colors (0xAARRGGBB)
-- Scheme author: rudra (derived from Pitch Black by Viktor Qvarfordt)
-- Drop-in replacement for colors.lua. NOTE: this is an OPAQUE jet-black bar —
-- it replaces a translucent/liquid-glass design if you have one.
local colors = {}

colors.white       = 0xffffffff
colors.transparent = 0x00000000
colors.red         = 0xffff6360
colors.orange      = 0xffff8c1f
colors.charging    = 0xffffe14d

colors.bar_color         = 0xff000000
colors.accent_color      = 0xff50b4ff
colors.secondary_accent  = 0xff25e6df
colors.disabled_color    = 0xff808080
colors.background        = 0xff1a1a1a
colors.background_border = 0xff2a2a2a
colors.popup_background  = 0xee000000
colors.popup_border      = 0xff666666

return colors
