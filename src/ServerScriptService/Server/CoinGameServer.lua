-- Leaderboard setup: Add leaderstats and Coins value
print("HI")
local function onPlayerAdded(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Spawn a collectible at a random position within spawn area
local function spawnCollectible()
	local collectible = collectibleTemplate:Clone()
	local randomPos = Vector3.new(
		math.random(-SPAWN_AREA_SIZE.X / 2, SPAWN_AREA_SIZE.X / 2),
		SPAWN_HEIGHT,
		math.random(-SPAWN_AREA_SIZE.Z / 2, SPAWN_AREA_SIZE.Z / 2)
	)
	collectible.Position = workspace.Baseplate.Position + randomPos
	collectible.Parent = collectiblesFolder

	-- Setup touch event
	local touchedConn
	touchedConn = collectible.Touched:Connect(function(hit)
		local character = hit.Parent
		if not character then
			return
		end
		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end

		-- Add coins
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local coins = leaderstats:FindFirstChild("Coins")
			if coins then
				coins.Value = coins.Value + COIN_VALUE
			end
		end

		-- Cleanup collectible (disconnect touched event)
		touchedConn:Disconnect()
		collectible:Destroy()
	end)

	-- Auto-remove collectible after lifetime expires
	delay(COLLECTIBLE_LIFETIME, function()
		if collectible and collectible.Parent then
			touchedConn:Disconnect()
			collectible:Destroy()
		end
	end)
end

-- Periodically ensure there are collectibles in the world
spawn(function()
	while true do
		local currentCount = #collectiblesFolder:GetChildren()
		if currentCount < MAX_COLLECTIBLES then
			spawnCollectible()
		end
		wait(2)
	end
end)

return true
