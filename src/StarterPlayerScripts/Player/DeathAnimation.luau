local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library = require(script.Parent.Parent.Library)
local Camera = Library.Camera

local DeathAnimation = {}

function DeathAnimation.OnGameStart()
    Library.Character.Humanoid.Died:Connect(function()
        Camera.Disable()

        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable

        TweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Quad), {FieldOfView = 100}):Play()
        TweenService:Create(Library.PlayerGui.Fades.Black, TweenInfo.new(3), {BackgroundTransparency = 0}):Play()

        RunService.RenderStepped:Connect(function()
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, Library.Character.HumanoidRootPart.CFrame.Position)
        end)
    end)
end

return DeathAnimation