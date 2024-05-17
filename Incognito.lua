-- Credits to Elegant and Weda, the original script coders

-- If ur gonna put in vault / showcase, pls don't put the source code directly or loadstring, put the discord

-- DO NOT EDIT BELOW IF YOU DON'T KNOW WHAT YOU'RE DOING!!

-- You will experience severe FPS drops if you fill the shapes since i decided to draw each pixel on its own.
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 1
frame.Parent = gui

function drawPixel(x, y, color)
    local pixel = Instance.new("Frame")
    pixel.Size = UDim2.new(0, 1, 0, 1)
    pixel.Position = UDim2.new(0, x, 0, y)
    pixel.BackgroundColor3 = color
    pixel.BorderSizePixel = 0
    pixel.Parent = frame
end

local function drawCircle(properties)
    local center = properties.Position
    local radius = properties.Radius
    local color = properties.Color
    local filled = properties.Filled

    local function plot(xc, yc, x, y)
        drawPixel(xc + x, yc + y, color)
        drawPixel(xc - x, yc + y, color)
        drawPixel(xc + x, yc - y, color)
        drawPixel(xc - x, yc - y, color)
        drawPixel(xc + y, yc + x, color)
        drawPixel(xc - y, yc + x, color)
        drawPixel(xc + y, yc - x, color)
        drawPixel(xc - y, yc - x, color)
    end

    local x = 0
    local y = radius
    local p = 1 - radius

    while x < y do
        if filled then
            for i = x, y do
                plot(center.X, center.Y, x, i)
                plot(center.X, center.Y, i, x)
            end
        else
            plot(center.X, center.Y, x, y)
            plot(center.X, center.Y, y, x)
        end

        x = x + 1
        if p < 0 then
            p = p + 2 * x + 1
        else
            y = y - 1
            p = p + 2 * (x - y) + 1
        end
    end
end

local function drawSquare(properties)
    local center = properties.Position
    local size = properties.Size
    local color = properties.Color
    local filled = properties.Filled

    local halfSize = size / 2
    local topLeft = Vector2.new(center.X - halfSize, center.Y - halfSize)
    local bottomRight = Vector2.new(center.X + halfSize, center.Y + halfSize)

    if filled then
        for x = topLeft.X, bottomRight.X do
            for y = topLeft.Y, bottomRight.Y do
                drawPixel(x, y, color)
            end
        end
    else
        for x = topLeft.X, bottomRight.X do
            drawPixel(x, topLeft.Y, color)
            drawPixel(x, bottomRight.Y, color)
        end
        for y = topLeft.Y, bottomRight.Y do
            drawPixel(topLeft.X, y, color)
            drawPixel(bottomRight.X, y, color)
        end
    end
end

local function drawLine(properties)
    local startPoint = properties.StartPoint
    local endPoint = properties.EndPoint
    local color = properties.Color

    local delta = endPoint - startPoint
    local steps = math.max(math.abs(delta.X), math.abs(delta.Y))

    for i = 0, steps do
        local t = i / steps
        local x = math.floor(startPoint.X + t * delta.X + 0.5)
        local y = math.floor(startPoint.Y + t * delta.Y + 0.5)
        drawPixel(x, y, color)
    end
end

local function drawTriangle(properties)
    local point1 = properties.Point1
    local point2 = properties.Point2
    local point3 = properties.Point3
    local color = properties.Color
    local filled = properties.Filled

    local function fillPoints(p1, p2)
        local delta = p2 - p1
        local steps = math.max(math.abs(delta.X), math.abs(delta.Y))

        for i = 0, steps do
            local t = i / steps
            local x = math.floor(p1.X + t * delta.X + 0.5)
            local y = math.floor(p1.Y + t * delta.Y + 0.5)
            drawPixel(x, y, color)
        end
    end

    fillPoints(point1, point2)
    fillPoints(point2, point3)
    fillPoints(point3, point1)

    if filled then
        local minX = math.min(point1.X, point2.X, point3.X)
        local minY = math.min(point1.Y, point2.Y, point3.Y)
        local maxX = math.max(point1.X, point2.X, point3.X)
        local maxY = math.max(point1.Y, point2.Y, point3.Y)

        for x = minX, maxX do
            for y = minY, maxY do
                local p = Vector2.new(x, y)
                local b1 = ((point2.X - point1.X) * (p.Y - point1.Y) - (point2.Y - point1.Y) * (p.X - point1.X)) < 0
                local b2 = ((point3.X - point2.X) * (p.Y - point2.Y) - (point3.Y - point2.Y) * (p.X - point2.X)) < 0
                local b3 = ((point1.X - point3.X) * (p.Y - point3.Y) - (point1.Y - point3.Y) * (p.X - point3.X)) < 0

                if b1 == b2 and b2 == b3 then
                    drawPixel(x, y, color)
                end
            end
        end
    end
end

