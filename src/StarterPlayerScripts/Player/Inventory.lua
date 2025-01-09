local Library = require(script.Parent.Parent.Library)
local ToolGrabber = Library.ToolGrabber

local Inventory = {}
Inventory.__index = Inventory

export type ClassType = typeof(setmetatable(
    {} :: {
        [number]: string,

        Selected: string,
        SelectedIndex: number,
    },
    Inventory
))

function Inventory.new(): ClassType
    local self: ClassType = setmetatable({}, Inventory)

    self[1] = "ClassicSword"
    self[2] = "RocketLauncher"
    self[3] = "Hello"

    self.Selected = self[1]
    self.SelectedIndex = 1
    
    return self
end

function Inventory.SwitchToItem(self: ClassType, index: number)
    if self[index] then
        self.Selected = self[index]
        self.SelectedIndex = index
        ToolGrabber.EquipTool(self, self.Selected)
    end
end

return Inventory