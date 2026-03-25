-- ======================================
-- LOOPRIX CONFIGURATION SYSTEM
-- ======================================

local CONFIG = {
    -- gui panels
    LOCK_TARGET_PANEL_VISIBLE = false,
    DROP_BRAINROT_PANEL_VISIBLE = false,
    SPEED_GUI_VISIBLE = false,
    FLING_PANEL_VISIBLE = false,
    FLOAT_PANEL_VISIBLE = false,
    SPINBOT_PANEL_VISIBLE = false,
    TAUNT_PANEL_VISIBLE = false,
    ANTI_STEAL_PANEL_VISIBLE = false,
    AUTO_LOCK_PANEL_VISIBLE = false,
    TP_DOWN_PANEL_VISIBLE = false,
    AUTO_WALK_PANEL_VISIBLE = false,
    AUTO_PLAY_GUI_VISIBLE = false,
    ACTIVE_HUD_VISIBLE = false,
    GRAB_BAR_VISIBLE = true,
    MAIN_GUI_VISIBLE = true,
    -- toggles
    AUTO_BAT_ENABLED = false,
    AIMBOT_ENABLED = false,
    SPINBOT_ENABLED = false,
    ANTIRAGDOLL_ENABLED = false,
    UNWALK_ENABLED = false,
    ESP_ENABLED = false,
    INF_JUMP_ENABLED = false,
    OPTIMIZER_ENABLED = false,
    XRAY_ENABLED = false,
    LOCK_TARGET_ENABLED = false,
    AUTO_MEDUSA_ENABLED = false,
    INSTANT_GRAB_ENABLED = false,
    ANTI_DIE_ENABLED = true,
    UI_LOCKED = false,
    SPEED_ENABLED = false,
    NO_COLLISION_ENABLED = false,
    TP_DOWN_ENABLED = false,
    AUTO_TP_DOWN_ENABLED = false,
    -- values
    SPEED_VALUE = 60,
    STEAL_SPEED_VALUE = 30,
    AIMBOT_RANGE = 40,
    AIMBOT_DISABLE_RANGE = 45,
    SPINBOT_SPEED = 30,
    LOCK_TARGET_SPEED = 55,
    AUTO_MEDUSA_RANGE = 5,
    INSTANT_GRAB_ACTIVATION_DIST = 100,
    FLOAT_HEIGHT = 10,
    FLOAT_SPEED = 50,
    GUI_COLOR_R = 0,
    GUI_COLOR_G = 217,
    GUI_COLOR_B = 127,
    UI_SCALE = 1.0,
    AUTO_PLAY_DELAY = 0.03,
    -- keybinds
    TOGGLE_GUI_KEYBIND = nil,
    AUTO_BAT_KEYBIND = nil,
    AIMBOT_KEYBIND = nil,
    SPINBOT_KEYBIND = nil,
    LOCK_TARGET_KEYBIND = nil,
    AUTO_MEDUSA_KEYBIND = nil,
    INSTANT_GRAB_KEYBIND = nil,
    DROP_BRAINROT_KEYBIND = nil,
    FLOAT_KEYBIND = nil,
    AUTO_PLAY_L_KEYBIND = nil,
    AUTO_PLAY_R_KEYBIND = nil,
    FLING_KEYBIND = nil,
    ANTI_STEAL_KEYBIND = nil,
    AUTO_LOCK_KEYBIND = nil,
    AUTO_WALK_L_KEYBIND = nil,
    AUTO_WALK_R_KEYBIND = nil,
    TP_DOWN_KEYBIND = nil,
    -- gui positions (populated at runtime)
    _guiPositions = nil,
    _autoPlayOffsets = nil,
}
getgenv().LOOPRIX_CONFIG = CONFIG

-- ======================================
-- UI SCALE SYSTEM
-- ======================================

local scaleMultiplier = 1.0
local _registeredScaleInstances = {}  -- list of { us = UIScale, base = number }

-- Register a UIScale on `frame`. `baseScale` is the element's natural base (default 1.0).
-- At slider=100 (multiplier=1.0), the final Scale = base * 1.0 = base → original appearance.
local function registerScaleTarget(frame, baseScale)
    baseScale = baseScale or 1.0
    if not frame then return nil end
    local existing = frame:FindFirstChildOfClass("UIScale")
    if existing then
        existing.Scale = baseScale * scaleMultiplier
        table.insert(_registeredScaleInstances, { us = existing, base = baseScale })
        return existing
    else
        local us = Instance.new("UIScale")
        us.Scale = baseScale * scaleMultiplier
        us.Parent = frame
        table.insert(_registeredScaleInstances, { us = us, base = baseScale })
        return us
    end
end

-- Push a new multiplier to all registered UIScale instances.
-- Each element's final Scale = its individual base * multiplier.
local function applyUIScale(scale)
    scale = math.clamp(scale, 0.5, 1.25)
    scaleMultiplier = scale
    CONFIG.UI_SCALE = scale
    for _, entry in ipairs(_registeredScaleInstances) do
        pcall(function()
            if entry.us and entry.us.Parent then
                entry.us.Scale = entry.base * scale
            end
        end)
    end
end

-- ======================================
-- CONFIG SAVE / LOAD  (k7-style, flat JSON)
-- ======================================

local CONFIG_FILE = "LooprixDuel.json"

local function saveConfig()
    local cfg = {
        -- toggles
        AUTO_BAT_ENABLED        = CONFIG.AUTO_BAT_ENABLED,
        AIMBOT_ENABLED          = CONFIG.AIMBOT_ENABLED,
        SPINBOT_ENABLED         = CONFIG.SPINBOT_ENABLED,
        ANTIRAGDOLL_ENABLED     = CONFIG.ANTIRAGDOLL_ENABLED,
        UNWALK_ENABLED          = CONFIG.UNWALK_ENABLED,
        ESP_ENABLED             = CONFIG.ESP_ENABLED,
        INF_JUMP_ENABLED        = CONFIG.INF_JUMP_ENABLED,
        OPTIMIZER_ENABLED       = CONFIG.OPTIMIZER_ENABLED,
        XRAY_ENABLED            = CONFIG.XRAY_ENABLED,
        LOCK_TARGET_ENABLED     = CONFIG.LOCK_TARGET_ENABLED,
        AUTO_MEDUSA_ENABLED     = CONFIG.AUTO_MEDUSA_ENABLED,
        INSTANT_GRAB_ENABLED    = CONFIG.INSTANT_GRAB_ENABLED,
        ANTI_DIE_ENABLED        = CONFIG.ANTI_DIE_ENABLED,
        UI_LOCKED               = CONFIG.UI_LOCKED,
        SPEED_ENABLED           = CONFIG.SPEED_ENABLED,
        NO_COLLISION_ENABLED    = CONFIG.NO_COLLISION_ENABLED,
        TP_DOWN_ENABLED         = CONFIG.TP_DOWN_ENABLED,
        AUTO_TP_DOWN_ENABLED    = CONFIG.AUTO_TP_DOWN_ENABLED,
        -- panel visibility
        LOCK_TARGET_PANEL_VISIBLE   = CONFIG.LOCK_TARGET_PANEL_VISIBLE,
        DROP_BRAINROT_PANEL_VISIBLE = CONFIG.DROP_BRAINROT_PANEL_VISIBLE,
        SPEED_GUI_VISIBLE           = CONFIG.SPEED_GUI_VISIBLE,
        FLING_PANEL_VISIBLE         = CONFIG.FLING_PANEL_VISIBLE,
        FLOAT_PANEL_VISIBLE         = CONFIG.FLOAT_PANEL_VISIBLE,
        SPINBOT_PANEL_VISIBLE       = CONFIG.SPINBOT_PANEL_VISIBLE,
        TAUNT_PANEL_VISIBLE         = CONFIG.TAUNT_PANEL_VISIBLE,
        ANTI_STEAL_PANEL_VISIBLE    = CONFIG.ANTI_STEAL_PANEL_VISIBLE,
        AUTO_LOCK_PANEL_VISIBLE     = CONFIG.AUTO_LOCK_PANEL_VISIBLE,
        TP_DOWN_PANEL_VISIBLE       = CONFIG.TP_DOWN_PANEL_VISIBLE,
        AUTO_WALK_PANEL_VISIBLE     = CONFIG.AUTO_WALK_PANEL_VISIBLE,
        AUTO_PLAY_GUI_VISIBLE       = CONFIG.AUTO_PLAY_GUI_VISIBLE,
        ACTIVE_HUD_VISIBLE          = CONFIG.ACTIVE_HUD_VISIBLE,
        GRAB_BAR_VISIBLE            = CONFIG.GRAB_BAR_VISIBLE,
        MAIN_GUI_VISIBLE            = guiVisible,
        -- values
        SPEED_VALUE                 = CONFIG.SPEED_VALUE,
        STEAL_SPEED_VALUE           = CONFIG.STEAL_SPEED_VALUE,
        AIMBOT_RANGE                = CONFIG.AIMBOT_RANGE,
        AIMBOT_DISABLE_RANGE        = CONFIG.AIMBOT_DISABLE_RANGE,
        SPINBOT_SPEED               = CONFIG.SPINBOT_SPEED,
        LOCK_TARGET_SPEED           = CONFIG.LOCK_TARGET_SPEED,
        AUTO_MEDUSA_RANGE           = CONFIG.AUTO_MEDUSA_RANGE,
        INSTANT_GRAB_ACTIVATION_DIST= CONFIG.INSTANT_GRAB_ACTIVATION_DIST,
        FLOAT_HEIGHT                = CONFIG.FLOAT_HEIGHT,
        FLOAT_SPEED                 = CONFIG.FLOAT_SPEED,
        GUI_COLOR_R                 = CONFIG.GUI_COLOR_R,
        GUI_COLOR_G                 = CONFIG.GUI_COLOR_G,
        GUI_COLOR_B                 = CONFIG.GUI_COLOR_B,
        UI_SCALE                    = CONFIG.UI_SCALE,
        AUTO_PLAY_DELAY             = CONFIG.AUTO_PLAY_DELAY,
        -- keybinds stored as key name strings
        TOGGLE_GUI_KEYBIND          = CONFIG.TOGGLE_GUI_KEYBIND and CONFIG.TOGGLE_GUI_KEYBIND.Name or nil,
        AUTO_BAT_KEYBIND            = CONFIG.AUTO_BAT_KEYBIND and CONFIG.AUTO_BAT_KEYBIND.Name or nil,
        AIMBOT_KEYBIND              = CONFIG.AIMBOT_KEYBIND and CONFIG.AIMBOT_KEYBIND.Name or nil,
        SPINBOT_KEYBIND             = CONFIG.SPINBOT_KEYBIND and CONFIG.SPINBOT_KEYBIND.Name or nil,
        LOCK_TARGET_KEYBIND         = CONFIG.LOCK_TARGET_KEYBIND and CONFIG.LOCK_TARGET_KEYBIND.Name or nil,
        AUTO_MEDUSA_KEYBIND         = CONFIG.AUTO_MEDUSA_KEYBIND and CONFIG.AUTO_MEDUSA_KEYBIND.Name or nil,
        INSTANT_GRAB_KEYBIND        = CONFIG.INSTANT_GRAB_KEYBIND and CONFIG.INSTANT_GRAB_KEYBIND.Name or nil,
        DROP_BRAINROT_KEYBIND       = CONFIG.DROP_BRAINROT_KEYBIND and CONFIG.DROP_BRAINROT_KEYBIND.Name or nil,
        FLOAT_KEYBIND               = CONFIG.FLOAT_KEYBIND and CONFIG.FLOAT_KEYBIND.Name or nil,
        AUTO_PLAY_L_KEYBIND         = CONFIG.AUTO_PLAY_L_KEYBIND and CONFIG.AUTO_PLAY_L_KEYBIND.Name or nil,
        AUTO_PLAY_R_KEYBIND         = CONFIG.AUTO_PLAY_R_KEYBIND and CONFIG.AUTO_PLAY_R_KEYBIND.Name or nil,
        FLING_KEYBIND               = CONFIG.FLING_KEYBIND and CONFIG.FLING_KEYBIND.Name or nil,
        ANTI_STEAL_KEYBIND          = CONFIG.ANTI_STEAL_KEYBIND and CONFIG.ANTI_STEAL_KEYBIND.Name or nil,
        AUTO_LOCK_KEYBIND           = CONFIG.AUTO_LOCK_KEYBIND and CONFIG.AUTO_LOCK_KEYBIND.Name or nil,
        AUTO_WALK_L_KEYBIND         = CONFIG.AUTO_WALK_L_KEYBIND and CONFIG.AUTO_WALK_L_KEYBIND.Name or nil,
        AUTO_WALK_R_KEYBIND         = CONFIG.AUTO_WALK_R_KEYBIND and CONFIG.AUTO_WALK_R_KEYBIND.Name or nil,
        TP_DOWN_KEYBIND             = CONFIG.TP_DOWN_KEYBIND and CONFIG.TP_DOWN_KEYBIND.Name or nil,
        -- gui positions
        _guiPositions               = CONFIG._guiPositions,
        _autoPlayOffsets            = CONFIG._autoPlayOffsets,
    }
    pcall(function()
        writefile(CONFIG_FILE, game:GetService("HttpService"):JSONEncode(cfg))
    end)
end

local function loadConfig()
    if not (isfile and isfile(CONFIG_FILE)) then return end
    local ok, cfg = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(CONFIG_FILE))
    end)
    if not ok or not cfg then return end

    local function applyBool(k)  if cfg[k] ~= nil then CONFIG[k] = cfg[k] end end
    local function applyNum(k)   if cfg[k] ~= nil then CONFIG[k] = cfg[k] end end
    local function applyKey(k)
        if cfg[k] and Enum.KeyCode[cfg[k]] then CONFIG[k] = Enum.KeyCode[cfg[k]] end
    end

    -- toggles
    applyBool("AUTO_BAT_ENABLED"); applyBool("AIMBOT_ENABLED"); applyBool("SPINBOT_ENABLED")
    applyBool("ANTIRAGDOLL_ENABLED"); applyBool("UNWALK_ENABLED"); applyBool("ESP_ENABLED")
    applyBool("INF_JUMP_ENABLED"); applyBool("OPTIMIZER_ENABLED"); applyBool("XRAY_ENABLED")
    applyBool("LOCK_TARGET_ENABLED"); applyBool("AUTO_MEDUSA_ENABLED"); applyBool("INSTANT_GRAB_ENABLED")
    applyBool("ANTI_DIE_ENABLED"); applyBool("UI_LOCKED"); applyBool("SPEED_ENABLED")
    applyBool("NO_COLLISION_ENABLED"); applyBool("TP_DOWN_ENABLED"); applyBool("AUTO_TP_DOWN_ENABLED")
    -- panel visibility
    applyBool("LOCK_TARGET_PANEL_VISIBLE"); applyBool("DROP_BRAINROT_PANEL_VISIBLE")
    applyBool("SPEED_GUI_VISIBLE"); applyBool("FLING_PANEL_VISIBLE"); applyBool("FLOAT_PANEL_VISIBLE")
    applyBool("SPINBOT_PANEL_VISIBLE"); applyBool("TAUNT_PANEL_VISIBLE"); applyBool("ANTI_STEAL_PANEL_VISIBLE")
    applyBool("AUTO_LOCK_PANEL_VISIBLE"); applyBool("TP_DOWN_PANEL_VISIBLE")
    applyBool("AUTO_WALK_PANEL_VISIBLE"); applyBool("AUTO_PLAY_GUI_VISIBLE")
    applyBool("ACTIVE_HUD_VISIBLE"); applyBool("GRAB_BAR_VISIBLE")
    if cfg.MAIN_GUI_VISIBLE ~= nil then guiVisible = cfg.MAIN_GUI_VISIBLE end
    -- values
    applyNum("SPEED_VALUE"); applyNum("STEAL_SPEED_VALUE"); applyNum("AIMBOT_RANGE")
    applyNum("AIMBOT_DISABLE_RANGE"); applyNum("SPINBOT_SPEED"); applyNum("LOCK_TARGET_SPEED")
    applyNum("AUTO_MEDUSA_RANGE"); applyNum("INSTANT_GRAB_ACTIVATION_DIST")
    applyNum("FLOAT_HEIGHT"); applyNum("FLOAT_SPEED"); applyNum("GUI_COLOR_R")
    applyNum("GUI_COLOR_G"); applyNum("GUI_COLOR_B"); applyNum("UI_SCALE")
    applyNum("AUTO_PLAY_DELAY")
    -- keybinds
    applyKey("TOGGLE_GUI_KEYBIND"); applyKey("AUTO_BAT_KEYBIND"); applyKey("AIMBOT_KEYBIND")
    applyKey("SPINBOT_KEYBIND"); applyKey("LOCK_TARGET_KEYBIND"); applyKey("AUTO_MEDUSA_KEYBIND")
    applyKey("INSTANT_GRAB_KEYBIND"); applyKey("DROP_BRAINROT_KEYBIND"); applyKey("FLOAT_KEYBIND")
    applyKey("AUTO_PLAY_L_KEYBIND"); applyKey("AUTO_PLAY_R_KEYBIND"); applyKey("FLING_KEYBIND")
    applyKey("ANTI_STEAL_KEYBIND"); applyKey("AUTO_LOCK_KEYBIND")
    applyKey("AUTO_WALK_L_KEYBIND"); applyKey("AUTO_WALK_R_KEYBIND"); applyKey("TP_DOWN_KEYBIND")
    -- gui positions
    if type(cfg._guiPositions) == "table" then CONFIG._guiPositions = cfg._guiPositions end
    if type(cfg._autoPlayOffsets) == "table" then CONFIG._autoPlayOffsets = cfg._autoPlayOffsets end

    scaleMultiplier = math.clamp(CONFIG.UI_SCALE or 1.0, 0.5, 1.25)
    getgenv().LOOPRIX_CONFIG = CONFIG
end

local function saveGuiPosition(frame, pathParts)
    if not frame or not pathParts then return end
    CONFIG._guiPositions = CONFIG._guiPositions or {}
    CONFIG._guiPositions[pathParts] = {
        scaleX  = frame.Position.X.Scale,
        scaleY  = frame.Position.Y.Scale,
        offsetX = frame.Position.X.Offset,
        offsetY = frame.Position.Y.Offset
    }
    saveConfig()
end

local function loadGuiPosition(frame, pathParts)
    if not frame or not pathParts then return end
    CONFIG._guiPositions = CONFIG._guiPositions or {}
    local pos = CONFIG._guiPositions[pathParts]
    if pos then
        frame.Position = UDim2.new(pos.scaleX, pos.offsetX, pos.scaleY, pos.offsetY)
    end
end

-- ======================================
-- COLORS & SERVICES
-- ======================================

local COLORS = {
    Background             = Color3.fromRGB(12, 14, 20),
    BackgroundTransparency = 0.1,
    Surface                = Color3.fromRGB(20, 24, 34),
    SurfaceTransparency    = 0.10,
    Text    = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 190, 200),
    Accent  = Color3.new(0.000000, 0.850980, 0.498039),
    Purple = Color3.new(0.125490, 0.898039, 0.549020),
    Pink   = Color3.fromRGB(150, 255, 180),
    Cyan   = Color3.fromRGB(120, 255, 210),
    Yellow = Color3.fromRGB(255, 235, 120),
    Blue   = Color3.fromRGB(140, 200, 255),
    Red    = Color3.fromRGB(255, 100, 120),
}

-- Dynamic color tracking for live color updates
local _accentStrokes   = {}  -- { UIStroke }
local _accentFrames    = {}  -- { Frame / TextButton }
local _accentLabels    = {}  -- { TextLabel / TextButton }
local _accentGradients = {}  -- { UIGradient, colorSeqBuilder }
local _accentDots      = {}  -- { Frame } small dot indicators

local function _buildAccentGradient(r, g, b)
    local c = Color3.fromRGB(r, g, b)
    local bright = Color3.fromRGB(
        math.min(r + 80, 255),
        math.min(g + 40, 255),
        math.min(b + 60, 255)
    )
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0,    c),
        ColorSequenceKeypoint.new(0.33, bright),
        ColorSequenceKeypoint.new(0.66, bright),
        ColorSequenceKeypoint.new(1,    c)
    })
end

local function applyAccentColor(r, g, b)
    local newColor = Color3.fromRGB(r, g, b)
    COLORS.Accent = newColor
    CONFIG.GUI_COLOR_R = r
    CONFIG.GUI_COLOR_G = g
    CONFIG.GUI_COLOR_B = b

    for _, s in ipairs(_accentStrokes) do
        pcall(function() if s and s.Parent then s.Color = newColor end end)
    end
    for _, f in ipairs(_accentFrames) do
        pcall(function() if f and f.Parent then f.BackgroundColor3 = newColor end end)
    end
    for _, l in ipairs(_accentLabels) do
        pcall(function() if l and l.Parent then l.TextColor3 = newColor end end)
    end
    for _, d in ipairs(_accentDots) do
        pcall(function() if d and d.Parent then d.BackgroundColor3 = newColor end end)
    end
    local gradSeq = _buildAccentGradient(r, g, b)
    for _, g2 in ipairs(_accentGradients) do
        pcall(function() if g2 and g2.Parent then g2.Color = gradSeq end end)
    end
    -- Update live ESP colors
    pcall(updateEspAccentColor, r, g, b)
end

local function trackStroke(s)   table.insert(_accentStrokes,   s)   return s   end
local function trackFrame(f)    table.insert(_accentFrames,    f)   return f    end
local function trackLabel(l)    table.insert(_accentLabels,    l)   return l    end
local function trackGradient(g) table.insert(_accentGradients, g)   return g    end
local function trackDot(d)      table.insert(_accentDots,      d)   return d    end

local S = {
    Players           = game:GetService("Players"),
    UserInputService  = game:GetService("UserInputService"),
    TweenService      = game:GetService("TweenService"),
    HttpService       = game:GetService("HttpService"),
    RunService        = game:GetService("RunService"),
    Lighting          = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

S.LocalPlayer = S.Players.LocalPlayer
S.PlayerGui   = S.LocalPlayer:WaitForChild("PlayerGui")

-- ======================================
-- GUI VARIABLES
-- ======================================

local screenGui, mainFrame, contentFrame, tabBar
local lockTargetPanelGui, lockTargetPanelBtn
local dropBrainrotPanelGui, dropBrainrotPanelBtn
local floatPanelGui, floatPanelBtn
local spinbotPanelGui, spinbotPanelBtn
local tauntPanelGui, tauntPanelBtn
local antiStealPanelGui, antiStealPanelBtn
local flingPanelGui, flingPanelBtn
local autoLockPanelGui, autoLockPanelBtn
local tpDownPanelGui, tpDownPanelBtn
local _aimbotBtn  = nil
local _spinbotBtn = nil

local guiVisible = true
local isMinimized = false
local currentTab = "duel"

local attacking = false
local aimbotEnabled = false
local spinbotEnabled = false
local unwalkEnabled = false
local espEnabled = false
local infJumpEnabled = false
local optimizerEnabled = false
local xrayEnabled = false
local lockTargetEnabled = false
local autoMedusaEnabled = false
local instantGrabEnabled = false
local antiDieEnabled = false

local speedGuiEnabled = false
local speedGuiInstance = nil

-- ── Auto Play state (single table = 1 local instead of 17) ───────────────
local AP = {
    enabled      = false,
    loopConn     = nil,
    currentStep  = 1,
    isWaiting    = false,
    activeSide   = nil,
    settingsOpen = false,
    settingsSide = "L",
    btnL         = nil,
    btnR         = nil,
    guiInstance  = nil,
    espFolder    = nil,
    espParts     = {},
    BASE = {
        L = {
            P1 = Vector3.new(-485.04, -4.90,  26.11),
            P2 = Vector3.new(-476.52, -6.42,  28.10),
            P3 = Vector3.new(-475.17, -6.93,  92.61),
            P4 = Vector3.new(-476.06, -6.64,  94.73),
            P5 = Vector3.new(-483.34, -5.10,  97.76),
        },
        R = {
            P1 = Vector3.new(-484.70, -5.00,  94.59),
            P2 = Vector3.new(-476.28, -6.58,  93.77),
            P3 = Vector3.new(-474.70, -7.00,  28.32),
            P4 = Vector3.new(-476.26, -6.58,  26.00),
            P5 = Vector3.new(-483.50, -5.10,  23.27),
        },
    },
    SEQUENCE   = {"P3","P4","P5","P4","P2","P1"},
    POINT_KEYS = {"P1","P2","P3","P4","P5"},
    offsets = {
        L = { P1={x=0,z=0}, P2={x=0,z=0}, P3={x=0,z=0}, P4={x=0,z=0}, P5={x=0,z=0} },
        R = { P1={x=0,z=0}, P2={x=0,z=0}, P3={x=0,z=0}, P4={x=0,z=0}, P5={x=0,z=0} },
    },
    sideBoxes = {
        L = { P1={x="0",z="0"}, P2={x="0",z="0"}, P3={x="0",z="0"}, P4={x="0",z="0"}, P5={x="0",z="0"} },
        R = { P1={x="0",z="0"}, P2={x="0",z="0"}, P3={x="0",z="0"}, P4={x="0",z="0"}, P5={x="0",z="0"} },
    },
}
-- convenience aliases (no extra locals — just fields)
local apBtnL, apBtnR, apGuiInstance = nil, nil, nil

local aimbotConnection
local spinbotConnection
local espConnection
local infJumpConnection
local lockTargetConnection
local autoMedusaConnection
local medusaCharAddedConnection
local instantGrabConnection
local instantGrabProgressConnection
local antiDieConnection

local alignOri
local attach0
local spinBAV = nil
local savedAnimations = {}
local originalTransparency = {}
local medusaCircle = nil


local tweenInfoFast   = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoMedium = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local antiRagdollEnabled = false

local ANTI_RAGDOLL = {
    enabled = false,
    connections = {},
    cachedCharData = {}
}

local character = S.LocalPlayer.Character or S.LocalPlayer.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")

local connections = {}
local cleanupFunctions = {}

-- ======================================
-- CONNECTION MANAGEMENT
-- ======================================

-- Everything from here runs inside _main() so all local functions
-- get their own 200-register budget, separate from the chunk level.
local function _main()

local function addConnection(conn)
    table.insert(connections, conn)
end

local function clearConnections()
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
end

local function registerCleanup(func)
    table.insert(cleanupFunctions, func)
end

local function runCleanups()
    for _, f in ipairs(cleanupFunctions) do
        pcall(f)
    end
    cleanupFunctions = {}
end

-- ======================================
-- ANTI DIE SYSTEM
-- ======================================

local function activateAntiDie()
    local char = S.LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.BreakJointsOnDeath = false
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then
            hum.Health = hum.MaxHealth
        end
    end)

    hum.Died:Connect(function()
        task.wait()
        if char and char.Parent then
            local newHum = Instance.new("Humanoid")
            newHum.Name = "ReplacedHumanoid"
            newHum.Parent = char
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = newHum
            end
            hum:Destroy()
        end
    end)
