-- ==============================================================================
--              SUPER CIRCULAR MOTION UI - ULTIMATE EDITION
-- ==============================================================================
-- Desarrollado con arquitectura modular para ejecutor / Roblox Studio.
-- Sistema de física no invasivo: Mantiene control total de cámara y movimiento.
-- ==============================================================================

local Services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local Players = Services.Players
local RunService = Services.RunService
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local CoreGui = Services.CoreGui

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ------------------------------------------------------------------------------
-- CONFIGURACIÓN POR DEFECTO
-- ------------------------------------------------------------------------------
local Config = {
    Enabled = false,
    CircleSpeed = 50,          -- Velocidad de rotación
    CircleRadius = 90,         -- Fuerza / Radio del movimiento
    UsePhysicsMethod = true,   -- true = AssemblyLinearVelocity (Cámara libre), false = CFrame
    Theme = {
        Background = Color3.fromRGB(18, 18, 18),
        Header = Color3.fromRGB(24, 24, 24),
        Accent = Color3.fromRGB(255, 59, 0),
        Button = Color3.fromRGB(32, 32, 32),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(150, 150, 150)
    }
}

-- ------------------------------------------------------------------------------
-- SISTEMA DE INTERFAZ GRÁFICA (UI BUILDER)
-- ------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateCircleMotionUI"
ScreenGui.ResetOnSpawn = false

-- Protección para inyectar en CoreGui si está disponible
local success, _ = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success or not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Funciones auxiliares de UI
local function AddCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

local function AddStroke(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Config.Theme.Accent
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

-- ------------------------------------------------------------------------------
-- 1. BOTÓN FLOTANTE (DRAGGABLE TOGGLE BUTTON)
-- ------------------------------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "DraggableUIBtn"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 30, 0, 30)
ToggleButton.BackgroundColor3 = Config.Theme.Background
ToggleButton.TextColor3 = Config.Theme.Accent
ToggleButton.Text = "UI"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ScreenGui

AddCorner(ToggleButton, 12)
AddStroke(ToggleButton, Config.Theme.Accent, 2)

-- Lógica para arrastrar el botón flotante
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(ToggleButton, TweenInfo.new(0.08), {Position = newPos}):Play()
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- ------------------------------------------------------------------------------
-- 2. PANEL PRINCIPAL DE CONTROL
-- ------------------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0, 90, 0, 30)
MainFrame.BackgroundColor3 = Config.Theme.Background
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

AddCorner(MainFrame, 12)
AddStroke(MainFrame, Config.Theme.Accent, 2)

-- Encabezado
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Config.Theme.Header
Header.Parent = MainFrame

AddCorner(Header, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ CIRCLE MOTION V2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Config.Theme.Accent
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Botón dentro del menú para cerrar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Config.Theme.TextMuted
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Contenedor de Elementos
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -30, 1, -60)
ContentContainer.Position = UDim2.new(0, 15, 0, 55)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Botón Principal Toggle (ON / OFF)
local MotionToggleBtn = Instance.new("TextButton")
MotionToggleBtn.Size = UDim2.new(1, 0, 0, 45)
MotionToggleBtn.Position = UDim2.new(0, 0, 0, 5)
MotionToggleBtn.BackgroundColor3 = Config.Theme.Button
MotionToggleBtn.Text = "ESTADO: DESACTIVADO"
MotionToggleBtn.Font = Enum.Font.GothamBold
MotionToggleBtn.TextSize = 13
MotionToggleBtn.TextColor3 = Config.Theme.Text
MotionToggleBtn.Parent = ContentContainer

AddCorner(MotionToggleBtn, 8)
local ToggleStroke = AddStroke(MotionToggleBtn, Color3.fromRGB(60, 60, 60), 1)

MotionToggleBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    if Config.Enabled then
        MotionToggleBtn.Text = "ESTADO: ACTIVADO (CIRCULANDO)"
        MotionToggleBtn.TextColor3 = Config.Theme.Accent
        ToggleStroke.Color = Config.Theme.Accent
    else
        MotionToggleBtn.Text = "ESTADO: DESACTIVADO"
        MotionToggleBtn.TextColor3 = Config.Theme.Text
        ToggleStroke.Color = Color3.fromRGB(60, 60, 60)
    end
end)

-- Deslizador 1: Velocidad (Speed)
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 65)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidad de Giro: " .. tostring(Config.CircleSpeed)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.TextColor3 = Config.Theme.TextMuted
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = ContentContainer

