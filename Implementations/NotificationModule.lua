-- notification system made by @jurylol on discord
--[[

HOW TO USE

only 1 function

notify.CreateNotification("notification type" , "Notification Title", "Notification Body text", notification duration, notification Zindex, title text color, body text color, the bar on the side color / outline color, background color, divider color, progress bar color)

Example code:
notify.CreateNotification("default", "67 notification", "blah blah blah blah blah", 5, 10)

notify.CreateNotification("roundedOutline", "Skibidi 67 Notification", "asdasdas dasd as", 5, 10, nil, nil, Color3.fromRGB(math.random(0, 255),math.random(0, 255),math.random(0, 255)))

notify.CreateNotification("outline", "Skibidi 67 Notification", "asdasdas dasd as", 5, 10, nil, nil, Color3.fromRGB(math.random(0, 255),math.random(0, 255),math.random(0, 255)))
]]

local notify = {}
local activeNotifications = {}
local currID = 0

local function wrapText(text, limit)
	local result = ""
	local lineLength = 0
	local lastSpace = 0
	for i = 1, #text do
		local char = text:sub(i, i)
		result = result .. char
		lineLength = lineLength + 1
		if char == " " then
			lastSpace = #result
		end
		if lineLength >= limit then
			if lastSpace > 0 then
				result = result:sub(1, lastSpace - 1) .. "\n" .. result:sub(lastSpace + 1)
				lineLength = #result - lastSpace
				lastSpace = 0
			else
				result = result .. "\n"
				lineLength = 0
			end
		end
	end
	return result
end

local function addNotification(elements, id, duration, notificationType)
	local notifMain = elements[3]
	local offsets = {}

	for _, element in ipairs(elements) do
		offsets[element] = element.Position - notifMain.Position
	end

	local data = {
		ID = id,
		Elements = elements,
		Offsets = offsets,
		NotifMain = notifMain,
		Initialized = false,
		Duration = duration,
		Initializing = false,
		notificationType = notificationType
	}

	table.insert(activeNotifications, data)
end

local function updateRelativePosition(data, pos)
	for _, element in ipairs(data.Elements) do
		local offset = data.Offsets[element]
		element.Position = pos + offset
	end
end


