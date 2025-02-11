-- This updates kills done by each player, and fires events to every player which will add them to the kill score.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)
local ItemDrops = Library.ItemDrops

local Leaderboard = {
    LastHit = {},
    Kills = {}
}

function Leaderboard.UpdateLastHit(player: Player, hitBy: Player)
    Leaderboard.LastHit[player] = hitBy
end

function Leaderboard.AddKill(player: Player, killedBy: Player)
    if not Leaderboard.Kills[killedBy.Name] then
        Leaderboard.Kills[killedBy.Name] = {}
    end

    table.insert(Leaderboard.Kills[killedBy.Name], player)
    ReplicatedStorage.Events.UpdateKill:FireAllClients(player, killedBy)
    ItemDrops.RollForDrop(player)
end

function Leaderboard.ResetCounting()
    ReplicatedStorage.Events.MatchEnded:FireAllClients(Leaderboard.Kills)
    print(Leaderboard.Kills)
end

return Leaderboard