local function drawQuad(properties)
    local pointA = properties.PointA
    local pointB = properties.PointB
    local pointC = properties.PointC
    local pointD = properties.PointD
    local color = properties.Color
    local filled = properties.Filled
    local thickness = properties.Thickness

    if filled then
        local minX = math.min(pointA.X, pointB.X, pointC.X, pointD.X)
        local minY = math.min(pointA.Y, pointB.Y, pointC.Y, pointD.Y)
        local maxX = math.max(pointA.X, pointB.X, pointC.X, pointD.X)
        local maxY = math.max(pointA.Y, pointB.Y, pointC.Y, pointD.Y)

        for x = minX, maxX do
            for y = minY, maxY do
                local p = Vector2.new(x, y)
                local b1 = ((pointB.X - pointA.X) * (p.Y - pointA.Y) - (pointB.Y - pointA.Y) * (p.X - pointA.X)) < 0
                local b2 = ((pointC.X - pointB.X) * (p.Y - pointB.Y) - (pointC.Y - pointB.Y) * (p.X - pointB.X)) < 0
                local b3 = ((pointD.X - pointC.X) * (p.Y - pointC.Y) - (pointD.Y - pointC.Y) * (p.X - pointC.X)) < 0
                local b4 = ((pointA.X - pointD.X) * (p.Y - pointD.Y) - (pointA.Y - pointD.Y) * (p.X - pointD.X)) < 0

                if b1 == b2 and b2 == b3 and b3 == b4 then
                    drawPixel(x, y, color)
                end
            end
        end
    else
        drawLine({ StartPoint = pointA, EndPoint = pointB, Color = color })
        drawLine({ StartPoint = pointB, EndPoint = pointC, Color = color })
        drawLine({ StartPoint = pointC, EndPoint = pointD, Color = color })
        drawLine({ StartPoint = pointD, EndPoint = pointA, Color = color })

        if thickness and thickness > 1 then
            local halfThickness = math.floor(thickness / 2)
            for i = 1, halfThickness do
                drawLine({ StartPoint = pointA + Vector2.new(i, i), EndPoint = pointB + Vector2.new(i, i), Color = color })
                drawLine({ StartPoint = pointB + Vector2.new(i, i), EndPoint = pointC + Vector2.new(i, i), Color = color })
                drawLine({ StartPoint = pointC + Vector2.new(i, i), EndPoint = pointD + Vector2.new(i, i), Color = color })
                drawLine({ StartPoint = pointD + Vector2.new(i, i), EndPoint = pointA + Vector2.new(i, i), Color = color })
            end
        end
    end
end

local function drawText(text, position, color, fontSize)
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.Position = UDim2.new(0, position.X, 0, position.Y)
    textLabel.TextSize = fontSize
    textLabel.Parent = frame
end

local Drawing = {}
Drawing.__index = Drawing

function Drawing.new(shape, properties)
    local self = setmetatable({}, Drawing)
    if shape == "circle" then
        drawCircle(properties)
    elseif shape == "square" then
        drawSquare(properties)
    elseif shape == "line" then
        drawLine(properties)
    elseif shape == "triangle" then
        drawTriangle(properties)
    elseif shape == "quad" then
        drawQuad(properties)
    elseif shape == "text" then
        drawText(properties.Text, properties.Position, properties.Color, properties.FontSize)
    end
    return self
end


repeat wait() until game:IsLoaded()

Drawing = Drawing
hookmetamethod = hookmetamethod
newcclosure = newcclosure
getnamecallmethod = getnamecallmethod

-- Variables

local UiLib = loadstring(game:HttpGet("https://pastebin.com/raw/JFzC7iXS"))()

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StarterGui = game:GetService("StarterGui")
local Stats = game:GetService("Stats")

local CamlockPlr
local LocalPlr = Players.LocalPlayer

local CamBindEnabled = false

local AntiCheatNamecall

local StrafeSpeed = 0

local SelfDotCircle = Drawing.new("Circle")
SelfDotCircle.Filled = true
SelfDotCircle.Thickness = 1
SelfDotCircle.Radius = 7

local SelfTracerLine = Drawing.new("Line")
SelfTracerLine.Thickness = 2

local CamFovCircle = Drawing.new("Circle")
CamFovCircle.Thickness = 1.5

local CamTracerLine = Drawing.new("Line")
CamTracerLine.Thickness = 2

local CamHighlight = Instance.new("Highlight", CoreGui)

local CameraAimbot = {
	Enabled = false, 
	Keybind = nil, 

	Prediction = nil, 
	RealPrediction = nil, 

	Resolver = false, 
	ResolverType = "Recalculate", 

	JumpOffset = 0, 
	RealJumpOffset = nil, 

	HitPart = "HumanoidRootPart", 
	RealHitPart = nil, 

	UseAirPart = false, 
	AirPart = "Head", 
	AirCheckType = "Once in Air", 

	AutoPred = false, 
	Notify = false, 

	KoCheck = false, 
	Tracer = false, 

	Highlight = false, 

	Smoothing = false, 
	Smoothness = nil, 

	UseFov = false
}

