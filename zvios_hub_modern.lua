-- ZVIOS HUB - Ultimate Modern UI
-- Professionally designed with premium aesthetics

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

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Enhanced animation presets
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

-- Utility functions
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

-- Enhanced toggle with premium styling
local function createToggle(parent, text, icon)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundColor3 = COLORS.CARD
    container.BorderSizePixel = 0
    container.Parent = parent

    createCorner(container, 12)
    local stroke = createStroke(container, COLORS.BORDER, 1, 0.5)

    -- Animated background glow
    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(1, 0, 1, 0)
    glowFrame.BackgroundColor3 = COLORS.ACCENT
    glowFrame.BackgroundTransparency = 1
    glowFrame.BorderSizePixel = 0
    glowFrame.ZIndex = 0
    glowFrame.Parent = container
    createCorner(glowFrame, 12)

    -- Icon container with gradient
    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 32, 0, 32)
    iconContainer.Position = UDim2.new(0, 14, 0.5, -16)
    iconContainer.BackgroundColor3 = COLORS.ELEVATED
    iconContainer.BorderSizePixel = 0
    iconContainer.Parent = container

    createCorner(iconContainer, 8)

    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon or "•"
    iconLabel.TextColor3 = COLORS.TEXT_DIM
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = iconContainer

    -- Text label
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

    -- Toggle switch background
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 52, 0, 28)
    toggleBg.Position = UDim2.new(1, -66, 0.5, -14)
    toggleBg.BackgroundColor3 = COLORS.ELEVATED
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = container

    createCorner(toggleBg, 14)
    local toggleStroke = createStroke(toggleBg, COLORS.BORDER, 2, 0.6)

    -- Toggle knob with shadow
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new(0, 3, 0.5, -11)
    knob.BackgroundColor3 = COLORS.TEXT_MUTED
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = toggleBg

    createCorner(knob, 11)

    -- Knob inner shadow effect
    local knobHighlight = Instance.new("Frame")
    knobHighlight.Size = UDim2.new(1, -6, 1, -6)
    knobHighlight.Position = UDim2.new(0, 3, 0, 3)
    knobHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knobHighlight.BackgroundTransparency = 0.95
    knobHighlight.BorderSizePixel = 0
    knobHighlight.Parent = knob
    createCorner(knobHighlight, 8)

    -- Button overlay
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 3
    button.Parent = container

    button:SetAttribute("Active", false)

    -- Click handler
    button.MouseButton1Click:Connect(function()
        local active = not button:GetAttribute("Active")
        button:SetAttribute("Active", active)
        
        local bgColor = active and COLORS.ACCENT or COLORS.ELEVATED
        local strokeColor = active and COLORS.ACCENT_GLOW or COLORS.BORDER
        local knobColor = active and COLORS.TEXT or COLORS.TEXT_MUTED
        local knobPos = active and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        local iconColor = active and COLORS.ACCENT or COLORS.TEXT_DIM
        local iconBg = active and COLORS.CARD or COLORS.ELEVATED
        
        TweenService:Create(toggleBg, ANIM.MEDIUM, {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(toggleStroke, ANIM.FAST, {
            Color = strokeColor, 
            Transparency = active and 0 or 0.6
        }):Play()
        TweenService:Create(knob, ANIM.SPRING, {
            BackgroundColor3 = knobColor, 
            Position = knobPos,
            Size = active and UDim2.new(0, 24, 0, 24) or UDim2.new(0, 22, 0, 22)
        }):Play()
        TweenService:Create(label, ANIM.FAST, {
            TextColor3 = active and COLORS.TEXT or COLORS.TEXT_SECONDARY
        }):Play()
        TweenService:Create(iconLabel, ANIM.MEDIUM, {
            TextColor3 = iconColor,
            Rotation = active and 360 or 0
        }):Play()
        TweenService:Create(iconContainer, ANIM.MEDIUM, {
            BackgroundColor3 = iconBg
        }):Play()
        
        if active then
            TweenService:Create(glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 0.92}):Play()
        else
            TweenService:Create(glowFrame, ANIM.MEDIUM, {BackgroundTransparency = 1}):Play()
        end
    end)

    -- Hover effects
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
        update = function(self, active)
            self.button:SetAttribute("Active", active)
            local bgColor = active and COLORS.ACCENT or COLORS.ELEVATED
            local knobColor = active and COLORS.TEXT or COLORS.TEXT_MUTED
            local knobPos = active and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
            TweenService:Create(self.toggleBg, ANIM.MEDIUM, {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(self.knob, ANIM.SPRING, {
                BackgroundColor3 = knobColor, 
                Position = knobPos
            }):Play()
        end
    }
end

-- Create stylish section header
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

    -- Accent line
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 3, 0, 18)
    line.Position = UDim2.new(0, -10, 0, 14)
    line.BackgroundColor3 = COLORS.ACCENT
    line.BorderSizePixel = 0
    line.Parent = section
    createCorner(line, 2)

    return section
end

-- Draggable functionality
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

-- Main GUI creation
local function createMainGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZviosHubModern"
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

    -- Gradient overlay
    createGradient(toggleBtn, ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, COLORS.SECONDARY)
    }, 135)

    -- Outer glow
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

    -- Inner shine
    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(1, -8, 1, -8)
    shine.Position = UDim2.new(0, 4, 0, 4)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.95
    shine.BorderSizePixel = 0
    shine.Parent = toggleBtn
    createCorner(shine, 16)

    -- ZH Icon
    local zhIcon = Instance.new("TextLabel")
    zhIcon.Size = UDim2.new(1, 0, 1, 0)
    zhIcon.BackgroundTransparency = 1
    zhIcon.Text = "ZH"
    zhIcon.TextColor3 = COLORS.TEXT
    zhIcon.TextSize = 22
    zhIcon.Font = Enum.Font.GothamBold
    zhIcon.ZIndex = 11
    zhIcon.Parent = toggleBtn

    -- Animated pulse
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

    -- Backdrop shadow
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

    -- Header fill
    local headerFill = Instance.new("Frame")
    headerFill.Size = UDim2.new(1, 0, 0, 18)
    headerFill.Position = UDim2.new(0, 0, 1, -18)
    headerFill.BackgroundColor3 = COLORS.SURFACE
    headerFill.BorderSizePixel = 0
    headerFill.Parent = header

    -- Gradient accent bar
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

    -- Logo container
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

    -- Title section
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

    -- Close button
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

    -- Tab data
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

        -- Create tab button
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

        -- Tab content container
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
    
    -- Job ID card
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

    -- Join button
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

    -- Credits header
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
    versionLabel.Text = "Version 2.0 • © 2025 Zvios"
    versionLabel.TextColor3 = COLORS.TEXT_MUTED
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.Parent = creditsContainer

    -- === INTERACTIONS ===

    -- Close button
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

    -- Toggle button
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

    -- Join button
    joinBtn.MouseButton1Click:Connect(function()
        local jobId = jobInput.Text
        if jobId ~= "" and jobId:match("^%d+$") then
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.SUCCESS}):Play()
            joinBtn.Text = "✓ Joining Server..."
            task.wait(0.4)
            TweenService:Create(joinBtn, ANIM.FAST, {BackgroundColor3 = COLORS.ACCENT}):Play()
            joinBtn.Text = "Join Server"
            -- Add teleport logic here
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
