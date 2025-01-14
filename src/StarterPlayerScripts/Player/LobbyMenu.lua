local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Library = require(script.Parent.Parent.Library)

local LobbyMenu = {}

type Button = Frame & {Button: TextButton}

function LobbyMenu.OnLoad()
    local lobbyUI: ScreenGui & {Play: Button} = Library.PlayerGui.LobbyUI

    TweenService:Create(Library.PlayerGui.Fades.Black, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()

    lobbyUI.Play.Button.MouseButton1Click:Connect(function()
        ReplicatedStorage.Events.PlayerLeavingLobby:FireServer()
    end)

    ReplicatedStorage.Events.PlayerJoinedGame.OnClientEvent:Connect(function()
        print("bruh?")
        Library.LoadGame()
    end)
end

return LobbyMenu