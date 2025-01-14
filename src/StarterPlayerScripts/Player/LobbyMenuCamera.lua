local Library = require(script.Parent.Parent.Library)

local LobbyMenuCamera = {}

function LobbyMenuCamera.OnLoad()
    workspace.CurrentCamera.CFrame = CFrame.new(workspace:WaitForChild("SceneCamera").CFrame.Position, workspace:WaitForChild("SpawnLocation").CFrame.Position)
end

return LobbyMenuCamera