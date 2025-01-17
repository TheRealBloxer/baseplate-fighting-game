local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = require(script.Parent.Parent.Library)

local CharacterViewport = {}

function CharacterViewport.ClearViewport(viewportFrame: ViewportFrame & {WorldModel: WorldModel})
    for _, object: Instance in pairs(viewportFrame.WorldModel:GetChildren()) do
        object:Destroy()
    end
end

function CharacterViewport.CreateCharacterViewport(viewportFrame: ViewportFrame & {WorldModel: WorldModel})
    local Loadout = Library.Loadout

    local viewportCamera = Instance.new("Camera")
    viewportFrame.CurrentCamera = viewportCamera
    viewportCamera.Parent = viewportFrame.WorldModel

    Library.Character.Archivable = true

    local viewportCharacter = Library.Character:Clone()
    viewportCharacter.Parent = viewportFrame.WorldModel
    viewportCharacter.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    viewportCharacter:PivotTo(CFrame.new(0,0,0))
    
    viewportCamera.FieldOfView = 35

    local playerTool = ReplicatedStorage.Tools:FindFirstChild(Loadout[1])

    if playerTool then
        local newTool = playerTool:Clone()
        newTool.Parent = workspace
        viewportCharacter.Humanoid:EquipTool(newTool)
    end

    viewportCamera.CFrame = CFrame.lookAt(viewportCharacter.PrimaryPart.Position + Vector3.new(4, 3, -8), viewportCharacter.PrimaryPart.Position)
end

return CharacterViewport
