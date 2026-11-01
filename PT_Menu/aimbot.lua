-- Safe placeholder: no target acquisition, camera control, or player tracking.
-- Use this module for a UI-only settings demo in your own Roblox Studio place.
local DemoSettings = {}

function DemoSettings.setFov(config, value)
    config.demoFov = math.clamp(value, 40, 300)
end

function DemoSettings.setSmoothing(config, value)
    config.demoSmoothing = math.clamp(value, 0, 1)
end

return DemoSettings
