--[[
    The Library loads every single client module in 3 different stages

    OnGuiLoad(): First, which occurs every join/respawn
    OnLoad(): Second, same conditions as OnGuiLoad()
    OnGameStart(): Last, when the player enters a match and begins gameplay

    As well, this provides easy directories (Library.modulehere) for every single module, and
    intellisense (autocomplete and whatnot) if added below
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerFolder = script.Parent.Player

local Library = setmetatable({ -- Player, character, and PlayerGui given easy directories to use when scripting
        Player = Players.LocalPlayer,
        Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait(),
        PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    },

    {__index = function(_, index) -- This runs whenever a module is attempted to be accessed, but has not yet been required in the library.
        local module = PlayerFolder:FindFirstChild(index, true)
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

        return require(module) -- Returns the module at the end, so it can still be used!
    end
})

function Library.Load()
    Library.DataState.new("Player") -- Main DataState where most information is placed
    Library.Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait() -- The character is reset after each respawn, so we need to reset it to the new one.
    
    for _, module: Instance in pairs(PlayerFolder:GetChildren()) do
        if module.ClassName == "ModuleScript" then
            Library[module.Name] = require(module)
        end
    end

    local inventory = Library.Inventory

    export type Inventory = inventory.ClassType -- Inventory class type defined here so it can be accessed

    Library.PlayerGui:WaitForChild("LobbyUI")
    Library.PlayerGui:WaitForChild("KillScoreUI")

    -- Load orders
    for _, module in pairs(Library) do
        if typeof(module) ~= "table" then
            continue
        end

        if module.OnGuiLoad then
            module.OnGuiLoad()
        end
    end

    for _, module in pairs(Library) do
        if typeof(module) ~= "table" then
            continue
        end

        if module.OnLoad then
            module.OnLoad()
        end
    end

    Library.GetIntellisense()
end

function Library.LoadGame() -- Another loading order done
    for _, module in pairs(Library) do
        if typeof(module) ~= "table" then
            continue
        end

        if module.OnGameStart then
            module.OnGameStart()
        end
    end
end

function Library.GetIntellisense() -- This library system does not provide intellisense automatically, so for modules that we need to access from other ones later (especially classes), this is extremely useful.
    Library.DataState = require(ReplicatedStorage.DataState)

    Library.TransitionModule = require(PlayerFolder.TransitionModule)
    
    Library.Camera = require(PlayerFolder.Camera)
    Library.Inventory = require(PlayerFolder.Inventory)

    Library.ToolGrabber = require(PlayerFolder.ToolGrabber)
    Library.CharacterViewport = require(PlayerFolder.CharacterViewport)
    Library.ItemViewport = require(PlayerFolder.ItemViewport)

    Library.Loadout = require(PlayerFolder.Loadout)
    Library.LobbyMenu = require(PlayerFolder.LobbyMenu)
end

return Library
