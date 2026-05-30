#!/usr/bin/env python3
"""OKLCH utilities + accent tuner for jet-black.

`tune` raises an accent's OKLCH lightness (hue fixed, chroma clamped to sRGB
gamut) until it meets a target APCA Lc on a given background — the principled
way to make saturated reds/magentas legible on pure black without changing hue.

Usage:
  python3 dev/oklch.py tune <hex> [targetLc=60] [bg=000000]
  python3 dev/oklch.py conv <hex>          # show OKLCH
"""
import math
import sys


def _srgb_to_lin(c):
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def _lin_to_srgb(c):
    c = max(0.0, min(1.0, c))
    return 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055


def hex_to_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) / 255.0 for i in (0, 2, 4))


def rgb_to_hex(rgb):
    return "".join(f"{round(max(0.0,min(1.0,c))*255):02x}" for c in rgb)


def srgb_to_oklab(rgb):
    r, g, b = (_srgb_to_lin(c) for c in rgb)
    l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
    m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
    s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
    l_, m_, s_ = (v ** (1 / 3) for v in (l, m, s))
    return (
        0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
        1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
        0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
    )


def oklab_to_srgb(lab):
    L, a, b = lab
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l, m, s = (v ** 3 for v in (l_, m_, s_))
    return (
        _lin_to_srgb(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s),
        _lin_to_srgb(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s),
        _lin_to_srgb(-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s),
    )


def srgb_to_oklch(rgb):
    L, a, b = srgb_to_oklab(rgb)
    return (L, math.hypot(a, b), math.atan2(b, a))


def oklch_to_srgb(L, C, H):
    return oklab_to_srgb((L, C * math.cos(H), C * math.sin(H)))


def _in_gamut(rgb):
    return all(-1e-4 <= c <= 1 + 1e-4 for c in oklab_to_srgb(rgb) if True) or all(
        -1e-4 <= c <= 1 + 1e-4 for c in rgb)


def oklch_to_hex_clamped(L, C, H):
    """Reduce chroma until the color fits sRGB, then return hex."""
    lo, hi = 0.0, C
    rgb = oklch_to_srgb(L, C, H)
    if all(-1e-4 <= c <= 1 + 1e-4 for c in rgb):
        return rgb_to_hex(rgb)
    for _ in range(30):
        mid = (lo + hi) / 2
        rgb = oklch_to_srgb(L, mid, H)
        if all(-1e-4 <= c <= 1 + 1e-4 for c in rgb):
            lo = mid
        else:
            hi = mid
    return rgb_to_hex(oklch_to_srgb(L, lo, H))


def _Y(rgb):
    r, g, b = ((c) ** 2.4 for c in rgb)
    return 0.2126729 * r + 0.7151522 * g + 0.0721750 * b


def apca_lc(txt_rgb, bg_rgb):
    yt, yb = _Y(txt_rgb), _Y(bg_rgb)
    if yt < 0.022:
        yt += (0.022 - yt) ** 1.414
    if yb < 0.022:
        yb += (0.022 - yb) ** 1.414
    if abs(yb - yt) < 0.0005:
        return 0.0
    if yb > yt:
        sapc = (yb ** 0.56 - yt ** 0.57) * 1.14
        return 0.0 if sapc < 0.1 else (sapc - 0.027) * 100
    sapc = (yb ** 0.65 - yt ** 0.62) * 1.14
    return 0.0 if sapc > -0.1 else (sapc + 0.027) * 100


def tune(hex_in, target=60.0, bg="000000"):
    bg_rgb = hex_to_rgb(bg)
    L0, C, H = srgb_to_oklch(hex_to_rgb(hex_in))
    cur = abs(apca_lc(hex_to_rgb(hex_in), bg_rgb))
    if cur >= target:
        return hex_in, cur, cur  # already fine
    lo, hi = L0, 1.0
    for _ in range(40):
        mid = (lo + hi) / 2
        h = oklch_to_hex_clamped(mid, C, H)
        lc = abs(apca_lc(hex_to_rgb(h), bg_rgb))
        if lc < target:
            lo = mid
        else:
            hi = mid
    h = oklch_to_hex_clamped(hi, C, H)
    return h, cur, abs(apca_lc(hex_to_rgb(h), bg_rgb))


if __name__ == "__main__":
    mode = sys.argv[1]
    if mode == "conv":
        L, C, H = srgb_to_oklch(hex_to_rgb(sys.argv[2]))
        print(f"#{sys.argv[2].lstrip('#')}  OKLCH(L={L:.3f} C={C:.3f} H={math.degrees(H):.1f})")
    elif mode == "tune":
        h = sys.argv[2]
        tgt = float(sys.argv[3]) if len(sys.argv) > 3 else 60.0
        bg = sys.argv[4] if len(sys.argv) > 4 else "000000"
        new, before, after = tune(h, tgt, bg)
        print(f"#{h.lstrip('#')} (Lc {before:.1f}) -> #{new} (Lc {after:.1f})  target {tgt}")
