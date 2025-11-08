-- ZVIOS HUB - Modern UI
-- Enhanced with premium styling and smooth animations

local COLORS = {
    -- Background layers with depth
    BG = Color3.fromRGB(15, 15, 20),
    SURFACE = Color3.fromRGB(22, 22, 30),
    ELEVATED = Color3.fromRGB(28, 28, 38),
    CARD = Color3.fromRGB(32, 32, 44),
    
    -- Accent colors with variations
    ACCENT = Color3.fromRGB(88, 101, 242),
    ACCENT_HOVER = Color3.fromRGB(108, 121, 255),
    ACCENT_DARK = Color3.fromRGB(68, 81, 222),
    ACCENT_GLOW = Color3.fromRGB(88, 101, 242),
    
    -- Status colors
    SUCCESS = Color3.fromRGB(52, 211, 153),
    SUCCESS_DIM = Color3.fromRGB(34, 197, 94),
    WARNING = Color3.fromRGB(251, 191, 36),
    ERROR = Color3.fromRGB(239, 68, 68),
    ERROR_HOVER = Color3.fromRGB(220, 38, 38),
    
    -- Text hierarchy
    TEXT = Color3.fromRGB(248, 248, 252),
    TEXT_SECONDARY = Color3.fromRGB(203, 213, 225),
    TEXT_DIM = Color3.fromRGB(148, 163, 184),
    TEXT_MUTED = Color3.fromRGB(100, 116, 139),
    
    -- Borders and dividers
    BORDER = Color3.fromRGB(51, 51, 68),
    BORDER_LIGHT = Color3.fromRGB(64, 64, 84),
    DIVIDER = Color3.fromRGB(45, 45, 60)
}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Animation presets
local ANIM = {
    FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    MEDIUM = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SLOW = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    BOUNCE = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ELASTIC = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    SPRING = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
}

-- Utility: Create rounded corner
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

-- Utility: Create stroke
local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end

-- Utility: Create padding
local function createPadding(parent, all)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, all)
    padding.PaddingBottom = UDim.new(0, all)
    padding.PaddingLeft = UDim.new(0, all)
    padding.PaddingRight = UDim.new(0, all)
    padding.Parent = parent
    return padding
end

