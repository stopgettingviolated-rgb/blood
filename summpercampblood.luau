-- bubbles.cc v2.1

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImInsane-1337/neverlose-ui/refs/heads/main/source/library.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Clean old instances
for _, v in ipairs(CoreGui:GetChildren()) do
    if v.Name == "bb_dist_overlay" or v.Name == "bb_fov" or v.Name == "bb_warn" or v.Name == "bubbles_cc" or v.Name == "\0" or v.Name == "" then v:Destroy() end
end

-- Configure theme
Library.Folders = {
    Directory = "bubbles.cc",
    Configs = "bubbles.cc/Configs",
    Assets = "bubbles.cc/Assets",
}
local Accent = Color3.fromRGB(100, 180, 255)
Library.Theme.Accent = Accent
Library.Theme.AccentGradient = Color3.fromRGB(50, 80, 200)
Library:ChangeTheme("Accent", Accent)

-- Toggles table for ESP/feature state
local Toggles = {}

-- Colors
local Colors = {
    Window = Color3.fromRGB(255, 255, 0),
    Killer = Color3.fromRGB(255, 30, 30),
    Survivor = Color3.fromRGB(30, 255, 30),
    BearTrap = Color3.fromRGB(255, 165, 0),
    Radio = Color3.fromRGB(255, 0, 255),
    CarEscape = Color3.fromRGB(0, 255, 255),
    BoatEscape = Color3.fromRGB(180, 180, 255),
    PhoneBox = Color3.fromRGB(255, 128, 0),
    TommyRadio = Color3.fromRGB(180, 50, 255),
    PocketKnife = Color3.fromRGB(150, 50, 255),
    MedSpray = Color3.fromRGB(0, 255, 150),
    Shotgun = Color3.fromRGB(200, 50, 50),
    FlareGun = Color3.fromRGB(255, 120, 0),
    BaseballBat = Color3.fromRGB(180, 120, 50),
    SurvivorAxe = Color3.fromRGB(180, 180, 180),
    Gas = Color3.fromRGB(255, 255, 50),
    Fuse = Color3.fromRGB(255, 50, 200),
    CarKeys = Color3.fromRGB(255, 200, 0),
    Propeller = Color3.fromRGB(0, 200, 255),
    Firecracker = Color3.fromRGB(255, 50, 0),
    Battery = Color3.fromRGB(150, 255, 50),
}

local PromptNames = {
    BatteryPrompt = "Battery", GasPrompt = "Gas", KeyPrompt = "Key",
    PropellerPrompt = "Propeller", EnginePrompt = "Engine",
}

local infStamConn = nil
local godModeConn = nil
local noCDConn = nil
local backpackBypassConn = nil
local autoPickConn = nil

local charms = {}
local distLabels = {}
local cam = workspace.CurrentCamera

-- Screen-space overlay for distance labels
local distOverlay = Instance.new("ScreenGui")
distOverlay.Name = "bb_dist_overlay"
distOverlay.ResetOnSpawn = false
distOverlay.Parent = CoreGui

local distPool = Instance.new("Frame")
distPool.Size = UDim2.new(1, 0, 1, 0)
distPool.BackgroundTransparency = 1
distPool.Parent = distOverlay

-- Helper to create toggle callback
local function mkTog(key, def)
    Toggles[key] = def
    return function(v) Toggles[key] = v end
end

-- Create window and pages
local Window = Library:Window({
    Name = "bubbles.cc",
    SubName = "Summer Campblood",
    Logo = "73717790052871",
    Size = UDim2.new(0, 610, 0, 570),
})

-- ESP Tab
local espPage = Window:Page({Name = "ESP", Icon = "122669828593160", Columns = 2})

-- Players Section
local playersSec = espPage:Section({Name = "Players", Side = 1})
playersSec:Toggle({Name = "Killer Highlight", Flag = "espKiller", Default = true, Callback = mkTog("Killer", true)})
playersSec:Toggle({Name = "Survivor Highlight", Flag = "espSurvivor", Default = true, Callback = mkTog("Survivor", true)})

