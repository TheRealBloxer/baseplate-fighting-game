local TweenService = game:GetService("TweenService")
local Library = require(script.Parent.Parent.Library)

local TransitionModule = {}

function TransitionModule.StartTransition(duration: number, xScalePosition: number?, yield: boolean?, resetTransition: boolean?) -- Transition used between different parts of the start menu
    if resetTransition then
        Library.PlayerGui.TransitionUI.Black.Position = UDim2.fromScale(-1, 0)
    end
    
    local transition = TweenService:Create(Library.PlayerGui.TransitionUI.Black, TweenInfo.new(duration), {Position = UDim2.fromScale(xScalePosition or 1, 0)})
    transition:Play()

    if not yield then
        return
    end

    transition.Completed:Wait()
end

return TransitionModule
