--[[
    Intro.lua
    February 25 2023
    Nicklaus_s

    Interface class for the introduction.
--]]

local Workspace = game:GetService('Workspace')
local StarterGui = game:GetService('StarterGui')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Modules = ReplicatedStorage.Modules
local Pane = require(Modules.Pane)
local Fade = require(Modules.Fade)

local Client = ReplicatedStorage.Client
local Interface = Client.Interface
local Templates = Interface.Templates

local Sounds = Workspace.Sounds

local Intro = setmetatable({}, Pane)
Intro.__index = Intro

function Intro.New()
    local self = setmetatable(Pane.New(), Intro)

    self.Interface = Templates.Intro:Clone()
    self.Background = self.Interface.Background
    self.Welcome = self.Background.Welcome
    self.Author = self.Background.Author

    self._Maid:Give(self.VisibleChanged:Connect(function(Visible, Animate)
        local Transparency = Visible and 0 or 1

        if Animate then
            local Tween = Fade.Fade({self.Background}, Transparency, 1)

            self._Maid:Give(Tween[self.Background].Completed:Connect(function()
                self:Destroy()
            end))
        else
            self.Background.Transparency = Transparency
            self:Destroy()
        end

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, not Visible)
        local SongOut = Fade.Fade({Sounds.Intro}, 0, 20)
        SongOut[Sounds.Intro].Completed:Connect(function()
            Sounds.Intro:Destroy()
            Fade.Fade({Sounds.Background}, 0.3, 10)
            Sounds.Background:Play()
        end)
    end))

    return self
end

function Intro:Run()
    Sounds.Intro:Play()
    local Tween = Fade.Fade({self.Background}, 0, 1)

    Tween[self.Background].Completed:Wait()
    task.wait(3)

    local WelcomeFade = Fade.Fade({self.Welcome}, 1, 1)
    WelcomeFade[self.Welcome].Completed:Wait()
    task.wait(0.8)

    local AuthorFade = Fade.Fade({self.Author}, 0, 1)
    AuthorFade[self.Author].Completed:Wait()
    task.wait(4)

    self:Hide(true)
end

return Intro