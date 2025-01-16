local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local Leaderboard = Library.Leaderboard
local PlayerStatus = Library.PlayerStatus
local VotingSystem = Library.VotingSystem

local RoundSystem = {}

local INTERMISSION_LENGTH = 10
local VOTING_LENGTH = 5
local ROUND_LENGTH = 20

local gameMode = ReplicatedStorage.GameStats.GameMode
local timeLeft = ReplicatedStorage.GameStats.TimeLeft

local playersConnected = 0

function RoundSystem.OnLoad()
    Players.PlayerAdded:Connect(function()
        playersConnected += 1

        if playersConnected == 1 then
            RoundSystem.NewRound()
        end
    end)

    Players.PlayerRemoving:Connect(function()
        playersConnected -= 1
    end)
end

function RoundSystem.NewRound()
    task.spawn(function()
        task.wait(0.5)
        gameMode.Value = "Intermission"
    end)

    timeLeft.Value = INTERMISSION_LENGTH

    RoundSystem.Countdown()

    timeLeft.Value = VOTING_LENGTH
    VotingSystem.StartVoting()

    task.spawn(function()
        task.wait(0.5)
        gameMode.Value = "Voting"
    end)

    RoundSystem.Countdown()

    gameMode.Value = VotingSystem.EndVoting()

    RoundSystem.StartMatch()

    timeLeft.Value = ROUND_LENGTH
    RoundSystem.Countdown()

    RoundSystem.EndMatch()
    RoundSystem.NewRound()
end

function RoundSystem.Countdown()
    while task.wait(1) and timeLeft.Value > 0 do
        timeLeft.Value -= 1
    end
end

function RoundSystem.StartMatch()
    timeLeft.Value = 5
    RoundSystem.Countdown()

    for _, player: Player in pairs(Players:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
        character.Humanoid.WalkSpeed = 16
    end
end

function RoundSystem.EndMatch()
    for _, player: Player in pairs(Players:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
    
        if PlayerStatus[player] == "Game" then
            character.Humanoid:TakeDamage(1000)
            PlayerStatus[player] = "Lobby"
        end
    end

    task.spawn(function()
        task.wait(5)
        Leaderboard.ResetCounting()
    end)
end

return RoundSystem