-- Objectives Section
local objSec = espPage:Section({Name = "Objectives", Side = 1})
objSec:Toggle({Name = "Window", Flag = "espWindow", Default = true, Callback = mkTog("Window", true)})
objSec:Toggle({Name = "Bear Trap", Flag = "espBearTrap", Default = true, Callback = mkTog("BearTrap", true)})
objSec:Toggle({Name = "Radio", Flag = "espRadio", Default = true, Callback = mkTog("Radio", true)})
objSec:Toggle({Name = "Phone Box", Flag = "espPhoneBox", Default = true, Callback = mkTog("PhoneBox", true)})
objSec:Toggle({Name = "Car Parts", Flag = "espCarEscape", Default = true, Callback = mkTog("CarEscape", true)})
objSec:Toggle({Name = "Boat Parts", Flag = "espBoatEscape", Default = true, Callback = mkTog("BoatEscape", true)})
objSec:Toggle({Name = "Tommy Radio", Flag = "espTommyRadio", Default = true, Callback = mkTog("TommyRadio", true)})

-- Items Section
local itemsSec = espPage:Section({Name = "Items", Side = 2})
itemsSec:Toggle({Name = "Pocket Knife", Flag = "espPocketKnife", Default = true, Callback = mkTog("PocketKnife", true)})
itemsSec:Toggle({Name = "Med Spray", Flag = "espMedSpray", Default = true, Callback = mkTog("MedSpray", true)})
itemsSec:Toggle({Name = "Shotgun", Flag = "espShotgun", Default = true, Callback = mkTog("Shotgun", true)})
itemsSec:Toggle({Name = "Flare Gun", Flag = "espFlareGun", Default = true, Callback = mkTog("FlareGun", true)})
itemsSec:Toggle({Name = "Baseball Bat", Flag = "espBaseballBat", Default = true, Callback = mkTog("BaseballBat", true)})
itemsSec:Toggle({Name = "Axe", Flag = "espAxe", Default = true, Callback = mkTog("SurvivorAxe", true)})
itemsSec:Toggle({Name = "Gas", Flag = "espGas", Default = true, Callback = mkTog("Gas", true)})
itemsSec:Toggle({Name = "Fuse", Flag = "espFuse", Default = true, Callback = mkTog("Fuse", true)})
itemsSec:Toggle({Name = "Car Keys", Flag = "espCarKeys", Default = true, Callback = mkTog("CarKeys", true)})
itemsSec:Toggle({Name = "Propeller", Flag = "espPropeller", Default = true, Callback = mkTog("Propeller", true)})
itemsSec:Toggle({Name = "Firecracker", Flag = "espFirecracker", Default = true, Callback = mkTog("Firecracker", true)})

-- EXP Tab
local expPage = Window:Page({Name = "EXP", Icon = "92464809279921", Columns = 1})

local expSec = expPage:Section({Name = "Exploits", Side = 1})
expSec:Toggle({Name = "God Mode", Flag = "expGodMode", Default = false, Callback = function(v) Toggles.GodMode = v; toggleGodMode(v) end})
expSec:Toggle({Name = "Infinite Stamina", Flag = "expInfStamina", Default = false, Callback = function(v) Toggles.InfStamina = v; toggleInfStamina(v) end})
expSec:Toggle({Name = "No Ability CD", Flag = "expNoCD", Default = false, Callback = function(v) Toggles.NoCD = v; toggleNoCD(v) end})
expSec:Toggle({Name = "Backpack Bypass", Flag = "expBackpackBypass", Default = false, Callback = function(v) Toggles.BackpackBypass = v; toggleBackpackBypass(v) end})
expSec:Toggle({Name = "Auto-Pick Knives", Flag = "expAutoPick", Default = false, Callback = function(v) Toggles.AutoPickKnives = v; toggleAutoPick(v) end})

