local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemViewport = {}

function ItemViewport.CreateViewport(slot, itemName: string)
    local viewportFrame: ViewportFrame = slot.ViewportFrame
    local viewportItem = ReplicatedStorage.Tools:FindFirstChild(itemName)

    if not viewportItem then
        return
    end

    viewportItem = viewportItem:Clone()

    viewportItem.Parent = viewportFrame.WorldModel
    viewportItem.Handle.CFrame = CFrame.new(0, 0, 0)

    local viewportCamera = Instance.new("Camera")
    viewportFrame.CurrentCamera = viewportCamera
    viewportCamera.Parent = viewportFrame.WorldModel

    viewportCamera.FieldOfView = 35

    viewportCamera.CFrame = CFrame.lookAt(viewportItem.Handle.CFrame.Position + Vector3.new(4, 3, -8), viewportItem.Handle.CFrame.Position)
end

return ItemViewport
