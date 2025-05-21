RegisterNetEvent('coreNova:clientCallback', function(callbackId, ...)
    local args = { ... }
    if _G[callbackId] then
        local result = _G[callbackId](table.unpack(args))
        TriggerClientEvent('coreNova:receiveCallback', source, callbackId, result)
    end
end)

function RegisterCallback(name, cb)
    _G[name] = cb
end

function TriggerServerCallback(name, source, ...)
    TriggerClientEvent('coreNova:clientCallback', source, name, ...)
end

exports('RegisterCallback', RegisterCallback)
exports('TriggerServerCallback', TriggerServerCallback)
