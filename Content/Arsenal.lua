loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaSecurity/Matcha-Scripts/refs/heads/main/Implementations/Ui%20Library.lua"))()

local function getGameName()
	return _G.GameName
end

local ArcaneHub = UILib.new('Arcane Hub', Vector2.new(750, 550), {getGameName})
local weaponsTab = ArcaneHub:Tab('Weapons')

local mainSection = ArcaneHub:Section(weaponsTab, 'Main Control')
local spreadSection = ArcaneHub:Section(weaponsTab, 'Spread Control')
local fireSection = ArcaneHub:Section(weaponsTab, 'Fire & Reload')
local ammoSection = ArcaneHub:Section(weaponsTab, 'Ammo Control')
local recoilSection = ArcaneHub:Section(weaponsTab, 'Recoil & Recovery')
local equipSection = ArcaneHub:Section(weaponsTab, 'Equip Speed')

local enableTweaks = false
local spreadEnabled = false
local instantFire = false
local instantReload = false
local instantEquip = false
local infiniteAmmo = false
local recoilEnabled = false
local autoGunsEnabled = false

local spreadValue = 0
local maxSpreadValue = 0
local fireRateValue = 0
local reloadTimeValue = 0
local equipTimeValue = 0
local recoilControlValue = 0
local spreadRecoveryValue = 255
local ammoValue = 255
local storedAmmoValue = 255

local function applyWeaponTweaks()
	if not enableTweaks then return end

	local weapons = game.ReplicatedStorage:FindFirstChild("Weapons")
	if not weapons then return end

	for _, v in pairs(weapons:GetDescendants()) do
		if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("BoolValue") then
			
			if autoGunsEnabled and v.Name == "Auto" and v:IsA("BoolValue") then
				v.Value = true
			end

			if spreadEnabled then
				if v.Name == "Spread" then
					v.Value = spreadValue
				elseif v.Name == "MaxSpread" then
					v.Value = maxSpreadValue
				end
			end

			if v.Name == "FireRate" and instantFire then
				v.Value = fireRateValue
			elseif v.Name == "ReloadTime" and instantReload then
				v.Value = reloadTimeValue
			end

			if v.Name == "EquipTime" and instantEquip then
				v.Value = equipTimeValue
			end

			if infiniteAmmo then
				if v.Name == "Ammo" then
					v.Value = ammoValue
				elseif v.Name == "StoredAmmo" then
					v.Value = storedAmmoValue
				end
			end

			if recoilEnabled then
				if v.Name == "RecoilControl" then
					v.Value = recoilControlValue
				elseif v.Name == "SpreadRecovery" then
					v.Value = spreadRecoveryValue
				end
			end
		end
	end
end

ArcaneHub:Checkbox(weaponsTab, mainSection, 'Enable Weapon Mods', false, function(state)
	enableTweaks = state
	if state then applyWeaponTweaks() end
end)

ArcaneHub:Checkbox(weaponsTab, spreadSection, 'Enable Spread Control', false, function(state)
	spreadEnabled = state
	if enableTweaks then applyWeaponTweaks() end
end)

ArcaneHub:Slider(weaponsTab, spreadSection, 'Spread', 0, function(value)
	spreadValue = value
	if enableTweaks and spreadEnabled then applyWeaponTweaks() end
end, 0, 10, 0.1, '')

ArcaneHub:Slider(weaponsTab, spreadSection, 'Max Spread', 0, function(value)
	maxSpreadValue = value
	if enableTweaks and spreadEnabled then applyWeaponTweaks() end
end, 0, 10, 0.1, '')

ArcaneHub:Checkbox(weaponsTab, fireSection, 'Automatic Guns', false, function(state)
	autoGunsEnabled = state
	if enableTweaks then applyWeaponTweaks() end
end)

ArcaneHub:Checkbox(weaponsTab, fireSection, 'Instant Fire', false, function(state)
	instantFire = state
	if enableTweaks then applyWeaponTweaks() end
end)

ArcaneHub:Checkbox(weaponsTab, fireSection, 'Instant Reload', false, function(state)
	instantReload = state
	if enableTweaks then applyWeaponTweaks() end
end)

ArcaneHub:Slider(weaponsTab, fireSection, 'Fire Rate', 0, function(value)
	fireRateValue = value
	if enableTweaks and instantFire then applyWeaponTweaks() end
end, 0.1, 10, 0.1, ' sec')

ArcaneHub:Slider(weaponsTab, fireSection, 'Reload Time', 0, function(value)
	reloadTimeValue = value
	if enableTweaks and instantReload then applyWeaponTweaks() end
end, 0.1, 10, 0.1, ' sec')

ArcaneHub:Checkbox(weaponsTab, equipSection, 'Instant Equip', false, function(state)
	instantEquip = state
	if enableTweaks then applyWeaponTweaks() end
end)

ArcaneHub:Slider(weaponsTab, equipSection, 'Equip Time', 0, function(value)
	equipTimeValue = value
	if enableTweaks and instantEquip then applyWeaponTweaks() end
end, 0.1, 5, 0.1, ' sec')

ArcaneHub:Checkbox(weaponsTab, ammoSection, 'Infinite Ammo', false, function(state)
	infiniteAmmo = state
	if enableTweaks then applyWeaponTweaks() end
end)

ArcaneHub:Slider(weaponsTab, ammoSection, 'Ammo', 255, function(value)
	ammoValue = value
	if enableTweaks and infiniteAmmo then applyWeaponTweaks() end
end, 0, 255, 1, '')

ArcaneHub:Slider(weaponsTab, ammoSection, 'Stored Ammo', 255, function(value)
	storedAmmoValue = value
	if enableTweaks and infiniteAmmo then applyWeaponTweaks() end
end, 0, 255, 1, '')

ArcaneHub:Checkbox(weaponsTab, recoilSection, 'Enable Recoil Control', false, function(state)
	recoilEnabled = state
	if enableTweaks then applyWeaponTweaks() end
end)

ArcaneHub:Slider(weaponsTab, recoilSection, 'Recoil Control', 0, function(value)
	recoilControlValue = value
	if enableTweaks and recoilEnabled then applyWeaponTweaks() end
end, 0, 255, 1, '')

ArcaneHub:Slider(weaponsTab, recoilSection, 'Spread Recovery', 255, function(value)
	spreadRecoveryValue = value
	if enableTweaks and recoilEnabled then applyWeaponTweaks() end
end, 0, 255, 1, '')

ArcaneHub:CreateSettingsTab()

local running = true
while running do
	ArcaneHub:Step()
	wait(0)
end
ArcaneHub:Destroy()