local BringPLR = {
	Enabled = false, 
	Keybind = nil, 
}

local AntiLock = {
	Enabled = false, 
	Mode = "Up", 

	DesyncVel = Vector3.new(0, 9e9, 0), 
	DesyncAngles = 0.5
}

local SelfDot = {
	Enabled = false, 
	Tracer = false, 

	RandomHitPart = false, 
	Prediction = 1, 

	HitPart = "HumanoidRootPart", 
	RealHitPart = nil
}

local TargetStrafe = {
	Enabled = false, 

	Speed = 1, 
	Distance = 1, 
	Height = 1
}

local Utilities = {
	NoJumpCooldown = false, 
	NoSlowdown = false, 

	AutoStomp = false, 
	AutoReload = false
}

local Movement = {
	SpeedEnabled = false, 
	SpeedAmount = 1, 

	AutoJump = false, 

	BunnyHop = false, 
	HopAmount = 1, 

	FlightEnabled = false, 
	FlightAmount = 1
}

-- Functions

function ClosestPlr(Part, UseFov, FovCircle)
	local Distance, Closest = math.huge, nil

	for I, Target in pairs(Players:GetPlayers()) do
		if Target ~= LocalPlr then
			local Position = Workspace.CurrentCamera:WorldToViewportPoint(Target.Character[Part].Position)
			local Magnitude = (Vector2.new(Position.X, Position.Y) - UserInputService:GetMouseLocation()).Magnitude

			if UseFov then
				if Magnitude < Distance and Magnitude < FovCircle.Radius then
					Closest = Target
					Distance = Magnitude
				end
			else
				if Magnitude < Distance then
					Closest = Target
					Distance = Magnitude
				end
			end
		end
	end

	return Closest
end

-- You've caught me, the resolver is skidded...

function Resolver(Target)
	local Part = Target.Character[CameraAimbot.RealHitPart]

	local CurrentPosition = Part.Position
	local CurrentTime = tick()

	wait()

	local NewPosition = Part.Position
	local NewTime = tick()
	local DistanceTraveled = (NewPosition - CurrentPosition)
	local TimeInterval = NewTime - CurrentTime
	local Velocity = DistanceTraveled / TimeInterval

	CurrentPosition = NewPosition
	CurrentTime = NewTime

	if CameraAimbot.Resolver and CameraAimbot.ResolverType == "MoveDirection" then
		return CamlockPlr.Character.Humanoid.MoveDirection * CamlockPlr.Character.Humanoid.WalkSpeed
	end

	return Velocity
end

-- Window

local Actyrn = UiLib:CreateWindow("detected.lol", Vector2.new(500, 600), Enum.KeyCode.RightShift)

-- Tabs

local MainTab = Actyrn:CreateTab("Main")
local MiscTab = Actyrn:CreateTab("Misc")

-- Sectors

-- MAIN

local CameraAimbotSec = MainTab:CreateSector("Camera Aimbot", "left")
local AntiLockSec = MainTab:CreateSector("Anti Lock", "right")
local SelfDotSec = MainTab:CreateSector("Self Dot", "right")
local TargetStrafeSec = MainTab:CreateSector("Target Strafe", "right")

-- MISC

local UtilitiesSec = MiscTab:CreateSector("Utilities", "left")
local MovementSec = MiscTab:CreateSector("Movement", "right")

-- Toggles

-- MAIN

-- Camera Aimbot

CameraAimbotSec:AddToggle("Enabled", true, function(Value)
	CameraAimbot.Enabled = Value
end, "CameraEnabled")

CameraAimbotSec:AddKeybind("Keybind", Enum.KeyCode.T, function(Value)
	CameraAimbot.Keybind = Value
end, "CameraKeybind")

CameraAimbotSec:AddTextbox("Prediction", 0, function(Value)
	CameraAimbot.Prediction = Value
	CameraAimbot.RealPrediction = Value
end, "CameraPrediction")



local CamResolverTog = CameraAimbotSec:AddToggle("Antilock Resolver", false, function(Value)
	CameraAimbot.Resolver = Value
end, "CameraAntilockResolver")

CamResolverTog:AddKeybind(Enum.KeyCode.B, "CameraAntilockResolverKeybind")

CameraAimbotSec:AddDropdown("Resolver Type", {"Recalculate", "MoveDirection"}, "Recalculate", false, function(Value)
	CameraAimbot.ResolverType = Value
end, "CameraResolverType")

CameraAimbotSec:AddSlider("Jump Offset", -2, 0.2, 2, 100, function(Value)
	CameraAimbot.JumpOffset = Value
	CameraAimbot.RealJumpOffset = Value
end, "CameraJumpOffset")

CameraAimbotSec:AddDropdown("Hit Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, "HumanoidRootPart", false, function(Value)
	CameraAimbot.HitPart = Value
	CameraAimbot.RealHitPart = Value
end, "CameraHitPart")

CameraAimbotSec:AddToggle("Use Air Part", false, function(Value)
	CameraAimbot.UseAirPart = Value
end, "CameraUseAirPart")