end

-- ======================================
-- ANTI RAGDOLL SYSTEM
-- ======================================

local function disconnectAllAntiRagdoll()
    for _, conn in ipairs(ANTI_RAGDOLL.connections) do
        pcall(function() conn:Disconnect() end)
    end
    ANTI_RAGDOLL.connections = {}
end

local function cacheCharacterData()
    local char = S.LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    ANTI_RAGDOLL.cachedCharData = {
        character = char,
        humanoid = hum,
        root = root,
    }
    return true
end

local function isRagdolled()
    if not ANTI_RAGDOLL.cachedCharData.humanoid then return false end
    local hum = ANTI_RAGDOLL.cachedCharData.humanoid
    local state = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true
    }
    if ragdollStates[state] then return true end
    local endTime = S.LocalPlayer:GetAttribute("RagdollEndTime")
    if endTime then
        local now = workspace:GetServerTimeNow()
        if (endTime - now) > 0 then return true end
    end
    return false
end

local function removeRagdollConstraints()
    if not ANTI_RAGDOLL.cachedCharData.character then return end
    for _, descendant in ipairs(ANTI_RAGDOLL.cachedCharData.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            pcall(function() descendant:Destroy() end)
        end
    end
end

local function forceExitRagdoll()
    if not ANTI_RAGDOLL.cachedCharData.humanoid or not ANTI_RAGDOLL.cachedCharData.root then return end
    local hum = ANTI_RAGDOLL.cachedCharData.humanoid
    local root = ANTI_RAGDOLL.cachedCharData.root
    pcall(function()
        S.LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

local function v1HeartbeatLoop()
    while ANTI_RAGDOLL.enabled and ANTI_RAGDOLL.cachedCharData.humanoid do
        task.wait(0.05)
        if isRagdolled() then
            removeRagdollConstraints()
            forceExitRagdoll()
        end
    end
end

local function setupCameraBinding()
    if not ANTI_RAGDOLL.cachedCharData.humanoid then return end
    local lastCheck = 0
    local conn = S.RunService.RenderStepped:Connect(function()
        if not ANTI_RAGDOLL.enabled then return end
        local now = tick()
        if now - lastCheck < 0.1 then return end
        lastCheck = now
        local cam = workspace.CurrentCamera
        if cam and ANTI_RAGDOLL.cachedCharData.humanoid and cam.CameraSubject ~= ANTI_RAGDOLL.cachedCharData.humanoid then
            cam.CameraSubject = ANTI_RAGDOLL.cachedCharData.humanoid
        end
    end)
    table.insert(ANTI_RAGDOLL.connections, conn)
end

local function onCharacterAddedAntiRagdoll()
    task.wait(0.5)
    if not ANTI_RAGDOLL.enabled then return end
    if cacheCharacterData() then
        setupCameraBinding()
        task.spawn(v1HeartbeatLoop)
    end
end

local function toggleAntiRagdoll(state)
    antiRagdollEnabled = state
    if state then
        if not cacheCharacterData() then return end
        ANTI_RAGDOLL.enabled = true
        local charConn = S.LocalPlayer.CharacterAdded:Connect(onCharacterAddedAntiRagdoll)
        table.insert(ANTI_RAGDOLL.connections, charConn)
        setupCameraBinding()
        task.spawn(v1HeartbeatLoop)
    else
        ANTI_RAGDOLL.enabled = false
        disconnectAllAntiRagdoll()
        ANTI_RAGDOLL.cachedCharData = {}
    end
end

-- ======================================
-- NOTIFICATION TOAST SYSTEM
-- ======================================

local _toastGui        = nil
local _toastContainer  = nil
local _toastCount      = 0

local function ensureToastGui()
    if _toastGui and _toastGui.Parent then return end
    _toastGui = Instance.new("ScreenGui")
    _toastGui.Name = "Looprix_Toasts"
    _toastGui.ResetOnSpawn = false
    _toastGui.DisplayOrder = 9999999
    _toastGui.IgnoreGuiInset = true
    pcall(function()
        if gethui then _toastGui.Parent = gethui()
        elseif syn and syn.protect_gui then syn.protect_gui(_toastGui); _toastGui.Parent = S.PlayerGui
        else _toastGui.Parent = S.PlayerGui end
    end)
    if not _toastGui.Parent then _toastGui.Parent = S.PlayerGui end

    _toastContainer = Instance.new("Frame", _toastGui)
    _toastContainer.Name = "ToastContainer"
    _toastContainer.Size = UDim2.new(0, 180, 1, -8)
    _toastContainer.Position = UDim2.new(1, -188, 0, 8)
    _toastContainer.BackgroundTransparency = 1
    _toastContainer.BorderSizePixel = 0

    local layout = Instance.new("UIListLayout", _toastContainer)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
end

local function showNotification(featureName, isOn)
    task.spawn(function()
        ensureToastGui()

        _toastCount = _toastCount + 1
        local order = _toastCount

        -- Card
        local toast = Instance.new("Frame", _toastContainer)
        toast.Name = "Toast_" .. order
        toast.Size = UDim2.new(1, 0, 0, 38)
        toast.BackgroundColor3 = COLORS.Background
        toast.BackgroundTransparency = 0.05
        toast.BorderSizePixel = 0
        toast.LayoutOrder = order
        toast.ClipsDescendants = true
        Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)

        -- Animated accent border
        local tStroke = Instance.new("UIStroke", toast)
        tStroke.Thickness = 1.2
        tStroke.Color = COLORS.Accent
        tStroke.Transparency = 0.15
        tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        trackStroke(tStroke)

        -- Left accent bar
        local accentBar = Instance.new("Frame", toast)
        accentBar.Size = UDim2.new(0, 3, 1, 0)
        accentBar.Position = UDim2.new(0, 0, 0, 0)
        accentBar.BackgroundColor3 = isOn and COLORS.Accent or COLORS.Red
        accentBar.BorderSizePixel = 0
        if isOn then trackFrame(accentBar) end

        -- Feature name label
        local nameLabel = Instance.new("TextLabel", toast)
        nameLabel.Size = UDim2.new(1, -52, 0.55, 0)
        nameLabel.Position = UDim2.new(0, 12, 0, 3)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = featureName
        nameLabel.TextColor3 = COLORS.Text
        nameLabel.TextSize = 11
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

        -- Sub-label "Feature changed"
        local subLabel = Instance.new("TextLabel", toast)
        subLabel.Size = UDim2.new(1, -52, 0.4, 0)
        subLabel.Position = UDim2.new(0, 12, 0.58, 0)
        subLabel.BackgroundTransparency = 1
        subLabel.Text = isOn and "Enabled" or "Disabled"
        subLabel.TextColor3 = isOn and COLORS.Accent or COLORS.TextDim
        subLabel.TextSize = 10
        subLabel.Font = Enum.Font.Gotham
        subLabel.TextXAlignment = Enum.TextXAlignment.Left
        if isOn then trackLabel(subLabel) end

        -- ON/OFF badge
        local badge = Instance.new("TextLabel", toast)
        badge.Size = UDim2.new(0, 34, 0, 18)
        badge.AnchorPoint = Vector2.new(1, 0.5)
        badge.Position = UDim2.new(1, -7, 0.5, 0)
        badge.BackgroundColor3 = isOn and COLORS.Accent or Color3.fromRGB(50, 20, 20)
        badge.BackgroundTransparency = isOn and 0.05 or 0.3
        badge.BorderSizePixel = 0
        badge.Text = isOn and "ON" or "OFF"
        badge.TextColor3 = COLORS.Text
        badge.TextSize = 10
        badge.Font = Enum.Font.GothamBold
        badge.TextXAlignment = Enum.TextXAlignment.Center
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
        if isOn then trackFrame(badge) end

        -- Slide in from right
        toast.Position = UDim2.new(0, 0, 0, 0)  -- container handles position via layout
        local slideIn = Instance.new("UIScale", toast)
        slideIn.Scale = 0.85
        S.TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0.05 }):Play()
        S.TweenService:Create(slideIn, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Scale = 1 }):Play()

        -- Hold
        task.wait(2.8)

        -- Fade + shrink out
        S.TweenService:Create(toast, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            { BackgroundTransparency = 1 }):Play()
        S.TweenService:Create(slideIn, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            { Scale = 0.8 }):Play()
        S.TweenService:Create(tStroke, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            { Transparency = 1 }):Play()

        task.wait(0.3)
        if toast and toast.Parent then toast:Destroy() end
    end)
end

-- ======================================
-- UI HELPERS
-- ======================================

local function applyLooprixTextStyle(el)
    if not el then return end
    if el:IsA("TextLabel") or el:IsA("TextButton") or el:IsA("TextBox") then
        el.TextStrokeColor3 = COLORS.Background
        local size = el.TextSize
        if el.TextScaled then
            size = math.floor((el.AbsoluteSize.Y / 24) * 18)
        end
        if size <= 14 then
            el.TextStrokeTransparency = 0.5
        else
            el.TextStrokeTransparency = 0.3
        end
    end
end

local function createElement(className, properties)
    local el = Instance.new(className)
    for k, v in pairs(properties) do el[k] = v end
    applyLooprixTextStyle(el)
    return el
end

local function tween(el, info, props)
    S.TweenService:Create(el, info, props):Play()
end

local function setToggleVisual(btn, state)
    if not btn then return end
    btn.Text = state and "ON" or "OFF"
    tween(btn, tweenInfoFast, { BackgroundColor3 = state and COLORS.Accent or COLORS.Background })
    if state then
        if not table.find(_accentFrames, btn) then table.insert(_accentFrames, btn) end
    else
        for i, f in ipairs(_accentFrames) do
            if f == btn then table.remove(_accentFrames, i); break end
        end
    end
end

-- ======================================
-- UI ELEMENTS CREATION
-- ======================================

local function createKeybindButton(parent, text, currentKey, callback)
    local container = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = COLORS.SurfaceTransparency,
        BorderSizePixel = 0,
        Parent = parent,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = container }))

    local label = createElement("TextLabel", {
        Size = UDim2.new(0.6, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    local keyButton = createElement("TextButton", {
        Size = UDim2.new(0.35, -5, 0.7, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0.2,
        Text = currentKey and currentKey.Name or "None",
        TextColor3 = COLORS.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = container,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyButton })
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.3, Parent = keyButton }))
    trackLabel(keyButton)

    local isListening = false
    keyButton.MouseButton1Click:Connect(function()
        if isListening then return end
        isListening = true
        keyButton.Text = "..."
        keyButton.TextColor3 = COLORS.Yellow
        local conn
        conn = S.UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local newKey = input.KeyCode
                keyButton.Text = newKey.Name
                keyButton.TextColor3 = COLORS.Accent
                callback(newKey)
                saveConfig()
                isListening = false
                conn:Disconnect()
            end
        end)
    end)
    return container
end

local function createToggle(parent, text, defaultValue, callback)
    local container = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = COLORS.SurfaceTransparency,
        BorderSizePixel = 0,
        Parent = parent,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = container }))

    local label = createElement("TextLabel", {
        Size = UDim2.new(0.6, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    local toggleButton = createElement("TextButton", {
        Size = UDim2.new(0.25, 0, 0.6, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        BackgroundColor3 = defaultValue and COLORS.Accent or COLORS.Background,
        BackgroundTransparency = 0.2,
        Text = defaultValue and "ON" or "OFF",
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = container,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 4), Parent = toggleButton })
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.3, Parent = toggleButton }))

    -- Track ON-state background so color changes propagate
    if defaultValue then table.insert(_accentFrames, toggleButton) end

    local state = defaultValue

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = state and "ON" or "OFF"
        tween(toggleButton, tweenInfoFast, { BackgroundColor3 = state and COLORS.Accent or COLORS.Background })
        if state then
            if not table.find(_accentFrames, toggleButton) then
                table.insert(_accentFrames, toggleButton)
            end
        else
            for i, f in ipairs(_accentFrames) do
                if f == toggleButton then table.remove(_accentFrames, i) break end
            end
        end
        showNotification(text, state)
        callback(state)
    end)

    return container
end

local function createTextInput(parent, text, defaultValue, minVal, maxVal, callback)
    local container = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = COLORS.SurfaceTransparency,
        BorderSizePixel = 0,
        Parent = parent,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })
    createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = container })

    local label = createElement("TextLabel", {
        Size = UDim2.new(0.6, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })

    local input = createElement("TextBox", {
        Size = UDim2.new(0.25, 0, 0.6, 0),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0.2,
        Text = tostring(defaultValue),
        TextColor3 = COLORS.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = container,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 4), Parent = input })
    createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.3, Parent = input })

    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num then
            num = math.clamp(num, minVal or 1, maxVal or 100)
            callback(num)
            input.Text = tostring(num)
        else
            input.Text = tostring(defaultValue)
        end
    end)

    return container
end

-- Slider UI element (draggable progress bar style)
local function createSlider(parent, labelText, defaultValue, minVal, maxVal, callback)
    minVal = minVal or 0
    maxVal = maxVal or 100
    local current = math.clamp(defaultValue, minVal, maxVal)

    local container = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = COLORS.SurfaceTransparency,
        BorderSizePixel = 0,
        Parent = parent,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })
    local cStroke = createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = container })
    trackStroke(cStroke)

    -- Left label: "Radius [8]"
    local lbl = createElement("TextLabel", {
        Size = UDim2.new(0.55, 0, 0, 18),
        Position = UDim2.new(0, 8, 0, 4),
        BackgroundTransparency = 1,
        Text = labelText .. " [" .. tostring(current) .. "]",
        TextColor3 = COLORS.Text,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })
    trackLabel(lbl)

    -- Track background
    local track = createElement("Frame", {
        Size = UDim2.new(1, -16, 0, 8),
        Position = UDim2.new(0, 8, 1, -14),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = container,
    })
    createElement("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

    local fraction = (current - minVal) / (maxVal - minVal)
    -- Fill bar
    local fill = createElement("Frame", {
        Size = UDim2.new(fraction, 0, 1, 0),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    createElement("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
    trackFrame(fill)

    -- Thumb knob
    local thumb = createElement("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(fraction, 0, 0.5, 0),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = track,
    })
    createElement("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })
    trackFrame(thumb)

    local isDragging = false

    local function updateFromPos(absX)
        local trackAbs = track.AbsolutePosition.X
        local trackW   = track.AbsoluteSize.X
        local frac = math.clamp((absX - trackAbs) / trackW, 0, 1)
        current = math.round(minVal + frac * (maxVal - minVal))
        fill.Size = UDim2.new(frac, 0, 1, 0)
        thumb.Position = UDim2.new(frac, 0, 0.5, 0)
        lbl.Text = labelText .. " [" .. tostring(current) .. "]"
        callback(current)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateFromPos(input.Position.X)
        end
    end)

    S.UserInputService.InputChanged:Connect(function(input)
        if not isDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            updateFromPos(input.Position.X)
        end
    end)

    S.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                isDragging = false
                saveConfig()
            end
        end
    end)

    return container
end

-- ======================================
-- NUMBER INPUT BOX  (replaces sliders in Settings)
-- ======================================

local function createNumberInput(parent, labelText, defaultValue, minVal, maxVal, callback)
    minVal = minVal or 0
    maxVal = maxVal or 9999
    local current = math.clamp(defaultValue, minVal, maxVal)

    local container = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = COLORS.SurfaceTransparency,
        BorderSizePixel = 0,
        Parent = parent,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })
    local cStroke = createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = container })
    trackStroke(cStroke)

    -- Left label
    local lbl = createElement("TextLabel", {
        Size = UDim2.new(0.58, -6, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = COLORS.Text,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container,
    })
    trackLabel(lbl)

    -- Input box on the right
    local inputBox = createElement("TextBox", {
        Size = UDim2.new(0.38, 0, 0, 26),
        Position = UDim2.new(0.60, 0, 0.5, -13),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0.3,
        Text = tostring(current),
        TextColor3 = COLORS.Accent,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ClearTextOnFocus = true,
        PlaceholderText = tostring(current),
        PlaceholderColor3 = COLORS.TextDim,
        Parent = container,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 5), Parent = inputBox })
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.4, Parent = inputBox }))
    trackLabel(inputBox)

    local function applyValue(raw)
        local num = tonumber(raw)
        if not num then
            inputBox.Text = tostring(current)
            return
        end
        current = math.clamp(math.round(num), minVal, maxVal)
        inputBox.Text = tostring(current)
        callback(current)
        saveConfig()
    end

    inputBox.FocusLost:Connect(function(enterPressed)
        applyValue(inputBox.Text)
    end)

    -- Also apply immediately on Enter key (ReturnPressedFromOnScreenKeyboard)
    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
        -- live preview: only update if text is a valid number
        local num = tonumber(inputBox.Text)
        if num then
            local clamped = math.clamp(math.round(num), minVal, maxVal)
            if clamped ~= current then
                current = clamped
                callback(current)
            end
        end
    end)

    return container
end

-- ======================================
-- COLLAPSIBLE CATEGORY  (animated)
-- ======================================

local function createCategory(parent, title, defaultOpen)
    defaultOpen = (defaultOpen ~= false)

    -- Outer wrapper – AutomaticSize.Y stacks header + clipper
    local wrapper = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = parent,
    })

    local wLayout = Instance.new("UIListLayout")
    wLayout.FillDirection  = Enum.FillDirection.Vertical
    wLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    wLayout.VerticalAlignment   = Enum.VerticalAlignment.Top
    wLayout.Padding    = UDim.new(0, 4)
    wLayout.SortOrder  = Enum.SortOrder.LayoutOrder
    wLayout.Parent     = wrapper

    -- ── Header ──────────────────────────────────────────────────────────────
    local header = createElement("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 1,
        Parent = wrapper,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 7), Parent = header })
    local hStroke = createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1.2, Transparency = 0.3,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = header })
    trackStroke(hStroke)

    local titleLbl = createElement("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = COLORS.Accent,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header,
    })
    trackLabel(titleLbl)

    -- Arrow rotates: 0° = open (▼), -90° = closed (▶)
    local arrowLbl = createElement("TextLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        BackgroundTransparency = 1,
        Text = "v",
        TextColor3 = COLORS.Accent,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Rotation = defaultOpen and 0 or -90,
        Parent = header,
    })
    trackLabel(arrowLbl)

    -- ── Clipper – masks the content during the slide animation ───────────────
    -- When open:   AutomaticSize.Y  → naturally matches content height
    -- When closed: AutomaticSize.None + tween Size.Y → 0
    local clipper = createElement("Frame", {
        Size            = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,   -- this is what creates the reveal effect
        AutomaticSize   = defaultOpen and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
        Visible         = defaultOpen,
        LayoutOrder     = 2,
        Parent          = wrapper,
    })

    -- ── Content – holds all items, always AutomaticSize.Y ───────────────────
    local content = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = clipper,
    })

    local contentPad = Instance.new("UIPadding")
    contentPad.PaddingBottom = UDim.new(0, 6)
    contentPad.Parent = content

    local itemList = createElement("UIListLayout", {
        Padding    = UDim.new(0, 6),
        SortOrder  = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = content,
    })

    -- ── Animation state ──────────────────────────────────────────────────────
    local isOpen    = defaultOpen
    local animating = false
    local catTween  = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local function setOpen(open)
        if animating then return end
        isOpen = open

        -- Rotate arrow with tween
        S.TweenService:Create(arrowLbl, catTween, {
            Rotation = open and 0 or -90
        }):Play()

        if open then
            -- Show clipper at zero height, then expand to content height
            clipper.AutomaticSize = Enum.AutomaticSize.None
            clipper.Size          = UDim2.new(1, 0, 0, 0)
            clipper.Visible       = true
            animating = true
            -- Defer one frame so AbsoluteSize is valid after clipper becomes visible
            task.defer(function()
                if not (content and content.Parent) then animating = false return end
                local targetH = math.max(content.AbsoluteSize.Y, 8)
                local tw = S.TweenService:Create(clipper, catTween, { Size = UDim2.new(1, 0, 0, targetH) })
                tw.Completed:Connect(function()
                    -- Hand off to AutomaticSize so the clipper tracks future resizes
                    clipper.AutomaticSize = Enum.AutomaticSize.Y
                    animating = false
                end)
                tw:Play()
            end)
        else
            -- Collapse from current height to zero
            clipper.AutomaticSize = Enum.AutomaticSize.None
            animating = true
            local tw = S.TweenService:Create(clipper, catTween, { Size = UDim2.new(1, 0, 0, 0) })
            tw.Completed:Connect(function()
                clipper.Visible = false
                animating = false
            end)
            tw:Play()
        end
    end

    header.MouseButton1Click:Connect(function()
        setOpen(not isOpen)
    end)

    return content, wrapper
end

local function createEmptyTab(parent, name)
    return createElement("Frame", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = parent,
    })
end

-- ======================================
-- DROP BRAINROT FEATURE
-- ======================================

local dropBrainrotRunning = false
local dropBrainrotConnection = nil

local function executeDrop()
    if dropBrainrotRunning then return end
    
    local char = character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    dropBrainrotRunning = true
    if dropBrainrotPanelBtn then
        dropBrainrotPanelBtn.BackgroundColor3 = COLORS.Purple
    end
    
    if dropBrainrotConnection then
        dropBrainrotConnection:Disconnect()
    end
    
    dropBrainrotConnection = S.RunService.Heartbeat:Connect(function()
        if not dropBrainrotRunning or not root or not root.Parent then
            if dropBrainrotConnection then dropBrainrotConnection:Disconnect() end
            dropBrainrotConnection = nil
            return
        end

        local vel = root.Velocity
        root.Velocity = vel * 1000 + Vector3.new(0, 1000, 0)
        
        S.RunService.RenderStepped:Wait()
        if root and root.Parent then root.Velocity = vel end
        
        S.RunService.Stepped:Wait()
        if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
    end)

    task.wait(0.2)
    
    dropBrainrotRunning = false
    if dropBrainrotConnection then dropBrainrotConnection:Disconnect() end
    dropBrainrotConnection = nil
    if dropBrainrotPanelBtn then
        dropBrainrotPanelBtn.BackgroundColor3 = COLORS.Surface
    end
