--[[
    Initializer.server.lua
    Nicklaus_s
    25 January 2023

    Handle all server-sided initialization of
    classes & more.
--]]

local Players = game:GetService('Players')
local ServerScriptService = game:GetService('ServerScriptService')

local Services = ServerScriptService.Services

for _, Service: ModuleScript in Services:GetDescendants() do
    local Module = require(Service)

    local Status, Response = pcall(Module.Initialize)

    if Status then
        warn(`[🚀] Started service {Service.Name} successfully.`)
    else
        warn(`[🚀] Failed to start service {Service.Name} got {Response}.`)
    end
end