CameraAimbotSec:AddDropdown("Air Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightHand", "LeftHand", "RightFoot", "LeftFoot"}, "LowerTorso", false, function(Value)
	CameraAimbot.AirPart = Value
end, "CameraAirPart")

CameraAimbotSec:AddDropdown("Air Check Type", {"Once in Air", "Once Freefalling"}, "Once in Air", false, function(Value)
	CameraAimbot.AirCheckType = Value
end, "CameraAirCheckType")

CameraAimbotSec:AddToggle("Auto Pred", true, function(Value)
	CameraAimbot.AutoPred = Value
end, "CameraAutoPred")

CameraAimbotSec:AddToggle("Notify", true, function(Value)
	CameraAimbot.Notify = Value
end, "CameraNotify")

local function createBoxOutline(player)
	local character = player.Character
	if character then
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		local head = character:FindFirstChild("Head")
		if rootPart and head then
			local boxOutline = Instance.new("SelectionBox")
			boxOutline.Color3 = Color3.new(0.666667, 0.470588, 0.823529) -- Black color
			boxOutline.LineThickness = 0.05 -- Adjust thickness as needed
			boxOutline.Adornee = character
			boxOutline.Archivable = false
			boxOutline.Parent = character
			return boxOutline
		end
	end
end

local function removeBoxOutline(player)
	local character = player.Character
	if character then
		for _, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("SelectionBox") then
				descendant:Destroy()
			end
		end
	end
end

local function createBoxOutlinesForOtherPlayers()
	local localPlayer = game.Players.LocalPlayer
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= localPlayer then
			createBoxOutline(player)
		end
	end
end

local function updateBoxOutlines()
	local localPlayer = game.Players.LocalPlayer
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= localPlayer then
			removeBoxOutline(player)
			if Utilities.BoxESP then
				createBoxOutline(player)
			end
		end
	end
end

local function toggleBoxESP(Value)
	Utilities.BoxESP = Value
	if Value then
		createBoxOutlinesForOtherPlayers()
		updateBoxOutlines()
	else
		for _, player in ipairs(game.Players:GetPlayers()) do
			removeBoxOutline(player)
		end
	end
end

CameraAimbotSec:AddToggle("Box ESP", false, toggleBoxESP, "CameraKOCheck")


local CamTracerTog = CameraAimbotSec:AddToggle("Tracer", true, function(Value)
	CameraAimbot.Tracer = Value
end, "CameraTracer")

CamTracerTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	CamTracerLine.Color = Value
end, "CameraTracerColor")

local CamHighlightTog = CameraAimbotSec:AddToggle("Highlight", true, function(Value)
	CameraAimbot.Highlight = Value
end, "CameraHighlight")

CamHighlightTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	CamHighlight.FillColor = Value
end, "CameraHighlightFillColor")

CamHighlightTog:AddColorpicker(Color3.fromRGB(90, 65, 110), function(Value)
	CamHighlight.OutlineColor = Value
end, "CameraHighlightOutlineColor")

CameraAimbotSec:AddToggle("Smoothing", false, function(Value)
	CameraAimbot.Smoothing = Value
end, "CameraSmoothing")

CameraAimbotSec:AddTextbox("Smoothness", nil, function(Value)
	CameraAimbot.Smoothness = Value
end, "CameraSmoothness")

CameraAimbotSec:AddToggle("Use FOV", false, function(Value)
	CameraAimbot.UseFov = Value
end, "CameraUseFOV")

local CamFovTog = CameraAimbotSec:AddToggle("FOV Visible", false, function(Value)
	CamFovCircle.Visible = Value
end, "CameraFOVVisible")

CamFovTog:AddColorpicker(Color3.fromRGB(80, 15, 180), function(Value)
	CamFovCircle.Color = Value
end, "CameraFOVColor")

CameraAimbotSec:AddToggle("FOV Filled", false, function(Value)
	CamFovCircle.Filled = Value
end, "CameraFOVFilled")

CameraAimbotSec:AddSlider("FOV Transparency", 0, 0.15, 1, 100, function(Value)
	CamFovCircle.Transparency = Value
end, "CameraFOVTransparency")

CameraAimbotSec:AddSlider("FOV Size", 5, 80, 500, 1, function(Value)
	CamFovCircle.Radius = Value * 2
end, "CameraFOVSize")

-- Anti Lock

local AntiLockTog = AntiLockSec:AddToggle("Enabled", false, function(Value)
	AntiLock.Enabled = Value
end, "AntiLockEnabled")

AntiLockTog:AddKeybind(Enum.KeyCode.C, "AntiLockKeybind")

AntiLockSec:AddDropdown("Mode", {"Up", "Down", "Prediction Disabler", "Spinbot Desync"}, "Prediction Disabler", false, function(Value)
	AntiLock.Mode = Value
end, "AntiLockMode")

AntiLockSec:AddLabel("Spinbot Desync")

