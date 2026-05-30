# Jet Black

A pure-black color theme for the whole toolchain — terminals, editors, and CLI tools — generated from **one** palette.

Derived from the excellent [Pitch Black](https://github.com/ViktorQvarfordt/vscode-pitch-black-theme) VS Code theme by Viktor Qvarfordt, re-expressed as a [base24](https://github.com/tinted-theming/base24) scheme and equalized in OKLCH so every accent stays legible on `#000000`.

## How it works

```
schemes/jet-black.yaml   ← single source of truth (base24 palette)
        │
        ▼  build.sh  (tinty / tinted-builder + templates/)
        │
   ┌────┴───────────────────────────────────────────┐
   ▼          ▼          ▼            ▼          ▼
jet-black-  jet-black- jet-black-  jet-black- jet-black-
 ghostty/    tmux/      starship/    vscode/    cursor/
```

Edit the palette in `schemes/jet-black.yaml`, run `./build.sh`, and every `jet-black-*/` folder regenerates. Each folder is independently publishable.

## Palette

| Slot | Hex | Role |
|------|-----|------|
| base00 | `#000000` | background |
| base05 | `#d4d4d4` | foreground |
| base08 | `#f44747` | red |
| base09 | `#d2691e` | orange |
| base0A | `#d0c590` | yellow |
| base0B | `#a8d57e` | green |
| base0C | `#5bb8a8` | cyan |
| base0D | `#6db3f2` | blue |
| base0E | `#c586c0` | magenta |
| base0F | `#d7ba7d` | gold |

(base01–04 ramp, base06–07 lights, base10–17 brights — see `schemes/jet-black.yaml`.)

## Usage

- **Try it (DEV, no system changes):** `./dev/dev.sh` — opens isolated ghostty/tmux/starship/editor previews.
- **Install (PROD):** `./install.sh` — wires the built themes into your live config.
- **Publish editors:** `./publish.sh` — VS Code Marketplace + Open VSX.

## Credit & license

Jet Black is licensed MIT. It derives from **Pitch Black Theme**, © 2021 Viktor Qvarfordt, also MIT — see [`LICENSE`](./LICENSE).
