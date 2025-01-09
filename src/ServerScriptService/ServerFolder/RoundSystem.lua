local Players = game:GetService("Players")

local Library = require(script.Parent.Parent.Library)

local PlayerStatus = Library.PlayerStatus

local RoundSystem = {}

local ROUND_LENGTH = 5

local timeLeft = 0
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
    timeLeft = ROUND_LENGTH

    task.spawn(function()
        RoundSystem.PlayRound()
    end)
end

function RoundSystem.PlayRound()
    while task.wait(1) and timeLeft > 0 do
        timeLeft -= 1
        print(timeLeft)
    end

    for _, player: Player in pairs(Players:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()

        if PlayerStatus[player] == "In Game" then
            character.Humanoid:TakeDamage(1000)
        end
    end
end

return RoundSystem