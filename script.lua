local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer

local CONFIG = {
    HeadSize = 20,
    RootSize = 14,
    ShowVisuals = true,
    TeamCheck = true,
    UpdateInterval = 2
}

local originals = {}
local connections = {}
local dragging = false
local dragStart, startPos
local updateConnection = nil
local staticFrame = 0

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxExpander"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 260)
Main.Position = UDim2.new(0.5, -140, 0.15, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hitbox Expander"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.TextSize = 28
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -80)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
OpenBtn.Text = "H"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 26
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local function createSlider(name, yPos, default, minVal, maxVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -30, 0, 55)
    container.Position = UDim2.new(0, 15, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = Main

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 22)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(210,210,210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 32)
    bar.BackgroundColor3 = Color3.fromRGB(45,45,45)
    bar.Parent = container
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -11, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    knob.Text = ""
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local isDragging = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not isDragging then return end
        local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + relX * (maxVal - minVal))
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -11, 0.5, -11)
        label.Text = name .. ": " .. value
        callback(value)
    end)
end

createSlider("Head Size", 55, CONFIG.HeadSize, 8, 30, function(v) CONFIG.HeadSize = v end)
createSlider("Root Size", 120, CONFIG.RootSize, 8, 25, function(v) CONFIG.RootSize = v end)

local visualsBtn = Instance.new("TextButton")
visualsBtn.Size = UDim2.new(1, -30, 0, 45)
visualsBtn.Position = UDim2.new(0, 15, 0, 185)
visualsBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
visualsBtn.Text = CONFIG.ShowVisuals and "Visuals: ON" or "Visuals: OFF"
visualsBtn.TextColor3 = CONFIG.ShowVisuals and Color3.new(1,1,1) or Color3.fromRGB(150,150,150)
visualsBtn.Font = Enum.Font.GothamBold
visualsBtn.TextSize = 16
visualsBtn.Parent = Main
Instance.new("UICorner", visualsBtn).CornerRadius = UDim.new(0,10)

visualsBtn.MouseButton1Click:Connect(function()
    CONFIG.ShowVisuals = not CONFIG.ShowVisuals
    visualsBtn.Text = CONFIG.ShowVisuals and "Visuals: ON" or "Visuals: OFF"
    visualsBtn.TextColor3 = CONFIG.ShowVisuals and Color3.new(1,1,1) or Color3.fromRGB(150,150,150)
end)

local function restore(plr)
    if not originals[plr] then return end
    local char = plr.Character
    if not char then return end
    for name, size in pairs(originals[plr]) do
        local part = char:FindFirstChild(name)
        if part then
            part.Size = size
            part.Transparency = (name == "Head") and 0 or 1
        end
    end
end

local function apply(plr)
    if plr == lp or (CONFIG.TeamCheck and plr.Team == lp.Team) then
        restore(plr)
        return
    end

    local char = plr.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    if not originals[plr] then originals[plr] = {} end
    if head and not originals[plr].Head then originals[plr].Head = head.Size end
    if hrp and not originals[plr].HumanoidRootPart then originals[plr].HumanoidRootPart = hrp.Size end

    if hum and hum.Health > 0 then
        if head then
            head.Size = Vector3.new(CONFIG.HeadSize, CONFIG.HeadSize, CONFIG.HeadSize)
            head.CanCollide = false
            head.Transparency = CONFIG.ShowVisuals and 0.6 or 1
            head.Color = Color3.fromRGB(255, 40, 40)
        end
        if hrp then
            hrp.Size = Vector3.new(CONFIG.RootSize, CONFIG.RootSize, CONFIG.RootSize)
            hrp.CanCollide = false
            hrp.Transparency = CONFIG.ShowVisuals and 0.6 or 1
            hrp.Color = Color3.fromRGB(40, 255, 40)
        end
    else
        restore(plr)
    end
end

local function updateAll()
    for _, plr in ipairs(Players:GetPlayers()) do
        apply(plr)
    end
end

local function cleanupPlayer(plr)
    restore(plr)
    if connections[plr] then
        connections[plr]:Disconnect()
        connections[plr] = nil
    end
    originals[plr] = nil
end

local function setupPlayer(plr)
    if plr == lp then return end

    cleanupPlayer(plr)

    local charAddedConn = plr.CharacterAdded:Connect(function()
        task.spawn(function()
            task.wait(0.6)
            apply(plr)
        end)
    end)

    local charRemovingConn = plr.CharacterRemoving:Connect(function()
        restore(plr)
    end)

    connections[plr] = charAddedConn

    if plr.Character then
        task.spawn(function()
            task.wait(0.6)
            apply(plr)
        end)
    end
end

-- Инициализация существующих игроков
for _, plr in ipairs(Players:GetPlayers()) do
    setupPlayer(plr)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)

-- Периодическое обновление (не каждый кадр)
updateConnection = RunService.Heartbeat:Connect(function()
    staticFrame += 1
    if staticFrame % (CONFIG.UpdateInterval * 60) == 0 then
        updateAll()
    end
end)

-- Drag меню
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Кнопки сворачивания
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 0, 35)
minBtn.Position = UDim2.new(1, -80, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "–"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 24
minBtn.Parent = Main
minBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- Очистка при уничтожении GUI
ScreenGui.Destroying:Connect(function()
    if updateConnection then
        updateConnection:Disconnect()
    end
    for plr, _ in pairs(connections) do
        cleanupPlayer(plr)
    end
    originals = {}
    connections = {}
end)

print("Hitbox Expander (Mobile Optimized v2) loaded successfully")
