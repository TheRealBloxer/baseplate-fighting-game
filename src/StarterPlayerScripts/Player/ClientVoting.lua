local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local DataState = Library.DataState

local ClientVoting = {}

local _Connections = DataState.new("ClientVoting")

type VoteFrame = Frame & {
    Votes: TextLabel,
    Title: TextLabel,
    Button: TextButton
}

ReplicatedStorage.Events.VotingBegan.OnClientEvent:Connect(function()
    local votingUI: ScreenGui & {FreeForAll: VoteFrame, TeamDeathmatch: VoteFrame} = Library.PlayerGui.VotingUI

    Library.PlayerGui.LobbyUI.Enabled = false
    votingUI.Enabled = true

    _Connections:AddTo("Connections", {
        ReplicatedStorage.Events.VotingChanged.OnClientEvent:Connect(function(freeForAllVotes: {Player}, teamDeathmatchVotes: {Player})
            votingUI.FreeForAll.Votes.Text = #freeForAllVotes
            votingUI.TeamDeathmatch.Votes.Text = #teamDeathmatchVotes
        end),

        votingUI.FreeForAll.Button.MouseButton1Click:Connect(function()
            ReplicatedStorage.Events.VoteForFreeForAll:FireServer()
        end),

        votingUI.TeamDeathmatch.Button.MouseButton1Click:Connect(function()
            ReplicatedStorage.Events.VoteForTeamDeathmatch:FireServer()
        end)
    })
end)

ReplicatedStorage.Events.VotingEnded.OnClientEvent:Connect(function()
    _Connections:Dump()
    
    if Library.PlayerGui.VotingUI.Enabled then
        Library.PlayerGui.VotingUI.Enabled = false
        Library.PlayerGui.LobbyUI.Enabled = true
    end
end)

return ClientVoting