local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local ACCENT      = Color3.fromRGB(124, 77, 255)
local BG_DARK     = Color3.fromRGB(14, 14, 14)
local BG_SIDEBAR  = Color3.fromRGB(18, 18, 18)
local BG_CONTENT  = Color3.fromRGB(24, 24, 24)
local BG_ITEM     = Color3.fromRGB(31, 31, 31)
local BG_ITEM2    = Color3.fromRGB(38, 38, 38)
local TEXT_MAIN   = Color3.fromRGB(225, 225, 225)
local TEXT_DIM    = Color3.fromRGB(140, 140, 140)
local TEXT_ACCENT = ACCENT
local DIVIDER     = Color3.fromRGB(40, 40, 40)

local Nexora = {}
Nexora.Unloaded = false
Nexora.Flags = {}

Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local function GetGui()
    if RunService:IsStudio() then return Player.PlayerGui end
    return (rawget(_G, "gethui") and gethui()) or (rawget(_G, "cloneref") and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")
end

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    if parent then obj.Parent = parent end
    return obj
end

local function Corner(radius, parent)
    New("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function Stroke(color, thickness, transparency, parent)
    New("UIStroke", { Color = color, Thickness = thickness or 1, Transparency = transparency or 0 }, parent)
end

local function CircleClick(btn, x, y)
    task.spawn(function()
        btn.ClipsDescendants = true
        local c = New("ImageLabel", {
            Image = "rbxassetid://106471194043211",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.75,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            ZIndex = 20,
            Name = "Circle"
        }, btn)
        c.Position = UDim2.new(0, x - btn.AbsolutePosition.X, 0, y - btn.AbsolutePosition.Y)
        local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.6
        TweenService:Create(c, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, sz, 0, sz),
            Position = UDim2.new(0.5, -sz/2, 0.5, -sz/2),
            ImageTransparency = 1
        }):Play()
        task.wait(0.55)
        c:Destroy()
    end)
end

local function Draggable(handle, target)
    local drag, dStart, dPos = false, nil, nil
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true; dStart = inp.Position; dPos = target.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dStart
            target.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
        end
    end)
end

local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

