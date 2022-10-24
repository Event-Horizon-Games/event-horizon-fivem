fx_version 'cerulean'
game 'gta5'

-- Credit to https://github.com/aymannajim/an_progBar
author "Gravity"
description "Creates an on screen progress bar for the player."
version "1.0.0"

ui_page 'html/index.html'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}
