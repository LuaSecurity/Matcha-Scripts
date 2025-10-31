EspLib = {}
EspLib.__index = EspLib
RED = Color3.fromRGB(255, 0, 0)
GREEN = Color3.fromRGB(0, 255, 0)
BLUE = Color3.fromRGB(0, 0, 255)
YELLOW = Color3.fromRGB(255, 255, 0)
CYAN = Color3.fromRGB(0, 255, 255)
PINK = Color3.fromRGB(255, 0, 255)
WHITE = Color3.fromRGB(255, 255, 255)
BLACK = Color3.fromRGB(0, 0, 0)
ESP_FONTSIZE = 12
DEFAULT_PARTS_SIZING = {
	Head = Vector3.new(2, 1, 1),
	Torso = Vector3.new(2, 2, 1),
	['Left Arm'] = Vector3.new(1, 2, 1),
	['Right Arm'] = Vector3.new(1, 2, 1),
	['Left Leg'] = Vector3.new(1, 2, 1),
	['Right Leg'] = Vector3.new(1, 2, 1),
	UpperTorso = Vector3.new(2, 1, 1),
	LowerTorso = Vector3.new(2, 1, 1),
	LeftUpperArm = Vector3.new(1, 1, 1),
	LeftLowerArm = Vector3.new(1, 1, 1),
	LeftHand = Vector3.new(0.3, 0.3, 1),
	RightUpperArm = Vector3.new(1, 1, 1),
	RightLowerArm = Vector3.new(1, 1, 1),
	RightHand = Vector3.new(0.3, 0.3, 1),
	LeftUpperLeg = Vector3.new(1, 1, 1),
	LeftLowerLeg = Vector3.new(1, 1, 1),
	LeftFoot = Vector3.new(0.3, 0.3, 1),
	RightUpperLeg = Vector3.new(1, 1, 1),
	RightLowerLeg = Vector3.new(1, 1, 1),
	RightFoot = Vector3.new(0.3, 0.3, 1)
}
local currentCamera = workspace.CurrentCamera

local function magnitude(vector)
	return math.sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
end

local function normalize(vector)
	local mag = magnitude(vector)
	if mag == 0 then
		return Vector3.new(0, 0, 0)
	end
	return Vector3.new(vector.x / mag, vector.y / mag, vector.z / mag)
end

local function rotateVectorXZ(vector, angle)
	local sin_angle = math.sin(angle)
	local cos_angle = math.cos(angle)
	return Vector3.new(vector.x * sin_angle - vector.z * cos_angle, 0, vector.x * cos_angle + vector.z * sin_angle)
end

local function removeDrawings(drawingList)
	for _, drawing in ipairs(drawingList) do
		drawing:Remove()
	end
end

local function hideDrawings(drawingList)
	for _, drawing in ipairs(drawingList) do
		drawing.Visible = false
	end
end

function EspLib.new(config)
	local self = setmetatable({}, EspLib)
	self._objects = {}
	self._objectContainer = nil
	self._objectContainerLength = -1
	self._containerLastUpdate = 0
	self._components = {
		bbox = true,
		name = true,
		distance = true,
		flags = config.Flags ~= nil,
		snapline = false
	}
	self._running = true
	self._gb_accent = config.Accent or WHITE
	self._gb_distance = config.MaxDistance or nil
	self._gb_mode = config.Mode or EspLib.Mode['Standard']
	self._gb_validateEntry = config.ValidateEntry or nil
	self._gb_fetchEntryName = config.FetchEntryName or nil
	self._gb_traverseEntry = config.TraverseEntry or nil
	self._gb_measureEntry = config.MeasureEntry or nil
	self._gb_isEntryLocal = config.IsEntryLocal or nil
	self._gb_flags = config.Flags or nil
	return self
end

EspLib.Component = {
	['Box'] = 'bbox',
	['Name'] = 'name',
	['Distance'] = 'distance',
	['Flags'] = 'flags',
	['Snapline'] = 'snapline'
}

EspLib.Mode = {
	['Critical'] = 0,
	['Standard'] = 1,
	['Lazy'] = nil
}

EspLib.Validation = {
	['Matching Name'] = function(targetName)
		return function(entry)
			return entry.Name:lower():find(targetName:lower()) ~= nil
		end
	end
}

function EspLib._IsBasePart(instance)
	return instance.ClassName:lower():find('part') ~= nil
end

function EspLib._GetTextBounds(text)
	return #text * ESP_FONTSIZE * 0.5, ESP_FONTSIZE
end

function EspLib:_DistanceFromLocal(instance)
	if not self._IsBasePart(instance) then
		instance = instance:FindFirstChildOfClass('Part') or instance:FindFirstChildOfClass('MeshPart')
	end
	if instance == nil then
		return 0
	end
	local partPosition = instance.Position
	return magnitude(currentCamera.Position + Vector3.new(-partPosition.x, -partPosition.y, -partPosition.z))
end

