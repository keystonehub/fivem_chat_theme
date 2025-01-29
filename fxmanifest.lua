--[[
----------------------------------------------
 _  _________   ______ _____ ___  _   _ _____ 
| |/ / ____\ \ / / ___|_   _/ _ \| \ | | ____|
| ' /|  _|  \ V /\___ \ | || | | |  \| |  _|  
| . \| |___  | |  ___) || || |_| | |\  | |___ 
|_|\_\_____| |_| |____/ |_| \___/|_| \_|_____|
----------------------------------------------                                               
       FIVEM CHAT THEME AND RP COMMANDS
                   V1.0.0              
----------------------------------------------
]]

fx_version 'cerulean'
games { 'gta5', 'rdr3' }

name 'fivem_chat_theme'
version '1.0.0'
description 'Keystone - FiveM Chat Theme'
author 'keystonehub'
repository 'https://github.com/keystonehub/fivem_chat_theme'
lua54 'yes'

file 'html/css/styles.css'

server_scripts {
    'server/config.lua',
    'server/log.lua',
    'server/main.lua'
}

chat_theme 'fivem_chat_theme' {
    styleSheet = 'html/css/styles.css'
}

escrow_ignore {
    'server/*'
}

dependancies {
	'chat',
    'fivem_utils'
}