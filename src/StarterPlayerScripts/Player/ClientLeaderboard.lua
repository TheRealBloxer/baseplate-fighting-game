--[[
    Displays kills and leaderboard post-game 
]]

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

    _Connections:AddTo("LeaderboardConnections", { -- Kill score part
        ReplicatedStorage.Events.UpdateKill.OnClientEvent:Connect(function(playerKilled: Player, killedBy: Player)
            local newKill = killScoreUI.KillList.Template:Clone()

            if ReplicatedStorage.GameStats.GameMode.Value == "Team Deathmatch" then
                newKill.BackgroundColor3 = killedBy.TeamColor.Color
            end

            if killedBy == Library.Player then
                newKill.UIStroke.Enabled = true
                newKill.UIStroke.Color = Color3.new(0, 0.5, 0)
            elseif playerKilled == Library.Player.Character then
                newKill.UIStroke.Enabled = true
                newKill.UIStroke.Color = Color3.new(0.5, 0, 0)
            end

            newKill.Name = playerKilled.Name..killedBy.Name
            newKill.Description.Text = killedBy.Name.." -> "..playerKilled.Name
            newKill.Parent = killScoreUI.KillList
            newKill.LayoutOrder = -totalKillCount

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

    for player, killList in pairs(kills) do -- Post-game leaderboard
        local newPosition = leaderboardUI.Container.List.Template:Clone()
        newPosition.Name = player
        newPosition.Parent = leaderboardUI.Container.List
        newPosition.LayoutOrder = table.find(killRanking, player)

        newPosition.Kills.Text = #killList
        newPosition.Player.Text = player
        newPosition.Ranking.Text = table.find(killRanking, player)

        newPosition.Visible = true
    end

    task.spawn(function()
        task.wait(5)
        
        for _, instance: Instance in pairs(leaderboardUI.Container.List:GetChildren()) do
            if instance.Name ~= "Template" then
                instance:Destroy()
            end
        end
        
        leaderboardUI.Enabled = false
    end)
end)

return ClientLeaderboard