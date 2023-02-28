--[[
    Button.lua
    Nicklaus_s
    Feburary 26 2023

    Provide a base class for providing button logic.
--]]

local CollectionService = game:GetService('CollectionService')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService('Workspace')

local Modules = ReplicatedStorage.Modules
local Object = require(Modules.Object)
local Event = require(Modules.Event)

local TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local Button = setmetatable({}, Object)
Button.__index = Button

function Button.New(Model: Model, Blacklist)
    local self = setmetatable(Object.New(), Button)
    self.Model = Model
    self.Plate = Model:FindFirstChild('Plate')
    self.Pivot = self.Model:GetPivot()
    self.Position = self.Plate.Position

    if not self.Plate then
        warn(`Failed to find "Plate" within {Button}! Did you forget to name the plate?`)
        return
    end

    local Detection = self.Plate.Size * Vector3.new(1, 0, 1) + 5 * Vector3.yAxis

    self._Maid:Give(RunService.Stepped:Connect(function()
        local Parameters = OverlapParams.new()
        Parameters.FilterType = Enum.RaycastFilterType.Exclude

        local Hit = Workspace:GetPartBoundsInBox(self.Pivot, Detection, Parameters)
        local Debug = {}

        local Weight = 0

        for _, Obj in Hit do
            if Obj.Parent == self.Model then
                continue
            end

            if Obj:GetAttribute('Ignore') then
                continue
            end

            if table.find(Blacklist, Obj) then
                continue
            end

            if table.find(Blacklist, Obj.Parent) then
                continue
            end

            table.insert(Debug, Obj)
            Weight += Obj.Mass
        end

        self:_Move(Weight, Debug)
    end))

    self.DidActivate = false

    self.Activated = Event.New()
    self.Ended = Event.New()

    self._Maid:Give(self.Activated)
    self._Maid:Give(self.Ended)

    return self
end

function Button:_Move(Fraction: number, Debug)
    local Move = math.clamp(Fraction, 0, 0.5)
    local Activated = Move == 0.5

    TweenService:Create(self.Plate, TweenInfo, {
        Position = self.Position - Vector3.yAxis * self.Plate.Size.Y * Move
    }):Play()

    if Activated then
        if self.DidActivate then
            return
        end

        print(Debug)
        self.Activated:Fire()
        self.DidActivate = true
    else
        if self.DidActivate then
            self.DidActivate = false
        else
            return
        end

        print(Debug)
        self.Ended:Fire()
    end

    return Activated
end

return Button