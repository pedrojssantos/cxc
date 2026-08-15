-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")

local jecs = require(rs.Shared.Packages.Jecs)
local HackingComponents = require(rs.Shared.Components.HackingComponents)

-- Client Systems
local HackingSystemClient = require(script.Systems.Hacking.HackingSystemClient)
local HackingSystemNetworkClient = require(script.Systems.Hacking.HackingSystemNetworkClient)

local RequestESPHack = require(rs.Shared.Events.HackingEvents).RequestESPHack

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
HackingSystemNetworkClient.Init(world, HackingComponents)

task.delay(2, function()
	RequestESPHack:Client():Fire()
end)

-- Call all Systems
RunService.RenderStepped:Connect(function(deltaTime)
	HackingSystemNetworkClient.HandleHackRequest(world, deltaTime, PlayerEntities, HackingComponents)
	HackingSystemClient(world, deltaTime, PlayerEntities, HackingComponents)
end)
