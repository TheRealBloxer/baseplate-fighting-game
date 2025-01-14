local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local PlayerStatus = Library.PlayerStatus
local RoundSystem = Library.RoundSystem

local PlayerExitLobby = {}

function PlayerExitLobby.OnLoad()
    ReplicatedStorage.Events.PlayerLeavingLobby.OnServerEvent:Connect(function(player)
        if RoundSystem.GameMode ~= "Free For All" or RoundSystem.GameMode ~= "Team Deathmatch" then
            return
        end

        PlayerStatus[player] = "Game"
        ReplicatedStorage.Events.PlayerJoinedGame:FireClient(player)
    end)
end

return PlayerExitLobby