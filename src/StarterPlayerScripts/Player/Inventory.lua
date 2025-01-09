local Inventory = {}
Inventory.__index = Inventory

local player: Player
local character: Model & {Humanoid: Humanoid}

export type ClassType = typeof(setmetatable(
    {} :: {
        [number]: string,

        Selected: string,
        SelectedIndex: number,
    },
    Inventory
))

function Inventory.OnLoad(newPlayer: Player, newCharacter: Model & {Humanoid: Humanoid})
    player = newPlayer
    character = newCharacter
end

function Inventory.new(): ClassType
    local self: ClassType = setmetatable({}, Inventory)

    self[1] = "sijisoklsm"
    self[2] = "yi7298iu2wegdj"
    self[3] = "Hello"

    self.Selected = self.One
    self.SelectedIndex = 1
    
    return self
end

function Inventory.SwitchToItem(self: ClassType, index: number)
    if self[index] then
        character.Humanoid:EquipTool(workspace.ClassicSword)
        self.Selected = self[index]
        self.SelectedIndex = index
        print("Chose", self.Selected)
    end
end

return Inventory