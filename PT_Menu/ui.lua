-- Clean, draggable settings panel for Roblox Studio.
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

function UI.create(config)
    local gui = Instance.new("ScreenGui")
    gui.Name = "PT_Menu"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Name = "Window"
    frame.Size = UDim2.fromOffset(430, 310)
    frame.Position = UDim2.new(0.5, -215, 0.5, -155)
    frame.BackgroundColor3 = config.background
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = config.accent
    stroke.Thickness = 1.5
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 42)
    title.Position = UDim2.fromOffset(14, 4)
    title.BackgroundTransparency = 1
    title.Text = "PT MENU  /  STUDIO DEMO"
    title.TextColor3 = config.text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local body = Instance.new("Frame")
    body.Position = UDim2.fromOffset(14, 52)
    body.Size = UDim2.new(1, -28, 1, -66)
    body.BackgroundColor3 = config.panel
    body.BorderSizePixel = 0
    body.Parent = frame
    Instance.new("UICorner", body).CornerRadius = UDim.new(0, 9)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = body

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = body

    local function addToggle(label, key)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 34)
        button.BackgroundColor3 = config.background
        button.BorderSizePixel = 0
        button.TextColor3 = config.text
        button.Font = Enum.Font.Gotham
        button.TextSize = 13
        button.Parent = body
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

        local function refresh()
            button.Text = string.format("%s     %s", label, config[key] and "ON" or "OFF")
        end
        refresh()
        button.Activated:Connect(function()
            config[key] = not config[key]
            refresh()
        end)
    end

    addToggle("Demo overlay", "showDemoOverlay")
    addToggle("Show names", "showNames")
    addToggle("Show health", "showHealth")
    addToggle("Show distance", "showDistance")

    -- Drag using the title region.
    local dragging, dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    return gui
end

return UI
