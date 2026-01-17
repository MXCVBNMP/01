-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer

-- =====================
-- NOCLIP
-- =====================
local Clip = true
RunService.Stepped:Connect(function()
	if Clip then return end
	local char = plr.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end)

-- =====================
-- TELEPORT TOOL
-- =====================
local function GiveTeleportTool()
	if plr.Backpack:FindFirstChild("Teleport Tool")
	or (plr.Character and plr.Character:FindFirstChild("Teleport Tool")) then
		return
	end

	local tool = Instance.new("Tool")
	tool.Name = "Teleport Tool"
	tool.RequiresHandle = false
	tool.Parent = plr.Backpack

	tool.Activated:Connect(function()
		local char = plr.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local cam = workspace.CurrentCamera
		local pos = UserInputService:GetMouseLocation()
		local ray = cam:ViewportPointToRay(pos.X, pos.Y)
		local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
		if result then
			hrp.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0))
		end
	end)
end

-- =====================
-- SPEED / JUMP
-- =====================
local SpeedEnabled = false
local JumpEnabled  = false

local SpeedValue = 16
local JumpValue  = 50

local DEFAULT_SPEED = 16
local DEFAULT_JUMP  = 50

local MAX_SPEED = 150
local MAX_JUMP  = 250

local function applyMovement()
	local char = plr.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	hum.WalkSpeed = SpeedEnabled and SpeedValue or DEFAULT_SPEED
	hum.JumpPower = JumpEnabled and JumpValue or DEFAULT_JUMP
end

plr.CharacterAdded:Connect(function()
	task.wait(0.3)
	applyMovement()
end)

-- =====================
-- ESP (MANUAL)
-- =====================
local ESP_ENABLED = false
local ESP_CACHE = {}

local function clearESP()
	for _, pack in pairs(ESP_CACHE) do
		if pack.highlight then pack.highlight:Destroy() end
		if pack.billboard then pack.billboard:Destroy() end
	end
	table.clear(ESP_CACHE)
end

local function addESP(player)
	if player == plr then return end
	if not player.Character then return end
	if ESP_CACHE[player] then return end

	local char = player.Character
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local hl = Instance.new("Highlight")
	hl.Adornee = char
	hl.FillColor = Color3.fromRGB(255,0,0)
	hl.FillTransparency = 0.6
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char

	local bill = Instance.new("BillboardGui")
	bill.Adornee = hrp
	bill.Size = UDim2.new(0,120,0,30)
	bill.StudsOffset = Vector3.new(0,3,0)
	bill.AlwaysOnTop = true
	bill.Parent = char

	local txt = Instance.new("TextLabel", bill)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = player.Name
	txt.TextColor3 = Color3.fromRGB(255,60,60)
	txt.TextStrokeTransparency = 0
	txt.TextScaled = true
	txt.Font = Enum.Font.SourceSansBold

	ESP_CACHE[player] = {highlight = hl, billboard = bill}
end

local function updateESP()
	clearESP()
	if not ESP_ENABLED then return end
	for _, p in ipairs(Players:GetPlayers()) do
		addESP(p)
	end
end

-- =====================
-- GUI
-- =====================
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = plr.PlayerGui

-- Toggle Button
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0,46,0,46)
toggleBtn.Position = UDim2.new(0,15,0.6,0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://93953871104478"
toggleBtn.Active = true
toggleBtn.Draggable = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- Main Frame (Scrolling)
local frame = Instance.new("ScrollingFrame", gui)
frame.Size = UDim2.new(0,230,0,260)
frame.Position = UDim2.new(0.5,-115,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Visible = false
frame.ScrollBarThickness = 5
frame.CanvasSize = UDim2.new(0,0,0,0)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Text = " by Faust  ไม่รู้ "
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.BorderSizePixel = 0
title.Active = true

-- =====================
-- DRAG UI BY TITLE ONLY
-- =====================
do
	local dragging = false
	local dragStart
	local startPos

	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	title.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end

		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end)
end

-- =====================
-- BUTTONS / SLIDERS
-- =====================
local function makeButton(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-20,0,32)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 14
	Instance.new("UICorner", b)
	return b
end

local tpBtn     = makeButton("Get Teleport Tool", 40)
local noclipBtn = makeButton("Noclip : OFF", 80)
local espBtn    = makeButton("ESP : OFF", 120)
local speedBtn  = makeButton("Speed : OFF", 160)
local jumpBtn   = makeButton("Jump : OFF", 200)

local function createSlider(text, y, min, max, default, onChange)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1,-20,0,18)
	label.Position = UDim2.new(0,10,0,y)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 13
	label.Text = text..": "..default

	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(1,-20,0,8)
	bar.Position = UDim2.new(0,10,0,y+22)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(120,120,255)
	Instance.new("UICorner", fill)

	local dragging = false

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if not dragging then return end
		if i.UserInputType ~= Enum.UserInputType.MouseMovement
		and i.UserInputType ~= Enum.UserInputType.Touch then return end

		local pos = math.clamp(
			(i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
			0,1
		)

		fill.Size = UDim2.new(pos,0,1,0)
		local value = math.floor(min + (max-min)*pos)
		label.Text = text..": "..value
		onChange(value)
	end)
end

createSlider("Speed", 245, 16, MAX_SPEED, SpeedValue, function(v)
	SpeedValue = v
	if SpeedEnabled then applyMovement() end
end)

createSlider("Jump", 305, 50, MAX_JUMP, JumpValue, function(v)
	JumpValue = v
	if JumpEnabled then applyMovement() end
end)

-- Update Canvas Size
local function updateCanvas()
	local maxY = 0
	for _, v in ipairs(frame:GetChildren()) do
		if v:IsA("GuiObject") then
			maxY = math.max(maxY, v.Position.Y.Offset + v.Size.Y.Offset)
		end
	end
	frame.CanvasSize = UDim2.new(0,0,0,maxY + 10)
end
updateCanvas()

-- =====================
-- EVENTS
-- =====================
toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

tpBtn.MouseButton1Click:Connect(GiveTeleportTool)

noclipBtn.MouseButton1Click:Connect(function()
	Clip = not Clip
	noclipBtn.Text = Clip and "Noclip : OFF" or "Noclip : ON"
end)

espBtn.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	espBtn.Text = ESP_ENABLED and "ESP : ON" or "ESP : OFF"
	updateESP()
end)

speedBtn.MouseButton1Click:Connect(function()
	SpeedEnabled = not SpeedEnabled
	speedBtn.Text = SpeedEnabled and "Speed : ON" or "Speed : OFF"
	applyMovement()
end)

jumpBtn.MouseButton1Click:Connect(function()
	JumpEnabled = not JumpEnabled
	jumpBtn.Text = JumpEnabled and "Jump : ON" or "Jump : OFF"
	applyMovement()
end)
