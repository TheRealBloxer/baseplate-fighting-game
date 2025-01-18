local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToolService = {}

ReplicatedStorage.Events.ToolEquipped.OnServerEvent:Connect(function(player, tool: Tool) -- EQUIPS TOOLS ON THE SERVER!
    local newTool = tool:Clone()
    newTool.Parent = player.Character
    player.Character.Humanoid:EquipTool(newTool)
end)

return ToolService