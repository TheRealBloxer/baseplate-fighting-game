local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local ToolGrabber = {}

function ToolGrabber.EquipTool(inventory: Library.Inventory, name: string)
    local tool: Tool = ReplicatedStorage.Tools:FindFirstChild(name)

    if tool then
        local newTool = tool:Clone()
        newTool.Parent = Library.Character
        Library.Character.Humanoid:EquipTool(newTool)
    end
end

return ToolGrabber