Config = {}

-- 热键
Config.OpenKey = 'F6'
Config.OpenKeyDescription = '打开快捷语录'

-- 界面
Config.DefaultTheme = 'dark'     -- 'dark' | 'light'
Config.ShowCurrentJobOnly = true -- true: 只显示当前职业话术, false: 显示所有职业话术

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

--- 通用通知函数 (双端可用)
---@param source any 玩家ID (服务端必填, 客户端传nil或不传)
---@param message string 通知内容
---@param notifyType? string 通知类型 'success'|'error'|'info' (默认 'info')
function Config.Notify(source, message, notifyType)
    notifyType = notifyType or 'info'
    if IsDuplicityVersion() then
        -- 服务端: 触发客户端通知
        TriggerClientEvent('dy_quickchat:notify', source, message, notifyType)
    else
        -- 客户端: 直接显示通知
        ESX.ShowNotification(message, notifyType)
    end
end

-- 客户端: 注册接收服务端通知的事件
if not IsDuplicityVersion() then
    RegisterNetEvent('dy_quickchat:notify', function(message, notifyType)
        ESX.ShowNotification(message, notifyType or 'info')
    end)
end
