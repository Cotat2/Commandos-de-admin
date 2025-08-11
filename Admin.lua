-- La base del script
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Tus poderes y estados
local isFlying = false
local isInvisible = false
local defaultWalkSpeed = humanoid.WalkSpeed
local defaultJumpPower = humanoid.JumpPower

-- La función para volar.
local function toggleFly()
    isFlying = not isFlying
    if isFlying then
        humanoid.PlatformStand = true
        humanoid.Sit = false
        game.Workspace.Gravity = 0
    else
        humanoid.PlatformStand = false
        game.Workspace.Gravity = 196.2
    end
end

-- El "noclip" para atravesar objetos.
local function toggleNoclip()
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(character) then
            part.CanCollide = not part.CanCollide
        end
    end
end

-- Un poder para ser veloz.
local function toggleSpeedHack()
    if humanoid.WalkSpeed == defaultWalkSpeed then
        humanoid.WalkSpeed = 100
        print("Súper velocidad activada!")
    else
        humanoid.WalkSpeed = defaultWalkSpeed
        print("Súper velocidad desactivada!")
    end
end

-- El poder de teletransportarte.
local function teleportPlayer(x, y, z)
    rootPart.CFrame = CFrame.new(x, y, z)
    print("Teletransportado a:", x, y, z)
end

-- Un super salto.
local function toggleSuperJump()
    if humanoid.JumpPower == defaultJumpPower then
        humanoid.JumpPower = 150
        print("Super Salto activado!")
    else
        humanoid.JumpPower = defaultJumpPower
        print("Super Salto desactivado!")
    end
end

-- El poder de ser invisible.
local function toggleInvisibility()
    isInvisible = not isInvisible
    local transparencyValue = isInvisible and 1 or 0
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = transparencyValue
        end
    end
end

-- El poder de congelar a un jugador.
local function freezePlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        targetPlayer.Character.Humanoid.WalkSpeed = 0
        targetPlayer.Character.Humanoid.JumpPower = 0
        print(targetPlayer.Name .. " ha sido congelado.")
    else
        print("Jugador no encontrado.")
    end
end

-- El poder de descongelar a un jugador.
local function unfreezePlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        targetPlayer.Character.Humanoid.WalkSpeed = 16
        targetPlayer.Character.Humanoid.JumpPower = 50
        print(targetPlayer.Name .. " ha sido descongelado.")
    else
        print("Jugador no encontrado.")
    end
end

-- *** CÓDIGO DE LA INTERFAZ GRÁFICA (UI) ***
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PanelDeControlAdmin"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MenuPrincipal"
mainFrame.Size = UDim2.new(0, 200, 0, 300)
mainFrame.Position = UDim2.new(0, 60, 0.5, -150)
mainFrame.AnchorPoint = Vector2.new(0, 0.5)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderColor3 = Color3.new(0, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.Visible = true -- Ahora el menú está visible por defecto

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "BotonDeToggle"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0.5, -20)
toggleButton.AnchorPoint = Vector2.new(0, 0.5)
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleButton.BorderColor3 = Color3.new(0, 0, 0)
toggleButton.CornerRadius = UDim.new(0, 20)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "O"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = mainFrame

local function createButton(text, clickFunction)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    button.BorderColor3 = Color3.new(0, 0, 0)
    button.Font = Enum.Font.SourceSansBold
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Parent = mainFrame
    button.MouseButton1Click:Connect(clickFunction)
    return button
end

local flyButton = createButton("Fly", toggleFly)
local noclipButton = createButton("Noclip", toggleNoclip)
local speedButton = createButton("Speed", toggleSpeedHack)
local jumpButton = createButton("Jump", toggleSuperJump)
local invisButton = createButton("Invisibility", toggleInvisibility)

local playerInput = Instance.new("TextBox")
playerInput.PlaceholderText = "Nombre del Jugador"
playerInput.Size = UDim2.new(1, 0, 0, 30)
playerInput.Parent = mainFrame

local freezeButton = createButton("Freeze", function()
    local targetName = playerInput.Text
    local targetPlayer = game.Players:FindFirstChild(targetName)
    freezePlayer(targetPlayer)
end)

local unfreezeButton = createButton("Unfreeze", function()
    local targetName = playerInput.Text
    local targetPlayer = game.Players:FindFirstChild(targetName)
    unfreezePlayer(targetPlayer)
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

**print("El panel de admin ha sido forzado a mostrarse.")**
