local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Omni_v4_Integrated"
ScreenGui.ResetOnSpawn = false
local success, err = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

-- [[ TOGGLE BUTTON ]]
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "OpenHide"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 1, -70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Text = "O"
ToggleBtn.TextColor3 = Color3.fromHex("#30D6FF")
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = ToggleBtn

local BtnGlow = Instance.new("UIStroke")
BtnGlow.Color = Color3.fromHex("#30D6FF")
BtnGlow.Thickness = 2
BtnGlow.Parent = ToggleBtn

-- [[ MAIN FRAME ]]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Glow = Instance.new("UIStroke")
Glow.Color = Color3.fromHex("#30D6FF")
Glow.Thickness = 2
Glow.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "OMNI CONTROL"
Title.TextColor3 = Color3.fromHex("#30D6FF")
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- [[ CASH SETTER ]]
local CashFrame = Instance.new("Frame")
CashFrame.Size = UDim2.new(1, -30, 0, 60)
CashFrame.Position = UDim2.new(0, 15, 0, 60)
CashFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CashFrame.Parent = MainFrame
Instance.new("UICorner", CashFrame)

local CashInput = Instance.new("TextBox")
CashInput.Size = UDim2.new(0.6, -10, 0, 30)
CashInput.Position = UDim2.new(0, 10, 0.5, -15)
CashInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CashInput.Text = ""
CashInput.PlaceholderText = "Amount..."
CashInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CashInput.Font = Enum.Font.Gotham
CashInput.Parent = CashFrame
Instance.new("UICorner", CashInput)

local SetBtn = Instance.new("TextButton")
SetBtn.Size = UDim2.new(0.4, -15, 0, 30)
SetBtn.Position = UDim2.new(0.6, 5, 0.5, -15)
SetBtn.BackgroundColor3 = Color3.fromHex("#30D6FF")
SetBtn.Text = "SET CASH"
SetBtn.Font = Enum.Font.GothamBold
SetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SetBtn.Parent = CashFrame
Instance.new("UICorner", SetBtn)

-- [[ PLAYER LIST ]]
local ListContainer = Instance.new("ScrollingFrame")
ListContainer.Size = UDim2.new(1, -30, 1, -150)
ListContainer.Position = UDim2.new(0, 15, 0, 135)
ListContainer.BackgroundTransparency = 1
ListContainer.ScrollBarThickness = 2
ListContainer.ScrollBarImageColor3 = Color3.fromHex("#30D6FF")
ListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListContainer.Parent = MainFrame
Instance.new("UIListLayout", ListContainer).Padding = UDim.new(0, 5)

-- Logic: Open/Hide Toggle
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleBtn.Text = MainFrame.Visible and "X" or "O"
    ToggleBtn.TextColor3 = MainFrame.Visible and Color3.new(1, 0, 0) or Color3.fromHex("#30D6FF")
    ToggleBtn.UIStroke.Color = ToggleBtn.TextColor3
end)

-- Logic: Cash Function
SetBtn.MouseButton1Click:Connect(function()
    local val = tonumber(CashInput.Text)
    if val then
        local stats = Players.LocalPlayer:FindFirstChild("leaderstats")
        if stats then
            local cashObj = stats:FindFirstChild("Cash") or stats:FindFirstChild("Money") or stats:FindFirstChild("Coins")
            if cashObj then cashObj.Value = val end
        end
    end
end)

-- Logic: List Update
local function updateList()
    for _, c in pairs(ListContainer:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local pLabel = Instance.new("TextLabel")
        pLabel.Size = UDim2.new(1, 0, 0, 30)
        pLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        pLabel.Text = "  " .. p.DisplayName
        pLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        pLabel.TextXAlignment = Enum.TextXAlignment.Left
        pLabel.Font = Enum.Font.Gotham
        pLabel.Parent = ListContainer
        Instance.new("UICorner", pLabel)
    end
end

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
updateList()

-- Simple Dragging Logic
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
