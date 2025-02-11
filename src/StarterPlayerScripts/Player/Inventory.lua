--[[
    Only class, or object in the entire project.
    Lua/Luau features prototypal-based object orientated programming, which this uses.
]]

local Library = require(script.Parent.Parent.Library)

local ToolGrabber = Library.ToolGrabber
local ItemViewport = Library.ItemViewport

local Loadout = Library.Loadout

local Inventory: {CurrentInventory: ClassType} = {}
Inventory.__index = Inventory

export type ClassType = typeof(setmetatable( -- This type both provides a structure for the class, but also allows us to see the methods when programming.
    {} :: {
        [number]: string,

        Selected: string,
        SelectedIndex: number,
    },
    Inventory
))

function Inventory.new(): ClassType -- Inventory is constructed
    local self: ClassType = setmetatable({}, Inventory)

    self[1] = Loadout[1]
    self[2] = Loadout[2]
    self[3] = Loadout[3]

    self.Selected = self[1]
    self.SelectedIndex = 1

    self:_init()

    return self
end

function Inventory._init(self: ClassType) -- init() function creates item viewports and equips player tool.
    Library.PlayerGui.InventoryUI.Container[self.SelectedIndex].BackgroundTransparency = 0.5

    for _, slot in pairs(Library.PlayerGui.InventoryUI.Container:GetChildren()) do
        if not slot:IsA("Frame") then
            continue
        end

        ItemViewport.CreateViewport(slot, self[tonumber(slot.Name)])
    end

    ToolGrabber.EquipTool(self, self.Selected)
end

function Inventory.SwitchToItem(self: ClassType, index: number) -- Switch item, inventory slot, and equip tool
    if self[index] then
        Library.PlayerGui.InventoryUI.Container[self.SelectedIndex].BackgroundTransparency = 0.75
        Library.PlayerGui.InventoryUI.Container[index].BackgroundTransparency = 0.5

        self.Selected = self[index]
        self.SelectedIndex = index
        ToolGrabber.EquipTool(self, self.Selected)
    end
end

return Inventory