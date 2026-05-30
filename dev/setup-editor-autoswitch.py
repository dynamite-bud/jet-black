#!/usr/bin/env python3
"""Make Cursor + VS Code auto-switch their theme with the OS appearance:
    dark  -> "Jet Black"            (this theme)
    light -> "GitHub Light Default"

Sets, in each editor's user settings.json:
    window.autoDetectColorScheme       = true
    workbench.preferredDarkColorTheme  = "Jet Black"
    workbench.preferredLightColorTheme = "GitHub Light Default"

Idempotent, and preserves the existing file: settings.json is JSONC (comments,
trailing commas), so we edit by targeted regex instead of reparsing/rewriting
(which would drop the user's comments and ordering).

Usage: setup-editor-autoswitch.py
"""
import json
import os
import re

LIGHT = "GitHub Light Default"
DESIRED = {
    "window.autoDetectColorScheme": True,
    "workbench.preferredDarkColorTheme": "Jet Black",
    "workbench.preferredLightColorTheme": LIGHT,
}

home = os.path.expanduser("~")
CANDIDATES = [
    f"{home}/Library/Application Support/Cursor/User/settings.json",
    f"{home}/Library/Application Support/Code/User/settings.json",
    f"{home}/.config/Cursor/User/settings.json",
    f"{home}/.config/Code/User/settings.json",
]


def set_key(text, key, value):
    """Replace key's value in place, or insert it just after the opening brace."""
    vstr = json.dumps(value)
    # match an existing "key": "string" | true | false
    pat = re.compile(r'("%s"\s*:\s*)(?:"[^"]*"|true|false)' % re.escape(key))
    if pat.search(text):
        return pat.sub(lambda m: m.group(1) + vstr, text, count=1)
    # otherwise insert as the first entry of the root object
    return re.sub(r"\{", '{\n  %s: %s,' % (json.dumps(key), vstr), text, count=1)


configured = 0
for path in CANDIDATES:
    user_dir = os.path.dirname(path)
    if not os.path.isdir(user_dir):
        continue  # editor not installed
    if not os.path.isfile(path):
        open(path, "w").write("{}\n")
    text = open(path).read()
    for k, v in DESIRED.items():
        text = set_key(text, k, v)
    open(path, "w").write(text)
    print(f"  ✓ {path}")
    configured += 1

if configured:
    print(f"  auto-switch set: dark=Jet Black, light={LIGHT} ({configured} editor(s))")
else:
    print("  no Cursor/VS Code install found — skipped")
