local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)
local DataState = Library.DataState

local ClientLeaderboard = {}

type KillScoreUI = ScreenGui & {
    KillList: ScrollingFrame & {
        Template: Frame & {
            Description: TextLabel
        }
    }
}

type LeaderboardUI = ScreenGui & {
    Container: Frame & {
        List: ScrollingFrame & {
            Template: Frame & {
                Ranking: TextLabel,
                Player: TextLabel,
                Kills: TextLabel
            }
        }
    }
}

function ClientLeaderboard.OnGameStart()
    local _Connections = DataState.new("Leaderboard")
    local totalKillCount = 0
    local killScoreUI: KillScoreUI = Library.PlayerGui.KillScoreUI

    _Connections:AddTo("LeaderboardConnections", {
        ReplicatedStorage.Events.UpdateKill.OnClientEvent:Connect(function(playerKilled: Player, killedBy: Player)
            local newKill = killScoreUI.KillList.Template:Clone()

            newKill.Name = playerKilled.Name..killedBy.Name
            newKill.Description.Text = killedBy.Name.." -> "..playerKilled.Name
            newKill.Parent = killScoreUI.KillList
            newKill.LayoutOrder = -totalKillCount

            if killedBy == Library.Player then
                newKill.BackgroundColor3 = Color3.new(0, 0.5, 0)
            elseif playerKilled == Library.Player then
                newKill.BackgroundColor3 = Color3.new(0.5, 0, 0)
            end

            newKill.Visible = true

            totalKillCount += 1
        end)
    })
end

ReplicatedStorage.Events.MatchEnded.OnClientEvent:Connect(function(kills: {[string]: {Player}})
    local leaderboardUI: LeaderboardUI = Library.PlayerGui.LeaderboardUI
    local killRanking = {}

    for player, _ in pairs(kills) do
        table.insert(killRanking, player)
    end

    table.sort(killRanking, function(a, b)
        return #kills[a] > #kills[b]
    end)

    leaderboardUI.Enabled = true

    for player, killList in pairs(kills) do
        local newPosition = leaderboardUI.Container.List.Template:Clone()
        newPosition.Name = player
        newPosition.Parent = leaderboardUI.Container.List
        newPosition.LayoutOrder = table.find(killRanking, player)

        newPosition.Kills.Text = #killList
        newPosition.Player.Text = player
        newPosition.Ranking.Text = table.find(killRanking, player)

        newPosition.Visible = true
    end
end)

return ClientLeaderboard