local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local hitboxSize = 30
local showVisuals = true
local hitboxColor = Color3.fromRGB(255, 0, 100)

local draggingMenu = false
local draggingSlider = false
local draggingFloat = false
local dragStart, startPos

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxUltra2026"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 260)
MainFrame.Position = UDim2.new(0.5, -140, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 0, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "HITBOX ULTRA 2026"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(1, -85, 0, 5)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(180, 180, 255)
MinBtn.TextSize = 28
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = Header

-- Main Content
local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(1, -24, 0, 25)
SizeLabel.Position = UDim2.new(0, 12, 0, 65)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "Size: " .. hitboxSize
SizeLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
SizeLabel.Font = Enum.Font.Gotham
SizeLabel.TextSize = 15
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeLabel.Parent = MainFrame

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, -24, 0, 28)
SliderFrame.Position = UDim2.new(0, 12, 0, 95)
SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
SliderFrame.Parent = MainFrame
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 14)

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 36, 1, 0)
SliderButton.Position = UDim2.new(0, 0, 0, 0)
SliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
SliderButton.Text = ""
SliderButton.Parent = SliderFrame
Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(0, 14)

local VisualsBtn = Instance.new("TextButton")
VisualsBtn.Size = UDim2.new(1, -24, 0, 45)
VisualsBtn.Position = UDim2.new(0, 12, 0, 135)
VisualsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
VisualsBtn.Text = "Visuals: ON"
VisualsBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
VisualsBtn.Font = Enum.Font.GothamBold
VisualsBtn.TextSize = 15
VisualsBtn.Parent = MainFrame
Instance.new("UICorner", VisualsBtn).CornerRadius = UDim.new(0, 12)

local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(1, -24, 0, 25)
ColorLabel.Position = UDim2.new(0, 12, 0, 190)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "Hitbox Color"
ColorLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
ColorLabel.Font = Enum.Font.Gotham
ColorLabel.TextSize = 15
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.Parent = MainFrame

local ColorFrame = Instance.new("Frame")
ColorFrame.Size = UDim2.new(1, -24, 0, 45)
ColorFrame.Position = UDim2.new(0, 12, 0, 215)
ColorFrame.BackgroundTransparency = 1
ColorFrame.Parent = MainFrame

local colors = {
    Color3.fromRGB(255, 0, 100),
    Color3.fromRGB(0, 255, 200),
    Color3.fromRGB(100, 50, 255),
    Color3.fromRGB(255, 180, 0)
}

for i, col in ipairs(colors) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 45, 0, 45)
    cBtn.Position = UDim2.new(0, (i-1)*55, 0, 0)
    cBtn.BackgroundColor3 = col
    cBtn.Text = ""
    cBtn.Parent = ColorFrame
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 12)
    cBtn.MouseButton1Click:Connect(function()
        hitboxColor = col
    end)
end

-- Floating Button
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 60, 0, 60)
FloatBtn.Position = UDim2.new(0, 30, 0.7, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
FloatBtn.Text = "H"
FloatBtn.TextColor3 = Color3.new(1,1,1)
FloatBtn.Font = Enum.Font.GothamBlack
FloatBtn.TextSize = 28
FloatBtn.Visible = false
FloatBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(0, 255, 200)
FloatStroke.Thickness = 3
FloatStroke.Parent = FloatBtn

-- Min / Open logic
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatBtn.Visible = false
end)

-- Dragging
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFloat = true
        dragStart = input.Position
        startPos = FloatBtn.Position
    end
end)

SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = false
        draggingSlider = false
        draggingFloat = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    elseif draggingFloat and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    elseif draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local absPos = SliderFrame.AbsolutePosition
        local absSize = SliderFrame.AbsoluteSize
        local relativeX = math.clamp((input.Position.X - absPos.X), 0, absSize.X)
        local percentage = relativeX / absSize.X
        hitboxSize = math.floor(5 + (percentage * 95))
        SliderButton.Position = UDim2.new(percentage, -18, 0, 0)
        SizeLabel.Text = "Size: " .. hitboxSize
    end
end)

VisualsBtn.MouseButton1Click:Connect(function()
    showVisuals = not showVisuals
    VisualsBtn.Text = showVisuals and "Visuals: ON" or "Visuals: OFF"
    VisualsBtn.TextColor3 = showVisuals and Color3.fromRGB(0, 255, 180) or Color3.fromRGB(150, 150, 150)
end)

-- Main Hitbox Loop
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player \~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChild("Humanoid")

            if humanoid and humanoid.Health > 0 then
                hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                hrp.Transparency = showVisuals and 0.55 or 1
                hrp.Color = hitboxColor
                hrp.CanCollide = false
            else
                if hrp.Size.X > 5 then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end
    end
end)
