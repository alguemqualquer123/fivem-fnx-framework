AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
  end)
  

RegisterNetEvent('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() then
        Wait(500)
        TriggerServerEvent('coreNova:playerLoaded')
    end
end)

CreateThread(function()
    while true do
        Wait(2000)
        local money = LocalPlayer.state.money
        if money then
            print("Você tem $" .. money)
        end
        local job = TriggerServerCallback('getPlayerJob')
        if job then 
            print('Meu trabalho é: ', job)
        end
    end
end)
