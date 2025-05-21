

RegisterCallback('getPlayerJob', function(source)
    local player = Player(source)
    return player.state.playerData and player.state.playerData.job or "unemployed"
end)


RegisterNetEvent('coreNova:playerLoaded', function()
    local src = source
    local license = GetPlayerIdentifier(src, 0)

    local data = Citizen.Await(GetUserData(license))

    if not data then
        CreateUser(license, GetPlayerName(src))
        data = Citizen.Await(GetUserData(license))
    end

    SetPlayerState(src, "money", data.money)
    print("[CoreNova] Player "..src.." carregado.")
end)


RegisterNetEvent('coreNova:queueAccepted')
AddEventHandler('coreNova:queueAccepted', function()
    local src = source

    local success = CoreNova.LoadPlayer(src)
    if not success then
        DropPlayer(src, "Erro ao carregar seus dados.")
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    CoreNova.OnPlayerDropped(src)
end)
