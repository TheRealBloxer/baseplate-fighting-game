local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local PlayerStatus = Library.PlayerStatus
local RoundSystem = Library.RoundSystem

local PlayerExitLobby = {}

function PlayerExitLobby.OnLoad()
    ReplicatedStorage.Events.PlayerLeavingLobby.OnServerEvent:Connect(function(player)
        if ReplicatedStorage.GameStats.GameMode.Value ~= "Free For All" and ReplicatedStorage.GameStats.GameMode.Value ~= "Team Deathmatch" then
            return
        end

        PlayerStatus[player] = "Game"
        ReplicatedStorage.Events.PlayerJoinedGame:FireClient(player)
    end)
end

return PlayerExitLobby