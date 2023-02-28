--[[
    Remotes.server.lua
    Nicklaus_s
    26 January 2023

    Handle all server-sided initialization of
    classes & more.
--]]

local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')

local Remotes = ReplicatedStorage.Remotes

local Characters = Instance.new('Folder')
Characters.Name = 'Characters'
Characters.Parent = ServerStorage

Remotes.ChangeCharacter.OnServerEvent:Connect(function(Player, Type)
    if Type == 'Dummy' then
        local Dummy = Workspace:WaitForChild('Dummy')

        local Origin = Player.Character
        local foundHumanoid = Origin:FindFirstChild('Humanoid')

        if foundHumanoid then
            foundHumanoid:Destroy()
        end
        
        Player.Character = Dummy

        local Humanoid = Instance.new('Humanoid')
        Humanoid.Parent = Player.Character

        Origin.Parent = Workspace
    end

    if Type == 'Normal' then
        local Origin = Workspace:FindFirstChild(Player.Name)
        local Dummy = Player.Character

        local Humanoid = Dummy.Humanoid
        Humanoid.PlatformStand = false

        Player.Character = Origin
        Humanoid.Parent = Origin

        Dummy.Parent = Workspace
    end
end)