function notify.CreateNotification(notificationType:string , titleContent:string, textContent:string, duration:number, zIndex:number ,titleColor:Color3, textContentColor:Color3, barColor:Color3, backgroundColor:Color3, lineColor:Color3, progressBarColor:Color3) 

	local processedText = wrapText(textContent, 35)
	if zIndex == nil then
		zIndex = 67
	end
	local xPos = -100
	local yPos = -100

	if notificationType == "default" then
		local ColorBar = Drawing.new("Square")
		ColorBar.ZIndex = zIndex
		ColorBar.Size = Vector2.new(5, 60)
		ColorBar.Position = Vector2.new(xPos - 5, yPos)
		ColorBar.Color = barColor or Color3.fromRGB(255, 255, 255)
		ColorBar.Filled = true

		local Title = Drawing.new("Text")
		Title.ZIndex = zIndex + 1
		Title.Position = Vector2.new(xPos + 5, yPos + 2)
		Title.Color = titleColor or Color3.fromRGB(255, 255, 255)
		Title.Text = titleContent or "Title"
		Title.Outline = false

		local NotifMain = Drawing.new("Square")
		NotifMain.ZIndex = zIndex
		NotifMain.Size = Vector2.new(200, 60)
		NotifMain.Position = Vector2.new(xPos, yPos)
		NotifMain.Color = backgroundColor or Color3.fromRGB(30, 30, 30)
		NotifMain.Filled = true

		local BorderLine1 = Drawing.new("Square")
		BorderLine1.ZIndex = zIndex + 1
		BorderLine1.Size = Vector2.new(190, 2)
		BorderLine1.Position = Vector2.new(xPos + 5, yPos + 20)
		BorderLine1.Color = barColor or Color3.fromRGB(255, 255, 255)
		BorderLine1.Filled = true

		local Text = Drawing.new("Text")
		Text.ZIndex = zIndex + 1
		Text.Position = Vector2.new(xPos + 5, yPos + 25)
		Text.Color = textContentColor or Color3.fromRGB(255, 255, 255)
		Text.Text = processedText or "hi"
		Text.Outline = false

		local ProgressBarTop = Drawing.new("Square")
		ProgressBarTop.ZIndex = zIndex + 2
		ProgressBarTop.Size = Vector2.new(190, 2)
		ProgressBarTop.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarTop.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarTop.Filled = true

		local ProgressBarBottom = Drawing.new("Square")
		ProgressBarBottom.ZIndex = zIndex + 1
		ProgressBarBottom.Size = Vector2.new(190, 2)
		ProgressBarBottom.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarBottom.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarBottom.Filled = true
		ProgressBarBottom.Transparency = 0.5

		addNotification({ColorBar, Title, NotifMain, BorderLine1, Text, ProgressBarTop, ProgressBarBottom}, currID, duration, notificationType)
	end

	if notificationType == "outline" then
		local ColorBar = Drawing.new("Square")
		ColorBar.Size = Vector2.new(204, 64)
		ColorBar.Position = Vector2.new(xPos - 2, yPos - 2)
		ColorBar.Color = barColor or Color3.fromRGB(255, 255, 255)
		ColorBar.Filled = true

		local Title = Drawing.new("Text")
		Title.ZIndex = zIndex + 1
		Title.Position = Vector2.new(xPos + 5, yPos + 2)
		Title.Color = titleColor or Color3.fromRGB(255, 255, 255)
		Title.Text = titleContent or "Title"
		Title.Outline = false

		local NotifMain = Drawing.new("Square")
		NotifMain.ZIndex = zIndex
		NotifMain.Size = Vector2.new(200, 60)
		NotifMain.Position = Vector2.new(xPos, yPos)
		NotifMain.Color = backgroundColor or Color3.fromRGB(30, 30, 30)
		NotifMain.Filled = true

		local BorderLine1 = Drawing.new("Square")
		BorderLine1.ZIndex = zIndex + 1
		BorderLine1.Size = Vector2.new(190, 2)
		BorderLine1.Position = Vector2.new(xPos + 5, yPos + 20)
		BorderLine1.Color = barColor or Color3.fromRGB(255, 255, 255)
		BorderLine1.Filled = true

		local Text = Drawing.new("Text")
		Text.ZIndex = zIndex + 1
		Text.Position = Vector2.new(xPos + 5, yPos + 25)
		Text.Color = textContentColor or Color3.fromRGB(255, 255, 255)
		Text.Text = processedText or "hi"
		Text.Outline = false

		local ProgressBarTop = Drawing.new("Square")
		ProgressBarTop.ZIndex = zIndex + 2
		ProgressBarTop.Size = Vector2.new(190, 2)
		ProgressBarTop.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarTop.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarTop.Filled = true

		local ProgressBarBottom = Drawing.new("Square")
		ProgressBarBottom.ZIndex = zIndex + 1
		ProgressBarBottom.Size = Vector2.new(190, 2)
		ProgressBarBottom.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarBottom.Color = progressBarColor or Color3.fromRGB(255, 255, 255)
		ProgressBarBottom.Filled = true
		ProgressBarBottom.Transparency = 0.5

		addNotification({ColorBar, Title, NotifMain, BorderLine1, Text, ProgressBarTop, ProgressBarBottom}, currID, duration, notificationType)
	end

	if notificationType == "roundedOutline" then
		
		local Outline = Drawing.new("Square")
		Outline.Size = Vector2.new(208, 64)
		Outline.Position = Vector2.new(xPos - 4, yPos - 2)
		Outline.Color = barColor or Color3.fromRGB(255, 255, 255)
		Outline.Filled = true
		Outline.ZIndex = zIndex

		local Title = Drawing.new("Text")
		Title.Position = Vector2.new(xPos + 5, yPos + 5)
		Title.Color = Color3.fromRGB(255, 255, 255)
		Title.Text = titleContent or "Title"
		Title.Outline = false
		Title.ZIndex = zIndex + 2

		local Background = Drawing.new("Square")
		Background.Size = Vector2.new(204, 60)
		Background.Position = Vector2.new(xPos - 2, yPos)
		Background.Color = backgroundColor or Color3.fromRGB(30, 30, 30)
		Background.Filled = true
		Background.ZIndex = zIndex + 1

		local BorderLine1 = Drawing.new("Square")
		BorderLine1.Size = Vector2.new(190, 2)
		BorderLine1.Position = Vector2.new(xPos + 5, yPos + 20)
		BorderLine1.Color = lineColor or Color3.fromRGB(255, 255, 255)
		BorderLine1.Filled = true
		BorderLine1.ZIndex = zIndex + 2

		local Text = Drawing.new("Text")
		Text.Position = Vector2.new(xPos + 5, yPos + 25)
		Text.Color = textContentColor or Color3.fromRGB(255, 255, 255)
		Text.Text = textContent or "Text"
		Text.Outline = false
		Text.ZIndex = zIndex + 2

		local ProgressBarTop = Drawing.new("Square")
		ProgressBarTop.Size = Vector2.new(95, 2)
		ProgressBarTop.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarTop.Color = progressBarColor or Color3.new(255, 255, 255)
		ProgressBarTop.Filled = true
		ProgressBarTop.ZIndex = zIndex + 3

		local ProgressBarBottom = Drawing.new("Square")
		ProgressBarBottom.Size = Vector2.new(190, 2)
		ProgressBarBottom.Transparency = 0.5
		ProgressBarBottom.Position = Vector2.new(xPos + 5, yPos + 55)
		ProgressBarBottom.Color = progressBarColor or Color3.new(255, 255, 255)
		ProgressBarBottom.Filled = true
		ProgressBarBottom.ZIndex = zIndex + 2

		local OutlineCircleTopLeft = Drawing.new("Circle")
		OutlineCircleTopLeft.Position = Vector2.new(xPos, yPos)
		OutlineCircleTopLeft.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleTopLeft.Radius = 4
		OutlineCircleTopLeft.NumSides = 24
		OutlineCircleTopLeft.Filled = true
		OutlineCircleTopLeft.ZIndex = zIndex

		local OutlineCircleTopRight = Drawing.new("Circle")
		OutlineCircleTopRight.Position = Vector2.new(xPos + 200, yPos)
		OutlineCircleTopRight.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleTopRight.Radius = 4
		OutlineCircleTopRight.NumSides = 24
		OutlineCircleTopRight.Filled = true
		OutlineCircleTopRight.ZIndex = zIndex

		local OutlineCircleBottomLeft = Drawing.new("Circle")
		OutlineCircleBottomLeft.Position = Vector2.new(xPos, yPos + 60)
		OutlineCircleBottomLeft.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleBottomLeft.Radius = 4
		OutlineCircleBottomLeft.NumSides = 24
		OutlineCircleBottomLeft.Filled = true
		OutlineCircleBottomLeft.ZIndex = zIndex

		local OutlineCircleBottomRight = Drawing.new("Circle")
		OutlineCircleBottomRight.Position = Vector2.new(xPos + 200, yPos + 60)
		OutlineCircleBottomRight.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineCircleBottomRight.Radius = 4
		OutlineCircleBottomRight.NumSides = 24
		OutlineCircleBottomRight.Filled = true
		OutlineCircleBottomRight.ZIndex = zIndex

		local OutlineTop = Drawing.new("Square")
		OutlineTop.Size = Vector2.new(204, 68)
		OutlineTop.Position = Vector2.new(xPos - 2, yPos - 4)
		OutlineTop.Color = barColor or Color3.fromRGB(255, 255, 255)
		OutlineTop.Filled = true
		OutlineTop.ZIndex = zIndex

		local BackgroundCircleTopLeft = Drawing.new("Circle")
		BackgroundCircleTopLeft.Position = Vector2.new(xPos + 2, yPos + 2)
		BackgroundCircleTopLeft.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleTopLeft.Radius = 4
		BackgroundCircleTopLeft.NumSides = 24
		BackgroundCircleTopLeft.Filled = true
		BackgroundCircleTopLeft.ZIndex = zIndex + 1

		local BackgroundCircleTopRight = Drawing.new("Circle")
		BackgroundCircleTopRight.Position = Vector2.new(xPos + 198, yPos + 2)
		BackgroundCircleTopRight.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleTopRight.Radius = 4
		BackgroundCircleTopRight.NumSides = 24
		BackgroundCircleTopRight.Filled = true
		BackgroundCircleTopRight.ZIndex = zIndex + 1

		local BackgroundCircleBottomLeft = Drawing.new("Circle")
		BackgroundCircleBottomLeft.Position = Vector2.new(xPos + 2, yPos + 58)
		BackgroundCircleBottomLeft.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleBottomLeft.Radius = 4
		BackgroundCircleBottomLeft.NumSides = 24
		BackgroundCircleBottomLeft.Filled = true
		BackgroundCircleBottomLeft.ZIndex = zIndex + 1

		local BackgroundCircleBottomRight = Drawing.new("Circle")
		BackgroundCircleBottomRight.Position = Vector2.new(xPos + 198, yPos + 58)
		BackgroundCircleBottomRight.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundCircleBottomRight.Radius = 4
		BackgroundCircleBottomRight.NumSides = 24
		BackgroundCircleBottomRight.Filled = true
		BackgroundCircleBottomRight.ZIndex = zIndex + 1

		local BackgroundTop = Drawing.new("Square")
		BackgroundTop.Size = Vector2.new(200, 64)
		BackgroundTop.Position = Vector2.new(xPos, yPos - 2)
		BackgroundTop.Color = backgroundColor or Color3.fromRGB(0, 0, 0)
		BackgroundTop.Filled = true
		BackgroundTop.ZIndex = zIndex + 1

		addNotification({Outline, Title, Background, BorderLine1, Text, ProgressBarTop, ProgressBarBottom, OutlineTop, OutlineCircleTopLeft, OutlineCircleTopRight, OutlineCircleBottomLeft, OutlineCircleBottomRight, BackgroundCircleTopLeft, BackgroundCircleTopRight, BackgroundCircleBottomLeft, BackgroundCircleBottomRight, BackgroundTop, OutlineTop}, currID, duration, notificationType)

	end
	
	currID = currID + 1

