local Players = game:GetService("Players")

local PlayerFolder = script.Parent.Player

local Library = setmetatable({
        Player = Players.LocalPlayer,
        Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait(),
        PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    },

    {__index = function(_, index)
        local module = PlayerFolder:FindFirstChild(index, true)

        if not module then
            return
        end

        if module.ClassName ~= "ModuleScript" then
            return
        end

        return require(module)
    end
    }
)

function Library.Load()
    Library.Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    
    for _, module: Instance in pairs(PlayerFolder:GetChildren()) do
        if module.ClassName == "ModuleScript" then
            Library[module.Name] = require(module)
        end
    end

    local inventory = Library.Inventory

    export type Inventory = inventory.ClassType

    for _, module in pairs(Library) do
        if typeof(module) ~= "table" then
            continue
        end

        if module.OnLoad then
            module.OnLoad()
        end

        if module.OnGuiLoad then
            module.OnGuiLoad()
        end
    end

    Library.GetIntellisense()
end

function Library.GetIntellisense() -- This library system does not provide intellisense, so for modules that we need to access from other ones later (especially classes), this is extremely useful.
    Library.Camera = require(PlayerFolder.Camera)
    Library.Inventory = require(PlayerFolder.Inventory)

    Library.ToolGrabber = require(PlayerFolder.ToolGrabber)
end

return Library
