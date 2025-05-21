local spawnedPed = nil

RegisterNetEvent("coreNova:Opened")
AddEventHandler("coreNova:Opened", function()
    DoScreenFadeOut(0)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local spawnCoords = vector3(-267.0, -957.0, 31.2)
    local heading = 90.0

    local model = GetHashKey("mp_m_freemode_01")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    spawnedPed = CreatePed(4, model, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, false, true)
    SetEntityAsMissionEntity(spawnedPed, true, true)
    SetPedDefaultComponentVariation(spawnedPed)

    SetPlayerModel(PlayerId(), model)
    SetEntityCoords(PlayerPedId(), spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, true)
    SetEntityHeading(PlayerPedId(), heading)
    FreezeEntityPosition(PlayerPedId(), false)

    DoScreenFadeIn(1000)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and spawnedPed then
        if DoesEntityExist(spawnedPed) then
            DeleteEntity(spawnedPed)
            print("[coreNova] Ped deletado ao parar resource.")
        end
    end
end)

AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(true, true)
end)

Citizen.CreateThread(function()
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
end)

RegisterNetEvent("onClientResourceStart")
AddEventHandler("onClientResourceStart",function(Resource)
	if GetCurrentResourceName() == Resource then
		SetNuiFocus(true, true)
		DoScreenFadeOut(0)
		DisplayRadar(false)
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		TriggerEvent("coreNova:Opened")
		return
	end
end)

RegisterNetEvent('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() then
        Wait(500)
        TriggerServerEvent('coreNova:playerLoaded')
    end
end)