-- Aim Tab
local aimPage = Window:Page({Name = "Aim", Icon = "120959262762131", Columns = 1})

local aimSec = aimPage:Section({Name = "Silent Aim", Side = 1})
aimSec:Toggle({Name = "Enabled", Flag = "aimEnabled", Default = false, Callback = function(v) Toggles.SilentAim = v end})
aimSec:Dropdown({Name = "Target Part", Flag = "aimTargetPart", Default = "Head", Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Callback = function(v) Toggles.AimTargetPart = v end})
aimSec:Toggle({Name = "Draw FOV", Flag = "aimShowFOV", Default = false, Callback = function(v) Toggles.ShowFOV = v end})
aimSec:Slider({Name = "FOV Radius", Flag = "aimFOV", Min = 50, Max = 500, Default = 200, Callback = function(v) Toggles.FOVRadius = v end})

-- Silent Aim (no hookmetamethod — uses fireproximityprompt + direct remote firing)
local stunEvents = nil
local function getStunEvents()
    if stunEvents then return stunEvents end
    local rs = game:GetService("ReplicatedStorage")
    local ev = rs:FindFirstChild("Events")
    if ev then stunEvents = ev:FindFirstChild("StunEvents") end
    return stunEvents
end

local function getKillerChar()
    if not Toggles.SilentAim then return nil end
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    myPos = myPos.Position
    local closest, closestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        if not isKiller(char) then continue end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local targetPart = char:FindFirstChild(Toggles.AimTargetPart or "Head")
        if not targetPart then continue end
        local dist = (targetPart.Position - myPos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = char
        end
    end
    return closest
end

local function getKillerPart(killerChar)
    if not killerChar then return nil end
    return killerChar:FindFirstChild(Toggles.AimTargetPart or "Head")
end

-- When player fires weapon, redirect to killer
local aimConn = nil
aimConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or not Toggles.SilentAim then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    local killerChar = getKillerChar()
    if not killerChar then return end
    local killerPart = getKillerPart(killerChar)
    if not killerPart then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    local targetPos = killerPart.Position
    local dir = (targetPos - myPos).Unit
    local tool = myChar:FindFirstChildWhichIsA("Tool")
    if not tool then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then tool = bp:FindFirstChildWhichIsA("Tool") end
    end
    if not tool then return end
    local toolName = tool.Name
    local se = getStunEvents()
    if not se then return end
    if toolName == "Shotgun" then
        local remote = se:FindFirstChild("ShotGunStun")
        if remote then
            pcall(function()
                remote:FireServer(dir)
            end)
        end
    elseif toolName == "FlareGun" then
        local remote = se:FindFirstChild("FlareGunStun")
        if remote then
            pcall(function()
                remote:FireServer(dir)
            end)
        end
    end
end)

-- FOV Circle (ScreenGui - follows mouse)
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "bb_fov"
fovGui.ResetOnSpawn = false
fovGui.Enabled = false
fovGui.Parent = CoreGui

local fovFrame = Instance.new("Frame")
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Size = UDim2.new(0, 0, 0, 0)
fovFrame.BackgroundTransparency = 1
fovFrame.Parent = fovGui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(0, 150, 255)
fovStroke.Thickness = 2
fovStroke.Transparency = 0.3
fovStroke.Parent = fovFrame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

-- Killer Warning
local warnGui = Instance.new("ScreenGui")
warnGui.Name = "bb_warn"
warnGui.ResetOnSpawn = false
warnGui.Enabled = false
warnGui.Parent = CoreGui

local warnFrame = Instance.new("Frame")
warnFrame.Size = UDim2.new(0, 400, 0, 36)
warnFrame.Position = UDim2.new(0.5, 0, 0, 40)
warnFrame.AnchorPoint = Vector2.new(0.5, 0)
warnFrame.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
warnFrame.BackgroundTransparency = 0.15
warnFrame.BorderSizePixel = 0
warnFrame.Parent = warnGui

