fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Neenbyss Studio'
description 'Script to give cars to players'
version '1.2.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/main.lua'
}

client_scripts {
    'client/framework.lua',
    'client/main.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}
