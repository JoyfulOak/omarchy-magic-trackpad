# omarchy-magic-trackpad

Two-finger horizontal swipe navigation for Omarchy on Hyprland, packaged as a small `libinput-gestures` configuration.

## Current prototype

- Two-finger swipe **left** sends `Alt+Left` (Back) to the focused window.
- Two-finger swipe **right** sends `Alt+Right` (Forward) to the focused window.
- Hyprland's `sendshortcut` dispatcher targets the active window, including native Wayland clients; it does not synthesize a system-wide key event.
- Gestures are restricted to exactly two fingers.

These are common shortcuts, not a guarantee that every application uses them. Chromium supports them; file managers and other apps vary. If an app uses different shortcuts, adjust the two command lines in `libinput-gestures.conf` for that app's behavior (the current config uses one mapping for all apps).

## Requirements

- Hyprland/Omarchy with `/usr/bin/hyprctl` and a working `sendshortcut` dispatcher.
- `libinput-gestures` and its `libinput-gestures-setup` helper.
- Permission for the user to read the touchpad's libinput events. On Arch, this commonly means adding the user to the `input` group and logging out/in; do not run the gesture daemon as root.
- A touchpad and driver that expose two-finger swipe gestures through libinput. Virtual touchpads may not expose physical swipe events.

## Gesture behavior

The mapping is global: a two-finger swipe left sends `Alt+Left`, and a swipe right sends `Alt+Right` to the active window. This enables each app's own Back/Forward action where it implements those shortcuts (for example, Chromium). Apps without those shortcuts will not navigate. `libinput-gestures` dispatches the event after recognizing the completed swipe; it is not a live, animated history gesture.

## Install on Omarchy

The gesture daemon is available from the AUR. In a terminal, install it with Omarchy's package helper, add your user to the `input` group so the daemon can read touchpad events, then log out and back in (or reboot) for the group change to take effect:

```bash
omarchy pkg aur add libinput-gestures
sudo gpasswd -a "$USER" input
```

After logging back in, install and start this plugin from the cloned repository:

```bash
cd ~/omarchy_share/GitHub/omarchy-magic-trackpad
./install.sh
```

The installer backs up an existing `~/.config/libinput-gestures.conf`, copies this repository's config, and asks `libinput-gestures-setup` to configure autostart and start the user daemon. Do not run the daemon as root. To remove the config and autostart, run `./uninstall.sh` (backups are retained).

If Omarchy's AUR helper is unavailable, install the package with an AUR helper such as `yay -S libinput-gestures` instead. Verify the setup with:

```bash
libinput-gestures-setup status
libinput-gestures -d
```

The debug mode reports recognized gestures and configured commands; stop it with Ctrl+C. Then test in Chromium and an application with back/forward navigation. Verify the app's expected shortcuts if it does not navigate.

## Development status

This is an initial functional config prototype, not verified against a physical Apple Magic Trackpad. The current development environment exposes a QEMU Virtio Pinch Touchpad and does not have `libinput` or `libinput-gestures` installed, so hardware gesture detection and live shortcut delivery still need testing on the target machine.
