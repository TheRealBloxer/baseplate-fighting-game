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
        local xOffset = 0.5 - (mouse.X) / (viewportSize.X)
        
        if mouse.X > viewportSize.X or mouse.X <= 0 then
            xOffset = 0.5
        else
            xOffset = math.sign(xOffset) * TweenService:GetValue(math.abs(xOffset), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
        end

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
