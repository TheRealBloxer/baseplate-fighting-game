local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local ToolGrabber = {}

function ToolGrabber.EquipTool(inventory: Library.Inventory, name: string)
    local tool: Tool = ReplicatedStorage.Tools:FindFirstChild(name)

    if tool then
        ReplicatedStorage.Events.ToolEquipped:FireServer(tool)
    end
end

return ToolGrabber