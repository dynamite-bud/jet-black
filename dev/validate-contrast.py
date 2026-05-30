#!/usr/bin/env python3
"""Validate a jet-black base24 scheme for legibility on its own background.

Reports, for every accent slot vs base00:
  - WCAG 2.1 contrast ratio (target >= 4.5:1 for body text)
  - APCA Lc  (target |Lc| >= 60 usable, >= 75 comfortable on dark bg)

Usage: python3 dev/validate-contrast.py [schemes/jet-black.yaml]
"""
import re
import sys

SCHEME = sys.argv[1] if len(sys.argv) > 1 else "schemes/jet-black.yaml"


def parse_palette(path):
    pal = {}
    in_pal = False
    for line in open(path):
        if re.match(r"^\s*palette:\s*$", line):
            in_pal = True
            continue
        if in_pal:
            m = re.match(r'\s*(base[0-9A-Fa-f]{2})\s*:\s*"?([0-9A-Fa-f]{6})"?', line)
            if m:
                pal[m.group(1).lower()] = m.group(2).lower()
    return pal


def rgb(h):
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def wcag_ratio(fg, bg):
    def lin(c):
        c /= 255.0
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4

    def lum(c):
        r, g, b = (lin(x) for x in c)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b

    l1, l2 = lum(fg), lum(bg)
    hi, lo = max(l1, l2), min(l1, l2)
    return (hi + 0.05) / (lo + 0.05)


def apca_lc(txt, bg):
    """APCA-W3 (0.1.x). Returns signed Lc; negative => light text on dark bg."""
    def Y(c):
        r, g, b = ((x / 255.0) ** 2.4 for x in c)
        return 0.2126729 * r + 0.7151522 * g + 0.0721750 * b

    yt, yb = Y(txt), Y(bg)
    blk_thrs, blk_clmp = 0.022, 1.414
    if yt < blk_thrs:
        yt += (blk_thrs - yt) ** blk_clmp
    if yb < blk_thrs:
        yb += (blk_thrs - yb) ** blk_clmp
    if abs(yb - yt) < 0.0005:
        return 0.0
    if yb > yt:  # normal polarity: dark text on light bg
        sapc = (yb ** 0.56 - yt ** 0.57) * 1.14
        return 0.0 if sapc < 0.1 else (sapc - 0.027) * 100
    else:        # reverse polarity: light text on dark bg (our case)
        sapc = (yb ** 0.65 - yt ** 0.62) * 1.14
        return 0.0 if sapc > -0.1 else (sapc + 0.027) * 100


# base24 semantics (base10/base11 are backgrounds, not text — not checked).
ROLES = {
    "base05": "fg/body", "base08": "red", "base09": "orange", "base0a": "yellow",
    "base0b": "green", "base0c": "cyan", "base0d": "blue", "base0e": "magenta",
    "base0f": "gold", "base12": "br-red", "base13": "br-yellow", "base14": "br-green",
    "base15": "br-cyan", "base16": "br-blue", "base17": "br-magenta",
}

pal = parse_palette(SCHEME)
bg = rgb(pal["base00"])
print(f"Scheme: {SCHEME}   background base00 = #{pal['base00']}\n")
print(f"{'slot':7} {'role':11} {'hex':8} {'WCAG':>6} {'AA?':4} {'APCA Lc':>8} {'ok?':4}")
print("-" * 52)
fails = 0
for slot, role in ROLES.items():
    if slot not in pal:
        continue
    c = rgb(pal[slot])
    w = wcag_ratio(c, bg)
    lc = abs(apca_lc(c, bg))
    aa = "PASS" if w >= 4.5 else "FAIL"
    # Vivid-neon tiers on pure black: >=60 comfortable, 50-60 vivid, 45-50 bold,
    # <45 genuinely unreadable (fail). Saturated red/pink can't beat ~50 on #000.
    if lc >= 60:
        ok = "ok"
    elif lc >= 50:
        ok = "vivid"
    elif lc >= 45:
        ok = "bold"
    else:
        ok = "LOW"
    if w < 4.5 or lc < 45:
        fails += 1
    print(f"{slot:7} {role:11} #{pal[slot]:7} {w:5.2f}:1 {aa:4} {lc:8.1f} {ok:5}")
print("-" * 52)
print(f"{fails} slot(s) genuinely unreadable (WCAG < 4.5:1 / APCA Lc < 45)." if fails
      else "All accents pass (WCAG >= 4.5:1, APCA Lc >= 45). vivid=50-60, bold=45-50.")
sys.exit(1 if fails else 0)
