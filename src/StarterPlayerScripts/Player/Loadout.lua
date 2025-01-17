local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local DataState = Library.DataState
local ItemViewport = Library.ItemViewport

local LobbyMenu = Library.LobbyMenu
local CharacterViewport = Library.CharacterViewport

local Loadout = {
    [1] = "ClassicSword",
    [2] = "HyperlaserGun",
    [3] = "RocketLauncher"
}

local ITEM_LIST = ReplicatedStorage.Tools:GetChildren()

for index, item in pairs(ITEM_LIST) do
    ITEM_LIST[index] = item.Name
end

function Loadout.OnLoad()
    local loadoutUI = Library.PlayerGui.LobbyUI.LoadoutContainer

    for _, slot in pairs(loadoutUI:GetChildren()) do
        local slotIndex = tonumber(slot.Name)

        if not slotIndex then
            continue
        end

        ItemViewport.CreateViewport(slot, Loadout[slotIndex])

        DataState.Find("Player"):AddTo(slot.Name.."Loadout", slot.Button.MouseButton1Click:Connect(function()
            Loadout[slotIndex] = ITEM_LIST[table.find(ITEM_LIST, Loadout[slotIndex]) % #ITEM_LIST + 1]

            for _, object: Instance in pairs(slot.ViewportFrame.WorldModel:GetChildren()) do
                object:Destroy()
            end

            if slot.Name == "1" then
                CharacterViewport.ClearViewport(Library.PlayerGui.LobbyUI.ViewportFrame)
                CharacterViewport.CreateCharacterViewport(Library.Player.LobbyUI.ViewportFrame)
            end

            ItemViewport.CreateViewport(slot, Loadout[slotIndex])
        end))
    end

    DataState.Find("Player"):AddTo("CloseLoadoutMenu", loadoutUI.Back.MouseButton1Click:Connect(function()
        loadoutUI.Visible = false
        LobbyMenu.OpenMenu()
    end))
end

function Loadout.OpenMenu()
    local loadoutUI = Library.PlayerGui.LobbyUI.LoadoutContainer
    loadoutUI.Visible = true
end

return Loadout