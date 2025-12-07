# 更新日志

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/) 规范。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)。

---

## [未发布]

### 计划中
- Phase 2: 收藏夹功能
- Phase 2: 设置面板
- Phase 2: 配置热重载

---

## [0.2.0] - 2024-12-07

### 新增
- **Lua 后端核心 (Phase 1 完成)**
- `fxmanifest.lua` 资源清单
- `shared/config.lua` 全局配置系统
  - 热键设置
  - 安全配置 (频率限制、话术验证)
  - 消息模板配置
- `client/main.lua` 客户端核心
  - F6 热键打开/关闭面板
  - NUI 焦点管理
  - ESX 职业检测与变更监听
  - NUI 回调处理 (sendMessage, close)
- `server/main.lua` 服务端核心
  - 消息广播到所有玩家
  - 安全验证 (频率限制、话术来源验证、职业权限检查)
  - 可疑行为日志记录
- 职业话术数据
  - `jobs/police.lua` 警察话术 (6个分类, 30+条语录)
  - `jobs/ambulance.lua` 医生话术 (5个分类, 25+条语录)
  - `jobs/mechanic.lua` 机械师话术 (5个分类, 25+条语录)

---

## [0.1.0] - 2024-12-07

### 新增
- **NUI 前端初始版本**
- React 18 + TypeScript + Vite 技术栈
- 可折叠侧边栏导航
- 职业切换功能
- 分类手风琴展开/收起
- 语录列表展示
- 实时搜索过滤 (Ctrl+F)
- 深色/浅色主题切换
- GSAP 流畅动画效果
- ESC 键关闭支持
- NUI 通信工具封装 (`fetchNui`, `useNuiEvent`)
- shadcn/ui 组件库集成
- TailwindCSS 样式系统
- 自定义滚动条样式

### 技术细节
- 组件: `Sidebar`, `CategoryGroup`, `QuoteItem`, `SearchBar`, `JobIcon`
- Hooks: `useNuiEvent`
- 工具: `nui.ts`, `animations.ts`
- 类型: `Job`, `Category`, `Quote`, `Settings`

---

## 版本说明

- **主版本号**: 不兼容的 API 变更
- **次版本号**: 向后兼容的功能新增
- **修订号**: 向后兼容的问题修复

### 标记说明

- `新增` - 新功能
- `变更` - 现有功能的变更
- `弃用` - 即将移除的功能
- `移除` - 已移除的功能
- `修复` - Bug 修复
- `安全` - 安全相关修复