local warnCorner = Instance.new("UICorner")
warnCorner.CornerRadius = UDim.new(0, 8)
warnCorner.Parent = warnFrame

local warnLabel = Instance.new("TextLabel")
warnLabel.Size = UDim2.new(1, -16, 1, 0)
warnLabel.Position = UDim2.new(0, 8, 0, 0)
warnLabel.BackgroundTransparency = 1
warnLabel.Text = "KILLER NEARBY"
warnLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
warnLabel.Font = Enum.Font.GothamBold
warnLabel.TextSize = 18
warnLabel.TextXAlignment = Enum.TextXAlignment.Center
warnLabel.Parent = warnFrame

-- Add killer warning toggle to ESP tab
objSec:Toggle({Name = "Killer Proximity Warn", Flag = "espKillerWarn", Default = true, Callback = mkTog("KillerWarn", true)})

RunService.RenderStepped:Connect(function()
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then warnGui.Enabled = false; return end
    myPos = myPos.Position

    -- FOV follows mouse
    if Toggles.SilentAim and Toggles.ShowFOV then
        fovGui.Enabled = true
        local mouse = UserInputService:GetMouseLocation()
        fovFrame.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
        local r = Toggles.FOVRadius or 200
        fovFrame.Size = UDim2.new(0, r * 2, 0, r * 2)
    else
        fovGui.Enabled = false
    end

    -- Killer proximity warning
    if Toggles.KillerWarn then
        local closestDist = math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local char = plr.Character
            if not char then continue end
            if not isKiller(char) then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local dist = (hrp.Position - myPos).Magnitude
            if dist < closestDist then closestDist = dist end
        end
        if closestDist <= 50 then
            warnGui.Enabled = true
            warnLabel.Text = "KILLER NEARBY [" .. math.floor(closestDist + 0.5) .. "m]"
            local pulse = math.abs(math.sin(tick() * 4))
            warnFrame.BackgroundColor3 = Color3.fromRGB(180, math.floor(20 + pulse * 40), 20)
        else
            warnGui.Enabled = false
        end
    else
        warnGui.Enabled = false
    end
end)

-- Inf Stamina
function toggleInfStamina(enabled)
    if infStamConn then infStamConn:Disconnect(); infStamConn = nil end
    if not enabled then return end
    local char = LocalPlayer.Character
    if not char then
        LocalPlayer.CharacterAdded:Connect(function(c) task.wait(1); toggleInfStamina(true) end)
        return
    end
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    local sprintSpeed = hum.WalkSpeed
    if sprintSpeed < 20 then sprintSpeed = 21 end
    infStamConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() hum.WalkSpeed = sprintSpeed end)
    hum.WalkSpeed = sprintSpeed
end

-- God Mode
local function applyGodMode(char)
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    godModeConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health < 1e9 then hum.Health = math.huge end
    end)
end

function toggleGodMode(enabled)
    if godModeConn then godModeConn:Disconnect(); godModeConn = nil end
    if not enabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.MaxHealth = 100; hum.Health = 100; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end
        end
        return
    end
    local char = LocalPlayer.Character
    if not char then
        LocalPlayer.CharacterAdded:Connect(function(c) task.wait(1); applyGodMode(c) end)
        return
    end
    applyGodMode(char)
end

