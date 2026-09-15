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
    TabWidth = 130,
    Size = UDim2.fromOffset(430, 350),
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

getgenv().Honey_AutoSell = false
getgenv().Honey_SellDelay = 5

getgenv().Honey_Anchor = false
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

Tabs.Main:AddToggle("Main_Honey_Anchor", {
    Title = "ล็อกปลา",
    Description = "ล็อกตำแหน่งปลา",
    Default = false,

    Callback = function(Value)
        getgenv().Honey_Anchor = Value
    end
})

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

Tabs.Main:AddToggle("Main_Honey_AutoCast", {
    Title = "เหวี่ยงเบ็ดอัตโนมัติ",
    Default = false,

    Callback = function(Value)
        getgenv().Honey_AutoCast = Value
    end
})

Tabs.Main:AddToggle("Main_Honey_AutoSkill", {
    Title = "ออโต้สกิล",
    Default = false,

    Callback = function(Value)
        getgenv().Honey_AutoSkill = Value
    end
})

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

Tabs.Main:AddToggle("Main_AutoBuyBait", {
    Title = "Auto Buy Ancestral Bait",
    Default = false,

    Callback = function(Value)
        _G.AutoBuyBait = Value
    end
})

Tabs.Main:AddToggle("Main_AutoTicketQuest", {
    Title = "Auto Ticket Quest",
    Default = false,

    Callback = function(Value)
        _G.AutoTicketQuest = Value
    end
})

--==================================================
-- BOSS / SELL
--==================================================

Tabs.BossSell:AddToggle("BossSell_AutoEnzo", {
    Title = "Auto Enzo",
    Default = false
}):OnChanged(function(v)
    _G.AutoBoss = v
end)

Tabs.BossSell:AddToggle("BossSell_AutoRhythmHit", {
    Title = "Auto ปลาหมึกยัก",
    Default = false
}):OnChanged(function(v)
    _G.AutoRhythmHit = v
end)

Tabs.BossSell:AddToggle("BossSell_AutoSell", {
    Title = "Auto Sell Fish",
    Default = false,

    Callback = function(Value)
        getgenv().Honey_AutoSell = Value
    end
})

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
-- AUTO BUY BAIT
--==================================================

task.spawn(function()
    local Event = game:GetService("ReplicatedStorage").Events.BuyBait

    while task.wait(20) do
        if _G.AutoBuyBait then
            pcall(function()
                Event:FireServer(
                    "Ancestral Bait",
                    100
                )
            end)
        end
    end
end)

--==================================================
-- AUTO TICKET QUEST
--==================================================

task.spawn(function()

    local Event =
        ReplicatedStorage
        :WaitForChild("Events")
        :WaitForChild("ChooseDialogueOption")

    local NPC =
        workspace
        :WaitForChild("NPC")
        :WaitForChild("Function")
        :WaitForChild("Ticket Quest Giver")

    while task.wait(20) do

        if _G.AutoTicketQuest then

            pcall(function()

                Event:FireServer(
                    "Ticket Quest Giver",
                    1,
                    "Quest",
                    {NPC}
                )

                Event:FireServer(
                    "Ticket Quest Giver",
                    2,
                    "HardAcceptQuest",
                    {NPC, "Ticket Quest"}
                )

                Event:FireServer(
                    "Ticket Quest Giver",
                    1,
                    "Quest",
                    {NPC}
                )

                Event:FireServer(
                    "Ticket Quest Giver",
                    2,
                    "SBF",
                    {NPC}
                )

            end)
        end
    end
end)

--==================================================
-- AUTO ENZO
--==================================================

task.spawn(function()

    local Event =
        game:GetService("ReplicatedStorage")
        .Events
        .BossPhase2Action

    while task.wait() do

        if _G.AutoBoss then

            for i = 1,10000000 do

                if not _G.AutoBoss then
                    break
                end

                Event:FireServer({
                    Index = i,
                    Hit = true
                })

                task.wait(0.5)
            end
        end
    end
end)

--==================================================
-- AUTO ปลาหมึกยัก
--==================================================

