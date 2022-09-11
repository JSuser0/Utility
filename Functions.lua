local functions = { };

function function:GetNearestPlayer()
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


return functions