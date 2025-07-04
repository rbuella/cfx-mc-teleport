fx_version 'cerulean'
game 'gta5'

author 'Masterrr'
description 'ESX + ox_lib Teleport Menu'
version '1.0.0'

shared_script 'shared/*.lua'

client_scripts {
    '@ox_lib/init.lua',
    'client/*.lua'
}

server_script 'server/*.lua'

dependencies {
    'es_extended',
    'ox_lib'
}
