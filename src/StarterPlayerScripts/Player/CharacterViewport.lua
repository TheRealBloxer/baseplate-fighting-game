local Library = require(script.Parent.Parent.Library)

local CharacterViewport = {}

function CharacterViewport.CreateCharacterViewport(viewportFrame: ViewportFrame & {WorldModel: WorldModel})
    local viewportCamera = Instance.new("Camera")
    viewportFrame.CurrentCamera = viewportCamera
    viewportCamera.Parent = viewportFrame.WorldModel

    Library.Character.Archivable = true

    local viewportCharacter = Library.Character:Clone()
    viewportCharacter.Parent = viewportFrame.WorldModel
    viewportCharacter.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    viewportCharacter:PivotTo(CFrame.new(0,0,0))
    
    viewportCamera.FieldOfView = 35

    viewportCamera.CFrame = CFrame.lookAt(viewportCharacter.PrimaryPart.Position + Vector3.new(4, 3, -8), viewportCharacter.PrimaryPart.Position)
end

return CharacterViewport
