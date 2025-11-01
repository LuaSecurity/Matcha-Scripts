local RunService = game:GetService("RunService")

local ESP = {}
local activeDrawings = {}

local function getTargetPositionPart(instance)
    if instance:IsA("BasePart") then
        return instance
    elseif instance:IsA("Model") then
        return instance:FindFirstChild("HumanoidRootPart")
            or instance:FindFirstChild("Torso")
            or instance:FindFirstChild("PrimaryPart")
    end
    return nil
end

local function removeDrawing(instance)
    local data = activeDrawings[instance]
    if data then
        pcall(function() data.Box:Remove() end)
        pcall(function() data.Text:Remove() end)
    end
    activeDrawings[instance] = nil
end

local function createDrawing(instance, color)
    removeDrawing(instance)

    local hrp = getTargetPositionPart(instance)
    if not hrp then return end

    local box = Drawing.new("Square")
    box.Filled = false
    box.Thickness = 1.5
    box.Visible = false

    local text = Drawing.new("Text")
    text.Size = Vector2.new(16, 16)
    text.Center = true
    text.Outline = true
    text.Visible = false

    activeDrawings[instance] = {
        Box = box,
        Text = text,
        Color = color,
        TargetPart = hrp
    }
end

local function updateDrawing(instance)
    local data = activeDrawings[instance]
    if not data or not data.TargetPart or not data.TargetPart.Parent then
        return removeDrawing(instance)
    end

    local hrp = data.TargetPart
    
    local sizeY = hrp.Size.Y
    local isCharacter = hrp.Parent:IsA("Model") and hrp.Parent:FindFirstChildOfClass("Humanoid")
    local offset = isCharacter and sizeY * 2 or sizeY * 0.5
    
    local top3D = hrp.Position + Vector3.new(0, offset, 0)
    local bottom3D = hrp.Position - Vector3.new(0, offset, 0)
    
    local top2D, topOn = WorldToScreen(top3D)
    local bottom2D, bottomOn = WorldToScreen(bottom3D)

    if not (topOn and bottomOn) then
        data.Box.Visible, data.Text.Visible = false, false
        return
    end

    local height = math.abs(bottom2D.Y - top2D.Y)
    local width = isCharacter and (height * 0.6) or height

    data.Box.Position = Vector2.new(top2D.X - width / 2, top2D.Y)
    data.Box.Size = Vector2.new(width, height)
    data.Box.Color = data.Color
    data.Box.Visible = true

    data.Text.Text = instance.Name
    data.Text.Color = data.Color
    data.Text.Position = Vector2.new(top2D.X, top2D.Y - 18)
    data.Text.Visible = true
end

function ESP.CreateEsp(self, color)
    local targetColor = nil
    
    if typeof(color) == "Color3" then
        targetColor = color
    elseif typeof(color) == "table" and color.R and color.G and color.B then
        targetColor = Color3.new(color.R, color.G, color.B)
    elseif color == true then
        targetColor = Color3.fromRGB(255, 255, 255)
    end

    if targetColor then
        local data = activeDrawings[self]
        if not data then
            createDrawing(self, targetColor)
        elseif data.Color ~= targetColor then
            data.Color = targetColor
        end
    else
        removeDrawing(self)
    end
end

function ESP.Start()
    if ESP.IsRunning then return end
    ESP.IsRunning = true
    
    RunService.Heartbeat:Connect(function()
        for instance, data in pairs(activeDrawings) do
            if not instance.Parent then
                removeDrawing(instance)
            else
                updateDrawing(instance)
            end
        end
    end)
end

local success, Instance_mt = pcall(function()
    return getmetatable(game.Workspace) 
end)

if success and typeof(Instance_mt) == "table" and Instance_mt.__index then
    if typeof(Instance_mt.__index) == "table" then
        if not Instance_mt.__index.CreateEsp then
            Instance_mt.__index.CreateEsp = ESP.CreateEsp
        end
    end
end

ESP.Start()

return ESP