-- No Ability CD
function toggleNoCD(enabled)
    if noCDConn then noCDConn:Disconnect(); noCDConn = nil end
    if not enabled then return end
    noCDConn = RunService.RenderStepped:Connect(function()
        local extra = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
            and LocalPlayer.PlayerGui:FindFirstChild("ExtraStuff")
        if not extra then return end
        local killerStuff = extra:FindFirstChild("KillerStuff")
        if killerStuff then
            local tg = killerStuff:FindFirstChild("TrapGUI")
            if tg then
                local shift = tg:FindFirstChild("Shift")
                if shift then
                    local cd = shift:FindFirstChild("Cooldown")
                    if cd and cd:IsA("TextLabel") and cd.Text ~= "Ready" then cd.Text = "Ready" end
                end
                local tp = tg:FindFirstChild("Teleport")
                if tp then
                    local cd = tp:FindFirstChild("Cooldown")
                    if cd and cd:IsA("TextLabel") and cd.Text ~= "Ready" then cd.Text = "Ready" end
                end
                local stalk = tg:FindFirstChild("StalkButton")
                if stalk then
                    local timer = stalk:FindFirstChild("Timer")
                    if timer and timer:IsA("TextLabel") then timer.Text = "30" end
                end
                local pf = tg:FindFirstChild("PowerUpFrame")
                if pf then
                    local kp = pf:FindFirstChild("KillerPower")
                    if kp then
                        local t = kp:FindFirstChild("Timer")
                        if t and t:IsA("TextLabel") then t.Text = "30" end
                    end
                end
            end
        end
        -- Counselor ability cooldowns (Sprint/Stun recovery)
        local counselorStuff = extra:FindFirstChild("CounselorStuff")
        if counselorStuff then
            for _, gui in ipairs(counselorStuff:GetDescendants()) do
                if gui:IsA("TextLabel") and gui.Name == "Timer" then
                    local parent = gui.Parent
                    if parent and parent:IsA("Frame") then
                        local name = parent.Name:lower()
                        if name:find("sprint") or name:find("stun") or name:find("recover") then
                            gui.Text = "0"
                        end
                    end
                end
            end
        end
    end)
end

-- Backpack Bypass
local toolProtectionConns = {}
local function protectTool(tool, bp)
    if not tool:IsA("Tool") then return end
    if toolProtectionConns[tool] then
        pcall(function() toolProtectionConns[tool]:Disconnect() end)
    end
    local conn
    conn = tool:GetPropertyChangedSignal("Parent"):Connect(function()
        if not Toggles.BackpackBypass then
            if conn then conn:Disconnect(); toolProtectionConns[tool] = nil end
            return
        end
        local newParent = tool.Parent
        -- Allow: backpack, character, nil (briefly during equip)
        if newParent == bp or newParent == LocalPlayer.Character then return end
        task.wait(0.08)
        if Toggles.BackpackBypass and tool:IsA("Tool") then
            local curParent = tool.Parent
            if curParent ~= bp and curParent ~= LocalPlayer.Character then
                tool.Parent = bp
            end
        end
    end)
    toolProtectionConns[tool] = conn
end

function toggleBackpackBypass(enabled)
    for _, c in pairs(toolProtectionConns) do pcall(function() c:Disconnect() end) end
    toolProtectionConns = {}
    if not enabled then return end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then
        local conn
        conn = LocalPlayer.ChildAdded:Connect(function(c)
            if c.Name == "Backpack" and Toggles.BackpackBypass then
                toggleBackpackBypass(true)
                if conn then conn:Disconnect() end
            end
        end)
        return
    end
    -- Protect existing tools
    for _, v in ipairs(bp:GetChildren()) do protectTool(v, bp) end
    -- Protect new tools entering backpack
    bp.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then task.wait(0.05); protectTool(child, bp) end
    end)
    -- Also protect tools equipped to character from being dropped
    local char = LocalPlayer.Character
    if char then
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and Toggles.BackpackBypass then task.wait(0.05); protectTool(child, bp) end
        end)
    end
end

