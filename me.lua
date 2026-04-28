-- [[ CONFIGURATION ]]
local TARGET_USER_ID = 9460535304 -- Your ID
local ACCENT_COLOR = Color3.fromHex("#30D6FF")
local BG_COLOR = Color3.fromRGB(15, 15, 15)
local SECONDARY_BG = Color3.fromRGB(25, 25, 25)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [[ SECURITY LOCK ]]
if LocalPlayer.UserId ~= TARGET_USER_ID then
	warn("Unauthorized User. Omni System Terminated.")
	return
end

-- [[ GUI INITIALIZATION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Omni_Riel_Final"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local selectedPlayer = nil

-- [[ TOGGLE BUTTON ]]
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 1, -70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ToggleBtn.Text = "R"
ToggleBtn.TextColor3 = ACCENT_COLOR
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 22
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = ACCENT_COLOR
BtnStroke.Thickness = 2

-- [[ MAIN DASHBOARD ]]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = ACCENT_COLOR
MainStroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "RIEL CONTROL CENTER"
Title.TextColor3 = ACCENT_COLOR
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- [[ CONTROL PANEL ]]
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -30, 0, 100)
ControlFrame.Position = UDim2.new(0, 15, 0, 60)
ControlFrame.BackgroundColor3 = SECONDARY_BG
ControlFrame.Parent = MainFrame
Instance.new("UICorner", ControlFrame)

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 0, 30)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target: [Select Player]"
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.Parent = ControlFrame

local RielInput = Instance.new("TextBox")
RielInput.Size = UDim2.new(0.6, -10, 0, 35)
RielInput.Position = UDim2.new(0, 10, 0, 45)
RielInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RielInput.PlaceholderText = "Amount..."
RielInput.Text = ""
RielInput.TextColor3 = Color3.new(1,1,1)
RielInput.Font = Enum.Font.Gotham
RielInput.Parent = ControlFrame
Instance.new("UICorner", RielInput)

local SetBtn = Instance.new("TextButton")
SetBtn.Size = UDim2.new(0.4, -15, 0, 35)
SetBtn.Position = UDim2.new(0.6, 5, 0, 45)
SetBtn.BackgroundColor3 = ACCENT_COLOR
SetBtn.Text = "SET RIEL"
SetBtn.Font = Enum.Font.GothamBold
SetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SetBtn.Parent = ControlFrame
Instance.new("UICorner", SetBtn)

-- [[ PLAYER LIST ]]
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -30, 1, -210)
ScrollingFrame.Position = UDim2.new(0, 15, 0, 195)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 2
ScrollingFrame.ScrollBarImageColor3 = ACCENT_COLOR
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 6)

-- [[ LOGIC ]]

-- Function to attempt a "Real" change by scanning for game remotes
local function fireRemoteBypass(target, amount)
	-- 1. Local Visual Change
	local stats = target:FindFirstChild("leaderstats")
	if stats then
		local r = stats:FindFirstChild("Riel") or stats:FindFirstChild("Cash")
		if r then r.Value = amount end
	end

	-- 2. Scanner: Look for hidden events to make it 'Real'
	local remotes = game:GetDescendants()
	for _, obj in pairs(remotes) do
		if obj:IsA("RemoteEvent") then
			local n = obj.Name:lower()
			if n:find("riel") or n:find("money") or n:find("cash") or n:find("add") then
				pcall(function()
					obj:FireServer(amount)
					obj:FireServer(target, amount)
				end)
			end
		end
	end
end

local function updateList()
	for _, child in pairs(ScrollingFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	for _, player in pairs(Players:GetPlayers()) do
		local pBtn = Instance.new("TextButton")
		pBtn.Size = UDim2.new(1, -5, 0, 35)
		pBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		pBtn.Text = "  " .. player.DisplayName
		pBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
		pBtn.TextXAlignment = Enum.TextXAlignment.Left
		pBtn.Font = Enum.Font.Gotham
		pBtn.Parent = ScrollingFrame
		Instance.new("UICorner", pBtn)

		pBtn.MouseButton1Click:Connect(function()
			selectedPlayer = player
			TargetLabel.Text = "Target: " .. player.DisplayName
			TargetLabel.TextColor3 = ACCENT_COLOR
		end)
	end
end

SetBtn.MouseButton1Click:Connect(function()
	local amt = tonumber(RielInput.Text)
	if amt and selectedPlayer then
		fireRemoteBypass(selectedPlayer, amt)
		SetBtn.Text = "INJECTED"
		task.wait(0.5)
		SetBtn.Text = "SET RIEL"
	end
end)

ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
	ToggleBtn.Text = MainFrame.Visible and "X" or "R"
end)

-- Smooth Dragging
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()
