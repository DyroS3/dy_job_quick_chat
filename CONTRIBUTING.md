# 贡献指南

感谢你对 dy_job_quick_chat 的关注！欢迎提交 Issue 和 Pull Request。

## 如何贡献

### 报告 Bug

1. 搜索 [Issues](../../issues) 确认问题未被报告
2. 使用 Bug Report 模板创建新 Issue
3. 提供详细的复现步骤和环境信息

### 功能建议

1. 搜索 [Issues](../../issues) 确认建议未被提出
2. 使用 Feature Request 模板创建新 Issue
3. 描述功能的使用场景和预期效果

### 提交代码

1. Fork 本仓库
2. 创建功能分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 创建 Pull Request

## 开发环境

### 前置要求

- Node.js 18+
- FiveM 服务器（测试用）
- ESX Legacy v1.9.0+

### 本地开发

```bash
# 克隆仓库
git clone https://github.com/DyroS3/dy_job_quick_chat.git

# 进入前端目录
cd dy_job_quick_chat/web

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 构建

```bash
npm run build
```

构建产物位于 `web/dist/` 目录。

## 代码规范

- **Lua**: 4 空格缩进
- **Vue/TypeScript**: 2 空格缩进
- 提交信息使用中文或英文均可
- 遵循现有代码风格

## 添加新职业话术

1. 在 `jobs/` 目录创建新文件，如 `jobs/taxi.lua`
2. 参考现有文件结构定义话术数据
3. 确保 `id` 与 ESX 职业名一致

```lua
return {
    id = 'taxi',
    name = '出租车司机',
    icon = 'mdi:taxi',
    description = '出租车司机常用语录',
    categories = {
        {
            id = 'greeting',
            name = '接客问候',
            expanded = true,
            quotes = {
                { id = 't001', text = '您好，请问去哪里？', favorite = false },
            }
        }
    }
}
```

## 许可证

提交代码即表示你同意将代码以 [MIT 许可证](./LICENSE) 开源。
