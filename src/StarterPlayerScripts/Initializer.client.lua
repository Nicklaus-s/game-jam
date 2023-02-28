--[[
    Initializer.client.lua
    Nicklaus_s
    February 25 2023

    Handle all client-side initialization of
    classes & more.
--]]

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Client = ReplicatedStorage.Client
local Controllers = Client.Controllers

for _, Controller: ModuleScript in Controllers:GetDescendants() do
    local Module = require(Controller)

    local Status, Response = pcall(Module.Initialize)

    if Status then
        warn(`[🚀] Started controller {Controller.Name} successfully.`)
    else
        warn(`[🚀] Failed to start controller {Controller.Name} got\n\n{Response}\n\n{debug.traceback()}`)
    end
end