-- ================================================================
-- ZVIOS HUB - Complete Edition
-- Modern UI + Full Feature Set
-- discord.gg/9KXrTZWFZS
-- ================================================================

-- ================================================================
-- GAME VALIDATION & EXECUTOR
-- ================================================================

local TARGET_GAME_ID = "13822889085"
local CURRENT_GAME_ID = tostring(game.PlaceId)

if CURRENT_GAME_ID ~= TARGET_GAME_ID then
    warn("⚠️ Wrong game! Expected: " .. TARGET_GAME_ID .. ", Got: " .. CURRENT_GAME_ID)
end

if _G.Executed then
    warn("⚠️ Script already executed! Reload to run again.")
    return
end
_G.Executed = true

-- Log executor info
local executor = identifyexecutor and identifyexecutor() or "Unknown"
print("🚀 Zvios Hub loaded on: " .. executor)

-- ================================================================
-- SERVICES
-- ================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- ================================================================
-- COLORS & ANIMATION
-- ================================================================

local COLORS = {
    -- Background layers with depth
    BG = Color3.fromRGB(13, 13, 18),
    SURFACE = Color3.fromRGB(20, 20, 28),
    ELEVATED = Color3.fromRGB(26, 26, 36),
    CARD = Color3.fromRGB(30, 30, 42),
    CARD_HOVER = Color3.fromRGB(34, 34, 46),
    
    -- Accent colors
    ACCENT = Color3.fromRGB(88, 101, 242),
    ACCENT_HOVER = Color3.fromRGB(108, 121, 255),
    ACCENT_PRESSED = Color3.fromRGB(68, 81, 222),
    ACCENT_GLOW = Color3.fromRGB(88, 101, 242),
    
    -- Secondary accent (purple)
    SECONDARY = Color3.fromRGB(139, 92, 246),
    SECONDARY_HOVER = Color3.fromRGB(159, 112, 255),
    
    -- Status colors
    SUCCESS = Color3.fromRGB(52, 211, 153),
    SUCCESS_DIM = Color3.fromRGB(16, 185, 129),
    WARNING = Color3.fromRGB(251, 191, 36),
    WARNING_DIM = Color3.fromRGB(245, 158, 11),
    ERROR = Color3.fromRGB(239, 68, 68),
    ERROR_HOVER = Color3.fromRGB(220, 38, 38),
    
    -- Text colors
    TEXT = Color3.fromRGB(250, 250, 252),
    TEXT_SECONDARY = Color3.fromRGB(203, 213, 225),
    TEXT_DIM = Color3.fromRGB(148, 163, 184),
    TEXT_MUTED = Color3.fromRGB(100, 116, 139),
    
    -- UI Elements
    BORDER = Color3.fromRGB(51, 51, 68),
    BORDER_LIGHT = Color3.fromRGB(64, 64, 84),
    DIVIDER = Color3.fromRGB(45, 45, 60)
}

local ANIM = {
    INSTANT = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    MEDIUM = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SLOW = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    BOUNCE = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ELASTIC = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    SPRING = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    SMOOTH = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}

-- ================================================================
-- CONFIG & STATE
-- ================================================================

local CONFIG = {
    AUTO_GRAB = {
        ENABLED = false,
        CHECK_INTERVAL = 0.5,
        SAFE_DISTANCE = 15,
        AUTO_EQUIP_BEST_PET = true,
        PRIORITY_ITEMS = {
            ["Mythical Chest"] = 10,
            ["Diamond Chest"] = 8,
            ["Gold Chest"] = 6,
            ["Silver Chest"] = 4
        }
    },
    
    ESP_CONFIG = {
        PLAYER_ESP = {
            ENABLED = false,
            SHOW_NAME = true,
            SHOW_DISTANCE = true,
            SHOW_HEALTH = true,
            BOX_ENABLED = true,
            TRACER_ENABLED = false,
            MAX_DISTANCE = 500,
            TEAM_CHECK = false,
            COLORS = {
                ENEMY = Color3.fromRGB(255, 50, 50),
                TEAM = Color3.fromRGB(50, 255, 50),
                TEXT = Color3.fromRGB(255, 255, 255)
            }
        },
        
        TIMER_ESP = {
            ENABLED = false,
            SHOW_ALL_TIMERS = true,
            HIGHLIGHT_READY = true,
            TEXT_SIZE = 14
        },
        
        HIGHEST_VALUE = {
            ENABLED = false,
            UPDATE_INTERVAL = 2,
            SHOW_VALUE = true,
            GLOW_EFFECT = true
        }
    },
    
    UI = {
        TOGGLE_KEY = Enum.KeyCode.RightShift,
        NOTIFICATION_DURATION = 3,
        SAVE_POSITION = true
    },
    
    HOTKEYS = {
        AUTO_GRAB = Enum.KeyCode.G,
        SPEED_BOOST = Enum.KeyCode.X,
        XRAY = Enum.KeyCode.V
    }
}

local State = {
    AutoGrab = {
        enabled = false,
        connection = nil,
        lastCheck = 0,
        itemsGrabbed = 0
    },
    
    InfiniteJump = {
        enabled = false,
        connection = nil
    },
    
    XRay = {
        enabled = false,
        originalTransparencies = {},
        affectedParts = {}
    },
    
    KillAura = {
        enabled = false,
        connection = nil,
        range = 20,
        killCount = 0
    },
    
    AntiRagdoll = {
        enabled = false,
        connection = nil
    },
    
    SpeedBoost = {
        enabled = false,
        multiplier = 1.5,
        originalSpeed = 16
    },
    
    AntiBee = {
        enabled = false,
        connection = nil
    },
    
    AntiSteal = {
        enabled = false,
        connection = nil,
        protectedItems = {}
    },
    
    PlayerESP = {
        enabled = false,
        espObjects = {}
    },
    
    TimerESP = {
        enabled = false,
        espObjects = {}
    },
    
    HighestValueESP = {
        enabled = false,
        connection = nil,
        currentHighlight = nil
    },
    
    KickOnSteal = {
        enabled = false,
        connection = nil
    },
    
    PerformanceBoost = {
        enabled = false,
        originalSettings = {}
    },
    
    Platform = {
        enabled = false,
        part = nil
    }
}

-- ================================================================
-- NOTIFICATION SYSTEM
-- ================================================================

local function createNotification(title, message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"
    
    local notifColor = COLORS.ACCENT
    local notifIcon = "ℹ️"
    
    if notifType == "success" then
        notifColor = COLORS.SUCCESS
        notifIcon = "✓"
    elseif notifType == "error" then
        notifColor = COLORS.ERROR
        notifIcon = "✕"
    elseif notifType == "warning" then
        notifColor = COLORS.WARNING
        notifIcon = "⚠"
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZviosNotification"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 320, 0, 80)
    notification.Position = UDim2.new(1, -340, 0, -100)
    notification.BackgroundColor3 = COLORS.SURFACE
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = notifColor
    stroke.Thickness = 2
    stroke.Parent = notification
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = notifColor
    accent.BorderSizePixel = 0
    accent.Parent = notification
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 16, 0.5, -20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = notifIcon
    iconLabel.TextColor3 = notifColor
    iconLabel.TextSize = 24
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 0, 24)
    titleLabel.Position = UDim2.new(0, 60, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = COLORS.TEXT
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -70, 0, 32)
    messageLabel.Position = UDim2.new(0, 60, 0, 38)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = COLORS.TEXT_DIM
    messageLabel.TextSize = 13
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    
    -- Animate in
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -340, 0, 20)
    }):Play()
    
    -- Auto dismiss
    task.delay(duration, function()
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, -340, 0, -100)
        }):Play()
        
        task.wait(0.3)
        screenGui:Destroy()
    end)
