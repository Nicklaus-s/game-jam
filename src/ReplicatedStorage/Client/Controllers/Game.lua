--[[
    Game.lua
    February 25 2023
    Nicklaus_s

    Service responsible for initialization and handling of
    game mechanics.
--]]

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')
local UserInputService = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')

local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Dummy = Workspace:WaitForChild('Dummy')

local Service = {}
Service.__index = Service

function Service.Initialize()
    local Normal = true

    UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == Enum.KeyCode.E then
            if Normal then
                Remotes.ChangeCharacter:FireServer('Dummy')
                Normal = false
            else
                Remotes.ChangeCharacter:FireServer('Normal')
                Normal = true
            end
        end
    end)
end

return Service