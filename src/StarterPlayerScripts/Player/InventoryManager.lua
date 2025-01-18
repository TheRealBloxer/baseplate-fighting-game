--[[
    Inventory object is created here, and item cycles are also done here
]]

local ContextActionService = game:GetService("ContextActionService")

local Library = require(script.Parent.Parent.Library)
local Inventory = Library.Inventory

local InventoryManager = {}

local NUMBER_INDEX = {
    [1] = "One",
    [2] = "Two",
    [3] = "Three",
    [4] = "Four",
    [5] = "Five",
}

function InventoryManager.OnGameStart()
    Inventory.CurrentInventory = Inventory.new()

    for index, _ in pairs(Inventory.CurrentInventory) do
        if not tonumber(index) then
            continue
        end

        ContextActionService:BindAction("ChangeInventoryItem"..index, function(_, inputState: Enum.UserInputState, _) -- fix
            if inputState == Enum.UserInputState.Begin then
                Inventory.CurrentInventory:SwitchToItem(index)
            end
        end, false, Enum.KeyCode[NUMBER_INDEX[index]])
    end
end

return InventoryManager