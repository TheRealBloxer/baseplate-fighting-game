local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolService = {}

ReplicatedStorage.Events.ToolEquipped.OnServerEvent:Connect(function(player, tool: Tool)
    local newTool = tool:Clone()
    newTool.Parent = player.Character
    player.Character.Humanoid:EquipTool(newTool)
end)

return ToolService