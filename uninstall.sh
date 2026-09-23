#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
main_config="$config_dir/hyprland.lua"
managed_config="$config_dir/omarchy-magic-trackpad-back-forward.lua"
marker="omarchy-magic-trackpad-back-forward"

if [[ -L "$main_config" ]]; then
  printf 'Refusing to edit symlinked Hyprland config: %s\n' "$main_config" >&2
  exit 1
fi

if [[ -f "$main_config" ]]; then
  python3 - "$main_config" "$marker" <<'PY'
import os
import pathlib
import sys
import tempfile

path = pathlib.Path(sys.argv[1])
marker = sys.argv[2]
if path.is_symlink():
    raise SystemExit(f"Refusing to edit symlinked config: {path}")
lines = path.read_text().splitlines(keepends=True)
kept = [line for line in lines if marker not in line]
if len(kept) != len(lines):
    fd, temp_name = tempfile.mkstemp(prefix=path.name + ".", dir=path.parent)
    try:
        with os.fdopen(fd, "w") as out:
            out.writelines(kept)
        os.chmod(temp_name, path.stat().st_mode & 0o777)
        os.replace(temp_name, path)
    finally:
        if os.path.exists(temp_name):
            os.unlink(temp_name)
    print(f"Removed the marked loader from {path}.")
else:
    print("No marked loader found; Hyprland config left unchanged.")
PY
else
  printf 'Hyprland config not found; skipped loader cleanup.\n'
fi

rm -f -- "$managed_config"
printf 'Removed the managed binding file. Apply removal with: hyprctl reload\n'
printf 'Existing libinput-gestures files and autostart were not changed.\n'
