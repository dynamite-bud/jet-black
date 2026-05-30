#!/usr/bin/env python3
"""Layer editor-overrides.json onto a generated VS Code / Cursor theme JSON.

The tinted-vscode template produces a generic base24 theme; this applies our
opinionated tweaks (specific scope recolors, workbench color overrides) on top —
WITHOUT forking the vendored template, so it survives every `./build.sh`.

  - colors:      dict-merged (override wins)
  - tokenColors: appended after the generated rules (VS Code: among equally
                 specific scopes, the LAST matching rule wins -> override wins)

Usage: apply-editor-overrides.py <path-to-theme.json>
"""
import json
import os
import sys

theme_path = sys.argv[1]
repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ov_path = os.path.join(repo_root, "editor-overrides.json")

with open(theme_path) as f:
    theme = json.load(f)
with open(ov_path) as f:
    ov = json.load(f)

theme.setdefault("colors", {}).update(ov.get("colors", {}))
theme.setdefault("tokenColors", []).extend(ov.get("tokenColors", []))
# Semantic highlighting (TS/Rust/etc.) overrides TextMate scopes, so we must set
# these too or typed-language variables fall back to the default fg.
if "semanticHighlighting" in ov:
    theme["semanticHighlighting"] = ov["semanticHighlighting"]
theme.setdefault("semanticTokenColors", {}).update(ov.get("semanticTokenColors", {}))

with open(theme_path, "w") as f:
    json.dump(theme, f, indent=2)

print(f"  overrides applied -> {os.path.basename(theme_path)} "
      f"({len(ov.get('colors',{}))} colors, {len(ov.get('tokenColors',[]))} token rules)")
