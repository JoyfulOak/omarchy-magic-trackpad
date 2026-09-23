# omarchy-magic-trackpad

A prototype for horizontal back/forward navigation on Omarchy with Hyprland. Its current `libinput-gestures` rules are experimental: standard libinput reports two-finger movement as scrolling, not swipe events, so they do not implement two-finger back/forward yet.

## Prototype status and gesture limitation

The config currently contains the requested mapping:

- Swipe left sends `Alt+Left` (Back) to the focused window.
- Swipe right sends `Alt+Right` (Forward) to the focused window.

However, this mapping is **not usable as a two-finger swipe with `libinput-gestures`**. Linux libinput reports ordinary one- and two-finger movement as pointer/scroll events; its swipe gesture events are normally generated for three or more fingers. As a result, the two-finger movement scrolls the active app instead of matching these `gesture swipe ... 2` rules. Hyprland's `sendshortcut` is only reached after a swipe event is recognized; it cannot turn a scroll event into a two-finger swipe by itself.

With this approach, change the mappings to three fingers for swipe events, or use an app's own horizontal-scroll history navigation where supported. A true system-wide two-finger back/forward action requires a separate scroll-event recognizer that can distinguish a deliberate horizontal swipe from normal horizontal scrolling; this prototype does not provide that.

## Requirements

- Hyprland/Omarchy with `/usr/bin/hyprctl` and a working `sendshortcut` dispatcher.
- `libinput-gestures` and its `libinput-gestures-setup` helper.
- Permission for the user to read the touchpad's libinput events. On Arch, this commonly means adding the user to the `input` group and logging out/in; do not run the gesture daemon as root.
- A touchpad and driver that expose libinput swipe events. Standard libinput swipe gestures use three or more fingers; two-finger movement is normally reported as scrolling.

## Shortcut mapping

The config maps a recognized left swipe to `Alt+Left` (Back) and a recognized right swipe to `Alt+Right` (Forward), sent to the active window. Apps must support those shortcuts. Note that the current `... 2` rules will not receive ordinary two-finger movement as swipe events from standard libinput, so this does not currently deliver the requested two-finger behavior.

## Install on Omarchy

The gesture daemon is available from the AUR. In a terminal, install it with Omarchy's package helper, add your user to the `input` group so the daemon can read touchpad events, then log out and back in (or reboot) for the group change to take effect:

```bash
omarchy pkg aur add libinput-gestures
sudo gpasswd -a "$USER" input
```

After logging back in, clone the plugin from GitHub, then install and start it:

```bash
git clone https://github.com/JoyfulOak/omarchy-magic-trackpad.git ~/omarchy_share/GitHub/omarchy-magic-trackpad
cd ~/omarchy_share/GitHub/omarchy-magic-trackpad
./install.sh
```

If you already cloned the repository, skip the `git clone` line and run the `cd` and `./install.sh` commands.

The installer backs up an existing `~/.config/libinput-gestures.conf`, copies this repository's config, and asks `libinput-gestures-setup` to configure autostart and start the user daemon. Do not run the daemon as root. To remove the config and autostart, run `./uninstall.sh` (backups are retained).

If Omarchy's AUR helper is unavailable, install the package with an AUR helper such as `yay -S libinput-gestures` instead. Verify the setup with:

```bash
libinput-gestures-setup status
libinput-gestures -d
```

The debug mode reports recognized gestures and configured commands; stop it with Ctrl+C. Then test in Chromium and an application with back/forward navigation. Verify the app's expected shortcuts if it does not navigate.

## Development status

This prototype has not been verified with a physical Apple Magic Trackpad. The development environment exposes a QEMU Virtio Pinch Touchpad and does not have `libinput` or `libinput-gestures` installed, so physical-device event behavior and shortcut delivery remain untested here.
