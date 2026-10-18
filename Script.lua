-- ==============================================================================
--              WAR TYCOON - TROLL CIRCLE MOTION (SOLARA READY)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- UI Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WarTycoonTrollUI"
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Botón Flotante Arrastrable (UI)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 30, 0, 30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
toggleBtn.TextColor3 = Color3.fromRGB(255, 59, 0)
toggleBtn.Text = "UI"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner", toggleBtn)
btnCorner.CornerRadius = UDim.new(0, 10)

local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Color = Color3.fromRGB(255, 59, 0)
btnStroke.Thickness = 2

-- Lógica de Arrastre para Solara
local dragging, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Panel de Control
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 160)
mainFrame.Position = UDim2.new(0, 90, 0, 30)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.Visible = false
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner", mainFrame)
frameCorner.CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", mainFrame)
frameStroke.Color = Color3.fromRGB(255, 59, 0)
frameStroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "🔫 WAR TYCOON TROLL 🔫"
title.TextColor3 = Color3.fromRGB(255, 59, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 13

-- Botón Toggle Círculo
local circleBtn = Instance.new("TextButton", mainFrame)
circleBtn.Size = UDim2.new(0, 200, 0, 45)
circleBtn.Position = UDim2.new(0.5, -100, 0, 45)
circleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
circleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
circleBtn.Text = "Modo Círculo: [OFF]"
circleBtn.Font = Enum.Font.GothamBold
circleBtn.TextSize = 12

local circleCorner = Instance.new("UICorner", circleBtn)
circleCorner.CornerRadius = UDim.new(0, 8)

local circleStroke = Instance.new("UIStroke", circleBtn)
circleStroke.Color = Color3.fromRGB(60, 60, 60)

-- Botón Cambio de Velocidad (Normal / Ultra)
local speedBtn = Instance.new("TextButton", mainFrame)
speedBtn.Size = UDim2.new(0, 200, 0, 35)
speedBtn.Position = UDim2.new(0.5, -100, 0, 100)
speedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
speedBtn.Text = "Velocidad: ULTRA TROLL"
speedBtn.Font = Enum.Font.Gotham
speedBtn.TextSize = 11

local speedCorner = Instance.new("UICorner", speedBtn)
speedCorner.CornerRadius = UDim.new(0, 8)

-- Variables de Estado
local active = false
local angle = 0
local speedMultiplier = 120 -- Velocidad hiper rápida para no ser objetivo fácil

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

circleBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        circleBtn.Text = "Modo Círculo: [ON]"
        circleBtn.TextColor3 = Color3.fromRGB(255, 59, 0)
        circleStroke.Color = Color3.fromRGB(255, 59, 0)
    else
        circleBtn.Text = "Modo Círculo: [OFF]"
        circleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        circleStroke.Color = Color3.fromRGB(60, 60, 60)
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    if speedMultiplier == 120 then
        speedMultiplier = 200
        speedBtn.Text = "Velocidad: EXTREMA 🔥"
        speedBtn.TextColor3 = Color3.fromRGB(255, 59, 0)
    else
        speedMultiplier = 120
        speedBtn.Text = "Velocidad: ULTRA TROLL"
        speedBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Bucle de Física Exclusivo para Solara
RunService.RenderStepped:Connect(function(dt)
    if not active then return end
    
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if root and hum and hum.Health > 0 then
        angle = angle + (speedMultiplier * dt)
        local vx = math.cos(angle) * speedMultiplier
        local vz = math.sin(angle) * speedMultiplier
        
        -- Mantiene gravedad para caer o saltar libremente mientras gira
        root.AssemblyLinearVelocity = Vector3.new(vx, root.AssemblyLinearVelocity.Y, vz)
    end
end)
