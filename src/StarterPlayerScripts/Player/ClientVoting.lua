local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Library = require(script.Parent.Parent.Library)

local DataState = Library.DataState

local TransitionModule = Library.TransitionModule

local ClientVoting = {}

type VoteFrame = Frame & {
    Votes: TextLabel,
    Title: TextLabel,
    Button: TextButton
}

local function tweenVotingOptions(option1: VoteFrame, option2: VoteFrame, chosen: boolean)
    if chosen then
        TweenService:Create(option1, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.38, 0.9)}):Play()
        TweenService:Create(option2, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.28, 0.8)}):Play()
    else
        for _, option: VoteFrame in pairs({option1, option2}) do
            TweenService:Create(option, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.28, 0.8)}):Play()
        end
    end
end

ReplicatedStorage.Events.VotingBegan.OnClientEvent:Connect(function()
    local _Connections = DataState.new("ClientVoting")

    local votingUI: ScreenGui & {FreeForAll: VoteFrame, TeamDeathmatch: VoteFrame} = Library.PlayerGui:WaitForChild("VotingUI")

    local freeForAllChosen = false
    local teamDeathmatchChosen = false

    votingUI.FreeForAll.Votes.Text = "0"
    votingUI.TeamDeathmatch.Votes.Text = "0"

    TransitionModule.StartTransition(0.5, 0, true, true)
    task.wait(0.5)
    TransitionModule.StartTransition(0.5)

    Library.PlayerGui.LobbyUI.Enabled = false
    votingUI.Enabled = true

    print(votingUI)
    _Connections:AddTo("Connections", {
        ReplicatedStorage.Events.VotingChanged.OnClientEvent:Connect(function(freeForAllVotes: {Player}, teamDeathmatchVotes: {Player})
            votingUI.FreeForAll.Votes.Text = #freeForAllVotes
            votingUI.TeamDeathmatch.Votes.Text = #teamDeathmatchVotes

            votingUI.FreeForAll.Votes.TextColor3 = if #freeForAllVotes > #teamDeathmatchVotes then Color3.new(1, 0.85, 0.25) else Color3.new(1, 1, 1)
            votingUI.TeamDeathmatch.Votes.TextColor3 = if #teamDeathmatchVotes > #freeForAllVotes then Color3.new(1, 0.85, 0.25) else Color3.new(1, 1, 1)
        end),

        votingUI.FreeForAll.Button.MouseButton1Click:Connect(function()
            teamDeathmatchChosen = false
            freeForAllChosen = not freeForAllChosen

            tweenVotingOptions(votingUI.FreeForAll, votingUI.TeamDeathmatch, freeForAllChosen)
            ReplicatedStorage.Events.VoteForFreeForAll:FireServer()
        end),

        votingUI.TeamDeathmatch.Button.MouseButton1Click:Connect(function()
            freeForAllChosen = false
            teamDeathmatchChosen = not teamDeathmatchChosen

            tweenVotingOptions(votingUI.TeamDeathmatch, votingUI.FreeForAll, teamDeathmatchChosen)
            ReplicatedStorage.Events.VoteForTeamDeathmatch:FireServer()
        end)
    })
end)

ReplicatedStorage.Events.VotingEnded.OnClientEvent:Connect(function()
    DataState.Find("ClientVoting"):Delete()

    if Library.PlayerGui.VotingUI.Enabled then
        TransitionModule.StartTransition(0.5, 0, true, true)
        task.wait(0.5)
        TransitionModule.StartTransition(0.5)
        
        Library.PlayerGui.VotingUI.Enabled = false
        Library.PlayerGui.LobbyUI.Enabled = true
    end
end)

return ClientVoting