RegisterNetEvent('coreNova:playerLoaded', function()
    local src = source
    local license = GetIdentifier(src, "license")

    local data = GetUserData(license)

    SetPlayerState(src, "money", data.money)
    print("[CoreNova] Player "..src.." carregado.")
end)

RegisterNetEvent('coreNova:queueAccepted')
AddEventHandler('coreNova:queueAccepted', function()
    local src = source

    local success = FCore.LoadPlayer(src)
    if not success then
        DropPlayer(src, "Erro ao carregar seus dados.")
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    FCore.OnPlayerDropped(src)
end)

RegisterCallback("getPlayerJob", function(data, cb)
    print("[getPlayerJob] Dados recebidos:", json.encode(data))

    local playerSrc = data.source or data.playerId
    local license = GetIdentifier(playerSrc, "license")

    local userData = GetUserData(license)

    if userData and userData.job then
        cb({ job = userData.job })
    else
        cb({ job = "desempregado" })
    end
end)

exports("FCore", FCore)