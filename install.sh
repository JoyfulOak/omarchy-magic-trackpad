#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
config_file="$config_dir/libinput-gestures.conf"

for command in libinput-gestures-setup hyprctl; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command" >&2
    printf 'Install libinput-gestures and Hyprland, then run this installer again.\n' >&2
    exit 1
  fi
done

mkdir -p "$config_dir"
if [[ -e "$config_file" ]]; then
  backup="$config_file.omarchy-magic-trackpad.bak.$(date +%Y%m%d-%H%M%S)"
  cp -a -- "$config_file" "$backup"
  printf 'Existing configuration backed up to %s\n' "$backup"
fi
install -m 0644 "$repo_dir/libinput-gestures.conf" "$config_file"

# Upstream helper sets up the user's autostart and starts the gesture daemon.
libinput-gestures-setup autostart
libinput-gestures-setup start
printf 'Installed two-finger swipe config: %s\n' "$config_file"
