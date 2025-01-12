local Players = game:GetService("Players")

local Library = require(script.Parent.Library)
Library.Load()

if not Players.LocalPlayer.Character then
    Players.LocalPlayer.CharacterAdded:Wait()
end

Players.LocalPlayer.CharacterAdded:Connect(function()
    Library.Load()
end)