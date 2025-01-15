local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Leaderboard = {
    LastHit = {},
    Kills = {}
}

function Leaderboard.UpdateLastHit(player: Player, hitBy: Player)
    Leaderboard.LastHit[player] = hitBy
end

function Leaderboard.AddKill(player: Player, killedBy: Player)
    if not Leaderboard.Kills[player] then
        Leaderboard.Kills[player] = {}
    end

    table.insert(Leaderboard.Kills[player], killedBy)
    ReplicatedStorage.Events.UpdateKill:FireAllClients(player, killedBy)
end

return Leaderboard
