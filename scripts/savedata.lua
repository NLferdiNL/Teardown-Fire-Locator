#include "datascripts/keybinds.lua"

moddataPrefix = "savegame.mod.firelocator"

function saveFileInit()
	saveVersion = GetInt(moddataPrefix .. "Version")
	
	refreshRate = GetFloat(moddataPrefix .. "RefreshRate")
	alwaysActive = GetBool(moddataPrefix .. "AlwaysActive")
	range = GetFloat(moddataPrefix .. "Range")
	
	if saveVersion < 1 or saveVersion == nil then
		saveVersion = 1
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		refreshRate = 1
		GetFloat(moddataPrefix .. "RefreshRate", refreshRate)
		
		alwaysActive = false
		SetBool(moddataPrefix .. "AlwaysActive", alwaysActive)
		
		range = 100
		SetFloat(moddataPrefix .. "Range", range)
	end
end

function saveDataValues()
	SetFloat(moddataPrefix .. "RefreshRate", refreshRate)
	SetFloat(moddataPrefix .. "Range", range)
	SetBool(moddataPrefix .. "AlwaysActive", alwaysActive)
end