end

-- ======================================
-- AIMBOT SYSTEM
-- ======================================

local function getClosestTarget()
    local char = character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local hrp = char.HumanoidRootPart
    local closest = nil
    local shortestDistance = CONFIG.AIMBOT_RANGE

    for _, plr in ipairs(S.Players:GetPlayers()) do
        if plr ~= S.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetHrp = plr.Character.HumanoidRootPart
            local dist = (targetHrp.Position - hrp.Position).Magnitude

            if dist <= shortestDistance then
                shortestDistance = dist
                closest = targetHrp
            end
        end
    end
    return closest
end

local function startBodyAimbot()
    if aimbotConnection then return end

    local char = character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.AutoRotate = false
    end

    attach0 = Instance.new("Attachment", hrp)

    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = attach0
    alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOri.RigidityEnabled = true
    alignOri.MaxTorque = math.huge
    alignOri.Responsiveness = 200
    alignOri.Parent = hrp

    aimbotConnection = S.RunService.RenderStepped:Connect(function()
        if not CONFIG.AIMBOT_ENABLED then return end
        local target = getClosestTarget()
        if not target then return end

        local dist = (target.Position - hrp.Position).Magnitude
        if dist > CONFIG.AIMBOT_DISABLE_RANGE then return end

        local lookPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
        alignOri.CFrame = CFrame.lookAt(hrp.Position, lookPos)
    end)
    addConnection(aimbotConnection)
end

local function stopBodyAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end

    if alignOri then
        alignOri:Destroy()
        alignOri = nil
    end

    if attach0 then
        attach0:Destroy()
        attach0 = nil
    end

    local char = character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
end

-- ======================================
-- AUTO BAT SYSTEM
-- ======================================

local function autoAttack()
    task.spawn(function()
        while CONFIG.AUTO_BAT_ENABLED do
            local char = character
            if char then
                local bat = char:FindFirstChild("Bat")
                if bat then
                    pcall(function()
                        bat:Activate()
                    end)
                end
            end
            task.wait(0.15)
        end
    end)
end

-- ======================================
-- SPINBOT SYSTEM
-- ======================================

local function startSpinBot()
    if spinbotConnection then return end
    
    local char = character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if spinBAV then spinBAV:Destroy() spinBAV = nil end
    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "SpinBAV" then v:Destroy() end
    end
    
    spinBAV = Instance.new("BodyAngularVelocity")
    spinBAV.Name = "SpinBAV"
    spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
    spinBAV.AngularVelocity = Vector3.new(0, CONFIG.SPINBOT_SPEED, 0)
    spinBAV.Parent = hrp
    
    spinbotConnection = S.RunService.Heartbeat:Connect(function()
        if not CONFIG.SPINBOT_ENABLED or not spinBAV then return end
        if spinBAV and spinBAV.Parent then
            spinBAV.AngularVelocity = Vector3.new(0, CONFIG.SPINBOT_SPEED, 0)
        end
    end)
    addConnection(spinbotConnection)
end

local function stopSpinBot()
    if spinbotConnection then
        spinbotConnection:Disconnect()
        spinbotConnection = nil
    end
    
    if spinBAV then 
        spinBAV:Destroy() 
        spinBAV = nil 
    end
    
    local char = character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "SpinBAV" then v:Destroy() end
            end
        end
    end
end

-- ======================================
-- UNWALK SYSTEM
-- ======================================

local function startUnwalk()
    local c = character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            t:Stop()
        end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        savedAnimations.Animate = anim:Clone()
        anim:Destroy()
    end
end

local function stopUnwalk()
    local c = character
    if c and savedAnimations.Animate then
        savedAnimations.Animate:Clone().Parent = c
        savedAnimations.Animate = nil
    end
end

-- ======================================
-- ESP SYSTEM  (outline + beam, accent-tracked, no nickname)
-- ======================================

local ESP_NAME      = "Looprix_Esp"
local ESP_BEAM_NAME = "Looprix_EspBeam"
local espCache      = {}   -- [player] = { highlight, beam, beamAtt0, charConn }
local _espHighlights = {}  -- for accent color tracking
local _espBeams      = {}  -- for accent color tracking

local function espGetAccentColor()
    return Color3.fromRGB(CONFIG.GUI_COLOR_R or 0, CONFIG.GUI_COLOR_G or 217, CONFIG.GUI_COLOR_B or 127)
end

local function espClearPlayer(player)
    local data = espCache[player]
    if not data then return end
    pcall(function()
        if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
        if data.beam      and data.beam.Parent      then data.beam:Destroy()      end
        if data.beamAtt0  and data.beamAtt0.Parent  then data.beamAtt0:Destroy()  end
        if data.beamAtt1  and data.beamAtt1.Parent  then data.beamAtt1:Destroy()  end
        if data.charConn  then data.charConn:Disconnect() end
    end)
    -- remove from tracking arrays
    for _, tbl in ipairs({_espHighlights, _espBeams}) do
        for i = #tbl, 1, -1 do
            if tbl[i] == data.highlight or tbl[i] == data.beam then
                table.remove(tbl, i)
            end
        end
    end
    espCache[player] = nil
end

local function espSetupChar(player, char)
    espClearPlayer(player)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    local accent = espGetAccentColor()

    -- Highlight (outline only)
    local hl = Instance.new("Highlight")
    hl.Name            = ESP_NAME
    hl.Adornee         = char
    hl.FillTransparency   = 1
    hl.OutlineColor       = accent
    hl.OutlineTransparency = 0
    hl.DepthMode          = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    table.insert(_espHighlights, hl)

    -- Beam: att0 on local HRP, att1 on enemy HRP
    local myChar = S.LocalPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")

    local att0, att1
    if myHRP then
        att0 = Instance.new("Attachment", myHRP)
        att0.Name = ESP_BEAM_NAME .. "_att0_" .. player.UserId
    end
    att1 = Instance.new("Attachment", hrp)
    att1.Name = ESP_BEAM_NAME .. "_att1"

    local beam = Instance.new("Beam")
    beam.Name         = ESP_BEAM_NAME
    beam.Attachment0  = att0 or att1
    beam.Attachment1  = att1
    beam.Color        = ColorSequence.new(accent)
    beam.Transparency = NumberSequence.new(0.35)
    beam.Width0       = 0.06
    beam.Width1       = 0.06
    beam.FaceCamera   = true
    beam.Segments     = 1
    beam.Parent       = hrp
    table.insert(_espBeams, beam)

    local charConn = player.CharacterRemoving:Connect(function()
        espClearPlayer(player)
    end)

    espCache[player] = {
        highlight = hl,
        beam      = beam,
        beamAtt0  = att0,
        beamAtt1  = att1,
        hrp       = hrp,
        charConn  = charConn,
    }
end

local function createESPForPlayer(player)
    if player == S.LocalPlayer then return end
    if player.Character then
        task.spawn(espSetupChar, player, player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        if CONFIG.ESP_ENABLED then
            espSetupChar(player, char)
        end
    end)
end

local function startESP()
    if espConnection then return end
    for _, p in ipairs(S.Players:GetPlayers()) do
        createESPForPlayer(p)
    end
    S.Players.PlayerAdded:Connect(createESPForPlayer)
    espConnection = S.RunService.RenderStepped:Connect(function()
        if not CONFIG.ESP_ENABLED then return end
        -- keep beam att0 anchored to local HRP (character can respawn)
        local myChar = S.LocalPlayer.Character
        local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        for player, data in pairs(espCache) do
            if data.beam and data.beam.Parent then
                if myHRP and data.beamAtt0 then
                    if data.beamAtt0.Parent ~= myHRP then
                        data.beamAtt0.Parent = myHRP
                    end
                    data.beam.Attachment0 = data.beamAtt0
                end
            end
        end
    end)
    addConnection(espConnection)
end

local function stopESP()
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    for player, _ in pairs(espCache) do
        espClearPlayer(player)
    end
    espCache = {}
end

-- Called by applyAccentColor to update live ESP colors
local function updateEspAccentColor(r, g, b)
    local c = Color3.fromRGB(r, g, b)
    for _, hl in ipairs(_espHighlights) do
        pcall(function() if hl and hl.Parent then hl.OutlineColor = c end end)
    end
    for _, bm in ipairs(_espBeams) do
        pcall(function() if bm and bm.Parent then bm.Color = ColorSequence.new(c) end end)
    end
end


-- ======================================
-- FLING SYSTEM
-- ======================================

local flingEnabled   = false
local _flingLoopConn = nil
local _flingMoveL    = 0.1
local FLING_STRENGTH = 10000
local FLING_UP_FORCE = 100

local function startFling()
    flingEnabled = true
    _flingMoveL  = 0.1
    task.spawn(function()
        while flingEnabled do
            local char = character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then task.wait(0.1) continue end
            local originalVel = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = originalVel * FLING_STRENGTH + Vector3.new(0, FLING_UP_FORCE, 0)
            S.RunService.RenderStepped:Wait()
            if hrp and hrp.Parent then hrp.AssemblyLinearVelocity = originalVel end
            S.RunService.Stepped:Wait()
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = originalVel + Vector3.new(0, _flingMoveL, 0)
                _flingMoveL = -_flingMoveL
            end
            S.RunService.Heartbeat:Wait()
        end
    end)
end

local function stopFling()
    flingEnabled = false
end


-- ======================================
-- AUTO WALK SYSTEM
-- ======================================

local AW = {
    enabled     = false,
    loopConn    = nil,
    currentStep = 1,
    activeSide  = nil,
    WALK_SEQ    = {"P3","P4","P5"},
    BASE = {
        L = {
            P3 = Vector3.new(-475.17, -6.93,  92.61),
            P4 = Vector3.new(-476.06, -6.64,  94.73),
            P5 = Vector3.new(-483.34, -5.10,  97.76),
        },
        R = {
            P3 = Vector3.new(-474.70, -7.00,  28.32),
            P4 = Vector3.new(-476.26, -6.58,  26.00),
            P5 = Vector3.new(-483.50, -5.10,  23.27),
        },
    },
}
local awGuiInstance = nil
local awWalkBtnL    = nil
local awWalkBtnR    = nil

local function awGetTarget(key)
    local b = AW.BASE[AW.activeSide][key]
    return b
end

local function awSetBtnActive(side, active)
    local btn = (side == "L") and awWalkBtnL or awWalkBtnR
    if not btn then return end
    S.TweenService:Create(btn, tweenInfoFast, {
        BackgroundColor3       = active and COLORS.Accent or COLORS.Surface,
        BackgroundTransparency = active and 0.0 or COLORS.SurfaceTransparency,
    }):Play()
    btn.TextColor3 = active and Color3.fromRGB(10,10,10) or COLORS.TextDim
end

local function awStopLoop()
    local prevSide = AW.activeSide
    AW.enabled     = false
    if AW.loopConn then AW.loopConn:Disconnect(); AW.loopConn = nil end
    AW.currentStep = 1
    if prevSide then awSetBtnActive(prevSide, false) end
end

local function awStartLoop()
    if AW.loopConn then AW.loopConn:Disconnect() end
    AW.currentStep = 1

    AW.loopConn = S.RunService.Heartbeat:Connect(function()
        if not AW.enabled then return end
        local char = character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local key    = AW.WALK_SEQ[AW.currentStep]
        local target = awGetTarget(key)
        local flat   = Vector3.new(target.X, hrp.Position.Y, target.Z)
        local dist   = (flat - hrp.Position).Magnitude
        local spd    = CONFIG.SPEED_VALUE or 60

        if dist > 2.0 then
            local dir = (flat - hrp.Position).Unit
            hum:Move(dir, false)
            hrp.AssemblyLinearVelocity = Vector3.new(dir.X * spd, hrp.AssemblyLinearVelocity.Y, dir.Z * spd)
        else
            if AW.currentStep >= #AW.WALK_SEQ then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                awStopLoop()
            else
                AW.currentStep = AW.currentStep + 1
            end
        end
    end)
    addConnection(AW.loopConn)
end

local function awLaunch(side)
    if AW.enabled and AW.activeSide == side then
        awStopLoop()
        return
    end
    if AW.enabled then awStopLoop() end
    AW.activeSide = side
    AW.enabled    = true
    awSetBtnActive(side, true)
    awStartLoop()
end

-- ======================================
-- AUTO WALK FLOATING GUI  (L / R buttons)
-- ======================================

local function createAutoWalkGui()
    local W      = 160
    local HDR_H  = 20
    local BTN_H  = 24
    local GAP    = 4
    local PAD    = 5
    local FULL_H = HDR_H + PAD + BTN_H + PAD

    local sg = Instance.new("ScreenGui", S.PlayerGui)
    sg.Name = "Looprix_AutoWalkGui"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999998
    sg.Enabled = CONFIG.AUTO_WALK_PANEL_VISIBLE

    local function makeAS(parent, thick, initT)
        local s = Instance.new("UIStroke", parent)
        s.Thickness = thick or 1.2; s.Color = COLORS.Accent
        s.Transparency = initT or 0; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        trackStroke(s)
        local g = Instance.new("UIGradient", s)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    COLORS.Accent),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(120,255,200)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(150,255,180)),
            ColorSequenceKeypoint.new(1,    COLORS.Accent),
        })
        trackGradient(g)
        S.RunService.RenderStepped:Connect(function() g.Rotation=(tick()*55)%360 end)
        return s
    end

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, W, 0, FULL_H)
    main.BackgroundColor3 = COLORS.Background
    main.BackgroundTransparency = 0.08
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    registerScaleTarget(main)
    makeAS(main, 1.2, 0)

    local savedAW = CONFIG._guiPositions and CONFIG._guiPositions.autoWalkPanel
    if savedAW then
        main.Position = UDim2.new(savedAW.scaleX, savedAW.offsetX, savedAW.scaleY, savedAW.offsetY)
    else
        main.Position = UDim2.new(0, 10, 0, 220)
    end

    local hdr = Instance.new("Frame", main)
    hdr.Size = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = COLORS.Surface; hdr.BackgroundTransparency = 0.05; hdr.BorderSizePixel = 0
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 10)
    local hdrFill = Instance.new("Frame", hdr)
    hdrFill.Size = UDim2.new(1,0,0,8); hdrFill.Position = UDim2.new(0,0,1,-8)
    hdrFill.BackgroundColor3 = COLORS.Surface; hdrFill.BackgroundTransparency = 0.05; hdrFill.BorderSizePixel = 0

    local dot = Instance.new("Frame", hdr)
    dot.Size = UDim2.new(0,6,0,6); dot.Position = UDim2.new(0,9,0.5,-3)
    dot.BackgroundColor3 = COLORS.Accent; dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    trackDot(dot)

    local titleLbl = Instance.new("TextLabel", hdr)
    titleLbl.Size = UDim2.new(1,-34,1,0); titleLbl.Position = UDim2.new(0,20,0,0)
    titleLbl.BackgroundTransparency = 1; titleLbl.Text = "Auto Walk"
    titleLbl.TextColor3 = COLORS.Text; titleLbl.Font = Enum.Font.GothamSemibold
    titleLbl.TextSize = 11; titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    local tg = Instance.new("UIGradient", titleLbl)
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    COLORS.Accent),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(120,255,200)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(1,    COLORS.Accent)})
    trackGradient(tg)
    S.RunService.RenderStepped:Connect(function() tg.Offset=Vector2.new(math.sin(tick()*1.1)*0.5,0) end)

    local minBtn = Instance.new("TextButton", hdr)
    minBtn.Size = UDim2.new(0,20,0,18); minBtn.Position = UDim2.new(1,-24,0.5,-9)
    minBtn.BackgroundColor3 = COLORS.Background; minBtn.BackgroundTransparency = 0.2
    minBtn.Text = "-"; minBtn.TextColor3 = COLORS.Accent
    minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 14; minBtn.BorderSizePixel = 0
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,4)
    makeAS(minBtn, 1, 0.4); trackLabel(minBtn)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1,0,1,-HDR_H); content.Position = UDim2.new(0,0,0,HDR_H)
    content.BackgroundTransparency = 1; content.BorderSizePixel = 0
    local btnLayout = Instance.new("UIListLayout", content)
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, GAP)
    local cPad = Instance.new("UIPadding", content)
    cPad.PaddingLeft=UDim.new(0,PAD); cPad.PaddingRight=UDim.new(0,PAD)
    cPad.PaddingTop=UDim.new(0,PAD); cPad.PaddingBottom=UDim.new(0,PAD)

    local HALF_W = (W - PAD*2 - GAP) / 2

    local function makeSideBtn(side)
        local btn = Instance.new("TextButton", content)
        btn.LayoutOrder = (side == "L") and 1 or 2
        btn.Size = UDim2.new(0, HALF_W, 0, BTN_H)
        btn.BackgroundColor3 = COLORS.Surface
        btn.BackgroundTransparency = COLORS.SurfaceTransparency
        btn.Text = (side == "L") and "◀ Auto L" or "Auto R ▶"
        btn.TextColor3 = COLORS.TextDim
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
        makeAS(btn, 1, 0.45)

        local badge = Instance.new("TextLabel", btn)
        badge.Size = UDim2.new(0,38,0,11); badge.AnchorPoint = Vector2.new(1,0)
        badge.Position = UDim2.new(1,-2,1,-5)
        badge.BackgroundColor3 = COLORS.Background; badge.BackgroundTransparency = 0.15
        badge.BorderSizePixel = 0; badge.Font = Enum.Font.GothamBold; badge.TextSize = 7
        badge.TextColor3 = COLORS.Accent; badge.ZIndex = 5
        local cfgKey = "AUTO_WALK_" .. side .. "_KEYBIND"
        badge.Text = CONFIG[cfgKey] and CONFIG[cfgKey].Name or "NONE"
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0,3)
        makeAS(badge, 1, 0.35); trackLabel(badge)
        task.spawn(function()
            while btn and btn.Parent do
                task.wait(0.5)
                badge.Text = CONFIG[cfgKey] and CONFIG[cfgKey].Name or "NONE"
            end
        end)
        btn.MouseButton1Click:Connect(function() awLaunch(side) end)
        return btn
    end

    awWalkBtnL = makeSideBtn("L")
    awWalkBtnR = makeSideBtn("R")

    local awMin = false
    minBtn.MouseButton1Click:Connect(function()
        awMin = not awMin
        if awMin then
            hdrFill.Visible=false; content.Visible=false
            S.TweenService:Create(main, tweenInfoMedium, {Size=UDim2.new(0,W,0,HDR_H)}):Play()
            minBtn.Text="+"
        else
            hdrFill.Visible=true; content.Visible=true
            S.TweenService:Create(main, tweenInfoMedium, {Size=UDim2.new(0,W,0,FULL_H)}):Play()
            minBtn.Text="-"
        end
    end)

    local awDrag,awDS,awDSP=false,nil,nil
    main.InputBegan:Connect(function(inp)
        if CONFIG.UI_LOCKED then return end
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            awDrag=false; awDS=inp.Position; awDSP=main.Position
        end
    end)
    S.UserInputService.InputChanged:Connect(function(inp)
        if CONFIG.UI_LOCKED or not awDS then return end
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
            if (inp.Position-awDS).Magnitude>5 then
                awDrag=true
                local d=inp.Position-awDS
                main.Position=UDim2.new(awDSP.X.Scale,awDSP.X.Offset+d.X,awDSP.Y.Scale,awDSP.Y.Offset+d.Y)
            end
        end
    end)
    main.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            if awDrag then
                CONFIG._guiPositions = CONFIG._guiPositions or {}
                CONFIG._guiPositions.autoWalkPanel = {
                    scaleX=main.Position.X.Scale, scaleY=main.Position.Y.Scale,
                    offsetX=main.Position.X.Offset, offsetY=main.Position.Y.Offset,
                }
                saveConfig()
            end
            awDrag=false; awDS=nil
        end
    end)

    awGuiInstance = sg
    pcall(function()
        applyAccentColor(CONFIG.GUI_COLOR_R or 0, CONFIG.GUI_COLOR_G or 217, CONFIG.GUI_COLOR_B or 127)
    end)
    return sg
end

-- ======================================
-- SIDE HELPER  (explicit, no auto-detect)
-- ======================================

local function canRunAutoPlay()
    local players = S.Players:GetPlayers()
    if #players ~= 2 then return false end
    return true
end


-- ======================================
-- LOCK TARGET SYSTEM
-- ======================================

local function isMoving()
    local char = character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        return hum.MoveDirection.Magnitude > 0
    end
    return false
end

local function getNearestEnemyLockTarget()
    local char = character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local target = nil
    local dist = math.huge
    for _, p in ipairs(S.Players:GetPlayers()) do
        if p ~= S.LocalPlayer and p.Character then
            local th = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if th and hum and hum.Health > 0 then
                local d = (th.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    target = th
                end
            end
        end
    end
    return target
end

local function startLockTarget()
    if lockTargetConnection then return end
    
    lockTargetConnection = S.RunService.Heartbeat:Connect(function()
        if not CONFIG.LOCK_TARGET_ENABLED then return end
        
        local char = character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if isMoving() then
            return
        end

        local target = getNearestEnemyLockTarget()
        if target then
            local direction = (target.Position - hrp.Position)
            
            if direction.Magnitude > 0.1 then
                local moveVec = direction.Unit * CONFIG.LOCK_TARGET_SPEED
                hrp.AssemblyLinearVelocity = Vector3.new(
                    moveVec.X, 
                    moveVec.Y, 
                    moveVec.Z
                )
            else
                hrp.AssemblyLinearVelocity = target.AssemblyLinearVelocity
            end
        end
    end)
    addConnection(lockTargetConnection)
end

local function stopLockTarget()
    if lockTargetConnection then
        lockTargetConnection:Disconnect()
        lockTargetConnection = nil
    end
end

-- ======================================
-- INFINITY JUMP SYSTEM
-- ======================================

local jumpForce = 50
local function startInfJump()
    if infJumpConnection then return end
    infJumpConnection = S.UserInputService.JumpRequest:Connect(function()
        if not CONFIG.INF_JUMP_ENABLED then return end
        local char = character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local vel = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, jumpForce, vel.Z)
    end)
    addConnection(infJumpConnection)
end

local function stopInfJump()
    if infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
end

-- ======================================
-- OPTIMIZER SYSTEM
-- ======================================

local function startOptimizer()
    if getgenv and getgenv().OPTIMIZER_ACTIVE then return end
    if getgenv then getgenv().OPTIMIZER_ACTIVE = true end
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        S.Lighting.GlobalShadows = false
        S.Lighting.Brightness = 3
        S.Lighting.FogEnd = 9e9
    end)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj:Destroy()
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.Plastic
                end
            end)
        end
    end)
end

local function stopOptimizer()
    if getgenv then getgenv().OPTIMIZER_ACTIVE = false end
end

-- ======================================
-- XRAY SYSTEM
-- ======================================

local function startXRay()
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Anchored and (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                originalTransparency[obj] = obj.LocalTransparencyModifier
                obj.LocalTransparencyModifier = 0.85
            end
        end
    end)
end

local function stopXRay()
    for part, value in pairs(originalTransparency) do
        if part then 
            pcall(function() part.LocalTransparencyModifier = value end)
        end
    end
    originalTransparency = {}
end

-- ======================================
-- NO PLAYER COLLISION SYSTEM
-- ======================================

local noCollisionConnection = nil

local function disableCollisionForPlayer(character)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function startNoCollision()
    if noCollisionConnection then return end
    
    noCollisionConnection = S.RunService.Stepped:Connect(function()
        if not CONFIG.NO_COLLISION_ENABLED then return end
        for _, player in ipairs(S.Players:GetPlayers()) do
            if player ~= S.LocalPlayer then
                local char = player.Character
                if char then
                    disableCollisionForPlayer(char)
                end
            end
        end
    end)
    addConnection(noCollisionConnection)
end

local function stopNoCollision()
    if noCollisionConnection then
        noCollisionConnection:Disconnect()
        noCollisionConnection = nil
    end
end

-- ======================================
-- FLOAT SYSTEM  (velocity-based rise, speed slider)
-- ======================================

local floatModeConn  = nil
local floatEnabled   = false
local _floatCurHip   = 0
local _floatTpInProgress = false  -- guard so auto-tp fires only once per cycle
local _floatGeneration   = 0     -- incremented on stopFloat; pending restarts abort if stale

