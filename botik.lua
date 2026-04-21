local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local hitboxSize = 20
local showVisuals = true
local teamCheck = true
local targetPartName = "HumanoidRootPart"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxExpander"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 290, 0, 340)
MainFrame.Position = UDim2.new(0.5, -145, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 40, 120)
UIStroke.Thickness = 1.6
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Hitbox Expander"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -72, 0, 8)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 26
MinBtn.Parent = Header

-- Круглая кнопка открытия
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 58, 0, 58)
OpenBtn.Position = UDim2.new(0, 20, 0.6, -29)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
OpenBtn.Text = "H"
OpenBtn.TextColor3 = Color3.fromRGB(255, 40, 120)
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 32
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 40, 120)
OpenStroke.Thickness = 2.5
OpenStroke.Parent = OpenBtn

-- Контент
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -68)
Content.Position = UDim2.new(0, 12, 0, 58)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Size
local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(1, 0, 0, 24)
SizeLabel.Text = "Size: " .. hitboxSize
SizeLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Font = Enum.Font.GothamSemibold
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeLabel.Parent = Content

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 10)
SliderFrame.Position = UDim2.new(0, 0, 0, 32)
SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
SliderFrame.Parent = Content
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((hitboxSize-1)/49, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 40, 120)
SliderFill.Parent = SliderFrame
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 22, 0, 22)
SliderKnob.Position = UDim2.new((hitboxSize-1)/49, -11, 0.5, -11)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.Text = ""
SliderKnob.Parent = SliderFrame
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

-- Тогглы
local function CreateToggle(name, default, yPos, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 38)
    Toggle.Position = UDim2.new(0, 0, 0, yPos)
    Toggle.BackgroundTransparency = 1
    Toggle.Parent = Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(210, 210, 210)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 52, 0, 26)
    Btn.Position = UDim2.new(1, -60, 0.5, -13)
    Btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(70, 70, 80)
    Btn.Text = ""
    Btn.Parent = Toggle
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Btn, TweenInfo.new(0.25), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(70, 70, 80)}):Play()
        callback(state)
    end)
end

CreateToggle("Show Visuals", showVisuals, 70, function(v) showVisuals = v end)
CreateToggle("Team Check", teamCheck, 115, function(v) teamCheck = v end)

-- Target Part
local PartLabel = Instance.new("TextLabel")
PartLabel.Size = UDim2.new(1, 0, 0, 24)
PartLabel.Position = UDim2.new(0, 0, 0, 165)
PartLabel.Text = "Target Part: " .. targetPartName
PartLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
PartLabel.BackgroundTransparency = 1
PartLabel.Font = Enum.Font.GothamSemibold
PartLabel.TextXAlignment = Enum.TextXAlignment.Left
PartLabel.Parent = Content

local PartButton = Instance.new("TextButton")
PartButton.Size = UDim2.new(1, 0, 0, 38)
PartButton.Position = UDim2.new(0, 0, 0, 195)
PartButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
PartButton.Text = targetPartName
PartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PartButton.Font = Enum.Font.GothamBold
PartButton.TextSize = 15
PartButton.Parent = Content
Instance.new("UICorner", PartButton).CornerRadius = UDim.new(0, 10)

local parts = {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"}
local partIndex = 1

PartButton.MouseButton1Click:Connect(function()
    partIndex = partIndex % #parts + 1
    targetPartName = parts[partIndex]
    PartButton.Text = targetPartName
    PartLabel.Text = "Target Part: " .. targetPartName
end)

-- Dragging MainFrame
local draggingMenu = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = false
    end
end)

-- Dragging OpenBtn (круг)
local draggingOpen = false
local openDragStart, openStartPos

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingOpen = true
        openDragStart = input.Position
        openStartPos = OpenBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingOpen and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - openDragStart
        OpenBtn.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingOpen = false
    end
end)

-- Slider
local draggingSlider = false

SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local relX = math.clamp(UserInputService:GetMouseLocation().X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
        local percent = relX / SliderFrame.AbsoluteSize.X
        hitboxSize = math.floor(1 + percent * 49)

        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderKnob.Position = UDim2.new(percent, -11, 0.5, -11)
        SizeLabel.Text = "Size: " .. hitboxSize
    end
end)

-- Кнопки сворачивания
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Keybind (работает и на ПК)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        OpenBtn.Visible = not MainFrame.Visible
    end
end)

-- Главный цикл
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player \~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local part = character:FindFirstChild(targetPartName) or character:FindFirstChild("HumanoidRootPart")
                if part then
                    if teamCheck and player.Team == LocalPlayer.Team then
                        part.Size = Vector3.new(2, 2, 1)
                        part.Transparency = 1
                    else
                        part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        part.CanCollide = false
                        part.Color = Color3.fromRGB(255, 40, 120)
                        part.Transparency = showVisuals and 0.6 or 1
                        part.Material = Enum.Material.ForceField
                    end
                end
            end
        end
    end
end)
