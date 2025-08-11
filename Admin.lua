-- La base del script de Delta
-- Empieza por conseguir tu personaje y su 'Humanoid'
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

-- *** NUEVAS FUNCIONES DE CONTROL ***

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
        targetPlayer.Character.Humanoid.WalkSpeed = 16 -- La velocidad por defecto.
        targetPlayer.Character.Humanoid.JumpPower = 50 -- El salto por defecto.
        print(targetPlayer.Name .. " ha sido descongelado.")
    else
        print("Jugador no encontrado.")
    end
end

-- La varita mágica para activar tus poderes con comandos de chat
player.Chatted:Connect(function(message)
    local args = message:split(" ")
    local command = args[1]:lower()
    local targetName = args[2]
    local targetPlayer = game.Players:FindFirstChild(targetName)

    if command == "!fly" then
        toggleFly()
    elseif command == "!noclip" then
        toggleNoclip()
    elseif command == "!speed" then
        toggleSpeedHack()
    elseif command == "!jump" then
        toggleSuperJump()
    elseif command == "!invis" then
        toggleInvisibility()
    elseif command == "!tp" and #args == 4 then
        teleportPlayer(tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
    elseif command == "!freeze" then
        freezePlayer(targetPlayer)
    elseif command == "!unfreeze" then
        unfreezePlayer(targetPlayer)
    end
end)
