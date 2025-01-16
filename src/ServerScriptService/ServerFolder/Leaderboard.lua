local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
end

function Leaderboard.ResetCounting()
    ReplicatedStorage.Events.MatchEnded:FireAllClients(Leaderboard.Kills)
    print(Leaderboard.Kills)
end

return Leaderboard
