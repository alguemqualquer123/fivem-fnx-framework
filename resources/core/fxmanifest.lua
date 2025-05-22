fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SR VINIX'
description 'CoreNova - Framework Base'
version '1.0.0'

loadscreen_manual_shutdown 'yes'

shared_scripts {
    -- '@ox_lib/init.lua',
    'lib/MySQL.lua',
    'global/**/*',
    "lib/IdManager.lua",
   "lib/loader.lua",
    "lib/class.lua",
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "lib/Utils.lua",
}

server_scripts {
    'core/init.lua',
    'core/callbacks.lua',
    'core/database.lua',
    'core/prepares.lua',
    'core/cards.lua',
    'core/access.lua',
    'core/tunnel.lua',
    'core/statebag.lua',
    'server/main.lua',
    'server/commands.lua',
}

client_scripts {
    'client/init.lua',
    'client/callbacks.lua',
    'client/spawn.lua',
    'client/main.lua',
}

files {
    "lib/loader.lua",
    "lib/class.lua",
    "lib/IdManager.lua",
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "lib/Utils.lua",
    -- Inclua arquivos estáticos se usar UI ou outros
    -- 'ui/index.html',
    -- 'ui/*.*',
}
