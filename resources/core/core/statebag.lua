RegisterNetEvent('coreNova:setState', function(key, value)
    local src = source
    local player = Player(src)
    player.state:set(key, value, true)
end)

function SetPlayerState(src, key, value)
    local player = Player(src)
    player.state:set(key, value, true)
end

exports('SetPlayerState', SetPlayerState)
