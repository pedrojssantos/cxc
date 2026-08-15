-- Services
local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local hackingGUI = playerGui:WaitForChild("HackingGUI")
local camera = workspace.CurrentCamera

-- Tables to store frames and billboards
local espFrames = {}
local espBillboards = {}

local function createLineFrame()
	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Magic number
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = hackingGUI
	return frame
end

local function createBoxBillboard()
	local billboard = Instance.new("BillboardGui")
	billboard.AlwaysOnTop = true
	billboard.Enabled = false
	billboard.Parent = hackingGUI

	local billboard_frame = Instance.new("Frame")
	billboard_frame.Size = UDim2.fromScale(1, 1)
	billboard_frame.BackgroundTransparency = 1
	billboard_frame.Parent = billboard

	local frame_stroke = Instance.new("UIStroke")
	frame_stroke.Thickness = 1
	frame_stroke.Color = Color3.fromRGB(255, 0, 0) -- Magic number
	frame_stroke.LineJoinMode = Enum.LineJoinMode.Miter
	frame_stroke.Parent = billboard_frame

	return billboard
end

Players.PlayerRemoving:Connect(function(leavingPlayer)
	if espFrames[leavingPlayer] then
		espFrames[leavingPlayer]:Destroy()
		espFrames[leavingPlayer] = nil
	end
	if espBillboards[leavingPlayer] then
		espBillboards[leavingPlayer]:Destroy()
		espBillboards[leavingPlayer] = nil
	end
end)

local View = {}

function View.Render()
	local character = localPlayer.Character
	if not character or not character:GetPivot() then
		for _, frame in pairs(espFrames) do
			frame.Visible = false
		end
		for _, billboard in pairs(espBillboards) do
			billboard.Enabled = false
		end
		return
	end

	local localPlayerCFrame, localPlayerSize = character:GetBoundingBox()
	local localPlayerFoot3D = localPlayerCFrame.Position - Vector3.new(0, localPlayerSize.Y / 2, 0)

	local startPosition3D = camera:WorldToViewportPoint(localPlayerFoot3D)

	for _, targetPlayer in Players:GetPlayers() do
		if targetPlayer ~= localPlayer then
			-- Create a frame and a billboard for the player
			local targetLineFrame = espFrames[targetPlayer]
			if not targetLineFrame then
				targetLineFrame = createLineFrame()
				espFrames[targetPlayer] = targetLineFrame
			end

			local targetBox = espBillboards[targetPlayer]
			if not targetBox then
				targetBox = createBoxBillboard()
				espBillboards[targetPlayer] = targetBox
			end

			if targetPlayer.Character and targetPlayer.Character:GetPivot() then
				local targetCFrame, targetSize = targetPlayer.Character:GetBoundingBox()
				local targetFoot3D = targetCFrame.Position - Vector3.new(0, targetSize.Y / 2, 0)

				-- Get the position on the screen of a 3d point(foot of the player)
				local endPosition3D, isEndOnScreen = camera:WorldToViewportPoint(targetFoot3D)
				local _, isBoxOnScreen = camera:WorldToViewportPoint(targetCFrame.Position)

				if isBoxOnScreen then
					targetBox.Enabled = true
					targetBox.Adornee = targetPlayer.Character.PrimaryPart
					targetBox.Size = UDim2.fromScale(targetSize.X, targetSize.Y)
				else
					targetBox.Enabled = false
				end

				if isEndOnScreen then
					targetLineFrame.Visible = true

					local startPosition = Vector2.new(startPosition3D.X, startPosition3D.Y)
					local endPosition = Vector2.new(endPosition3D.X, endPosition3D.Y)

					-- Calcule the properties of the line(frame) on the screen
					local distance = (endPosition - startPosition).Magnitude
					local centerPosition = (startPosition + endPosition) / 2
					local angle = math.atan2(endPosition.Y - startPosition.Y, endPosition.X - startPosition.X)

					targetLineFrame.Size = UDim2.fromOffset(distance, 1)
					targetLineFrame.Position = UDim2.fromOffset(centerPosition.X, centerPosition.Y)
					targetLineFrame.Rotation = math.deg(angle)
				else
					targetLineFrame.Visible = false
				end
			else
				targetLineFrame.Visible = false
				targetBox.Enabled = false
			end
		end
	end
end

function View.Hide()
	for _, frame in pairs(espFrames) do
		frame.Visible = false
	end
end

return View
