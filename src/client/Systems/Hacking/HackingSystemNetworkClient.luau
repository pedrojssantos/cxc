-- Services
local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RequestESPHack = require(rs.Shared.Events.HackingEvents).RequestESPHack

local localPlayer = Players.LocalPlayer

local HackingSystemNetworkClient = {}

function HackingSystemNetworkClient.Init(world, HackingComponents)
	RequestESPHack:Client():On(function(state)
		local requestEntity = world:entity()

		world:set(requestEntity, HackingComponents.HackRequest, {
			hackName = "ESPHack",
			isActive = state,
		})
	end)
end

function HackingSystemNetworkClient.HandleHackRequest(world, deltaTime, PlayerEntities, HackingComponents)
	local playerEntity = PlayerEntities[localPlayer]

	if not playerEntity then
		return
	end

	for requestEntity, reqData in world:query(HackingComponents.HackRequest) do
		if not reqData then
			return
		end

		local targetComponent = HackingComponents[reqData.hackName]

		if targetComponent then
			if reqData.isActive then
				world:set(playerEntity, targetComponent, true)
				print("hack granted to the player " .. localPlayer.Name)
			else
				world:remove(playerEntity, targetComponent)
				print("hack removed from the  player " .. localPlayer.Name)
			end
		else
			warn("target component not found -> client")
		end

		world:delete(requestEntity)
	end
end

return HackingSystemNetworkClient
