local Players = game:GetService("Players")

local Library = require(script.Parent.Library)
Library.Load()

Players.LocalPlayer.CharacterAdded:Wait()

Players.LocalPlayer.CharacterAdded:Connect(function()
    Library.Load()
end)