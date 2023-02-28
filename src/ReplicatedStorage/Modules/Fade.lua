--[[
    Fade.lua
    Nicklaus_s
    1 October 2022

    Utility module used for handling fades with canvas
    groups.
--]]

local TweenService = game:GetService("TweenService")

local Fade = {}
Fade.__index = Fade

local Get = function(Interface): string
    if Interface:IsA('Frame') then
        return 'BackgroundTransparency'
    end

    if Interface:IsA('CanvasGroup') then
        return 'GroupTransparency'
    end

    if Interface:IsA('TextLabel') then
        return 'TextTransparency'
    end

    if Interface:IsA('Sound') then
        return 'Volume'
    end

    return 'Transparency'
end

function Fade.Fade(Interface: {[number]: Instance}, Transparency: number, Speed: number?)
    local Tweens = {}

    for _, Object in pairs(Interface) do
        local Tween = TweenService:Create(
            Object,
            TweenInfo.new(
                Speed or 0.5,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out,
                0,
                false,
                0
            ),
            {
                [Get(Object)] = Transparency or 1
            }
        )

        Tween:Play()

        Tweens[Object] = Tween
    end

    return Tweens
end

return Fade