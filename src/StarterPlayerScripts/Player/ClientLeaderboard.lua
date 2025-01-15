local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(script.Parent.Parent.Library)

local ClientLeaderboard = {}

type KillScoreUI = ScreenGui & {KillList: ScrollingFrame & {Template: Frame & {Description: TextLabel}}}

function ClientLeaderboard.OnGameStart()
    local killCount = 0
    local killScoreUI: KillScoreUI = Library.PlayerGui.KillScoreUI

    ReplicatedStorage.Events.UpdateKill.OnClientEvent:Connect(function(playerKilled: Player, killedBy: Player)
        local newKill = killScoreUI.KillList.Template:Clone()
        print(killedBy)

        newKill.Name = playerKilled.Name..killedBy.Name
        newKill.Description.Text = killedBy.Name.." -> "..playerKilled.Name
        newKill.Parent = killScoreUI.KillList
        newKill.LayoutOrder = -killCount

        if killedBy == Library.Player then
            newKill.BackgroundColor3 = Color3.new(0, 0.5, 0)
        elseif playerKilled == Library.Player then
            newKill.BackgroundColor3 = Color3.new(0.5, 0, 0)
        end

        newKill.Visible = true

        killCount += 1
    end)
end

return ClientLeaderboard