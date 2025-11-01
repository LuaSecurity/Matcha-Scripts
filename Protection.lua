task.spawn(function()
    for i = 1, 10 do
      local Original = loadstring

      loadstring = function(Chunk, ChunkName)
        if type(Chunk) == "string" then
        end
        return Original(Chunk, ChunkName)
      end
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Arcane%20Loader.lua"))()
