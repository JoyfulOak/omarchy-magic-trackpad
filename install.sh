#!/usr/bin/env bash
set -euo pipefail

cat >&2 <<'MESSAGE'
This repository currently has no working system-wide two-finger back/forward installer.

Hyprland mouse_left/mouse_right binds accept mouse-wheel events, not touchpad
scroll events. A global workaround needs raw touchpad access or an in-process
Hyprland plugin; this installer deliberately makes no system changes.

The failed managed Hyprland binding can be removed with ./uninstall.sh.
MESSAGE
exit 1
