--[[
    Intro.lua
    February 25 2023
    Nicklaus_s

    Service responsible for initialization of intro
    interface.
--]]

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Client = ReplicatedStorage.Client
local Interface = Client.Interface.Classes
local Intro = require(Interface.Intro)

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')

local Service = {}
Service.__index = Service

function Service.Initialize()
    local Object = Intro.New()
    Object.Interface.Parent = PlayerGui

    Object:Run()
end

return Service