local function startFloat()
    if floatModeConn then return end
    floatEnabled = true
    _floatCurHip = 0
    _floatTpInProgress = false
    pcall(function()
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if hum then _floatCurHip = hum.HipHeight end
    end)

    floatModeConn = S.RunService.Heartbeat:Connect(function()
        if not floatEnabled then return end
        pcall(function()
            local char = character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end

            local target = CONFIG.FLOAT_HEIGHT or 10
            local speed  = math.clamp(CONFIG.FLOAT_SPEED or 50, 1, 100)
            local step   = (speed / 100) * 2.0

            if _floatCurHip < target then
                _floatCurHip = math.min(_floatCurHip + step, target)
            elseif _floatCurHip > target then
                _floatCurHip = math.max(_floatCurHip - step * 5, target)
            end

            if math.abs(hum.HipHeight - _floatCurHip) > 0.01 then
                hum.HipHeight = _floatCurHip
            end

            -- Auto Tp Down logic:
            -- When we reach the target height and the toggle is on, and we're
            -- not already mid-cycle: stop float, fire tp down, then restart.
            if CONFIG.AUTO_TP_DOWN_ENABLED
               and not _floatTpInProgress
               and _floatCurHip >= target - 0.05 then
                _floatTpInProgress = true
                -- 1. stop float (resets HipHeight cleanly, no slam)
                floatEnabled = false
                floatModeConn:Disconnect()
                floatModeConn = nil
                hum.HipHeight = 2
                local gen = _floatGeneration  -- capture generation BEFORE any delays
                -- 2. tiny wait so the game actually applies the HipHeight drop
                task.delay(0.07, function()
                    if _floatGeneration ~= gen then return end  -- float was manually stopped
                    -- 3. slam velocity
                    local hrp2 = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp2 then
                        hrp2.AssemblyLinearVelocity = Vector3.new(
                            hrp2.AssemblyLinearVelocity.X, -100,
                            hrp2.AssemblyLinearVelocity.Z)
                    end
                    -- 4. restart float after a brief moment
                    task.delay(0.10, function()
                        if _floatGeneration ~= gen then return end  -- float was manually stopped
                        _floatTpInProgress = false
                        _floatCurHip = 0
                        -- zero out any bounce from the landing before restarting
                        local hrp3 = character and character:FindFirstChild("HumanoidRootPart")
                        if hrp3 then
                            local v = hrp3.AssemblyLinearVelocity
                            if v.Y > 0 then
                                hrp3.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
                            end
                        end
                        startFloat()
                    end)
                end)
            end
        end)
    end)
    addConnection(floatModeConn)
end

local function stopFloat()
    floatEnabled = false
    _floatTpInProgress = false
    _floatGeneration = _floatGeneration + 1  -- cancel any pending restarts
    if floatModeConn then
        floatModeConn:Disconnect()
        floatModeConn = nil
    end
    pcall(function()
        local char = character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.HipHeight = 2 end
    end)
    _floatCurHip = 0
end

local function tpDown()
    local char = character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.AssemblyLinearVelocity = Vector3.new(
        hrp.AssemblyLinearVelocity.X, -100,
        hrp.AssemblyLinearVelocity.Z)
end

-- ======================================
-- AUTO PLAY SYSTEM
-- ======================================

local function apGetTarget(key)
    local b   = AP.BASE[AP.activeSide][key]
    local off = AP.offsets[AP.activeSide][key]
    return b + Vector3.new(off.x, 0, off.z)
end

local function apGetSpeed(step)
    -- Sequence: P3(1)→P4(2)→P5(3)→P4(4)→P2(5)→P1(6)
    -- Steps 1-3 = forward to grab = SPEED_VALUE
    -- Steps 4-6 = returning back  = STEAL_SPEED_VALUE
    if step <= 3 then
        return CONFIG.SPEED_VALUE or 60
    else
        return CONFIG.STEAL_SPEED_VALUE or 30
    end
end

local function apGetRadius(key)
    return key == "P5" and 1.5 or 2.0
end

local function apClearESP()
    if AP.espFolder then
        for _, p in pairs(AP.espParts) do pcall(function() if p and p.Parent then p:Destroy() end end) end
        AP.espParts = {}
    end
end

local function apRefreshESP()
    apClearESP()
    if not AP.activeSide then return end
    if not AP.espFolder then
        AP.espFolder = Instance.new("Folder", workspace)
        AP.espFolder.Name = "Looprix_AutoPlay_ESP"
    end
    for k, v in pairs(AP.BASE[AP.activeSide]) do
        local off  = AP.offsets[AP.activeSide][k]
        local pos  = v + Vector3.new(off.x, 0, off.z)
        local part = Instance.new("Part", AP.espFolder)
        part.Size = Vector3.new(1.2, 1.2, 1.2)
        part.Position = pos
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Color = COLORS.Accent
        part.Transparency = 0.3
        local box = Instance.new("SelectionBox", part)
        box.Adornee = part
        box.Color3 = COLORS.Accent
        box.LineThickness = 0.03
        local bg = Instance.new("BillboardGui", part)
        bg.Size = UDim2.new(0, 50, 0, 14)
        bg.AlwaysOnTop = true
        bg.StudsOffset = Vector3.new(0, 2, 0)
        local tl = Instance.new("TextLabel", bg)
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.Text = k
        tl.TextColor3 = COLORS.Accent
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 9
        table.insert(AP.espParts, part)
    end
end

local function apSetBtnActive(btn, active)
    if not btn then return end
    S.TweenService:Create(btn, tweenInfoFast, {
        BackgroundColor3       = active and COLORS.Accent or COLORS.Surface,
        BackgroundTransparency = active and 0.0 or COLORS.SurfaceTransparency,
    }):Play()
    btn.TextColor3 = active and Color3.fromRGB(10, 10, 10) or COLORS.TextDim
end

local function apStopLoop()
    AP.enabled = false
    AP.isWaiting = false   -- FIX: reset waiting flag so next launch doesn't hang
    if AP.loopConn then AP.loopConn:Disconnect(); AP.loopConn = nil end
    AP.currentStep = 1
    -- FIX: always restore Speed GUI if we paused it
    if AP._speedWas ~= nil then
        CONFIG.SPEED_ENABLED = AP._speedWas
        AP._speedWas = nil
    end
end

local function apResetBtns()
    apSetBtnActive(apBtnL, false)
    apSetBtnActive(apBtnR, false)
end

local function apStartLoop()
    if AP.loopConn then AP.loopConn:Disconnect() end
    AP.currentStep = 1
    AP.isWaiting   = false
    AP._speedWas   = nil   -- FIX: clear any stale saved state before starting

    AP.loopConn = S.RunService.Heartbeat:Connect(function()
        if not AP.enabled or AP.isWaiting then return end
        local char = character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local key    = AP.SEQUENCE[AP.currentStep]
        local target = apGetTarget(key)
        local flat   = Vector3.new(target.X, hrp.Position.Y, target.Z)
        local dist   = (flat - hrp.Position).Magnitude

        -- Step 4 is first return step — pause Speed GUI exactly once
        if AP.currentStep == 4 and AP._speedWas == nil then
            AP._speedWas = CONFIG.SPEED_ENABLED  -- FIX: saved at AP level, accessible everywhere
            CONFIG.SPEED_ENABLED = false
        end

        if dist > apGetRadius(key) then
            local dir = (flat - hrp.Position).Unit
            hum:Move(dir, false)
            if AP.currentStep <= 3 then
                -- Forward to grab: light nudge, Speed GUI drives actual speed
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X * 0.01, hrp.AssemblyLinearVelocity.Y, dir.Z * 0.01)
            else
                -- Return: use STEAL_SPEED_VALUE directly
                local spd = CONFIG.STEAL_SPEED_VALUE or 30
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X * spd, hrp.AssemblyLinearVelocity.Y, dir.Z * spd)
            end
        else
            if key == "P5" then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                AP.isWaiting = true
                task.delay(CONFIG.AUTO_PLAY_DELAY or 0.03, function()
                    AP.isWaiting   = false
                    AP.currentStep = AP.currentStep + 1
                end)
            elseif AP.currentStep == #AP.SEQUENCE then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                apStopLoop()   -- FIX: apStopLoop now handles speed restore
                task.defer(apResetBtns)
            else
                AP.currentStep = AP.currentStep + 1
            end
        end
    end)
    addConnection(AP.loopConn)
end

-- apLaunchSide: explicit side, toggle behaviour
local function apLaunchSide(side)
    if not canRunAutoPlay() then
        showNotification("Auto Play", false)
        return
    end
    if not side then showNotification("Auto Play", false); return end
    if AP.enabled and AP.activeSide == side then
        apStopLoop()
        apSetBtnActive(apBtnL, false)
        apSetBtnActive(apBtnR, false)
        showNotification("Auto Play", false)
    else
        apStopLoop()
        AP.activeSide = side
        apRefreshESP()
        AP.enabled = true
        apStartLoop()
        apSetBtnActive(apBtnL, side == "L")
        apSetBtnActive(apBtnR, side == "R")
        showNotification("Auto Play " .. side, true)
    end
end

-- ======================================
-- AUTO MEDUSA SYSTEM
-- ======================================

local function setupMedusaIndicator(char)
    if not char then return end
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if not root then return end
    
    if medusaCircle then medusaCircle:Destroy() end
    
    medusaCircle = Instance.new("CylinderHandleAdornment")
    medusaCircle.Name = "MedusaRadius"
    medusaCircle.Adornee = root
    medusaCircle.AlwaysOnTop = true
    medusaCircle.ZIndex = 5
    medusaCircle.Transparency = 0.6
    medusaCircle.Color3 = Color3.fromRGB(0, 255, 255)
    medusaCircle.Radius = CONFIG.AUTO_MEDUSA_RANGE
    medusaCircle.Height = 0.05
    medusaCircle.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)
    medusaCircle.Parent = root
end

local function startAutoMedusa()
    if autoMedusaConnection then return end
    
    if character then
        setupMedusaIndicator(character)
    end
    
    if not medusaCharAddedConnection then
        medusaCharAddedConnection = S.LocalPlayer.CharacterAdded:Connect(function(newChar)
            if CONFIG.AUTO_MEDUSA_ENABLED then
                setupMedusaIndicator(newChar)
            end
        end)
    end

    autoMedusaConnection = S.RunService.Heartbeat:Connect(function()
        if not CONFIG.AUTO_MEDUSA_ENABLED then return end
        
        if medusaCircle then
            medusaCircle.Radius = CONFIG.AUTO_MEDUSA_RANGE
        end
        
        local char = character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local equippedTool
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Tool") and v.Name:lower():find("medusa") then
                equippedTool = v
                break
            end
        end
        
        if not equippedTool then return end
        
        for _, p in ipairs(S.Players:GetPlayers()) do
            if p ~= S.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist <= CONFIG.AUTO_MEDUSA_RANGE then
                    pcall(function() equippedTool:Activate() end)
                    break
                end
            end
        end
    end)
    addConnection(autoMedusaConnection)
end

local function stopAutoMedusa()
    if autoMedusaConnection then
        autoMedusaConnection:Disconnect()
        autoMedusaConnection = nil
    end
    if medusaCircle then
        medusaCircle:Destroy()
        medusaCircle = nil
    end
end

-- ======================================
-- INSTANT GRAB SYSTEM
-- ======================================

local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local STEAL_DURATION = 0.2
local autoStealEnabled = false
local isStealing = false
local stealStartTime = nil
local StealData = {}
local autoStealConn = nil
local stealProgressConnection = nil
local stealScreenGui = nil
local stealFillFrame = nil

local function ResetStealProgressBar()
    if stealFillFrame then
        stealFillFrame.Size = UDim2.new(0, 0, 1, 0)
        stealFillFrame.Visible = false
    end
    if stealScreenGui and CONFIG.GRAB_BAR_VISIBLE then
        stealScreenGui.Enabled = true
    elseif stealScreenGui then
        stealScreenGui.Enabled = false
    end
end

local function isMyPlotByName(pn)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(pn)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    if not HRP then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local np, nd, nn = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then continue end
        for _, pod in ipairs(podiums:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - HRP.Position).Magnitude
                    if dist < nd and dist <= CONFIG.INSTANT_GRAB_ACTIVATION_DIST then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, ch in ipairs(att:GetChildren()) do
                                if ch:IsA("ProximityPrompt") then np, nd, nn = ch, dist, pod.Name break end
                            end
                        end
                    end
                end
            end)
        end
    end
    return np, nd, nn
end

local function executeSteal(prompt, name)
    if isStealing then return end
    if not StealData[prompt] then
        StealData[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(StealData[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    
    local data = StealData[prompt]
    if not data.ready then return end
    
    data.ready = false
    isStealing = true
    stealStartTime = tick()
    
    if stealScreenGui and CONFIG.GRAB_BAR_VISIBLE then stealScreenGui.Enabled = true end
    if stealFillFrame then
        stealFillFrame.Size = UDim2.new(0, 0, 1, 0)
        stealFillFrame.Visible = true
    end
    
    -- Heartbeat-driven progress (k7 style) — guaranteed accurate fill
    if stealProgressConnection then stealProgressConnection:Disconnect() end
    stealProgressConnection = S.RunService.Heartbeat:Connect(function()
        if not isStealing then
            if stealProgressConnection then stealProgressConnection:Disconnect() stealProgressConnection = nil end
            return
        end
        local prog = math.clamp((tick() - stealStartTime) / STEAL_DURATION, 0, 1)
        if stealFillFrame then stealFillFrame.Size = UDim2.new(prog, 0, 1, 0) end
    end)
    
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        -- Elapsed loop from k7 — ticks until full duration passes precisely
        local elapsed = 0
        while elapsed < STEAL_DURATION do elapsed = elapsed + task.wait() end
        for _, f in ipairs(data.trigger) do task.spawn(f) end
        -- Force bar to 100% before reset so it visually completes
        if stealFillFrame then stealFillFrame.Size = UDim2.new(1, 0, 1, 0) end
        task.wait(0.05) -- brief hold at 100% so user sees full bar
        if stealProgressConnection then stealProgressConnection:Disconnect() stealProgressConnection = nil end
        ResetStealProgressBar()
        data.ready = true
        isStealing = false
    end)
end

local function createStealGui()
    if stealScreenGui then return end

    local CoreGui = game:GetService("CoreGui")
    local guiParent

    stealScreenGui = Instance.new("ScreenGui")
    stealScreenGui.Name = "Looprix_AutoSteal_GUI"
    stealScreenGui.ResetOnSpawn = false
    stealScreenGui.DisplayOrder = 100
    stealScreenGui.IgnoreGuiInset = true
    stealScreenGui.Enabled = CONFIG.GRAB_BAR_VISIBLE

    pcall(function()
        if gethui then
            guiParent = gethui()
        elseif syn and syn.protect_gui then
            guiParent = S.PlayerGui
            syn.protect_gui(stealScreenGui)
        else
            guiParent = CoreGui
        end
    end)
    if not guiParent then guiParent = S.PlayerGui end
    stealScreenGui.Parent = guiParent

    -- ── Outer card — same look as stats island ──────────────────────────────
    local grabBar = Instance.new("Frame")
    grabBar.Name = "GrabBar"
    grabBar.Size = UDim2.new(0, 165, 0, 22)
    grabBar.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    grabBar.BackgroundTransparency = 0.15
    grabBar.BorderSizePixel = 0
    grabBar.Parent = stealScreenGui
    registerScaleTarget(grabBar)

    local savedGrab = CONFIG._guiPositions and CONFIG._guiPositions.grabBar
    if savedGrab then
        grabBar.Position = UDim2.new(savedGrab.scaleX, savedGrab.offsetX, savedGrab.scaleY, savedGrab.offsetY)
    else
        grabBar.Position = UDim2.new(0.5, -82, 0, 44)
    end

    Instance.new("UICorner", grabBar).CornerRadius = UDim.new(0, 6)

    -- Animated rotating gradient border — same as stats island
    local igStroke = Instance.new("UIStroke", grabBar)
    igStroke.Thickness = 1
    igStroke.Color = COLORS.Accent
    igStroke.Transparency = 0.1
    igStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(igStroke)

    local igBorderGrad = Instance.new("UIGradient", igStroke)
    igBorderGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,217,127)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,217,127))
    })
    trackGradient(igBorderGrad)
    S.RunService.RenderStepped:Connect(function()
        igBorderGrad.Rotation = (tick() * 80) % 360
    end)

    -- ── Status label left ────────────────────────────────────────────────────
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(0, 48, 1, 0)
    statusLbl.Position = UDim2.new(0, 6, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "Ready"
    statusLbl.TextColor3 = COLORS.Accent
    statusLbl.TextScaled = false
    statusLbl.TextSize = 10
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.ZIndex = 4
    statusLbl.Parent = grabBar
    trackLabel(statusLbl)

    -- ── Progress bar track (centre) ──────────────────────────────────────────
    -- Layout (bar=165px): statusLbl x=6 w=48→54 | gap 4 | track x=58 w=74→132 | gap 9 | badge x=141 w=20→161 | pad 4
    local barTrack = Instance.new("Frame")
    barTrack.Size = UDim2.new(0, 74, 0, 6)
    barTrack.Position = UDim2.new(0, 58, 0.5, -3)
    barTrack.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    barTrack.BackgroundTransparency = 0.1
    barTrack.BorderSizePixel = 0
    barTrack.ClipsDescendants = true
    barTrack.ZIndex = 3
    barTrack.Parent = grabBar
    Instance.new("UICorner", barTrack).CornerRadius = UDim.new(1, 0)

    -- Outline on the progress track — same gradient colour as outer border
    local trackStrokeEl = Instance.new("UIStroke", barTrack)
    trackStrokeEl.Thickness = 1
    trackStrokeEl.Transparency = 0.2
    trackStrokeEl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStrokeEl.Color = COLORS.Accent
    trackStroke(trackStrokeEl)

    local trackGrad = Instance.new("UIGradient", trackStrokeEl)
    trackGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,217,127)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,217,127))
    })
    trackGradient(trackGrad)
    S.RunService.RenderStepped:Connect(function()
        trackGrad.Rotation = (tick() * 80) % 360
    end)

    -- Fill frame — lives inside barTrack so ClipsDescendants ensures clean edge
    stealFillFrame = Instance.new("Frame")
    stealFillFrame.Name = "Fill"
    stealFillFrame.Size = UDim2.new(0, 0, 1, 0)
    stealFillFrame.BackgroundColor3 = COLORS.Accent
    stealFillFrame.BackgroundTransparency = 0
    stealFillFrame.BorderSizePixel = 0
    stealFillFrame.Visible = false
    stealFillFrame.ZIndex = 4
    stealFillFrame.Parent = barTrack
    trackFrame(stealFillFrame)
    Instance.new("UICorner", stealFillFrame).CornerRadius = UDim.new(1, 0)

    -- ── Distance badge right ─────────────────────────────────────────────────
    local distBadge = Instance.new("TextLabel")
    distBadge.Size = UDim2.new(0, 20, 0, 12)
    distBadge.Position = UDim2.new(1, -24, 0.5, -6)
    distBadge.BackgroundColor3 = COLORS.Surface
    distBadge.BackgroundTransparency = 0.3
    distBadge.BorderSizePixel = 0
    distBadge.Text = tostring(CONFIG.INSTANT_GRAB_ACTIVATION_DIST)
    distBadge.TextColor3 = COLORS.Accent
    distBadge.TextScaled = false
    distBadge.TextSize = 8
    distBadge.Font = Enum.Font.GothamBold
    distBadge.TextXAlignment = Enum.TextXAlignment.Center
    distBadge.ZIndex = 4
    distBadge.Parent = grabBar
    trackLabel(distBadge)
    Instance.new("UICorner", distBadge).CornerRadius = UDim.new(0, 3)
    local distStroke = Instance.new("UIStroke", distBadge)
    distStroke.Thickness = 1
    distStroke.Transparency = 0.2
    distStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    distStroke.Color = COLORS.Accent
    trackStroke(distStroke)
    local distGrad = Instance.new("UIGradient", distStroke)
    distGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,217,127)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,217,127))
    })
    trackGradient(distGrad)
    S.RunService.RenderStepped:Connect(function()
        distGrad.Rotation = (tick() * 80) % 360
    end)

    -- ── Keep distance badge synced ────────────────────────────────────────────
    task.spawn(function()
        local last = CONFIG.INSTANT_GRAB_ACTIVATION_DIST
        while grabBar and grabBar.Parent do
            task.wait(0.25)
            local cur = CONFIG.INSTANT_GRAB_ACTIVATION_DIST
            if cur ~= last then
                last = cur
                distBadge.Text = tostring(cur)
            end
        end
    end)

    -- ── Sync status text ──────────────────────────────────────────────────────
    task.spawn(function()
        while grabBar and grabBar.Parent do
            task.wait(0.1)
            if isStealing then
                statusLbl.Text = "Grabbing"
            else
                statusLbl.Text = "Ready"
            end
        end
    end)

    -- ── Drag (respects UI_LOCKED) ─────────────────────────────────────────────
    local gbDragging = false
    local gbDragStart, gbStartPos

    grabBar.InputBegan:Connect(function(inp)
        if CONFIG.UI_LOCKED then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            gbDragging = true
            gbDragStart = inp.Position
            gbStartPos  = grabBar.Position
        end
    end)

    S.UserInputService.InputChanged:Connect(function(inp)
        if not gbDragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or
           inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - gbDragStart
            grabBar.Position = UDim2.new(
                gbStartPos.X.Scale, gbStartPos.X.Offset + delta.X,
                gbStartPos.Y.Scale, gbStartPos.Y.Offset + delta.Y
            )
        end
    end)

    S.UserInputService.InputEnded:Connect(function(inp)
        if gbDragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch) then
            gbDragging = false
            CONFIG._guiPositions = CONFIG._guiPositions or {}
            CONFIG._guiPositions.grabBar = {
                scaleX  = grabBar.Position.X.Scale,
                scaleY  = grabBar.Position.Y.Scale,
                offsetX = grabBar.Position.X.Offset,
                offsetY = grabBar.Position.Y.Offset,
            }
            saveConfig()
        end
    end)
    -- Re-apply saved accent color so grab bar elements get the right color
    -- regardless of when createStealGui() is called relative to applyAccentColor()
    pcall(function()
        applyAccentColor(CONFIG.GUI_COLOR_R or 0, CONFIG.GUI_COLOR_G or 217, CONFIG.GUI_COLOR_B or 127)
    end)
end

local function startInstantGrab()
    if autoStealConn then return end
    
    createStealGui()
    autoStealEnabled = true
    
    autoStealConn = S.RunService.Heartbeat:Connect(function()
        if not CONFIG.INSTANT_GRAB_ENABLED or isStealing then return end
        local p, _, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    addConnection(autoStealConn)
end

local function stopInstantGrab()
    autoStealEnabled = false
    if autoStealConn then
        autoStealConn:Disconnect()
        autoStealConn = nil
    end
    if stealProgressConnection then
        stealProgressConnection:Disconnect()
        stealProgressConnection = nil
    end
    ResetStealProgressBar()
end

-- ======================================
-- FLOATING PANELS
-- ======================================

local function createFloatingPanel(name, configPath, configVisible, defaultText)
    local panelGui = Instance.new("ScreenGui", S.PlayerGui)
    panelGui.Name = "Looprix_Floating_" .. name
    panelGui.ResetOnSpawn = false
    panelGui.DisplayOrder = 999998
    panelGui.Enabled = CONFIG[configVisible]

    local frame = Instance.new("TextButton", panelGui)
    frame.Size = UDim2.new(0, 100, 0, 33)
    frame.BackgroundTransparency = 0.15
    frame.BackgroundColor3 = Color3.fromRGB(12, 14, 20)

    loadGuiPosition(frame, configPath)
    if frame.Position.X.Offset == 0 and frame.Position.Y.Offset == 0 then
        frame.Position = UDim2.new(0, 0, 0, 0)
    end

    frame.Text = defaultText
    frame.TextColor3 = COLORS.Accent
    frame.Font = Enum.Font.GothamBold
    frame.TextSize = 11
    frame.AutoButtonColor = false
    trackLabel(frame)

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    registerScaleTarget(frame)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = COLORS.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(stroke)

    local strokeGrad = Instance.new("UIGradient", stroke)
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,217,127)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,217,127))
    })
    trackGradient(strokeGrad)
    S.RunService.RenderStepped:Connect(function()
        strokeGrad.Rotation = (tick() * 80) % 360
    end)

    local isDragging = false
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)
        if CONFIG.UI_LOCKED then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    S.UserInputService.InputChanged:Connect(function(input)
        if CONFIG.UI_LOCKED then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStart and (input.Position - dragStart).Magnitude > 5 then
                isDragging = true
                local delta = input.Position - dragStart
                local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                frame.Position = newPos
            end
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                saveGuiPosition(frame, configPath)
            end
            dragStart = nil
            isDragging = false
        end
    end)

    -- Ensure accent color is applied to this panel's tracked elements
    pcall(function()
        applyAccentColor(CONFIG.GUI_COLOR_R or 0, CONFIG.GUI_COLOR_G or 217, CONFIG.GUI_COLOR_B or 127)
    end)

    return panelGui, frame