-- Enhanced toggle with better visuals
local function createToggle(parent, text, icon)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 48)
    container.BackgroundColor3 = COLORS.CARD
    container.BorderSizePixel = 0
    container.Parent = parent

    createCorner(container, 10)
    local stroke = createStroke(container, COLORS.BORDER, 1, 0.4)

    -- Hover glow effect
    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(1, 0, 1, 0)
    glowFrame.BackgroundColor3 = COLORS.ACCENT
    glowFrame.BackgroundTransparency = 1
    glowFrame.BorderSizePixel = 0
    glowFrame.ZIndex = 0
    glowFrame.Parent = container
    createCorner(glowFrame, 10)

    -- Icon (optional)
    local iconLabel
    if icon then
        iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 24, 0, 24)
        iconLabel.Position = UDim2.new(0, 16, 0.5, -12)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = COLORS.TEXT_SECONDARY
        iconLabel.TextSize = 16
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Parent = container
    end

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, icon and 48 or 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.TEXT_SECONDARY
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- Toggle switch background
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 50, 0, 26)
    toggleBg.Position = UDim2.new(1, -62, 0.5, -13)
    toggleBg.BackgroundColor3 = COLORS.ELEVATED
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = container

    createCorner(toggleBg, 13)
    local toggleStroke = createStroke(toggleBg, COLORS.BORDER, 2, 0.5)

    -- Toggle knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = COLORS.TEXT_MUTED
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg

    createCorner(knob, 10)

    -- Knob shadow
    local knobShadow = Instance.new("Frame")
    knobShadow.Size = UDim2.new(1, 4, 1, 4)
    knobShadow.Position = UDim2.new(0, -2, 0, -2)
    knobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.6
    knobShadow.BorderSizePixel = 0
    knobShadow.ZIndex = -1
    knobShadow.Parent = knob
    createCorner(knobShadow, 12)

    -- Interactive button
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 2
    button.Parent = container

    button:SetAttribute("Active", false)

    -- Toggle functionality
    button.MouseButton1Click:Connect(function()
        local active = not button:GetAttribute("Active")
        button:SetAttribute("Active", active)
        
        local bgColor = active and COLORS.ACCENT or COLORS.ELEVATED
        local strokeColor = active and COLORS.ACCENT_GLOW or COLORS.BORDER
        local knobColor = active and COLORS.TEXT or COLORS.TEXT_MUTED
        local knobPos = active and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        
        TweenService:Create(toggleBg, ANIM.MEDIUM, {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(toggleStroke, ANIM.MEDIUM, {Color = strokeColor, Transparency = active and 0 or 0.5}):Play()
        TweenService:Create(knob, ANIM.SPRING, {BackgroundColor3 = knobColor, Position = knobPos}):Play()
        TweenService:Create(label, ANIM.FAST, {TextColor3 = active and COLORS.TEXT or COLORS.TEXT_SECONDARY}):Play()
        
        if iconLabel then
            TweenService:Create(iconLabel, ANIM.FAST, {TextColor3 = active and COLORS.ACCENT or COLORS.TEXT_SECONDARY}):Play()
        end
    end)

    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(container, ANIM.FAST, {BackgroundColor3 = COLORS.ELEVATED}):Play()
        TweenService:Create(stroke, ANIM.FAST, {Transparency = 0.2}):Play()
        TweenService:Create(glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 0.95}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(container, ANIM.FAST, {BackgroundColor3 = COLORS.CARD}):Play()
        TweenService:Create(stroke, ANIM.FAST, {Transparency = 0.4}):Play()
        TweenService:Create(glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 1}):Play()
    end)

    return {
        button = button,
        container = container,
        toggleBg = toggleBg,
        knob = knob,
        update = function(self, active)
            self.button:SetAttribute("Active", active)
            local bgColor = active and COLORS.ACCENT or COLORS.ELEVATED
            local knobColor = active and COLORS.TEXT or COLORS.TEXT_MUTED
            local knobPos = active and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            TweenService:Create(self.toggleBg, ANIM.MEDIUM, {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(self.knob, ANIM.SPRING, {BackgroundColor3 = knobColor, Position = knobPos}):Play()
        end
    }
end

-- Create section header
local function createSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 32)
    section.BackgroundTransparency = 1
    section.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = COLORS.TEXT
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 40, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -4)
    line.BackgroundColor3 = COLORS.ACCENT
    line.BorderSizePixel = 0
    line.Parent = section
    createCorner(line, 1)

    return section
end

-- Make frame draggable
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
            TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- Main GUI creation
