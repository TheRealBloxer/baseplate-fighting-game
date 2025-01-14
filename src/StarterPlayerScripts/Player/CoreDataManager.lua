local Library = require(script.Parent.Parent.Library)
local DataState = Library.DataState

local CoreDataManager = {}

Library.Player.CharacterRemoving:Connect(function()
    DataState.DeleteAll()
end)

return CoreDataManager