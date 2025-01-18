--[[
    This is a function based module that both controls the position of the camera, and X rotation of the player's character.
]]

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library = require(script.Parent.Parent.Library)

local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable

local cameraLoop: RBXScriptConnection

local Camera = {}

function Camera.OnGameStart()
    Camera.Disable()

    local viewportSize = camera.ViewportSize
    local mouse = Library.Player:GetMouse()

    Library.Character.Humanoid.AutoRotate = false

    camera.CFrame = Library.Character.HumanoidRootPart.CFrame
    camera.CameraSubject = Library.Character.HumanoidRootPart
    camera.FieldOfView = 70

    cameraLoop = RunService.RenderStepped:Connect(function()
        local xOffset = 0.5 - (mouse.X) / (viewportSize.X) -- This defines how much the character's orientation on the x-axis should change based on mouse movement..

        xOffset = math.sign(xOffset) * TweenService:GetValue(math.abs(xOffset), Enum.EasingStyle.Sine, Enum.EasingDirection.In) -- We apply a sine curve to the initial value to make it slowly increase at higher X-offsets. Basically smoothing it.

        Library.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, xOffset, 0)
        camera.CFrame = Library.Character.HumanoidRootPart.CFrame * CFrame.new(3, 2, 7)
    end)
end

function Camera.Disable()
    if cameraLoop then
        cameraLoop:Disconnect()
    end
end

return Camera
