local Player = game:GetService("Players")

local PlayerFolder = script.Parent.Player

local Library = setmetatable({}, {__index = function(_, index)
    local module = PlayerFolder:FindFirstChild(index, true)

    if not module then
        return
    end

    if module.ClassName ~= "ModuleScript" then
        return
    end

    return require(module)
end})

function Library.Load()
    for _, module: Instance in pairs(PlayerFolder:GetChildren()) do
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

        module.OnLoad(Player.LocalPlayer, Player.LocalPlayer.Character or Player.LocalPlayer.CharacterAdded:Wait())
    end

    Library.GetIntellisense()
end

function Library.GetIntellisense() -- This library system does not provide intellisense, so for modules that we need to access from other ones later (especially classes), this is extremely useful.
    Library.Camera = require(PlayerFolder.Camera)
    Library.Inventory = require(PlayerFolder.Inventory)
end

return Library
