local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Omni_Control_v4"
ScreenGui.ResetOnSpawn = false
-- Attempting CoreGui for persistence, falls back to PlayerGui
local success, err = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
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
Title.Text = "CONTROL PANEL"
Title.TextColor3 = Color3.fromHex("#30D6FF")
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

--- [ SET CASH SECTION ] ---
local CashFrame = Instance.new("Frame")
CashFrame.Size = UDim2.new(1, -30, 0, 60)
CashFrame.Position = UDim2.new(0, 15, 0, 60)
CashFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CashFrame.Parent = MainFrame

Instance.new("UICorner", CashFrame).CornerRadius = UDim.new(0, 8)

local CashInput = Instance.new("TextBox")
CashInput.Size = UDim2.new(0.6, -10, 0, 30)
CashInput.Position = UDim2.new(0, 10, 0.5, -15)
CashInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CashInput.Text = ""
CashInput.PlaceholderText = "Enter Amount..."
CashInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CashInput.Font = Enum.Font.Gotham
CashInput.TextSize = 14
CashInput.Parent = CashFrame
Instance.new("UICorner", CashInput)

local SetBtn = Instance.new("TextButton")
SetBtn.Size = UDim2.new(0.4, -15, 0, 30)
SetBtn.Position = UDim2.new(0.6, 5, 0.5, -15)
SetBtn.BackgroundColor3 = Color3.fromHex("#30D6FF")
SetBtn.Text = "SET CASH"
SetBtn.Font = Enum.Font.GothamBold
SetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SetBtn.TextSize = 12
SetBtn.Parent = CashFrame
Instance.new("UICorner", SetBtn)

--- [ PLAYER LIST SECTION ] ---
local ListContainer = Instance.new("ScrollingFrame")
ListContainer.Size = UDim2.new(1, -30, 1, -150)
ListContainer.Position = UDim2.new(0, 15, 0, 135)
ListContainer.BackgroundTransparency = 1
ListContainer.ScrollBarThickness = 2
ListContainer.ScrollBarImageColor3 = Color3.fromHex("#30D6FF")
ListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListContainer.Parent = MainFrame

local Layout = Instance.new("UIListLayout", ListContainer)
Layout.Padding = UDim.new(0, 5)

-- Logic: Set Cash
SetBtn.MouseButton1Click:Connect(function()
    local val = tonumber(CashInput.Text)
    if val then
        -- Logic: Search for common "Cash" leaderstat names
        local stats = Players.LocalPlayer:FindFirstChild("leaderstats")
        if stats then
            local cashObj = stats:FindFirstChild("Cash") or stats:FindFirstChild("Money") or stats:FindFirstChild("Coins")
            if cashObj then
                cashObj.Value = val
                print("Cash updated to: " .. val)
            end
        end
    end
end)

-- Logic: Update Player List
local function updateList()
    for _, c in pairs(ListContainer:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local pLabel = Instance.new("TextLabel")
        pLabel.Size = UDim2.new(1, 0, 0, 30)
        pLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        pLabel.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
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

-- Toggle UI (RightControl)
UserInputService.InputBegan:Connect(function(io, gpe)
    if not gpe and io.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
