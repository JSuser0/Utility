-- [ SERVICES ] --
local contentProvider = game:GetService("ContentProvider")

-- [ MODULE ] --
local Animation = { };

function Animation:Preload(animation)
	contentProvider:PreloadAsync({animation})
end

function Animation:Load(humanoid, id)
	local function Load(humanoid, id)
		local animation = Instance.new("Animation")
		
		if (typeof(id) == "number") then
			animation.AnimationId = string.format("rbxassetid://%s", id)
		else
			animation.AnimationId = id
		end
		
		Animation:Preload(animation)
		
		local track = humanoid.Animator:LoadAnimation(animation)
		animation:Destroy()
		
		return track
	end
	
	if (typeof(id) == "number" or typeof(id) == "string") then
		return Load(humanoid, id)
		
	elseif (typeof(id) == "table") then
		local ids = {}
		
		for _, v in pairs(id) do
			table.insert(ids, Load(humanoid, v))
		end
		
		return ids
	end
end

function Animation:StopTrackById(humanoid, id)
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		if (track.Animation.AnimationId == id) then
			track:Stop()
		end
	end
end

function Animation:Stop(track)
	if (typeof(track) ~= "table") then track:Stop() return end

	task.defer(function()
		for _, t in pairs(track) do
			t:Stop()
		end
	end)	
end

function Animation:Play(track)
	if (typeof(track) ~= "table") then track:Play() return end
	
	task.defer(function()
		for _, t in pairs(track) do
			t:Play()
			
			if (t.Looped == true) then continue end
			t.Stopped:Wait()
		end
	end)	
end

return Animation