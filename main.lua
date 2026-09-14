--==================================================
-- FLUENT HUB - COMBINED
--==================================================

local Fluent = loadstring(game:HttpGet(
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
))()

local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"
))()

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer

--==================================================
-- WINDOW
--==================================================

local Window = Fluent:CreateWindow({
    Title = "Fluent Hub",
    SubTitle = "Combined",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({
        Title = "Main"
    }),

    BossSell = Window:AddTab({
        Title = "Boss/sell"
    }),

    TP = Window:AddTab({
        Title = "TP"
    }),

    Settings = Window:AddTab({
        Title = "Settings",
        Icon = "settings"
    })
}

--==================================================
-- VARIABLES
--==================================================

_G.AutoBuyBait = false
_G.AutoTicketQuest = false

_G.AutoBoss = false
_G.AutoRhythmHit = false
_G.AutoEnzo = false

getgenv().Honey_AutoSell = false
getgenv().Honey_SellDelay = 5

getgenv().Honey_Anchor = false

-- 0 = ซ้าย
-- 0.5 = กลาง
-- 1 = ขวา
getgenv().Honey_AnchorPosition = 0.5

getgenv().Honey_AutoCast = false
getgenv().Honey_AutoSkill = false

getgenv().Honey_Skills = {
    Z = true,
    X = true,
    C = true,
    V = true
}

--==================================================
-- MAIN
--==================================================

Tabs.Main:AddParagraph({
    Title = "Main",
    Content = "ระบบหลักและระบบตกปลา"
})

-- Auto Buy Bait
Tabs.Main:AddToggle("Main_AutoBuyBait", {
    Title = "Auto Buy Ancestral Bait",
    Default = false,

    Callback = function(Value)
        _G.AutoBuyBait = Value
    end
})

-- Auto Ticket Quest
Tabs.Main:AddToggle("Main_AutoTicketQuest", {
    Title = "Auto Ticket Quest",
    Default = false,

    Callback = function(Value)
        _G.AutoTicketQuest = Value
    end
})

--==================================================
-- FISHING
--==================================================

Tabs.Main:AddParagraph({
    Title = "Fishing",
    Content = "ระบบตกปลา"
})

-- ล็อกปลา
Tabs.Main:AddToggle("Main_Honey_Anchor", {
    Title = "ล็อกปลา",
    Description = "เปิดเพื่อให้ปลาอยู่ตามตำแหน่งที่กำหนด",

    Default = false,

    Callback = function(Value)
        getgenv().Honey_Anchor = Value
    end
})

-- Slider ตำแหน่งปลา
Tabs.Main:AddSlider("Main_Honey_AnchorPosition", {

    Title = "ตำแหน่งล็อกปลา",

    Description = "0 = ซ้าย | 0.5 = กลาง | 1 = ขวา",

    Default = 0.5,

    Min = 0,
    Max = 1,

    Rounding = 2,

    Callback = function(Value)
        getgenv().Honey_AnchorPosition = Value
    end
})

-- Auto Cast
Tabs.Main:AddToggle("Main_Honey_AutoCast", {
    Title = "เหวี่ยงเบ็ดอัตโนมัติ",

    Default = false,

    Callback = function(Value)
        getgenv().Honey_AutoCast = Value
    end
})

-- Auto Skill
Tabs.Main:AddToggle("Main_Honey_AutoSkill", {
    Title = "ออโต้สกิล",

    Default = false,

    Callback = function(Value)
        getgenv().Honey_AutoSkill = Value
    end
})

-- เลือก Skill
Tabs.Main:AddDropdown("Main_Honey_SkillPick", {

    Title = "เลือกสกิลที่จะกด",

    Values = {
        "Z",
        "X",
        "C",
        "V"
    },

    Multi = true,

    Default = {
        "Z",
        "X",
        "C",
        "V"
    },

    Callback = function(Value)

        getgenv().Honey_Skills = {
            Z = false,
            X = false,
            C = false,
            V = false
        }

        for Skill, Enabled in pairs(Value) do

            if getgenv().Honey_Skills[Skill] ~= nil then
                getgenv().Honey_Skills[Skill] = Enabled
            end

        end

    end
})

--==================================================
-- BOSS / SELL
--==================================================

Tabs.BossSell:AddParagraph({
    Title = "Boss / Sell",
    Content = "ระบบบอสและขายปลา"
})

-- Auto Enzo
Tabs.BossSell:AddToggle("BossSell_AutoEnzo", {
    Title = "Auto Enzo",

    Default = false,

    Callback = function(Value)
        _G.AutoEnzo = Value
    end
})

-- Auto Squid
Tabs.BossSell:AddToggle("BossSell_AutoRhythmHit", {
    Title = "Auto ปลาหมึกยัก",

    Default = false,

    Callback = function(Value)
        _G.AutoRhythmHit = Value
    end
})

-- Auto Sell
Tabs.BossSell:AddToggle("BossSell_AutoSell", {
    Title = "Auto Sell Fish",

    Default = false,

    Callback = function(Value)
        getgenv().Honey_AutoSell = Value
    end
})

-- Sell Delay
Tabs.BossSell:AddSlider("BossSell_SellDelay", {

    Title = "Sell Delay",

    Description = "เวลาหน่วงก่อนขายปลา",

    Default = 5,

    Min = 0.5,
    Max = 30,

    Rounding = 1,

    Callback = function(Value)
        getgenv().Honey_SellDelay = Value
    end
})

--==================================================
-- TP
--==================================================

Tabs.TP:AddParagraph({
    Title = "Teleport",
    Content = "กดแล้ววาปทันที"
})

-- Power 1
Tabs.TP:AddButton({
    Title = "Teleport Power 1",

    Callback = function()

        local Character = Player.Character

        if Character
            and Character:FindFirstChild("HumanoidRootPart") then

            Character.HumanoidRootPart.CFrame =
                CFrame.new(-214, 7, 39)

        end

    end
})

-- Power 19
Tabs.TP:AddButton({
    Title = "Teleport Power 19",

    Callback = function()

        local Character = Player.Character

        if Character
            and Character:FindFirstChild("HumanoidRootPart") then

            Character.HumanoidRootPart.CFrame =
                CFrame.new(-1220, 7, -13)

        end

    end
})

-- Power 32
Tabs.TP:AddButton({
    Title = "Teleport Power 32",

    Callback = function()

        local Character = Player.Character

        if Character
            and Character:FindFirstChild("HumanoidRootPart") then

            Character.HumanoidRootPart.CFrame =
                CFrame.new(73, 7, 1173)

        end

    end
})

--==================================================
-- AUTO CAST
--==================================================

task.spawn(function()

    while task.wait(1) do

        if getgenv().Honey_AutoCast then

            pcall(function()

                local Character = Player.Character
                local PlayerGui =
                    Player:FindFirstChild("PlayerGui")

                if not PlayerGui then
                    return
                end

                local MainGui =
                    PlayerGui:FindFirstChild("MainGui")

                if not MainGui then
                    return
                end

                local Fishing =
                    MainGui:FindFirstChild("Fishing")

                if not Fishing then
                    return
                end

                if Character
                    and not Character:GetAttribute("Fishing")
                    and not Fishing.Visible then

                    local Events =
                        ReplicatedStorage:FindFirstChild("Events")

                    if Events then

                        local FishingEvent =
                            Events:FindFirstChild("Fishing")

                        if FishingEvent then
                            FishingEvent:FireServer()
                        end

                    end

                end

            end)

        end

    end

end)

--==================================================
-- AUTO SKILL
--==================================================

task.spawn(function()

    local Skills = {
        Z = Enum.KeyCode.Z,
        X = Enum.KeyCode.X,
        C = Enum.KeyCode.C,
        V = Enum.KeyCode.V
    }

    while task.wait(0.5) do

        if getgenv().Honey_AutoSkill then

            for Skill, Key in pairs(Skills) do

                if getgenv().Honey_Skills[Skill] then

                    pcall(function()

                        VirtualInputManager:SendKeyEvent(
                            true,
                            Key,
                            false,
                            game
                        )

                        task.wait(0.1)

                        VirtualInputManager:SendKeyEvent(
                            false,
                            Key,
                            false,
                            game
                        )

                    end)

                end

            end

        end

    end

end)

--==================================================
-- LOCK FISH
--==================================================

RunService.RenderStepped:Connect(function()

    if not getgenv().Honey_Anchor then
        return
    end

    pcall(function()

        local PlayerGui =
            Player:FindFirstChild("PlayerGui")

        if not PlayerGui then
            return
        end

        local MainGui =
            PlayerGui:FindFirstChild("MainGui")

        if not MainGui then
            return
        end

        local Fishing =
            MainGui:FindFirstChild("Fishing")

        if not Fishing or not Fishing.Visible then
            return
        end

        local BarFrame =
            Fishing:FindFirstChild("BarFrame")

        if not BarFrame then
            return
        end

        local Bar =
            BarFrame:FindFirstChild("Bar")

        if not Bar then
            return
        end

        --========================================
        -- ตำแหน่งจาก Slider
        -- 0   = ซ้าย
        -- 0.5 = กลาง
        -- 1   = ขวา
        --========================================

        Bar.Position = UDim2.new(
            getgenv().Honey_AnchorPosition,
            -Bar.AbsoluteSize.X / 2,
            Bar.Position.Y.Scale,
            0
        )

        -- Remote เดิม
        local FishingEvent =
            ReplicatedStorage:FindFirstChild("Fishing")

        if FishingEvent then
            FishingEvent:FireServer("1")
        end

    end)

end)

--==================================================
-- AUTO SELL
--==================================================

task.spawn(function()

    while task.wait(0.2) do

        if getgenv().Honey_AutoSell then

            task.wait(getgenv().Honey_SellDelay)

            pcall(function()

                -- ใส่ Remote ขายปลาของเกมตรงนี้

            end)

        end

    end

end)

--==================================================
-- AUTO SCROLL
--==================================================

task.spawn(function()

    while task.wait(0.5) do

        pcall(function()

            for _, Tab in pairs(Tabs) do

                local Container =
                    Tab.Container

                if Container then

                    local ScrollFrame

                    if Container:IsA("ScrollingFrame") then
                        ScrollFrame = Container
                    else

                        for _, Object in ipairs(
                            Container:GetDescendants()
                        ) do

                            if Object:IsA("ScrollingFrame") then
                                ScrollFrame = Object
                                break
                            end

                        end

                    end

                    if ScrollFrame then

                        ScrollFrame.ScrollingEnabled = true
                        ScrollFrame.ScrollingDirection =
                            Enum.ScrollingDirection.Y

                        ScrollFrame.ScrollBarThickness = 5

                        local Layout =
                            ScrollFrame:FindFirstChildOfClass(
                                "UIListLayout"
                            )

                        if Layout then

                            ScrollFrame.CanvasSize =
                                UDim2.new(
                                    0,
                                    0,
                                    0,
                                    Layout.AbsoluteContentSize.Y + 30
                                )

                        end

                    end

                end

            end

        end)

    end

end)

--==================================================
-- SETTINGS
--==================================================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentHub")
SaveManager:SetFolder("FluentHub")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

--==================================================
-- START
--==================================================

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent Hub",

    Content = "โหลดระบบเรียบร้อยแล้ว",

    Duration = 5
})

SaveManager:LoadAutoloadConfig()
