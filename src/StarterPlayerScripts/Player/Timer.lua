local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)

local Timer = {}

local function setTime(timeLeft: number)
    local seconds = timeLeft % 60
    local minutes = math.floor(timeLeft / 60)

    Library.PlayerGui.TimerUI.Container.Text.Text = string.format("%i:%02i", minutes, seconds) -- Little function that formats minutes and seconds similar to real clock
end

function Timer.OnLoad()
    setTime(ReplicatedStorage.GameStats.TimeLeft.Value) -- Set initially upon joining/reset
    ReplicatedStorage.GameStats.TimeLeft.Changed:Connect(setTime)
end

return Timer