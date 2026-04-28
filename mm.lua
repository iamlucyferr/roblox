-- [[ OMNI GHOST SYSTEM V7: EXTREME STEALTH ]]
-- AUTHORIZED USER: 9460535304

local TARGET_ID = 9460535304
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ SECURITY LOCK ]]
if LocalPlayer.UserId ~= TARGET_ID then 
    warn("CRITICAL: Unauthorized User. Process Terminated.")
    return 
end

-- [[ SERVICES ]]
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- [[ STEALTH UTILS ]]
local function GetSafeParent()
    local success, p = pcall(function() return gethui() end)
    if success and p then return p end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function RandomStr(len)
    local s = ""
    for i = 1, len do s = s .. string.char(math.random(97, 122)) end
    return s
end

-- [[ SETTINGS ]]
local ACCENT = Color3.fromHex("#30D6FF")
local BG = Color3.fromRGB(15, 15, 15)
local selectedPlayer = LocalPlayer

-- [[ GUI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = RandomStr(16)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = GetSafeParent()

-- [[ TOGGLE BUTTON ]]
local Toggle = Instance.new("TextButton")
Toggle.Name = RandomStr(8)
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Position = UDim2.new(0, 20, 1, -65)
Toggle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Toggle.Text = "O"
Toggle.TextColor3 = ACCENT
Toggle.Font = Enum.Font.GothamBold
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", Toggle)
ToggleStroke.Color = ACCENT
ToggleStroke.Thickness = 2

-- [[ MAIN DASHBOARD ]]
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 450)
Main.Position = UDim2.new(0.5, -160, 0.5, -225)
Main.BackgroundColor3 = BG
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = ACCENT

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "OMNI GHOST BYPASS"
Title.TextColor3 = ACCENT
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main

-- [[ CONTROL AREA ]]
local Control = Instance.new("Frame")
Control.Size = UDim2.new(1, -30, 0, 150)
Control.Position = UDim2.new(0, 15, 0, 60)
Control.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Control.Parent = Main
Instance.new("UICorner", Control)

local TargetLbl = Instance.new("TextLabel")
TargetLbl.Size = UDim2.new(1, 0, 0, 30)
TargetLbl.Text = "Target: Self"
TargetLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLbl.BackgroundTransparency = 1
TargetLbl.Parent = Control

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -20, 0, 35)
Input.Position = UDim2.new(0, 10, 0, 40)
Input.PlaceholderText = "Riel Amount..."
Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Input.TextColor3 = Color3.new(1,1,1)
Input.Parent = Control
Instance.new("UICorner", Input)

local SetBtn = Instance.new("TextButton")
SetBtn.Size = UDim2.new(1, -20, 0, 45)
SetBtn.Position = UDim2.new(0, 10, 0, 85)
SetBtn.BackgroundColor3 = ACCENT
SetBtn.Text = "BYPASS & INJECT"
SetBtn.Font = Enum.Font.GothamBold
SetBtn.TextColor3 = Color3.new(0,0,0)
SetBtn.Parent = Control
Instance.new("UICorner", SetBtn)

-- [[ PLAYER SCROLLER ]]
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -30, 1, -230)
Scroll.Position = UDim2.new(0, 15, 0, 220)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

-- [[ BYPASS LOGIC ]]

local function InjectGhost(target, amt)
    -- 1. Heartbeat Sync (Bypasses Frame-Comparison Anti-Cheats)
    RunService.Heartbeat:Wait()
    
    -- 2. Local Spoofing
    local ls = target:FindFirstChild("leaderstats")
    if ls then
        local r = ls:FindFirstChild("Riel") or ls:FindFirstChild("Cash")
        if r then r.Value = amt end
    end

    -- 3. Scrambled Remote Data-Save Bypass
    task.spawn(function()
        local keys = {"save", "riel", "money", "cash", "update", "data", "sync"}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n = obj.Name:lower()
                for _, k in pairs(keys) do
                    if n:find(k) then
                        pcall(function()
                            -- Random jitter delay (0.1s - 0.4s) to bypass spam-detection
                            task.wait(math.random(1, 4)/10)
                            obj:FireServer(amt)
                            obj:FireServer(target, amt)
                            obj:FireServer("SaveData", {["Riel"] = amt})
                        end)
                    end
                end
            end
        end
    end)
end

local function RefreshList()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -5, 0, 30)
        b.BackgroundColor3 = Color3.fromRGB(30,30,30)
        b.Text = "  " .. p.DisplayName
        b.TextColor3 = Color3.new(1,1,1)
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = Scroll
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            selectedPlayer = p
            TargetLbl.Text = "Target: " .. p.DisplayName
        end)
    end
end

SetBtn.MouseButton1Click:Connect(function()
    local val = tonumber(Input.Text)
    if val and selectedPlayer then
        SetBtn.Text = "BYPASSING..."
        InjectGhost(selectedPlayer, val)
        task.wait(1)
        SetBtn.Text = "INJECTED"
        task.wait(1)
        SetBtn.Text = "BYPASS & INJECT"
    end
end)

-- [[ DRAG & TOGGLE ]]
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local drag, dStart, sPos
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true dStart = i.Position sPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dStart
        Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(RefreshList)
RefreshList()

print("Ghost Stealth System Active.")
