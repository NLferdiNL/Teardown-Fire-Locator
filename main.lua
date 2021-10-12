#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/menu.lua"
#include "datascripts/keybinds.lua"
#include "datascripts/inputList.lua"

toolName = "firelocator"
toolReadableName = "Fire Locator"

local menu_disabled = false
local fireCount = 0
local fires = {}

range = 100
local steps = 50

refreshRate = 1
local currentRefreshTimer = 0

alwaysActive = false

function init()
	saveFileInit()
	menu_init()
	
	RegisterTool(toolName, toolReadableName, "MOD/vox/tool.vox")
	SetBool("game.tool." .. toolName .. ".enabled", true)
	--SetFloat("game.tool." .. toolName .. ".ammo", 100)
end

function tick(dt)
	if not menu_disabled then
		menu_tick(dt)
	end
	
	local isMenuOpenRightNow = isMenuOpen()
	
	if isMenuOpenRightNow then
		return
	end
	
	if (GetString("game.player.tool") ~= toolName or GetPlayerVehicle() ~= 0) and not alwaysActive then
		return
	end
	
	if GetFireCount() <= 0 then
		fireCount = 0
		return
	end
	
	currentRefreshTimer = currentRefreshTimer - dt
	
	if currentRefreshTimer <= 0 then
		currentRefreshTimer = refreshRate
		
		fires, fireCount = QueryFires()
	end
end

function draw(dt)
	menu_draw(dt)
	
	local isMenuOpenRightNow = isMenuOpen()
	
	if isMenuOpenRightNow then
		return
	end
	
	if (GetString("game.player.tool") ~= toolName or GetPlayerVehicle() ~= 0) and not alwaysActive then
		return
	end
	
	if fireCount <= 0 then
		return
	end
	
	drawFireIcons()
end

-- UI Functions (excludes sound specific functions)

function drawFireIcons()
	UiPush()
		UiAlign("center middle")
		
		for key, value in pairs(fires) do
			UiPush()
				local xPos, yPos, dist = UiWorldToPixel(value)
				if dist > 0 then
					UiTranslate(xPos, yPos)
					UiImageBox("MOD/sprites/fire.png", 50, 50, 0, 0)
				end
			UiPop()
		end
	UiPop()
end

-- Creation Functions

-- Object handlers

-- Tool Functions

-- Particle Functions

-- Action functions

function QueryFires()
	local fires = {}
	local playerPos = GetPlayerTransform().pos
	
	ParticleReset()
	ParticleColor(0, 0, 1)
	
	local fireCount = 0
	
	for x = 0, range * 2 / steps, 1 do
		for z = 0, range * 2 / steps, 1 do
			local currPos = Vec(playerPos[1] - range + steps * x, 
								playerPos[2], 
								playerPos[3] - range + steps * z)
			
			local hit, pos = QueryClosestFire(currPos, steps)
			
			if hit then
				-- Prevent duplicate fires with this
				local posString = pos[1] .. "," .. pos[2] .. "," .. pos[3]
				
				if fires[posString] == nil then
					fireCount = fireCount + 1
					fires[posString] = pos
				end
			end
		end
	end
	
	return fires, fireCount
end

-- Sprite Functions

-- UI Sound Functions

-- Misc Functions