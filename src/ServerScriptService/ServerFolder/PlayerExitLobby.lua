-- When a player requests to leave the lobby, this module runs checks and if it can be done, sets it up.

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

        local character = player.Character or player.CharacterAdded:Wait()

        PlayerStatus[player] = "Game"

        if RoundSystem.MatchStarted then
            character:WaitForChild("Humanoid").WalkSpeed = 30
        end
        
        character:MoveTo(Vector3.new(math.random(0, 50), 2, math.random(0, 50))) -- Randomize player position

        ReplicatedStorage.Events.PlayerJoinedGame:FireClient(player) -- Fire event to player so they can initialize their client modules meant for gameplay
    end)
end

return PlayerExitLobby