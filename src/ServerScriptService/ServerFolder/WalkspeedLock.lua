local Players = game:GetService("Players")
local Library = require(script.Parent.Parent.Library)

local WalkspeedLock = {}

function WalkspeedLock.OnLoad()
    Players.PlayerAdded:Connect(function(player) -- When you enter the game, your character's walkspeed is defaulted to 0
        local character = player.Character or player.CharacterAdded:Wait()
        character:WaitForChild("Humanoid").WalkSpeed = 0
    end)
end

return WalkspeedLock