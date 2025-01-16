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
        (player.Character or player.CharacterAdded:Wait()):WaitForChild("Humanoid").WalkSpeed = 16
        
        local character = player.Character or player.CharacterAdded:Wait()
        character:MoveTo(Vector3.new(math.random(0, 50), 2, math.random(0, 50)))

        ReplicatedStorage.Events.PlayerJoinedGame:FireClient(player)
    end)
end

return PlayerExitLobby