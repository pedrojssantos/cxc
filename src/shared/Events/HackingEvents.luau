-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Shared.Packages.Red)

return {
	RequestESPHack = Red.Event("OnESPHack", function(state: boolean)
		return state
	end),
}
