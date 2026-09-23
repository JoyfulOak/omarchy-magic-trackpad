#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
main_config="$config_dir/hyprland.lua"
managed_config="$config_dir/omarchy-magic-trackpad-back-forward.lua"
marker="omarchy-magic-trackpad-back-forward"
loader='local config_home = os.getenv("XDG_CONFIG_HOME") or ((os.getenv("HOME") or "") .. "/.config"); pcall(dofile, config_home .. "/hypr/omarchy-magic-trackpad-back-forward.lua")'

for command in python3 hyprctl; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command" >&2
    exit 1
  fi
done

if [[ ! -f "$main_config" || -L "$main_config" ]]; then
  printf 'Refusing to edit missing or symlinked Hyprland config: %s\n' "$main_config" >&2
  exit 1
fi

if ! command -v luac >/dev/null 2>&1; then
  printf 'Missing required command: luac (install Lua, then retry).\n' >&2
  exit 1
fi
luac -p "$repo_dir/back-forward.lua"

# Write the managed binding through a temporary file and rename it into place.
tmp="$managed_config.tmp.$$"
trap 'rm -f -- "$tmp"' EXIT
install -m 0644 "$repo_dir/back-forward.lua" "$tmp"
mv -f -- "$tmp" "$managed_config"

# Append one marked loader to the user's Lua config. Keep a timestamped backup
# and refuse symlinks, so the installer never writes through a redirected path.
python3 - "$main_config" "$marker" "$loader" <<'PY'
import os
import pathlib
import shutil
import sys
import tempfile
import time

path = pathlib.Path(sys.argv[1])
marker, loader = sys.argv[2:]
if path.is_symlink() or not path.is_file():
    raise SystemExit(f"Refusing to edit missing or symlinked config: {path}")
text = path.read_text()
if marker in text:
    if loader not in text:
        raise SystemExit(f"Found {marker!r} but not the expected loader; inspect {path} manually")
    print("Loader already present; left Hyprland config unchanged.")
else:
    backup = path.with_name(path.name + ".omarchy-magic-trackpad.bak." + time.strftime("%Y%m%d-%H%M%S"))
    shutil.copy2(path, backup)
    newline = "" if not text or text.endswith("\n") else "\n"
    updated = text + newline + f"\n-- {marker}: managed back/forward horizontal scroll binds\n{loader}\n"
    fd, temp_name = tempfile.mkstemp(prefix=path.name + ".", dir=path.parent)
    try:
        with os.fdopen(fd, "w") as out:
            out.write(updated)
        os.chmod(temp_name, path.stat().st_mode & 0o777)
        os.replace(temp_name, path)
    finally:
        if os.path.exists(temp_name):
            os.unlink(temp_name)
    print(f"Updated {path}; backup: {backup}")
PY

printf '\nInstalled the Hyprland horizontal-scroll bindings. No daemon or input permissions were changed.\n'
printf 'Apply them with: hyprctl reload\n'
printf 'Remove them with: %s/uninstall.sh\n' "$repo_dir"
