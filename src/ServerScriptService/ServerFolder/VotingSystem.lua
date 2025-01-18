--[[
    Controls the current vote totals, and the results of them.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local DataState = Library.DataState

local VotingSystem = {}

local _VotingConnections = DataState.new("VotingConnections")

local freeForAllVotes = {}
local teamDeathmatchVotes = {}

function VotingSystem.StartVoting()
    table.clear(freeForAllVotes)
    table.clear(teamDeathmatchVotes)
    
    ReplicatedStorage.Events.VotingBegan:FireAllClients()

     -- Players are given events that initialize their voting systems whenever their character resets
    for _, player: Player in pairs(Players:GetPlayers()) do
        _VotingConnections:AddTo(player.Name.."Added", player.CharacterAdded:Connect(function()
            ReplicatedStorage.Events.AddPlayerToVote:FireClient(player, freeForAllVotes, teamDeathmatchVotes)
        end))
    end

    _VotingConnections:AddTo("PlayerJoined", Players.PlayerAdded:Connect(function(player)
        _VotingConnections:AddTo(player.Name.."Added", player.CharacterAdded:Connect(function()
            ReplicatedStorage.Events.AddPlayerToVote:FireClient(player, freeForAllVotes, teamDeathmatchVotes)
        end))
    end))

    -- When different votes happen we add them in basically
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
    ReplicatedStorage.Events.VotingEnded:FireAllClients() -- Send event that voting ended

    _VotingConnections:Dump()

    if #freeForAllVotes > #teamDeathmatchVotes then -- Depending on resuls, stuff is returned for the round system
        return "Free For All"
    else
        return "Team Deathmatch"
    end
end

return VotingSystem