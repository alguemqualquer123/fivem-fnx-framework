local queue = {}
local connected = {}

function GetIdentifier(src, idType)
    if not src then
        return nil
    end
    if not idType then
        idType = "license"
    end

    local idTypeLower = idType:lower() .. ":"

    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if identifier:sub(1, #idTypeLower) == idTypeLower then
            return identifier:sub(#idTypeLower + 1)
        end
    end

    return nil
end

function isBanned(license)
    local p = promise.new()
    MySQL.query('SELECT * FROM bans WHERE license = ? AND (expires_at IS NULL OR expires_at > NOW())', {license},
        function(res)
            p:resolve(res and res[1] or nil)
        end)
    return Citizen.Await(p)
end

function isWhitelisted(license)
    local p = promise.new()
    MySQL.query('SELECT whitelist FROM users WHERE license = ?', {license}, function(res)
        if res and res[1] and res[1].whitelist == 1 then
            p:resolve(true)
        else
            p:resolve(false)
        end
    end)
    return Citizen.Await(p)
end

function EnsureAccount(license, name)
    local p = promise.new()

    MySQL.query('SELECT * FROM users WHERE license = ?', {license}, function(res)
        if res and #res > 0 then
            p:resolve(res[1])
        else
            local account = CreateUser(license, name)
            p:resolve(account)
        end
    end)

    return Citizen.Await(p)
end

function getPriority(license)
    local p = promise.new()
    MySQL.query('SELECT priority FROM users WHERE license = ?', {license}, function(res)
        p:resolve((res[1] and res[1].priority) or 0)
    end)
    return Citizen.Await(p)
end

function addToQueue(src, license)
    print("[coreNova] Adicionando " .. license .. " à fila")
    table.insert(queue, {
        src = src,
        license = license,
        prio = getPriority(license),
        time = os.time()
    })
end

function processQueue()
    if #queue == 0 then
        return
    end

    table.sort(queue, function(a, b)
        if a.prio == b.prio then
            return a.time < b.time
        end
        return a.prio > b.prio
    end)

    for i, p in ipairs(queue) do
        if not connected[p.license] then
            connected[p.license] = true
            TriggerClientEvent('coreNova:queueAccepted', p.src)
            print("[coreNova] Jogador " .. p.license .. " aceito da fila")
            table.remove(queue, i)
            break
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        processQueue()
    end
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local license = GetIdentifier(src, "license")
    local MaintenanceActive = "Servidor em manutenção!"
    local MaintenanceText = "O servidor está passando por manutenção programada."
    local AdaptativeConfig = {
        geral = {
            logo = "https://exemplo.com/logo.png",
            discord = "https://discord.gg/seuServidor",
            background = "https://exemplo.com/fundo.png"
        }
    }

    deferrals.defer()
    Wait(100)
    deferrals.update("Verificando whitelist...")

    if not license then
        deferrals.done("Não conseguimos validar sua licença.")
        CancelEvent()
        return
    end

    if connected[license] then
        deferrals.done()
        return
    end

    local account = EnsureAccount(license, name)

    local ban = isBanned(license)
    if ban then
        deferrals.done("Você está banido.\nMotivo: " .. ban.reason .. "\nAdmin: " .. ban.banned_by)
        CancelEvent()
        return
    end

    local whitelist = isWhitelisted(license)
    if not whitelist then
        local whitelistCard = [[
{
  "type": "AdaptiveCard",
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
  "version": "1.3",
  "body": [
    {
      "type": "Image",
      "url": "]] .. AdaptativeConfig.geral.logo .. [[",
      "spacing": "Large",
      "size": "Large",
      "horizontalAlignment": "Center"
    },
    {
      "type": "Container",
      "separator": true,
      "items": [
        {
          "type": "TextBlock",
          "text": "Acesso Negado - Whitelist",
          "wrap": true,
          "fontType": "Default",
          "weight": "Bolder",
          "color": "Attention",
          "size": "Large",
          "horizontalAlignment": "Center",
          "spacing": "None"
        }
      ]
    },
    {
      "type": "TextBlock",
      "text": "Você não está na whitelist do servidor. Para solicitar acesso, entre em contato pelo Discord.\nSeu id: ]] ..
                                  tostring(account.id) .. [[",
      "wrap": true,
      "size": "Medium",
      "color": "Warning",
      "fontType": "Default",
      "weight": "Bolder",
      "spacing": "Medium"
    },
    {
      "type": "Container",
      "separator": true
    },
    {
      "type": "ActionSet",
      "actions": [
        {
          "type": "Action.OpenUrl",
          "title": "Acesse o Discord",
          "url": "]] .. AdaptativeConfig.geral.discord .. [[",
          "iconUrl": "https://discord.com/assets/3437c10597c1526c3dbd98c737c2bcae.svg"
        }
      ]
    }
  ],
  "minHeight": "200px",
  "backgroundImage": {
    "url": "]] .. AdaptativeConfig.geral.background .. [["
  }
}
]]

        deferrals.presentCard(whitelistCard)
        CancelEvent()
        return
    end

    if #queue == 0 then
        connected[license] = true
        deferrals.done()
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

AddEventHandler("playerDropped", function(reason)
    local src = source
    local license = GetIdentifier(src, "license")

    if license then
        connected[license] = nil

        for i = #queue, 1, -1 do
            if queue[i].license == license then
                print("[coreNova] Removendo " .. license .. " da fila por desconexão")
                table.remove(queue, i)
            end
        end
    end
end)