AntiLockSec:AddDropdown("Desync Velocity", {"Sky", "Underground"}, "Sky", false, function(Value)
	if Value == "Sky" then
		AntiLock.DesyncVel = Vector3.new(0, 9e9, 0)
	elseif Value == "Underground" then
		AntiLock.DesyncVel = Vector3.new(0, -9e9, 0)
	end
end, "AntiLockDesyncVelocity")

AntiLockSec:AddSlider("Desync Angles", -50, 0.5, 50, 2, function(Value)
	AntiLock.DesyncAngles = Value
end, "AntiLockDesyncAngles")

-- Self Dot

local SelfDotTog = SelfDotSec:AddToggle("Enabled", false, function(Value)
	SelfDot.Enabled = Value
end, "SelfDotEnabled")

SelfDotTog:AddColorpicker(Color3.fromRGB(170, 120, 210), function(Value)
	SelfDotCircle.Color = Value
	SelfTracerLine.Color = Value
end, "SelfDotCircleLineColor")

SelfDotSec:AddToggle("Tracer", false, function(Value)
	SelfDot.Tracer = Value
end, "SelfDotTracer")

SelfDotSec:AddToggle("Random Hit Part", false, function(Value)
	SelfDot.RandomHitPart = Value
end, "SelfDotRandomHitPart")

SelfDotSec:AddSlider("Prediction", 1, 2.5, 5, 2, function(Value)
	SelfDot.Prediction = Value / 20
end, "SelfDotPrediction")

SelfDotSec:AddDropdown("Hit Part", {"Head", "Torso"}, "Torso", false, function(Value)
	if Value == "Head" then
		SelfDot.HitPart = "Head"
		SelfDot.RealHitPart = "Head"
	else
		SelfDot.HitPart = "HumanoidRootPart"
		SelfDot.RealHitPart = "HumanoidRootPart"
	end
end, "SelfDotHitPart")

-- Target Strafe

local TargStrafeTog = TargetStrafeSec:AddToggle("Target Strafe", false, function(Value)
	TargetStrafe.Enabled = Value
end, "TargetStrafe")

TargStrafeTog:AddKeybind(nil, "TargetStrafeKeybind")

TargetStrafeSec:AddSlider("Speed", 1, 10, 10, 2, function(Value)
	TargetStrafe.Speed = Value
end, "TargetStrafeSpeed")

TargetStrafeSec:AddSlider("Distance", 1, 10, 20, 2, function(Value)
	TargetStrafe.Distance = Value
end, "TargetStrafeDistance")

TargetStrafeSec:AddSlider("Height", 1, 5, 20, 2, function(Value)
	TargetStrafe.Height = Value
end, "TargetStrafeHeight")

-- MISC

-- Utilities

UtilitiesSec:AddToggle("No Jump Cooldown", true, function(Value)
	Utilities.NoJumpCooldown = Value
end, "NoJumpCooldown")

UtilitiesSec:AddToggle("No Slowdown", true, function(Value)
	Utilities.NoSlowdown = Value
end, "NoSlowdown")

UtilitiesSec:AddToggle("Auto Stomp", true, function(Value)
	Utilities.AutoStomp = Value
end, "AutoStomp")

UtilitiesSec:AddToggle("Auto Reload", true, function(Value)
	Utilities.AutoReload = Value
end, "AutoReload")

