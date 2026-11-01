-- Visual-only overlay for explicitly tagged demo dummies in your own place.
-- Tag a dummy Model with CollectionService tag "PT_DemoTarget".
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Overlay = {}

function Overlay.start(config)
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "PT_DemoOverlay"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local labels = {}

    local function clear(model)
        if labels[model] then
            labels[model]:Destroy()
            labels[model] = nil
        end
    end

    local function add(model)
        if not model:IsA("Model") or labels[model] then return end
        local head = model:FindFirstChild("Head")
        if not head or not head:IsA("BasePart") then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PT_DemoLabel"
        billboard.Adornee = head
        billboard.Size = UDim2.fromOffset(170, 54)
        billboard.StudsOffset = Vector3.new(0, 2.4, 0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = config.showDemoOverlay
        billboard.Parent = gui

        local text = Instance.new("TextLabel")
        text.Name = "Info"
        text.Size = UDim2.fromScale(1, 1)
        text.BackgroundTransparency = 1
        text.TextColor3 = config.accent
        text.TextStrokeTransparency = 0.25
        text.Font = Enum.Font.GothamBold
        text.TextSize = 13
        text.Parent = billboard
        labels[model] = billboard
    end

    for _, model in ipairs(CollectionService:GetTagged("PT_DemoTarget")) do
        add(model)
    end
    CollectionService:GetInstanceAddedSignal("PT_DemoTarget"):Connect(add)
    CollectionService:GetInstanceRemovedSignal("PT_DemoTarget"):Connect(clear)

    RunService.RenderStepped:Connect(function()
        for model, billboard in pairs(labels) do
            if not model.Parent then
                clear(model)
            else
                local head = model:FindFirstChild("Head")
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                billboard.Enabled = config.showDemoOverlay
                local info = billboard:FindFirstChild("Info")
                if info then
                    local bits = {}
                    if config.showNames then table.insert(bits, model.Name) end
                    if config.showHealth and humanoid then
                        table.insert(bits, ("HP %d"):format(math.floor(humanoid.Health)))
                    end
                    if config.showDistance and head then
                        local character = Players.LocalPlayer.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        if root then
                            table.insert(bits, ("%dm"):format(math.floor((root.Position - head.Position).Magnitude)))
                        end
                    end
                    info.Text = table.concat(bits, "  |  ")
                end
            end
        end
    end)

    return gui
end

return Overlay
