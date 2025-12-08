ESX = exports['es_extended']:getSharedObject()

local messageCooldowns = {} -- [source] = lastSendTime

local function DebugLog(...)
    if Config.Debug then
        print('[dy_quickchat:server]', ...)
    end
end

--- 记录可疑行为到控制台
local function SecurityLog(src, msg)
    if Config.Security.LogSuspicious then
        print(('[dy_quickchat] 安全警告 [玩家 %s]: %s'):format(src, msg))
    end
end

--- 将话术模板转换为 Lua 匹配模式
--- 占位符 {key} 转换为 (.+) 或 (.*)
---@param template string 话术模板
---@param placeholders table|nil 占位符定义列表
---@return string Lua 匹配模式
local function TemplateToPattern(template, placeholders)
    -- 转义 Lua 模式特殊字符
    local pattern = template:gsub('([%(%)%.%%%+%-%*%?%[%]%^%$])', '%%%1')

    -- 构建占位符 required 映射
    local requiredMap = {}
    if placeholders then
        for _, p in ipairs(placeholders) do
            requiredMap[p.key] = p.required
        end
    end

    -- 替换 {key} 为匹配模式
    pattern = pattern:gsub('%{([^}]+)%}', function(key)
        if requiredMap[key] then
            return '(.+)'  -- 必填：至少一个字符
        else
            return '(.*)'  -- 可选：零个或多个字符
        end
    end)

    return '^' .. pattern .. '$'
end

--- 验证话术是否存在于该职业的话术库中
--- 支持精确匹配和模板匹配（带占位符的话术）
---@param jobName string
---@param message string
---@return boolean
local function IsValidQuote(jobName, message)
    if not Config.Security.ValidateQuotes then return true end
    if not JobQuotes or not JobQuotes[jobName] then return false end

    for _, category in ipairs(JobQuotes[jobName].categories) do
        for _, quote in ipairs(category.quotes) do
            if quote.placeholders and #quote.placeholders > 0 then
                -- 带占位符的话术：使用模板匹配
                local pattern = TemplateToPattern(quote.text, quote.placeholders)
                if message:match(pattern) then
                    return true
                end
            else
                -- 普通话术：精确匹配
                if quote.text == message then
                    return true
                end
            end
        end
    end
    return false
end

--- 检查玩家消息冷却状态
---@param src number
---@return boolean
local function CheckCooldown(src)
    if not Config.Security.EnableCooldown then return true end

    local now = GetGameTimer()
    local last = messageCooldowns[src]

    if last and (now - last) < Config.Security.CooldownTime then
        return false
    end

    messageCooldowns[src] = now
    return true
end

--- 接收客户端话术，验证后广播到所有玩家聊天框
RegisterNetEvent('dy_quickchat:sendMessage', function(message)
    local src = source

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        SecurityLog(src, 'ESX 玩家对象不存在')
        return
    end

    if not CheckCooldown(src) then
        DebugLog('玩家', src, '消息发送过于频繁')
        return
    end

    if type(message) ~= 'string' or #message == 0 then
        SecurityLog(src, '消息格式无效')
        return
    end

    local playerJob = xPlayer.job.name
    if not IsValidQuote(playerJob, message) then
        SecurityLog(src, ('非法话术 [职业: %s]: %s'):format(playerJob, message))
        return
    end

    if GetResourceState('mChat') == 'started' then
        TriggerClientEvent('chat:addMessage', -1, {
            tags = { xPlayer.job.name },
            channel = { "ooc" },
            args = { xPlayer.getName(), message }
        })
    else
        TriggerClientEvent('chat:addMessage', -1, {
            template = Config.MessageTemplate,
            args = { xPlayer.getName(), message },
            color = Config.MessageColor
        })
    end


    DebugLog('玩家', src, '发送消息:', message)
end)

--- 玩家断开时清理冷却记录
AddEventHandler('playerDropped', function()
    messageCooldowns[source] = nil
end)
