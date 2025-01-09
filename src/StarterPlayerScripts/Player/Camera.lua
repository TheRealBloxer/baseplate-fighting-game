local RunService = game:GetService("RunService")

local Library = require(script.Parent.Parent.Library)

local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable

local Camera = {}

function Camera.OnLoad()
    local humanoidRootPart = Library.Character:WaitForChild("HumanoidRootPart")
    RunService.RenderStepped:Connect(function()
        camera.CFrame = camera.CFrame:Lerp(humanoidRootPart.CFrame * CFrame.new(3, 2, 7), 0.2)
    end)
end

return Camera