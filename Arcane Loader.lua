
-- Hi pookie!!! why u reading this?
--[[

    🎄 Hello Jolly skidder!! 🎄

    How are you my fellow skid? I am
    surprised you got here! I'd like
    to ask for you to not skid from 
    my sources, its VERY bad quality
    and i don't think its optimized
    lol


🎁     Donate here:
    https://www.roblox.com/game-pass/1480054132/

    TODO:

        mm2:
            kill all
            coin auto farm

]]

local Arcane = {}

--> Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--> Game Data, "useless" for now
local PlaceId = game.PlaceId
local JobId = game.JobId
local Username = LocalPlayer.Name

--> Universal
local Universal = "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Universal.lua"

--> Supported Games
-- [123] = {"hi", "https"}
local SupportedGames = {
    [286090429] = {"Arsenal", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Arsenal.lua"},
    [7215881810] = {"Strongest Punch Simulator", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Strongest%20Punch%20Simulator.lua"},
    [155615604] = {"Prison Life", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Prison%20Life.lua"},
    [9872472334] = {"Evade", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Evade.lua"},
    [112757576021097] = {"Defuse Division", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Defuse%20Division.lua"},
    [142823291] = {"Murder Mystery 2", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/MM2.lua"},
    [301549746] = {"Counter Blox", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Counter%20Blox.lua"},
    [93838124426523] = {"Boom Hood", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Boom%20Hood.lua"},
    [537413528] = {"Build A Boat For Treasure", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/BABFT.lua"},
    
    [13559635034] = {"Combat Initiation", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Combat%20initiation.lua"}, -- Special kids game idgaf
    [14582748896] = {"Combat Initiation", "https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Combat%20initiation.lua"},
}

--> Functions
local function GetSupportedGame(placeId)
    local gameData = SupportedGames[placeId]
    if not gameData then
        return false, nil, nil
    end
    return true, gameData[1], gameData[2]
end

--> Main
local isSupported, gameName, scriptUrl = GetSupportedGame(PlaceId)

if not isSupported then
    print("Game not supported, Loading universal version.")
    gameName = "Universal"
    scriptUrl = Universal
else
    print("Supported game found: " .. gameName)
end

print("Loading Arcane Hub!")

local Players = game:GetService("Players")
local BaseUrl = "https://arcanecheats.xyz/api/activity/"
local Product = "Arcane" 
local Username = Players.LocalPlayer.Name
local PlaceId = tostring(game.PlaceId)

local RequestUrl = BaseUrl .. Product .. "/" .. Username .. "/" .. PlaceId

pcall(function()
    game:HttpGet(RequestUrl)
end)

task.wait(1)

_G.GameName = gameName -- because YES

--> Loads sript
if scriptUrl then
    local success = pcall(function()
        local scriptContent = game:HttpGet(scriptUrl)
        if scriptContent then
            loadstring(scriptContent)()
        end
    end)
    
    if success then
        print("Arcane Hub has loaded successfully!")
    else
        print("Couldn't load, Maybe you did something wrong?")
    end
end

return Arcane -- i think it returns something, maybe a present.