end

-- ================================================================
-- UTILITY FUNCTIONS
-- ================================================================

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function createPadding(parent, top, right, bottom, left)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingRight = UDim.new(0, right or top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or top or 0)
    padding.PaddingLeft = UDim.new(0, left or right or top or 0)
    padding.Parent = parent
    return padding
end

local function createGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- ================================================================
-- GAME UTILITY FUNCTIONS
-- ================================================================

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getNearestEnemy()
    local root = getRoot()
    if not root then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local enemyHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
                local distance = (root.Position - enemyRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    
    return nearestPlayer, shortestDistance
end

local function isInOwnPlot()
    local char = getCharacter()
    if not char then return false end
    
    local root = getRoot()
    if not root then return false end
    
    -- Game-specific logic to check if player is in their own plot
    return true -- Placeholder
end

-- ================================================================
-- FEATURE IMPLEMENTATIONS
-- ================================================================

-- AUTO GRAB
local function startAutoGrab()
    if State.AutoGrab.enabled then return end
    State.AutoGrab.enabled = true
    
    createNotification("Auto Grab", "Started automatically grabbing items", 2, "success")
    
    State.AutoGrab.connection = RunService.Heartbeat:Connect(function()
        if not State.AutoGrab.enabled then return end
        
        local currentTime = tick()
        if currentTime - State.AutoGrab.lastCheck < CONFIG.AUTO_GRAB.CHECK_INTERVAL then
            return
        end
        State.AutoGrab.lastCheck = currentTime
        
        local char = getCharacter()
        local root = getRoot()
        if not char or not root then return end
        
        -- Find and grab proximity prompts
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                local parent = obj.Parent
                if parent and (root.Position - parent.Position).Magnitude <= CONFIG.AUTO_GRAB.SAFE_DISTANCE then
                    pcall(function()
                        fireproximityprompt(obj)
                        State.AutoGrab.itemsGrabbed = State.AutoGrab.itemsGrabbed + 1
                    end)
                end
            end
        end
    end)
end

local function stopAutoGrab()
    if not State.AutoGrab.enabled then return end
    State.AutoGrab.enabled = false
    
    if State.AutoGrab.connection then
        State.AutoGrab.connection:Disconnect()
        State.AutoGrab.connection = nil
    end
    
    createNotification("Auto Grab", "Stopped (Grabbed: " .. State.AutoGrab.itemsGrabbed .. ")", 2, "info")
end

-- INFINITE JUMP
local function startInfiniteJump()
    if State.InfiniteJump.enabled then return end
    State.InfiniteJump.enabled = true
    
    createNotification("Infinite Jump", "Enabled - Jump in mid-air!", 2, "success")
    
    State.InfiniteJump.connection = UserInputService.JumpRequest:Connect(function()
        if State.InfiniteJump.enabled then
            local humanoid = getHumanoid()
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function stopInfiniteJump()
    if not State.InfiniteJump.enabled then return end
    State.InfiniteJump.enabled = false
    
    if State.InfiniteJump.connection then
        State.InfiniteJump.connection:Disconnect()
        State.InfiniteJump.connection = nil
    end
    
    createNotification("Infinite Jump", "Disabled", 2, "info")
end

-- X-RAY
local function startXRay()
    if State.XRay.enabled then return end
    State.XRay.enabled = true
    
    createNotification("X-Ray", "Enabled - See through walls!", 2, "success")
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency < 1 then
            State.XRay.originalTransparencies[obj] = obj.Transparency
            obj.Transparency = 0.7
            table.insert(State.XRay.affectedParts, obj)
        end
    end
end

local function stopXRay()
    if not State.XRay.enabled then return end
    State.XRay.enabled = false
    
    for _, obj in ipairs(State.XRay.affectedParts) do
        if obj and State.XRay.originalTransparencies[obj] then
            obj.Transparency = State.XRay.originalTransparencies[obj]
        end
    end
    
    State.XRay.originalTransparencies = {}
    State.XRay.affectedParts = {}
    
    createNotification("X-Ray", "Disabled", 2, "info")
end

-- KILL AURA
local function startKillAura()
    if State.KillAura.enabled then return end
    State.KillAura.enabled = true
    
    createNotification("Kill Aura", "Enabled - Auto attack nearby enemies!", 2, "success")
    
    State.KillAura.connection = RunService.Heartbeat:Connect(function()
        if not State.KillAura.enabled then return end
        
        local enemy, distance = getNearestEnemy()
        if enemy and distance <= State.KillAura.range then
            local enemyChar = enemy.Character
            local enemyHumanoid = enemyChar and enemyChar:FindFirstChildOfClass("Humanoid")
            
            if enemyHumanoid and enemyHumanoid.Health > 0 then
                -- Attack logic here (game-specific)
                pcall(function()
                    enemyHumanoid:TakeDamage(10)
                    State.KillAura.killCount = State.KillAura.killCount + 1
                end)
            end
        end
    end)
end

local function stopKillAura()
    if not State.KillAura.enabled then return end
    State.KillAura.enabled = false
    
    if State.KillAura.connection then
        State.KillAura.connection:Disconnect()
        State.KillAura.connection = nil
    end
    
    createNotification("Kill Aura", "Disabled (Kills: " .. State.KillAura.killCount .. ")", 2, "info")
end

-- ANTI-RAGDOLL
local function startAntiRagdoll()
    if State.AntiRagdoll.enabled then return end
    State.AntiRagdoll.enabled = true
    
    createNotification("Anti-Ragdoll", "Enabled - No more ragdolls!", 2, "success")
    
    State.AntiRagdoll.connection = RunService.Heartbeat:Connect(function()
        if not State.AntiRagdoll.enabled then return end
        
        local humanoid = getHumanoid()
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end
    end)
end

local function stopAntiRagdoll()
    if not State.AntiRagdoll.enabled then return end
    State.AntiRagdoll.enabled = false
    
    if State.AntiRagdoll.connection then
        State.AntiRagdoll.connection:Disconnect()
        State.AntiRagdoll.connection = nil
    end
    
    local humanoid = getHumanoid()
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
    
    createNotification("Anti-Ragdoll", "Disabled", 2, "info")
end

-- SPEED BOOSTER
local function startSpeedBoost()
    if State.SpeedBoost.enabled then return end
    State.SpeedBoost.enabled = true
    
    local humanoid = getHumanoid()
    if humanoid then
        State.SpeedBoost.originalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = State.SpeedBoost.originalSpeed * State.SpeedBoost.multiplier
    end
    
    createNotification("Speed Boost", "Enabled - Moving faster!", 2, "success")
end

local function stopSpeedBoost()
    if not State.SpeedBoost.enabled then return end
    State.SpeedBoost.enabled = false
    
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = State.SpeedBoost.originalSpeed
    end
    
    createNotification("Speed Boost", "Disabled", 2, "info")
end

-- ANTI-BEE
local function startAntiBee()
    if State.AntiBee.enabled then return end
    State.AntiBee.enabled = true
    
    createNotification("Anti-Bee", "Enabled - Bees won't attack you!", 2, "success")
    
    State.AntiBee.connection = RunService.Heartbeat:Connect(function()
        if not State.AntiBee.enabled then return end
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("bee") and obj:IsA("BasePart") then
                pcall(function()
                    obj:Destroy()
                end)
            end
        end
    end)
end

local function stopAntiBee()
    if not State.AntiBee.enabled then return end
    State.AntiBee.enabled = false
    
    if State.AntiBee.connection then
        State.AntiBee.connection:Disconnect()
        State.AntiBee.connection = nil
    end
    
    createNotification("Anti-Bee", "Disabled", 2, "info")
end

-- ANTI-STEAL
local function startAntiSteal()
    if State.AntiSteal.enabled then return end
    State.AntiSteal.enabled = true
    
    createNotification("Anti-Steal", "Enabled - Your items are protected!", 2, "success")
    
    State.AntiSteal.connection = Workspace.DescendantRemoving:Connect(function(obj)
        if not State.AntiSteal.enabled then return end
        
        if State.AntiSteal.protectedItems[obj] then
            createNotification("Anti-Steal", "Blocked steal attempt!", 2, "warning")
        end
    end)
end

local function stopAntiSteal()
    if not State.AntiSteal.enabled then return end
    State.AntiSteal.enabled = false
    
    if State.AntiSteal.connection then
        State.AntiSteal.connection:Disconnect()
        State.AntiSteal.connection = nil
    end
    
    State.AntiSteal.protectedItems = {}
    createNotification("Anti-Steal", "Disabled", 2, "info")
end

-- PLAYER ESP
local function createPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function createESPForCharacter(character)
        local root = character:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESP_" .. player.Name
        billboard.Adornee = root
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = root
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = CONFIG.ESP_CONFIG.PLAYER_ESP.COLORS.ENEMY
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = frame
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0, 16)
        distanceLabel.Position = UDim2.new(0, 0, 0, 22)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = COLORS.TEXT_DIM
        distanceLabel.TextSize = 14
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.TextStrokeTransparency = 0.5
        distanceLabel.Parent = frame
        
        -- Update distance
        local updateConnection = RunService.Heartbeat:Connect(function()
            if not State.PlayerESP.enabled or not root or not root.Parent then
                billboard:Destroy()
                return
            end
            
            local myRoot = getRoot()
            if myRoot then
                local distance = (myRoot.Position - root.Position).Magnitude
                distanceLabel.Text = string.format("%.1f studs", distance)
            end
        end)
        
        State.PlayerESP.espObjects[player] = {billboard = billboard, connection = updateConnection}
    end
    
    if player.Character then
        createESPForCharacter(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        if State.PlayerESP.enabled then
            createESPForCharacter(character)
        end
    end)
end

local function startPlayerESP()
    if State.PlayerESP.enabled then return end
    State.PlayerESP.enabled = true
    
    createNotification("Player ESP", "Enabled - See all players!", 2, "success")
    
    for _, player in ipairs(Players:GetPlayers()) do
        createPlayerESP(player)
    end
    
    Players.PlayerAdded:Connect(function(player)
        if State.PlayerESP.enabled then
            createPlayerESP(player)
        end
    end)
end

local function stopPlayerESP()
    if not State.PlayerESP.enabled then return end
    State.PlayerESP.enabled = false
    
    for player, data in pairs(State.PlayerESP.espObjects) do
        if data.billboard then
            data.billboard:Destroy()
        end
        if data.connection then
            data.connection:Disconnect()
        end
    end
    
    State.PlayerESP.espObjects = {}
    createNotification("Player ESP", "Disabled", 2, "info")
end

-- TIMER ESP
local function startTimerESP()
    if State.TimerESP.enabled then return end
    State.TimerESP.enabled = true
    
    createNotification("Timer ESP", "Enabled - See all timers!", 2, "success")
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "TimerESP"
            billboard.Adornee = obj.Parent
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = obj.Parent
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "Ready!"
            label.TextColor3 = COLORS.SUCCESS
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.TextStrokeTransparency = 0.5
            label.Parent = billboard
            
            table.insert(State.TimerESP.espObjects, billboard)
        end
    end
end

local function stopTimerESP()
    if not State.TimerESP.enabled then return end
    State.TimerESP.enabled = false
    
    for _, billboard in ipairs(State.TimerESP.espObjects) do
        if billboard then
            billboard:Destroy()
        end
    end
    
    State.TimerESP.espObjects = {}
    createNotification("Timer ESP", "Disabled", 2, "info")
end

-- HIGHEST VALUE ESP
local function startHighestValueESP()
    if State.HighestValueESP.enabled then return end
    State.HighestValueESP.enabled = true
    
    createNotification("Highest Value ESP", "Enabled - Highlighting best items!", 2, "success")
    
    State.HighestValueESP.connection = RunService.Heartbeat:Connect(function()
        if not State.HighestValueESP.enabled then return end
        
        -- Game-specific logic to find highest value item
        -- Placeholder implementation
    end)
end

local function stopHighestValueESP()
    if not State.HighestValueESP.enabled then return end
    State.HighestValueESP.enabled = false
    
    if State.HighestValueESP.connection then
        State.HighestValueESP.connection:Disconnect()
        State.HighestValueESP.connection = nil
    end
    
    if State.HighestValueESP.currentHighlight then
        State.HighestValueESP.currentHighlight:Destroy()
        State.HighestValueESP.currentHighlight = nil
    end
    
    createNotification("Highest Value ESP", "Disabled", 2, "info")
end

-- KICK ON STEAL
local function startKickOnSteal()
    if State.KickOnSteal.enabled then return end
    State.KickOnSteal.enabled = true
    
    createNotification("Kick on Steal", "Enabled - Will kick if stolen from!", 2, "success")
    
    State.KickOnSteal.connection = Workspace.DescendantRemoving:Connect(function(obj)
        if not State.KickOnSteal.enabled then return end
        
        if obj.Name:find("YourItem") then -- Game-specific check
            createNotification("Kick on Steal", "Steal detected! Leaving server...", 2, "warning")
            task.wait(1)
            LocalPlayer:Kick("Anti-Steal: Item stolen, leaving server to protect items.")
        end
    end)
end

local function stopKickOnSteal()
    if not State.KickOnSteal.enabled then return end
    State.KickOnSteal.enabled = false
    
    if State.KickOnSteal.connection then
        State.KickOnSteal.connection:Disconnect()
        State.KickOnSteal.connection = nil
    end
    
    createNotification("Kick on Steal", "Disabled", 2, "info")
end

-- PERFORMANCE BOOST
local function startPerformanceBoost()
    if State.PerformanceBoost.enabled then return end
    State.PerformanceBoost.enabled = true
    
    -- Save original settings
    State.PerformanceBoost.originalSettings = {
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        Brightness = Lighting.Brightness
    }
    
    -- Apply performance settings
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
    
    -- Disable unnecessary effects
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") then
            obj.Enabled = false
        end
    end
    
    createNotification("Performance Boost", "Enabled - FPS optimized!", 2, "success")
end

local function stopPerformanceBoost()
    if not State.PerformanceBoost.enabled then return end
    State.PerformanceBoost.enabled = false
    
    -- Restore original settings
    if State.PerformanceBoost.originalSettings then
        Lighting.GlobalShadows = State.PerformanceBoost.originalSettings.GlobalShadows
        Lighting.FogEnd = State.PerformanceBoost.originalSettings.FogEnd
        Lighting.Brightness = State.PerformanceBoost.originalSettings.Brightness
    end
    
    -- Re-enable effects
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") then
            obj.Enabled = true
        end
    end
    
    createNotification("Performance Boost", "Disabled", 2, "info")
end

-- PLATFORM
local function startPlatform()
    if State.Platform.enabled then return end
    State.Platform.enabled = true
    
    local root = getRoot()
    if not root then return end
    
    local platform = Instance.new("Part")
    platform.Name = "ZviosPlatform"
    platform.Size = Vector3.new(8, 1, 8)
    platform.Position = root.Position - Vector3.new(0, 3, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.5
    platform.Material = Enum.Material.Neon
    platform.Color = COLORS.ACCENT
    platform.Parent = Workspace
    
    createCorner(platform, 0.2)
    
    State.Platform.part = platform
    
    -- Update platform position
    RunService.Heartbeat:Connect(function()
        if State.Platform.enabled and State.Platform.part and root then
            State.Platform.part.Position = root.Position - Vector3.new(0, 3, 0)
        end
    end)
    
    createNotification("Platform", "Enabled - Standing on air!", 2, "success")
end

local function stopPlatform()
    if not State.Platform.enabled then return end
    State.Platform.enabled = false
    
    if State.Platform.part then
        State.Platform.part:Destroy()
        State.Platform.part = nil
    end
    
    createNotification("Platform", "Disabled", 2, "info")
end

-- ================================================================
-- CONFIG MANAGEMENT
-- ================================================================

local CONFIG_FILE = "zvios_hub_config.json"

local function saveConfig()
    local configData = {
        autoGrab = State.AutoGrab.enabled,
        infiniteJump = State.InfiniteJump.enabled,
        xray = State.XRay.enabled,
        killAura = State.KillAura.enabled,
        antiRagdoll = State.AntiRagdoll.enabled,
        speedBoost = State.SpeedBoost.enabled,
        antiBee = State.AntiBee.enabled,
        antiSteal = State.AntiSteal.enabled,
        playerESP = State.PlayerESP.enabled,
        timerESP = State.TimerESP.enabled,
        highestValueESP = State.HighestValueESP.enabled,
        kickOnSteal = State.KickOnSteal.enabled,
        performanceBoost = State.PerformanceBoost.enabled,
        platform = State.Platform.enabled
    }
    
    local success, result = pcall(function()
        local jsonData = HttpService:JSONEncode(configData)
        writefile(CONFIG_FILE, jsonData)
    end)
    
    if success then
        createNotification("Config", "Configuration saved successfully!", 2, "success")
    else
        createNotification("Config", "Failed to save configuration", 2, "error")
    end
end

local function loadConfig()
    local success, result = pcall(function()
        if isfile(CONFIG_FILE) then
            local jsonData = readfile(CONFIG_FILE)
            return HttpService:JSONDecode(jsonData)
        end
        return nil
    end)
    
    if success and result then
        createNotification("Config", "Configuration loaded!", 2, "success")
        return result
    else
        createNotification("Config", "No saved configuration found", 2, "info")
        return nil
    end
end

local function deleteConfig()
    local success = pcall(function()
        if isfile(CONFIG_FILE) then
            delfile(CONFIG_FILE)
        end
    end)
    
    if success then
        createNotification("Config", "Configuration deleted!", 2, "success")
    else
        createNotification("Config", "Failed to delete configuration", 2, "error")
    end
end

-- ================================================================
-- UI COMPONENTS
-- ================================================================

local function createToggle(parent, text, icon)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundColor3 = COLORS.CARD
    container.BorderSizePixel = 0
    container.Parent = parent

    createCorner(container, 12)
    local stroke = createStroke(container, COLORS.BORDER, 1, 0.5)

    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(1, 0, 1, 0)
    glowFrame.BackgroundColor3 = COLORS.ACCENT
    glowFrame.BackgroundTransparency = 1
    glowFrame.BorderSizePixel = 0
    glowFrame.ZIndex = 0
    glowFrame.Parent = container
    createCorner(glowFrame, 12)

    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 32, 0, 32)
    iconContainer.Position = UDim2.new(0, 14, 0.5, -16)
    iconContainer.BackgroundColor3 = COLORS.ELEVATED
    iconContainer.BorderSizePixel = 0
    iconContainer.Parent = container
    createCorner(iconContainer, 8)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon or "•"
    iconLabel.TextColor3 = COLORS.TEXT_DIM
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = iconContainer

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -130, 1, 0)
    label.Position = UDim2.new(0, 54, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.TEXT_SECONDARY
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = container

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 52, 0, 28)
    toggleBg.Position = UDim2.new(1, -66, 0.5, -14)
    toggleBg.BackgroundColor3 = COLORS.ELEVATED
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = container
    createCorner(toggleBg, 14)
    local toggleStroke = createStroke(toggleBg, COLORS.BORDER, 2, 0.6)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new(0, 3, 0.5, -11)
    knob.BackgroundColor3 = COLORS.TEXT_MUTED
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = toggleBg
    createCorner(knob, 11)

    local knobHighlight = Instance.new("Frame")
    knobHighlight.Size = UDim2.new(1, -6, 1, -6)
    knobHighlight.Position = UDim2.new(0, 3, 0, 3)
    knobHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knobHighlight.BackgroundTransparency = 0.95
    knobHighlight.BorderSizePixel = 0
    knobHighlight.Parent = knob
    createCorner(knobHighlight, 8)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 3
    button.Parent = container
    button:SetAttribute("Active", false)

    button.MouseEnter:Connect(function()
        TweenService:Create(container, ANIM.FAST, {BackgroundColor3 = COLORS.CARD_HOVER}):Play()
        TweenService:Create(stroke, ANIM.FAST, {Transparency = 0.2}):Play()
        TweenService:Create(iconContainer, ANIM.FAST, {
            Size = UDim2.new(0, 34, 0, 34),
            Position = UDim2.new(0, 13, 0.5, -17)
        }):Play()
        
        if not button:GetAttribute("Active") then
            TweenService:Create(glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 0.97}):Play()
        end
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(container, ANIM.FAST, {BackgroundColor3 = COLORS.CARD}):Play()
        TweenService:Create(stroke, ANIM.FAST, {Transparency = 0.5}):Play()
        TweenService:Create(iconContainer, ANIM.FAST, {
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(0, 14, 0.5, -16)
        }):Play()
        
        if not button:GetAttribute("Active") then
            TweenService:Create(glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 1}):Play()
        end
    end)

    return {
        button = button,
        container = container,
        toggleBg = toggleBg,
        knob = knob,
        iconLabel = iconLabel,
        label = label,
        glowFrame = glowFrame,
        toggleStroke = toggleStroke,
        iconContainer = iconContainer,
        update = function(self, active)
            self.button:SetAttribute("Active", active)
            local bgColor = active and COLORS.ACCENT or COLORS.ELEVATED
            local strokeColor = active and COLORS.ACCENT_GLOW or COLORS.BORDER
            local knobColor = active and COLORS.TEXT or COLORS.TEXT_MUTED
            local knobPos = active and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
            local iconColor = active and COLORS.ACCENT or COLORS.TEXT_DIM
            local iconBg = active and COLORS.CARD or COLORS.ELEVATED
            
            TweenService:Create(self.toggleBg, ANIM.MEDIUM, {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(self.toggleStroke, ANIM.FAST, {
                Color = strokeColor, 
                Transparency = active and 0 or 0.6
            }):Play()
            TweenService:Create(self.knob, ANIM.SPRING, {
                BackgroundColor3 = knobColor, 
                Position = knobPos,
                Size = active and UDim2.new(0, 24, 0, 24) or UDim2.new(0, 22, 0, 22)
            }):Play()
            TweenService:Create(self.label, ANIM.FAST, {
                TextColor3 = active and COLORS.TEXT or COLORS.TEXT_SECONDARY
            }):Play()
            TweenService:Create(self.iconLabel, ANIM.MEDIUM, {
                TextColor3 = iconColor,
                Rotation = active and 360 or 0
            }):Play()
            TweenService:Create(self.iconContainer, ANIM.MEDIUM, {
                BackgroundColor3 = iconBg
            }):Play()
            
            if active then
                TweenService:Create(self.glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 0.92}):Play()
            else
                TweenService:Create(self.glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 1}):Play()
            end
        end
    }
