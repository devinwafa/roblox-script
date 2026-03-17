local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)
Frame.Active = true
Frame.Draggable = true

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.703, 0, 0.491, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "FLY"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "FLY GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextScaled = true

speedLabel.Name = "speed"
speedLabel.Parent = Frame
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speedLabel.Position = UDim2.new(0.468, 0, 0.491, 0)
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Text = "1"
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextScaled = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231, 0, 0.491, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextScaled = true

closebutton.Name = "Close"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = Enum.Font.SourceSans
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position = UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = Enum.Font.SourceSans
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = Enum.Font.SourceSans
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

-- State
local speeds = 1
local nowe = false
local tpwalking = false
local flyObjects = {} -- simpan BodyGyro & BodyVelocity untuk cleanup

local player = Players.LocalPlayer

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FLY GUI V3",
    Text = "BY XNEO",
    Duration = 5,
})

-- ============================================================
-- CORE FLY LOGIC
-- ============================================================
local function startFly()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local isR6 = hum.RigType == Enum.HumanoidRigType.R6
    local torso = isR6 and char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return end

    -- Disable hanya state yang perlu untuk fly (BUKAN semua state)
    -- Ini kunci agar tool/senjata tetap bisa dipakai
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Freefall and nowe then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end)

    -- Tidak pakai PlatformStand agar tool tetap bisa digunakan
    local bg = Instance.new("BodyGyro", torso)
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = torso.CFrame

    local bv = Instance.new("BodyVelocity", torso)
    bv.Velocity = Vector3.new(0, 0.1, 0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    flyObjects.bg = bg
    flyObjects.bv = bv
    flyObjects.torso = torso

    -- Speed walk loop
    tpwalking = true
    for i = 1, speeds do
        task.spawn(function()
            local hb = RunService.Heartbeat
            while tpwalking and nowe do
                hb:Wait()
                local c = player.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h and h.MoveDirection.Magnitude > 0 then
                    c:TranslateBy(h.MoveDirection * speeds * 0.5)
                end
            end
        end)
    end

    -- Fly movement loop
    local ctrl = {f=0, b=0, l=0, r=0}
    local lastctrl = {f=0, b=0, l=0, r=0}
    local maxspeed = 50
    local spd = 0

    -- Input
    local inputConn1 = UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.W then ctrl.f = 1
        elseif inp.KeyCode == Enum.KeyCode.S then ctrl.b = -1
        elseif inp.KeyCode == Enum.KeyCode.A then ctrl.l = -1
        elseif inp.KeyCode == Enum.KeyCode.D then ctrl.r = 1
        end
    end)
    local inputConn2 = UserInputService.InputEnded:Connect(function(inp, gp)
        if inp.KeyCode == Enum.KeyCode.W then ctrl.f = 0
        elseif inp.KeyCode == Enum.KeyCode.S then ctrl.b = 0
        elseif inp.KeyCode == Enum.KeyCode.A then ctrl.l = 0
        elseif inp.KeyCode == Enum.KeyCode.D then ctrl.r = 0
        end
    end)

    flyObjects.inputConn1 = inputConn1
    flyObjects.inputConn2 = inputConn2

    local cam = workspace.CurrentCamera

    while nowe do
        RunService.RenderStepped:Wait()

        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            spd = math.min(spd + 0.5 + (spd / maxspeed), maxspeed)
        elseif spd ~= 0 then
            spd = math.max(spd - 1, 0)
        end

        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.Velocity = ((cam.CFrame.LookVector * (ctrl.f + ctrl.b))
                + ((cam.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0)).Position
                - cam.CFrame.Position)) * spd
            lastctrl = {f=ctrl.f, b=ctrl.b, l=ctrl.l, r=ctrl.r}
        elseif spd ~= 0 then
            bv.Velocity = ((cam.CFrame.LookVector * (lastctrl.f + lastctrl.b))
                + ((cam.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0)).Position
                - cam.CFrame.Position)) * spd
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end

        bg.CFrame = cam.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * spd / maxspeed), 0, 0)
    end
end

local function stopFly()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    tpwalking = false

    if flyObjects.bg then flyObjects.bg:Destroy() end
    if flyObjects.bv then flyObjects.bv:Destroy() end
    if flyObjects.inputConn1 then flyObjects.inputConn1:Disconnect() end
    if flyObjects.inputConn2 then flyObjects.inputConn2:Disconnect() end
    flyObjects = {}

    if hum then
        -- Restore semua state
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        hum.PlatformStand = false
    end
end

-- ============================================================
-- TOGGLE FLY
-- ============================================================
onof.MouseButton1Click:Connect(function()
    nowe = not nowe
    if nowe then
        onof.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        onof.Text = "ON"
        task.spawn(startFly)
    else
        onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
        onof.Text = "FLY"
        stopFly()
    end
end)

-- ============================================================
-- UP / DOWN (tahan tombol)
-- ============================================================
local upHeld = false
local downHeld = false

up.MouseButton1Down:Connect(function() upHeld = true end)
up.MouseButton1Up:Connect(function() upHeld = false end)
up.MouseLeave:Connect(function() upHeld = false end)

down.MouseButton1Down:Connect(function() downHeld = true end)
down.MouseButton1Up:Connect(function() downHeld = false end)
down.MouseLeave:Connect(function() downHeld = false end)

RunService.RenderStepped:Connect(function()
    if not nowe then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if upHeld then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 1, 0)
    elseif downHeld then
        hrp.CFrame = hrp.CFrame * CFrame.new(0, -1, 0)
    end
end)

-- ============================================================
-- SPEED +/-
-- ============================================================
local function refreshSpeedLoops()
    if not nowe then return end
    tpwalking = false
    task.wait(0.1)
    tpwalking = true
    for i = 1, speeds do
        task.spawn(function()
            local hb = RunService.Heartbeat
            while tpwalking and nowe do
                hb:Wait()
                local c = player.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h and h.MoveDirection.Magnitude > 0 then
                    c:TranslateBy(h.MoveDirection * speeds * 0.5)
                end
            end
        end)
    end
end

plus.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speedLabel.Text = speeds
    refreshSpeedLoops()
end)

mine.MouseButton1Click:Connect(function()
    if speeds <= 1 then
        speedLabel.Text = "min!"
        task.delay(1, function() speedLabel.Text = tostring(speeds) end)
        return
    end
    speeds = speeds - 1
    speedLabel.Text = speeds
    refreshSpeedLoops()
end)

-- ============================================================
-- RESPAWN HANDLER
-- ============================================================
player.CharacterAdded:Connect(function()
    task.wait(0.7)
    nowe = false
    tpwalking = false
    flyObjects = {}
    onof.Text = "FLY"
    onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
    end
end)

-- ============================================================
-- UI BUTTONS
-- ============================================================
closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    for _, v in ipairs({up, down, onof, plus, speedLabel, mine, mini}) do
        v.Visible = false
    end
    mini2.Visible = true
    Frame.BackgroundTransparency = 1
    closebutton.Position = UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
    for _, v in ipairs({up, down, onof, plus, speedLabel, mine, mini}) do
        v.Visible = true
    end
    mini2.Visible = false
    Frame.BackgroundTransparency = 0
    closebutton.Position = UDim2.new(0, 0, -1, 27)
end)
