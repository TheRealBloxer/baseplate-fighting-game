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
local ROUND_LENGTH = 20

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
    ReplicatedStorage.GameStats.GameMode.Value = "Intermission"
    timeLeft.Value = INTERMISSION_LENGTH

    RoundSystem.Countdown()

    timeLeft.Value = VOTING_LENGTH
    VotingSystem.StartVoting()

    task.spawn(function()
        task.wait(0.5)
        ReplicatedStorage.GameStats.GameMode.Value = "Voting"
    end)

    RoundSystem.Countdown()

    ReplicatedStorage.GameStats.GameMode.Value = VotingSystem.EndVoting()

    RoundSystem.StartMatch()

    timeLeft.Value = ROUND_LENGTH
    RoundSystem.Countdown()

    for _, player: Player in pairs(Players:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
    
        if PlayerStatus[player] == "Game" then
            character.Humanoid:TakeDamage(1000)
            PlayerStatus[player] = "Lobby"
        end
    end

    RoundSystem.NewRound()
end

function RoundSystem.Countdown()
    while task.wait(1) and timeLeft.Value > 0 do
        timeLeft.Value -= 1
    end
end

function RoundSystem.StartMatch()
    for _, player: Player in pairs(Players:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
        
        character.Humanoid.WalkSpeed = 0
        character:MoveTo(Vector3.new(math.random(0, 50), 2, math.random(0, 50)))
    end

    timeLeft.Value = 5
    RoundSystem.Countdown()

    for _, player: Player in pairs(Players:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
        character.Humanoid.WalkSpeed = 16
    end
end

return RoundSystem