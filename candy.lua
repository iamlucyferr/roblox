local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OmniDashboard"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui") -- Using CoreGui for persistence

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Visual Styling (Glow & Glassmorphism)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromHex("#30D6FF") -- Neon Cyan Glow
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "PLAYER MONITOR"
Title.TextColor3 = Color3.fromHex("#30D6FF")
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- List Container
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 2
ScrollingFrame.ScrollBarImageColor3 = Color3.fromHex("#30D6FF")
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollingFrame

-- Function to add players
local function createPlayerEntry(player)
    local Frame = Instance.new("Frame")
    Frame.Name = player.Name
    Frame.Size = UDim2.new(1, -5, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScrollingFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -10, 1, 0)
    NameLabel.Position = UDim2.new(0, 10, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextSize = 14
    NameLabel.Parent = Frame
end

-- Refresh Logic
local function refresh()
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        createPlayerEntry(p)
    end
end

-- Toggle Visibility
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Events
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()

print("GUI Loaded. Press RightControl to Toggle.")
