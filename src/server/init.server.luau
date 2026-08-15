-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")

local jecs = require(rs.Shared.Packages.Jecs)
local HackingComponents = require(rs.Shared.Components.HackingComponents)

-- Server Systems
local HackingSystemServer = require(script.Systems.HackingSystemServer)
local HackingSystemNetworkServer = require(script.Systems.HackingSystemNetworkServer)

local PlayerEntities = {}

local world = jecs.World.new()
HackingComponents:Init(world)

local function onPlayerAdded(player)
	local entityId = world:entity()
	PlayerEntities[player] = entityId
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

Players.PlayerRemoving:Connect(function(player)
	local entityId = PlayerEntities[player]
	if entityId then
		world:delete(entityId)
		PlayerEntities[player] = nil
	end
end)

-- Systems Network
HackingSystemNetworkServer.Init(world, PlayerEntities, HackingComponents)

-- Call all systems
RunService.Heartbeat:Connect(function(deltaTime)
	HackingSystemServer(world, deltaTime)
end)
