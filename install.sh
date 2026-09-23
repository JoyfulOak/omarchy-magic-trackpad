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

# The daemon opens /dev/input directly. Check the groups active in this login,
# not just the account database: a newly added group is not applied until the
# user starts a fresh desktop session.
if ! id -nG | tr ' ' '\n' | grep -Fxq input; then
  if id -nG "$USER" | tr ' ' '\n' | grep -Fxq input; then
    printf 'Your account is in the input group, but this desktop session has not refreshed its groups.\n' >&2
    printf 'Log out and back in, then rerun this installer.\n' >&2
  else
    printf 'Your account is not a member of the input group.\n' >&2
    printf 'Run: sudo gpasswd -a %q input\n' "$USER" >&2
    printf 'Then log out and back in, and rerun this installer.\n' >&2
  fi
  exit 1
fi

mkdir -p "$config_dir"
if [[ -e "$config_file" ]]; then
  backup="$config_file.omarchy-magic-trackpad.bak.$(date +%Y%m%d-%H%M%S)"
  cp -a -- "$config_file" "$backup"
  printf 'Existing configuration backed up to %s\n' "$backup"
fi
install -m 0644 "$repo_dir/libinput-gestures.conf" "$config_file"

libinput-gestures-setup autostart
libinput-gestures-setup start
status="$(libinput-gestures-setup status 2>&1)"
printf '%s\n' "$status"
if ! grep -Fq 'is currently running' <<<"$status"; then
  printf 'Configuration was copied, but the gesture daemon did not start. Check device permissions and logs.\n' >&2
  exit 1
fi
printf 'Installed and started the gesture config: %s\n' "$config_file"
