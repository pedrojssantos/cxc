-- Services
local rs = game:GetService("ReplicatedStorage")

local RequestESPHack = require(rs.Shared.Events.HackingEvents).RequestESPHack

local HackingSystemNetworkServer = {}

function HackingSystemNetworkServer.Init(world, PlayerEntities, HackingComponents)
	RequestESPHack:Server():On(function(player)
		local entityId = PlayerEntities[player]
		if not entityId then
			return
		end

		-- Rules

		world:set(entityId, HackingComponents.ESPHack, true)

		RequestESPHack:Server():Fire(player, true)
		print("the server granted hack to the player :", player.Name)
	end)
end

return HackingSystemNetworkServer
