# omarchy-magic-trackpad

This repository investigates two-finger horizontal navigation on Omarchy with Hyprland. It does not currently provide a working system-wide solution.

## Why the previous approach failed

Hyprland's `mouse_left` and `mouse_right` binds are for horizontal mouse-wheel events. They do not receive touchpad scroll events, even though the bindings appear in `hyprctl binds`. The previous installer registered those binds and therefore reported success without making touchpad swipes work. The current `install.sh` refuses to install them.

`libinput-gestures` is not a replacement: libinput reports ordinary two-finger touchpad movement as scroll events, while its swipe gestures are for three or more fingers.

## What works without a system daemon

Applications can implement navigation on their own. Chromium has the `TouchpadOverscrollHistoryNavigation` feature; it must be enabled when Chromium starts. On this machine, Chromium already uses that feature through `~/.config/chromium-flags.conf`. The feature only affects Chromium and other apps need their own native support.

There is no generic Wayland shortcut that translates two-finger scrolls to back/forward in every focused app. A global recognizer would need to read raw `/dev/input` events or run inside Hyprland as a native plugin. The event devices on this Omarchy system are restricted to the `input` group, and this user is not a member. This repo will not silently add broad input-device permissions or install compositor code.

## Cleanup

The earlier installer from this repository added a marked loader line and a managed Hyprland Lua file. To remove those files and restore normal horizontal mouse-wheel behavior:

```sh
./uninstall.sh
hyprctl reload
```

The uninstall script removes only this repository's marked loader and managed Lua file. Timestamped backups are kept. It does not remove unrelated `libinput-gestures` configuration or autostart files.

## Next steps

For Chromium, verify the swipe in a Wayland session and confirm the current Chromium process includes `--enable-features=TouchpadOverscrollHistoryNavigation` in `chrome://version`.

For a system-wide behavior, choose between a user-space event monitor with raw input-device access and a version-matched Hyprland plugin. Both have broader system impact than this repo's original config-only prototype and need a separately reviewed implementation.
