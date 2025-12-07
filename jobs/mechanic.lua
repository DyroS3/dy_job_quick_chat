--- 机械师职业话术
--- 数据结构说明见 jobs/police.lua

JobQuotes = JobQuotes or {}

JobQuotes['mechanic'] = {
    id = 'mechanic',
    name = '机械师',
    icon = 'mdi:wrench',
    description = '汽修人员常用语录',
    categories = {
        {
            id = 'service',
            name = '接待服务',
            expanded = true,
            quotes = {
                { id = 's001', text = '欢迎光临，请问需要什么服务？', favorite = false },
                { id = 's002', text = '请稍等，我来检查一下车辆', favorite = false },
                { id = 's003', text = '您的车辆需要维修', favorite = false },
                { id = 's004', text = '维修费用大约是...', favorite = false },
                { id = 's005', text = '请问您的车出了什么问题？', favorite = false },
                { id = 's006', text = '我们可以为您提供拖车服务', favorite = false },
            }
        },
        {
            id = 'repair',
            name = '维修过程',
            expanded = true,
            quotes = {
                { id = 'rp001', text = '车辆维修中，请稍候', favorite = false },
                { id = 'rp002', text = '维修完成，请验收', favorite = false },
                { id = 'rp003', text = '这个零件需要更换', favorite = false },
                { id = 'rp004', text = '发动机有问题，需要大修', favorite = false },
                { id = 'rp005', text = '轮胎需要更换', favorite = false },
                { id = 'rp006', text = '刹车系统需要检修', favorite = false },
            }
        },
        {
            id = 'advice',
            name = '建议提醒',
            expanded = true,
            quotes = {
                { id = 'a001', text = '建议您定期保养车辆', favorite = false },
                { id = 'a002', text = '这辆车的状况不太好，小心驾驶', favorite = false },
                { id = 'a003', text = '下次记得按时更换机油', favorite = false },
                { id = 'a004', text = '您的车辆保养得很好', favorite = false },
                { id = 'a005', text = '有问题随时联系我们', favorite = false },
            }
        },
        {
            id = 'towing',
            name = '拖车服务',
            expanded = true,
            quotes = {
                { id = 'tw001', text = '拖车服务，请问您在哪里？', favorite = false },
                { id = 'tw002', text = '我正在前往您的位置', favorite = false },
                { id = 'tw003', text = '请在安全的地方等待', favorite = false },
                { id = 'tw004', text = '车辆已经拖到修理厂了', favorite = false },
                { id = 'tw005', text = '拖车费用是...', favorite = false },
            }
        },
        {
            id = 'custom',
            name = '改装服务',
            expanded = true,
            quotes = {
                { id = 'c001', text = '您想对车辆进行什么改装？', favorite = false },
                { id = 'c002', text = '这个改装需要一些时间', favorite = false },
                { id = 'c003', text = '改装完成，看看效果如何？', favorite = false },
                { id = 'c004', text = '这个配件目前没有库存', favorite = false },
                { id = 'c005', text = '改装费用是...', favorite = false },
            }
        }
    }
}
