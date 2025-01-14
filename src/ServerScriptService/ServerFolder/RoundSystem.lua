local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local PlayerStatus = Library.PlayerStatus
local VotingSystem = Library.VotingSystem

local RoundSystem = {
    GameMode = "Intermission"
}

local INTERMISSION_LENGTH = 10
local VOTING_LENGTH = 10
local ROUND_LENGTH = 10

local timeLeft = ReplicatedStorage.GameStats.TimeLeft

local playersConnected = 0

function RoundSystem.OnLoad()
    Players.PlayerAdded:Connect(function(player)
        playersConnected += 1

        if playersConnected == 1 then
            RoundSystem.NewRound()
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        playersConnected -= 1
    end)
end

function RoundSystem.NewRound()
    RoundSystem.GameMode = "Intermission"
    timeLeft.Value = INTERMISSION_LENGTH

    RoundSystem.Countdown()

    RoundSystem.GameMode = "Voting"
    timeLeft.Value = VOTING_LENGTH
    VotingSystem.StartVoting()

    RoundSystem.Countdown()

    RoundSystem.GameMode = VotingSystem.EndVoting()
    timeLeft.Value = ROUND_LENGTH

    task.spawn(function()
        RoundSystem.Countdown()

        for _, player: Player in pairs(Players:GetPlayers()) do
            local character = player.Character or player.CharacterAdded:Wait()
    
            if PlayerStatus[player] == "Game" then
                character.Humanoid:TakeDamage(1000)
                PlayerStatus[player] = "Lobby"
            end
        end
    end)
end

function RoundSystem.Countdown()
    while task.wait(1) and timeLeft.Value > 0 do
        timeLeft.Value -= 1
    end
end

return RoundSystem