end

-- ======================================
-- SPEED GUI
-- ======================================

local function createSpeedGui()
    local W = 160
    local HDR_H = 24
    local ROW_H = 32
    local GAP = 4
    local PAD = 6
    local FULL_H = HDR_H + PAD + (ROW_H * 3) + (GAP * 2) + PAD

    local sg = Instance.new("ScreenGui", S.PlayerGui)
    sg.Name = "Looprix_SpeedGui"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999998
    sg.Enabled = CONFIG.SPEED_GUI_VISIBLE

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, W, 0, FULL_H)
    main.BackgroundColor3 = COLORS.Background
    main.BackgroundTransparency = 0.1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    registerScaleTarget(main)

    loadGuiPosition(main, "speedGui")
    if main.Position.X.Offset == 0 and main.Position.Y.Offset == 0 then
        main.Position = UDim2.new(0, 10, 0, 55)
    end

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Thickness = 1.2
    mainStroke.Color = COLORS.Accent
    mainStroke.Transparency = 0.0
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(mainStroke)
    local sg_ = Instance.new("UIGradient", mainStroke)
    sg_.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.Accent),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(120, 255, 200)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(150, 255, 180)),
        ColorSequenceKeypoint.new(1, COLORS.Accent),
    })
    trackGradient(sg_)
    S.RunService.RenderStepped:Connect(function() sg_.Rotation = (tick() * 55) % 360 end)

    local hdr = Instance.new("Frame", main)
    hdr.Size = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = COLORS.Surface
    hdr.BackgroundTransparency = 0.05
    hdr.BorderSizePixel = 0
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 8)
    local hdrFill = Instance.new("Frame", hdr)
    hdrFill.Size = UDim2.new(1, 0, 0, 10)
    hdrFill.Position = UDim2.new(0, 0, 1, -10)
    hdrFill.BackgroundColor3 = COLORS.Surface
    hdrFill.BackgroundTransparency = 0.05
    hdrFill.BorderSizePixel = 0

    local dot = Instance.new("Frame", hdr)
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(0, 9, 0.5, -3)
    dot.BackgroundColor3 = COLORS.Accent
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    trackDot(dot)

    local titleLbl = Instance.new("TextLabel", hdr)
    titleLbl.Size = UDim2.new(1, -45, 1, 0)
    titleLbl.Position = UDim2.new(0, 20, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Speed"
    titleLbl.TextColor3 = COLORS.Text
    titleLbl.Font = Enum.Font.GothamSemibold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    local tg = Instance.new("UIGradient", titleLbl)
    tg.Color = sg_.Color
    trackGradient(tg)
    S.RunService.RenderStepped:Connect(function() tg.Offset = Vector2.new(math.sin(tick() * 1.1) * 0.5, 0) end)

    local minBtn = Instance.new("TextButton", hdr)
    minBtn.Size = UDim2.new(0, 20, 0, 16)
    minBtn.Position = UDim2.new(1, -25, 0.5, -8)
    minBtn.BackgroundColor3 = COLORS.Background
    minBtn.BackgroundTransparency = 0.15
    minBtn.Text = "-"
    minBtn.TextColor3 = COLORS.Accent
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.BorderSizePixel = 0
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)
    trackLabel(minBtn)
    local ms = Instance.new("UIStroke", minBtn)
    ms.Color = COLORS.Accent
    ms.Thickness = 1
    ms.Transparency = 0.4
    trackStroke(ms)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, 0, 1, -HDR_H)
    content.Position = UDim2.new(0, 0, 0, HDR_H)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ClipsDescendants = false

    local ll = Instance.new("UIListLayout", content)
    ll.FillDirection = Enum.FillDirection.Vertical
    ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ll.VerticalAlignment = Enum.VerticalAlignment.Top
    ll.Padding = UDim.new(0, GAP)
    ll.SortOrder = Enum.SortOrder.LayoutOrder

    local uip = Instance.new("UIPadding", content)
    uip.PaddingLeft = UDim.new(0, PAD)
    uip.PaddingRight = UDim.new(0, PAD)
    uip.PaddingTop = UDim.new(0, PAD)
    uip.PaddingBottom = UDim.new(0, PAD)

    local IW = W - PAD * 2
    local BOX_W = 45
    local BOX_POS = IW - BOX_W - 4

    local function makeRow(lo, labelText)
        local f = Instance.new("Frame", content)
        f.LayoutOrder = lo
        f.Size = UDim2.new(1, 0, 0, ROW_H)
        f.BackgroundColor3 = COLORS.Surface
        f.BackgroundTransparency = 0.08
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
        local rs = Instance.new("UIStroke", f)
        rs.Color = COLORS.Accent
        rs.Thickness = 1
        rs.Transparency = 0.65
        rs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(0.45, 0, 0, 16)
        lbl.Position = UDim2.new(0, 8, 0, 5)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = COLORS.TextDim
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        return f
    end

    local function makeBox(parent, xOff, wOff, defText, tColor)
        local box = Instance.new("TextBox", parent)
        box.Size = UDim2.new(0, wOff, 0, 17)
        box.Position = UDim2.new(0, xOff, 1, -22)
        box.BackgroundColor3 = COLORS.Background
        box.BackgroundTransparency = 0.0
        box.Text = defText
        box.TextColor3 = tColor or COLORS.Accent
        box.Font = Enum.Font.GothamBold
        box.TextSize = 10
        box.ClearTextOnFocus = false
        box.BorderSizePixel = 0
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        local s = Instance.new("UIStroke", box)
        s.Color = COLORS.Accent
        s.Thickness = 1
        s.Transparency = 0.55
        return box
    end

    local r0 = makeRow(0, "Status:")
    local statusBtn = Instance.new("TextButton", r0)
    statusBtn.Size = UDim2.new(0, BOX_W, 0, 17)
    statusBtn.Position = UDim2.new(0, BOX_POS, 1, -22)
    statusBtn.BackgroundColor3 = CONFIG.SPEED_ENABLED and COLORS.Accent or COLORS.Background
    statusBtn.Text = CONFIG.SPEED_ENABLED and "ON" or "OFF"
    statusBtn.TextColor3 = COLORS.Text
    statusBtn.Font = Enum.Font.GothamBold
    statusBtn.TextSize = 10
    statusBtn.BorderSizePixel = 0
    Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 4)
    local statusStroke = Instance.new("UIStroke", statusBtn)
    statusStroke.Color = COLORS.Accent
    statusStroke.Thickness = 1
    statusStroke.Transparency = 0.55

    local r1 = makeRow(1, "Normal:")
    local b1 = makeBox(r1, BOX_POS, BOX_W, tostring(CONFIG.SPEED_VALUE), COLORS.Accent)
    b1.FocusLost:Connect(function()
        local v = tonumber(b1.Text) or CONFIG.SPEED_VALUE
        CONFIG.SPEED_VALUE = math.clamp(v, 0, 70)
        b1.Text = tostring(CONFIG.SPEED_VALUE)
        saveConfig()
    end)

    local r2 = makeRow(2, "Steal:")
    local b2 = makeBox(r2, BOX_POS, BOX_W, tostring(CONFIG.STEAL_SPEED_VALUE), COLORS.Accent)
    b2.FocusLost:Connect(function()
        local v = tonumber(b2.Text) or CONFIG.STEAL_SPEED_VALUE
        CONFIG.STEAL_SPEED_VALUE = math.clamp(v, 0, 40)
        b2.Text = tostring(CONFIG.STEAL_SPEED_VALUE)
        saveConfig()
    end)

    statusBtn.MouseButton1Click:Connect(function()
        CONFIG.SPEED_ENABLED = not CONFIG.SPEED_ENABLED
        statusBtn.BackgroundColor3 = CONFIG.SPEED_ENABLED and COLORS.Accent or COLORS.Background
        statusBtn.Text = CONFIG.SPEED_ENABLED and "ON" or "OFF"
        saveConfig()
    end)

    local speedMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        speedMinimized = not speedMinimized
        if speedMinimized then
            hdrFill.Visible = false
            content.Visible = false
            S.TweenService:Create(main, tweenInfoMedium, {Size = UDim2.new(0, W, 0, HDR_H)}):Play()
            minBtn.Text = "+"
        else
            hdrFill.Visible = true
            content.Visible = true
            S.TweenService:Create(main, tweenInfoMedium, {Size = UDim2.new(0, W, 0, FULL_H)}):Play()
            minBtn.Text = "-"
        end
    end)

    local isDragging = false
    local dragStart
    local startPos

    main.InputBegan:Connect(function(input)
        if CONFIG.UI_LOCKED then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    S.UserInputService.InputChanged:Connect(function(input)
        if CONFIG.UI_LOCKED then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStart and (input.Position - dragStart).Magnitude > 5 then
                isDragging = true
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                saveGuiPosition(main, "speedGui")
            end
            dragStart = nil
            isDragging = false
        end
    end)

    local speedConn = S.RunService.Heartbeat:Connect(function()
        if not CONFIG.SPEED_ENABLED then return end
        local char = character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.MoveDirection.Magnitude > 0 then
            local isStealing = S.LocalPlayer:GetAttribute("Stealing")
            local vel = isStealing and CONFIG.STEAL_SPEED_VALUE or CONFIG.SPEED_VALUE
            root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * vel, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * vel)
        end
    end)
    addConnection(speedConn)

    return sg
end

-- ======================================
-- AUTO PLAY GUI
-- ======================================

local function createAutoPlayGui()
    local W      = 148
    local HDR_H  = 20
    local BTN_H  = 24
    local GAP    = 4
    local PAD    = 5
    local FULL_H = HDR_H + PAD + BTN_H + PAD

    local sg = Instance.new("ScreenGui", S.PlayerGui)
    sg.Name = "Looprix_AutoPlayGui"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999998
    sg.Enabled = CONFIG.AUTO_PLAY_GUI_VISIBLE

    local function makeAccentStroke(parent, thick, initT)
        local s = Instance.new("UIStroke", parent)
        s.Thickness = thick or 1.2
        s.Color = COLORS.Accent
        s.Transparency = initT or 0
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        trackStroke(s)
        local g = Instance.new("UIGradient", s)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    COLORS.Accent),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(120,255,200)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(150,255,180)),
            ColorSequenceKeypoint.new(1,    COLORS.Accent),
        })
        trackGradient(g)
        S.RunService.RenderStepped:Connect(function() g.Rotation=(tick()*55)%360 end)
        return s, g
    end

    -- MAIN WINDOW
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, W, 0, FULL_H)
    main.BackgroundColor3 = COLORS.Background
    main.BackgroundTransparency = 0.08
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    registerScaleTarget(main)

    local savedAP = CONFIG._guiPositions and CONFIG._guiPositions.autoPlayMain
    if savedAP then
        main.Position = UDim2.new(savedAP.scaleX, savedAP.offsetX, savedAP.scaleY, savedAP.offsetY)
    else
        main.Position = UDim2.new(0, 10, 0, 160)
    end
    makeAccentStroke(main, 1.2, 0)

    local hdr = Instance.new("Frame", main)
    hdr.Size = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = COLORS.Surface
    hdr.BackgroundTransparency = 0.05
    hdr.BorderSizePixel = 0
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 10)
    local hdrFill = Instance.new("Frame", hdr)
    hdrFill.Size = UDim2.new(1,0,0,10); hdrFill.Position = UDim2.new(0,0,1,-10)
    hdrFill.BackgroundColor3 = COLORS.Surface; hdrFill.BackgroundTransparency = 0.05
    hdrFill.BorderSizePixel = 0

    local dot = Instance.new("Frame", hdr)
    dot.Size = UDim2.new(0,6,0,6); dot.Position = UDim2.new(0,9,0.5,-3)
    dot.BackgroundColor3 = COLORS.Accent; dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    trackDot(dot)

    local titleLbl = Instance.new("TextLabel", hdr)
    titleLbl.Size = UDim2.new(1,-34,1,0); titleLbl.Position = UDim2.new(0,20,0,0)
    titleLbl.BackgroundTransparency = 1; titleLbl.Text = "Auto Play"
    titleLbl.TextColor3 = COLORS.Text; titleLbl.Font = Enum.Font.GothamSemibold
    titleLbl.TextSize = 11; titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    local titleGrad = Instance.new("UIGradient", titleLbl)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    COLORS.Accent),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(120,255,200)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(1,    COLORS.Accent),
    })
    trackGradient(titleGrad)
    S.RunService.RenderStepped:Connect(function()
        titleGrad.Offset = Vector2.new(math.sin(tick()*1.1)*0.5, 0)
    end)

    local minBtn = Instance.new("TextButton", hdr)
    minBtn.Size = UDim2.new(0,20,0,18); minBtn.Position = UDim2.new(1,-24,0.5,-9)
    minBtn.BackgroundColor3 = COLORS.Background; minBtn.BackgroundTransparency = 0.2
    minBtn.Text = "-"; minBtn.TextColor3 = COLORS.Accent
    minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 14; minBtn.BorderSizePixel = 0
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,4)
    makeAccentStroke(minBtn, 1, 0.4); trackLabel(minBtn)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1,0,1,-HDR_H); content.Position = UDim2.new(0,0,0,HDR_H)
    content.BackgroundTransparency = 1; content.BorderSizePixel = 0
    local btnLayout = Instance.new("UIListLayout", content)
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, GAP)
    local btnPad = Instance.new("UIPadding", content)
    btnPad.PaddingLeft=UDim.new(0,PAD); btnPad.PaddingRight=UDim.new(0,PAD)
    btnPad.PaddingTop=UDim.new(0,PAD); btnPad.PaddingBottom=UDim.new(0,PAD)

    local HALF_W = (W - PAD*2 - GAP) / 2

    local function makeAPBtn(side)
        local btn = Instance.new("TextButton", content)
        btn.LayoutOrder = (side == "L") and 1 or 2
        btn.Size = UDim2.new(0, HALF_W, 0, BTN_H)
        btn.BackgroundColor3 = COLORS.Surface
        btn.BackgroundTransparency = COLORS.SurfaceTransparency
        btn.Text = (side == "L") and "◀ Auto L" or "Auto R ▶"
        btn.TextColor3 = COLORS.TextDim
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
        makeAccentStroke(btn, 1, 0.45)
        local badge = Instance.new("TextLabel", btn)
        badge.Size = UDim2.new(0,38,0,11); badge.AnchorPoint = Vector2.new(1,0)
        badge.Position = UDim2.new(1,-2,1,-5)
        badge.BackgroundColor3 = COLORS.Background; badge.BackgroundTransparency = 0.15
        badge.BorderSizePixel = 0; badge.Font = Enum.Font.GothamBold; badge.TextSize = 7
        badge.TextColor3 = COLORS.Accent; badge.ZIndex = 5
        local cfgKey = "AUTO_PLAY_" .. side .. "_KEYBIND"
        badge.Text = CONFIG[cfgKey] and CONFIG[cfgKey].Name or "NONE"
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0,3)
        makeAccentStroke(badge, 1, 0.35); trackLabel(badge)
        task.spawn(function()
            while btn and btn.Parent do
                task.wait(0.5)
                badge.Text = CONFIG[cfgKey] and CONFIG[cfgKey].Name or "NONE"
            end
        end)
        btn.MouseButton1Click:Connect(function() apLaunchSide(side) end)
        return btn
    end

    apBtnL = makeAPBtn("L")
    apBtnR = makeAPBtn("R")

    local apMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        apMinimized = not apMinimized
        if apMinimized then
            hdrFill.Visible=false; content.Visible=false
            S.TweenService:Create(main, tweenInfoMedium, {Size=UDim2.new(0,W,0,HDR_H)}):Play()
            minBtn.Text="+"
        else
            hdrFill.Visible=true; content.Visible=true
            S.TweenService:Create(main, tweenInfoMedium, {Size=UDim2.new(0,W,0,FULL_H)}):Play()
            minBtn.Text="-"
        end
    end)

    -- Drag main
    local apDrag,apDS,apDSP=false,nil,nil
    main.InputBegan:Connect(function(inp)
        if CONFIG.UI_LOCKED then return end
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            apDrag=false; apDS=inp.Position; apDSP=main.Position
        end
    end)
    S.UserInputService.InputChanged:Connect(function(inp)
        if CONFIG.UI_LOCKED or not apDS then return end
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
            if (inp.Position-apDS).Magnitude>5 then
                apDrag=true
                local d=inp.Position-apDS
                main.Position=UDim2.new(apDSP.X.Scale,apDSP.X.Offset+d.X,apDSP.Y.Scale,apDSP.Y.Offset+d.Y)
            end
        end
    end)
    main.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            if apDrag then
                CONFIG._guiPositions=CONFIG._guiPositions or {}
                CONFIG._guiPositions.autoPlayMain={scaleX=main.Position.X.Scale,scaleY=main.Position.Y.Scale,offsetX=main.Position.X.Offset,offsetY=main.Position.Y.Offset,visible=CONFIG.AUTO_PLAY_GUI_VISIBLE}
                saveConfig()
            end
            apDrag=false; apDS=nil
        end
    end)

    -- Load saved offsets
    if CONFIG._autoPlayOffsets then
        for _, side in ipairs({"L","R"}) do
            for _, key in ipairs(AP.POINT_KEYS) do
                if CONFIG._autoPlayOffsets[side] and CONFIG._autoPlayOffsets[side][key] then
                    AP.offsets[side][key].x=CONFIG._autoPlayOffsets[side][key].x or 0
                    AP.offsets[side][key].z=CONFIG._autoPlayOffsets[side][key].z or 0
                end
            end
        end
    end

    apGuiInstance=sg
    pcall(function()
        applyAccentColor(CONFIG.GUI_COLOR_R or 0, CONFIG.GUI_COLOR_G or 217, CONFIG.GUI_COLOR_B or 127)
    end)
    return sg
end



-- ======================================
-- FLOATING PANELS SETUP
-- ======================================

local function setupFloatingPanels()

    lockTargetPanelGui, lockTargetPanelBtn = createFloatingPanel("LockTarget", "lockPanel", "LOCK_TARGET_PANEL_VISIBLE", "LOCK: " .. (CONFIG.LOCK_TARGET_ENABLED and "ON" or "OFF"))

    if CONFIG.LOCK_TARGET_ENABLED then lockTargetPanelBtn.TextColor3 = COLORS.Accent end

    lockTargetPanelBtn.Activated:Connect(function()
        CONFIG.LOCK_TARGET_ENABLED = not CONFIG.LOCK_TARGET_ENABLED
        lockTargetEnabled = CONFIG.LOCK_TARGET_ENABLED
        lockTargetPanelBtn.Text = "LOCK: " .. (lockTargetEnabled and "ON" or "OFF")
        lockTargetPanelBtn.TextColor3 = COLORS.Accent
        saveConfig()
        if lockTargetEnabled then startLockTarget() else stopLockTarget() end
    end)

    dropBrainrotPanelGui, dropBrainrotPanelBtn = createFloatingPanel("DropBrainrot", "dropBrainrotPanel", "DROP_BRAINROT_PANEL_VISIBLE", "DROP BRAINROT")

    dropBrainrotPanelBtn.Activated:Connect(function()
        executeDrop()
    end)
    
    spinbotPanelGui, spinbotPanelBtn = createFloatingPanel("Spinbot", "spinbotPanel", "SPINBOT_PANEL_VISIBLE", "SPIN: " .. (CONFIG.SPINBOT_ENABLED and "ON" or "OFF"))
    if CONFIG.SPINBOT_ENABLED then spinbotPanelBtn.TextColor3 = COLORS.Accent end

    spinbotPanelBtn.Activated:Connect(function()
        local newState = not CONFIG.SPINBOT_ENABLED
        -- Mutual exclusion: turning spinbot ON → force aimbot OFF
        if newState and CONFIG.AIMBOT_ENABLED then
            CONFIG.AIMBOT_ENABLED = false
            aimbotEnabled = false
            stopBodyAimbot()
            saveConfig()
            if _aimbotBtn then setToggleVisual(_aimbotBtn, false) end
            showNotification("Aimbot", false)
        end
        CONFIG.SPINBOT_ENABLED = newState
        spinbotEnabled = newState
        spinbotPanelBtn.Text = "SPIN: " .. (spinbotEnabled and "ON" or "OFF")
        spinbotPanelBtn.TextColor3 = COLORS.Accent
        if _spinbotBtn then setToggleVisual(_spinbotBtn, newState) end
        saveConfig()
        if spinbotEnabled then startSpinBot() else stopSpinBot() end
    end)

    floatPanelGui, floatPanelBtn = createFloatingPanel("Float", "floatPanel", "FLOAT_PANEL_VISIBLE", "FLOAT: " .. (floatEnabled and "ON" or "OFF"))

    if floatEnabled then floatPanelBtn.TextColor3 = COLORS.Accent end

    floatPanelBtn.Activated:Connect(function()
        floatEnabled = not floatEnabled
        floatPanelBtn.Text = "FLOAT: " .. (floatEnabled and "ON" or "OFF")
        floatPanelBtn.TextColor3 = COLORS.Accent
        if floatEnabled then startFloat() else stopFloat() end
    end)
    
    tauntPanelGui, tauntPanelBtn = createFloatingPanel("Taunt", "tauntPanel", "TAUNT_PANEL_VISIBLE", "TAUNT")

    tauntPanelBtn.Activated:Connect(function()
        pcall(function()
            local TextChatService = game:GetService("TextChatService")
            TextChatService.TextChannels.RBXGeneral:SendAsync("/Looprix Is The Best")
        end)
    end)

    flingPanelGui, flingPanelBtn = createFloatingPanel("Fling", "flingPanel", "FLING_PANEL_VISIBLE", "FLING: OFF")

    flingPanelBtn.Activated:Connect(function()
        flingEnabled = not flingEnabled
        flingPanelBtn.Text = "FLING: " .. (flingEnabled and "ON" or "OFF")
        flingPanelBtn.TextColor3 = COLORS.Accent
        if flingEnabled then startFling() else stopFling() end
        saveConfig()
    end)

    -- ── ANTI STEAL PANEL ──────────────────────────────────────────────────────
    antiStealPanelGui, antiStealPanelBtn = createFloatingPanel(
        "AntiSteal", "antiStealPanel", "ANTI_STEAL_PANEL_VISIBLE",
        "ANTI STEAL: " .. (CONFIG.ANTI_STEAL_PANEL_VISIBLE and "ON" or "OFF")
    )

    local antiStealEnabled = CONFIG.ANTI_STEAL_PANEL_VISIBLE or false
    local _antiStealConn   = nil

    local STEAL_KEYWORD = "someone is stealing"

    local function hasStealKeyword(text)
        if type(text) ~= "string" then return false end
        return string.find(string.lower(text), STEAL_KEYWORD, 1, true) ~= nil
    end

    -- Trigger: activate lock-target logic (reuse existing system)
    local function triggerAntiSteal()
        if not antiStealEnabled then return end
        if CONFIG.LOCK_TARGET_ENABLED then return end   -- already on
        CONFIG.LOCK_TARGET_ENABLED = true
        lockTargetEnabled = true
        startLockTarget()
        if lockTargetPanelBtn then
            lockTargetPanelBtn.Text = "LOCK: ON"
            lockTargetPanelBtn.TextColor3 = COLORS.Accent
        end
        showNotification("Anti Steal", true)
    end

    -- Watch a single text element
    local function watchTextElement(obj)
        if hasStealKeyword(obj.Text) then triggerAntiSteal() end
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if hasStealKeyword(obj.Text) then triggerAntiSteal() end
        end)
    end

    -- Scan all text inside a GUI subtree
    local function scanGui(parent)
        for _, desc in ipairs(parent:GetDescendants()) do
            if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                watchTextElement(desc)
            end
        end
        parent.DescendantAdded:Connect(function(desc)
            if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                watchTextElement(desc)
            end
        end)
    end

    local function startAntiStealWatcher()
        if _antiStealConn then return end
        local pg = S.LocalPlayer:WaitForChild("PlayerGui")
        for _, gui in ipairs(pg:GetChildren()) do
            scanGui(gui)
        end
        _antiStealConn = pg.ChildAdded:Connect(function(gui)
            scanGui(gui)
        end)
    end

    local function stopAntiStealWatcher()
        if _antiStealConn then
            _antiStealConn:Disconnect()
            _antiStealConn = nil
        end
    end

    if antiStealEnabled then startAntiStealWatcher() end

    -- ── TP DOWN PANEL ────────────────────────────────────────────────────────
    tpDownPanelGui, tpDownPanelBtn = createFloatingPanel("TpDown", "tpDownPanel", "TP_DOWN_PANEL_VISIBLE", "TP DOWN")
    tpDownPanelBtn.Activated:Connect(function()
        if floatEnabled then
            -- 1. stop float cleanly (also increments _floatGeneration, cancels any pending restart)
            stopFloat()
            if floatPanelBtn then floatPanelBtn.Text = "FLOAT: OFF" end
            local gen = _floatGeneration  -- capture AFTER stopFloat so we own this generation
            -- 2. wait a bit, then apply velocity
            task.delay(0.08, function()
                if _floatGeneration ~= gen then return end  -- user disabled float again
                local hrp2 = character and character:FindFirstChild("HumanoidRootPart")
                if hrp2 then
                    hrp2.AssemblyLinearVelocity = Vector3.new(
                        hrp2.AssemblyLinearVelocity.X, -100,
                        hrp2.AssemblyLinearVelocity.Z)
                end
                -- 3. restart float after landing; zero out any bounce first
                task.delay(0.14, function()
                    if _floatGeneration ~= gen then return end  -- user disabled float again
                    local hrp3 = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp3 then
                        local v = hrp3.AssemblyLinearVelocity
                        if v.Y > 0 then
                            hrp3.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
                        end
                    end
                    floatEnabled = true
                    if floatPanelBtn then floatPanelBtn.Text = "FLOAT: ON" end
                    startFloat()
                end)
            end)
        else
            tpDown()
        end
    end)

    -- ── AUTO LOCK PANEL ──────────────────────────────────────────────────────
    autoLockPanelGui, autoLockPanelBtn = createFloatingPanel(
        "AutoLock", "autoLockPanel", "AUTO_LOCK_PANEL_VISIBLE",
        "AUTO LOCK: " .. (CONFIG.AUTO_LOCK_PANEL_VISIBLE and "ON" or "OFF")
    )

    local autoLockEnabled2 = CONFIG.AUTO_LOCK_PANEL_VISIBLE or false
    local _autoLockConn    = nil

    local function triggerAutoLock()
        if not autoLockEnabled2 then return end
        if CONFIG.LOCK_TARGET_ENABLED then return end
        CONFIG.LOCK_TARGET_ENABLED = true
        lockTargetEnabled = true
        startLockTarget()
        if lockTargetPanelBtn then
            lockTargetPanelBtn.Text = "LOCK: ON"
            lockTargetPanelBtn.TextColor3 = COLORS.Accent
        end
        showNotification("Auto Lock", true)
    end

    local function startAutoLockWatcher()
        if _autoLockConn then return end
        _autoLockConn = S.RunService.Heartbeat:Connect(function()
            if not autoLockEnabled2 then return end
            local char = S.LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local state = hum:GetState()
            local ragdollStates = {
                [Enum.HumanoidStateType.Physics]     = true,
                [Enum.HumanoidStateType.Ragdoll]     = true,
                [Enum.HumanoidStateType.FallingDown] = true,
            }
            local endTime = S.LocalPlayer:GetAttribute("RagdollEndTime")
            local isRagdoll = ragdollStates[state] or
                (endTime and (endTime - workspace:GetServerTimeNow()) > 0)
            if isRagdoll then triggerAutoLock() end
        end)
    end

    local function stopAutoLockWatcher()
        if _autoLockConn then _autoLockConn:Disconnect(); _autoLockConn = nil end
    end

    if autoLockEnabled2 then startAutoLockWatcher() end

    autoLockPanelBtn.Activated:Connect(function()
        autoLockEnabled2 = not autoLockEnabled2
        CONFIG.AUTO_LOCK_PANEL_VISIBLE = autoLockEnabled2
        autoLockPanelBtn.Text = "AUTO LOCK: " .. (autoLockEnabled2 and "ON" or "OFF")
        autoLockPanelBtn.TextColor3 = COLORS.Accent
        saveConfig()
        if autoLockEnabled2 then startAutoLockWatcher() else stopAutoLockWatcher() end
    end)
