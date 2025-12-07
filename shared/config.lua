Config = {}

-- 热键
Config.OpenKey = 'F6'
Config.OpenKeyDescription = '打开快捷语录'

-- 界面
Config.DefaultTheme = 'dark' -- 'dark' | 'light'

-- 安全
Config.Security = {
    EnableCooldown = true, -- 消息冷却
    CooldownTime = 1000,   -- 冷却时间 (ms)
    ValidateQuotes = true, -- 验证话术来源
    LogSuspicious = true,  -- 记录可疑行为
}

-- 消息格式: {0}=玩家名, {1}=消息内容
Config.MessageTemplate = '<b>{0}</b>: {1}'
Config.MessageColor = { 255, 255, 255 }

-- 调试
Config.Debug = false