local TrashTalkTog = UtilitiesSec:AddToggle("Trash Talk", false, function(Value)
	if Value then
		local TrashTalkWords = {"FemboyAssPounder", "How to aim pls help", "wow my little brother was playing and beat you :rofl:", "Mobile player beat u Lol XD", "420 ping and u got SLAMMED", "ur bad", "seed", "im not locking ur just bad", "clown", "sonned", "LOLL UR BAD", "dont even try.. ur not enough for the alpha", "ez", "gg = get good", "my grandmas better than u :skull:", "hop off kid", "bro cannot aim", "u got absolutely DOGGED on", "i run this server son", "what is bro doing :skull:", "no way", "sorry my cat walked across my keyboard and i still won"}

		ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(TrashTalkWords[math.random(#TrashTalkWords)], "All")
	end
end, "TrashTalk")

TrashTalkTog:AddKeybind(nil, "TrashTalkKeybind")

-- Movement

local SpeedTog = MovementSec:AddToggle("Speed", false, function(Value)
	Movement.SpeedEnabled = Value
end, "Speed")

SpeedTog:AddKeybind(Enum.KeyCode.Z, "SpeedKeybind")

MovementSec:AddSlider("Speed Amount", 1, 1000, 5000, 1, function(Value)
	Movement.SpeedAmount = Value / 1000
end, "SpeedAmount")

MovementSec:AddToggle("Auto Jump", false, function(Value)
	Movement.AutoJump = Value
end, "AutoJump")

MovementSec:AddToggle("Bunny Hop", false, function(Value)
	Movement.BunnyHop = Value
end, "BunnyHop")

MovementSec:AddSlider("Hop Amount", 1, 1, 50, 1, function(Value)
	Movement.HopAmount = Value / 100
end, "HopAmount")

local FlightTog = MovementSec:AddToggle("Flight", false, function(Value)
	Movement.FlightEnabled = Value
end, "Flight")

FlightTog:AddKeybind(nil, "FlightKeybind")

MovementSec:AddSlider("Flight Amount", 1, 2000, 5000, 1, function(Value)
	Movement.FlightAmount = Value / 20
end, "FlightAmount")

-- Code

if CorePackages.Packages then
	CorePackages.Packages:Destroy()
end

-- Heartbeat Functions

RunService.Heartbeat:Connect(function()
	local Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(LocalPlr.Character[SelfDot.RealHitPart].Position + (LocalPlr.Character[SelfDot.RealHitPart].AssemblyLinearVelocity * SelfDot.Prediction))

	if SelfDot.Enabled and OnScreen then
		SelfDotCircle.Visible = true
		SelfDotCircle.Position = Vector2.new(Position.X, Position.Y)
	else
		SelfDotCircle.Visible = false
	end
end)

RunService.Heartbeat:Connect(function()
	local Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(LocalPlr.Character[SelfDot.RealHitPart].Position + (LocalPlr.Character[SelfDot.RealHitPart].AssemblyLinearVelocity * SelfDot.Prediction))

	if SelfDot.Tracer and OnScreen then
		SelfTracerLine.Visible = true
		SelfTracerLine.From = UserInputService:GetMouseLocation()
		SelfTracerLine.To = Vector2.new(Position.X, Position.Y)
	else
		SelfTracerLine.Visible = false
	end
end)

RunService.Heartbeat:Connect(function()
	if AntiLock.Enabled then
		local RootPart = LocalPlr.Character.HumanoidRootPart
		local Velocity, Cframe = RootPart.AssemblyLinearVelocity, RootPart.CFrame

		if AntiLock.Mode == "Up" then
			RootPart.AssemblyLinearVelocity = Vector3.new(0, 9e9, 0)
			RunService.RenderStepped:Wait()
			RootPart.AssemblyLinearVelocity = Velocity

		elseif AntiLock.Mode == "Down" then
			RootPart.AssemblyLinearVelocity = Vector3.new(0, -9e9, 0)
			RunService.RenderStepped:Wait()
			RootPart.AssemblyLinearVelocity = Velocity

		elseif AntiLock.Mode == "Prediction Disabler" then
			RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			RunService.RenderStepped:Wait()
			RootPart.AssemblyLinearVelocity = Velocity

		elseif AntiLock.Mode == "Spinbot Desync" then
			RootPart.AssemblyLinearVelocity = AntiLock.DesyncVel
			RootPart.CFrame = Cframe * CFrame.Angles(0, math.rad(AntiLock.DesyncAngles), 0)
			RunService.RenderStepped:Wait()
			RootPart.AssemblyLinearVelocity = Velocity
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if Movement.FlightEnabled and not AntiLock.Enabled then
		local FlyVelocity = Vector3.new(0, 0.9, 0)

		if not UserInputService:GetFocusedTextBox() then
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				FlyVelocity = FlyVelocity + (Workspace.CurrentCamera.CoordinateFrame.lookVector * Movement.FlightAmount)
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				FlyVelocity = FlyVelocity + (Workspace.CurrentCamera.CoordinateFrame.rightVector * -Movement.FlightAmount)
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				FlyVelocity = FlyVelocity + (Workspace.CurrentCamera.CoordinateFrame.lookVector * -Movement.FlightAmount)
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				FlyVelocity = FlyVelocity + (Workspace.CurrentCamera.CoordinateFrame.rightVector * Movement.FlightAmount)
			end
		end

		LocalPlr.Character.HumanoidRootPart.AssemblyLinearVelocity = FlyVelocity
		LocalPlr.Character.Humanoid:ChangeState("Freefall")
	end
end)

-- Stepped Functions

RunService.Stepped:Connect(function()
	if CameraAimbot.Enabled and CamBindEnabled and CamlockPlr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		CameraAimbot.RealJumpOffset = CameraAimbot.JumpOffset
	else
		CameraAimbot.RealJumpOffset = 0
	end
end)

RunService.Stepped:Connect(function()
	local AirCheckType

	if CameraAimbot.AirCheckType == "Once in Air" then
		AirCheckType = CamlockPlr.Character.Humanoid.FloorMaterial == Enum.Material.Air
	else
		AirCheckType = CamlockPlr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall
	end

	if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.UseAirPart and AirCheckType then
		CameraAimbot.RealHitPart = CameraAimbot.AirPart
	else
		CameraAimbot.RealHitPart = CameraAimbot.HitPart
	end
end)

RunService.Stepped:Connect(function()
	if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.AutoPred then
		local Ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

		if Ping < 10 then
			CameraAimbot.RealPrediction = 0.097

		elseif Ping < 20 then
			CameraAimbot.RealPrediction = 0.112

		elseif Ping < 30 then
			CameraAimbot.RealPrediction = 0.115

		elseif Ping < 40 then
			CameraAimbot.RealPrediction = 0.125

		elseif Ping < 50 then
			CameraAimbot.RealPrediction = 0.122

		elseif Ping < 60 then
			CameraAimbot.RealPrediction = 0.123

		elseif Ping < 70 then
			CameraAimbot.RealPrediction = 0.132

		elseif Ping < 80 then
			CameraAimbot.RealPrediction = 0.134

		elseif Ping < 90 then
			CameraAimbot.RealPrediction = 0.137

		elseif Ping < 100 then
			CameraAimbot.RealPrediction = 0.146

		elseif Ping < 110 then
			CameraAimbot.RealPrediction = 0.148

		elseif Ping < 120 then
			CameraAimbot.RealPrediction = 0.144

		elseif Ping < 130 then
			CameraAimbot.RealPrediction = 0.157

		elseif Ping < 140 then
			CameraAimbot.RealPrediction = 0.122

		elseif Ping < 150 then
			CameraAimbot.RealPrediction = 0.152

		elseif Ping < 160 then
			CameraAimbot.RealPrediction = 0.163

		elseif Ping < 170 then
			CameraAimbot.RealPrediction = 0.192

		elseif Ping < 180 then
			CameraAimbot.RealPrediction = 0.193

		elseif Ping < 190 then
			CameraAimbot.RealPrediction = 0.167

		elseif Ping < 200 then
			CameraAimbot.RealPrediction = 0.166

		elseif Ping < 210 then
			CameraAimbot.RealPrediction = 0.168

		elseif Ping < 220 then
			CameraAimbot.RealPrediction = 0.166

		elseif Ping < 230 then
			CameraAimbot.RealPrediction = 0.157

		elseif Ping < 240 then
			CameraAimbot.RealPrediction = 0.168

		elseif Ping < 250 then
			CameraAimbot.RealPrediction = 0.165

		elseif Ping < 260 then
			CameraAimbot.RealPrediction = 0.176

		elseif Ping < 270 then
			CameraAimbot.RealPrediction = 0.177

		elseif Ping < 280 then
			CameraAimbot.RealPrediction = 0.181

		elseif Ping < 290 then
			CameraAimbot.RealPrediction = 0.182

		elseif Ping < 300 then
			CameraAimbot.RealPrediction = 0.185
		end
	else
		CameraAimbot.RealPrediction = CameraAimbot.Prediction
	end
end)

RunService.Stepped:Connect(function()
	if CameraAimbot.Enabled and CamBindEnabled and TargetStrafe.Enabled then
		StrafeSpeed = StrafeSpeed + TargetStrafe.Speed

		LocalPlr.Character.HumanoidRootPart.CFrame = CamlockPlr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(StrafeSpeed), 0) * CFrame.new(0, TargetStrafe.Height, TargetStrafe.Distance)
	end
end)

RunService.Stepped:Connect(function()
	LocalPlr.Character.Humanoid.UseJumpPower = not Utilities.NoJumpCooldown
end)

RunService.Stepped:Connect(function()
	if Utilities.NoSlowdown then
		local Slowdowns = LocalPlr.Character.BodyEffects.Movement:FindFirstChild("NoJumping") or LocalPlr.Character.BodyEffects.Movement:FindFirstChild("ReduceWalk") or LocalPlr.Character.BodyEffects.Movement:FindFirstChild("NoWalkSpeed")

		if Slowdowns then
			Slowdowns:Destroy()
		end

		if LocalPlr.Character.BodyEffects.Reload.Value then
			LocalPlr.Character.BodyEffects.Reload.Value = false
		end

		if LocalPlr.Character.BodyEffects.Reloading.Value then
			LocalPlr.Character.BodyEffects.Reloading.Value = false
		end
	end
end)

RunService.Stepped:Connect(function()
	if Utilities.AutoStomp then
		ReplicatedStorage.MainEvent:FireServer("Stomp")
	end
end)

RunService.Stepped:Connect(function()
	if Utilities.AutoReload and LocalPlr.Character:FindFirstChildWhichIsA("Tool").Ammo.Value <= 0 then
		ReplicatedStorage.MainEvent:FireServer("Reload", LocalPlr.Character:FindFirstChildWhichIsA("Tool"))
	end
end)

RunService.Stepped:Connect(function()
	if Movement.SpeedEnabled then
		LocalPlr.Character.HumanoidRootPart.CFrame = LocalPlr.Character.HumanoidRootPart.CFrame + LocalPlr.Character.Humanoid.MoveDirection * Movement.SpeedAmount
	end
end)

RunService.Stepped:Connect(function()
	if Movement.AutoJump and LocalPlr.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and LocalPlr.Character.Humanoid.MoveDirection.Magnitude > 0 then
		LocalPlr.Character.Humanoid:ChangeState("Jumping")
	end
end)

RunService.Stepped:Connect(function()
	if Movement.BunnyHop and LocalPlr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
		LocalPlr.Character.HumanoidRootPart.CFrame = LocalPlr.Character.HumanoidRootPart.CFrame + LocalPlr.Character.Humanoid.MoveDirection * Movement.HopAmount
	end
end)

-- RenderStepped Functions

RunService.RenderStepped:Connect(function()
	if CameraAimbot.Enabled and CamBindEnabled then
		if CameraAimbot.Resolver then
			if CameraAimbot.Smoothing then
				Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame:Lerp(CFrame.new(Workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (Resolver(CamlockPlr) * CameraAimbot.RealPrediction)), CameraAimbot.Smoothness, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
			else
				Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (Resolver(CamlockPlr) * CameraAimbot.RealPrediction))
			end
		else
			if CameraAimbot.Smoothing then
				Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame:Lerp(CFrame.new(Workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character[CameraAimbot.RealHitPart].AssemblyLinearVelocity * CameraAimbot.RealPrediction)), CameraAimbot.Smoothness, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
			else
				Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.p, CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character[CameraAimbot.RealHitPart].AssemblyLinearVelocity * CameraAimbot.RealPrediction))
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.KoCheck and (CamlockPlr.Character.Humanoid.Health <= 2.25 or LocalPlr.Character.Humanoid.Health <= 2.25) then
		CamBindEnabled = false
	end
end)