end

-- ======================================
-- TABS CREATION
-- ======================================

local function createSettingsTab(parent)
    local tab = createEmptyTab(parent, "Settings")
    local scroll = createElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = tab,
    })
    local scrollPad = Instance.new("UIPadding")
    scrollPad.PaddingLeft   = UDim.new(0, 6)
    scrollPad.PaddingRight  = UDim.new(0, 10)
    scrollPad.PaddingTop    = UDim.new(0, 6)
    scrollPad.PaddingBottom = UDim.new(0, 6)
    scrollPad.Parent = scroll
    local list = createElement("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = scroll
    })  

    -- ── UI ───────────────────────────────────────────────────────────────────
    local uiContent, uiWrapper = createCategory(scroll, "[UI Settings]", true)
    uiWrapper.LayoutOrder = 1

    local lockUIToggle = createToggle(uiContent, "Lock UI", CONFIG.UI_LOCKED, function(state)
        CONFIG.UI_LOCKED = state; saveConfig()
    end)
    lockUIToggle.LayoutOrder = 1

    local activeHudToggle = createToggle(uiContent, "Active Functions HUD", CONFIG.ACTIVE_HUD_VISIBLE, function(state)
        CONFIG.ACTIVE_HUD_VISIBLE = state; saveConfig()
        local hud = S.PlayerGui:FindFirstChild("LooprixActiveHUD")
        if hud then hud.Enabled = state end
    end)
    activeHudToggle.LayoutOrder = 2

    local grabBarToggle = createToggle(uiContent, "Grab Bar", CONFIG.GRAB_BAR_VISIBLE, function(state)
        CONFIG.GRAB_BAR_VISIBLE = state; saveConfig()
        if stealScreenGui then stealScreenGui.Enabled = state end
    end)
    grabBarToggle.LayoutOrder = 3

    -- ── UI Scale slider ──────────────────────────────────────────────────────
    -- Range 0.5 → 1.25, displayed as integer % (50 → 125) for readability.
    -- Internally the slider works in integer steps (50–125) and we divide by 100.
    local scaleSlider = createSlider(
        uiContent,
        "UI Scale",
        math.floor((CONFIG.UI_SCALE or 1.0) * 100),  -- default shown as integer
        50,   -- min = 0.50
        125,  -- max = 1.25
        function(intVal)
            local realScale = intVal / 100
            CONFIG.UI_SCALE = realScale
            applyUIScale(realScale)
            saveConfig()
        end
    )
    scaleSlider.LayoutOrder = 4

    -- ── GUI Color — HEX input ────────────────────────────────────────────────
    local colorRow = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = COLORS.Surface,
        BackgroundTransparency = COLORS.SurfaceTransparency,
        BorderSizePixel = 0,
        LayoutOrder = 5,
        Parent = uiContent,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = colorRow })
    local crStroke = createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = colorRow })
    trackStroke(crStroke)

    local crLabel = createElement("TextLabel", {
        Size = UDim2.new(1, -12, 0, 16),
        Position = UDim2.new(0, 8, 0, 4),
        BackgroundTransparency = 1,
        Text = "GUI Color  (#RRGGBB)",
        TextColor3 = COLORS.Text,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = colorRow,
    })

    -- Preview swatch
    local crPreview = createElement("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 4),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Parent = colorRow,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 4), Parent = crPreview })
    trackFrame(crPreview)

    -- HEX text input
    local hexBox = createElement("TextBox", {
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.new(0, 8, 0, 24),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0.3,
        Text = string.format("#%02X%02X%02X", CONFIG.GUI_COLOR_R, CONFIG.GUI_COLOR_G, CONFIG.GUI_COLOR_B),
        TextColor3 = COLORS.Accent,
        PlaceholderText = "#00D97F",
        PlaceholderColor3 = COLORS.TextDim,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Parent = colorRow,
    })
    createElement("UICorner", { CornerRadius = UDim.new(0, 5), Parent = hexBox })
    local hexStroke = createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.4, Parent = hexBox })
    trackStroke(hexStroke)
    trackLabel(hexBox)

    local function applyHex(raw)
        local hex = raw:gsub("^#", ""):upper()
        if #hex == 6 then
            local r = tonumber(hex:sub(1,2), 16)
            local g = tonumber(hex:sub(3,4), 16)
            local b = tonumber(hex:sub(5,6), 16)
            if r and g and b then
                applyAccentColor(r, g, b)
                crPreview.BackgroundColor3 = Color3.fromRGB(r, g, b)
                hexBox.Text = "#" .. hex
                saveConfig()
                return
            end
        end
        hexBox.Text = string.format("#%02X%02X%02X", CONFIG.GUI_COLOR_R, CONFIG.GUI_COLOR_G, CONFIG.GUI_COLOR_B)
    end

    hexBox.FocusLost:Connect(function()
        applyHex(hexBox.Text)
    end)

    -- ── COMBAT VALUES ────────────────────────────────────────────────────────
    local cvContent, cvWrapper = createCategory(scroll, "[Combat Values]", true)
    cvWrapper.LayoutOrder = 2

    local aimbotRangeInput = createNumberInput(cvContent, "Aimbot Range", CONFIG.AIMBOT_RANGE, 5, 200, function(value)
        CONFIG.AIMBOT_RANGE = value
    end)
    aimbotRangeInput.LayoutOrder = 1

    local aimbotDisableInput = createNumberInput(cvContent, "Aimbot Disable Range", CONFIG.AIMBOT_DISABLE_RANGE, 5, 250, function(value)
        CONFIG.AIMBOT_DISABLE_RANGE = value
    end)
    aimbotDisableInput.LayoutOrder = 2

    local spinbotSpeedInput = createNumberInput(cvContent, "Spinbot Speed", CONFIG.SPINBOT_SPEED, 1, 100, function(value)
        CONFIG.SPINBOT_SPEED = value
    end)
    spinbotSpeedInput.LayoutOrder = 3

    local lockSpeedInput = createNumberInput(cvContent, "Lock Target Speed", CONFIG.LOCK_TARGET_SPEED, 1, 200, function(value)
        CONFIG.LOCK_TARGET_SPEED = value
    end)
    lockSpeedInput.LayoutOrder = 4

    -- ── TOOL VALUES ───────────────────────────────────────────────────────────
    local tvContent, tvWrapper = createCategory(scroll, "[Tool Values]", true)
    tvWrapper.LayoutOrder = 3

    local medusaRangeInput = createNumberInput(tvContent, "Medusa Range", CONFIG.AUTO_MEDUSA_RANGE, 1, 50, function(value)
        CONFIG.AUTO_MEDUSA_RANGE = value
        if medusaCircle then medusaCircle.Radius = value end
    end)
    medusaRangeInput.LayoutOrder = 1

    local igDistInput = createNumberInput(tvContent, "Grab Distance", CONFIG.INSTANT_GRAB_ACTIVATION_DIST, 1, 200, function(value)
        CONFIG.INSTANT_GRAB_ACTIVATION_DIST = value
    end)
    igDistInput.LayoutOrder = 2

    local floatHeightInput = createNumberInput(tvContent, "Float Height", CONFIG.FLOAT_HEIGHT, 0, 50, function(value)
        CONFIG.FLOAT_HEIGHT = value
        saveConfig()
    end)
    floatHeightInput.LayoutOrder = 3

    local floatSpeedInput = createNumberInput(tvContent, "Float Speed (1-100)", CONFIG.FLOAT_SPEED, 1, 100, function(value)
        CONFIG.FLOAT_SPEED = math.clamp(value, 1, 100)
        saveConfig()
    end)
    floatSpeedInput.LayoutOrder = 4

    -- ── AUTO PLAY POINTS ──────────────────────────────────────────────────────
    local apContent, apWrapper = createCategory(scroll, "[Auto Play]", true)
    apWrapper.LayoutOrder = 4

    -- Which side we are currently setting points for
    local _apSide = "L"

    -- Clean point toast — no left color bar, pure text card
    local function showPointToast(msg)
        task.spawn(function()
            ensureToastGui()
            local toast = Instance.new("Frame", _toastContainer)
            toast.Size = UDim2.new(1, 0, 0, 38)
            toast.BackgroundColor3 = COLORS.Background
            toast.BackgroundTransparency = 1
            toast.BorderSizePixel = 0
            toast.LayoutOrder = _toastCount + 1
            _toastCount = _toastCount + 1
            toast.ClipsDescendants = true
            Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)

            local tStroke = Instance.new("UIStroke", toast)
            tStroke.Thickness = 1.2
            tStroke.Color = COLORS.Accent
            tStroke.Transparency = 0.15
            tStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            trackStroke(tStroke)

            local tLbl = Instance.new("TextLabel", toast)
            tLbl.Size = UDim2.new(1, -16, 1, 0)
            tLbl.Position = UDim2.new(0, 8, 0, 0)
            tLbl.BackgroundTransparency = 1
            tLbl.Text = msg
            tLbl.TextColor3 = COLORS.Accent
            tLbl.TextSize = 12
            tLbl.Font = Enum.Font.GothamBold
            tLbl.TextXAlignment = Enum.TextXAlignment.Left
            tLbl.TextTransparency = 1
            trackLabel(tLbl)

            local sc = Instance.new("UIScale", toast)
            sc.Scale = 0.88

            -- slide in
            S.TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { BackgroundTransparency = 0.08 }):Play()
            S.TweenService:Create(tLbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { TextTransparency = 0 }):Play()
            S.TweenService:Create(sc, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Scale = 1 }):Play()

            task.wait(2.2)

            S.TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                { BackgroundTransparency = 1 }):Play()
            S.TweenService:Create(tLbl, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                { TextTransparency = 1 }):Play()
            S.TweenService:Create(tStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                { Transparency = 1 }):Play()
            S.TweenService:Create(sc, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                { Scale = 0.85 }):Play()
            task.wait(0.28)
            if toast and toast.Parent then toast:Destroy() end
        end)
    end

    -- ── SIDE SWITCHER ROW ──────────────────────────────────────────────────────
    local sideRow = Instance.new("Frame")
    sideRow.Size = UDim2.new(1, 0, 0, 30)
    sideRow.BackgroundColor3 = COLORS.Surface
    sideRow.BackgroundTransparency = 0.1
    sideRow.BorderSizePixel = 0
    sideRow.LayoutOrder = 0
    sideRow.Parent = apContent
    local srCorner = Instance.new("UICorner", sideRow)
    srCorner.CornerRadius = UDim.new(0, 7)
    local srStroke = Instance.new("UIStroke", sideRow)
    srStroke.Color = COLORS.Accent
    srStroke.Thickness = 1
    srStroke.Transparency = 0.45
    srStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(srStroke)

    -- Arrow left
    local arL = Instance.new("TextButton", sideRow)
    arL.Size = UDim2.new(0, 26, 1, 0)
    arL.Position = UDim2.new(0, 0, 0, 0)
    arL.BackgroundTransparency = 1
    arL.Text = "←"
    arL.TextColor3 = COLORS.Accent
    arL.Font = Enum.Font.GothamBold
    arL.TextSize = 14
    arL.BorderSizePixel = 0
    trackLabel(arL)

    -- Side label (center)
    local sideLbl = Instance.new("TextLabel", sideRow)
    sideLbl.Size = UDim2.new(1, -52, 1, 0)
    sideLbl.Position = UDim2.new(0, 26, 0, 0)
    sideLbl.BackgroundTransparency = 1
    sideLbl.Text = "Auto Left"
    sideLbl.TextColor3 = COLORS.Text
    sideLbl.Font = Enum.Font.GothamSemibold
    sideLbl.TextSize = 11
    sideLbl.TextXAlignment = Enum.TextXAlignment.Center
    local sideLblGrad = Instance.new("UIGradient", sideLbl)
    sideLblGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    COLORS.Accent),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(1,    COLORS.Accent),
    })
    trackGradient(sideLblGrad)

    -- Arrow right
    local arR = Instance.new("TextButton", sideRow)
    arR.Size = UDim2.new(0, 26, 1, 0)
    arR.Position = UDim2.new(1, -26, 0, 0)
    arR.BackgroundTransparency = 1
    arR.Text = "→"
    arR.TextColor3 = COLORS.Accent
    arR.Font = Enum.Font.GothamBold
    arR.TextSize = 14
    arR.BorderSizePixel = 0
    trackLabel(arR)

    local function apSetSide(side)
        _apSide = side
        AP.settingsSide = side
        sideLbl.Text = (side == "L") and "Auto Left" or "Auto Right"
    end

    arL.Activated:Connect(function() apSetSide("L") end)
    arR.Activated:Connect(function() apSetSide("R") end)

    -- ── POINT ROWS ────────────────────────────────────────────────────────────
    for i = 1, 5 do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundColor3 = COLORS.Surface
        row.BackgroundTransparency = 0.08
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        row.Parent = apContent
        local rCorner = Instance.new("UICorner", row)
        rCorner.CornerRadius = UDim.new(0, 6)
        local rStroke = Instance.new("UIStroke", row)
        rStroke.Color = COLORS.Accent
        rStroke.Thickness = 1
        rStroke.Transparency = 0.65
        rStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        trackStroke(rStroke)

        local ptLbl = Instance.new("TextLabel", row)
        ptLbl.Size = UDim2.new(1, -72, 1, 0)
        ptLbl.Position = UDim2.new(0, 10, 0, 0)
        ptLbl.BackgroundTransparency = 1
        ptLbl.Text = "Point " .. i
        ptLbl.TextColor3 = COLORS.Text
        ptLbl.Font = Enum.Font.GothamSemibold
        ptLbl.TextSize = 12
        ptLbl.TextXAlignment = Enum.TextXAlignment.Left

        local setBtn = Instance.new("TextButton", row)
        setBtn.Size = UDim2.new(0, 48, 0, 22)
        setBtn.AnchorPoint = Vector2.new(1, 0.5)
        setBtn.Position = UDim2.new(1, -8, 0.5, 0)
        setBtn.BackgroundColor3 = Color3.fromRGB(10, 40, 28)
        setBtn.BackgroundTransparency = 0
        setBtn.Text = "SET"
        setBtn.TextColor3 = COLORS.Accent
        setBtn.Font = Enum.Font.GothamBold
        setBtn.TextSize = 11
        setBtn.BorderSizePixel = 0
        local sBtnCorner = Instance.new("UICorner", setBtn)
        sBtnCorner.CornerRadius = UDim.new(0, 5)
        local sBtnStroke = Instance.new("UIStroke", setBtn)
        sBtnStroke.Color = COLORS.Accent
        sBtnStroke.Thickness = 1
        sBtnStroke.Transparency = 0.3
        sBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        trackStroke(sBtnStroke)
        trackLabel(setBtn)

        local _idx = i
        setBtn.Activated:Connect(function()
            local character = S.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local pos = character.HumanoidRootPart.Position
                local key = AP.POINT_KEYS[_idx]
                -- Save exact position to BASE
                AP.BASE[_apSide][key] = Vector3.new(pos.X, pos.Y, pos.Z)
                -- Zero out any saved offset so apGetTarget returns exactly pos
                AP.offsets[_apSide][key] = { x = 0, z = 0 }
                -- Flash button
                S.TweenService:Create(setBtn, tweenInfoFast, { BackgroundColor3 = COLORS.Accent }):Play()
                task.delay(0.3, function()
                    S.TweenService:Create(setBtn, tweenInfoFast, {
                        BackgroundColor3 = Color3.fromRGB(10, 40, 28)
                    }):Play()
                end)
                showPointToast("Point " .. _idx .. " set  ✅")
            end
        end)
    end

    -- ── DELAY ROW ─────────────────────────────────────────────────────────────
    local delayRow = Instance.new("Frame")
    delayRow.Size = UDim2.new(1, 0, 0, 32)
    delayRow.BackgroundColor3 = COLORS.Surface
    delayRow.BackgroundTransparency = 0.08
    delayRow.BorderSizePixel = 0
    delayRow.LayoutOrder = 6
    delayRow.Parent = apContent
    Instance.new("UICorner", delayRow).CornerRadius = UDim.new(0, 6)
    local drStroke = Instance.new("UIStroke", delayRow)
    drStroke.Color = COLORS.Accent
    drStroke.Thickness = 1
    drStroke.Transparency = 0.65
    drStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(drStroke)

    local delayLbl = Instance.new("TextLabel", delayRow)
    delayLbl.Size = UDim2.new(1, -80, 1, 0)
    delayLbl.Position = UDim2.new(0, 10, 0, 0)
    delayLbl.BackgroundTransparency = 1
    delayLbl.Text = "Grab Delay"
    delayLbl.TextColor3 = COLORS.Text
    delayLbl.Font = Enum.Font.GothamSemibold
    delayLbl.TextSize = 12
    delayLbl.TextXAlignment = Enum.TextXAlignment.Left

    local delayBox = Instance.new("TextBox", delayRow)
    delayBox.Size = UDim2.new(0, 60, 0, 22)
    delayBox.AnchorPoint = Vector2.new(1, 0.5)
    delayBox.Position = UDim2.new(1, -8, 0.5, 0)
    delayBox.BackgroundColor3 = COLORS.Background
    delayBox.BackgroundTransparency = 0.2
    delayBox.Text = tostring(CONFIG.AUTO_PLAY_DELAY or 0.03)
    delayBox.TextColor3 = COLORS.Accent
    delayBox.Font = Enum.Font.GothamBold
    delayBox.TextSize = 11
    delayBox.ClearTextOnFocus = false
    delayBox.BorderSizePixel = 0
    delayBox.PlaceholderText = "0.01–0.1"
    delayBox.PlaceholderColor3 = COLORS.TextDim
    Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 5)
    local dbStroke = Instance.new("UIStroke", delayBox)
    dbStroke.Color = COLORS.Accent
    dbStroke.Thickness = 1
    dbStroke.Transparency = 0.35
    dbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(dbStroke)
    trackLabel(delayBox)

    delayBox.FocusLost:Connect(function()
        local v = tonumber(delayBox.Text)
        if v then
            CONFIG.AUTO_PLAY_DELAY = math.clamp(v, 0.01, 0.1)
        end
        delayBox.Text = tostring(CONFIG.AUTO_PLAY_DELAY)
        saveConfig()
    end)

    return tab
end

local function createBindsTab(parent)
    local tab = createEmptyTab(parent, "Binds")
    local scroll = createElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = tab,
    })
    local scrollPad = Instance.new("UIPadding")
    scrollPad.PaddingLeft   = UDim.new(0, 6)
    scrollPad.PaddingRight  = UDim.new(0, 10)
    scrollPad.PaddingTop    = UDim.new(0, 6)
    scrollPad.PaddingBottom = UDim.new(0, 6)
    scrollPad.Parent = scroll
    local list = createElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scroll
    })

    local function kb(label, cfgKey, order)
        local w = createKeybindButton(scroll, label, CONFIG[cfgKey], function(key)
            CONFIG[cfgKey] = key; saveConfig()
        end)
        w.LayoutOrder = order
    end

    kb("Toggle GUI",        "TOGGLE_GUI_KEYBIND",      1)
    kb("Auto Bat",          "AUTO_BAT_KEYBIND",        2)
    kb("Aimbot",            "AIMBOT_KEYBIND",          3)
    kb("Spin Bot",          "SPINBOT_KEYBIND",         4)
    kb("Lock Target",       "LOCK_TARGET_KEYBIND",     5)
    kb("Auto Medusa",       "AUTO_MEDUSA_KEYBIND",     6)
    kb("Instant Grab",      "INSTANT_GRAB_KEYBIND",    7)
    kb("Drop Brainrot",     "DROP_BRAINROT_KEYBIND",   8)
    kb("Float",             "FLOAT_KEYBIND",           9)
    kb("Auto Play L",       "AUTO_PLAY_L_KEYBIND",     10)
    kb("Auto Play R",       "AUTO_PLAY_R_KEYBIND",     11)
    kb("Auto Walk L",       "AUTO_WALK_L_KEYBIND",     12)
    kb("Auto Walk R",       "AUTO_WALK_R_KEYBIND",     13)
    kb("Fling",             "FLING_KEYBIND",           14)
    kb("Anti Steal",        "ANTI_STEAL_KEYBIND",      15)
    kb("Auto Lock",         "AUTO_LOCK_KEYBIND",       16)
    kb("Tp Down",           "TP_DOWN_KEYBIND",         17)

    return tab