local SpeedPlusBtn = Instance.new("TextButton")
SpeedPlusBtn.Size = UDim2.new(0, 60, 0, 30)
SpeedPlusBtn.Position = UDim2.new(1, -60, 0, 85)
SpeedPlusBtn.BackgroundColor3 = Config.Theme.Button
SpeedPlusBtn.Text = "+10"
SpeedPlusBtn.Font = Enum.Font.GothamBold
SpeedPlusBtn.TextColor3 = Config.Theme.Text
SpeedPlusBtn.Parent = ContentContainer
AddCorner(SpeedPlusBtn, 6)

local SpeedMinusBtn = Instance.new("TextButton")
SpeedMinusBtn.Size = UDim2.new(0, 60, 0, 30)
SpeedMinusBtn.Position = UDim2.new(1, -125, 0, 85)
SpeedMinusBtn.BackgroundColor3 = Config.Theme.Button
SpeedMinusBtn.Text = "-10"
SpeedMinusBtn.Font = Enum.Font.GothamBold
SpeedMinusBtn.TextColor3 = Config.Theme.Text
SpeedMinusBtn.Parent = ContentContainer
AddCorner(SpeedMinusBtn, 6)

SpeedPlusBtn.MouseButton1Click:Connect(function()
    Config.CircleSpeed = math.min(Config.CircleSpeed + 10, 200)
    SpeedLabel.Text = "Velocidad de Giro: " .. tostring(Config.CircleSpeed)
end)

SpeedMinusBtn.MouseButton1Click:Connect(function()
    Config.CircleSpeed = math.max(Config.CircleSpeed - 10, 10)
    SpeedLabel.Text = "Velocidad de Giro: " .. tostring(Config.CircleSpeed)
end)

-- Deslizador 2: Radio (Radius)
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(1, 0, 0, 20)
RadiusLabel.Position = UDim2.new(0, 0, 0, 125)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Radio del Círculo: " .. tostring(Config.CircleRadius)
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.TextSize = 12
RadiusLabel.TextColor3 = Config.Theme.TextMuted
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.Parent = ContentContainer

local RadiusPlusBtn = Instance.new("TextButton")
RadiusPlusBtn.Size = UDim2.new(0, 60, 0, 30)
RadiusPlusBtn.Position = UDim2.new(1, -60, 0, 145)
RadiusPlusBtn.BackgroundColor3 = Config.Theme.Button
RadiusPlusBtn.Text = "+10"
RadiusPlusBtn.Font = Enum.Font.GothamBold
RadiusPlusBtn.TextColor3 = Config.Theme.Text
RadiusPlusBtn.Parent = ContentContainer
AddCorner(RadiusPlusBtn, 6)

RadiusMinusBtn = Instance.new("TextButton")
RadiusMinusBtn.Size = UDim2.new(0, 60, 0, 30)
RadiusMinusBtn.Position = UDim2.new(1, -125, 0, 145)
RadiusMinusBtn.BackgroundColor3 = Config.Theme.Button
RadiusMinusBtn.Text = "-10"
RadiusMinusBtn.Font = Enum.Font.GothamBold
RadiusMinusBtn.TextColor3 = Config.Theme.Text
RadiusMinusBtn.Parent = ContentContainer
AddCorner(RadiusMinusBtn, 6)

RadiusPlusBtn.MouseButton1Click:Connect(function()
    Config.CircleRadius = math.min(Config.CircleRadius + 10, 300)
    RadiusLabel.Text = "Radio del Círculo: " .. tostring(Config.CircleRadius)
end)

RadiusMinusBtn.MouseButton1Click:Connect(function()
    Config.CircleRadius = math.max(Config.CircleRadius - 10, 10)
    RadiusLabel.Text = "Radio del Círculo: " .. tostring(Config.CircleRadius)
end)

-- ------------------------------------------------------------------------------
-- 3. MOTOR DE FÍSICA Y MOVIMIENTO CIRCULAR
-- ------------------------------------------------------------------------------
local angleAccumulator = 0

RunService.RenderStepped:Connect(function(deltaTime)
    if not Config.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if rootPart and humanoid and humanoid.Health > 0 then
        -- Incrementar el ángulo en función del tiempo para mantener consistencia de FPS
        angleAccumulator = angleAccumulator + (Config.CircleSpeed * deltaTime)
        
        -- Calcular vectores circulares mediante trigonometría
        local velX = math.cos(angleAccumulator) * Config.CircleRadius
        local velZ = math.sin(angleAccumulator) * Config.CircleRadius
        
        -- Aplicar velocidad lineal sobre HumanoidRootPart sin alterar el eje Y (gravedad intacta)
        rootPart.AssemblyLinearVelocity = Vector3.new(velX, rootPart.AssemblyLinearVelocity.Y, velZ)
    end
end)

-- Restablecer referencias al reaparecer el personaje
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    newCharacter:WaitForChild("HumanoidRootPart")
end)

print("[SUCCES] Ultimate Circle Motion Script cargado correctamente.")
