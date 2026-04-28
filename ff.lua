-- [[ OMNI RIEL SYSTEM: BYPASS EDITION ]]
-- AUTHORED FOR USERID: 9460535304

local TARGET_ID = 9460535304
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Security Check
if LocalPlayer.UserId ~= TARGET_ID then 
    warn("Unauthorized User Detected. Omni System Terminated.")
    return 
end

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- [[ SETTINGS ]]
local ACCENT_COLOR = Color3.fromHex("#30D6FF")
local BG_COLOR = Color3.fromRGB(15, 15, 15)
local SECONDARY_BG = Color3.fromRGB(25, 25, 25)

-- [[ GUI INITIALIZATION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Omni_Riel_Bypass_V5"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local selectedPlayer = LocalPlayer -- Default to yourself

-- [[ TOGGLE BUTTON ]]
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 1, -75)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ToggleBtn.Text = "RIEL"
ToggleBtn.TextColor3 = ACCENT_COLOR
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
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
Title.Text = "OMNI BYPASS SYSTEM"
Title.TextColor3 = ACCENT_COLOR
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- [[ CONTROL PANEL ]]
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -30, 0, 140)
ControlFrame.Position = UDim2.new(0, 15, 0, 60)
ControlFrame.BackgroundColor3 = SECONDARY_BG
ControlFrame.Parent = MainFrame
Instance.new("UICorner", ControlFrame)

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 0, 30)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target: Self"
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.Parent = ControlFrame

local RielInput = Instance.new("TextBox")
RielInput.Size = UDim2.new(1, -20, 0, 35)
RielInput.Position = UDim2.new(0, 10, 0, 40)
RielInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RielInput.PlaceholderText = "Riel Amount..."
RielInput.TextColor3 = Color3.new(1,1,1)
RielInput.Font = Enum.Font.Gotham
RielInput.Parent = ControlFrame
Instance.new("UICorner", RielInput)

local SetBtn = Instance.new("TextButton")
SetBtn.Size = UDim2.new(1, -20, 0, 40)
SetBtn.Position = UDim2.new(0, 10, 0, 85)
SetBtn.BackgroundColor3 = ACCENT_COLOR
SetBtn.Text = "INJECT & SAVE DATA"
SetBtn.Font = Enum.Font.GothamBold
SetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SetBtn.Parent = ControlFrame
Instance.new("UICorner", SetBtn)

-- [[ PLAYER LIST ]]
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -30, 1, -250)
ScrollingFrame.Position = UDim2.new(0, 15, 0, 210)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 2
ScrollingFrame.ScrollBarImageColor3 = ACCENT_COLOR
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 6)

-- [[ BYPASS LOGIC ]]

local function attemptSaveBypass(target, amount)
    -- 1. Visual/Leaderstat Update
    local stats = target:FindFirstChild("leaderstats")
    if stats then
        local r = stats:FindFirstChild("Riel") or stats:FindFirstChild("Cash") or stats:FindFirstChild("Money")
        if r then r.Value = amount end
    end

    -- 2. Remote Scanner (Scanning for Save/Data Events)
    local keywords = {"save", "data", "sync", "store", "update", "riel", "cash"}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            for _, key in pairs(keywords) do
                if name:find(key) then
                    pcall(function()
                        obj:FireServer(amount)
                        obj:FireServer(target, amount)
                        obj:FireServer("Update", {["Riel"] = amount})
                    end)
                end
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
    local val = tonumber(RielInput.Text)
    if val and selectedPlayer then
        SetBtn.Text = "INJECTING..."
        attemptSaveBypass(selectedPlayer, val)
        task.wait(1)
        SetBtn.Text = "SUCCESS (CHECK DATA)"
        task.wait(1)
        SetBtn.Text = "INJECT & SAVE DATA"
    end
end)

-- Standard UI Handlers
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = i.Position startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()

print("Omni System v5 Loaded for Authorized User.")
