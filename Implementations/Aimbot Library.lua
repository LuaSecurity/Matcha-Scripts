--[[

    skided some stuff from nulare :)
https://discord.gg/cv4mT5bdjZ


v1.0 aimbot library

AimbotLib:SetTargetPath(<Folder | Model>)
AimbotLib:Add(entity) -> entity
AimbotLib:Remove(entity)
AimbotLib:Toggle(boolean | nil)
AimbotLib:SetMaxDistance(number | nil)
AimbotLib:SetFov(number)
AimbotLib:FovToggle(boolean | nil)
AimbotLib:Update()
AimbotLib:Destroy()

Settings:
- aimbot_key: Key code for activation (default: 0x02 - right mouse)
- fov_radius: Radius of FOV circle (default: 40)
- max_distance: Maximum targeting distance (default: 700)
- validate_entry: Function to validate if an entity should be targeted
- traverse_entry: Function to get the actual part to aim at from an entity


example on all the features:

local aimbot = AimbotLib.new({
    aimbot_key = 0x02, - right mouse button
    fov_radius = 200,
    max_distance = 700,
    validate_entry = function(entry)
        return true  or false
    end,
    traverse_entry = function(entry)
         Return the part you want to aim at
    end
})
aimbot:SetTargetPath(path to th shit)



example for reflex aimtrainer:

local aimbot = AimbotLib.new({
    aimbot_key = 0x02, -- right mouse button
    fov_radius = 200,
    max_distance = 700,
})

aimbot:SetTargetPath(workspace.Targets)

while true do
    aimbot:Update()
end

aimbot:Destroy()
]]

AimbotLib = {}
AimbotLib.__index = AimbotLib

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

local function Magnitude(pos1, pos2)
    if not pos1 or not pos2 then return math.huge end
    local dx = pos1.x + (-pos2.x)
    local dy = pos1.y + (-pos2.y)
    local dz = pos1.z + (-pos2.z)
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function getMousePosition()
    return Vector2(mouse.X, mouse.Y)
end

local function isInFOV(targetWorldPos, fovRadius, mousePos)
    local screenPos, isOnScreen = WorldToScreen(targetWorldPos)
    if not isOnScreen then return false end
    local dx = screenPos.x - mousePos.x
    local dy = screenPos.y - mousePos.y
    return (dx * dx + dy * dy) <= (fovRadius * fovRadius)
end

function AimbotLib.new(settings)
    local self = setmetatable({}, AimbotLib)
    
    self._aimbot_key = settings.aimbot_key or 0x02
    self._fov_radius = settings.fov_radius or 40
    self._max_distance = settings.max_distance or 700
    self._validate_entry = settings.validate_entry
    self._traverse_entry = settings.traverse_entry

    self._running = true
    self._fov_visible = true
    self._targets = {}
    self._target_container = nil
    self._container_length = -1
    self._last_update = 0
    self._last_target = nil
    
    self._fov_circle = Drawing.new("Circle")
    self._fov_circle.Visible = true
    self._fov_circle.Filled = false
    self._fov_circle.Color = Color3(1, 1, 1)
    self._fov_circle.Thickness = 1
    self._fov_circle.Radius = self._fov_radius
    self._fov_circle.NumSides = 80
    self._fov_circle.ZIndex = 3
    
    return self
end

function AimbotLib:SetTargetPath(container)
    self._target_container = container
end

function AimbotLib:Add(entity)
    self._targets[entity] = true
    return entity
end

function AimbotLib:Remove(entity)
    if self._targets[entity] then
        self._targets[entity] = nil
    end
end

function AimbotLib:Toggle(state)
    self._running = type(state) == 'boolean' and state or not self._running
end

function AimbotLib:FovToggle(state)
    self._fov_visible = type(state) == 'boolean' and state or not self._fov_visible
    if self._fov_circle then
        self._fov_circle.Visible = self._fov_visible
    end
end

function AimbotLib:SetMaxDistance(distance)
    self._max_distance = distance or 700
end

function AimbotLib:SetFov(radius)
    self._fov_radius = radius
    if self._fov_circle then
        self._fov_circle.Radius = radius
    end
end

function AimbotLib:Update()
    local mousePos = getMousePosition()
    
    if self._fov_visible then
        self._fov_circle.Position = mousePos
    end

    if not self._running then return end
    
    if self._target_container then
        local children = self._target_container:GetChildren()
        self._targets = {}
        for _, child in pairs(children) do
            if not self._validate_entry or self._validate_entry(child) then
                self:Add(child)
            end
        end
    end
    
    local character = localPlayer.Character
    local playerRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not playerRootPart then return end
    
    local closestTarget = nil
    local minDistance = math.huge
    
    for target, _ in pairs(self._targets) do
        if target then
            local aimTarget = self._traverse_entry and self._traverse_entry(target) or target
            if aimTarget and aimTarget.Position then
                local dist = Magnitude(playerRootPart.Position, aimTarget.Position)
                
                if dist <= self._max_distance and isInFOV(aimTarget.Position, self._fov_radius, mousePos) then
                    if dist < minDistance then
                        minDistance = dist
                        closestTarget = aimTarget
                    end
                end
            end
        end
    end
    
    if closestTarget and iskeypressed(self._aimbot_key) then
        workspace.CurrentCamera:SetRotation(closestTarget.Position)
    end
end

function AimbotLib:Destroy()
    self:Toggle(false)
    if self._fov_circle then
        self._fov_circle:Remove()
    end
    self._targets = {}
end
