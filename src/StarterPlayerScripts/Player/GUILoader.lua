local StarterGui = game:GetService("StarterGui")

local Library = require(script.Parent.Parent.Library)

local GUILoader = {}

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)

function GUILoader.OnGuiLoad()
    Library.PlayerGui.Fades.Black.BackgroundTransparency = 0

    Library.PlayerGui.KillScoreUI.Enabled = false
    Library.PlayerGui.LobbyUI.Enabled = true
    Library.PlayerGui.PlayerStatsUI.Enabled = false
    Library.PlayerGui.InventoryUI.Enabled = false
    Library.PlayerGui.VotingUI.Enabled = false
end

function GUILoader.OnGameStart()
    Library.PlayerGui.PlayerStatsUI.PlayerName.Text = Library.Player.Name

    Library.PlayerGui.LobbyUI.Enabled = false
    Library.PlayerGui.PlayerStatsUI.Enabled = true
    Library.PlayerGui.InventoryUI.Enabled = true
    Library.PlayerGui.KillScoreUI.Enabled = true
end

return GUILoader