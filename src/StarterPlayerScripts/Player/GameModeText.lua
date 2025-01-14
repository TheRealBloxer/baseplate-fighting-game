local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local GameModeText = {}

function GameModeText.OnLoad()
    Library.PlayerGui.GameModeUI.Mode.Text = ReplicatedStorage.GameStats.GameMode.Value

    ReplicatedStorage.GameStats.GameMode.Changed:Connect(function(value)
        Library.PlayerGui.GameModeUI.Mode.Text = value
    end)
end

return GameModeText