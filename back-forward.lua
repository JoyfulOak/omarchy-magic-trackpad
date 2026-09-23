-- Two-finger horizontal scrolling is delivered to Hyprland as mouse_left/right.
-- Bind those native events; no daemon or raw /dev/input access is needed.
if type(hl) ~= "table" then return end

local busy = false
local reset = hl.timer(function()
  busy = false
end, { timeout = 500, type = "oneshot" })
reset:set_enabled(false)

local function navigate(direction)
  if not busy then
    busy = true
    hl.dispatch(hl.dsp.send_shortcut({
      mods = "ALT",
      key = direction,
      window = "activewindow"
    }))
  end

  -- A trackpad reports a stream of scroll events for one swipe. Debounce the
  -- stream so it produces one history step, then re-arm after a short pause.
  reset:set_enabled(false)
  reset:set_enabled(true)
end

-- These are global Hyprland scroll binds. Unbind first so reloading this
-- managed file replaces its own registrations instead of stacking duplicates.
hl.unbind("mouse_left")
hl.unbind("mouse_right")
hl.bind("mouse_left", function() navigate("LEFT") end)
hl.bind("mouse_right", function() navigate("RIGHT") end)