-- Auto-Pick 2 Pocket Knives
local pickedKnives = {}
function toggleAutoPick(enabled)
    if autoPickConn then autoPickConn:Disconnect(); autoPickConn = nil end
    pickedKnives = {}
    if not enabled then return end
    autoPickConn = RunService.RenderStepped:Connect(function()
        if not Toggles.AutoPickKnives then return end
        local items = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Items")
        if not items then return end
        local count = 0
        if LocalPlayer.Character then
            for _, t in ipairs(LocalPlayer.Character:GetChildren()) do
                if t:IsA("Tool") and t.Name == "PocketKnife" then count = count + 1 end
            end
        end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and t.Name == "PocketKnife" then count = count + 1 end
            end
        end
        if count >= 2 then return end
        for _, v in ipairs(items:GetChildren()) do
            if count >= 2 then break end
            if v.Name ~= "PocketKnife" then continue end
            if pickedKnives[v] then continue end
            local pp = v:FindFirstChild("ProximityPrompt")
            if pp and pp.Enabled then
                pcall(function() fireproximityprompt(pp) end)
                pickedKnives[v] = true
                count = count + 1
            end
        end
    end)
end

-- Highlight functions
function addCharm(instance, color, labelText, isModel)
    if charms[instance] then return end
    local highlight
    if isModel and instance:IsA("Model") then
        highlight = Instance.new("Highlight"); highlight.Adornee = instance
    elseif instance:IsA("BasePart") then
        highlight = Instance.new("Highlight"); highlight.Adornee = instance
    else return end
    highlight.Name = "bb_charm"
    highlight.FillColor = color
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = CoreGui
    charms[instance] = highlight
    if labelText then
        local adornee = isModel and (instance:FindFirstChild("HumanoidRootPart") or instance:FindFirstChildWhichIsA("BasePart")) or instance
        if adornee then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 160, 0, 20)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText .. " [0m]"
            lbl.TextColor3 = color
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 14
            lbl.TextStrokeTransparency = 0.2
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.Visible = false
            lbl.Parent = distPool
            distLabels[instance] = {lbl = lbl, adornee = adornee, baseText = labelText, color = color}
        end
    end
end

function removeCharm(instance)
    local hl = charms[instance]
    if hl then hl:Destroy(); charms[instance] = nil end
    local dl = distLabels[instance]
    if dl and dl.lbl then dl.lbl:Destroy(); distLabels[instance] = nil end
end

function isKiller(char) return char:FindFirstChild("Killer") ~= nil end

-- Scan functions
function scanWindows()
    if not Toggles.Window then return end
    local wm = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Window")
    if not wm then return end
    local wp = wm:FindFirstChild("Window")
    if wp and wp:IsA("BasePart") then addCharm(wp, Colors.Window, "Window") end
end

function scanBearTraps()
    if not Toggles.BearTrap then return end
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    for _, c in ipairs(map:GetChildren()) do
        if c.Name == "Bear_Trap" and c:IsA("BasePart") then addCharm(c, Colors.BearTrap, "Bear Trap") end
    end
end

function scanRadios()
    if not Toggles.Radio then return end
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    for _, c in ipairs(map:GetChildren()) do
        if c.Name == "Radio" and c:IsA("BasePart") then addCharm(c, Colors.Radio, "Radio") end
    end
end

function scanItems()
    local items = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Items")
    if not items then return end
    for _, item in ipairs(items:GetChildren()) do
        if not item:IsA("BasePart") then continue end
        local toggleKey = item.Name
        if Toggles[toggleKey] and Colors[toggleKey] then addCharm(item, Colors[toggleKey], item.Name) end
    end
end

function scanPhoneBox()
    if not Toggles.PhoneBox then return end
    local pe = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("PhoneEscape")
    if not pe then return end
    for _, c in ipairs(pe:GetDescendants()) do
        if not c:IsA("BasePart") then continue end
        if c.Name == "Panel" then addCharm(c, Colors.PhoneBox, "Phone Box") end
    end
    local pb = pe:FindFirstChild("PowerBox")
    if pb then
        for _, p in ipairs(pb:GetDescendants()) do
            if p:IsA("BasePart") then addCharm(p, Colors.PhoneBox, "Fuse Box") end
        end
    end
end

