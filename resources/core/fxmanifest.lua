fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SR VINIX'
description 'CoreNova - Framework Base'

shared_script '@ox_lib/init.lua'

server_scripts {
    'lib/MySQL.lua',
    'core/init.lua',
    'core/database.lua',
    'core/tunnel.lua',
    'core/statebag.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua'
}
