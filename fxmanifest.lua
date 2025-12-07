fx_version 'cerulean'
game 'gta5'

name 'dy_job_quick_chat'
description '职业快捷语录系统 - 根据玩家职业提供预设话术模板'
author 'DY'
version '0.1.0'

-- 共享脚本 (客户端和服务端都会加载)
shared_scripts {
    'shared/config.lua',
    'jobs/*.lua'
}

-- 客户端脚本
client_scripts {
    'client/main.lua'
}

-- 服务端脚本
server_scripts {
    'server/main.lua'
}

-- NUI 页面
ui_page 'web/dist/index.html'

-- NUI 文件
files {
    'web/dist/index.html',
    'web/dist/*.js',
    'web/dist/*.css',
    'web/dist/*.svg',
    'web/dist/*.png'
}

-- 依赖资源
dependencies {
    'es_extended'
}

-- Lua 运行时
lua54 'yes'
