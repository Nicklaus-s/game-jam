--[[
    Event.lua
    Nicklaus_s
    16 June 2022

    Custom library for using BindableEvents.
--]]

local HttpService = game:GetService('HttpService')

local Class = {}
Class.__index = Class

function Class.New()
    local self = setmetatable({}, Class)

    self._Event = Instance.new('BindableEvent')
    self._Arguments = {}

    return self
end

function Class:Fire(...)
    if not self._Event then
        return
    end

    local Key = HttpService:GenerateGUID(false)

    local Arguments = table.pack(...)
    self._Arguments[Key] = Arguments

    self._Event:Fire(Key)
end

function Class:Connect(Run)
    return self._Event.Event:Connect(function(Key)
        local Arguments = self._Arguments[Key]

        if Arguments then
            Run(table.unpack(Arguments, 1, Arguments.n))
        else
            return
        end
    end)
end

function Class:OnRun()
    local Key = self._Event.Event:Wait()
    local Arguments = self._Arguments[Key]

    if Arguments then
        return table.unpack(Arguments, 1, Arguments.n)
    else
        return
    end
end

function Class:Destroy()
    if self._Event then
        self._Event:Destroy()
        self._Event = nil
    end

    setmetatable(self, nil)
end

return Class