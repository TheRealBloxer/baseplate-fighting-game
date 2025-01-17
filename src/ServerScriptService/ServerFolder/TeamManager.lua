local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local Library = require(script.Parent.Parent.Library)
local DataState = Library.DataState

local TeamManager = {
    Red = {},
    Blue = {}
}

local _Connections = DataState.new("TeamManager")

local redTeam: Team
local blueTeam: Team

function TeamManager.CreateTeams()
    redTeam = Instance.new("Team")

    redTeam.Parent = Teams
    redTeam.Name = "Red"
    redTeam.TeamColor = BrickColor.Red()
    redTeam.AutoAssignable = true

    blueTeam = Instance.new("Team")

    blueTeam.Parent = Teams
    blueTeam.Name = "Blue"
    blueTeam.TeamColor = BrickColor.Blue()
    blueTeam.AutoAssignable = true

    local nextTeam = redTeam

    for _, player: Player in pairs(Players:GetPlayers()) do
        player.Team = nextTeam
        
        if nextTeam == redTeam then
            nextTeam = blueTeam
        else
            nextTeam = redTeam
        end
    end

    _Connections:AddTo("Connections", {
        redTeam.PlayerAdded:Connect(function(player)
            table.insert(TeamManager.Red, player)
        end),

        redTeam.PlayerRemoved:Connect(function(player)
            table.remove(TeamManager.Red, table.find(TeamManager.Red, player))
        end),

        blueTeam.PlayerAdded:Connect(function(player)
            table.insert(TeamManager.Blue, player)
        end),

        blueTeam.PlayerRemoved:Connect(function(player)
            table.remove(TeamManager.Blue, table.find(TeamManager.Blue, player))
        end)
    })
end

function TeamManager.RemoveTeams()
    _Connections:Dump()

    if redTeam then
        redTeam:Destroy()
    end

    if blueTeam then
        blueTeam:Destroy()
    end

    for index: number, _ in pairs(TeamManager.Red) do
        table.remove(TeamManager.Red, index)
    end

    for index: number, _ in pairs(TeamManager.Blue) do
        table.remove(TeamManager.Blue, index)
    end
end

return TeamManager
