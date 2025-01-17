local Library = require(script.Parent.Parent.Library)

local HealthBar = {}

function HealthBar.OnGameStart()
    local playerStatsUI = Library.PlayerGui.PlayerStatsUI

    Library.Character.Humanoid.HealthChanged:Connect(function(health)
        Library.PlayerGui.PlayerStatsUI.HealthBar.Base.Size = UDim2.fromScale(health / Library.Character.Humanoid.MaxHealth, 1)
        Library.PlayerGui.PlayerStatsUI.HealthBar.Base.Main.BackgroundColor3 = Color3.fromHSV(0.3 * (health / Library.Character.Humanoid.MaxHealth), 1, 1)
    end)
end

return HealthBar