end

local function createPerformanceTab(parent)
    local tab = createEmptyTab(parent, "Performance")
    local scroll = createElement("ScrollingFrame", {  
        Size = UDim2.new(1, 0, 1, 0),  
        BackgroundTransparency = 1,  
        ScrollBarThickness = 4,  
        ScrollBarImageColor3 = COLORS.Accent,  
        BorderSizePixel = 0,  
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = tab,  
    })
    local scrollPad = Instance.new("UIPadding")
    scrollPad.PaddingLeft   = UDim.new(0, 6)
    scrollPad.PaddingRight  = UDim.new(0, 10)
    scrollPad.PaddingTop    = UDim.new(0, 6)
    scrollPad.PaddingBottom = UDim.new(0, 6)
    scrollPad.Parent = scroll
    local list = createElement("UIListLayout", { 
        Padding = UDim.new(0, 8), 
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = scroll 
    })

    -- ── VISUALS ───────────────────────────────────────────────────────────────
    local visContent, visWrapper = createCategory(scroll, "[Visuals]", true)
    visWrapper.LayoutOrder = 1

    local espToggle = createToggle(visContent, "Player ESP", CONFIG.ESP_ENABLED, function(state)
        CONFIG.ESP_ENABLED = state; espEnabled = state; saveConfig()
        if state then startESP() else stopESP() end
    end)
    espToggle.LayoutOrder = 1
    
    local xrayToggle = createToggle(visContent, "XRay", CONFIG.XRAY_ENABLED, function(state)
        CONFIG.XRAY_ENABLED = state; xrayEnabled = state; saveConfig()
        if state then startXRay() else stopXRay() end
    end)
    xrayToggle.LayoutOrder = 2

    -- ── PERFORMANCE ───────────────────────────────────────────────────────────
    local perfContent, perfWrapper = createCategory(scroll, "[Performance]", true)
    perfWrapper.LayoutOrder = 2
    
    local optimizerToggle = createToggle(perfContent, "Optimizer", CONFIG.OPTIMIZER_ENABLED, function(state)
        CONFIG.OPTIMIZER_ENABLED = state; optimizerEnabled = state; saveConfig()
        if state then startOptimizer() else stopOptimizer() end
    end)
    optimizerToggle.LayoutOrder = 1

    local noCollisionToggle = createToggle(perfContent, "No Player Collision", CONFIG.NO_COLLISION_ENABLED, function(state)
        CONFIG.NO_COLLISION_ENABLED = state; saveConfig()
        if state then startNoCollision() else stopNoCollision() end
    end)
    noCollisionToggle.LayoutOrder = 2

    local autoTpDownToggle = createToggle(perfContent, "Auto Tp Down (Float)", CONFIG.AUTO_TP_DOWN_ENABLED, function(state)
        CONFIG.AUTO_TP_DOWN_ENABLED = state; saveConfig()
        showNotification("Auto Tp Down", state)
    end)
    autoTpDownToggle.LayoutOrder = 3

    return tab
end

local function createDuelTab(parent)
    local tab = createEmptyTab(parent, "Duel")
    local scroll = createElement("ScrollingFrame", {  
        Size = UDim2.new(1, 0, 1, 0),  
        BackgroundTransparency = 1,  
        ScrollBarThickness = 4,  
        ScrollBarImageColor3 = COLORS.Accent,  
        BorderSizePixel = 0,  
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = tab,  
    })
    -- Padding: right side keeps scrollbar from overlapping; top/bottom breathing room
    local scrollPad = Instance.new("UIPadding")
    scrollPad.PaddingLeft  = UDim.new(0, 6)
    scrollPad.PaddingRight = UDim.new(0, 10)
    scrollPad.PaddingTop   = UDim.new(0, 6)
    scrollPad.PaddingBottom = UDim.new(0, 6)
    scrollPad.Parent = scroll
    local list = createElement("UIListLayout", { 
        Padding = UDim.new(0, 8), 
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = scroll 
    })

    -- ── COMBAT ──────────────────────────────────────────────────────────────
    local combatContent, combatWrapper = createCategory(scroll, "[Combat]", true)
    combatWrapper.LayoutOrder = 1
    -- NOTE: createCategory already provides its own UIListLayout inside content
    
    local autoBatToggle = createToggle(combatContent, "Auto Bat", CONFIG.AUTO_BAT_ENABLED, function(state)
        CONFIG.AUTO_BAT_ENABLED = state; attacking = state; saveConfig()
        if state then autoAttack() end
    end)
    autoBatToggle.LayoutOrder = 1
    
    -- Aimbot and Spinbot are mutually exclusive.
    -- We build them manually so each can reference the other's button.

    local function makeMutualToggle(parent, labelText, initState, lo)
        local container = createElement("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = COLORS.Surface,
            BackgroundTransparency = COLORS.SurfaceTransparency,
            BorderSizePixel = 0,
            LayoutOrder = lo,
            Parent = parent,
        })
        createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })
        trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = container }))
        createElement("TextLabel", {
            Size = UDim2.new(0.6, -10, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = COLORS.Text,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container,
        })
        local btn = createElement("TextButton", {
            Size = UDim2.new(0.25, 0, 0.6, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0),
            BackgroundColor3 = initState and COLORS.Accent or COLORS.Background,
            BackgroundTransparency = 0.2,
            Text = initState and "ON" or "OFF",
            TextColor3 = COLORS.Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            Parent = container,
        })
        createElement("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
        trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.3, Parent = btn }))
        if initState then table.insert(_accentFrames, btn) end
        return container, btn
    end


    local aimbotToggle,  _aimbotBtnLocal  = makeMutualToggle(combatContent, "Aimbot",   CONFIG.AIMBOT_ENABLED,  2)
    local spinbotToggle, _spinbotBtnLocal = makeMutualToggle(combatContent, "Spin Bot", CONFIG.SPINBOT_ENABLED, 3)
    _aimbotBtn  = _aimbotBtnLocal
    _spinbotBtn = _spinbotBtnLocal

    _aimbotBtn.MouseButton1Click:Connect(function()
        local newState = not CONFIG.AIMBOT_ENABLED
        -- If turning ON aimbot while spinbot is ON → force spinbot OFF first
        if newState and CONFIG.SPINBOT_ENABLED then
            CONFIG.SPINBOT_ENABLED = false
            spinbotEnabled = false
            stopSpinBot()
            saveConfig()
            setToggleVisual(_spinbotBtn, false)
            showNotification("Spin Bot", false)
        end
        CONFIG.AIMBOT_ENABLED = newState
        aimbotEnabled = newState
        saveConfig()
        setToggleVisual(_aimbotBtn, newState)
        showNotification("Aimbot", newState)
        if newState then startBodyAimbot() else stopBodyAimbot() end
    end)

    _spinbotBtn.MouseButton1Click:Connect(function()
        local newState = not CONFIG.SPINBOT_ENABLED
        -- If turning ON spinbot while aimbot is ON → force aimbot OFF first
        if newState and CONFIG.AIMBOT_ENABLED then
            CONFIG.AIMBOT_ENABLED = false
            aimbotEnabled = false
            stopBodyAimbot()
            saveConfig()
            setToggleVisual(_aimbotBtn, false)
            showNotification("Aimbot", false)
        end
        CONFIG.SPINBOT_ENABLED = newState
        spinbotEnabled = newState
        saveConfig()
        setToggleVisual(_spinbotBtn, newState)
        showNotification("Spin Bot", newState)
        if newState then startSpinBot() else stopSpinBot() end
    end)

    local antiRagdollToggle = createToggle(combatContent, "Anti Ragdoll", CONFIG.ANTIRAGDOLL_ENABLED, function(state)
        CONFIG.ANTIRAGDOLL_ENABLED = state; saveConfig(); toggleAntiRagdoll(state)
    end)
    antiRagdollToggle.LayoutOrder = 4

    local antiDieToggle = createToggle(combatContent, "Anti Die", CONFIG.ANTI_DIE_ENABLED, function(state)
        CONFIG.ANTI_DIE_ENABLED = state; antiDieEnabled = state; saveConfig()
        if state then activateAntiDie() end
    end)
    antiDieToggle.LayoutOrder = 5

    -- ── MOBILITY ─────────────────────────────────────────────────────────────
    local mobContent, mobWrapper = createCategory(scroll, "[Mobility]", true)
    mobWrapper.LayoutOrder = 2

    local unwalkToggle = createToggle(mobContent, "Unwalk", CONFIG.UNWALK_ENABLED, function(state)
        CONFIG.UNWALK_ENABLED = state; unwalkEnabled = state; saveConfig()
        if state then startUnwalk() else stopUnwalk() end
    end)
    unwalkToggle.LayoutOrder = 1

    local infJumpToggle = createToggle(mobContent, "Infinity Jump", CONFIG.INF_JUMP_ENABLED, function(state)
        CONFIG.INF_JUMP_ENABLED = state; infJumpEnabled = state; saveConfig()
        if state then startInfJump() else stopInfJump() end
    end)
    infJumpToggle.LayoutOrder = 2

    local floatPanelToggle = createToggle(mobContent, "Float", CONFIG.FLOAT_PANEL_VISIBLE, function(state)
        CONFIG.FLOAT_PANEL_VISIBLE = state; saveConfig()
        if floatPanelGui then floatPanelGui.Enabled = state end
    end)
    floatPanelToggle.LayoutOrder = 3

    local flingPanelToggle = createToggle(mobContent, "Fling", CONFIG.FLING_PANEL_VISIBLE, function(state)
        CONFIG.FLING_PANEL_VISIBLE = state; saveConfig()
        if flingPanelGui then flingPanelGui.Enabled = state end
    end)
    flingPanelToggle.LayoutOrder = 4

    local autoWalkPanelToggle = createToggle(mobContent, "Auto Walk", CONFIG.AUTO_WALK_PANEL_VISIBLE, function(state)
        CONFIG.AUTO_WALK_PANEL_VISIBLE = state; saveConfig()
        if awGuiInstance then awGuiInstance.Enabled = state end
    end)
    autoWalkPanelToggle.LayoutOrder = 5

    local tpDownToggle = createToggle(mobContent, "Tp Down Panel", CONFIG.TP_DOWN_PANEL_VISIBLE, function(state)
        CONFIG.TP_DOWN_PANEL_VISIBLE = state; saveConfig()
        if tpDownPanelGui then tpDownPanelGui.Enabled = state end
    end)
    tpDownToggle.LayoutOrder = 6


    -- ── TOOLS ────────────────────────────────────────────────────────────────
    local toolsContent, toolsWrapper = createCategory(scroll, "[Tools]", true)
    toolsWrapper.LayoutOrder = 3

    local autoMedusaToggle = createToggle(toolsContent, "Auto Medusa", CONFIG.AUTO_MEDUSA_ENABLED, function(state)
        CONFIG.AUTO_MEDUSA_ENABLED = state; autoMedusaEnabled = state; saveConfig()
        if state then startAutoMedusa() else stopAutoMedusa() end
    end)
    autoMedusaToggle.LayoutOrder = 1

    local instantGrabToggle = createToggle(toolsContent, "Instant Grab", CONFIG.INSTANT_GRAB_ENABLED, function(state)
        CONFIG.INSTANT_GRAB_ENABLED = state; instantGrabEnabled = state; saveConfig()
        if state then startInstantGrab() else stopInstantGrab() end
    end)
    instantGrabToggle.LayoutOrder = 2

    local dropBrainrotPanelToggle = createToggle(toolsContent, "Drop Brainrot", CONFIG.DROP_BRAINROT_PANEL_VISIBLE, function(state)
        CONFIG.DROP_BRAINROT_PANEL_VISIBLE = state; saveConfig()
        if dropBrainrotPanelGui then dropBrainrotPanelGui.Enabled = state end
    end)
    dropBrainrotPanelToggle.LayoutOrder = 3

    local lockTargetPanelToggle = createToggle(toolsContent, "Lock Target", CONFIG.LOCK_TARGET_PANEL_VISIBLE, function(state)
        CONFIG.LOCK_TARGET_PANEL_VISIBLE = state; saveConfig()
        if lockTargetPanelGui then lockTargetPanelGui.Enabled = state end
    end)
    lockTargetPanelToggle.LayoutOrder = 4

    local speedGuiToggle = createToggle(toolsContent, "Speed Booster", CONFIG.SPEED_GUI_VISIBLE, function(state)
        CONFIG.SPEED_GUI_VISIBLE = state; speedGuiEnabled = state; saveConfig()
        if speedGuiInstance then speedGuiInstance.Enabled = state end
    end)
    speedGuiToggle.LayoutOrder = 5

    local autoPlayGuiToggle = createToggle(toolsContent, "Auto Play", CONFIG.AUTO_PLAY_GUI_VISIBLE, function(state)
        CONFIG.AUTO_PLAY_GUI_VISIBLE = state; saveConfig()
        if apGuiInstance then apGuiInstance.Enabled = state end
    end)
    autoPlayGuiToggle.LayoutOrder = 6

    local spinbotPanelToggle = createToggle(toolsContent, "Spin Bot Panel", CONFIG.SPINBOT_PANEL_VISIBLE, function(state)
        CONFIG.SPINBOT_PANEL_VISIBLE = state; saveConfig()
        if spinbotPanelGui then spinbotPanelGui.Enabled = state end
    end)
    spinbotPanelToggle.LayoutOrder = 6

    local tauntPanelToggle = createToggle(toolsContent, "Taunt", CONFIG.TAUNT_PANEL_VISIBLE, function(state)
        CONFIG.TAUNT_PANEL_VISIBLE = state; saveConfig()
        if tauntPanelGui then tauntPanelGui.Enabled = state end
    end)
    tauntPanelToggle.LayoutOrder = 7

    local antiStealToggle = createToggle(toolsContent, "Anti Steal", CONFIG.ANTI_STEAL_PANEL_VISIBLE, function(state)
        CONFIG.ANTI_STEAL_PANEL_VISIBLE = state; saveConfig()
        if antiStealPanelGui then antiStealPanelGui.Enabled = state end
        if antiStealPanelBtn then
            antiStealPanelBtn.Text = "ANTI STEAL: " .. (state and "ON" or "OFF")
        end
    end)
    antiStealToggle.LayoutOrder = 8

    local autoLockToggle = createToggle(toolsContent, "Auto Lock Panel", CONFIG.AUTO_LOCK_PANEL_VISIBLE, function(state)
        CONFIG.AUTO_LOCK_PANEL_VISIBLE = state; saveConfig()
        if autoLockPanelGui then autoLockPanelGui.Enabled = state end
        if autoLockPanelBtn then
            autoLockPanelBtn.Text = "AUTO LOCK: " .. (state and "ON" or "OFF")
        end
    end)
    autoLockToggle.LayoutOrder = 9

    return tab
end

-- ======================================
-- MAIN GUI CREATION
-- ======================================

local function toggleGui()
    guiVisible = not guiVisible
    if mainFrame then mainFrame.Visible = guiVisible end
    CONFIG.MAIN_GUI_VISIBLE = guiVisible
    saveConfig()
end

local function createGui()
    screenGui = createElement("ScreenGui", {
        Name = "LooprixV2",
        ResetOnSpawn = false,
        DisplayOrder = 999999,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Parent = S.PlayerGui,
    })
    local isMobile = S.UserInputService.TouchEnabled and not S.UserInputService.KeyboardEnabled  
    local isTablet = S.UserInputService.TouchEnabled and workspace.CurrentCamera.ViewportSize.X >= 768  
    local screenSize = workspace.CurrentCamera.ViewportSize  
    local function getScaleFactor()  
        local baseWidth = 1920  
        local currentWidth = screenSize.X  
        local scaleFactor = math.clamp(currentWidth / baseWidth, 0.5, 1.2)  
        if isMobile and not isTablet then return math.clamp(scaleFactor * 0.85, 0.6, 0.9)  
        elseif isTablet then return math.clamp(scaleFactor * 1.0, 0.8, 1.1)  
        else return scaleFactor end  
    end  
    local globalScale = getScaleFactor()  
    local mainWidth = isMobile and 360 or (isTablet and 420 or 450)  
    local mainHeight = isMobile and 420 or (isTablet and 480 or 500)  
    local titleHeight = 50  
    
    mainFrame = createElement("Frame", {  
        Name = "MainFrame",  
        Size = UDim2.new(0, mainWidth, 0, mainHeight),  
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,  
        BackgroundTransparency = COLORS.BackgroundTransparency,  
        BorderSizePixel = 0,  
        ClipsDescendants = true,  
        Parent = screenGui,  
    })
    
    -- Load saved position; if none, default to true screen center
    local savedPos = CONFIG._guiPositions and CONFIG._guiPositions.main
    if savedPos and (savedPos.offsetX ~= 0 or savedPos.offsetY ~= 0 or savedPos.scaleX ~= 0 or savedPos.scaleY ~= 0.5) then
        mainFrame.AnchorPoint = Vector2.new(0, 0)
        mainFrame.Position = UDim2.new(savedPos.scaleX, savedPos.offsetX, savedPos.scaleY, savedPos.offsetY)
    else
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    end
    
    createElement("UICorner", { CornerRadius = UDim.new(0, 8), Parent = mainFrame })  
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 2, Transparency = 0.1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = mainFrame }))

    -- ── Unified UIScale — controlled by the UI Scale slider in Settings ───────
    -- base = getScaleFactor() on mobile/tablet (original behaviour), 1.0 on desktop.
    -- At slider=100 (multiplier 1.0) the frame looks exactly like the original.
    local _mainFrameBase = (isMobile or isTablet) and globalScale or 1.0
    registerScaleTarget(mainFrame, _mainFrameBase)
    -- For mobile: keep viewport-based rescaling on top of the user's chosen scale
    if isMobile or isTablet then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            applyUIScale(scaleMultiplier)  -- re-broadcast so mobile layout stays consistent
        end)
    end
    local titleBar = createElement("Frame", {  
        Size = UDim2.new(1, 0, 0, titleHeight),  
        BackgroundColor3 = COLORS.Surface,  
        BackgroundTransparency = 0.3,  
        BorderSizePixel = 0,  
        Parent = mainFrame,  
    })  
    createElement("UICorner", { CornerRadius = UDim.new(0, 8), Parent = titleBar })  
    local mainTitle = createElement("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "Looprix Hub",
        TextColor3 = COLORS.Accent,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    })
    trackLabel(mainTitle)
    local minBtn = createElement("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -45, 0.5, -15),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 0.5,  
        Text = "-",  
        TextColor3 = COLORS.Accent,  
        TextSize = 20,  
        Font = Enum.Font.GothamBold,  
        BorderSizePixel = 0,  
        Parent = titleBar,  
    })  
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = minBtn })
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5, Parent = minBtn }))
    trackLabel(minBtn)
    tabBar = createElement("Frame", {  
        Size = UDim2.new(1, -20, 0, 36),  
        Position = UDim2.new(0, 10, 0, titleHeight + 10),  
        BackgroundColor3 = COLORS.Surface,  
        BackgroundTransparency = 0.5,  
        BorderSizePixel = 0,  
        Parent = mainFrame,  
    })  
    createElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBar })
    trackStroke(createElement("UIStroke", { Color = COLORS.Accent, Thickness = 1, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = tabBar }))

    local tabButtons = {}
    local tabNames = { "Duel", "Performance", "Settings", "Binds" }
    local tabIds = { "duel", "performance", "settings", "binds" }
    local numTabs = #tabNames
    local tabWidth = (1 / numTabs)
    for i, tabName in ipairs(tabNames) do
        local isActive = (currentTab == tabIds[i])
        local tabBtn = createElement("TextButton", {
            Size = UDim2.new(tabWidth, 0, 1, 0),
            Position = UDim2.new(tabWidth * (i - 1), 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = isActive and COLORS.Accent or COLORS.TextDim,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            Parent = tabBar,
        })
        if isActive then trackLabel(tabBtn) end
        tabButtons[tabIds[i]] = tabBtn
    end  

    contentFrame = createElement("Frame", {  
        Name = "ContentFrame",  
        Size = UDim2.new(1, 0, 1, -(titleHeight + 60)),  
        Position = UDim2.new(0, 0, 0, titleHeight + 60),  
        BackgroundTransparency = 1,  
        Parent = mainFrame,  
    })  

    local tabs = {  
        duel = createDuelTab(contentFrame),
        performance = createPerformanceTab(contentFrame),
        settings = createSettingsTab(contentFrame),
        binds = createBindsTab(contentFrame),
    }  

    tabs[currentTab].Visible = true  

    local function switchTab(tabId)
        currentTab = tabId
        for id, t in pairs(tabs) do t.Visible = (id == tabId) end
        for id, btn in pairs(tabButtons) do
            local active = (id == tabId)
            tween(btn, tweenInfoFast, { TextColor3 = active and COLORS.Accent or COLORS.TextDim })
            if active then
                if not table.find(_accentLabels, btn) then table.insert(_accentLabels, btn) end
            else
                for i, l in ipairs(_accentLabels) do
                    if l == btn then table.remove(_accentLabels, i) break end
                end
            end
        end
    end

    for id, btn in pairs(tabButtons) do  
        btn.MouseButton1Click:Connect(function() switchTab(id) end)  
    end  

    minBtn.MouseButton1Click:Connect(function()  
        isMinimized = not isMinimized  
        minBtn.Text = isMinimized and "+" or "-"  
        if isMinimized then  
            tween(mainFrame, tweenInfoMedium, { Size = UDim2.new(0, mainWidth, 0, titleHeight) })  
            tabBar.Visible = false  
            contentFrame.Visible = false  
        else  
            tween(mainFrame, tweenInfoMedium, { Size = UDim2.new(0, mainWidth, 0, mainHeight) })  
            task.delay(0.2, function()  
                if not isMinimized then  
                    tabBar.Visible = true  
                    contentFrame.Visible = true  
                end  
            end)  
        end  
    end)  

    local dragging, dragStart, startPos  
    local function startDrag(input)  
        if CONFIG.UI_LOCKED then return end
        dragging = true  
        dragStart = input.Position  
        startPos = mainFrame.Position  
    end  
    local function stopDrag()  
        if dragging then  
            dragging = false  
            saveGuiPosition(mainFrame, "main")
        end  
    end  
    titleBar.InputBegan:Connect(function(input)  
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then startDrag(input) end  
    end)  
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then startDrag(input) end
    end)
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)

    S.UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            mainFrame.Position = newPos
        end
    end)

    S.UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local kc = input.KeyCode
        if CONFIG.TOGGLE_GUI_KEYBIND and kc == CONFIG.TOGGLE_GUI_KEYBIND then
            toggleGui()
        elseif CONFIG.AUTO_BAT_KEYBIND and kc == CONFIG.AUTO_BAT_KEYBIND then
            CONFIG.AUTO_BAT_ENABLED = not CONFIG.AUTO_BAT_ENABLED
            attacking = CONFIG.AUTO_BAT_ENABLED; saveConfig()
            if CONFIG.AUTO_BAT_ENABLED then autoAttack() end
        elseif CONFIG.AIMBOT_KEYBIND and kc == CONFIG.AIMBOT_KEYBIND then
            local newAimState = not CONFIG.AIMBOT_ENABLED
            if newAimState and CONFIG.SPINBOT_ENABLED then
                CONFIG.SPINBOT_ENABLED = false; spinbotEnabled = false; stopSpinBot()
                if _spinbotBtn then setToggleVisual(_spinbotBtn, false) end
                if spinbotPanelBtn then spinbotPanelBtn.Text = "SPIN: OFF"; spinbotPanelBtn.TextColor3 = COLORS.Accent end
                showNotification("Spin Bot", false)
            end
            CONFIG.AIMBOT_ENABLED = newAimState; aimbotEnabled = newAimState; saveConfig()
            if newAimState then startBodyAimbot() else stopBodyAimbot() end
            if _aimbotBtn then setToggleVisual(_aimbotBtn, newAimState) end
        elseif CONFIG.SPINBOT_KEYBIND and kc == CONFIG.SPINBOT_KEYBIND then
            local newSpinState = not CONFIG.SPINBOT_ENABLED
            if newSpinState and CONFIG.AIMBOT_ENABLED then
                CONFIG.AIMBOT_ENABLED = false; aimbotEnabled = false; stopBodyAimbot()
                if _aimbotBtn then setToggleVisual(_aimbotBtn, false) end
                showNotification("Aimbot", false)
            end
            CONFIG.SPINBOT_ENABLED = newSpinState; spinbotEnabled = newSpinState; saveConfig()
            if newSpinState then startSpinBot() else stopSpinBot() end
            if spinbotPanelBtn then spinbotPanelBtn.Text = "SPIN: " .. (newSpinState and "ON" or "OFF"); spinbotPanelBtn.TextColor3 = COLORS.Accent end
            if _spinbotBtn then setToggleVisual(_spinbotBtn, newSpinState) end
        elseif CONFIG.LOCK_TARGET_KEYBIND and kc == CONFIG.LOCK_TARGET_KEYBIND then
            CONFIG.LOCK_TARGET_ENABLED = not CONFIG.LOCK_TARGET_ENABLED
            lockTargetEnabled = CONFIG.LOCK_TARGET_ENABLED; saveConfig()
            if lockTargetPanelBtn then lockTargetPanelBtn.Text = "LOCK: " .. (lockTargetEnabled and "ON" or "OFF"); lockTargetPanelBtn.TextColor3 = COLORS.Accent end
            if lockTargetEnabled then startLockTarget() else stopLockTarget() end
        elseif CONFIG.AUTO_MEDUSA_KEYBIND and kc == CONFIG.AUTO_MEDUSA_KEYBIND then
            CONFIG.AUTO_MEDUSA_ENABLED = not CONFIG.AUTO_MEDUSA_ENABLED
            autoMedusaEnabled = CONFIG.AUTO_MEDUSA_ENABLED; saveConfig()
            if CONFIG.AUTO_MEDUSA_ENABLED then startAutoMedusa() else stopAutoMedusa() end
        elseif CONFIG.INSTANT_GRAB_KEYBIND and kc == CONFIG.INSTANT_GRAB_KEYBIND then
            local newState = not CONFIG.INSTANT_GRAB_ENABLED
            CONFIG.INSTANT_GRAB_ENABLED = newState; instantGrabEnabled = newState; saveConfig()
            if newState then startInstantGrab() else stopInstantGrab() end
        elseif CONFIG.DROP_BRAINROT_KEYBIND and kc == CONFIG.DROP_BRAINROT_KEYBIND then
            executeDrop()
        elseif CONFIG.FLOAT_KEYBIND and kc == CONFIG.FLOAT_KEYBIND then
            floatEnabled = not floatEnabled
            if floatPanelBtn then floatPanelBtn.Text = "FLOAT: " .. (floatEnabled and "ON" or "OFF"); floatPanelBtn.TextColor3 = COLORS.Accent end
            if floatEnabled then startFloat() else stopFloat() end; saveConfig()
        elseif CONFIG.AUTO_PLAY_L_KEYBIND and kc == CONFIG.AUTO_PLAY_L_KEYBIND then
            if apGuiInstance and apGuiInstance.Enabled then apLaunchSide("L") end
        elseif CONFIG.AUTO_PLAY_R_KEYBIND and kc == CONFIG.AUTO_PLAY_R_KEYBIND then
            if apGuiInstance and apGuiInstance.Enabled then apLaunchSide("R") end
        elseif CONFIG.AUTO_WALK_L_KEYBIND and kc == CONFIG.AUTO_WALK_L_KEYBIND then
            if awGuiInstance and awGuiInstance.Enabled then awLaunch("L") end
        elseif CONFIG.AUTO_WALK_R_KEYBIND and kc == CONFIG.AUTO_WALK_R_KEYBIND then
            if awGuiInstance and awGuiInstance.Enabled then awLaunch("R") end
        elseif CONFIG.ANTI_STEAL_KEYBIND and kc == CONFIG.ANTI_STEAL_KEYBIND then
            CONFIG.ANTI_STEAL_PANEL_VISIBLE = not CONFIG.ANTI_STEAL_PANEL_VISIBLE
            if antiStealPanelGui then antiStealPanelGui.Enabled = CONFIG.ANTI_STEAL_PANEL_VISIBLE end
            if antiStealPanelBtn then antiStealPanelBtn.Text = "ANTI STEAL: " .. (CONFIG.ANTI_STEAL_PANEL_VISIBLE and "ON" or "OFF"); antiStealPanelBtn.TextColor3 = COLORS.Accent end
            saveConfig()
        elseif CONFIG.FLING_KEYBIND and kc == CONFIG.FLING_KEYBIND then
            flingEnabled = not flingEnabled
            if flingPanelBtn then flingPanelBtn.Text = "FLING: " .. (flingEnabled and "ON" or "OFF"); flingPanelBtn.TextColor3 = COLORS.Accent end
            if flingEnabled then startFling() else stopFling() end; saveConfig()
        elseif CONFIG.AUTO_LOCK_KEYBIND and kc == CONFIG.AUTO_LOCK_KEYBIND then
            CONFIG.AUTO_LOCK_PANEL_VISIBLE = not CONFIG.AUTO_LOCK_PANEL_VISIBLE
            if autoLockPanelGui then autoLockPanelGui.Enabled = CONFIG.AUTO_LOCK_PANEL_VISIBLE end
            if autoLockPanelBtn then autoLockPanelBtn.Text = "AUTO LOCK: " .. (CONFIG.AUTO_LOCK_PANEL_VISIBLE and "ON" or "OFF"); autoLockPanelBtn.TextColor3 = COLORS.Accent end
            saveConfig()
        elseif CONFIG.TP_DOWN_KEYBIND and kc == CONFIG.TP_DOWN_KEYBIND then
            tpDown()
        end
    end)
