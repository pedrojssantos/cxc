local HackingComponents = {}

function HackingComponents:Init(world)
	self.ESPHack = world:component()
	self.SpeedHack = world:component()

	self.HackRequest = world:component()
end

return HackingComponents
