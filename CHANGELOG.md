# 更新日志

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/) 规范。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)。

---

## [未发布]

### 计划中
- 收藏夹功能
- 设置面板
- 配置热重载

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
