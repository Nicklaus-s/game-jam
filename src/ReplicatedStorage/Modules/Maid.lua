--[[
    Maid.lua
    Nicklaus_s
    5 July 2022

    Utility object for cleaning up, destroying and
    otherwise releasing resources.
--]]

local Class = {}
Class.__index = Class

function Class.New()
    local self = setmetatable({}, Class)

    self._Tasks = {}
    self._Count = 0

    return self
end

function Class:Give(Task)
    if not Task then
        warn('[Maid.Give] Task cannot be false or nil!')
    end

    local Identifier = #self._Tasks + 1
    self._Tasks[Identifier] = Task

    if type(Task) == 'table' and (not Task.Destroy) then
        warn(
            ('[Maid.Give] Task of type table was given without .Destroy!\n\n%s'):format(debug.traceback())
        )
    end

    return Identifier
end

function Class:Cleanup()
    local Time = os.clock()

    for Identifier, Task in pairs(self._Tasks) do
        if typeof(Task) == 'RBXScriptConnection' then
            self._Tasks[Identifier] = nil
            Task:Disconnect()

            self._Count += 1
        end
    end

    local Identifier, Task = next(self._Tasks)

    while Task do
        self._Tasks[Identifier] = nil

        if type(Task) == 'function' then
            Task()
        elseif typeof(Task) == 'RBXScriptConnection' then
            Task:Disconnect()
        elseif typeof(Task) == 'thread' then
            coroutine.close(Task)
        elseif Task.Destroy then
            Task:Destroy()
        end

        self._Count += 1

        Identifier, Task = next(self._Tasks)
    end

    warn(string.format('Cleaned up %s tasks in %s seconds!', self._Count, os.clock() - Time))
end

return Class