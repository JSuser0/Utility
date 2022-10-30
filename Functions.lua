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
    
            table.insert(distances, {
                player.Character,
                (mouse.Hit.Position - playerRootPart.Position).Magnitude or math.huge
            })
        end)
    end
    
    table.sort(distances, function(a, b)
        return b[2] > a[2]
    end)
    
     return distances[1][1], distances[1][2]
end


function functions:LogData()
end


return functions