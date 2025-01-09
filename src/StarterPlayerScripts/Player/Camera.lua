local RunService = game:GetService("RunService")

local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Scriptable

local Camera = {}

function Camera.OnLoad(_, character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    RunService.RenderStepped:Connect(function()
        camera.CFrame = camera.CFrame:Lerp(humanoidRootPart.CFrame * CFrame.new(3, 2, 7), 0.2)
    end)
end

return Camera