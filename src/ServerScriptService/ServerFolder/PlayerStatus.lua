-- This module contains the current status of each player, for checks in if statements and stuff like that.

local Players = game:GetService("Players")

local PlayerStatus: {[Player]: string} = {}

function PlayerStatus.OnLoad()
    Players.PlayerAdded:Connect(function(player)
        PlayerStatus[player] = "Lobby"
    end)

    Players.PlayerRemoving:Connect(function(player)
        PlayerStatus[player] = nil
    end)
end

return PlayerStatus