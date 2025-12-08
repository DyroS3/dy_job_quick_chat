--[[
    警察职业话术

    JobQuotes 数据结构:
    - id: string          职业唯一标识, 需与 ESX 职业名一致
    - name: string        职业显示名称
    - icon: string        Iconify 图标名称, 浏览: https://icon-sets.iconify.design
    - description: string 职业描述, 显示在标题下方
    - categories: table   话术分类列表

    Category 分类结构:
    - id: string          分类唯一标识
    - name: string        分类显示名称
    - expanded: boolean   是否默认展开
    - quotes: table       话术列表

    Quote 话术结构:
    - id: string          话术唯一标识
    - text: string        话术内容, 点击后发送到聊天, 支持 {key} 占位符
    - favorite: boolean   是否收藏 (预留功能)
    - placeholders: table (可选) 占位符定义列表

    Placeholder 占位符结构:
    - key: string         占位符标识, 对应 text 中的 {key}
    - label: string       表单显示的中文标签
    - default: string     (可选) 默认值
    - required: boolean   (可选) 是否必填, 默认 false
    - maxLength: number   (可选) 最大长度, 默认 100
]]

JobQuotes = JobQuotes or {}

JobQuotes['police'] = {
    id = 'police',
    name = '警察',
    icon = 'mdi:police-badge',
    description = '执法人员常用语录',
    categories = {
        {
            id = 'patrol',
            name = '日常巡逻',
            expanded = true,
            quotes = {
                { id = 'p001', text = '^2请靠边^3停车, ^8接受检查', favorite = false },
                { id = 'p002', text = '请出示您的驾照和行驶证', favorite = false },
                { id = 'p003', text = '这是例行检查, 请配合', favorite = false },
                { id = 'p004', text = '请熄火并将双手放在方向盘上', favorite = false },
                { id = 'p005', text = '请问您知道为什么被拦下吗？', favorite = false },
                { id = 'p006', text = '您的车辆登记信息有问题', favorite = false },
            }
        },
        {
            id = 'chase',
            name = '追捕嫌疑人',
            expanded = true,
            quotes = {
                { id = 'c001', text = '停下！这是警察！', favorite = false },
                { id = 'c002', text = '放下武器, 双手抱头！', favorite = false },
                { id = 'c003', text = '你已被包围, 放弃抵抗！', favorite = false },
                { id = 'c004', text = '这是最后警告！', favorite = false },
                { id = 'c005', text = '不要试图逃跑！', favorite = false },
                { id = 'c006', text = '趴在地上, 双手放在头后！', favorite = false },
            }
        },
        {
            id = 'arrest',
            name = '逮捕程序',
            expanded = true,
            quotes = {
                { id = 'a001', text = '你因涉嫌违法被逮捕', favorite = false },
                { id = 'a002', text = '你有权保持沉默', favorite = false },
                { id = 'a003', text = '你所说的一切都可能作为呈堂证供', favorite = false },
                { id = 'a004', text = '你有权请律师', favorite = false },
                { id = 'a005', text = '请配合调查', favorite = false },
                { id = 'a006', text = '现在将你带回警局进行询问', favorite = false },
            }
        },
        {
            id = 'traffic',
            name = '交通执法',
            expanded = true,
            quotes = {
                { id = 't001', text = '您超速了, 请注意安全驾驶', favorite = false },
                { id = 't002', text = '您闯红灯了, 这是违法行为', favorite = false },
                { id = 't003', text = '请不要在此处停车', favorite = false },
                { id = 't004', text = '您的车辆需要进行检测', favorite = false },
                { id = 't005', text = '这是您的罚单, 请按时缴纳', favorite = false },
            }
        },
        {
            id = 'radio',
            name = '无线电通讯',
            expanded = true,
            quotes = {
                { id = 'r001', text = '收到, 正在前往现场', favorite = false },
                { id = 'r002', text = '请求支援, 我的位置是...', favorite = false },
                { id = 'r003', text = '嫌疑人正在逃跑, 方向是...', favorite = false },
                { id = 'r004', text = '现场已控制, 情况稳定', favorite = false },
                { id = 'r005', text = '需要医疗支援', favorite = false },
            }
        },
        {
            id = 'judgment',
            name = '判罚公告',
            expanded = true,
            quotes = {
                {
                    id = 'j001',
                    text = '^3嫌疑人{name}因^8{crime}^3. 警方判罚: 罚款{fine}, 监狱{time}.望各位市民遵纪守法, 快乐游戏.',
                    favorite = false,
                    placeholders = {
                        { key = 'name', label = '嫌疑人名称', required = true, maxLength = 20 },
                        { key = 'crime', label = '罪名', default = '违法行为', required = true, maxLength = 30 },
                        { key = 'fine', label = '罚款金额', default = '10W', maxLength = 10 },
                        { key = 'time', label = '监狱时间', default = '10分钟', maxLength = 10 }
                    }
                },
                {
                    id = 'j002',
                    text = '^1[警方通报]^0 {name}因{crime}被依法处理, 罚款{fine}.',
                    favorite = false,
                    placeholders = {
                        { key = 'name', label = '当事人', required = true, maxLength = 20 },
                        { key = 'crime', label = '违法行为', required = true, maxLength = 50 },
                        { key = 'fine', label = '罚款金额', default = '5W', maxLength = 10 }
                    }
                }
            }
        }
    }
}