end

-- ======================================
-- HUD: ACTIVE FEATURES LIST
-- ======================================

local function createActiveHud()
    -- Remove old if exists
    pcall(function()
        if S.PlayerGui:FindFirstChild("LooprixActiveHUD") then
            S.PlayerGui.LooprixActiveHUD:Destroy()
        end
    end)

    local hudGui = Instance.new("ScreenGui")
    hudGui.Name = "LooprixActiveHUD"
    hudGui.ResetOnSpawn = false
    hudGui.DisplayOrder = 999990
    hudGui.Enabled = CONFIG.ACTIVE_HUD_VISIBLE
    hudGui.Parent = S.PlayerGui

    -- Primary column: bottom-right
    local primaryCol = Instance.new("Frame")
    primaryCol.Name = "PrimaryCol"
    primaryCol.Size = UDim2.new(0, 160, 0, 0)
    primaryCol.Position = UDim2.new(1, -168, 1, -8)
    primaryCol.AnchorPoint = Vector2.new(0, 1)
    primaryCol.BackgroundTransparency = 1
    primaryCol.BorderSizePixel = 0
    primaryCol.AutomaticSize = Enum.AutomaticSize.Y
    primaryCol.Parent = hudGui

    local primaryLayout = Instance.new("UIListLayout", primaryCol)
    primaryLayout.FillDirection = Enum.FillDirection.Vertical
    primaryLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    primaryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    primaryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    primaryLayout.Padding = UDim.new(0, 3)

    -- Secondary column: bottom-left (overflow 5+)
    local secondaryCol = Instance.new("Frame")
    secondaryCol.Name = "SecondaryCol"
    secondaryCol.Size = UDim2.new(0, 160, 0, 0)
    secondaryCol.Position = UDim2.new(0, 8, 1, -8)
    secondaryCol.AnchorPoint = Vector2.new(0, 1)
    secondaryCol.BackgroundTransparency = 1
    secondaryCol.BorderSizePixel = 0
    secondaryCol.AutomaticSize = Enum.AutomaticSize.Y
    secondaryCol.Parent = hudGui

    local secondaryLayout = Instance.new("UIListLayout", secondaryCol)
    secondaryLayout.FillDirection = Enum.FillDirection.Vertical
    secondaryLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    secondaryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    secondaryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    secondaryLayout.Padding = UDim.new(0, 3)

    -- Toggle definitions: { configKey, displayName }
    local TOGGLE_DEFS = {
        { k = "AUTO_BAT_ENABLED",         n = "Auto Bat"       },
        { k = "AIMBOT_ENABLED",            n = "Aimbot"         },
        { k = "SPINBOT_ENABLED",           n = "Spin Bot"       },
        { k = "ANTIRAGDOLL_ENABLED",       n = "Anti Ragdoll"   },
        { k = "UNWALK_ENABLED",            n = "Unwalk"         },
        { k = "ESP_ENABLED",               n = "ESP"            },
        { k = "INF_JUMP_ENABLED",          n = "Inf Jump"       },
        { k = "OPTIMIZER_ENABLED",         n = "Optimizer"      },
        { k = "XRAY_ENABLED",              n = "XRay"           },
        { k = "LOCK_TARGET_ENABLED",       n = "Lock Target"    },
        { k = "AUTO_MEDUSA_ENABLED",       n = "Auto Medusa"    },
        { k = "INSTANT_GRAB_ENABLED",      n = "Instant Grab"   },
        { k = "ANTI_DIE_ENABLED",          n = "Anti Die"       },
        { k = "NO_COLLISION_ENABLED",      n = "No Collision"   },
        { k = "SPEED_ENABLED",             n = "Speed Boost"    },
    }

    local hudPool = {}  -- cache of row frames
    local GRAD_COLORS = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(CONFIG.GUI_COLOR_R, CONFIG.GUI_COLOR_G, CONFIG.GUI_COLOR_B)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(
            math.min(CONFIG.GUI_COLOR_R+80,255),
            math.min(CONFIG.GUI_COLOR_G+40,255),
            math.min(CONFIG.GUI_COLOR_B+60,255))),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(CONFIG.GUI_COLOR_R, CONFIG.GUI_COLOR_G, CONFIG.GUI_COLOR_B)),
    })

    local function makeHudRow(name)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 22)
        row.BackgroundColor3 = COLORS.Background
        row.BackgroundTransparency = 0.25
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Thickness = 1
        rowStroke.Color = COLORS.Accent
        rowStroke.Transparency = 0.4
        rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        trackStroke(rowStroke)

        -- Dot indicator
        local dot = Instance.new("Frame", row)
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 6, 0.5, -3)
        dot.BackgroundColor3 = COLORS.Accent
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        trackDot(dot)

        -- Pulse animation on dot
        task.spawn(function()
            while dot and dot.Parent do
                S.TweenService:Create(dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {BackgroundTransparency = 0.3}):Play()
                task.wait(0.6)
                if dot and dot.Parent then
                    S.TweenService:Create(dot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                        {BackgroundTransparency = 0}):Play()
                    task.wait(0.6)
                end
            end
        end)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -18, 1, 0)
        lbl.Position = UDim2.new(0, 17, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local lblGrad = Instance.new("UIGradient", lbl)
        lblGrad.Color = GRAD_COLORS
        table.insert(_accentGradients, lblGrad)

        return row
    end

    local function refreshHud()
        -- Gather active toggles
        local active = {}
        for _, def in ipairs(TOGGLE_DEFS) do
            if CONFIG[def.k] then
                table.insert(active, def.n)
            end
        end

        -- Clear existing rows
        for _, r in ipairs(hudPool) do
            if r and r.Parent then r:Destroy() end
        end
        hudPool = {}

        -- Populate columns
        for i, name in ipairs(active) do
            local row = makeHudRow(name)
            if i <= 5 then
                row.LayoutOrder = i
                row.Parent = primaryCol
            else
                row.LayoutOrder = i
                row.Parent = secondaryCol
            end
            table.insert(hudPool, row)
        end
    end

    -- Refresh HUD every 0.5 seconds
    task.spawn(function()
        while hudGui and hudGui.Parent do
            refreshHud()
            task.wait(0.5)
        end
    end)

    -- Animate gradient offset
    S.RunService.RenderStepped:Connect(function()
        local t = tick()
        for _, g in ipairs(_accentGradients) do
            pcall(function()
                if g and g.Parent then
                    g.Offset = Vector2.new(math.sin(t * 1.3) * 0.6, 0)
                end
            end)
        end
    end)

    return hudGui
end

-- ======================================
-- STATS ISLAND
-- ======================================

local function createStatsIsland()
    if S.PlayerGui:FindFirstChild("LooprixStats") then
        S.PlayerGui.LooprixStats:Destroy()
    end

    local TEXT_GRADIENT_COLORS = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 217, 127)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(120, 255, 210)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(150, 255, 180)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 217, 127))
    })

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LooprixStats"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 100
    screenGui.Parent = S.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainContainer"
    mainFrame.Size = UDim2.new(0, 220, 0, 22)
    mainFrame.Position = UDim2.new(0.5, 0, 0, 10)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    registerScaleTarget(mainFrame)

    local uiCorner = Instance.new("UICorner", mainFrame)
    uiCorner.CornerRadius = UDim.new(0, 6)

    local borderStroke = Instance.new("UIStroke", mainFrame)
    borderStroke.Thickness = 1
    borderStroke.Color = Color3.fromRGB(0, 217, 127)
    borderStroke.Transparency = 0.1
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(borderStroke)

    local borderGradient = Instance.new("UIGradient", borderStroke)
    borderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0, 217, 127)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120, 255, 210)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(150, 255, 180)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120, 255, 210)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0, 217, 127))
    })
    trackGradient(borderGradient)

    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(1, -12, 1, 0)
    statsLabel.Position = UDim2.new(0, 6, 0, 0)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextColor3 = Color3.new(1, 1, 1)
    statsLabel.TextScaled = false
    statsLabel.TextSize = 12
    statsLabel.RichText = true
    statsLabel.Text = "Looprix  |  FPS: --  |  PING: -- ms"
    statsLabel.Parent = mainFrame

    local statsGradient = Instance.new("UIGradient", statsLabel)
    statsGradient.Color = TEXT_GRADIENT_COLORS
    trackGradient(statsGradient)

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(0, 160, 0, 13)
    discordLabel.Position = UDim2.new(0.5, -80, 0, 36)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Font = Enum.Font.Gotham
    discordLabel.TextColor3 = Color3.new(1, 1, 1)
    discordLabel.TextScaled = false
    discordLabel.TextSize = 10
    discordLabel.Text = "discord.gg/XuKtKw2hEq"
    discordLabel.Parent = screenGui

    local discordGradient = Instance.new("UIGradient", discordLabel)
    discordGradient.Color = TEXT_GRADIENT_COLORS
    trackGradient(discordGradient)

    S.RunService.RenderStepped:Connect(function()
        local t = tick()
        local move = math.sin(t * 1.5) * 0.7
        statsGradient.Offset = Vector2.new(move, 0)
        discordGradient.Offset = Vector2.new(-move, 0)
        borderGradient.Rotation = (t * 80) % 360
    end)

    local lastTime = tick()
    local frames = 0

    S.RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local currentTime = tick()
        if currentTime - lastTime >= 0.5 then
            local fps  = math.round(frames / (currentTime - lastTime))
            local ping = math.round(S.LocalPlayer:GetNetworkPing() * 1000)
            local pingHex
            if ping < 80 then
                pingHex = string.format("%02X%02X%02X",
                    CONFIG.GUI_COLOR_R or 0,
                    CONFIG.GUI_COLOR_G or 217,
                    CONFIG.GUI_COLOR_B or 127)
            elseif ping < 150 then
                pingHex = "FFEB78"  -- yellow
            else
                pingHex = "FF6478"  -- red
            end
            statsLabel.Text = string.format(
                "Looprix  |  FPS: %d  |  PING: <font color=\"#%s\">%d ms</font>",
                fps, pingHex, ping)
            frames = 0
            lastTime = currentTime
        end
    end)

    return screenGui
end

-- ======================================
-- REAPPLY SETTINGS ON CHARACTER RESPAWN
-- ======================================

local function reapplyAllSettings()
    if CONFIG.ANTI_DIE_ENABLED then
        task.wait(0.2)
        activateAntiDie()
        antiDieEnabled = true
    end
    
    if CONFIG.AUTO_BAT_ENABLED then
        attacking = true
        autoAttack()
    end
    
    if CONFIG.AIMBOT_ENABLED then
        aimbotEnabled = true
        startBodyAimbot()
    end
    
    if CONFIG.SPINBOT_ENABLED then
        spinbotEnabled = true
        startSpinBot()
    end
    
    if CONFIG.ANTIRAGDOLL_ENABLED then
        toggleAntiRagdoll(true)
    end
    
    if CONFIG.UNWALK_ENABLED then
        unwalkEnabled = true
        startUnwalk()
    end
    
    if CONFIG.ESP_ENABLED then
        espEnabled = true
        startESP()
    end
    
    
    if CONFIG.LOCK_TARGET_ENABLED then
        lockTargetEnabled = true
        startLockTarget()
    end
    
    if CONFIG.INF_JUMP_ENABLED then
        infJumpEnabled = true
        startInfJump()
    end
    
    if CONFIG.OPTIMIZER_ENABLED then
        optimizerEnabled = true
        startOptimizer()
    end
    
    if CONFIG.XRAY_ENABLED then
        xrayEnabled = true
        startXRay()
    end
    
    if CONFIG.AUTO_MEDUSA_ENABLED then
        autoMedusaEnabled = true
        startAutoMedusa()
    end
    
    if CONFIG.INSTANT_GRAB_ENABLED then
        instantGrabEnabled = true
        startInstantGrab()
    end
    
    if CONFIG.NO_COLLISION_ENABLED then
        startNoCollision()
    end
    
    if CONFIG.FLOAT_PANEL_VISIBLE and floatPanelGui then
        floatPanelGui.Enabled = true
    end
    if CONFIG.FLING_PANEL_VISIBLE and flingPanelGui then
        flingPanelGui.Enabled = true
    end
    if CONFIG.SPINBOT_PANEL_VISIBLE and spinbotPanelGui then
        spinbotPanelGui.Enabled = true
    end
    if CONFIG.TAUNT_PANEL_VISIBLE and tauntPanelGui then
        tauntPanelGui.Enabled = true
    end
    if CONFIG.AUTO_WALK_PANEL_VISIBLE and awGuiInstance then
        awGuiInstance.Enabled = true
    end
    if CONFIG.TP_DOWN_PANEL_VISIBLE and tpDownPanelGui then
        tpDownPanelGui.Enabled = true
    end
    if CONFIG.AUTO_LOCK_PANEL_VISIBLE and autoLockPanelGui then
        autoLockPanelGui.Enabled = true
    end
end

-- ======================================
-- CHARACTER RESPAWN HANDLING
-- ======================================

local function onCharacterAdded(c)
    character = c
    HRP = c:WaitForChild("HumanoidRootPart")

    clearConnections()
    runCleanups()
    
    task.wait(0.5)
    reapplyAllSettings()
end

S.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- ======================================
-- INITIALIZATION
-- ======================================

loadConfig()

-- Apply saved GUI color on startup
do
    local r = CONFIG.GUI_COLOR_R or 0
    local g = CONFIG.GUI_COLOR_G or 217
    local b = CONFIG.GUI_COLOR_B or 127
    COLORS.Accent = Color3.fromRGB(r, g, b)
end

createGui()
-- Restore saved GUI visibility
guiVisible = (CONFIG.MAIN_GUI_VISIBLE ~= false)
if mainFrame then mainFrame.Visible = guiVisible end
setupFloatingPanels()
speedGuiInstance = createSpeedGui()
apGuiInstance    = createAutoPlayGui()
awGuiInstance    = createAutoWalkGui()
createStatsIsland()
createActiveHud()

-- Propagate saved accent color to ALL tracked elements (stats island, discord, speed gui, etc.)
do
    local r = CONFIG.GUI_COLOR_R or 0
    local g = CONFIG.GUI_COLOR_G or 217
    local b = CONFIG.GUI_COLOR_B or 127
    applyAccentColor(r, g, b)
end

-- Apply saved UI scale to all registered scale targets
applyUIScale(scaleMultiplier)

-- ======================================
-- FLOATING TOGGLE BUTTON  (2×2 grid icon)
-- ======================================

local function createToggleButton()
    local tbGui = Instance.new("ScreenGui")
    tbGui.Name = "Looprix_ToggleBtn"
    tbGui.ResetOnSpawn = false
    tbGui.DisplayOrder = 9999998
    tbGui.IgnoreGuiInset = true

    pcall(function()
        if gethui then
            tbGui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(tbGui)
            tbGui.Parent = S.PlayerGui
        else
            tbGui.Parent = S.PlayerGui
        end
    end)
    if not tbGui.Parent then tbGui.Parent = S.PlayerGui end

    -- Rounded square card
    local btn = Instance.new("Frame")
    btn.Name = "LooprixToggleBtn"
    btn.Size = UDim2.new(0, 42, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel = 0
    btn.Parent = tbGui
    registerScaleTarget(btn)

    local savedTB = CONFIG._guiPositions and CONFIG._guiPositions.toggleBtn
    if savedTB then
        btn.Position = UDim2.new(savedTB.scaleX, savedTB.offsetX, savedTB.scaleY, savedTB.offsetY)
    else
        btn.Position = UDim2.new(0, 12, 1, -56)
    end

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    -- Animated gradient border
    local outerStroke = Instance.new("UIStroke", btn)
    outerStroke.Thickness = 1.5
    outerStroke.Color = COLORS.Accent
    outerStroke.Transparency = 0.1
    outerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke(outerStroke)

    local outerGrad = Instance.new("UIGradient", outerStroke)
    outerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,217,127)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(150,255,180)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120,255,210)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,217,127))
    })
    trackGradient(outerGrad)
    S.RunService.RenderStepped:Connect(function()
        outerGrad.Rotation = (tick() * 80) % 360
    end)

    -- 2×2 grid icon — four rounded squares
    local CELL = 10
    local GAP  = 4
    local TOTAL = CELL * 2 + GAP  -- 24
    local OX = math.floor((42 - TOTAL) / 2)  -- left offset to centre
    local OY = math.floor((42 - TOTAL) / 2)

    local positions = {
        { OX,          OY         },
        { OX + CELL + GAP, OY         },
        { OX,          OY + CELL + GAP },
        { OX + CELL + GAP, OY + CELL + GAP },
    }

    local cells = {}
    for _, pos in ipairs(positions) do
        local cell = Instance.new("Frame", btn)
        cell.Size = UDim2.new(0, CELL, 0, CELL)
        cell.Position = UDim2.new(0, pos[1], 0, pos[2])
        cell.BackgroundColor3 = COLORS.Accent
        cell.BackgroundTransparency = 0
        cell.BorderSizePixel = 0
        Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 3)
        trackFrame(cell)
        table.insert(cells, cell)
    end

    -- ── Input ─────────────────────────────────────────────────────────────────
    local tbDragging  = false
    local tbDragStart = nil
    local tbStartPos  = nil
    local tbActive    = false

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            tbActive    = true
            tbDragging  = false
            tbDragStart = inp.Position
            tbStartPos  = btn.Position
        end
    end)

    S.UserInputService.InputChanged:Connect(function(inp)
        if not tbActive then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or
           inp.UserInputType == Enum.UserInputType.Touch then
            if tbDragStart and (inp.Position - tbDragStart).Magnitude > 5 then
                if not CONFIG.UI_LOCKED then
                    tbDragging = true
                    local delta = inp.Position - tbDragStart
                    btn.Position = UDim2.new(
                        tbStartPos.X.Scale, tbStartPos.X.Offset + delta.X,
                        tbStartPos.Y.Scale, tbStartPos.Y.Offset + delta.Y
                    )
                end
            end
        end
    end)

    S.UserInputService.InputEnded:Connect(function(inp)
        if not tbActive then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            tbActive = false
            if tbDragging then
                CONFIG._guiPositions = CONFIG._guiPositions or {}
                CONFIG._guiPositions.toggleBtn = {
                    scaleX  = btn.Position.X.Scale,
                    scaleY  = btn.Position.Y.Scale,
                    offsetX = btn.Position.X.Offset,
                    offsetY = btn.Position.Y.Offset,
                }
                saveConfig()
            else
                -- Toggle main GUI
                guiVisible = not guiVisible
                if mainFrame then mainFrame.Visible = guiVisible end
                CONFIG.MAIN_GUI_VISIBLE = guiVisible
                saveConfig()
                -- Pulse the cells
                for _, c in ipairs(cells) do
                    S.TweenService:Create(c, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = 0.5
                    }):Play()
                end
                task.delay(0.12, function()
                    for _, c in ipairs(cells) do
                        S.TweenService:Create(c, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                            BackgroundTransparency = 0
                        }):Play()
                    end
                end)
            end
            tbDragging  = false
            tbDragStart = nil
        end
    end)

    -- Re-apply saved accent color so toggle button elements get the right color
    pcall(function()
        applyAccentColor(CONFIG.GUI_COLOR_R or 0, CONFIG.GUI_COLOR_G or 217, CONFIG.GUI_COLOR_B or 127)
    end)

    return tbGui
end

createToggleButton()

reapplyAllSettings()

end -- _main
_main()