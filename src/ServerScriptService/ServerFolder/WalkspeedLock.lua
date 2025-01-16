local Players = game:GetService("Players")
local Library = require(script.Parent.Parent.Library)

local WalkspeedLock = {}

function WalkspeedLock.OnLoad()
    Players.PlayerAdded:Connect(function(player)
        local character = player.Character or player.CharacterAdded:Wait()
        character:WaitForChild("Humanoid").WalkSpeed = 0
    end)
end

return WalkspeedLock