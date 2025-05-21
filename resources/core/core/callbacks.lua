local ServerCallbacks = {}
local ClientCallbacks = {}
local CallbackCounter = 0

function RegisterCallback(name, cb)
    print("RegisterCallback",name)
    ServerCallbacks[name] = cb
end

RegisterNetEvent('coreNova:triggerServerCallback', function(name, callbackId, ...)
    local src = source
    local cb = ServerCallbacks[name]
    if not cb then
        print(("[CoreNova] Callback '%s' não registrado!"):format(name))
        TriggerClientEvent('coreNova:receiveServerCallback', src, callbackId, nil)
        return
    end

    local result = cb(src, ...)
    if result and type(result) == "table" and result.__await then
        result:next(function(res)
            TriggerClientEvent('coreNova:receiveServerCallback', src, callbackId, res)
        end)
    else
        TriggerClientEvent('coreNova:receiveServerCallback', src, callbackId, result)
    end
end)

function TriggerClientCallback(src, name, ...)
    local p = promise.new()
    CallbackCounter = CallbackCounter + 1
    local callbackId = ("cb_%s_%d"):format(name, CallbackCounter)

    ClientCallbacks[callbackId] = p

    TriggerClientEvent('coreNova:clientCallback', src, callbackId, name, ...)

    SetTimeout(10000, function()
        if ClientCallbacks[callbackId] then
            ClientCallbacks[callbackId] = nil
            p:resolve(nil)
        end
    end)

    return Citizen.Await(p)
end

RegisterNetEvent('coreNova:receiveClientCallback', function(callbackId, result)
    if ClientCallbacks[callbackId] then
        ClientCallbacks[callbackId]:resolve(result)
        ClientCallbacks[callbackId] = nil
    end
end)

exports('RegisterCallback', RegisterCallback)
exports('TriggerClientCallback', TriggerClientCallback)
