--- 医生职业话术
--- 数据结构说明见 jobs/police.lua

JobQuotes = JobQuotes or {}

JobQuotes['ambulance'] = {
    id = 'ambulance',
    name = '医生',
    icon = 'mdi:hospital-box',
    description = '医疗人员常用语录',
    categories = {
        {
            id = 'rescue',
            name = '急救响应',
            expanded = true,
            quotes = {
                { id = 'r001', text = '我是急救人员，请让开通道', favorite = false },
                { id = 'r002', text = '伤者情况如何？能听到我说话吗？', favorite = false },
                { id = 'r003', text = '请保持冷静，救援马上到达', favorite = false },
                { id = 'r004', text = '请不要移动伤者', favorite = false },
                { id = 'r005', text = '我需要了解发生了什么', favorite = false },
                { id = 'r006', text = '请给伤者一些空间', favorite = false },
            }
        },
        {
            id = 'treatment',
            name = '治疗过程',
            expanded = true,
            quotes = {
                { id = 't001', text = '请告诉我哪里不舒服', favorite = false },
                { id = 't002', text = '我需要为你进行检查', favorite = false },
                { id = 't003', text = '请放松，这可能会有点疼', favorite = false },
                { id = 't004', text = '治疗完成，请注意休息', favorite = false },
                { id = 't005', text = '你需要去医院做进一步检查', favorite = false },
                { id = 't006', text = '我给你开一些药，请按时服用', favorite = false },
            }
        },
        {
            id = 'hospital',
            name = '医院服务',
            expanded = true,
            quotes = {
                { id = 'h001', text = '欢迎来到医院，请问需要什么帮助？', favorite = false },
                { id = 'h002', text = '请在这里等候，马上为您诊治', favorite = false },
                { id = 'h003', text = '您的伤势已经处理好了', favorite = false },
                { id = 'h004', text = '费用是...', favorite = false },
                { id = 'h005', text = '祝您早日康复', favorite = false },
            }
        },
        {
            id = 'emergency',
            name = '紧急情况',
            expanded = true,
            quotes = {
                { id = 'e001', text = '情况紧急，需要立即手术', favorite = false },
                { id = 'e002', text = '准备除颤器！', favorite = false },
                { id = 'e003', text = '开始心肺复苏', favorite = false },
                { id = 'e004', text = '患者失去意识', favorite = false },
                { id = 'e005', text = '需要输血', favorite = false },
            }
        },
        {
            id = 'radio',
            name = '无线电通讯',
            expanded = true,
            quotes = {
                { id = 'rd001', text = '收到呼叫，正在前往', favorite = false },
                { id = 'rd002', text = '已到达现场，正在评估情况', favorite = false },
                { id = 'rd003', text = '需要额外的医疗支援', favorite = false },
                { id = 'rd004', text = '患者情况稳定，正在转运', favorite = false },
                { id = 'rd005', text = '返回医院途中', favorite = false },
            }
        }
    }
}
