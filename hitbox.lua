local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer

local CONFIG = {
    Enabled = true,
    HeadSize = 21,
    RootSize = 15,
    ShowVisuals = true,
    TeamCheck = true,
    UpdateInterval = 1.5
}

local originals = {}
local connections = {}
local draggingMenu = false
local draggingOpenBtn = false
local dragStart, startPos

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxExpander"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 290, 0, 280)
Main.Position = UDim2.new(0.5, -145, 0.12, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hitbox Expander"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -42, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.TextSize = 28
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Open Button (красная "H")
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -100)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
OpenBtn.Text = "H"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 28
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- Слайдеры
local function createSlider(name, yPos, default, minV, maxV, callback)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, -30, 0, 58)
    cont.Position = UDim2.new(0, 15, 0, yPos)
    cont.BackgroundTransparency = 1
    cont.Parent = Main

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,22)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(220,220,220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cont

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,0,0,10)
    bar.Position = UDim2.new(0,0,0,34)
    bar.BackgroundColor3 = Color3.fromRGB(45,45,45)
    bar.Parent = cont
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-minV)/(maxV-minV), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0,24,0,24)
    knob.Position = UDim2.new((default-minV)/(maxV-minV), -12, 0.5, -12)
    knob.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
    knob.Text = ""
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local dragging = false
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + rel * (maxV - minV))
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -12, 0.5, -12)
        lbl.Text = name .. ": " .. val
        callback(val)
    end)
end

createSlider("Head Size", 55, CONFIG.HeadSize, 8, 32, function(v) CONFIG.HeadSize = v end)
createSlider("Root Size", 125, CONFIG.RootSize, 8, 26, function(v) CONFIG.RootSize = v end)

-- Toggle Enabled
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -30, 0, 45)
toggleBtn.Position = UDim2.new(0, 15, 0, 195)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.Text = "Enabled: ON"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Parent = Main
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,10)

toggleBtn.MouseButton1Click:Connect(function()
    CONFIG.Enabled = not CONFIG.Enabled
    toggleBtn.Text = CONFIG.Enabled and "Enabled: ON" or "Enabled: OFF"
    toggleBtn.TextColor3 = CONFIG.Enabled and Color3.new(1,1,1) or Color3.fromRGB(160,160,160)
end)

-- Visuals
local visualsBtn = Instance.new("TextButton")
visualsBtn.Size = UDim2.new(1, -30, 0, 45)
visualsBtn.Position = UDim2.new(0, 15, 0, 245)
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
    for name, sz in pairs(originals[plr]) do
        local p = char:FindFirstChild(name)
        if p then
            p.Size = sz
            p.Transparency = (name == "Head") and 0 or 1
        end
    end
end

local function apply(plr)
    if not CONFIG.Enabled or plr == lp or (CONFIG.TeamCheck and plr.Team == lp.Team) then
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
            head.Transparency = CONFIG.ShowVisuals and 0.55 or 1
            head.Color = Color3.fromRGB(255, 50, 50)
        end
        if hrp then
            hrp.Size = Vector3.new(CONFIG.RootSize, CONFIG.RootSize, CONFIG.RootSize)
            hrp.CanCollide = false
            hrp.Transparency = CONFIG.ShowVisuals and 0.55 or 1
            hrp.Color = Color3.fromRGB(50, 255, 50)
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

-- Setup players
local function setupPlayer(plr)
    if plr == lp then return end
    restore(plr)
    if connections[plr] then connections[plr]:Disconnect() end

    connections[plr] = plr.CharacterAdded:Connect(function()
        task.wait(0.8)
        apply(plr)
    end)

    plr.CharacterRemoving:Connect(function() restore(plr) end)

    if plr.Character then
        task.wait(0.8)
        apply(plr)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do setupPlayer(plr) end
Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(function(plr)
    restore(plr)
    if connections[plr] then connections[plr]:Disconnect() end
    originals[plr] = nil
    connections[plr] = nil
end)

-- Периодическое обновление
RunService.Heartbeat:Connect(function()
    staticFrame = (staticFrame or 0) + 1
    if staticFrame % (CONFIG.UpdateInterval * 60) == 0 then
        updateAll()
    end
end)

-- Drag Main Frame
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)

-- Drag Open Button (красная H)
OpenBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        draggingOpenBtn = true
        dragStart = i.Position
        startPos = OpenBtn.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if draggingMenu and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    elseif draggingOpenBtn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = false
        draggingOpenBtn = false
    end
end)

-- Сворачивание
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 0, 35)
minBtn.Position = UDim2.new(1, -80, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "–"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 26
minBtn.Parent = Main
minBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

print("Hitbox Expander — загружен. Красная кнопка H теперь двигается.")