local function createMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZviosHubModern"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 100

    -- === TOGGLE BUTTON ===
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 60)
    toggleBtn.Position = UDim2.new(0, 24, 0.5, -30)
    toggleBtn.BackgroundColor3 = COLORS.SURFACE
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 10
    toggleBtn.Parent = screenGui

    createCorner(toggleBtn, 18)
    local toggleStroke = createStroke(toggleBtn, COLORS.ACCENT, 2, 0.2)

    -- Gradient overlay
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
    }
    gradient.Rotation = 135
    gradient.Parent = toggleBtn

    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0.5, -10, 0.5, -10)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = COLORS.ACCENT_GLOW
    glow.ImageTransparency = 0.7
    glow.ZIndex = 9
    glow.Parent = toggleBtn

    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextColor3 = COLORS.TEXT
    icon.TextSize = 28
    icon.Font = Enum.Font.GothamBold
    icon.ZIndex = 11
    icon.Parent = toggleBtn

    -- Pulse animation
    local pulseGlow = TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        ImageTransparency = 0.4,
        Size = UDim2.new(1, 30, 1, 30)
    })
    pulseGlow:Play()

    -- === MAIN FRAME ===
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 540, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -270, 0.5, -240)
    mainFrame.BackgroundColor3 = COLORS.BG
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.ZIndex = 5
    mainFrame.Parent = screenGui

    createCorner(mainFrame, 16)
    createStroke(mainFrame, COLORS.BORDER_LIGHT, 1, 0.3)

    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5028857084"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = 4
    shadow.Parent = mainFrame

    -- === HEADER ===
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 65)
    header.BackgroundColor3 = COLORS.SURFACE
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    createCorner(header, 16)

    -- Header fill (to hide bottom corners)
    local headerFill = Instance.new("Frame")
    headerFill.Size = UDim2.new(1, 0, 0, 16)
    headerFill.Position = UDim2.new(0, 0, 1, -16)
    headerFill.BackgroundColor3 = COLORS.SURFACE
    headerFill.BorderSizePixel = 0
    headerFill.Parent = header

    -- Accent line
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, 0)
    accentLine.BackgroundColor3 = COLORS.ACCENT
    accentLine.BorderSizePixel = 0
    accentLine.Parent = header

    local lineGradient = Instance.new("UIGradient")
    lineGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.ACCENT),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(139, 92, 246)),
        ColorSequenceKeypoint.new(1, COLORS.ACCENT)
    }
    lineGradient.Parent = accentLine

    -- Logo/Icon
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 38, 0, 38)
    logoContainer.Position = UDim2.new(0, 20, 0, 14)
    logoContainer.BackgroundColor3 = COLORS.ACCENT
    logoContainer.BorderSizePixel = 0
    logoContainer.Parent = header

    createCorner(logoContainer, 10)

    local logoGradient = Instance.new("UIGradient")
    logoGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
    }
    logoGradient.Rotation = 45
    logoGradient.Parent = logoContainer

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "Z"
    logo.TextColor3 = COLORS.TEXT
    logo.TextSize = 22
    logo.Font = Enum.Font.GothamBold
    logo.Parent = logoContainer

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 250, 0, 24)
    title.Position = UDim2.new(0, 66, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "Zvios Hub"
    title.TextColor3 = COLORS.TEXT
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 250, 0, 18)
    subtitle.Position = UDim2.new(0, 66, 0, 36)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Edition • discord.gg/9KXrTZWFZS"
    subtitle.TextColor3 = COLORS.TEXT_DIM
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 36, 0, 36)
    closeBtn.Position = UDim2.new(1, -50, 0, 14)
    closeBtn.BackgroundColor3 = COLORS.ELEVATED
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = COLORS.TEXT_SECONDARY
    closeBtn.TextSize = 24
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header

    createCorner(closeBtn, 10)

    -- === TAB BAR ===
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -32, 0, 44)
    tabBar.Position = UDim2.new(0, 16, 0, 77)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.Parent = tabBar

    -- === CONTENT AREA ===
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -32, 1, -141)
    contentFrame.Position = UDim2.new(0, 16, 0, 129)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Create tab pages
    local tabs = {
        {name = "Main", icon = "🏠"},
        {name = "ESP", icon = "👁️"},
        {name = "Utility", icon = "🔧"},
        {name = "Config", icon = "⚙️"},
        {name = "Credits", icon = "ℹ️"}
    }

    local tabPages = {}
    local tabButtons = {}

    for i, tab in ipairs(tabs) do
        -- Create tab page
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
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = page

        tabPages[tab.name] = page

        -- Create tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 100, 1, 0)
        tabBtn.BackgroundColor3 = (i == 1) and COLORS.ACCENT or COLORS.ELEVATED
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabBar

        createCorner(tabBtn, 10)

        -- Tab icon and text
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 12, 0.5, -10)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tab.icon
        tabIcon.TextSize = 14
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.Parent = tabBtn

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -40, 1, 0)
        tabLabel.Position = UDim2.new(0, 34, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tab.name
        tabLabel.TextColor3 = COLORS.TEXT
        tabLabel.TextSize = 13
        tabLabel.Font = Enum.Font.GothamSemibold
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn

        table.insert(tabButtons, {btn = tabBtn, name = tab.name, icon = tabIcon, label = tabLabel})
    end

    -- Tab switching logic
    for _, tabData in ipairs(tabButtons) do
        tabData.btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabButtons) do
                TweenService:Create(t.btn, ANIM.MEDIUM, {BackgroundColor3 = COLORS.ELEVATED}):Play()
                tabPages[t.name].Visible = false
            end
            TweenService:Create(tabData.btn, ANIM.MEDIUM, {BackgroundColor3 = COLORS.ACCENT}):Play()
            tabPages[tabData.name].Visible = true
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
    createSection(tabPages["Main"], "Core Features")
    local grabToggle = createToggle(tabPages["Main"], "Auto Grab", "🎯")
    local infiniteJumpToggle = createToggle(tabPages["Main"], "Infinite Jump", "🚀")
    local xrayToggle = createToggle(tabPages["Main"], "X-Ray Vision", "👻")
    
    createSection(tabPages["Main"], "Performance")
    local performanceToggle = createToggle(tabPages["Main"], "Performance Boost", "⚡")
    local platformToggle = createToggle(tabPages["Main"], "Platform Mode", "🏗️")

    -- ESP TAB
    createSection(tabPages["ESP"], "Visual ESP")
    local playerEspToggle = createToggle(tabPages["ESP"], "Player ESP", "👤")
    local highestValueToggle = createToggle(tabPages["ESP"], "Highest Value ESP", "💎")
    local timerEspToggle = createToggle(tabPages["ESP"], "Timer ESP", "⏱️")

    -- UTILITY TAB
    createSection(tabPages["Utility"], "Combat")
    local killAuraToggle = createToggle(tabPages["Utility"], "Kill Aura", "⚔️")
    
    createSection(tabPages["Utility"], "Protection")
    local antiStealToggle = createToggle(tabPages["Utility"], "Anti-Steal", "🛡️")
    local antiBeeToggle = createToggle(tabPages["Utility"], "Anti-Bee", "🐝")
    local antiRagdollToggle = createToggle(tabPages["Utility"], "Anti-Ragdoll", "🦾")
    
    createSection(tabPages["Utility"], "Movement")
    local speedBoosterToggle = createToggle(tabPages["Utility"], "Speed Booster", "💨")
    
    createSection(tabPages["Utility"], "Security")
    local kickOnStealToggle = createToggle(tabPages["Utility"], "Kick on Steal", "🚪")

    -- CONFIG TAB
    createSection(tabPages["Config"], "Server")
    
    -- Job ID input
    local jobFrame = Instance.new("Frame")
    jobFrame.Size = UDim2.new(1, 0, 0, 88)
    jobFrame.BackgroundColor3 = COLORS.CARD
    jobFrame.BorderSizePixel = 0
    jobFrame.Parent = tabPages["Config"]
    
    createCorner(jobFrame, 10)
    createStroke(jobFrame, COLORS.BORDER, 1, 0.4)
    createPadding(jobFrame, 14)

    local jobLabel = Instance.new("TextLabel")
    jobLabel.Size = UDim2.new(1, 0, 0, 20)
    jobLabel.BackgroundTransparency = 1
    jobLabel.Text = "Join Specific Job"
    jobLabel.TextColor3 = COLORS.TEXT_SECONDARY
    jobLabel.TextSize = 13
    jobLabel.Font = Enum.Font.GothamSemibold
    jobLabel.TextXAlignment = Enum.TextXAlignment.Left
    jobLabel.Parent = jobFrame

    local jobInput = Instance.new("TextBox")
    jobInput.Size = UDim2.new(1, 0, 0, 38)
    jobInput.Position = UDim2.new(0, 0, 0, 28)
    jobInput.BackgroundColor3 = COLORS.ELEVATED
    jobInput.BorderSizePixel = 0
    jobInput.Text = ""
    jobInput.PlaceholderText = "Enter Job ID..."
    jobInput.TextColor3 = COLORS.TEXT
    jobInput.PlaceholderColor3 = COLORS.TEXT_MUTED
    jobInput.TextSize = 13
    jobInput.Font = Enum.Font.Gotham
    jobInput.TextXAlignment = Enum.TextXAlignment.Left
    jobInput.Parent = jobFrame

    createCorner(jobInput, 8)
    createPadding(jobInput, 12)

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(1, 0, 0, 40)
    joinBtn.BackgroundColor3 = COLORS.ACCENT
    joinBtn.BorderSizePixel = 0
    joinBtn.Text = "Join Server"
    joinBtn.TextColor3 = COLORS.TEXT
    joinBtn.TextSize = 14
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.AutoButtonColor = false
    joinBtn.Parent = tabPages["Config"]

    createCorner(joinBtn, 10)

    createSection(tabPages["Config"], "Configuration")
    local saveConfigToggle = createToggle(tabPages["Config"], "Save Config", "💾")
    local removeConfigToggle = createToggle(tabPages["Config"], "Remove Config", "🗑️")
    local autoLoadToggle = createToggle(tabPages["Config"], "Auto Load Script", "🔄")

    -- CREDITS TAB
    local creditsContainer = Instance.new("Frame")
    creditsContainer.Size = UDim2.new(1, 0, 0, 0)
    creditsContainer.AutomaticSize = Enum.AutomaticSize.Y
    creditsContainer.BackgroundColor3 = COLORS.CARD
    creditsContainer.BorderSizePixel = 0
    creditsContainer.Parent = tabPages["Credits"]

    createCorner(creditsContainer, 12)
    createStroke(creditsContainer, COLORS.BORDER, 1, 0.3)

    local creditsLayout = Instance.new("UIListLayout")
    creditsLayout.Padding = UDim.new(0, 14)
    creditsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    creditsLayout.Parent = creditsContainer

    createPadding(creditsContainer, 24)

    -- Credits content
    local creditsTitle = Instance.new("TextLabel")
    creditsTitle.Size = UDim2.new(1, 0, 0, 32)
    creditsTitle.BackgroundTransparency = 1
    creditsTitle.Text = "⚡ Zvios Hub"
    creditsTitle.TextColor3 = COLORS.TEXT
    creditsTitle.TextSize = 22
    creditsTitle.Font = Enum.Font.GothamBold
    creditsTitle.Parent = creditsContainer

    local divider1 = Instance.new("Frame")
    divider1.Size = UDim2.new(0.8, 0, 0, 1)
    divider1.BackgroundColor3 = COLORS.DIVIDER
    divider1.BorderSizePixel = 0
    divider1.Parent = creditsContainer

    local devLabel = Instance.new("TextLabel")
    devLabel.Size = UDim2.new(1, 0, 0, 22)
    devLabel.BackgroundTransparency = 1
    devLabel.Text = "👑 Developed by Zvios"
    devLabel.TextColor3 = COLORS.TEXT_SECONDARY
    devLabel.TextSize = 15
    devLabel.Font = Enum.Font.GothamSemibold
    devLabel.Parent = creditsContainer

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, 0, 0, 20)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "💬 discord.gg/9KXrTZWFZS"
    discordLabel.TextColor3 = COLORS.ACCENT
    discordLabel.TextSize = 14
    discordLabel.Font = Enum.Font.GothamMedium
    discordLabel.Parent = creditsContainer

    local divider2 = Instance.new("Frame")
    divider2.Size = UDim2.new(0.8, 0, 0, 1)
    divider2.BackgroundColor3 = COLORS.DIVIDER
    divider2.BorderSizePixel = 0
    divider2.Parent = creditsContainer

    local thanksLabel = Instance.new("TextLabel")
    thanksLabel.Size = UDim2.new(1, 0, 0, 22)
    thanksLabel.BackgroundTransparency = 1
    thanksLabel.Text = "❤️ Thank you for using Zvios Hub!"
    thanksLabel.TextColor3 = COLORS.TEXT_DIM
    thanksLabel.TextSize = 13
    thanksLabel.Font = Enum.Font.Gotham
    thanksLabel.Parent = creditsContainer

    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1, 0, 0, 18)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v2.0.0 • Premium Edition • © 2025"
    versionLabel.TextColor3 = COLORS.TEXT_MUTED
    versionLabel.TextSize = 11
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.Parent = creditsContainer

    -- === BUTTON INTERACTIONS ===

    -- Close button
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        mainFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 540, 0, 480)
        mainFrame.Position = UDim2.new(0.5, -270, 0.5, -240)
    end)

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ERROR, Size = UDim2.new(0, 38, 0, 38)}):Play()
        TweenService:Create(closeBtn, ANIM.FAST, {TextColor3 = COLORS.TEXT}):Play()
    end)

    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ELEVATED, Size = UDim2.new(0, 36, 0, 36)}):Play()
        TweenService:Create(closeBtn, ANIM.FAST, {TextColor3 = COLORS.TEXT_SECONDARY}):Play()
    end)

    -- Toggle button
    toggleBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        
        if mainFrame.Visible then
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(mainFrame, ANIM.BOUNCE, {
                Size = UDim2.new(0, 540, 0, 480),
                Position = UDim2.new(0.5, -270, 0.5, -240)
            }):Play()
        end
        
        TweenService:Create(icon, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Rotation = mainFrame.Visible and 180 or 0
        }):Play()
    end)

    toggleBtn.MouseEnter:Connect(function()
        TweenService:Create(toggleBtn, ANIM.BOUNCE, {Size = UDim2.new(0, 68, 0, 68)}):Play()
        TweenService:Create(toggleStroke, ANIM.FAST, {Thickness = 3, Transparency = 0}):Play()
        TweenService:Create(glow, ANIM.MEDIUM, {ImageTransparency = 0.3}):Play()
    end)

    toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(toggleBtn, ANIM.BOUNCE, {Size = UDim2.new(0, 60, 0, 60)}):Play()
        TweenService:Create(toggleStroke, ANIM.FAST, {Thickness = 2, Transparency = 0.2}):Play()
        TweenService:Create(glow, ANIM.MEDIUM, {ImageTransparency = 0.7}):Play()
    end)

    -- Join button
    joinBtn.MouseButton1Click:Connect(function()
        local jobId = jobInput.Text
        if jobId ~= "" and jobId:match("^%d+$") then
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.SUCCESS}):Play()
            joinBtn.Text = "✓ Joining..."
            task.wait(0.3)
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ACCENT}):Play()
            joinBtn.Text = "Join Server"
            -- Add actual teleport logic here
        else
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ERROR}):Play()
            joinBtn.Text = "✕ Invalid ID"
            task.wait(0.5)
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ACCENT}):Play()
            joinBtn.Text = "Join Server"
        end
    end)

    joinBtn.MouseEnter:Connect(function()
        TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ACCENT_HOVER}):Play()
    end)

    joinBtn.MouseLeave:Connect(function()
        TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ACCENT}):Play()
    end)

    -- Make draggable
    makeDraggable(mainFrame, header)

    -- Parent to PlayerGui
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    return {
        gui = screenGui,
        mainToggles = {
            grab = grabToggle,
            infiniteJump = infiniteJumpToggle,
            xray = xrayToggle,
            performance = performanceToggle,
            platform = platformToggle
        },
        espToggles = {
            playerEsp = playerEspToggle,
            highestValue = highestValueToggle,
            timerEsp = timerEspToggle
        },
        utilityToggles = {
            killAura = killAuraToggle,
            antiSteal = antiStealToggle,
            antiBee = antiBeeToggle,
            antiRagdoll = antiRagdollToggle,
            speedBooster = speedBoosterToggle,
            kickOnSteal = kickOnStealToggle
        },
        configToggles = {
            saveConfig = saveConfigToggle,
            removeConfig = removeConfigToggle,
            autoLoad = autoLoadToggle
        },
        jobInput = jobInput,
        joinBtn = joinBtn
    }
end

-- Initialize
return createMainGUI()
