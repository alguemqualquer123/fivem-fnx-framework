fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SR VINIX'
description 'CoreNova - Framework Base'

loadscreen_manual_shutdown "yes"
ui_page_preload 'yes'


shared_script '@ox_lib/init.lua'

server_scripts {
    'lib/MySQL.lua',
    'core/callbacks.lua',
    'core/init.lua',
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
    'client/callbacks.lua',
    'client/spawn.lua',
    'client/main.lua',
}