function scanCarEscape()
    if not Toggles.CarEscape then return end
    local ce = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("CarEscape")
    if not ce then return end
    local car = ce:FindFirstChild("Car")
    if not car then return end
    local body = car:FindFirstChild("Body")
    if not body then return end
    for _, c in ipairs(body:GetChildren()) do
        if PromptNames[c.Name] and c:IsA("BasePart") then addCharm(c, Colors.CarEscape, PromptNames[c.Name] .. " (Car)") end
    end
end

function scanBoatEscape()
    if not Toggles.BoatEscape then return end
    local be = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("BoatEscape")
    if not be then return end
    local boat = be:FindFirstChild("Boat")
    if not boat then return end
    for _, c in ipairs(boat:GetChildren()) do
        if PromptNames[c.Name] and c:IsA("BasePart") then addCharm(c, Colors.BoatEscape, PromptNames[c.Name] .. " (Boat)") end
    end
end

function scanPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if not char then continue end
        if plr == LocalPlayer then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp:IsA("BasePart") then continue end
        if isKiller(char) and Toggles.Killer then
            addCharm(char, Colors.Killer, "KILLER - " .. plr.Name, true)
        elseif Toggles.Survivor then
            addCharm(char, Colors.Survivor, plr.Name, true)
        end
    end
end

-- Update distances every frame
RunService.RenderStepped:Connect(function()
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then
        for _, dl in pairs(distLabels) do if dl.lbl then dl.lbl.Visible = false end end
        return
    end
    myPos = myPos.Position
    local viewSize = cam.ViewportSize
    local screenCX, screenCY = viewSize.X / 2, viewSize.Y / 2
    for instance, dl in pairs(distLabels) do
        if not dl.adornee or not dl.adornee.Parent then
            if dl.lbl then dl.lbl.Visible = false end
            continue
        end
        local dist = (dl.adornee.Position - myPos).Magnitude
        local screenPos = cam:WorldToViewportPoint(dl.adornee.Position)
        local onScreen = screenPos.Z > 0
        if not onScreen then
            local dir = (dl.adornee.Position - myPos).Unit
            local angle = math.atan2(dir.X, -dir.Z)
            local edgeX = screenCX + math.sin(angle) * (screenCX - 20)
            local edgeY = screenCY - math.cos(angle) * (screenCY - 20)
            edgeX = math.clamp(edgeX, 4, viewSize.X - 164)
            edgeY = math.clamp(edgeY, 4, viewSize.Y - 24)
            dl.lbl.Position = UDim2.new(0, edgeX, 0, edgeY)
            dl.lbl.Text = dl.baseText .. " [" .. math.floor(dist + 0.5) .. "m] \xE2\x96\xB2"
            dl.lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            dl.lbl.Visible = true
        else
            local x, y = screenPos.X - 80, screenPos.Y - 30
            x = math.clamp(x, 4, viewSize.X - 164)
            y = math.clamp(y, 4, viewSize.Y - 24)
            dl.lbl.Position = UDim2.new(0, x, 0, y)
            dl.lbl.Text = dl.baseText .. " [" .. math.floor(dist + 0.5) .. "m]"
            dl.lbl.TextColor3 = dl.color
            dl.lbl.Visible = true
        end
    end
end)

-- Scan loop
local tick = 0
RunService.RenderStepped:Connect(function(dt)
    tick = tick + dt
    if tick < 0.3 then return end
    tick = 0
    scanPlayers()
    scanWindows()
    scanBearTraps()
    scanRadios()
    scanItems()
    scanPhoneBox()
    scanCarEscape()
    scanBoatEscape()
end)

Players.PlayerRemoving:Connect(function(plr)
    local char = plr.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then removeCharm(hrp) end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(1)
    if Toggles.InfStamina then toggleInfStamina(true) end
    if Toggles.GodMode then applyGodMode(c) end
    if Toggles.NoCD then toggleNoCD(true) end
    if Toggles.BackpackBypass then toggleBackpackBypass(true) end
    if Toggles.AutoPickKnives then toggleAutoPick(true) end
end)

Window:Init()
