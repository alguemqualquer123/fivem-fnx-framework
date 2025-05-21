local ServerCallbacks = {}
local ClientCallbacks = {}
local CallbackCounter = 0

-- REGISTRA um callback para ser chamado do client
function RegisterCallback(name, cb)
    ServerCallbacks[name] = cb
end

-- SERVER: escuta requisições do client
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
        -- é promise
        result:next(function(res)
            TriggerClientEvent('coreNova:receiveServerCallback', src, callbackId, res)
        end)
    else
        -- retorno direto
        TriggerClientEvent('coreNova:receiveServerCallback', src, callbackId, result)
    end
end)

-- SERVER CHAMA callback no client e espera resultado
function TriggerClientCallback(src, name, ...)
    local p = promise.new()
    CallbackCounter += 1
    local callbackId = ("cb_%s_%d"):format(name, CallbackCounter)

    ClientCallbacks[callbackId] = p

    TriggerClientEvent('coreNova:clientCallback', src, callbackId, name, ...)

    -- Timeout de segurança (10s)
    SetTimeout(10000, function()
        if ClientCallbacks[callbackId] then
            ClientCallbacks[callbackId] = nil
            p:resolve(nil)
        end
    end)

    return Citizen.Await(p)
end

-- Quando o client responde
RegisterNetEvent('coreNova:receiveClientCallback', function(callbackId, result)
    if ClientCallbacks[callbackId] then
        ClientCallbacks[callbackId]:resolve(result)
        ClientCallbacks[callbackId] = nil
    end
end)

exports('RegisterCallback', RegisterCallback)
exports('TriggerClientCallback', TriggerClientCallback)
