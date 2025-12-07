# 更新日志

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/) 规范。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)。

---

## [0.3.0] - 2025-12-07

### 新增
- `Config.ShowCurrentJobOnly` - 控制只显示当前职业话术或全部职业
- `Config.Notify()` - 双端通用通知函数
- 玩家加载初始化线程，确保职业数据正确获取

### 优化
- 单职业模式下自动隐藏侧边栏
- 职业变更时自动刷新或关闭面板

### 修复
- 发布包 `web/dist` 目录结构
- ESX 改为全局变量，修复 `Config.Notify` 调用时的 nil 错误

---

## [0.2.0] - 2025-12-07

### 新增
- **完整的 FiveM 资源系统**
- `fxmanifest.lua` 资源清单
- `shared/config.lua` 全局配置
- `client/main.lua` 客户端核心
  - F6 热键打开/关闭面板
  - NUI 焦点管理
  - ESX 职业检测
- `server/main.lua` 服务端核心
  - 消息广播
  - 安全验证
- 职业话术数据
  - `jobs/police.lua` 警察话术
  - `jobs/ambulance.lua` 医生话术
  - `jobs/mechanic.lua` 机械师话术
- **NUI 前端 (Vue 3)**
- Vue 3 + TypeScript + Vite 技术栈
- 可折叠侧边栏导航
- 职业切换与分类展开
- 实时搜索过滤
- 深色/浅色主题切换
- Iconify 图标库
- **开源标准化**
- GitHub Actions CI/CD 自动构建发布
- Issue Forms 模板
- PR 模板
- 贡献指南

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
