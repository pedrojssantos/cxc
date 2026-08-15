-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ESPHackView = require(ReplicatedStorage.Shared.UI.ESPHackView)

local localPlayer = Players.localPlayer

local function HasESPHack(world, playerEntity, HackingComponents)
	if world:has(playerEntity, HackingComponents.ESPHack) then
		ESPHackView.Render()
	end
end

return function(world, deltaTime, PlayerEntities, HackingComponents)
	local playerEntity = PlayerEntities[localPlayer]
	if not playerEntity then
		return
	end

	HasESPHack(world, playerEntity, HackingComponents)
end
