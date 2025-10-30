--[[

    🎃 Hello Spooky skidder!! 🎃

    How are you my fellow skid? I am
    surprised you got here! I'd like
    to ask for you to not skid from 
    my sources, its VERY bad quality
    and i don't think its optimized
    lol

🎃     Donate here:
    https://www.roblox.com/game-pass/1480054132/

    TODO:
        mm2:
            sheriff esp
            murder esp
            grab gun - automatic grab gun
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

--> Spooky Supported Games
local SupportedGames = {
    --[142823291] = "Murder Mystery 2",
    [286090429] = "Arsenal",
    [7215881810] = "Strongest Punch Simulator",
    [155615604] = "Prison Life",
    [9872472334] = "Evade",
    [112757576021097] = "Defuse Division",
    
    [13559635034] = "Combat Initiation", -- these are literally SPECIAL lmfao
    [14582748896] = "Combat Initiation",
    
    [301549746] = "Counter Blox",
    [93838124426523] = "Boom Hood",
    [537413528] = "Build A Boat For Treasure",
    
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
print("Loading Arcane Hub...")

task.wait(1)

_G.GameName = gameName -- because YES

--> lil o' table
local GameLoaders = {
    --["Murder Mystery 2"] = function() end,
    ["Boom Hood"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Boom%20Hood.lua") end,
    ["Strongest Punch Simulator"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Strongest%20Punch%20Simulator.lua") end,
    ["Combat Initiation"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Combat%20initiation.lua") end,
    ["Prison Life"] = function() return game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Content/Strongest%20Punch%20Simulator.lua") end,
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
        print("Arcane Hub loaded successfully.")
    else
        print("Arcane Hub could not load.")
    end
end

return Arcane -- i think it returns something, just don't know what

--[[
語れない 眠れない トロイメライ
katarenai nemurenai toroimerai

あなたの見てる正体
anata no miteru shoutai

誰も読めないカルテ
daremo yomenai karute

不可思議知りたいだけ
fukashigi shiritai dake


嘘も現実も
uso mo genjitsu mo

どっちも真実だったの 本当よ
docchi mo shinjitsu datta no hontou yo

今日も独り言
kyou mo hitorigoto

何にも無理をしないで
nannimo muri wo shinaide

私愛されたい
watashi aisaretai


有耶無耶さよなら 軽いめまい
uyamuya sayonara karui memai

あなたのいない現象界
anata no inai genshoukai

誰も読めないカルテ
daremo yomenai karute

自意識溢れ出して
jiishiki afuredashite


鼓動世界像
kodou sekaizou

いつも髪合わないの 痛くて
itsumo kami awanai no itakute

舞い寄る願い事
maiyo negaigoto

何にも疑わないで
nannimo utagawanaide

混ざり溶け会いたい
mazari toke aitai


たわいない わからない理由 存在
tawainai wakaranai riyuu sonzai

あなたの残す後悔
anata no nokosu koukai

誰も読めないカルテ
daremo yomenai karute

不可解繰り返して
fuyukai kurikaeshite


正しい夢は 悲しい声は
tadashii yume wa kanashii koe wa

美しい
utsukushii?

疑わしい
utagawashii?

羨ましい
urayamashii?

ねえ、どれ
nee, dore?


語れない 眠れない トロイメライ
katarenai nemurenai toroimerai

あなたの見てる正体
anata no miteru shoutai

誰も読めないカルテ
daremo yomenai karute

不可思議知りたいだけ
fukashigi shiritai dake


終わらないことはない とろいめらい
owaranai koto wa nai toroimerai

あなたの股ぐく境界
anata no matagau kyoukai

誰も読めないカルテ
daremo yomenai karute

思春期傷口 胸の内
shishunki kizuguchi mune no uchi

不可思議知りたいだけ
fukashigi shiritai dake

]]
