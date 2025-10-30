--[[
Made with love by @acidzs
This is a implementation of TweenService from rLua into matcha's luaVM

Example:
    -- Vector3 example (position):

    local tweenInfo = TweenService.TweenInfo.new(2, "Sine", "Out", 0, false, 0)
    local tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, tweenInfo, { Position = Vector3.new(0,50,0) })
    tween:Play()
    while tween.IsPlaying do wait(0) end

]] 

local TweenService = {}

local EasingFunctions = {
    Linear = function(t)
        return t
    end,

    Sine = {
        In = function(t)
            return 1 - math.cos((t * math.pi) / 2)
        end,
        Out = function(t)
            return math.sin((t * math.pi) / 2)
        end,
        InOut = function(t)
            return -(math.cos(math.pi * t) - 1) / 2
        end
    },

    Quad = {
        In = function(t)
            return t * t
        end,
        Out = function(t)
            return 1 - (1 - t) * (1 - t)
        end,
        InOut = function(t)
            return t < 0.5 and 2 * t * t or 1 - (-2 * t + 2) ^ 2 / 2
        end
    },

    Cubic = {
        In = function(t)
            return t * t * t
        end,
        Out = function(t)
            return 1 - (1 - t) ^ 3
        end,
        InOut = function(t)
            return t < 0.5 and 4 * t * t * t or 1 - (-2 * t + 2) ^ 3 / 2
        end
    },

    Quart = {
        In = function(t)
            return t * t * t * t
        end,
        Out = function(t)
            return 1 - (1 - t) ^ 4
        end,
        InOut = function(t)
            return t < 0.5 and 8 * t * t * t * t or 1 - (-2 * t + 2) ^ 4 / 2
        end
    },

    Quint = {
        In = function(t)
            return t * t * t * t * t
        end,
        Out = function(t)
            return 1 - (1 - t) ^ 5
        end,
        InOut = function(t)
            return t < 0.5 and 16 * t * t * t * t * t or 1 - (-2 * t + 2) ^ 5 / 2
        end
    },

    Expo = {
        In = function(t)
            return t == 0 and 0 or 2 ^ (10 * t - 10)
        end,
        Out = function(t)
            return t == 1 and 1 or 1 - 2 ^ (-10 * t)
        end,
        InOut = function(t)
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            elseif t < 0.5 then
                return 2 ^ (20 * t - 10) / 2
            else
                return (2 - 2 ^ (-20 * t + 10)) / 2
            end
        end
    },

    Circ = {
        In = function(t)
            return 1 - math.sqrt(1 - t ^ 2)
        end,
        Out = function(t)
            return math.sqrt(1 - (t - 1) ^ 2)
        end,
        InOut = function(t)
            if t < 0.5 then
                return (1 - math.sqrt(1 - (2 * t) ^ 2)) / 2
            else
                return (math.sqrt(1 - (-2 * t + 2) ^ 2) + 1) / 2
            end
        end
    },

    Back = {
        In = function(t)
            local c1 = 1.70158
            local c3 = c1 + 1
            return c3 * t * t * t - c1 * t * t
        end,
        Out = function(t)
            local c1 = 1.70158
            local c3 = c1 + 1
            return 1 + c3 * (t - 1) ^ 3 + c1 * (t - 1) ^ 2
        end,
        InOut = function(t)
            local c1 = 1.70158
            local c2 = c1 * 1.525
            if t < 0.5 then
                return (2 * t) ^ 2 * ((c2 + 1) * 2 * t - c2) / 2
            else
                return ((2 * t - 2) ^ 2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
            end
        end
    },

    Elastic = {
        In = function(t)
            local c4 = (2 * math.pi) / 3
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            else
                return -2 ^ (10 * t - 10) * math.sin((t * 10 - 10.75) * c4)
            end
        end,
        Out = function(t)
            local c4 = (2 * math.pi) / 3
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            else
                return 2 ^ (-10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
            end
        end,
        InOut = function(t)
            local c5 = (2 * math.pi) / 4.5
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            elseif t < 0.5 then
                return -(2 ^ (20 * t - 10) * math.sin((20 * t - 11.125) * c5)) / 2
            else
                return (2 ^ (-20 * t + 10) * math.sin((20 * t - 11.125) * c5)) / 2 + 1
            end
        end
    },

    Bounce = {
        In = function(t)
            return 1 - EasingFunctions.Bounce.Out(1 - t)
        end,
        Out = function(t)
            local n1 = 7.5625
            local d1 = 2.75

            if t < 1 / d1 then
                return n1 * t * t
            elseif t < 2 / d1 then
                t = t - 1.5 / d1
                return n1 * t * t + 0.75
            elseif t < 2.5 / d1 then
                t = t - 2.25 / d1
                return n1 * t * t + 0.9375
            else
                t = t - 2.625 / d1
                return n1 * t * t + 0.984375
            end
        end,
        InOut = function(t)
            if t < 0.5 then
                return (1 - EasingFunctions.Bounce.Out(1 - 2 * t)) / 2
            else
                return (1 + EasingFunctions.Bounce.Out(2 * t - 1)) / 2
            end
        end
    }
}

local function isVector3(obj)
    if type(obj) == "userdata" then
        return pcall(function()
            return obj.x and obj.y and obj.z
        end)
    elseif type(obj) == "table" then
        return obj.x ~= nil and obj.y ~= nil and obj.z ~= nil
    elseif type(obj) == "Vector3" then
        return obj.X and obj.Y and obj.Z
    end

    return false
end

local function createVector3(x, y, z)
    local success, result = pcall(function()
        return Vector3.new(x, y, z)
    end)

    if success then
        return result
    else
        print("Warning: Vector3 constructor failed, using table fallback")
        return {
            x = x,
            y = y,
            z = z
        }
    end
end

local function lerp(a, b, t)
    if type(a) == "number" and type(b) == "number" then
        return a + (b - a) * t
    elseif isVector3(a) and isVector3(b) then
        return createVector3(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * t)
    elseif type(a) == "table" and type(b) == "table" then
        local result = {}
        for key, value in pairs(a) do
            if b[key] then
                result[key] = lerp(value, b[key], t)
            else
                result[key] = value
            end
        end
        return result
    end
    return b
end

local function getEasingFunction(easingStyle, easingDirection)
    if easingStyle == "Linear" then
        return EasingFunctions.Linear
    elseif EasingFunctions[easingStyle] then
        if easingDirection == "In" then
            return EasingFunctions[easingStyle].In
        elseif easingDirection == "Out" then
            return EasingFunctions[easingStyle].Out
        else
            return EasingFunctions[easingStyle].InOut
        end
    end

    return EasingFunctions.Linear
end

local validEasingStyles = {
    Linear = true,
    Sine = true,
    Back = true,
    Bounce = true,
    Quad = true,
    Cubic = true,
    Quart = true,
    Quint = true,
    Expo = true,
    Circ = true,
    Elastic = true
}

local validEasingDirections = {
    In = true,
    Out = true,
    InOut = true
}

local TweenInfo = {}
TweenInfo.__index = TweenInfo

function TweenInfo.new(time, easingStyle, easingDirection, repeatCount, reverses, delayTime)
    local self = setmetatable({}, TweenInfo)

    self.Time = time or 1
    self.EasingStyle = easingStyle or "Quad"
    self.EasingDirection = easingDirection or "Out"
    self.RepeatCount = repeatCount or 0
    self.Reverses = reverses or false
    self.DelayTime = delayTime or 0

    return self
end

local Tween = {}
Tween.__index = Tween

function Tween.new(instance, tweenInfo, properties)
    local self = setmetatable({}, Tween)

    self.Instance = instance

    if type(tweenInfo) == "table" and getmetatable(tweenInfo) ~= TweenInfo then

        self.TweenInfo = TweenInfo.new(tweenInfo.Time or 1, tweenInfo.EasingStyle or "Quad",
            tweenInfo.EasingDirection or "Out", tweenInfo.RepeatCount or 0, tweenInfo.Reverses or false,
            tweenInfo.DelayTime or 0)
    else
        self.TweenInfo = tweenInfo
    end

    self.Properties = properties
    self.InitialProperties = {}
    self.IsPlaying = false
    self.StartTime = 0
    self.CurrentTime = 0
    self.CompletedLoops = 0
    self.CurrentDirection = 1

    for prop, targetValue in pairs(properties) do
        if instance[prop] ~= nil then
            local initialValue = instance[prop]

            if isVector3(initialValue) then

                self.InitialProperties[prop] = {
                    type = "Vector3",
                    x = initialValue.x,
                    y = initialValue.y,
                    z = initialValue.z
                }

            elseif type(initialValue) == "table" then

                self.InitialProperties[prop] = {}
                for k, v in pairs(initialValue) do
                    self.InitialProperties[prop][k] = v

                end
            else

                self.InitialProperties[prop] = initialValue

            end
        end
    end

    for prop, targetValue in pairs(properties) do
        if isVector3(targetValue) then

            properties[prop] = {
                type = "Vector3",
                x = targetValue.x,
                y = targetValue.y,
                z = targetValue.z
            }
        elseif type(targetValue) == "table" then

            for k, v in pairs(targetValue) do

            end
        else

        end
    end

    self.Completed = {
        Connect = function(_, callback)
            self._completedCallback = callback
            return {
                Disconnect = function()
                    self._completedCallback = nil
                end
            }
        end
    }

    return self
end

function Tween:Play()
    if self.IsPlaying then

        return
    end

    self.IsPlaying = true
    self.StartTime = os.clock()
    self.CurrentTime = 0
    self.CompletedLoops = 0
    self.CurrentDirection = 1

    TweenService._addActiveTween(self)

    self:Update(0.001)
end

function Tween:Stop()
    if not self.IsPlaying then

        return
    end

    self.IsPlaying = false

    TweenService._removeActiveTween(self)
end

function Tween:Cancel()
    if not self.IsPlaying then
        return
    end

    self:Stop()

    for prop, value in pairs(self.InitialProperties) do
        if self.Instance[prop] ~= nil then
            self.Instance[prop] = value
        end
    end
end

function Tween:Update(deltaTime)
    if not self.IsPlaying then

        return false
    end

    self.CurrentTime = self.CurrentTime + deltaTime

    local tweenInfo = self.TweenInfo

    if tweenInfo == nil then

        return false
    end

    local easingFunction = getEasingFunction(tweenInfo.EasingStyle, tweenInfo.EasingDirection)
    local totalDuration = tweenInfo.Time

    if self.CurrentTime < tweenInfo.DelayTime then

        return true
    end

    local adjustedTime = self.CurrentTime - tweenInfo.DelayTime

    local totalDuration = tweenInfo.Time
    local runsNeeded = (tweenInfo.RepeatCount == 0) and 1 or tweenInfo.RepeatCount
    local totalTimeNeeded = tweenInfo.DelayTime + totalDuration * runsNeeded

    if self.CurrentTime >= totalTimeNeeded then

        pcall(function()
            for prop, targetValue in pairs(self.Properties) do
                if type(targetValue) == "table" and targetValue.type == "Vector3" then

                    self.Instance[prop] = createVector3(targetValue.x, targetValue.y, targetValue.z)
                elseif type(targetValue) == "table" and targetValue.type == nil then

                    self.Instance[prop] = targetValue
                else

                    self.Instance[prop] = targetValue
                end
            end
        end)

        self:Stop()
        if self._completedCallback then
            self._completedCallback()
        end
        return false
    end

    local loopProgress = (adjustedTime % totalDuration) / totalDuration

    if self.CurrentDirection == -1 then
        loopProgress = 1 - loopProgress

    end

    local alpha = easingFunction(loopProgress)

    for prop, targetValue in pairs(self.Properties) do
        if self.Instance[prop] ~= nil and self.InitialProperties[prop] ~= nil then
            local initialValue = self.InitialProperties[prop]

            if type(initialValue) == "table" and initialValue.type == "Vector3" and type(targetValue) == "table" and
                (targetValue.type == "Vector3" or
                    (targetValue.x ~= nil and targetValue.y ~= nil and targetValue.z ~= nil)) then

                local tx, ty, tz
                if targetValue.type == "Vector3" then
                    tx, ty, tz = targetValue.x, targetValue.y, targetValue.z
                else
                    tx, ty, tz = targetValue.x, targetValue.y, targetValue.z
                end

                local nx = initialValue.x + (tx - initialValue.x) * alpha
                local ny = initialValue.y + (ty - initialValue.y) * alpha
                local nz = initialValue.z + (tz - initialValue.z) * alpha

                self.Instance[prop] = createVector3(nx, ny, nz)

            elseif type(targetValue) == "table" and type(initialValue) == "table" and initialValue.type == nil then

                if prop == "Position" and type(self.Instance[prop]) == "table" and self.Instance[prop].x ~= nil and
                    self.Instance[prop].y ~= nil and self.Instance[prop].z ~= nil then

                    local newPosition = {}
                    for k, v in pairs(initialValue) do
                        if targetValue[k] ~= nil and type(v) == "number" then
                            newPosition[k] = v + (targetValue[k] - v) * alpha

                        else
                            newPosition[k] = v
                        end
                    end

                    self.Instance[prop] = newPosition

                else

                    local newValue = {}
                    for k, v in pairs(initialValue) do
                        if targetValue[k] ~= nil then
                            if type(v) == "number" and type(targetValue[k]) == "number" then
                                newValue[k] = v + (targetValue[k] - v) * alpha
                            else
                                newValue[k] = targetValue[k]
                            end
                        else
                            newValue[k] = v
                        end
                    end

                    self.Instance[prop] = newValue

                end
            else

                if type(initialValue) == "number" and type(targetValue) == "number" then
                    self.Instance[prop] = initialValue + (targetValue - initialValue) * alpha

                else

                    self.Instance[prop] = targetValue

                end
            end
        else

        end
    end

    if adjustedTime >= (self.CompletedLoops + 1) * totalDuration then

        self.CompletedLoops = self.CompletedLoops + 1

        if tweenInfo.Reverses then
            self.CurrentDirection = self.CurrentDirection * -1

        end

        local shouldStop
        if tweenInfo.RepeatCount == 0 then
            shouldStop = (self.CompletedLoops >= 1)
        else
            shouldStop = (self.CompletedLoops >= tweenInfo.RepeatCount)
        end

        if shouldStop then
            self:Stop()
            if self._completedCallback then
                self._completedCallback()
            end
            return false
        end
    end

    return true
end

local activeTweens = {}

function TweenService._addActiveTween(tween)
    table.insert(activeTweens, tween)

    if not TweenService._updateLoopRunning then
        TweenService._startUpdateLoop()
    end
end

function TweenService._removeActiveTween(tween)
    for i, activeTween in ipairs(activeTweens) do
        if activeTween == tween then
            table.remove(activeTweens, i)

            break
        end
    end

    if #activeTweens == 0 then
        TweenService._stopUpdateLoop()
    end
end

TweenService._autoUpdateEnabled = true
TweenService._lastAutoUpdateTime = 0
TweenService._autoUpdateInterval = 0.006

function TweenService._autoUpdate()
    if not TweenService._autoUpdateEnabled or not TweenService._updateLoopRunning then
        return
    end

    local currentTime = os.clock()
    if currentTime - TweenService._lastAutoUpdateTime >= TweenService._autoUpdateInterval then
        TweenService._lastAutoUpdateTime = currentTime
        TweenService._update()
    end
end

local originalWait = wait

TweenService._lastUpdateTime = os.clock()
TweenService._updateFrequency = 144
function TweenService._processTweens()
    local currentTime = os.clock()
    local deltaTime = currentTime - TweenService._lastUpdateTime
    TweenService._lastUpdateTime = currentTime
    local i = 1
    while i <= #activeTweens do
        local tween = activeTweens[i]
        local shouldContinue = tween:Update(deltaTime)

        if shouldContinue then
            i = i + 1
        else
            table.remove(activeTweens, i)
        end
    end

    if #activeTweens == 0 then
        TweenService._updateLoopRunning = false
    end
end

function TweenService._startUpdateLoop()

    TweenService._updateLoopRunning = true
    TweenService._lastUpdateTime = os.clock()
end

function TweenService._stopUpdateLoop()

    TweenService._updateLoopRunning = false
end

wait = function(seconds)
    local startTime = os.clock()
    local endTime = startTime + seconds
    local updateInterval = 1 / TweenService._updateFrequency

    if TweenService._updateLoopRunning then
        TweenService._processTweens()
    end

    while os.clock() < endTime do
        local nextUpdateTime = os.clock() + updateInterval

        local waitTime = math.min(nextUpdateTime - os.clock(), endTime - os.clock())
        if waitTime > 0 then
            originalWait(waitTime)
        end

        if TweenService._updateLoopRunning then
            TweenService._processTweens()
        end
    end

    return os.clock() - startTime
end

function TweenService._update()
    TweenService._processTweens()
end

function TweenService.ManualUpdate()
    if TweenService._updateLoopRunning then
        TweenService._processTweens()
        return true
    end
    return false
end

function TweenService:Create(instance, tweenInfo, properties)

    return Tween.new(instance, tweenInfo, properties)
end

TweenService.TweenInfo = TweenInfo
_G.TweenService = TweenService