task.spawn(function()

    local Event =
        game:GetService("ReplicatedStorage")
        .Events
        .RhythmHit

    while task.wait(0.3) do

        if _G.AutoRhythmHit then

            Event:FireServer("hit")

        end
    end
end)

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

    while task.wait(0.1) do

        if not getgenv().Honey_AutoSkill then
            continue
        end

        if not Player.Character then
            continue
        end

        for Skill, Key in pairs(Skills) do

            if not getgenv().Honey_AutoSkill then
                break
            end

            if getgenv().Honey_Skills[Skill] then

                pcall(function()

                    VirtualInputManager:SendKeyEvent(
                        true,
                        Key,
                        false,
                        game
                    )

                    task.wait(0.15)

                    VirtualInputManager:SendKeyEvent(
                        false,
                        Key,
                        false,
                        game
                    )

                end)

                task.wait(0.25)
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

        if not Fishing
            or not Fishing.Visible then

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

        Bar.Position = UDim2.new(
            getgenv().Honey_AnchorPosition,
            -Bar.AbsoluteSize.X / 2,
            Bar.Position.Y.Scale,
            0
        )

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
    local Event = game:GetService("ReplicatedStorage").Events.SellFish

    while task.wait(0.2) do
        if getgenv().Honey_AutoSell then
            task.wait(getgenv().Honey_SellDelay)

            pcall(function()
                Event:FireServer("All")
            end)
        end
    end
end)

---==================================================
-- TP
--==================================================

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

Tabs.TP:AddButton({
Title = "Teleport Power 39",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(-1253, 7, 1241)  

    end  
end

})

Tabs.TP:AddButton({
Title = "Teleport Power 48",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(40, 9, -1339)  

    end  
end

})

Tabs.TP:AddButton({
Title = "Teleport Power 55",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(-1429, 9, -1482)  

    end  
end

})
Tabs.TP:AddButton({
Title = "Teleport Power 65",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(1435, 9, -1457)  

    end  
end

})

Tabs.TP:AddButton({
Title = "Teleport Power 75",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(1263, 7, 1390)  

    end  
end

})

Tabs.TP:AddButton({
Title = "Teleport Power 90",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(1291, 20, 37)  

    end  
end

})
Tabs.TP:AddButton({
Title = "Teleport Power 100",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(2634, 7, -55)  

    end  
end

})

Tabs.TP:AddButton({
Title = "Teleport PVP",

Callback = function()  

    local Character = Player.Character  

    if Character  
        and Character:FindFirstChild("HumanoidRootPart") then  

        Character.HumanoidRootPart.CFrame =  
            CFrame.new(-2429, 8, -209)  

    end  
end

})

--==================================================
-- COLOR + RGB + SETTINGS
--==================================================

local RunService = game:GetService("RunService")

--==================================================
-- COLOR PRESETS
--==================================================

local ColorPresets = {
    Red = Color3.fromRGB(255, 70, 70),
    Cyan = Color3.fromRGB(60, 200, 255),
    Purple = Color3.fromRGB(170, 90, 255),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(25, 25, 25),
    Blue = Color3.fromRGB(70, 120, 255),
    Pink = Color3.fromRGB(255, 100, 190),
    Green = Color3.fromRGB(80, 220, 120)
}

local CurrentColor = ColorPresets.Cyan
local RGBEnabled = false
local RGBConnection = nil

--==================================================
-- APPLY COLOR
--==================================================

local function ApplyColor(Color)
    CurrentColor = Color

    pcall(function()
        local GUI = Fluent.GUI
        if not GUI then
            return
        end

        for _, Object in ipairs(GUI:GetDescendants()) do

            if Object:IsA("UIStroke") then
                Object.Color = Color

            elseif Object:IsA("Frame") then

                if Object.Name == "ToggleSlider"
                    or Object.Name == "SliderRail"
                    or Object.Name == "InputIndicator" then

                    Object.BackgroundColor3 = Color
                end

            elseif Object:IsA("TextButton") then

                if Object.Name == "Button"
                    or Object.Name == "Toggle"
                    or Object.Name == "Dropdown" then

                    Object.BackgroundColor3 = Color
                end
            end
        end
    end)
end

--==================================================
-- START RGB
--==================================================

local function StartRGB()

    if RGBConnection then
        RGBConnection:Disconnect()
        RGBConnection = nil
    end

    RGBConnection = RunService.RenderStepped:Connect(function()

        if not RGBEnabled then
            return
        end

        local Hue = (os.clock() % 5) / 5
        local Color = Color3.fromHSV(Hue, 0.9, 1)

        ApplyColor(Color)
    end)
