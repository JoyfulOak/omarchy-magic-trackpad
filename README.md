# omarchy-magic-trackpad

Two-finger horizontal scroll navigation for Omarchy and Hyprland. Swiping left sends `Alt+Left` to the focused window; swiping right sends `Alt+Right`. Chromium and other applications that use those shortcuts can navigate backward and forward.

## Approach

This uses Hyprland's built-in horizontal scroll bindings (`mouse_left` and `mouse_right`). A normal two-finger touchpad movement is reported as scroll input, not as a two-finger swipe gesture, so `libinput-gestures` swipe rules cannot recognize it. This setup uses no gesture daemon, raw input-device access, root privileges, or input-group membership.

Hyprland sees horizontal scroll events rather than a distinct “history swipe” event. The bindings consume horizontal scrolling and translate each short scroll burst into one shortcut. That means apps with horizontal-scroll content will receive navigation instead while this is installed. Applications that do not use `Alt+Left`/`Alt+Right` will not navigate.

## Install

Requirements: Omarchy with Hyprland's Lua configuration, `hyprctl`, and `luac`.

```sh
cd ~/omarchy_share/Github/omarchy-magic-trackpad
./install.sh
hyprctl reload
```

The installer validates the Lua syntax, writes one managed file under `~/.config/hypr/`, and appends one marked `dofile` line to `hyprland.lua`. It makes a timestamped backup before editing that file, refuses symlinks, and does not start services or change device permissions. If the bindings conflict with your own `mouse_left` or `mouse_right` binds, inspect and remove the conflicting bind in your own config before enabling this one.

Try a two-finger swipe left and right over a window with navigation history. A left swipe should go back and a right swipe should go forward. The active Hyprland window receives the shortcut.

## Uninstall

```sh
./uninstall.sh
hyprctl reload
```

Uninstall removes only this repo's marked loader and managed Lua file. It keeps all timestamped backups. It does not remove or alter any files from an earlier `libinput-gestures` installation; that setup is independent and must be removed using its own configuration if present.

## Limitations

- Horizontal scroll is used for navigation while installed, including scroll input from devices that emit horizontal wheel events.
- `Alt+Left` and `Alt+Right` are common history shortcuts, but individual applications may use different shortcuts or no history action.
- Hyprland binds discrete scroll events, so this produces a single navigation step per scroll burst rather than macOS-style animated history tracking.
- This repository has not been validated on a physical Apple Magic Trackpad. The current development VM does not provide physical trackpad hardware.
