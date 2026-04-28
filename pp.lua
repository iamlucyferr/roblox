-- [[ OMNI GHOST PROTOCOL V14: KLA KLOUK MASTER ]]
-- AUTHORIZED USER: 9460535304
-- TARGET: KLA KLOUK AUTOMATION + BYPASS

local TARGET_ID = 9460535304
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ SECURITY GATE ]]
if LocalPlayer.UserId ~= TARGET_ID then 
    warn("CRITICAL: UNAUTHORIZED USER DETECTED.")
    return 
end

-- [[ SERVICES ]]
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- [[ STEALTH CORE ]]
local function GetSafeParent()
    local success, p = pcall(function() return gethui() end)
    if success and p then return p end
    return CoreGui
end

local function RandomName(len)
    local s = ""
    for i = 1, len do s = s .. string.char(math.random(97, 122)) end
    return s
end

-- [[ CONFIGURATION ]]
local Settings = {
    AutoPlay = false,
    Amount = 5000,
    Animal = "Kla",
    Speed = 0.6,
    Strategy = "Static", -- Static, Random, Cycle
    AntiKick = true
}

local Animals = {"Kdam", "Kla", "Klouk", "Morn", "Pkea", "Trey"}
local ACCENT = Color3.fromHex("#30D6FF")
local BG_DARK = Color3.fromRGB(12, 12, 12)

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = RandomName(12)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GetSafeParent()

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 480)
Main.Position = UDim2.new(0.5, -160, 0.5, -240)
Main.BackgroundColor3 = BG_DARK
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = ACCENT
Stroke.Thickness = 2

-- Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "OMNI MASTER CONFIG"
Title.TextColor3 = ACCENT
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = Main

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -80)
Content.Position = UDim2.new(0, 10, 0, 70)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 2
Content.CanvasSize = UDim2.new(0, 0, 0, 550)
Content.Parent = Main
local UIList = Instance.new("UIListLayout", Content)
UIList.Padding = UDim.new(0, 12)

-- [[ UI COMPONENTS ]]
local function CreateSection(txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = txt:upper()
    l.TextColor3 = Color3.fromRGB(100, 100, 100)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.BackgroundTransparency = 1
    l.Parent = Content
end

local function CreateInput(placeholder, callback)
    local i = Instance.new("TextBox")
    i.Size = UDim2.new(1, 0, 0, 45)
    i.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    i.PlaceholderText = placeholder
    i.Text = ""
    i.TextColor3 = Color3.new(1, 1, 1)
    i.Font = Enum.Font.Gotham
    i.Parent = Content
    Instance.new("UICorner", i)
    i.FocusLost:Connect(function() callback(i.Text) end)
end

local function CreateButton(txt, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 50)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.Parent = Content
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- [[ BUILD CONTROLS ]]
CreateSection("Betting Configuration")
CreateInput("Set Amount (Default 5000)", function(val)
    if tonumber(val) then Settings.Amount = tonumber(val) end
end)

CreateInput("Set Target Animal (e.g. Kla)", function(val)
    for _, a in pairs(Animals) do
        if val:lower() == a:lower() then Settings.Animal = a end
    end
end)

CreateSection("Execution Strategy")
local StratBtn = CreateButton("MODE: STATIC", Color3.fromRGB(40, 40, 40), function() end)
StratBtn.MouseButton1Click:Connect(function()
    if Settings.Strategy == "Static" then
        Settings.Strategy = "Random"
        StratBtn.Text = "MODE: RANDOM"
    elseif Settings.Strategy == "Random" then
        Settings.Strategy = "Cycle"
        StratBtn.Text = "MODE: CYCLE"
    else
        Settings.Strategy = "Static"
        StratBtn.Text = "MODE: STATIC"
    end
end)

CreateSection("System Controls")
local MainToggle = CreateButton("START AUTOMATOR", ACCENT, function() end)
MainToggle.TextColor3 = Color3.new(0, 0, 0)

-- [[ AUTOMATION LOGIC ]]
local function GetNextTarget()
    if Settings.Strategy == "Random" then
        return Animals[math.random(1, #Animals)]
    elseif Settings.Strategy == "Cycle" then
        local idx = table.find(Animals, Settings.Animal) or 1
        Settings.Animal = Animals[(idx % #Animals) + 1]
        return Settings.Animal
    end
    return Settings.Animal
end

local function PerformInjection()
    local remote = nil
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("bet") or v.Name:lower():find("place")) then
            remote = v break
        end
    end

    if remote then
        local target = GetNextTarget()
        -- Split into 1k chunks to look like natural human clicking
        local chunks = math.floor(Settings.Amount / 1000)
        for i = 1, chunks do
            if not Settings.AutoPlay then break end
            pcall(function() remote:FireServer(target, 1000) end)
            task.wait(Settings.Speed + (math.random() * 0.2)) -- Jitter
        end
        
        -- Auto-Confirm if button exists
        pcall(function()
            local confirm = ReplicatedStorage:FindFirstChild("PlaceBet", true) or ReplicatedStorage:FindFirstChild("Confirm", true)
            if confirm then confirm:FireServer() end
        end)
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoPlay then
            PerformInjection()
            task.wait(35) -- Round cooldown
        end
    end
end)

MainToggle.MouseButton1Click:Connect(function()
    Settings.AutoPlay = not Settings.AutoPlay
    if Settings.AutoPlay then
        MainToggle.Text = "STOPPING..."
        task.wait(0.5)
        MainToggle.Text = "OMNI ACTIVE"
        MainToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    else
        MainToggle.Text = "START AUTOMATOR"
        MainToggle.BackgroundColor3 = ACCENT
    end
end)

-- [[ GUI HELPERS ]]
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 20, 1, -70)
Toggle.Text = "OMNI"
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local drag, dStart, sPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true dStart = i.Position sPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

-- Anti-AFK
local VU = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

print("Omni Master V14 Loaded Successfully.")
