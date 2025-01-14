local Library = require(script.Parent.Parent.Library)
local ToolGrabber = Library.ToolGrabber

local Inventory: {CurrentInventory: ClassType} = {}
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

    self:_init()

    return self
end

function Inventory._init(self: ClassType)
    Library.PlayerGui.InventoryUI.Container[self.SelectedIndex].BackgroundTransparency = 0.5
    ToolGrabber.EquipTool(self, self.Selected)
end

function Inventory.SwitchToItem(self: ClassType, index: number)
    if self[index] then
        Library.PlayerGui.InventoryUI.Container[self.SelectedIndex].BackgroundTransparency = 0.75
        Library.PlayerGui.InventoryUI.Container[index].BackgroundTransparency = 0.5

        self.Selected = self[index]
        self.SelectedIndex = index
        ToolGrabber.EquipTool(self, self.Selected)
    end
end

return Inventory