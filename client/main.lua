local ESX = exports['es_extended']:getSharedObject()

local isOpen = false  -- 面板是否打开
local playerJob = nil -- 当前玩家职业名称

-- 调试日志, 仅在 Config.Debug 为 true 时输出
local function DebugLog(...)
    if Config.Debug then
        print('[dy_quickchat:client]', ...)
    end
end

--- 获取所有职业话术数据, 按 id 排序
---@return table[]
local function GetAllJobsData()
    local jobs = {}
    if JobQuotes then
        for _, jobData in pairs(JobQuotes) do
            table.insert(jobs, jobData)
        end
    end
    table.sort(jobs, function(a, b) return a.id < b.id end)
    return jobs
end

--- 获取当前玩家职业对应的话术数据
---@return table[] -- 只包含当前职业的数据数组
local function GetCurrentJobData()
    if not playerJob or not JobQuotes then
        return {}
    end
    local jobData = JobQuotes[playerJob]
    if jobData then
        return { jobData }
    end
    return {}
end

--- 根据配置获取话术数据
---@return table[]
local function GetJobsData()
    if Config.ShowCurrentJobOnly then
        return GetCurrentJobData()
    else
        return GetAllJobsData()
    end
end

--- 打开快捷语录面板, 发送职业数据到 NUI
local function OpenQuickChat()
    if isOpen then return end

    local jobs = GetJobsData()
    if #jobs == 0 then
        Config.Notify(nil, '没有可用的话术数据', 'error')
        DebugLog('没有可用的话术数据, 职业:', playerJob)
        return
    end

    isOpen = true
    SendNUIMessage({
        action = 'open',
        data = { jobs = jobs, activeJobId = playerJob or '' }
    })
    SetNuiFocus(true, true)
    DebugLog('UI 已打开, 当前职业:', playerJob)
end

--- 关闭面板并释放 NUI 焦点
local function CloseQuickChat()
    if not isOpen then return end

    isOpen = false
    SendNUIMessage({ action = 'close' })
    SetNuiFocus(false, false)
    DebugLog('UI 已关闭')
end

local function ToggleQuickChat()
    if isOpen then
        CloseQuickChat()
    else
        OpenQuickChat()
    end
end

---@param job table ESX job 对象
local function UpdatePlayerJob(job)
    if not job then return end
    playerJob = job.name
    DebugLog('职业更新:', playerJob)
end

--- NUI 回调: 将话术发送到服务端广播
RegisterNUICallback('sendMessage', function(data, cb)
    local message = data.message
    if not message or type(message) ~= 'string' or #message == 0 then
        cb({ success = false, error = '无效的消息' })
        return
    end

    TriggerServerEvent('dy_quickchat:sendMessage', message)
    DebugLog('发送消息:', message)
    cb({ success = true })
end)

--- NUI 回调: 关闭面板
RegisterNUICallback('close', function(_, cb)
    CloseQuickChat()
    cb({ success = true })
end)

--- 热键绑定, 玩家可在 FiveM 设置中自定义
RegisterKeyMapping('quickchat', Config.OpenKeyDescription, 'keyboard', Config.OpenKey)
RegisterCommand('quickchat', ToggleQuickChat, false)

--- 初始化线程: 等待玩家加载完成后获取职业
CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(250)
    end
    local xPlayer = ESX.GetPlayerData()
    UpdatePlayerJob(xPlayer.job)
    DebugLog('初始化完成, 玩家职业已加载')
end)

--- 玩家加载完成时获取初始职业
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    UpdatePlayerJob(xPlayer.job)
end)

--- 职业变更时更新本地状态, 若面板已打开则刷新显示
RegisterNetEvent('esx:setJob', function(job, lastJob)
    UpdatePlayerJob(job)
    if isOpen then
        local jobs = GetJobsData()
        if #jobs == 0 then
            -- 没有话术数据, 关闭面板
            CloseQuickChat()
            Config.Notify(nil, '没有可用的话术数据', 'info')
            DebugLog('职业变更后没有可用话术, 已关闭面板')
        else
            SendNUIMessage({
                action = 'open',
                data = { jobs = jobs, activeJobId = playerJob or '' }
            })
        end
    end
end)

--- 资源停止时确保关闭面板
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() and isOpen then
        CloseQuickChat()
    end
end)
