local RunService = game:GetService("RunService")

local Library = require(script.Parent.Parent.Library)

local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable

local cameraLoop: RBXScriptConnection

local Camera = {}

function Camera.OnGameStart()
    Camera.Disable()

    camera.CFrame = CFrame.new()
    camera.CFrame = Library.Character.HumanoidRootPart.CFrame
    camera.CameraSubject = Library.Character.HumanoidRootPart

    cameraLoop = RunService.RenderStepped:Connect(function()
        camera.CFrame = camera.CFrame:Lerp(Library.Character.HumanoidRootPart.CFrame * CFrame.new(3, 2, 7), 0.2)
    end)
end

function Camera.Disable()
    if cameraLoop then
        cameraLoop:Disconnect()
    end
end

return Camera
