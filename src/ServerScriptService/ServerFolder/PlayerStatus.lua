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