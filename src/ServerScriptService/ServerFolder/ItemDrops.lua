--[[
    Health kit drops are created here
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Library = require(script.Parent.Parent.Library)
local DataState = Library.DataState

local ItemDrops = {}

local _Connections = DataState.new("HealthKits")
local healthKit: Model = ReplicatedStorage.Assets.HealthKit

function ItemDrops.RollForDrop(characterDied: Model) -- When a character dies, a roll is done to see if a health kit should drop from them.
    local humanoidRootPart = characterDied:FindFirstChild("HumanoidRootPart")
    local roll = math.random(0, 100)

    if roll > 85 and humanoidRootPart then
        local hrpCFrame: Vector3 = humanoidRootPart.CFrame.Position
        local connection: RBXScriptConnection

        local newHealthKit = healthKit:Clone() -- New drop is made
        newHealthKit.Parent = workspace
        newHealthKit:MoveTo(Vector3.new(hrpCFrame.X, 0.5, hrpCFrame.Z))

        connection = _Connections:AddTo(#_Connections.Wrapped, newHealthKit.PrimaryPart.Touched:Connect(function(hit)
            local humanoid: Humanoid = hit.Parent:FindFirstChild("Humanoid")

            if humanoid then
                humanoid.Health = math.min(humanoid.Health + 20, humanoid.MaxHealth)
                newHealthKit:Destroy()
                connection:Disconnect()
            end
        end))
    end
end

function ItemDrops.RemoveDrops()
    for _, item in pairs(workspace:GetChildren()) do
        if item.Name == "HealthKit" then
            item:Destroy()
        end
    end

    _Connections:Dump()
end

return ItemDrops