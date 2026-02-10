fx_version 'cerulean'
game 'gta5'

author 'qUizo'
description 'Clothing Store'
version '1.0.0'

client_scripts {
    'client.lua'
}

shared_script {
  "@vrp/lib/utils.lua"
}

server_scripts {
    'server_vrp.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/script.js',
    'nui/style.css',
    'nui/clothing.json',
    'nui/assets/*'
}