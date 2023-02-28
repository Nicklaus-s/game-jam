--[[
    Pane.lua
    Nicklaus_s
    16 June 2022

    Class for interface which controls visibility.
--]]

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Modules = ReplicatedStorage.Modules

local Event = require(Modules.Event)
local Maid = require(Modules.Maid)

local Class = {}
Class.__index = Class

function Class.New()
    local self = setmetatable({}, Class)

    self._Maid = Maid.New()

    self._Visible = false
    self.VisibleChanged = Event.New()

    self._Maid:Give(self.VisibleChanged)

    return self
end

function Class:SetVisible(Value, Animate)
    self._Visible = Value
    self.VisibleChanged:Fire(Value, Animate)
end

function Class:Toggle(Animate)
    self:SetVisible(not self._Visible, Animate)
end

function Class:Show(Animate)
    self:SetVisible(true, Animate)
end

function Class:Hide(Animate)
    self:SetVisible(false, Animate)
end

function Class:Destroy()
    self._Maid:Cleanup()
    setmetatable(self, nil)
end

return Class