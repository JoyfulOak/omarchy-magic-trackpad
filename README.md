# omarchy-magic-trackpad

Two-finger horizontal swipe navigation for Omarchy on Hyprland, packaged as a small `libinput-gestures` configuration.

## Current prototype

- Two-finger swipe **left** sends `Alt+Left` (Back) to the focused window.
- Two-finger swipe **right** sends `Alt+Right` (Forward) to the focused window.
- Hyprland's `sendshortcut` dispatcher targets the active window, including native Wayland clients; it does not synthesize a system-wide key event.
- Gestures are restricted to exactly two fingers.

These are common shortcuts, not a guarantee that every application uses them. Chromium supports them; file managers and other apps vary. If an app uses different shortcuts, adjust the two command lines in `libinput-gestures.conf` for that app's behavior (the current config uses one mapping for all apps).

## Requirements

- Hyprland/Omarchy with `/usr/bin/hyprctl`.
- `libinput-gestures` and its `libinput-gestures-setup` helper.
- Permission for the user to read the touchpad's libinput events. Follow the libinput-gestures installation instructions for this distribution; do not run the gesture daemon as root.
- A touchpad and driver that expose two-finger swipe gestures through libinput.

## Install

Install `libinput-gestures` using your preferred package source, complete its documented input-device permissions setup, then run:

```bash
./install.sh
```

The installer backs up an existing `~/.config/libinput-gestures.conf`, copies this repository's config, and asks the upstream helper to configure autostart and start the daemon. Review the script before running it. To remove the config and autostart, run `./uninstall.sh` (backups are retained).

## Test and troubleshoot

```bash
libinput-gestures-setup status
libinput-gestures -d
```

The debug mode reports recognized gestures/configured commands; stop it with Ctrl+C. Then test in Chromium and an application with back/forward navigation. Verify the app's expected shortcuts if it does not navigate.

## Development status

This is an initial functional config prototype, not verified against a physical Apple Magic Trackpad. The current development environment exposes a QEMU Virtio Pinch Touchpad and does not have `libinput` or `libinput-gestures` installed, so hardware gesture detection and live shortcut delivery still need testing on the target machine.
