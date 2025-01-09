local ContextActionService = game:GetService("ContextActionService")

local Library = require(script.Parent.Parent.Library)
local Inventory = Library.Inventory

local InventoryManager = {}

function InventoryManager.OnLoad()
    local playerInventory = Inventory.new()

    ContextActionService:BindAction("ChangeInventoryItemRight", function(_, inputState: Enum.UserInputState, _)
        if inputState == Enum.UserInputState.Begin then
            playerInventory:SwitchToItem(playerInventory.SelectedIndex % 3 + 1)
        end
    end, false, Enum.KeyCode.Two)

    print(ContextActionService:GetAllBoundActionInfo())
end

return InventoryManager