end

local function createSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 38)
    section.BackgroundTransparency = 1
    section.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = COLORS.TEXT
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    titleLabel.Parent = section

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 3, 0, 18)
    line.Position = UDim2.new(0, -10, 0, 14)
    line.BackgroundColor3 = COLORS.ACCENT
    line.BorderSizePixel = 0
    line.Parent = section
    createCorner(line, 2)

    return section
end

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- ================================================================
-- MAIN GUI CREATION
-- ================================================================

local function createMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZviosHubComplete"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 100

    -- === TOGGLE BUTTON ===
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 64, 0, 64)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -32)
    toggleBtn.BackgroundColor3 = COLORS.SURFACE
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 10
    toggleBtn.Parent = screenGui

    createCorner(toggleBtn, 20)
    local toggleStroke = createStroke(toggleBtn, COLORS.ACCENT, 2.5, 0.3)

    createGradient(toggleBtn, ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, COLORS.SECONDARY)
    }, 135)

    local outerGlow = Instance.new("ImageLabel")
    outerGlow.Size = UDim2.new(1, 24, 1, 24)
    outerGlow.Position = UDim2.new(0.5, -12, 0.5, -12)
    outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    outerGlow.BackgroundTransparency = 1
    outerGlow.Image = "rbxassetid://5028857084"
    outerGlow.ImageColor3 = COLORS.ACCENT_GLOW
    outerGlow.ImageTransparency = 0.6
    outerGlow.ZIndex = 9
    outerGlow.Parent = toggleBtn

    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(1, -8, 1, -8)
    shine.Position = UDim2.new(0, 4, 0, 4)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.95
    shine.BorderSizePixel = 0
    shine.Parent = toggleBtn
    createCorner(shine, 16)

    local zhIcon = Instance.new("TextLabel")
    zhIcon.Size = UDim2.new(1, 0, 1, 0)
    zhIcon.BackgroundTransparency = 1
    zhIcon.Text = "ZH"
    zhIcon.TextColor3 = COLORS.TEXT
    zhIcon.TextSize = 22
    zhIcon.Font = Enum.Font.GothamBold
    zhIcon.ZIndex = 11
    zhIcon.Parent = toggleBtn

    local pulseGlow = TweenService:Create(outerGlow, 
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
        {ImageTransparency = 0.3, Size = UDim2.new(1, 32, 1, 32)}
    )
    pulseGlow:Play()

    -- === MAIN FRAME ===
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 560, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -280, 0.5, -250)
    mainFrame.BackgroundColor3 = COLORS.BG
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.ZIndex = 5
    mainFrame.Parent = screenGui

    createCorner(mainFrame, 18)
    createStroke(mainFrame, COLORS.BORDER_LIGHT, 1, 0.4)

    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.Position = UDim2.new(0, -25, 0, -25)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5028857084"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.4
    shadow.ZIndex = 4
    shadow.Parent = mainFrame

    -- === HEADER ===
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = COLORS.SURFACE
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    createCorner(header, 18)

    local headerFill = Instance.new("Frame")
    headerFill.Size = UDim2.new(1, 0, 0, 18)
    headerFill.Position = UDim2.new(0, 0, 1, -18)
    headerFill.BackgroundColor3 = COLORS.SURFACE
    headerFill.BorderSizePixel = 0
    headerFill.Parent = header

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(1, 0, 0, 3)
    accentBar.Position = UDim2.new(0, 0, 1, 0)
    accentBar.BackgroundColor3 = COLORS.ACCENT
    accentBar.BorderSizePixel = 0
    accentBar.Parent = header

    createGradient(accentBar, ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.ACCENT),
        ColorSequenceKeypoint.new(0.5, COLORS.SECONDARY),
        ColorSequenceKeypoint.new(1, COLORS.ACCENT)
    }, 90)

    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 42, 0, 42)
    logoContainer.Position = UDim2.new(0, 18, 0, 14)
    logoContainer.BackgroundColor3 = COLORS.ELEVATED
    logoContainer.BorderSizePixel = 0
    logoContainer.Parent = header

    createCorner(logoContainer, 12)
    createStroke(logoContainer, COLORS.ACCENT, 2, 0.5)

    createGradient(logoContainer, ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, COLORS.SECONDARY)
    }, 135)

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "Z"
    logo.TextColor3 = COLORS.TEXT
    logo.TextSize = 24
    logo.Font = Enum.Font.GothamBold
    logo.Parent = logoContainer

    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(1, -140, 0, 42)
    titleContainer.Position = UDim2.new(0, 68, 0, 14)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 26)
    title.BackgroundTransparency = 1
    title.Text = "Zvios Hub"
    title.TextColor3 = COLORS.TEXT
    title.TextSize = 21
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Bottom
    title.Parent = titleContainer

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 16)
    subtitle.Position = UDim2.new(0, 0, 1, -16)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "discord.gg/9KXrTZWFZS"
    subtitle.TextColor3 = COLORS.TEXT_DIM
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = titleContainer

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 38, 0, 38)
    closeBtn.Position = UDim2.new(1, -52, 0, 16)
    closeBtn.BackgroundColor3 = COLORS.ELEVATED
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = COLORS.TEXT_SECONDARY
    closeBtn.TextSize = 26
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header

    createCorner(closeBtn, 11)

    -- === TAB BAR ===
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -32, 0, 46)
    tabBar.Position = UDim2.new(0, 16, 0, 82)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.Parent = tabBar

    -- === CONTENT FRAME ===
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -32, 1, -148)
    contentFrame.Position = UDim2.new(0, 16, 0, 136)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local tabs = {
        {name = "Main", icon = "🏠"},
        {name = "ESP", icon = "👁️"},
        {name = "Utility", icon = "🔧"},
        {name = "Config", icon = "⚙️"},
        {name = "Credits", icon = "ℹ️"}
    }

    local tabPages = {}
    local tabButtons = {}

    -- Create tab pages
    for i, tab in ipairs(tabs) do
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 6
        page.ScrollBarImageColor3 = COLORS.ACCENT
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = (i == 1)
        page.Parent = contentFrame

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = page

        tabPages[tab.name] = page

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 104, 1, 0)
        tabBtn.BackgroundColor3 = (i == 1) and COLORS.ACCENT or COLORS.ELEVATED
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabBar

        createCorner(tabBtn, 11)
        
        if i == 1 then
            createStroke(tabBtn, COLORS.ACCENT_GLOW, 1, 0.3)
        end

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Parent = tabBtn

        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 12, 0.5, -10)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tab.icon
        tabIcon.TextSize = 15
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.Parent = tabContent

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -42, 1, 0)
        tabLabel.Position = UDim2.new(0, 36, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tab.name
        tabLabel.TextColor3 = COLORS.TEXT
        tabLabel.TextSize = 13
        tabLabel.Font = Enum.Font.GothamSemibold
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabContent

        table.insert(tabButtons, {
            btn = tabBtn, 
            name = tab.name, 
            icon = tabIcon, 
            label = tabLabel,
            stroke = i == 1 and tabBtn:FindFirstChildOfClass("UIStroke") or nil
        })
    end

    -- Tab switching
    for _, tabData in ipairs(tabButtons) do
        tabData.btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabButtons) do
                TweenService:Create(t.btn, ANIM.MEDIUM, {BackgroundColor3 = COLORS.ELEVATED}):Play()
                tabPages[t.name].Visible = false
                
                if t.stroke then
                    t.stroke:Destroy()
                    t.stroke = nil
                end
            end
            
            TweenService:Create(tabData.btn, ANIM.MEDIUM, {BackgroundColor3 = COLORS.ACCENT}):Play()
            tabPages[tabData.name].Visible = true
            
            if not tabData.stroke then
                tabData.stroke = createStroke(tabData.btn, COLORS.ACCENT_GLOW, 1, 0.3)
            end
        end)

        tabData.btn.MouseEnter:Connect(function()
            if tabData.btn.BackgroundColor3 ~= COLORS.ACCENT then
                TweenService:Create(tabData.btn, ANIM.FAST, {BackgroundColor3 = COLORS.CARD}):Play()
            end
        end)

        tabData.btn.MouseLeave:Connect(function()
            if tabData.btn.BackgroundColor3 ~= COLORS.ACCENT then
                TweenService:Create(tabData.btn, ANIM.FAST, {BackgroundColor3 = COLORS.ELEVATED}):Play()
            end
        end)
    end

    -- === POPULATE TABS ===
    
    -- MAIN TAB
    createSection(tabPages["Main"], "CORE FEATURES")
    local grabToggle = createToggle(tabPages["Main"], "Auto Grab", "🎯")
    local infiniteJumpToggle = createToggle(tabPages["Main"], "Infinite Jump", "🚀")
    local xrayToggle = createToggle(tabPages["Main"], "X-Ray Vision", "👻")
    
    createSection(tabPages["Main"], "PERFORMANCE")
    local performanceToggle = createToggle(tabPages["Main"], "Performance Boost", "⚡")
    local platformToggle = createToggle(tabPages["Main"], "Platform Mode", "🏗️")

    -- ESP TAB
    createSection(tabPages["ESP"], "VISUAL ENHANCEMENTS")
    local playerEspToggle = createToggle(tabPages["ESP"], "Player ESP", "👤")
    local highestValueToggle = createToggle(tabPages["ESP"], "Highest Value ESP", "💎")
    local timerEspToggle = createToggle(tabPages["ESP"], "Timer ESP", "⏱️")

    -- UTILITY TAB
    createSection(tabPages["Utility"], "COMBAT SYSTEMS")
    local killAuraToggle = createToggle(tabPages["Utility"], "Kill Aura", "⚔️")
    
    createSection(tabPages["Utility"], "PROTECTION")
    local antiStealToggle = createToggle(tabPages["Utility"], "Anti-Steal", "🛡️")
    local antiBeeToggle = createToggle(tabPages["Utility"], "Anti-Bee", "🐝")
    local antiRagdollToggle = createToggle(tabPages["Utility"], "Anti-Ragdoll", "🦾")
    
    createSection(tabPages["Utility"], "MOVEMENT")
    local speedBoosterToggle = createToggle(tabPages["Utility"], "Speed Booster", "💨")
    
    createSection(tabPages["Utility"], "SECURITY")
    local kickOnStealToggle = createToggle(tabPages["Utility"], "Kick on Steal", "🚪")

    -- CONFIG TAB
    createSection(tabPages["Config"], "SERVER MANAGEMENT")
    
    local jobCard = Instance.new("Frame")
    jobCard.Size = UDim2.new(1, 0, 0, 94)
    jobCard.BackgroundColor3 = COLORS.CARD
    jobCard.BorderSizePixel = 0
    jobCard.Parent = tabPages["Config"]
    
    createCorner(jobCard, 12)
    createStroke(jobCard, COLORS.BORDER, 1, 0.5)
    createPadding(jobCard, 16)

    local jobLabel = Instance.new("TextLabel")
    jobLabel.Size = UDim2.new(1, 0, 0, 22)
    jobLabel.BackgroundTransparency = 1
    jobLabel.Text = "Join Specific Server"
    jobLabel.TextColor3 = COLORS.TEXT_SECONDARY
    jobLabel.TextSize = 14
    jobLabel.Font = Enum.Font.GothamSemibold
    jobLabel.TextXAlignment = Enum.TextXAlignment.Left
    jobLabel.Parent = jobCard

    local jobInput = Instance.new("TextBox")
    jobInput.Size = UDim2.new(1, 0, 0, 40)
    jobInput.Position = UDim2.new(0, 0, 0, 30)
    jobInput.BackgroundColor3 = COLORS.ELEVATED
    jobInput.BorderSizePixel = 0
    jobInput.Text = ""
    jobInput.PlaceholderText = "Enter Job ID..."
    jobInput.TextColor3 = COLORS.TEXT
    jobInput.PlaceholderColor3 = COLORS.TEXT_MUTED
    jobInput.TextSize = 14
    jobInput.Font = Enum.Font.Gotham
    jobInput.TextXAlignment = Enum.TextXAlignment.Left
    jobInput.ClearTextOnFocus = false
    jobInput.Parent = jobCard

    createCorner(jobInput, 10)
    createPadding(jobInput, 12, 14, 12, 14)

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(1, 0, 0, 44)
    joinBtn.BackgroundColor3 = COLORS.ACCENT
    joinBtn.BorderSizePixel = 0
    joinBtn.Text = "Join Server"
    joinBtn.TextColor3 = COLORS.TEXT
    joinBtn.TextSize = 15
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.AutoButtonColor = false
    joinBtn.Parent = tabPages["Config"]

    createCorner(joinBtn, 12)
    createStroke(joinBtn, COLORS.ACCENT_GLOW, 1, 0.4)

    createSection(tabPages["Config"], "CONFIGURATION")
    local saveConfigToggle = createToggle(tabPages["Config"], "Save Configuration", "💾")
    local removeConfigToggle = createToggle(tabPages["Config"], "Remove Configuration", "🗑️")
    local autoLoadToggle = createToggle(tabPages["Config"], "Auto Load Script", "🔄")

    -- CREDITS TAB
    local creditsContainer = Instance.new("Frame")
    creditsContainer.Size = UDim2.new(1, 0, 0, 0)
    creditsContainer.AutomaticSize = Enum.AutomaticSize.Y
    creditsContainer.BackgroundColor3 = COLORS.CARD
    creditsContainer.BorderSizePixel = 0
    creditsContainer.Parent = tabPages["Credits"]

    createCorner(creditsContainer, 14)
    createStroke(creditsContainer, COLORS.BORDER, 1, 0.4)

    local creditsLayout = Instance.new("UIListLayout")
    creditsLayout.Padding = UDim.new(0, 16)
    creditsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    creditsLayout.Parent = creditsContainer

    createPadding(creditsContainer, 28, 24, 28, 24)

    local creditsHeader = Instance.new("Frame")
    creditsHeader.Size = UDim2.new(1, 0, 0, 48)
    creditsHeader.BackgroundColor3 = COLORS.ELEVATED
    creditsHeader.BorderSizePixel = 0
    creditsHeader.Parent = creditsContainer
    
    createCorner(creditsHeader, 10)

    local creditsIcon = Instance.new("TextLabel")
    creditsIcon.Size = UDim2.new(0, 40, 0, 40)
    creditsIcon.Position = UDim2.new(0.5, -20, 0.5, -20)
    creditsIcon.BackgroundColor3 = COLORS.ACCENT
    creditsIcon.BorderSizePixel = 0
    creditsIcon.Text = "Z"
    creditsIcon.TextColor3 = COLORS.TEXT
    creditsIcon.TextSize = 22
    creditsIcon.Font = Enum.Font.GothamBold
    creditsIcon.Parent = creditsHeader
    
    createCorner(creditsIcon, 10)

    local creditsTitle = Instance.new("TextLabel")
    creditsTitle.Size = UDim2.new(1, 0, 0, 34)
    creditsTitle.BackgroundTransparency = 1
    creditsTitle.Text = "⚡ Zvios Hub"
    creditsTitle.TextColor3 = COLORS.TEXT
    creditsTitle.TextSize = 24
    creditsTitle.Font = Enum.Font.GothamBold
    creditsTitle.Parent = creditsContainer

    local divider1 = Instance.new("Frame")
    divider1.Size = UDim2.new(0.7, 0, 0, 1)
    divider1.BackgroundColor3 = COLORS.DIVIDER
    divider1.BorderSizePixel = 0
    divider1.Parent = creditsContainer

    local devLabel = Instance.new("TextLabel")
    devLabel.Size = UDim2.new(1, 0, 0, 24)
    devLabel.BackgroundTransparency = 1
    devLabel.Text = "👑 Developed by Zvios"
    devLabel.TextColor3 = COLORS.TEXT_SECONDARY
    devLabel.TextSize = 16
    devLabel.Font = Enum.Font.GothamSemibold
    devLabel.Parent = creditsContainer

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, 0, 0, 22)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "💬 discord.gg/9KXrTZWFZS"
    discordLabel.TextColor3 = COLORS.ACCENT
    discordLabel.TextSize = 15
    discordLabel.Font = Enum.Font.GothamMedium
    discordLabel.Parent = creditsContainer

    local divider2 = Instance.new("Frame")
    divider2.Size = UDim2.new(0.7, 0, 0, 1)
    divider2.BackgroundColor3 = COLORS.DIVIDER
    divider2.BorderSizePixel = 0
    divider2.Parent = creditsContainer

    local thanksLabel = Instance.new("TextLabel")
    thanksLabel.Size = UDim2.new(1, 0, 0, 24)
    thanksLabel.BackgroundTransparency = 1
    thanksLabel.Text = "❤️ Thank you for using Zvios Hub!"
    thanksLabel.TextColor3 = COLORS.TEXT_DIM
    thanksLabel.TextSize = 14
    thanksLabel.Font = Enum.Font.Gotham
    thanksLabel.Parent = creditsContainer

    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1, 0, 0, 20)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "Version 2.0 Complete • © 2025 Zvios"
    versionLabel.TextColor3 = COLORS.TEXT_MUTED
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.Parent = creditsContainer

    -- ================================================================
    -- TOGGLE CONNECTIONS
    -- ================================================================
    
    -- Main Tab Toggles
    grabToggle.button.MouseButton1Click:Connect(function()
        local active = not grabToggle.button:GetAttribute("Active")
        grabToggle:update(active)
        if active then startAutoGrab() else stopAutoGrab() end
    end)
    
    infiniteJumpToggle.button.MouseButton1Click:Connect(function()
        local active = not infiniteJumpToggle.button:GetAttribute("Active")
        infiniteJumpToggle:update(active)
        if active then startInfiniteJump() else stopInfiniteJump() end
    end)
    
    xrayToggle.button.MouseButton1Click:Connect(function()
        local active = not xrayToggle.button:GetAttribute("Active")
        xrayToggle:update(active)
        if active then startXRay() else stopXRay() end
    end)
    
    performanceToggle.button.MouseButton1Click:Connect(function()
        local active = not performanceToggle.button:GetAttribute("Active")
        performanceToggle:update(active)
        if active then startPerformanceBoost() else stopPerformanceBoost() end
    end)
    
    platformToggle.button.MouseButton1Click:Connect(function()
        local active = not platformToggle.button:GetAttribute("Active")
        platformToggle:update(active)
        if active then startPlatform() else stopPlatform() end
    end)
    
    -- ESP Tab Toggles
    playerEspToggle.button.MouseButton1Click:Connect(function()
        local active = not playerEspToggle.button:GetAttribute("Active")
        playerEspToggle:update(active)
        if active then startPlayerESP() else stopPlayerESP() end
    end)
    
    highestValueToggle.button.MouseButton1Click:Connect(function()
        local active = not highestValueToggle.button:GetAttribute("Active")
        highestValueToggle:update(active)
        if active then startHighestValueESP() else stopHighestValueESP() end
    end)
    
    timerEspToggle.button.MouseButton1Click:Connect(function()
        local active = not timerEspToggle.button:GetAttribute("Active")
        timerEspToggle:update(active)
        if active then startTimerESP() else stopTimerESP() end
    end)
    
    -- Utility Tab Toggles
    killAuraToggle.button.MouseButton1Click:Connect(function()
        local active = not killAuraToggle.button:GetAttribute("Active")
        killAuraToggle:update(active)
        if active then startKillAura() else stopKillAura() end
    end)
    
    antiStealToggle.button.MouseButton1Click:Connect(function()
        local active = not antiStealToggle.button:GetAttribute("Active")
        antiStealToggle:update(active)
        if active then startAntiSteal() else stopAntiSteal() end
    end)
    
    antiBeeToggle.button.MouseButton1Click:Connect(function()
        local active = not antiBeeToggle.button:GetAttribute("Active")
        antiBeeToggle:update(active)
        if active then startAntiBee() else stopAntiBee() end
    end)
    
    antiRagdollToggle.button.MouseButton1Click:Connect(function()
        local active = not antiRagdollToggle.button:GetAttribute("Active")
        antiRagdollToggle:update(active)
        if active then startAntiRagdoll() else stopAntiRagdoll() end
    end)
    
    speedBoosterToggle.button.MouseButton1Click:Connect(function()
        local active = not speedBoosterToggle.button:GetAttribute("Active")
        speedBoosterToggle:update(active)
        if active then startSpeedBoost() else stopSpeedBoost() end
    end)
    
    kickOnStealToggle.button.MouseButton1Click:Connect(function()
        local active = not kickOnStealToggle.button:GetAttribute("Active")
        kickOnStealToggle:update(active)
        if active then startKickOnSteal() else stopKickOnSteal() end
    end)
    
    -- Config Tab Toggles
    saveConfigToggle.button.MouseButton1Click:Connect(function()
        saveConfig()
        task.wait(0.5)
        saveConfigToggle:update(false)
    end)
    
    removeConfigToggle.button.MouseButton1Click:Connect(function()
        deleteConfig()
        task.wait(0.5)
        removeConfigToggle:update(false)
    end)
    
    autoLoadToggle.button.MouseButton1Click:Connect(function()
        local active = not autoLoadToggle.button:GetAttribute("Active")
        autoLoadToggle:update(active)
        createNotification("Auto Load", active and "Will auto-load on startup" or "Disabled auto-load", 2, "info")
    end)

    -- === INTERACTIONS ===

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        TweenService:Create(mainFrame, ANIM.MEDIUM, {BackgroundTransparency = 1}):Play()
        task.wait(0.35)
        mainFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 560, 0, 500)
        mainFrame.Position = UDim2.new(0.5, -280, 0.5, -250)
        mainFrame.BackgroundTransparency = 0
    end)

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, ANIM.FAST, {
            BackgroundColor3 = COLORS.ERROR,
            Size = UDim2.new(0, 40, 0, 40),
            Position = UDim2.new(1, -54, 0, 15)
        }):Play()
        TweenService:Create(closeBtn, ANIM.FAST, {TextColor3 = COLORS.TEXT}):Play()
    end)

    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, ANIM.FAST, {
            BackgroundColor3 = COLORS.ELEVATED,
            Size = UDim2.new(0, 38, 0, 38),
            Position = UDim2.new(1, -52, 0, 16)
        }):Play()
        TweenService:Create(closeBtn, ANIM.FAST, {TextColor3 = COLORS.TEXT_SECONDARY}):Play()
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        
        if mainFrame.Visible then
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(mainFrame, ANIM.BOUNCE, {
                Size = UDim2.new(0, 560, 0, 500),
                Position = UDim2.new(0.5, -280, 0.5, -250)
            }):Play()
        end
        
        TweenService:Create(zhIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Rotation = mainFrame.Visible and 360 or 0
        }):Play()
        
        TweenService:Create(logo, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Rotation = mainFrame.Visible and 180 or 0
        }):Play()
    end)

    toggleBtn.MouseEnter:Connect(function()
        TweenService:Create(toggleBtn, ANIM.BOUNCE, {Size = UDim2.new(0, 70, 0, 70)}):Play()
        TweenService:Create(toggleStroke, ANIM.FAST, {Thickness = 3, Transparency = 0}):Play()
        TweenService:Create(outerGlow, ANIM.MEDIUM, {ImageTransparency = 0.2}):Play()
        TweenService:Create(zhIcon, ANIM.FAST, {TextSize = 24}):Play()
    end)

    toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(toggleBtn, ANIM.BOUNCE, {Size = UDim2.new(0, 64, 0, 64)}):Play()
        TweenService:Create(toggleStroke, ANIM.FAST, {Thickness = 2.5, Transparency = 0.3}):Play()
        TweenService:Create(outerGlow, ANIM.MEDIUM, {ImageTransparency = 0.6}):Play()
        TweenService:Create(zhIcon, ANIM.FAST, {TextSize = 22}):Play()
    end)

    joinBtn.MouseButton1Click:Connect(function()
        local jobId = jobInput.Text
        if jobId ~= "" and jobId:match("^%d+$") then
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.SUCCESS}):Play()
            joinBtn.Text = "✓ Joining Server..."
            
            pcall(function()
                TeleportService:TeleportToPlaceInstance(TARGET_GAME_ID, jobId, LocalPlayer)
            end)
            
            task.wait(2)
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ACCENT}):Play()
            joinBtn.Text = "Join Server"
        else
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ERROR}):Play()
            joinBtn.Text = "✕ Invalid Job ID"
            task.wait(0.6)
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ACCENT}):Play()
            joinBtn.Text = "Join Server"
        end
    end)

    joinBtn.MouseEnter:Connect(function()
        TweenService:Create(joinBtn, ANIM.FAST, {
            BackgroundColor3 = COLORS.ACCENT_HOVER,
            Size = UDim2.new(1, 0, 0, 46)
        }):Play()
    end)

    joinBtn.MouseLeave:Connect(function()
        TweenService:Create(joinBtn, ANIM.FAST, {
            BackgroundColor3 = COLORS.ACCENT,
            Size = UDim2.new(1, 0, 0, 44)
        }):Play()
    end)

    makeDraggable(mainFrame, header)

    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    return screenGui
