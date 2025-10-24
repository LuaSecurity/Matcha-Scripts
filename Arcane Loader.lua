--[[

	🎃 Hello Spooky skidder!! 🎃

 How are you my fellow skid? I'd like
 to ask for you to not skid from my 
 sources, its VERY bad quality and i
 don't think its optimized lol

🎃	Donate here:
	https://www.roblox.com/game-pass/1480054132/

]]

local Arcane = {}

--> Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--> Game Data, useless for now
local PlaceId = game.PlaceId
local JobId = game.JobId

--> Spooky Supported Games
local SupportedGames = {
	[142823291] = "Murder Mystery 2",
	[93838124426523] = "Boom Hood",
	[537413528] = "Build A Boat For Treasure",
	[87812856808709] = "Arcane Hub Testing Place"
}

--> Functions
local function GetSupportedGame(placeId)
	local name = SupportedGames[placeId]
	if not name then
		return false, "Unsupported game."
	end
	return true, name
end

--> Main
local isSupported, gameName = GetSupportedGame(PlaceId)

if not isSupported then
	print(gameName)
	return
end

print("Supported game found: " .. gameName)
print("Loading Arcane Hub...")

task.wait(1)

--> Loads
if gameName == "Murder Mystery 2" then
elseif gameName == "Boom Hood" then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Boom%20Hood%20Candy%20Autofarm"))()
elseif gameName == "Build A Boat For Treasure" then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Build%20a%20Boat.lua'))()
elseif gameName == "Arcane Hub Testing Place" then
	print("Test place UwU")
end

task.wait(0.5)
print("Arcane Hub loaded successfully.")

return Arcane