function Nexora:Notify(Config)
    local title   = Config.Title or Config[1] or "Nexora"
    local desc    = Config.Description or Config[2] or ""
    local content = Config.Content or Config[3] or ""
    local anim    = Config.Time or 0.35
    local delay   = Config.Delay or 4

    local nGui = New("ScreenGui", { ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false, Name = "NexoraNotif" }, GetGui())

    local baseH = 58
    if desc ~= "" then baseH = baseH + 14 end
    if content ~= "" then baseH = baseH + 16 end

    local NFrame = New("Frame", {
        BackgroundColor3 = BG_ITEM,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 380, 1, -18),
        Size = UDim2.new(0, 290, 0, baseH),
        Name = "NFrame"
    }, nGui)
    Corner(8, NFrame)
    Stroke(ACCENT, 1, 0.45, NFrame)

    New("Frame", {
        BackgroundColor3 = ACCENT,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(0, 3, 1, -20),
        Name = "Accent"
    }, NFrame)
    Corner(2, NFrame:FindFirstChild("Accent"))

    New("TextLabel", {
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = TEXT_MAIN,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 10),
        Size = UDim2.new(1, -36, 0, 14),
        Name = "NTitle"
    }, NFrame)

    if desc ~= "" then
        New("TextLabel", {
            Font = Enum.Font.GothamBold,
            Text = desc,
            TextColor3 = ACCENT,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 26),
            Size = UDim2.new(1, -16, 0, 13),
            Name = "NDesc"
        }, NFrame)
    end

    if content ~= "" then
        New("TextLabel", {
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = TEXT_DIM,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, desc ~= "" and 40 or 28),
            Size = UDim2.new(1, -16, 0, 20),
            Name = "NContent"
        }, NFrame)
    end

    local closeBtn = New("TextButton", {
        Font = Enum.Font.GothamBold, Text = "×",
        TextColor3 = TEXT_DIM, TextSize = 16,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, 4),
        Size = UDim2.new(0, 20, 0, 20),
        Name = "NClose"
    }, NFrame)

    local closed = false
    local function CloseNotif()
        if closed then return end
        closed = true
        Tween(NFrame, { Position = UDim2.new(1, 380, 1, -18) }, anim, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(anim + 0.05)
        nGui:Destroy()
    end

    closeBtn.Activated:Connect(CloseNotif)
    Tween(NFrame, { Position = UDim2.new(1, -18, 1, -18) }, anim, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    task.delay(delay, CloseNotif)
end

function Nexora:CreateWindow(Config)
    local winTitle   = Config.Title or Config[1] or "NEXORA"
    local winVersion = Config.Version or Config[2] or "v1.0"
    local winSize    = Config.Size or UDim2.fromOffset(600, 360)
    local menuKey    = Config.MenuKey or Enum.KeyCode.RightShift
    local sideW      = Config.SidebarWidth or 150

    local screenGui = New("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Name = "NexoraHub"
    }, GetGui())

    local statusGui = New("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Name = "NexoraStatus"
    }, GetGui())

    local StatusBarFrame = New("Frame", {
        BackgroundColor3 = BG_DARK,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 6),
        Size = UDim2.new(0, 360, 0, 26),
        Name = "StatusBar",
        Visible = true
    }, statusGui)
    Corner(7, StatusBarFrame)
    Stroke(DIVIDER, 1, 0, StatusBarFrame)

    local function SLabel(text, color, xOffset, width, name)
        return New("TextLabel", {
            Font = Enum.Font.GothamBold,
            Text = text, TextColor3 = color, TextSize = 10,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, xOffset, 0, 0),
            Size = UDim2.new(0, width, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2, Name = name or "SLabel"
        }, StatusBarFrame)
    end

    SLabel("NEXORA", Color3.fromRGB(210, 210, 210), 8, 58, "NexLabel")
    SLabel("FPS", TEXT_DIM, 72, 22, "FPSKey")
    local fpsVal  = SLabel("60",  Color3.fromRGB(90, 220, 90),  96,  30, "FPSVal")
    SLabel("PING", TEXT_DIM, 134, 30, "PingKey")
    local pingVal = SLabel("0 ms", Color3.fromRGB(255, 100, 100), 165, 42, "PingVal")
    SLabel("GAME", TEXT_DIM, 214, 32, "GameKey")
    SLabel(game.Name, Color3.fromRGB(200, 200, 200), 248, 108, "GameVal")

    local fpsCount, lastTick = 0, tick()
    RunService.RenderStepped:Connect(function()
        fpsCount += 1
        if tick() - lastTick >= 1 then
            local f = fpsCount
            fpsVal.Text = tostring(f)
            fpsVal.TextColor3 = f >= 55 and Color3.fromRGB(80, 220, 80) or f >= 30 and Color3.fromRGB(230, 200, 60) or Color3.fromRGB(230, 70, 70)
            fpsCount = 0; lastTick = tick()
        end
    end)
    task.spawn(function()
        while statusGui and statusGui.Parent do
            local ok, p = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok then
                local ms = math.floor(p)
                pingVal.Text = ms .. " ms"
                pingVal.TextColor3 = ms < 80 and Color3.fromRGB(80, 220, 80) or ms < 160 and Color3.fromRGB(230, 200, 60) or Color3.fromRGB(230, 70, 70)
            end
            task.wait(1)
        end
    end)

    local Holder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = winSize,
        Name = "Holder"
    }, screenGui)

    local Main = New("Frame", {
        BackgroundColor3 = BG_SIDEBAR,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Name = "Main"
    }, Holder)
    Corner(10, Main)
    Stroke(Color3.fromRGB(50, 50, 50), 1.5, 0, Main)

    local TopBar = New("Frame", {
        BackgroundColor3 = BG_DARK,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 38),
        Name = "TopBar",
        ZIndex = 2
    }, Main)
    Corner(10, TopBar)
    New("Frame", {
        BackgroundColor3 = BG_DARK, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0), Name = "BottomFix"
    }, TopBar)

    local NBadge = New("Frame", {
        BackgroundColor3 = ACCENT, BorderSizePixel = 0,
        Position = UDim2.new(0, 9, 0.5, -9),
        Size = UDim2.new(0, 18, 0, 18), Name = "NBadge", ZIndex = 3
    }, TopBar)
    Corner(5, NBadge)
    New("TextLabel", {
        Font = Enum.Font.GothamBold, Text = "N",
        TextColor3 = Color3.fromRGB(255,255,255), TextSize = 12,
        BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), ZIndex = 3
    }, NBadge)

    New("TextLabel", {
        Font = Enum.Font.GothamBold, Text = winTitle,
        TextColor3 = TEXT_MAIN, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 33, 0, 0),
        Size = UDim2.new(0, 120, 1, 0), ZIndex = 3
    }, TopBar)

    New("TextLabel", {
        Font = Enum.Font.Gotham, Text = "hub",
        TextColor3 = Color3.fromRGB(90, 90, 90), TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 33 + 60, 0, 0),
        Size = UDim2.new(0, 28, 1, 0), ZIndex = 3
    }, TopBar)

    New("TextLabel", {
        Font = Enum.Font.Gotham, Text = winVersion,
        TextColor3 = TEXT_DIM, TextSize = 11,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -70, 0.5, 0),
        Size = UDim2.new(0, 35, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3
    }, TopBar)

    local MinBtn = New("TextButton", {
        Font = Enum.Font.GothamBold, Text = "−",
        TextColor3 = TEXT_DIM, TextSize = 18,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -34, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24), ZIndex = 3, Name = "MinBtn"
    }, TopBar)

    local CloseWinBtn = New("TextButton", {
        Font = Enum.Font.GothamBold, Text = "×",
        TextColor3 = TEXT_DIM, TextSize = 16,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24), ZIndex = 3, Name = "CloseWinBtn"
    }, TopBar)

    local Sidebar = New("Frame", {
        BackgroundColor3 = BG_SIDEBAR,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 38),
        Size = UDim2.new(0, sideW, 1, -38),
        Name = "Sidebar"
    }, Main)
    Corner(10, Sidebar)
    New("Frame", {
        BackgroundColor3 = BG_SIDEBAR, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 10), Name = "TopFix"
    }, Sidebar)
    New("Frame", {
        BackgroundColor3 = BG_SIDEBAR, BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 0),
        Size = UDim2.new(0, 10, 0, 10), Name = "CornerFix"
    }, Sidebar)

    New("Frame", {
        BackgroundColor3 = DIVIDER, BorderSizePixel = 0,
        Position = UDim2.new(0, sideW, 0, 38),
        Size = UDim2.new(0, 1, 1, -38), Name = "Divider"
    }, Main)

    local TabScrollList = New("ScrollingFrame", {
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 6),
        Size = UDim2.new(1, 0, 1, -6),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Name = "TabScrollList"
    }, Sidebar)
    New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, TabScrollList)
    New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6) }, TabScrollList)

    local ContentArea = New("Frame", {
        BackgroundColor3 = BG_CONTENT,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = UDim2.new(0, sideW + 1, 0, 38),
        Size = UDim2.new(1, -(sideW + 1), 1, -38),
        Name = "ContentArea",
        ClipsDescendants = true
    }, Main)
    Corner(10, ContentArea)
    New("Frame", {
        BackgroundColor3 = BG_CONTENT, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 10, 0, 10), Name = "TopLeftFix"
    }, ContentArea)
    New("Frame", {
        BackgroundColor3 = BG_CONTENT, BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(0, 10, 0, 10), Name = "BotLeftFix"
    }, ContentArea)

    local PageFolder = New("Folder", { Name = "PageFolder" }, ContentArea)
    local PageLayout = New("UIPageLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        TweenTime = 0.25,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.InOut,
        Name = "PageLayout"
    }, PageFolder)

    local minimized = false
    local currentTabBtn = nil

    MinBtn.Activated:Connect(function()
        CircleClick(MinBtn, Player:GetMouse().X, Player:GetMouse().Y)
        minimized = not minimized
        if minimized then
            Tween(Main, { Size = UDim2.new(1, 0, 0, 38) }, 0.3, Enum.EasingStyle.Quad)
            Sidebar.Visible = false
            ContentArea.Visible = false
        else
            Sidebar.Visible = true
            ContentArea.Visible = true
            Tween(Main, { Size = UDim2.new(1, 0, 1, 0) }, 0.3, Enum.EasingStyle.Quad)
        end
    end)

    CloseWinBtn.Activated:Connect(function()
        CircleClick(CloseWinBtn, Player:GetMouse().X, Player:GetMouse().Y)
        Tween(Main, { Size = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        screenGui:Destroy()
        statusGui:Destroy()
        Nexora.Unloaded = true
    end)

    local currentKey = menuKey
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == currentKey then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    Draggable(TopBar, Holder)

    local Tabs = {}
    local tabCount = 0

    function Tabs:CreateTab(Config)
        local tName = Config.Name or Config[1] or "Tab"
        local tIcon = Config.Icon or Config[2] or ""

        local TabBtn = New("Frame", {
            BackgroundColor3 = tabCount == 0 and BG_ITEM2 or Color3.fromRGB(0,0,0),
            BackgroundTransparency = tabCount == 0 and 0 or 1,
            BorderSizePixel = 0,
            LayoutOrder = tabCount,
            Size = UDim2.new(1, 0, 0, 32),
            Name = "TabBtn"
        }, TabScrollList)
        Corner(6, TabBtn)

        local ActiveBar = New("Frame", {
            BackgroundColor3 = ACCENT,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -8),
            Size = UDim2.new(0, 3, 0, tabCount == 0 and 16 or 0),
            Name = "ActiveBar"
        }, TabBtn)
        Corner(2, ActiveBar)

        New("TextLabel", {
            Font = Enum.Font.GothamBold, Text = tName,
            TextColor3 = tabCount == 0 and TEXT_MAIN or TEXT_DIM,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -10, 1, 0),
            Name = "TabLabel"
        }, TabBtn)

        local TabClickBtn = New("TextButton", {
            Text = "", BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0), ZIndex = 2
        }, TabBtn)

        local TabPage = New("ScrollingFrame", {
            BackgroundTransparency = 1, BorderSizePixel = 0,
            LayoutOrder = tabCount,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = ACCENT,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Name = "TabPage",
            Parent = PageFolder
        })
        New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, TabPage)
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)
        }, TabPage)

        local function UpdateTabCanvas()
            local total = 0
            for _, ch in pairs(TabPage:GetChildren()) do
                if ch:IsA("GuiObject") then total = total + ch.Size.Y.Offset + 5 end
            end
            TabPage.CanvasSize = UDim2.new(0, 0, 0, total + 20)
        end
        TabPage.ChildAdded:Connect(function() task.wait() UpdateTabCanvas() end)
        TabPage.ChildRemoved:Connect(function() task.wait() UpdateTabCanvas() end)

        local function UpdateSidebarCanvas()
            local total = 0
            for _, ch in pairs(TabScrollList:GetChildren()) do
                if ch:IsA("GuiObject") and ch.Name == "TabBtn" then total = total + ch.Size.Y.Offset + 2 end
            end
            TabScrollList.CanvasSize = UDim2.new(0, 0, 0, total + 16)
        end
        UpdateSidebarCanvas()

        if tabCount == 0 then
            currentTabBtn = TabBtn
            PageLayout:JumpToIndex(0)
        end

        local myOrder = tabCount
        tabCount += 1

        TabClickBtn.Activated:Connect(function()
            if currentTabBtn == TabBtn then return end
            CircleClick(TabClickBtn, Player:GetMouse().X, Player:GetMouse().Y)
            for _, tb in pairs(TabScrollList:GetChildren()) do
                if tb:IsA("Frame") and tb.Name == "TabBtn" then
                    Tween(tb, { BackgroundTransparency = 1 }, 0.15)
                    local lbl = tb:FindFirstChild("TabLabel")
                    if lbl then Tween(lbl, { TextColor3 = TEXT_DIM }, 0.15) end
                    local bar = tb:FindFirstChild("ActiveBar")
                    if bar then Tween(bar, { Size = UDim2.new(0, 3, 0, 0) }, 0.15) end
                end
            end
            Tween(TabBtn, { BackgroundTransparency = 0, BackgroundColor3 = BG_ITEM2 }, 0.15)
            local lbl = TabBtn:FindFirstChild("TabLabel")
            if lbl then Tween(lbl, { TextColor3 = TEXT_MAIN }, 0.15) end
            Tween(ActiveBar, { Size = UDim2.new(0, 3, 0, 16) }, 0.2)
            PageLayout:JumpToIndex(myOrder)
            currentTabBtn = TabBtn
        end)

        local Sections = {}
        local sectionCount = 0

        function Sections:AddSection(Config)
            local sName = type(Config) == "string" and Config or (Config.Name or Config[1] or "Section")
            local openDefault = type(Config) == "table" and (Config.Open ~= nil and Config.Open or true) or true

            local SectionFrame = New("Frame", {
                BackgroundColor3 = BG_ITEM,
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                LayoutOrder = sectionCount,
                Size = UDim2.new(1, 0, 0, 32),
                ClipsDescendants = true,
                Name = "Section",
                Parent = TabPage
            })
            Corner(7, SectionFrame)

            local SecHeader = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32),
                Name = "SecHeader"
            }, SectionFrame)

            New("TextLabel", {
                Font = Enum.Font.GothamBold, Text = sName,
                TextColor3 = ACCENT, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -28, 1, 0),
                Name = "SecTitle"
            }, SecHeader)

            local Arrow = New("TextLabel", {
                Font = Enum.Font.GothamBold, Text = "▸",
                TextColor3 = TEXT_DIM, TextSize = 10,
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                Name = "Arrow"
            }, SecHeader)

            local SecBtn = New("TextButton", {
                Text = "", BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 32), ZIndex = 3, Name = "SecBtn"
            }, SecHeader)

            local SecContent = New("Frame", {
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 32),
                Size = UDim2.new(1, 0, 0, 0),
                Name = "SecContent"
            }, SectionFrame)
            New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, SecContent)
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6)
            }, SecContent)

            local secOpen = false

            local function CalcContentHeight()
                local total = 6
                for _, ch in pairs(SecContent:GetChildren()) do
                    if ch:IsA("GuiObject") then total = total + ch.Size.Y.Offset + 4 end
                end
                return total
            end

            local function UpdateSection()
                if not secOpen then return end
                local h = CalcContentHeight()
                SecContent.Size = UDim2.new(1, 0, 0, h)
                SectionFrame.Size = UDim2.new(1, 0, 0, 32 + h)
                UpdateTabCanvas()
            end

            local function ToggleSec()
                CircleClick(SecBtn, Player:GetMouse().X, Player:GetMouse().Y)
                secOpen = not secOpen
                if secOpen then
                    Arrow.Text = "▾"
                    local h = CalcContentHeight()
                    Tween(SecContent, { Size = UDim2.new(1, 0, 0, h) }, 0.2)
                    Tween(SectionFrame, { Size = UDim2.new(1, 0, 0, 32 + h) }, 0.2)
                    task.wait(0.2); UpdateTabCanvas()
                else
                    Arrow.Text = "▸"
                    Tween(SecContent, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                    Tween(SectionFrame, { Size = UDim2.new(1, 0, 0, 32) }, 0.2)
                    task.wait(0.2); UpdateTabCanvas()
                end
            end

            SecContent.ChildAdded:Connect(function() task.wait() UpdateSection() end)
            SecContent.ChildRemoved:Connect(function() task.wait() UpdateSection() end)
            SecBtn.Activated:Connect(ToggleSec)

            sectionCount += 1

            if openDefault then task.spawn(function() task.wait(0.05) ToggleSec() end) end

            local Item = {}
            local itemCount = 0

            function Item:AddParagraph(Config)
                local ptitle   = Config.Title or Config[1] or ""
                local pcontent = Config.Content or Config[2] or ""
                local Funcs = {}

                local Para = New("Frame", {
                    BackgroundColor3 = BG_ITEM2, BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 38), Name = "Paragraph", Parent = SecContent
                })
                Corner(5, Para)

                local PT = New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = ptitle,
                    TextColor3 = TEXT_MAIN, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 8),
                    Size = UDim2.new(1, -16, 0, 13), Name = "PT"
                }, Para)

                local PC = New("TextLabel", {
                    Font = Enum.Font.Gotham, Text = pcontent,
                    TextColor3 = TEXT_DIM, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true, BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 22),
                    Size = UDim2.new(1, -16, 0, 13), Name = "PC"
                }, Para)

                local function UpdPara()
                    PC.TextWrapped = false
                    local lines = math.max(1, math.ceil(PC.TextBounds.X / math.max(1, PC.AbsoluteSize.X)))
                    PC.Size = UDim2.new(1, -16, 0, lines * 13)
                    PC.TextWrapped = true
                    Para.Size = UDim2.new(1, 0, 0, 22 + PC.Size.Y.Offset + 8)
                    UpdateSection()
                end
                UpdPara()
                PC:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdPara)

                function Funcs:Set(Config)
                    PT.Text = Config.Title or Config[1] or PT.Text
                    PC.Text = Config.Content or Config[2] or PC.Text
                    UpdPara()
                end

                itemCount += 1
                return Funcs
            end

            function Item:AddSeperator(Config)
                local stitle = type(Config) == "string" and Config or (Config and (Config.Title or Config[1]) or "")
                local Funcs = {}

                local Sep = New("Frame", {
                    BackgroundColor3 = Color3.fromRGB(36, 36, 36), BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 22), Name = "Separator", Parent = SecContent
                })
                Corner(4, Sep)
                New("UIGradient", {
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, BG_ITEM),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(42, 42, 42)),
                        ColorSequenceKeypoint.new(1, BG_ITEM)
                    }
                }, Sep)

                local SepLine = New("Frame", {
                    BackgroundColor3 = ACCENT, BackgroundTransparency = 0.55, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0.85, 0, 0, 1), Name = "SepLine"
                }, Sep)
                Corner(1, SepLine)

                if stitle ~= "" then
                    local SL = New("TextLabel", {
                        Font = Enum.Font.GothamBold, Text = stitle,
                        TextColor3 = TEXT_DIM, TextSize = 10,
                        BackgroundColor3 = Color3.fromRGB(36, 36, 36), BackgroundTransparency = 0,
                        BorderSizePixel = 0,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 54, 1, -4), Name = "SepLabel"
                    }, Sep)
                    Corner(3, SL)
                end

                function Funcs:Set(Config)
                    local t = Config.Title or Config[1]
                    local sl = Sep:FindFirstChild("SepLabel")
                    if t and sl then sl.Text = t end
                end

                itemCount += 1
                return Funcs
            end

            function Item:AddLine()
                New("Frame", {
                    BackgroundColor3 = DIVIDER, BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 1),
                    Name = "Line", Parent = SecContent
                })
                itemCount += 1
                return {}
            end

            function Item:AddButton(Config)
                local btitle = Config.Title or Config[1] or ""
                local bcont  = Config.Content or Config[2] or ""
                local bcb    = Config.Callback or Config[3] or function() end
                local bicon  = Config.Icon or "rbxassetid://7734010488"
                local Funcs  = {}

                local Btn = New("Frame", {
                    BackgroundColor3 = BG_ITEM2, BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 36), Name = "Button", Parent = SecContent
                })
                Corner(5, Btn)
                Stroke(Color3.fromRGB(44, 44, 44), 1, 0, Btn)

                New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = btitle,
                    TextColor3 = TEXT_MAIN, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -80, 0, 13), Name = "BTitle"
                }, Btn)

                local BCont = New("TextLabel", {
                    Font = Enum.Font.Gotham, Text = bcont,
                    TextColor3 = TEXT_DIM, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 23),
                    Size = UDim2.new(1, -80, 0, 12), Name = "BCont"
                }, Btn)

                local ExecFrame = New("Frame", {
                    BackgroundColor3 = ACCENT, BackgroundTransparency = 0.8, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 56, 0, 22), Name = "ExecFrame"
                }, Btn)
                Corner(4, ExecFrame)
                New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = "Execute",
                    TextColor3 = ACCENT, TextSize = 10,
                    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0)
                }, ExecFrame)

                local BClick = New("TextButton", {
                    Text = "", BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0), ZIndex = 3
                }, Btn)

                local function UpdBtn()
                    BCont.TextWrapped = false
                    local l = math.max(1, math.ceil(BCont.TextBounds.X / math.max(1, BCont.AbsoluteSize.X)))
                    BCont.Size = UDim2.new(1, -80, 0, l * 12)
                    BCont.TextWrapped = true
                    Btn.Size = UDim2.new(1, 0, 0, BCont.AbsoluteSize.Y + 34)
                    UpdateSection()
                end
                UpdBtn()
                BCont:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdBtn)

                BClick.Activated:Connect(function()
                    CircleClick(BClick, Player:GetMouse().X, Player:GetMouse().Y)
                    Tween(Btn, { BackgroundColor3 = Color3.fromRGB(44, 44, 44) }, 0.08)
                    task.wait(0.1)
                    Tween(Btn, { BackgroundColor3 = BG_ITEM2 }, 0.1)
                    task.spawn(bcb)
                end)

                function Funcs:Set(Config)
                    local bl = Btn:FindFirstChild("BTitle")
                    local bc = Btn:FindFirstChild("BCont")
                    if bl then bl.Text = Config.Title or Config[1] or bl.Text end
                    if bc then bc.Text = Config.Content or Config[2] or bc.Text; UpdBtn() end
                end

                itemCount += 1
                return Funcs
            end

            function Item:AddToggle(Config)
                local ttitle = Config.Title or Config[1] or ""
                local tcont  = Config.Content or Config[2] or ""
                local tdef   = Config.Default ~= nil and Config.Default or (Config[3] or false)
                local tcb    = Config.Callback or Config[4] or function() end
                local flag   = Config.Flag or Config[5]
                local Funcs  = { Value = tdef }

                local Tog = New("Frame", {
                    BackgroundColor3 = BG_ITEM2, BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 36), Name = "Toggle", Parent = SecContent
                })
                Corner(5, Tog)

                local TTitle = New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = ttitle,
                    TextColor3 = TEXT_MAIN, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -66, 0, 13), Name = "TTitle"
                }, Tog)

                local TCont = New("TextLabel", {
                    Font = Enum.Font.Gotham, Text = tcont,
                    TextColor3 = TEXT_DIM, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 23),
                    Size = UDim2.new(1, -66, 0, 12), Name = "TCont"
                }, Tog)

                local SwBg = New("Frame", {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50), BackgroundTransparency = 0, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 36, 0, 18), Name = "SwBg"
                }, Tog)
                Corner(9, SwBg)
                local SwStroke = Stroke(Color3.fromRGB(70, 70, 70), 1.2, 0, SwBg)

                local SwCircle = New("Frame", {
                    BackgroundColor3 = Color3.fromRGB(170, 170, 170), BackgroundTransparency = 0, BorderSizePixel = 0,
                    Position = UDim2.new(0, 2, 0.5, -7),
                    Size = UDim2.new(0, 14, 0, 14), Name = "SwCircle"
                }, SwBg)
                Corner(7, SwCircle)

                local TClick = New("TextButton", {
                    Text = "", BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0), ZIndex = 3
                }, Tog)

                local function UpdTog()
                    TCont.TextWrapped = false
                    local l = math.max(1, math.ceil(TCont.TextBounds.X / math.max(1, TCont.AbsoluteSize.X)))
                    TCont.Size = UDim2.new(1, -66, 0, l * 12)
                    TCont.TextWrapped = true
                    Tog.Size = UDim2.new(1, 0, 0, TCont.AbsoluteSize.Y + 34)
                    UpdateSection()
                end
                UpdTog()
                TCont:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdTog)

                local function SetToggle(val)
                    Funcs.Value = val
                    if flag then Nexora.Flags[flag] = val end
                    local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                    if val then
                        TweenService:Create(SwBg, ti, { BackgroundColor3 = ACCENT }):Play()
                        TweenService:Create(SwCircle, ti, { Position = UDim2.new(0, 20, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
                        TweenService:Create(TTitle, ti, { TextColor3 = ACCENT }):Play()
                        TweenService:Create(SwStroke, ti, { Color = ACCENT, Transparency = 0.4 }):Play()
                    else
                        TweenService:Create(SwBg, ti, { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }):Play()
                        TweenService:Create(SwCircle, ti, { Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(170, 170, 170) }):Play()
                        TweenService:Create(TTitle, ti, { TextColor3 = TEXT_MAIN }):Play()
                        TweenService:Create(SwStroke, ti, { Color = Color3.fromRGB(70, 70, 70), Transparency = 0 }):Play()
                    end
                    task.spawn(tcb, val)
                end

                function Funcs:Set(val) SetToggle(val) end

                TClick.Activated:Connect(function()
                    CircleClick(TClick, Player:GetMouse().X, Player:GetMouse().Y)
                    SetToggle(not Funcs.Value)
                end)
                SetToggle(tdef)

                if flag then Nexora.Flags[flag] = tdef end
                itemCount += 1
                return Funcs
            end

            function Item:AddSlider(Config)
                local stitle = Config.Title or Config[1] or ""
                local scont  = Config.Content or Config[2] or ""
                local sincr  = Config.Increment or Config[3] or 1
                local smin   = Config.Min or Config[4] or 0
                local smax   = Config.Max or Config[5] or 100
                local sdef   = Config.Default or Config[6] or 50
                local scb    = Config.Callback or Config[7] or function() end
                local flag   = Config.Flag or Config[8]
                local Funcs  = { Value = sdef }

                local SlidFr = New("Frame", {
                    BackgroundColor3 = BG_ITEM2, BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 50), Name = "Slider", Parent = SecContent
                })
                Corner(5, SlidFr)

                New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = stitle,
                    TextColor3 = TEXT_MAIN, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 8),
                    Size = UDim2.new(0.6, 0, 0, 14), Name = "STitle"
                }, SlidFr)

                local ValBox = New("Frame", {
                    BackgroundColor3 = ACCENT, BackgroundTransparency = 0, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 6),
                    Size = UDim2.new(0, 36, 0, 18), Name = "ValBox"
                }, SlidFr)
                Corner(4, ValBox)

                local ValTB = New("TextBox", {
                    Font = Enum.Font.GothamBold, Text = tostring(sdef),
                    TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 11,
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0), Name = "ValTB"
                }, ValBox)

                local Track = New("Frame", {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50), BackgroundTransparency = 0, BorderSizePixel = 0,
                    Position = UDim2.new(0, 10, 0, 34),
                    Size = UDim2.new(1, -20, 0, 4), Name = "Track"
                }, SlidFr)
                Corner(2, Track)

                local Fill = New("Frame", {
                    BackgroundColor3 = ACCENT, BackgroundTransparency = 0, BorderSizePixel = 0,
                    Size = UDim2.new(math.clamp((sdef - smin) / (smax - smin), 0, 1), 0, 1, 0), Name = "Fill"
                }, Track)
                Corner(2, Fill)

                local Knob = New("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(math.clamp((sdef - smin) / (smax - smin), 0, 1), 0, 0.5, 0),
                    Size = UDim2.new(0, 10, 0, 10), Name = "Knob"
                }, Track)
                Corner(5, Knob)
                Stroke(ACCENT, 1.5, 0, Knob)

                local function Round(n, f) return math.floor(n / f + 0.5) * f end

                local dragging = false
                local function SetSlider(val)
                    val = math.clamp(Round(val, sincr), smin, smax)
                    Funcs.Value = val
                    if flag then Nexora.Flags[flag] = val end
                    local sc = (val - smin) / (smax - smin)
                    Tween(Fill, { Size = UDim2.new(sc, 0, 1, 0) }, 0.08)
                    Tween(Knob, { Position = UDim2.new(sc, 0, 0.5, 0) }, 0.08)
                    ValTB.Text = tostring(val)
                    task.spawn(scb, val)
                end

                function Funcs:Set(val) SetSlider(val) end

                Track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local sc = math.clamp((inp.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        SetSlider(smin + (smax - smin) * sc)
                    end
                end)
                Track.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging then
                        local sc = math.clamp((inp.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        SetSlider(smin + (smax - smin) * sc)
                    end
                end)

                ValTB:GetPropertyChangedSignal("Text"):Connect(function()
                    ValTB.Text = ValTB.Text:gsub("[^%d%-]", "")
                end)
                ValTB.FocusLost:Connect(function()
                    local v = tonumber(ValTB.Text)
                    if v then SetSlider(v) else ValTB.Text = tostring(Funcs.Value) end
                end)

                SetSlider(sdef)
                if flag then Nexora.Flags[flag] = sdef end
                itemCount += 1
                return Funcs
            end

            function Item:AddInput(Config)
                local ititle = Config.Title or Config[1] or ""
                local icont  = Config.Content or Config[2] or ""
                local idef   = Config.Default or Config[3] or ""
                local iph    = Config.Placeholder or "Type here..."
                local icb    = Config.Callback or Config[4] or function() end
                local flag   = Config.Flag or Config[5]
                local Funcs  = { Value = idef }

                local InpFr = New("Frame", {
                    BackgroundColor3 = BG_ITEM2, BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 36), Name = "Input", Parent = SecContent
                })
                Corner(5, InpFr)

                New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = ititle,
                    TextColor3 = TEXT_MAIN, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(0.38, 0, 0, 14), Name = "ITitle"
                }, InpFr)

                local InpBox = New("Frame", {
                    BackgroundColor3 = BG_DARK, BackgroundTransparency = 0, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 160, 0, 24), Name = "InpBox"
                }, InpFr)
                Corner(4, InpBox)
                local IStroke = Stroke(Color3.fromRGB(48, 48, 48), 1, 0, InpBox)

                local TB = New("TextBox", {
                    Font = Enum.Font.Gotham, Text = idef,
                    PlaceholderText = iph, PlaceholderColor3 = Color3.fromRGB(80, 80, 80),
                    TextColor3 = TEXT_MAIN, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 6, 0.5, 0),
                    Size = UDim2.new(1, -12, 1, -4), Name = "TB"
                }, InpBox)

                TB.Focused:Connect(function() Tween(IStroke, { Color = ACCENT }, 0.15) end)
                TB.FocusLost:Connect(function()
                    Tween(IStroke, { Color = Color3.fromRGB(48, 48, 48) }, 0.15)
                    Funcs.Value = TB.Text
                    if flag then Nexora.Flags[flag] = TB.Text end
                    task.spawn(icb, TB.Text)
                end)

                function Funcs:Set(val)
                    TB.Text = tostring(val)
                    Funcs.Value = tostring(val)
                    if flag then Nexora.Flags[flag] = tostring(val) end
                    task.spawn(icb, tostring(val))
                end

                if flag then Nexora.Flags[flag] = idef end
                itemCount += 1
                return Funcs
            end

            function Item:AddDropdown(Config)
                local dtitle   = Config.Title or Config[1] or ""
                local dcont    = Config.Content or Config[2] or ""
                local dmulti   = Config.Multi or Config[3] or false
                local doptions = Config.Options or Config[4] or {}
                local ddef     = Config.Default or Config[5] or {}
                local dcb      = Config.Callback or Config[6] or function() end
                local flag     = Config.Flag or Config[7]
                if type(ddef) ~= "table" then ddef = { ddef } end
                local Funcs = { Value = ddef, Options = doptions }

                local DDFr = New("Frame", {
                    BackgroundColor3 = BG_ITEM2, BackgroundTransparency = 0, BorderSizePixel = 0,
                    LayoutOrder = itemCount,
                    Size = UDim2.new(1, 0, 0, 36), Name = "Dropdown", Parent = SecContent
                })
                Corner(5, DDFr)

                New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = dtitle,
                    TextColor3 = TEXT_MAIN, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(0.35, 0, 0, 14), Name = "DDTitle"
                }, DDFr)

                local DDBox = New("Frame", {
                    BackgroundColor3 = BG_DARK, BackgroundTransparency = 0, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 160, 0, 24), ClipsDescendants = false, Name = "DDBox"
                }, DDFr)
                Corner(4, DDBox)
                local DDStroke = Stroke(Color3.fromRGB(48, 48, 48), 1, 0, DDBox)

                local DDText = New("TextLabel", {
                    Font = Enum.Font.Gotham, Text = "Select...",
                    TextColor3 = Color3.fromRGB(90, 90, 90), TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0), Name = "DDText"
                }, DDBox)

                local DDArrow = New("TextLabel", {
                    Font = Enum.Font.GothamBold, Text = "▾",
                    TextColor3 = TEXT_DIM, TextSize = 11,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -4, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14), Name = "DDArrow"
                }, DDBox)

                local DDBtn = New("TextButton", {
                    Text = "", BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0), ZIndex = 4
                }, DDBox)

                local SearchBar = New("Frame", {
                    BackgroundColor3 = BG_DARK, BackgroundTransparency = 0, BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 22), ZIndex = 5, Name = "SearchBar"
                }, DDBox)
                Corner(3, SearchBar)

                local SearchTB = New("TextBox", {
                    Font = Enum.Font.Gotham, Text = "",
                    PlaceholderText = "Search...", PlaceholderColor3 = Color3.fromRGB(80, 80, 80),
                    TextColor3 = TEXT_MAIN, TextSize = 10,
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 5, 0.5, 0),
                    Size = UDim2.new(1, -10, 1, -4),
                    ZIndex = 6, Name = "SearchTB"
                }, SearchBar)

                local DDPopup = New("Frame", {
                    BackgroundColor3 = BG_DARK, BackgroundTransparency = 0, BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, 2),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true, Visible = false,
                    ZIndex = 10, Name = "DDPopup"
                }, DDBox)
                Corner(5, DDPopup)
                Stroke(Color3.fromRGB(48, 48, 48), 1, 0, DDPopup)

                local DDList = New("ScrollingFrame", {
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, -24),
                    Position = UDim2.new(0, 0, 0, 24),
                    ScrollBarThickness = 2, ScrollBarImageColor3 = ACCENT,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ZIndex = 10, Name = "DDList"
                }, DDPopup)
                New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, DDList)
                New("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) }, DDList)

                local DDSearchFr = New("Frame", {
                    BackgroundColor3 = BG_ITEM, BackgroundTransparency = 0, BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 22),
                    ZIndex = 10, Name = "DDSearchHolder"
                }, DDPopup)
                Corner(4, DDSearchFr)
                New("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) }, DDSearchFr)
                local SearchTB2 = New("TextBox", {
                    Font = Enum.Font.Gotham, Text = "",
                    PlaceholderText = "Search...", PlaceholderColor3 = Color3.fromRGB(80, 80, 80),
                    TextColor3 = TEXT_MAIN, TextSize = 10,
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 4, 0.5, 0),
                    Size = UDim2.new(1, -8, 1, -4),
                    ZIndex = 11, Name = "SearchTB2"
                }, DDSearchFr)

                SearchTB2:GetPropertyChangedSignal("Text"):Connect(function()
                    local q = string.lower(SearchTB2.Text)
                    for _, opt in pairs(DDList:GetChildren()) do
                        if opt:IsA("Frame") and opt.Name == "DDOpt" then
                            local tl = opt:FindFirstChild("DDOptText")
                            opt.Visible = tl and (string.find(string.lower(tl.Text), q, 1, true) ~= nil)
                        end
                    end
                end)

                local isOpen = false

                local function UpdateDDCanvas()
                    local total = 4
                    for _, ch in pairs(DDList:GetChildren()) do
                        if ch:IsA("GuiObject") and ch.Name == "DDOpt" and ch.Visible then
                            total = total + ch.Size.Y.Offset + 2
                        end
                    end
                    DDList.CanvasSize = UDim2.new(0, 0, 0, total)
                end

                local function UpdateDDText()
                    if #Funcs.Value == 0 then
                        DDText.Text = "Select..."
                        DDText.TextColor3 = Color3.fromRGB(90, 90, 90)
                    else
                        DDText.Text = table.concat(Funcs.Value, ", ")
                        DDText.TextColor3 = TEXT_MAIN
                    end
                end

                local function RefreshVisuals()
                    for _, opt in pairs(DDList:GetChildren()) do
                        if opt:IsA("Frame") and opt.Name == "DDOpt" then
                            local tl = opt:FindFirstChild("DDOptText")
                            if tl then
                                local sel = table.find(Funcs.Value, tl.Text)
                                Tween(opt, { BackgroundColor3 = sel and ACCENT or BG_ITEM2, BackgroundTransparency = sel and 0 or 0 }, 0.12)
                                Tween(tl, { TextColor3 = sel and Color3.fromRGB(255, 255, 255) or TEXT_MAIN }, 0.12)
                            end
                        end
                    end
                end

                local optCount = 0
                local function AddOptionInternal(optName)
                    local Opt = New("Frame", {
                        BackgroundColor3 = BG_ITEM2, BackgroundTransparency = 0, BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 22),
                        LayoutOrder = optCount, ZIndex = 10, Name = "DDOpt"
                    }, DDList)
                    Corner(3, Opt)
                    local OText = New("TextLabel", {
                        Font = Enum.Font.Gotham, Text = optName,
                        TextColor3 = TEXT_MAIN, TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 6, 0, 0),
                        Size = UDim2.new(1, -6, 1, 0),
                        ZIndex = 10, Name = "DDOptText"
                    }, Opt)
                    local OBtn = New("TextButton", {
                        Text = "", BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0), ZIndex = 11
                    }, Opt)
                    OBtn.Activated:Connect(function()
                        if dmulti then
                            local idx = table.find(Funcs.Value, optName)
                            if idx then table.remove(Funcs.Value, idx) else table.insert(Funcs.Value, optName) end
                        else
                            Funcs.Value = { optName }
                            isOpen = false
                            Tween(DDPopup, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                            task.wait(0.22); DDPopup.Visible = false
                            Tween(DDStroke, { Color = Color3.fromRGB(48, 48, 48) }, 0.15)
                            DDArrow.Text = "▾"
                        end
                        RefreshVisuals(); UpdateDDText()
                        if flag then Nexora.Flags[flag] = Funcs.Value end
                        task.spawn(dcb, Funcs.Value)
                    end)
                    optCount += 1
                    UpdateDDCanvas()
                end

                local function OpenDD()
                    isOpen = true
                    SearchTB2.Text = ""
                    for _, opt in pairs(DDList:GetChildren()) do
                        if opt:IsA("Frame") and opt.Name == "DDOpt" then opt.Visible = true end
                    end
                    UpdateDDCanvas()
                    DDPopup.Visible = true
                    local popH = math.min(optCount * 24 + 36, 140)
                    Tween(DDPopup, { Size = UDim2.new(1, 0, 0, popH) }, 0.2)
                    Tween(DDStroke, { Color = ACCENT }, 0.15)
                    DDArrow.Text = "▴"
                end

                local function CloseDD()
                    isOpen = false
                    Tween(DDPopup, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                    task.wait(0.22); if not isOpen then DDPopup.Visible = false end
                    Tween(DDStroke, { Color = Color3.fromRGB(48, 48, 48) }, 0.15)
                    DDArrow.Text = "▾"
                end

                DDBtn.Activated:Connect(function()
                    if isOpen then CloseDD() else OpenDD() end
                end)

                function Funcs:Set(val)
                    Funcs.Value = type(val) == "table" and val or { val }
                    RefreshVisuals(); UpdateDDText()
                    if flag then Nexora.Flags[flag] = Funcs.Value end
                    task.spawn(dcb, Funcs.Value)
                end

                function Funcs:Clear()
                    Funcs.Value = {}
                    Funcs.Options = {}
                    for _, ch in pairs(DDList:GetChildren()) do
                        if ch.Name == "DDOpt" then ch:Destroy() end
                    end
                    optCount = 0
                    UpdateDDText(); UpdateDDCanvas()
                end

                function Funcs:AddOption(name)
                    table.insert(Funcs.Options, name)
                    AddOptionInternal(name)
                end

                function Funcs:Refresh(newOpts, selecting)
                    Funcs:Clear()
                    Funcs.Options = newOpts or {}
                    for _, o in ipairs(Funcs.Options) do AddOptionInternal(o) end
                    Funcs:Set(selecting or {})
                end

                for _, o in ipairs(doptions) do AddOptionInternal(o) end
                Funcs:Set(ddef); UpdateDDText()
                if flag then Nexora.Flags[flag] = ddef end
                itemCount += 1
                return Funcs
            end

            return Item
        end

        return Sections
    end

    Tabs.Notify = function(_, Config) Nexora:Notify(Config) end
    Tabs.StatusBar = StatusBarFrame
    Tabs.SetStatusBarVisible = function(_, visible)
        StatusBarFrame.Visible = visible
    end
    Tabs.SetMenuKey = function(_, key)
        currentKey = key
    end
    Tabs.Destroy = function()
        screenGui:Destroy()
        statusGui:Destroy()
        Nexora.Unloaded = true
    end

    return Tabs
end

Nexora.SetNotification = Nexora.Notify

return Nexora
