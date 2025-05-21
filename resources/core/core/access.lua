local queue = {}
local connected = {}

function isBanned(license)
    local p = promise.new()
    MySQL.query('SELECT * FROM bans WHERE license = ? AND (expires_at IS NULL OR expires_at > NOW())', { license }, function(res)
        p:resolve(res and res[1] or nil)
    end)
    return Citizen.Await(p)
end

function isWhitelisted(license)
    local p = promise.new()
    MySQL.query('SELECT * FROM whitelist WHERE license = ?', { license }, function(res)
        p:resolve(res and res[1] or nil)
    end)
    return Citizen.Await(p)
end

function getPriority(license)
    local p = promise.new()
    MySQL.query('SELECT priority FROM whitelist WHERE license = ?', { license }, function(res)
        p:resolve((res[1] and res[1].priority) or 0)
    end)
    return Citizen.Await(p)
end

function addToQueue(src, license)
    local priority = getPriority(license)
    table.insert(queue, { src = src, license = license, prio = priority, time = os.time() })
end

function processQueue()
    if #queue == 0 then return end
    table.sort(queue, function(a, b)
        if a.prio == b.prio then return a.time < b.time end
        return a.prio > b.prio
    end)

    for i, p in ipairs(queue) do
        if not connected[p.license] then
            connected[p.license] = true
            TriggerClientEvent('coreNova:queueAccepted', p.src)
            table.remove(queue, i)
            break
        end
    end
end

setInterval = function(cb, interval)
    CreateThread(function()
        while true do
            Wait(interval)
            cb()
        end
    end)
end

setInterval(processQueue, 3000)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local license = GetIdentifier(src, "license")

    deferrals.defer()
    Wait(100)
    deferrals.update("Verificando whitelist...")

    if not license then
        deferrals.done("Não conseguimos validar sua licença.")
        CancelEvent()
        return
    end

    local ban = isBanned(license)
    if ban then
        deferrals.done("Você está banido.\nMotivo: "..ban.reason.."\nAdmin: "..ban.banned_by)
        CancelEvent()
        return
    end

    local whitelist = isWhitelisted(license)
    if not whitelist then
        deferrals.done("Você não está na whitelist.")
        CancelEvent()
        return
    end

    deferrals.update("Adicionando à fila de espera...")
    addToQueue(src, license)

    local p = promise.new()

    RegisterNetEvent('coreNova:queueAccepted')
    AddEventHandler('coreNova:queueAccepted', function()
        if source == src then
            p:resolve(true)
        end
    end)

    local result = Citizen.Await(p)
    if result then
        deferrals.done()
    else
        deferrals.done("Erro na fila.")
    end
end)

function GetIdentifier(src, type)
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.find(v, type) then
            return v
        end
    end
    return nil
end

AddEventHandler("playerDropped", function(reason)
    local src = source
    local license = GetIdentifier(src, "license")
    connected[license] = nil
end)
