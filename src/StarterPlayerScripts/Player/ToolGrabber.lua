local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local ToolGrabber = {}

function ToolGrabber.EquipTool(inventory: Library.Inventory, name: string) -- Very simple function, just sends a request to equip a tool when asked to.
    local tool: Tool = ReplicatedStorage.Tools:FindFirstChild(name)

    if tool then
        ReplicatedStorage.Events.ToolEquipped:FireServer(tool)
    end
end

return ToolGrabber