end

--notif initializer
spawn(function()
	while true do
		task.wait()
		if #activeNotifications > 0 then
			for _, v in ipairs(activeNotifications) do
				if v.Initialized == false and v.Initializing == false then
					v.Initializing = true
					local gameWindowSize = game.Workspace.Camera.ViewportSize
					updateRelativePosition(v, Vector2.new(gameWindowSize.X - 200, gameWindowSize.Y - 120))
					v.Initialized = true
					spawn(function()
						local startTime = os.clock()
						while os.clock() - startTime < v.Duration do
							task.wait()
							local elapsed = os.clock() - startTime
							local timeLeft = v.Duration - elapsed

							local percent = math.clamp(timeLeft / v.Duration, 0, 1)
							local progressBar = v.Elements[6]
							progressBar.Size = Vector2.new(190 * percent, progressBar.Size.Y)
						end

						for _, element in ipairs(v.Elements) do
							element:Remove()
						end
						table.remove(activeNotifications, table.find(activeNotifications, v))
					end)

				end
			end
		end
	end
end)

-- notif updates
spawn(function()
	while true do
		if #activeNotifications > 0 then
			for _, v in ipairs(activeNotifications) do
				if v.Initialized == true then		
					table.sort(activeNotifications, function(a, b)
						return a.ID > b.ID
					end)
					local baseY = game.Workspace.Camera.ViewportSize.Y - 70
					for index, notif in ipairs(activeNotifications) do
						local offsetY = (index - 1) * -70
						local gameWindowSize = game.Workspace.Camera.ViewportSize
						local pos = Vector2.new(gameWindowSize.X - 212, baseY + offsetY)
						updateRelativePosition(notif, pos)
					end

				end
			end
		end
		task.wait()
	end
end)
