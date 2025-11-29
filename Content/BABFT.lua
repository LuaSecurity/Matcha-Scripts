loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Implementations/Ui%20Library.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Implementations/Tween.lua"))()

repeat task.wait() until UILib ~= nil

local function getGameName()
	return _G.GameName
end

local ArcaneHub = UILib.new('Arcane Hub', Vector2.new(750, 550), {getGameName})
local autofarmTab = ArcaneHub:Tab('AutoFarm')
local settingsSection = ArcaneHub:Section(autofarmTab, 'Settings')

local teleportTab = ArcaneHub:Tab('Teleport')
local teleportSection = ArcaneHub:Section(teleportTab, 'Teams')

local plr = game.Players.LocalPlayer
local run = false
local SigmaPath = game.Workspace.Houses
local OFFSET_Y = 10
local TWEEN_TIME = 1.8
local positions = {
    Vector3.new(-50.31, 44, 817.38),
    Vector3.new(-53.42, 44, 1996.92),
    Vector3.new(-62.30, 44, 2764.22),
    Vector3.new(-57.29, 44, 3572.89),
    Vector3.new(-50.01, 44, 4363.34),
    Vector3.new(-39.57, 44, 5137.95),
    Vector3.new(-47.36, 44, 5958.25),
    Vector3.new(-46.75, 44, 6711.18),
    Vector3.new(-45.88, 44, 7511.21),
    Vector3.new(-42.04, 44, 8261.71),
    Vector3.new(-58.36, -360.43, 9490.37)
}
local LAST_POSITION_INDEX = #positions
local TWEEN_INFO = TweenService.TweenInfo.new(TWEEN_TIME, "Linear", "In", 0, false, 0)

-- Predefined team positions for quick teleports
local teamPositions = {
    ["Black Team"] = Vector3.new(-591.06, -9.74, -69.76),
    ["Green Team"] = Vector3.new(-590.48, -9.72, 293.16),
    ["Yellow Team"] = Vector3.new(-591.22, -9.72, 639.22),
    ["Magenta Team"] = Vector3.new(483.06, -9.72, 648),
    ["Blue Team"] = Vector3.new(484.32, -9.72, 301.48),
    ["Red Team"] = Vector3.new(485.22, -9.72, -65.09),
    ["White Team"] = Vector3.new(-48.90, -9.72, -608.51)
}

ArcaneHub:Checkbox(autofarmTab, settingsSection, 'AutoFarm Enabled', false, function(state)
	run = state
end)

ArcaneHub:Slider(autofarmTab, settingsSection, 'Tween Time', 1.8, function(value)
	TWEEN_TIME = value
	TWEEN_INFO = TweenService.TweenInfo.new(TWEEN_TIME, "Linear", "In", 0, false, 0)
end, 0.5, 5, 0.1, ' sec')

ArcaneHub:Keybind(autofarmTab, settingsSection, 'Stop Autofarm', 'v', function()
	run = false
	runCandy = false
end, 'Stop')

ArcaneHub:CreateSettingsTab()

for teamName, pos in pairs(teamPositions) do
    ArcaneHub:Button(teleportTab, teleportSection, teamName, function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Position = pos
        end
    end)
end

-- Handles autofarm logic for candy collection
task.spawn(function()
    while true do
        if run then
            local char = plr.Character
            local hrp, hum

            while run and (not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid")) do
                char = plr.Character
                task.wait(0.1)
            end
            if not run then continue end

            hrp = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChild("Humanoid")
            if not hrp or not hum then continue end

            local firstPos = positions[1]
            local firstTarget = Vector3.new(firstPos.X, firstPos.Y + OFFSET_Y, firstPos.Z)
            hrp.Position = firstTarget
            task.wait(0.5)

            for i = 2, LAST_POSITION_INDEX do
                if not run then break end
                local charNow = plr.Character
                if not charNow then break end
                hrp = charNow:FindFirstChild("HumanoidRootPart")
                hum = charNow:FindFirstChild("Humanoid")
                if not hrp or not hum then break end

                local pos = positions[i]
                local targetPosition = Vector3.new(pos.X, pos.Y + OFFSET_Y, pos.Z)
                
                if i < LAST_POSITION_INDEX then
                    local tween = TweenService:Create(hrp, TWEEN_INFO, {
                        Position = targetPosition
                    })
                    tween:Play()
                    while tween.IsPlaying do
                        if not run then tween:Cancel() break end
                        task.wait(0.001)
                    end
                elseif i == LAST_POSITION_INDEX then
                    hrp.Position = targetPosition
                    task.wait(8)
                    hrp.Position = firstTarget
                end
            end
        end
        task.wait(0.1)
    end
end)

local running = true
while running do
	ArcaneHub:Step()
	task.wait(0.0015)
end
ArcaneHub:Destroy()
