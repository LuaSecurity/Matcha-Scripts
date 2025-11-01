local _ORIG = rawget(_G, "loadstring") or load
local function ensure_unhook(max_attempts, delay)
	max_attempts = max_attempts or 5
	delay = delay or 0.05
	local attempts = 0
	local function ok() return tostring(loadstring) == tostring(_ORIG) end
	while not ok() and attempts < max_attempts do
		attempts = attempts + 1
		pcall(function() loadstring = _ORIG end)
		task.wait(delay)
	end
	return ok()
end

if not ensure_unhook(10, 0.05) then
	error("failed to secure loadstring")
end

if _G.__ARCANE_LOADER_LOADED then return end
_G.__ARCANE_LOADER_LOADED = true

local src = game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Arcane%20Loader.lua")
local ok, chunk_or_err = pcall(_ORIG, src, "ArcaneLoader")
if not ok or type(chunk_or_err) ~= "function" then
	error(chunk_or_err or "compile failed")
end
pcall(chunk_or_err)
