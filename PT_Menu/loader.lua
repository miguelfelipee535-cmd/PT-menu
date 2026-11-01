-- PT_Menu | Safe Roblox Studio demo
-- Place this folder in a Roblox Studio project and require the modules
-- from a LocalScript. This loader intentionally does not use executors,
-- loadstring, hooks, or external exploit APIs.

local Config = require(script.Parent.config)
local UI = require(script.Parent.ui)
local DemoOverlay = require(script.Parent.esp)

local menu = UI.create(Config)
DemoOverlay.start(Config)

return {
    Config = Config,
    Menu = menu,
}
