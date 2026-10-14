local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local OWNER_NAME = "sm07070707tycon"

if CoreGui:FindFirstChild("DeltaMegaAdminPanel") then
    CoreGui.DeltaMegaAdminPanel:Destroy()
end

local States = {
    Fly = false,
    Noclip = false,
    ESPBox = false,
    ESPName = false,
    GodMode = false,
    Speed = 16,
    Jump = 50,
    FlySpeed = 50,
    TargetPlayer = ""
}

local espBoxes, espNames = {}, {}

-- UI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMegaAdminPanel"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Text = "🛠️"
ToggleButton.TextSize = 24
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(0, 25)
TCorner.Parent = ToggleButton

-- Botón Cerrar (Izquierda)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(0, 5, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
MinBtn.BackgroundTransparency = 0.1
MinBtn.Text = "✕"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.Parent = MainFrame

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 8)
MinBtnCorner.Parent = MinBtn

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 360, 0, 40)
Title.Position = UDim2.new(0, 50, 0, 5)
Title.Text = "👑 DELTA ADMIN PANEL"
Title.TextColor3 = Color3.fromRGB(0, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -55)
ContentContainer.Position = UDim2.new(0, 137, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Sections, Tabs = {}, {}

local function CreateSection(name)
    local Frame = Instance.new("ScrollingFrame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.CanvasSize = UDim2.new(0, 0, 2.5, 0)
    Frame.ScrollBarThickness = 4
    Frame.Visible = false
    Frame.Parent = ContentContainer

    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 8)
    UIList.Parent = Frame

    Sections[name] = Frame

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 10 + (#Tabs * 40))
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 11
    TabBtn.Parent = Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()
        for _, sec in pairs(Sections) do sec.Visible = false end
        for _, tab in pairs(Tabs) do tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end
        Frame.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
    end)

    table.insert(Tabs, TabBtn)
    return Frame
end

local SecAdmin = CreateSection("⚡ Comandos Admin")
local SecPlayer = CreateSection("👤 Mi Jugador")
local SecMovement = CreateSection("🏃 Movimiento")
local SecVisuals = CreateSection("👁️ Visuales")

if #Tabs > 0 then Tabs[1].BackgroundColor3 = Color3.fromRGB(0, 130, 255) end
Sections["⚡ Comandos Admin"].Visible = true

local function GetTargetPlayers()
    if States.TargetPlayer:lower() == "all" or States.TargetPlayer == "" then 
        return Players:GetPlayers() 
    end
    local found = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #States.TargetPlayer) == States.TargetPlayer:lower() or 
           p.DisplayName:lower():sub(1, #States.TargetPlayer) == States.TargetPlayer:lower() then
            table.insert(found, p)
        end
    end
    return found
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 12
    Btn.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(callback)
end

local function CreateToggle(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = text .. ": OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 12
    Btn.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and ": ON" or ": OFF")
        Btn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    Box.Text = text .. " [" .. default .. "]"
    Box.TextColor3 = Color3.fromRGB(240, 240, 240)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 12
    Box.Parent = Frame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Box

    Box.FocusLost:Connect(function()
        local val = tonumber(Box.Text:match("%d+")) or default
        val = math.clamp(val, min, max)
        Box.Text = text .. " [" .. val .. "]"
        callback(val)
    end)
end

local PlayerSelector = Instance.new("TextBox")
PlayerSelector.Size = UDim2.new(1, -10, 0, 40)
PlayerSelector.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerSelector.PlaceholderText = "Nombre Jugador (Escribe 'all' para todos)"
PlayerSelector.Text = ""
PlayerSelector.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerSelector.Font = Enum.Font.GothamBold
PlayerSelector.TextSize = 12
PlayerSelector.Parent = SecAdmin

local PSCorner = Instance.new("UICorner")
PSCorner.CornerRadius = UDim.new(0, 6)
PSCorner.Parent = PlayerSelector

PlayerSelector:GetPropertyChangedSignal("Text"):Connect(function()
    States.TargetPlayer = PlayerSelector.Text
end)

----------------------------------------------------
--- COMANDOS REALES VÍA FÍSICA (FLING)
----------------------------------------------------

-- Función de Fling Físico Real (Lanza al jugador fuera del mapa)
local function PerformFling(targetPlayer)
    if targetPlayer == LocalPlayer or targetPlayer.Name == OWNER_NAME then return end
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character

    if myChar and targetChar and myChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
        local myRoot = myChar.HumanoidRootPart
        local targetRoot = targetChar.HumanoidRootPart

        local oldCF = myRoot.CFrame
        local bgV = Instance.new("BodyAngularVelocity")
        bgV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bgV.AngularVelocity = Vector3.new(0, 99999, 0)
        bgV.Parent = myRoot

        local start = tick()
        while tick() - start < 1.5 do
            if not targetRoot or not myRoot then break end
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0)
            RunService.RenderStepped:Wait()
        end

        bgV:Destroy()
        myRoot.CFrame = oldCF
    end
end

CreateButton(SecAdmin, "💥 FLING / Destruir (Físico Real)", function()
    for _, p in pairs(GetTargetPlayers()) do
        PerformFling(p)
    end
end)

CreateButton(SecAdmin, "🌀 Teleport hacia él", function()
    for _, p in pairs(GetTargetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
            end
            break
        end
    end
end)

----------------------------------------------------
--- MI JUGADOR
----------------------------------------------------

CreateToggle(SecPlayer, "🛡️ Modo God (Inmunidad)", function(state)
    States.GodMode = state
end)

CreateSlider(SecPlayer, "Velocidad Caminar", 16, 500, 16, function(v) States.Speed = v end)
CreateSlider(SecPlayer, "Poder de Salto", 50, 1000, 50, function(v) States.Jump = v end)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = States.Speed
        if hum.UseJumpPower then
            hum.JumpPower = States.Jump
        else
            hum.JumpHeight = (States.Jump / 7)
        end
        if States.GodMode then
            hum.Health = hum.MaxHealth
        end
    end
end)

----------------------------------------------------
--- MOVIMIENTO
----------------------------------------------------

local flyVelo
CreateToggle(SecMovement, "Vuelo (Fly)", function(state)
    States.Fly = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if state then
        flyVelo = Instance.new("BodyVelocity")
        flyVelo.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyVelo.Velocity = Vector3.new(0, 0, 0)
        flyVelo.Parent = root

        task.spawn(function()
            while States.Fly and char and root and flyVelo and flyVelo.Parent do
                local dir = Vector3.new(0, 0, 0)
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    dir = hum.MoveDirection * States.FlySpeed
                    if hum.Jump then
                        dir = dir + Vector3.new(0, States.FlySpeed, 0)
                    end
                end
                flyVelo.Velocity = dir
                RunService.RenderStepped:Wait()
            end
        end)
    else
        if flyVelo then
            flyVelo:Destroy()
            flyVelo = nil
        end
    end
end)

CreateSlider(SecMovement, "Velocidad Vuelo", 10, 300, 50, function(v) States.FlySpeed = v end)
CreateToggle(SecMovement, "Noclip (Paredes)", function(state) States.Noclip = state end)

RunService.Stepped:Connect(function()
    if States.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

----------------------------------------------------
--- VISUALES
----------------------------------------------------

local function CreateESPBox(player)
    if player == LocalPlayer then return end
    local function addBox(char)
        if espBoxes[player] then espBoxes[player]:Destroy() end
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if root then
            local Box = Instance.new("BoxHandleAdornment")
            Box.Size = Vector3.new(4, 5.5, 4)
            Box.Color3 = Color3.fromRGB(255, 0, 0)
            Box.AlwaysOnTop = true
            Box.ZIndex = 6
            Box.Transparency = 0.4
            Box.Adornee = root
            Box.Parent = ScreenGui
            espBoxes[player] = Box
        end
    end
    if player.Character then addBox(player.Character) end
    player.CharacterAdded:Connect(addBox)
end

local function CreateESPName(player)
    if player == LocalPlayer then return end
    local function addNameTag(char)
        if espNames[player] then espNames[player]:Destroy() end
        local head = char:WaitForChild("Head", 5)
        if head then
            local Billboard = Instance.new("BillboardGui")
            Billboard.Name = "ESPNameTag"
            Billboard.Adornee = head
            Billboard.Size = UDim2.new(0, 150, 0, 30)
            Billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            Billboard.AlwaysOnTop = true
            Billboard.Parent = ScreenGui

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = player.DisplayName .. " (@" .. player.Name .. ")"
            Label.TextColor3 = Color3.fromRGB(0, 255, 150)
            Label.TextStrokeTransparency = 0
            Label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 13
            Label.Parent = Billboard

            espNames[player] = Billboard
        end
    end
    if player.Character then addNameTag(player.Character) end
    player.CharacterAdded:Connect(addNameTag)
end

CreateToggle(SecVisuals, "ESP Cuadrado Rojo", function(state)
    States.ESPBox = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do CreateESPBox(p) end
        Players.PlayerAdded:Connect(CreateESPBox)
    else
        for _, box in pairs(espBoxes) do box:Destroy() end
        espBoxes = {}
    end
end)

CreateToggle(SecVisuals, "ESP Jugadores (Nombres)", function(state)
    States.ESPName = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do CreateESPName(p) end
        Players.PlayerAdded:Connect(CreateESPName)
    else
        for _, tag in pairs(espNames) do tag:Destroy() end
        espNames = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if States.ESPName and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LocalPlayer.Character.HumanoidRootPart
        for player, tag in pairs(espNames) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and tag:FindFirstChildOfClass("TextLabel") then
                local dist = math.floor((myRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                tag.TextLabel.Text = player.DisplayName .. " [" .. dist .. "m]"
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if espBoxes[p] then espBoxes[p]:Destroy() espBoxes[p] = nil end
    if espNames[p] then espNames[p]:Destroy() espNames[p] = nil end
end)
