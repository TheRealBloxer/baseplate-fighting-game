local ItemDrops = {}

function ItemDrops.RollForDrop(characterDied: Model)
    local roll = math.random(0, 100)

    if roll > 50 and characterDied:FindFirstChild("HumanoidRootPart") then
        local part = Instance.new("Part")
        part.Parent = workspace
        part.Position = characterDied.HumanoidRootPart.CFrame.Position
        part.Anchored = true
    end
end

return ItemDrops