RunService.RenderStepped:Connect(function()
	local Position, OnScreen

	if CameraAimbot.Resolver then
		Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (Resolver(CamlockPlr) * CameraAimbot.RealPrediction))
	else
		Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(CamlockPlr.Character[CameraAimbot.RealHitPart].Position + Vector3.new(0, CameraAimbot.RealJumpOffset, 0) + (CamlockPlr.Character[CameraAimbot.RealHitPart].AssemblyLinearVelocity * CameraAimbot.RealPrediction))
	end

	if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.Tracer and OnScreen then
		CamTracerLine.Visible = true
		CamTracerLine.From = UserInputService:GetMouseLocation()
		CamTracerLine.To = Vector2.new(Position.X, Position.Y)
	else
		CamTracerLine.Visible = false
	end
end)

RunService.RenderStepped:Connect(function()
	if CameraAimbot.Enabled and CamBindEnabled and CameraAimbot.Highlight then
		CamHighlight.Parent = CamlockPlr.Character
	else
		CamHighlight.Parent = CoreGui
	end
end)

RunService.RenderStepped:Connect(function()
	CamFovCircle.Position = UserInputService:GetMouseLocation()
end)

RunService.RenderStepped:Connect(function()
	if (SelfDot.Enabled or SelfDot.Tracer) and SelfDot.RandomHitPart then
		local RandomHitParts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "RightUpperArm", "LeftUpperArm", "RightLowerArm", "LeftLowerArm", "RightUpperLeg", "LeftUpperLeg", "RightLowerLeg", "LeftLowerLeg"}

		SelfDot.RealHitPart = RandomHitParts[math.random(#RandomHitParts)]
		wait(0.6)
	else
		SelfDot.RealHitPart = SelfDot.HitPart
	end
end)

-- InputBegan Functions

UserInputService.InputBegan:Connect(function(Key)
	if CameraAimbot.Enabled and Key.KeyCode == CameraAimbot.Keybind and not UserInputService:GetFocusedTextBox() then
		local Position, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(ClosestPlr(CameraAimbot.RealHitPart, CameraAimbot.UseFov, CamFovCircle).Character[CameraAimbot.RealHitPart].Position)

		if CamBindEnabled then
			CamBindEnabled = false

			if CameraAimbot.Notify then
				StarterGui:SetCore("SendNotification", {
					Title = "detected.lol", 
					Text = "" .. CamlockPlr.DisplayName, 
					Duration = 2.5
				})
			end
		else
			if OnScreen then
				CamBindEnabled = true
				CamlockPlr = ClosestPlr(CameraAimbot.RealHitPart, CameraAimbot.UseFov, CamFovCircle)

				if CameraAimbot.Notify then
					StarterGui:SetCore("SendNotification", {
						Title = "detected.lol", 
						Text = "" .. CamlockPlr.DisplayName, 
						Duration = 2.5
					})
				end
			end
		end
	end
end)

-- Hookmetamethod functions

-- AntiCheatNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
-- 	local Arguments = {...}
-- 	local AntiCheats = {"BreathingHAMON", "TeleportDetect", "JJARC", "TakePoisonDamage", "CHECKER_1", "CHECKER", "GUI_CHECK", "OneMoreTime", "checkingSPEED", "BANREMOTE", "PERMAIDBAN", "KICKREMOTE", "BR_KICKPC", "FORCEFIELD", "Christmas_Sock", "VirusCough", "Symbiote", "Symbioted", "RequestAFKDisplay"}

-- 	if table.find(AntiCheats, Arguments[1]) and getnamecallmethod() == "FireServer" then
-- 		return
-- 	end

-- 	return AntiCheatNamecall(Self, ...)
-- end))
