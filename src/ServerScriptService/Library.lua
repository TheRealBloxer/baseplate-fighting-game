local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerFolder = script.Parent.ServerFolder

local Library = setmetatable({}, {__index = function(_, index)
    local module = ServerFolder:FindFirstChild(index, true)
    local replicatedStorageModule = ReplicatedStorage:FindFirstChild(index, true)

    if not module then
        if replicatedStorageModule then
            module = replicatedStorageModule
        else
            return
        end
    end

    if module.ClassName ~= "ModuleScript" then
        return
    end

    return require(module)
end})

function Library.Load()
    for _, module: Instance in pairs(ServerFolder:GetChildren()) do
        if module.ClassName == "ModuleScript" then
            Library[module.Name] = require(module)
        end
    end

    for _, module in pairs(Library) do
        if typeof(module) ~= "table" then
            continue
        end

        if not module.OnLoad then
            continue
        end

        module.OnLoad()
    end

    Library.GetIntellisense()
end

function Library.GetIntellisense() -- This library system does not provide intellisense, so for modules that we need to access from other ones later (especially classes), this is extremely useful.
    Library.DataState = require(ReplicatedStorage.DataState)
    
    Library.PlayerStatus = require(ServerFolder.PlayerStatus)
    Library.RoundSystem = require(ServerFolder.RoundSystem)
    Library.VotingSystem = require(ServerFolder.VotingSystem)
end

return Library
