RegisterCommand("nc", function(source, args)
    local src = source
    CoreClient.noClip(1)
    TriggerClientCallback("noClip", src)
end)

Core.Groups = function()
    return Groups
end


Core.StartServerLog = function(...)
    local args = {...}
    local msg = table.concat(args, " ")
    console.success(msg)
end

Core.testar = function(...)
    local args = {...}
    local msg = table.concat(args, " ")
    console.success(msg)
    return ...
end


-- HasPermission("EMS", "Resgatista", "revive")
function Core.HasPermission(group, rank, permission)
    local grp = Groups[group]
    if not grp then
        return false
    end

    local rankData = grp["Hierarchy"][rank]
    if not rankData then
        return false
    end

    if rankData["Permissions"] then
        for _, perm in pairs(rankData["Permissions"]) do
            if perm == permission or perm == "all" then
                return true
            end
        end
    end

    local parent = rankData["Parent"]
    if parent and parent ~= false then
        return HasPermission(group, parent[1], permission)
    end

    return false
end

RegisterNetEvent('coreNova:playerLoaded', function()
    local src = source
    local license = GetIdentifier(src, "license")

    local data = GetUserData(license)

    SetPlayerState(src, "money", data.money)
    print("[CoreNova] Player " .. src .. " carregado.")
end)

RegisterNetEvent('coreNova:queueAccepted')
AddEventHandler('coreNova:queueAccepted', function()
    local src = source

    local success = Core.LoadPlayer(src)
    if not success then
        DropPlayer(src, "Erro ao carregar seus dados.")
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    Core.OnPlayerDropped(src)
end)

RegisterCallback("getPlayerJob", function(data, cb)
    print("[getPlayerJob] Dados recebidos:", json.encode(data))

    local playerSrc = data.source or data.playerId
    local license = GetIdentifier(playerSrc, "license")

    local userData = GetUserData(license)

    if userData and userData.job then
        cb({
            job = userData.job
        })
    else
        cb({
            job = "desempregado"
        })
    end
end)

exports("FCore", Core)
