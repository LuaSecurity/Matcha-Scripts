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

--> Supported Games
local SupportedGames = {
    
    --[142823291] = "Murder Mystery 2",
    
    [286090429] = "Arsenal",
    [7215881810] = "Strongest Punch Simulator",
    [155615604] = "Prison Life",
    [9872472334] = "Evade",
    [112757576021097] = "Defuse Division",
    [142823291] = "Murder Mystery 2",
    [301549746] = "Counter Blox",
    [93838124426523] = "Boom Hood",
    [537413528] = "Build A Boat For Treasure",
    
    [13559635034] = "Combat Initiation", -- these are literally SPECIAL lmfao
    [14582748896] = "Combat Initiation",
    
    [87812856808709] = "Arcane Hub Testing Place"
}

--> Functions
local function GetSupportedGame(placeId)
    local name = SupportedGames[placeId]
    if not name then
        return false, "Unsupported game." -- womp womp
    end
    return true, name
end

--> Main
local isSupported, gameName = GetSupportedGame(PlaceId)
if not isSupported then
    return
end

print("Supported game found: " .. gameName)
print("Loading Arcane Hub!")

task.wait(1)

_G.GameName = gameName -- because YES

--> lil o' Table
local GameLoaders = {
    ["Murder Mystery 2"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/MM2.lua") end,
    ["Boom Hood"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Boom%20Hood.lua") end,
    ["Strongest Punch Simulator"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Strongest%20Punch%20Simulator.lua") end,
    ["Combat Initiation"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Combat%20initiation.lua") end,
    ["Prison Life"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Prison%20Life.lua") end,
    ["Evade"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Evade.lua") end,
    ["Defuse Division"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Defuse%20Division.lua") end,
    ["Build A Boat For Treasure"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/BABFT.lua") end,
    ["Arsenal"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Arsenal.lua") end,
    ["Counter Blox"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Counter%20Blox.lua") end,
    ["Arcane Hub Testing Place"] = function() print("Test place UwU") end
}

--> Loads sript
local loaderFunc = GameLoaders[gameName]
if loaderFunc then
    local success = pcall(function()
        local scriptContent = loaderFunc()
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

--[[
katarenai nemurenai toroimerai

anata no miteru shoutai

daremo yomenai karute

fukashigi shiritai dake


uso mo genjitsu mo

docchi mo shinjitsu datta no hontou yo

kyou mo hitorigoto

nannimo muri wo shinaide

watashi aisaretai


uyamuya sayonara karui memai

anata no inai genshoukai

daremo yomenai karute

jiishiki afuredashite


kodou sekaizou

itsumo kami awanai no itakute

maiyo negaigoto

nannimo utagawanaide

mazari toke aitai


tawainai wakaranai riyuu sonzai

anata no nokosu koukai

daremo yomenai karute

fuyukai kurikaeshite


tadashii yume wa kanashii koe wa

utsukushii?

utagawashii?

urayamashii?

nee, dore?


katarenai nemurenai toroimerai

anata no miteru shoutai

daremo yomenai karute

fukashigi shiritai dake


owaranai koto wa nai toroimerai

anata no matagau kyoukai

daremo yomenai karute

shishunki kizuguchi mune no uchi

fukashigi shiritai dake

]]
