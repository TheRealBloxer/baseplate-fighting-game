local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local DataState = Library.DataState

local VotingSystem = {}

local _VotingConnections = DataState.new("VotingConnections")

local freeForAllVotes = {}
local teamDeathmatchVotes = {}

function VotingSystem.StartVoting()
    ReplicatedStorage.Events.VotingBegan:FireAllClients()

    _VotingConnections:AddTo("Connections", {
        ReplicatedStorage.Events.VoteForFreeForAll.OnServerEvent:Connect(function(player)
            local newVotePlayerIndex = table.find(freeForAllVotes, player)
            local previousPlayerVoteIndex = table.find(teamDeathmatchVotes, player)

            if newVotePlayerIndex then
                table.remove(freeForAllVotes, newVotePlayerIndex)
            else
                table.insert(freeForAllVotes, player)
            end

            if previousPlayerVoteIndex then
                table.remove(teamDeathmatchVotes, previousPlayerVoteIndex)
            end

            ReplicatedStorage.Events.VotingChanged:FireAllClients(freeForAllVotes, teamDeathmatchVotes)
        end),

        ReplicatedStorage.Events.VoteForTeamDeathmatch.OnServerEvent:Connect(function(player)
            local newVotePlayerIndex = table.find(teamDeathmatchVotes, player)
            local previousPlayerVoteIndex = table.find(freeForAllVotes, player)

            if newVotePlayerIndex then
                table.remove(teamDeathmatchVotes, newVotePlayerIndex)
            else
                table.insert(teamDeathmatchVotes, player)
            end

            if previousPlayerVoteIndex then
                table.remove(freeForAllVotes, previousPlayerVoteIndex)
            end

            ReplicatedStorage.Events.VotingChanged:FireAllClients(freeForAllVotes, teamDeathmatchVotes)
        end)
    })
end

function VotingSystem.EndVoting(): string
    ReplicatedStorage.Events.VotingEnded:FireAllClients()
    
    _VotingConnections:Dump()

    if #freeForAllVotes > #teamDeathmatchVotes then
        return "Free For All"
    else
        return "Team Deathmatch"
    end
end

return VotingSystem