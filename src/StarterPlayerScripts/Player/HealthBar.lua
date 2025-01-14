local Library = require(script.Parent.Parent.Library)

local HealthBar = {}

function HealthBar.OnGameStart()
    Library.Character.Humanoid.HealthChanged:Connect(function(health)
        Library.PlayerGui.PlayerStatsUI.HealthBar.Base.Size = UDim2.fromScale(health / Library.Character.Humanoid.MaxHealth, 1)
    end)
end

return HealthBar
