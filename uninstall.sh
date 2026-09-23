#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
config_file="$config_dir/libinput-gestures.conf"

libinput-gestures-setup stop 2>/dev/null || true
libinput-gestures-setup remove-autostart 2>/dev/null || true
rm -f -- "$config_file"
printf 'Removed the Omarchy Magic Trackpad gesture config and autostart.\n'
printf 'Any backup files ending in .omarchy-magic-trackpad.bak.* were left untouched.\n'
