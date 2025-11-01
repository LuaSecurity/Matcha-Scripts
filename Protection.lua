task.spawn(function()
    for i = 1, 10 do
    local original_loadstring = loadstring

    loadstring = function(chunk, chunkname)
        if type(chunk) == "string" then
        end
        return original_loadstring(chunk, chunkname)
        end
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Arcane%20Loader.lua"))()
