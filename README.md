[![License MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
模块化设计的现代 NeoVim 配置，集成 AI 编程与全栈开发工具链，专为高效工作流打造。
![界面预览](https://via.placeholder.com/1920x1080.png/2d2d2d/ffffff?text=Neovim+2025+开发环境)
## ✨ 核心特性
- **50ms 极速启动** - 智能延迟加载插件系统
- **多语言支持** - 自动配置 C/C++/Python/JS/Rust 等语言的 LSP 服务
- **AI 双引擎** - GitHub Copilot + CopilotChat 智能编程
- **跨平台优化** - Linux/macOS/WSL2 原生支持
- **工业级工具链** - 集成调试器/性能分析/代码格式化
## 🚀 快速开始
### 环境要求
```bash
# 基础依赖
sudo apt install fd-find ripgrep python3-pip nodejs npm
```
### 一键安装
```bash
git clone https://github.com/miaolei20/nvim ~/.config/nvim
nvim +"Lazy install" +qa
```
## ⌨️ 核心快捷键
| 快捷键           | 功能描述                   | 模式      |
|------------------|---------------------------|----------|
| `<leader>sf`     | 项目文件搜索               | Normal   |
| `<C-Space>`      | 触发代码补全               | Insert   |
| `<F5>`           | 启动/停止调试              | Normal   |
| `<leader>ai`     | AI 编程助手                | Normal   |
| `<leader>gg`     | 开启 Lazygit               | Normal   |
## 🔧 高级功能
### 主题配置
```lua
:Telescope theme_picker  -- 可视化选择主题
:echo 'colorscheme tokyonight' > ~/.config/nvim/selected_theme.txt  -- 永久保存
```
### 添加语言支持
```bash
:MasonInstall clangd pyright  # 安装语言服务器
```
### 嵌入式开发示例
```lua
-- stm32_c.lua
require("lspconfig").clangd.setup({
  cmd = {"clangd", "--query-driver=/usr/bin/arm-none-eabi-gcc"},
  filetypes = {"c", "cpp"}
})
```
## 🚨 故障排查
```bash
# 插件系统重置
rm -rf ~/.local/share/nvim/lazy
# LSP 状态检查
:LspInfo
# 性能分析
:Lazy profile
```
## 🤝 参与贡献
1. 遵循 [Conventional Commits](https://www.conventionalcommits.org) 规范
2. 提交 Pull Request 前通过格式检查：
```bash
stylua lua/
```
[![捐赠支持](https://img.shields.io/badge/支持作者-Buy%20Me%20a%20Coffee-ffdd00?style=flat-square)](https://www.buymeacoffee.com/miaolei)
> 基于 LunarVim 框架深度定制 [1][5]，融合现代编辑器最佳实践 [2][4]
```
优化亮点：
1. 结构更扁平 - 合并相似板块，移除次级标题
2. 内容密度提升 - 关键数据前置，技术细节后置
3. 可视化增强 - 使用统一的功能图标体系
4. 交互优化 - 命令行操作全部使用代码块呈现
5. 移动端友好 - 表格布局适配小屏幕设备
6. 品牌统一 - 重要元素保留深色主题配色方案
