local vim = game:GetService("VirtualInputManager")
local uis = game:GetService("UserInputService")

local aktif = false

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.X then
        aktif = not aktif
        print("Auto Z:", aktif)
    end
end)

while true do
    if aktif then
        vim:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
    end
    
    task.wait(1)
end
