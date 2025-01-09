local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventService = {}

local function event(name: string): RemoteEvent
    local newEvent = Instance.new("RemoteEvent")
    newEvent.Parent = ReplicatedStorage.Events
    newEvent.Name = name
end

return EventService