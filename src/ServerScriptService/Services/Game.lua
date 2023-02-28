--[[
    Test.lua
    February 26 2023
    Nicklaus_s

    Service responsible for initialization of game.
--]]

local Workspace = game:GetService('Workspace')
local ServerScriptService = game:GetService('ServerScriptService')

local Modules = ServerScriptService.Modules
local Button = require(Modules.Button)

local Service = {}
Service.__index = Service

function Service.Initialize()
    for _, Plate in Workspace.Buttons:GetChildren() do
        local Object = Button.New(Plate, {})

        Object.Activated:Connect(function()
            print('activated', Plate)
            local controlsWhatDoor = Plate:GetAttribute('Door')
            local Door = Workspace.Doors:FindFirstChild(controlsWhatDoor)
            print(Door)

            if not Door then
                return
            end

            Door.Transparency = 0.5
            Door.CanCollide = false
        end)

        Object.Ended:Connect(function()
            print('ended', plate)
            local controlsWhatDoor = Plate:GetAttribute('Door')
            local Door = Workspace.Doors:FindFirstChild(controlsWhatDoor)
            print(Door)

            if not Door then
                return
            end

            Door.Transparency = 0
            Door.CanCollide = true
        end)
    end
end

return Service