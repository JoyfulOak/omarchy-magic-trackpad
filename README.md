# omarchy-magic-trackpad

Two-finger horizontal swipe navigation for Omarchy on Hyprland.

## Goal

Swipe left to go back and swipe right to go forward in the **currently focused window**, when that application supports its normal back/forward actions. This should work across applications rather than being hard-coded for Chromium (for example, browser history and file-manager navigation).

## Planned behavior

- Detect two-finger horizontal swipes from the touchpad.
- Map left/right gestures to configurable application-standard Back/Forward keyboard shortcuts (`Alt+Left` / `Alt+Right` by default).
- Send the shortcut to the focused application only; do nothing for vertical or non-horizontal gestures.
- Provide thresholds, enable/disable controls, and an installer/uninstaller that do not overwrite user Hyprland configuration.

## Development status

Repository scaffold only; gesture detection and installation are not implemented yet. The current development environment is a virtual machine exposing a QEMU Virtio Pinch Touchpad, not an Apple Magic Trackpad. Validate hardware-specific behavior on the target device before claiming Magic Trackpad support.

## Next steps

1. Choose and verify the gesture-event source supported by the target Hyprland/Omarchy version.
2. Implement gesture classification and configurable key emission without requiring broad root access.
3. Add install/uninstall, documentation, and tests; test focused-window behavior with Chromium and a file manager.
