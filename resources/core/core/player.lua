local players = {}

function CoreNova.LoadPlayer(src)
    local license = GetIdentifier(src, "license")
    if not license then return end

    local p = promise.new()
    MySQL.query('SELECT * FROM players WHERE license = ?', { license }, function(result)
        if result and result[1] then
            local data = result[1]
            players[src] = data

            -- Sincroniza dados no stateBag
            local state = Player(src).state
            state:set('playerData', {
                id = data.id,
                name = GetPlayerName(src),
                license = data.license,
                job = data.job or "unemployed"
            }, true)

            print(("[CoreNova] %s (%s) carregado."):format(data.name, license))
            p:resolve(true)
        else
            -- Novo jogador
            MySQL.query('INSERT INTO players (license, name) VALUES (?, ?)', {
                license,
                GetPlayerName(src)
            }, function(inserted)
                CoreNova.LoadPlayer(src) -- chama novamente após criar
            end)
        end
    end)
    return Citizen.Await(p)
end

function CoreNova.SavePlayer(src)
    local data = players[src]
    if not data then return end

    -- Exemplo: salvar job atual (expansível)
    local state = Player(src).state
    local job = state.playerData and state.playerData.job or "unemployed"

    MySQL.query('UPDATE players SET job = ? WHERE license = ?', {
        job,
        data.license
    })
end

function CoreNova.OnPlayerDropped(src)
    CoreNova.SavePlayer(src)
    players[src] = nil
end

-- Helper
function GetIdentifier(src, type)
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.find(v, type) then
            return v
        end
    end
    return nil
end
