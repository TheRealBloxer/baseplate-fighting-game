local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Library = require(script.Parent.Parent.Library)

local DataState = Library.DataState

local TransitionModule = Library.TransitionModule
local CharacterViewport = Library.CharacterViewport

local LobbyMenu = {}

local lobbyUI: ScreenGui & {MainContainer: Frame & {Play: Button}}

type Button = Frame & {Button: TextButton}

local function changePlayButtonColour(value)
    if value ~= "Free For All" and value ~= "Team Deathmatch" then
        lobbyUI.MainContainer.Play.Button.TextTransparency = 0.5
    else
        lobbyUI.MainContainer.Play.Button.TextTransparency = 0
    end
end

function LobbyMenu.OnLoad() -- connections need to be in datastate
    lobbyUI = Library.PlayerGui.LobbyUI

    CharacterViewport.CreateCharacterViewport(lobbyUI.ViewportFrame)
    changePlayButtonColour(ReplicatedStorage.GameStats.GameMode.Value)

    lobbyUI.PlayerName.Text = Library.Player.Name

    TweenService:Create(Library.PlayerGui.Fades.Black, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()

    DataState.Find("Player"):AddTo("Lobby", {
        lobbyUI.MainContainer.Play.Button.MouseButton1Click:Connect(function()
            ReplicatedStorage.Events.PlayerLeavingLobby:FireServer()
        end),

        lobbyUI.MainContainer.Loadout.Button.MouseButton1Click:Connect(function()
            lobbyUI.MainContainer.Visible = false
            Library.Loadout.OpenMenu()
        end),

        ReplicatedStorage.GameStats.GameMode.Changed:Connect(changePlayButtonColour),

        ReplicatedStorage.Events.PlayerJoinedGame.OnClientEvent:Connect(function()
            lobbyUI.MainContainer.Play.Button.Active = false
            
            TransitionModule.StartTransition(0.5, 0, true, true)
            task.wait(0.5)
            Library.LoadGame()
            TransitionModule.StartTransition(0.5)
        end)
    })
end

function LobbyMenu.OpenMenu()
    Library.PlayerGui.LobbyUI.MainContainer.Visible = true
end

return LobbyMenu