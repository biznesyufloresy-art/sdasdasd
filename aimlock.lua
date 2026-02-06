-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local AimlockEnabled = false
local TargetPart = "Head"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")

ScreenGui.Name = "AimlockGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0, 20, 0.5, -25)
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "AIMLOCK: OFF"
Button.TextSize = 18
Button.Font = Enum.Font.GothamBold
Button.Parent = ScreenGui
Button.BorderSizePixel = 0
Button.AutoButtonColor = true

-- TOGGLE
Button.MouseButton1Click:Connect(function()
	AimlockEnabled = not AimlockEnabled
	Button.Text = AimlockEnabled and "AIMLOCK: ON" or "AIMLOCK: OFF"
end)

-- GET CLOSEST PLAYER
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = math.huge
	local mousePos = UserInputService:GetMouseLocation()

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer
			and player.Character
			and player.Character:FindFirstChild(TargetPart) then

			local part = player.Character[TargetPart]
			local pos, onScreen = Camera:WorldToViewportPoint(part.Position)

			if onScreen then
				local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if dist < shortestDistance then
					shortestDistance = dist
					closestPlayer = player
				end
			end
		end
	end

	return closestPlayer
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
	if AimlockEnabled then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild(TargetPart) then
			local targetPos = target.Character[TargetPart].Position
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
		end
	end
end)