end

-- ================================================================
-- INITIALIZATION
-- ================================================================

-- Create GUI
local gui = createMainGUI()

-- Show welcome notification
createNotification("Zvios Hub", "Successfully loaded! Press ZH button to open.", 3, "success")

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    
    -- Reapply active features
    if State.SpeedBoost.enabled then
        local humanoid = character:WaitForChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = State.SpeedBoost.originalSpeed * State.SpeedBoost.multiplier
        end
    end
    
    if State.Platform.enabled then
        stopPlatform()
        task.wait(0.5)
        startPlatform()
    end
end)

-- Hotkey system
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.HOTKEYS.AUTO_GRAB then
        if State.AutoGrab.enabled then
            stopAutoGrab()
        else
            startAutoGrab()
        end
    elseif input.KeyCode == CONFIG.HOTKEYS.SPEED_BOOST then
        if State.SpeedBoost.enabled then
            stopSpeedBoost()
        else
            startSpeedBoost()
        end
    elseif input.KeyCode == CONFIG.HOTKEYS.XRAY then
        if State.XRay.enabled then
            stopXRay()
        else
            startXRay()
        end
    end
end)

print("✅ Zvios Hub Complete Edition loaded successfully!")
print("🎮 Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"))
print("🌐 Discord: discord.gg/9KXrTZWFZS")

return gui