end

--==================================================
-- STOP RGB
--==================================================

local function StopRGB()

    if RGBConnection then
        RGBConnection:Disconnect()
        RGBConnection = nil
    end

    ApplyColor(CurrentColor)
end


--==================================================
-- SETTINGS
--==================================================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentHub")
SaveManager:SetFolder("FluentHub")

--==================================================
-- COLOR + RGB SYSTEM
--==================================================

local RunService = game:GetService("RunService")

local RGBEnabled = false
local RGBConnection = nil
local UIConnection = nil

local ColorPresets = {
    Red = Color3.fromRGB(255, 70, 70),
    Cyan = Color3.fromRGB(60, 200, 255),
    Purple = Color3.fromRGB(170, 90, 255),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(25, 25, 25),
    Blue = Color3.fromRGB(70, 120, 255),
    Pink = Color3.fromRGB(255, 100, 190),
    Green = Color3.fromRGB(80, 220, 120)
}

local CurrentColor = ColorPresets.Cyan
local ColorObjects = {}

--==================================================
-- REGISTER UI
--==================================================

local function RegisterObject(Object)

    if ColorObjects[Object] then
        return
    end

    if Object:IsA("UIStroke")
        or Object:IsA("TextButton")
        or Object:IsA("ImageButton") then

        ColorObjects[Object] = true
    end
end

--==================================================
-- APPLY COLOR
--==================================================

local function ApplyColor(Color)

    CurrentColor = Color

    for Object in pairs(ColorObjects) do

        if not Object or not Object.Parent then
            ColorObjects[Object] = nil
            continue
        end

        pcall(function()

            if Object:IsA("UIStroke") then
                Object.Color = Color

            elseif Object:IsA("TextButton")
                or Object:IsA("ImageButton") then

                if Object.BackgroundTransparency < 1 then
                    Object.BackgroundColor3 = Color
                end
            end

        end)
    end
end

--==================================================
-- WATCH NEW UI
--==================================================

task.spawn(function()

    while task.wait(1) do

        pcall(function()

            local GUI = Fluent.GUI
            if not GUI then
                return
            end

            for _, Object in ipairs(GUI:GetDescendants()) do
                RegisterObject(Object)
            end

        end)

    end

end)

--==================================================
-- RGB
--==================================================

local function StartRGB()

    if RGBConnection then
        RGBConnection:Disconnect()
    end

    RGBConnection = RunService.Heartbeat:Connect(function()

        if not RGBEnabled then
            return
        end

        local Hue = (os.clock() % 5) / 5
        local Color = Color3.fromHSV(Hue, 0.9, 1)

        ApplyColor(Color)

    end)
end

local function StopRGB()

    if RGBConnection then
        RGBConnection:Disconnect()
        RGBConnection = nil
    end

    ApplyColor(CurrentColor)
end

--==================================================
-- SETTINGS
--==================================================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentHub")
SaveManager:SetFolder("FluentHub")

--==================================================
-- COLOR
--==================================================

Tabs.Settings:AddDropdown("UI_Color", {

    Title = "เลือกสี UI",

    Values = {
        "Red",
        "Cyan",
        "Purple",
        "White",
        "Black",
        "Blue",
        "Pink",
        "Green"
    },

    Default = "Cyan",

    Callback = function(Value)

        if not ColorPresets[Value] then
            return
        end

        RGBEnabled = false

        if RGBConnection then
            RGBConnection:Disconnect()
            RGBConnection = nil
        end

        ApplyColor(ColorPresets[Value])

    end
})

--==================================================
-- RGB TOGGLE
--==================================================

Tabs.Settings:AddToggle("UI_RGB", {

    Title = "RGB UI",

    Description = "ให้สี UI วิ่งอัตโนมัติ",

    Default = false,

    Callback = function(Value)

        RGBEnabled = Value

        if Value then
            StartRGB()
        else
            StopRGB()
        end

    end
})

--==================================================
-- FLUENT SETTINGS
--==================================================

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

--==================================================
-- FLUENT SETTINGS
--==================================================

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


--==================================================
-- FLUENT SETTINGS
--==================================================

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
