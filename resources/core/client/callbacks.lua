local ClientCallbacks = {}
local CallbackHandlers = {}
local CallbackCounter = 0

RegisterNetEvent('coreNova:clientCallback', function(callbackId, name, ...)
    local handler = CallbackHandlers[name]
    if not handler then
        print(("[CoreNova] Client callback '%s' não encontrado"):format(name))
        TriggerServerEvent('coreNova:receiveClientCallback', callbackId, nil)
        return
    end

    local result = handler(...)
    TriggerServerEvent('coreNova:receiveClientCallback', callbackId, result)
end)


function RegisterClientCallback(name, cb)
    CallbackHandlers[name] = cb
end


function TriggerServerCallback(name, ...)
    local p = promise.new()
    CallbackCounter += 1
    local callbackId = ("client_cb_%s_%d"):format(name, CallbackCounter)

    ClientCallbacks[callbackId] = p

    TriggerServerEvent('coreNova:triggerServerCallback', name, callbackId, ...)

    SetTimeout(10000, function()
        if ClientCallbacks[callbackId] then
            ClientCallbacks[callbackId]:resolve(nil)
            ClientCallbacks[callbackId] = nil
        end
    end)

    return Citizen.Await(p)
end

RegisterNetEvent('coreNova:receiveServerCallback', function(callbackId, result)
    if ClientCallbacks[callbackId] then
        ClientCallbacks[callbackId]:resolve(result)
        ClientCallbacks[callbackId] = nil
    end
end)

RegisterNetEvent("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        ClientCallbacks = {}
    end
end)

exports('RegisterClientCallback', RegisterClientCallback)
exports('TriggerServerCallback', TriggerServerCallback)
