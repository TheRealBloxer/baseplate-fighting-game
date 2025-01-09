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

function InventoryManager.OnLoad()
    local playerInventory = Inventory.new()

    for index, item in pairs(playerInventory) do
        if not tonumber(index) then
            continue
        end

        ContextActionService:BindAction("ChangeInventoryItem"..index, function(_, inputState: Enum.UserInputState, _)
            if inputState == Enum.UserInputState.Begin then
                playerInventory:SwitchToItem(index)
            end
        end, false, Enum.KeyCode[NUMBER_INDEX[index]])
    end
end

return InventoryManager