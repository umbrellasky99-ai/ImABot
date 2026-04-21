local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local hitboxSize = 20
local showVisuals = true
local teamCheck = true
local targetPartName = "HumanoidRootPart"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Hitbox Expander"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 30, 0.5, -80)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
OpenBtn.Text = "H"
OpenBtn.TextColor3 = Color3.fromRGB(255, 50, 130)
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 30
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- (остальной UI и логика оставил, но упростил для стабильности)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -55)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Size slider (упрощённый)
local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(1, 0, 0, 25)
SizeLabel.Text = "Size: 20"
SizeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Font = Enum.Font.Gotham
SizeLabel.Parent = Content

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, 0, 0, 8)
SliderFrame.Position = UDim2.new(0, 0, 0, 30)
SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SliderFrame.Parent = Content
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.4, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 130)
SliderFill.Parent = SliderFrame
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

-- Тогглы и остальное можно добавить позже, главное чтобы загрузилось

-- Главный цикл
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local part = plr.Character:FindFirstChild(targetPartName) or plr.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    if teamCheck and plr.Team == LocalPlayer.Team then
                        part.Size = Vector3.new(2,2,1)
                        part.Transparency = 1
                    else
                        part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        part.CanCollide = false
                        part.Transparency = showVisuals and 0.6 or 1
                        part.Color = Color3.fromRGB(255, 50, 130)
                    end
                end
            end
        end
    end
end)

print("Hitbox Expander загружен")