function EspLib:_BoundingBox(instance)
	local minX, minY, maxX, maxY = 0, 0, 0, 0
	local parts = self._IsBasePart(instance) and {
		instance
	} or instance:GetChildren()
	local camPosition = currentCamera.Position
	local foundVisiblePart = #parts > 0
	for _, part in ipairs(parts) do
		local partName = part.Name
		if foundVisiblePart and self._IsBasePart(part) then
			local partPos = part.Position
			local partSize = self._gb_measureEntry and self._gb_measureEntry(instance) or (DEFAULT_PARTS_SIZING[partName] ~= nil and DEFAULT_PARTS_SIZING[partName] or Vector3.new(1, 1, 1))
			local direction = normalize(Vector3.new(partPos.x - camPosition.x, 0, partPos.z - camPosition.z))
			local angle = math.atan2(direction.x, direction.z)
			local halfSize = Vector3.new(partSize.x / 2, partSize.y / 2, partSize.z / 2)
			local corners = math.abs(magnitude(partSize)) < 0.2 and {
				partPos
			} or {
				partPos + rotateVectorXZ(Vector3.new(-halfSize.x, 0, -halfSize.z), angle) + Vector3.new(0, halfSize.y, 0),
				partPos + rotateVectorXZ(Vector3.new(halfSize.x, 0, halfSize.z), angle) + Vector3.new(0, -halfSize.y, 0)
			}
			for _, worldPos in ipairs(corners) do
				local screenPos, isVisible = WorldToScreen(worldPos)
				if not isVisible and foundVisiblePart then
					foundVisiblePart = false
				elseif foundVisiblePart then
					minX = minX == 0 and screenPos.x or math.min(minX, screenPos.x)
					minY = minY == 0 and screenPos.y or math.min(minY, screenPos.y)
					maxX = math.max(maxX, screenPos.x)
					maxY = math.max(maxY, screenPos.y)
				end
			end
		elseif foundVisiblePart and part.ClassName == 'Model' or part.ClassName == 'Folder' then
			local isVisible, nestedMinX, nestedMinY, nestedWidth, nestedHeight = self:_BoundingBox(part)
			minX = minX == 0 and nestedMinX or math.min(minX, nestedMinX)
			minY = minY == 0 and nestedMinY or math.min(minY, nestedMinY)
			maxX = math.max(maxX, nestedMinX + nestedWidth)
			maxY = math.max(maxY, nestedMinY + nestedHeight)
		end
	end
	return foundVisiblePart and minX > 0, minX, minY, maxX - minX, maxY - minY
end

function EspLib:Toggle(state)
	self._running = type(state) == 'boolean' and state or not self._running
end

function EspLib:ToggleComponent(componentKey, state)
	local componentState = self._components[componentKey]
	if componentState ~= nil then
		self._components[componentKey] = type(state) == 'boolean' and state or not componentState
	end
end

function EspLib:SetMaxDistance(maxDistance)
	self._gb_distance = tonumber(maxDistance) or nil
end

function EspLib:SetAccent(accentColor)
	self._gb_accent = accentColor or WHITE
end

function EspLib:SetGroupContainer(container)
	self._objectContainer = container
end

function EspLib:Add(entry)
	local mainBox = Drawing.new('Square')
	mainBox.Thickness = 1
	mainBox.Filled = false
	
	local innerOutline = Drawing.new('Square')
	innerOutline.Thickness = 1
	innerOutline.Filled = false

	local outerOutline = Drawing.new('Square')
	outerOutline.Thickness = 1
	outerOutline.Filled = false
	
	local snapline = Drawing.new('Line')
	snapline.Thickness = 1

	local nameText = Drawing.new('Text')
	nameText.Outline = true
	nameText.OutlineColor = BLACK

	local distanceText = Drawing.new('Text')
	distanceText.Outline = true
	distanceText.OutlineColor = BLACK

	local flagDrawings = {}
	if self._gb_flags then
		for _, _ in pairs(self._gb_flags) do
			local flagText = Drawing.new('Text')
			flagText.Outline = true
			flagText.OutlineColor = BLACK
			flagText.Color = Color3.fromRGB(255, 255, 255)
			table.insert(flagDrawings, flagText)
		end
	end
	
	self._objects[entry] = {
		['class'] = entry.ClassName,
		['_drawings'] = {
			mainBox,
			innerOutline,
			outerOutline,
			nameText,
			distanceText,
			snapline,
			unpack(flagDrawings)
		}
	}
	return entry
end

function EspLib:Unadd(entry)
	if self._objects[entry] then
		removeDrawings(self._objects[entry]['_drawings'])
		self._objects[entry] = nil
	end
end

function EspLib:Clear()
	for entry, _ in pairs(self._objects) do
		self:Unadd(entry)
	end
end

