-- [ SERVICES ] --
local replicatedStorage = game:GetService("ReplicatedStorage")
local networkClient = game:GetService("NetworkClient")
local insertService = game:GetService("InsertService")
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- [ VARIABLES ] --
local client = players.LocalPlayer
local character = client.Character

local camera = workspace.CurrentCamera
local mouse = client:GetMouse()

local rootPart = character:WaitForChild("HumanoidRootPart")

local function Update()
    pcall(function()
        character = client.Character
        rootPart = character:WaitForChild("HumanoidRootPart")
    end)
end

local functions = { };

function functions:GetNearestPlayer()
    task.defer(Update)
    
    local distances = { };

     for _, player in pairs(players:GetPlayers()) do
         if (player.Name == client.Name or not player.Character) then continue end
    
         pcall(function()
            local playerRootPart = player.Character.HumanoidRootPart
    
            table.insert(distances, {
                player.Character,
                (playerRootPart.Position - rootPart.Position).Magnitude or math.huge
            })
        end)
    end
    
    table.sort(distances, function(a, b)
        return b[2] > a[2]
    end)
    
     return distances[1][1], distances[1][2]
end

function functions:GetNearestPlayerByMouse()
    task.defer(Update)
    
    local distances = { };
    
     for _, player in pairs(players:GetPlayers()) do
         if (player.Name == client.Name or not player.Character) then continue end
    
         pcall(function()
            local playerRootPart = player.Character.HumanoidRootPart
    
            local vector, on_screen = camera:WorldToScreenPoint(playerRootPart.Position)
            if (not on_screen) then return end

            table.insert(distances, {
                player.Character,
                (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).Magnitude or math.huge
            })
        end)
    end
    
    table.sort(distances, function(a, b)
        return b[2] > a[2]
    end)
    
     return distances[1][1], distances[1][2]
end


function functions:LogData(hook, data)
    syn.request({
		Url = hook;
		Method = "POST";
		Headers = {
			["Content-Type"] = "application/json"
		};
		Body = httpService:JSONEncode({
			["content"] = data.Content;

			["embeds"] = {{
				["title"] = data.Title;

				["fields"] = {
					table.unpack(data.Fields);
				}
			}}
		})
	})
end


return functions