function EspLib:Step()
	local currentTime = os.clock()
    local screen_width = workspace.CurrentCamera.ViewportSize.X
    local screen_height = workspace.CurrentCamera.ViewportSize.Y

	if self._objectContainer and currentTime - self._containerLastUpdate > (self._gb_mode and (self._gb_mode == 1 and 0 or 0.33) or 1) then
		local children = self._objectContainer:GetChildren()
		if #children ~= self._objectContainerLength then
			self:Clear()
			self._objectContainerLength = #children
			for _, child in ipairs(children) do
				if self._gb_validateEntry == nil or self._gb_validateEntry and self._gb_validateEntry(child) == true then
					self:Add(child)
				end
			end
		end
		self._containerLastUpdate = currentTime
	end
	
	for entry, entryData in pairs(self._objects) do
		local drawings = entryData['_drawings']
		local shouldDraw = self._running
		
		if entry == nil then
			self:Unadd(entry)
			shouldDraw = false
		end
		
		if shouldDraw and self._gb_validateEntry then
			shouldDraw = self._gb_validateEntry(entry)
		end
		
		local targetInstance = shouldDraw and (self._gb_traverseEntry and self._gb_traverseEntry(entry) or entry) or nil
		local distance = 0
		local isVisible, minX, minY, width, height = false, 0, 0, 0, 0
		
		if shouldDraw and targetInstance then
			distance = math.floor(self:_DistanceFromLocal(targetInstance))
			if self._gb_distance == nil or self._gb_distance ~= nil and distance <= self._gb_distance then
				isVisible, minX, minY, width, height = self:_BoundingBox(targetInstance)
			else
				shouldDraw = false
			end
		end
		
		if isVisible and shouldDraw and entry then
			local entryName = tostring(entry.Name)
			if self._gb_fetchEntryName then
				entryName = self._gb_fetchEntryName(entry)
			end
			
			local accentColor = type(self._gb_accent) == 'function' and self._gb_accent(entry) or self._gb_accent
			local mainBox = drawings[1]
			local innerOutline = drawings[2]
			local outerOutline = drawings[3]
			
			if self._components['bbox'] == true then
				innerOutline.Position = Vector2.new(minX + 1, minY + 1)
				innerOutline.Size = Vector2.new(width - 2, height - 2)
				innerOutline.Color = BLACK
				innerOutline.Visible = true
				
				outerOutline.Position = Vector2.new(minX - 1, minY - 1)
				outerOutline.Size = Vector2.new(width + 2, height + 2)
				outerOutline.Color = BLACK
				outerOutline.Visible = true
				
				mainBox.Position = Vector2.new(minX, minY)
				mainBox.Size = Vector2.new(width, height)
				mainBox.Color = accentColor
				mainBox.Visible = true
			else
				mainBox.Visible = false
				innerOutline.Visible = false
				outerOutline.Visible = false
			end
			
			local nameText = drawings[4]
			if self._components['name'] then
				local textWidth, textHeight = self._GetTextBounds(entryName)
				nameText.Position = Vector2.new(minX - textWidth / 2 + width / 2, minY - textHeight - 6)
				nameText.Color = WHITE
				nameText.Text = entryName
				nameText.Visible = true
			else
				nameText.Visible = false
			end
			
			local distanceText = drawings[5]
			if self._components['distance'] then
				local distString = '[' .. tostring(distance) .. 'm]'
				local textWidth, textHeight = self._GetTextBounds(distString)
				distanceText.Position = Vector2.new(minX - textWidth / 2 + width / 2, minY + height + 2)
				distanceText.Color = WHITE
				distanceText.Text = distString
				distanceText.Visible = true
			else
				distanceText.Visible = false
			end
			
			local snapline = drawings[6]
			if self._components['snapline'] then
                snapline.From = Vector2.new(screen_width / 2, screen_height)
				snapline.To = Vector2.new(minX + width / 2, minY + height)
				snapline.Color = accentColor
				snapline.Visible = true
			else
				snapline.Visible = false
			end
			
			if self._gb_flags and self._components['flags'] then
				local currentYOffset = 0
				local _, textHeight = self._GetTextBounds('')
				local flagDrawingIndex = 6
				
				for flagName, flagFunction in pairs(self._gb_flags) do
					flagDrawingIndex = flagDrawingIndex + 1
					local flagTextDrawing = drawings[flagDrawingIndex]
					local flagResult = flagFunction(entry)
					
					if flagResult == true then
						flagResult = '*' .. flagName .. '*'
					elseif flagResult == false or flagResult == '' then
						flagResult = nil
					elseif flagResult ~= nil then
						flagResult = tostring(flagResult)
					end
					
					if flagResult then
						flagTextDrawing.Position = Vector2.new(minX + width + 2, minY + currentYOffset)
						flagTextDrawing.Text = flagResult
						flagTextDrawing.Visible = true
						currentYOffset = currentYOffset + textHeight + 4
					else
						flagTextDrawing.Visible = false
					end
				end
			end
		elseif entry ~= nil then
			hideDrawings(drawings)
		end
	end
end

function EspLib:Destroy()
	self:Toggle(false)
	self:Clear()
end

return EspLib
