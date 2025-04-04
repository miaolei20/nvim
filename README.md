# Neovim Ultimate 2025 Configuration
](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-100%25-blueviolet.svg)](https://lua.org)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
## ✨ Features Highlight
- **Cross-platform Excellence**: Optimized for Linux/macOS/WSL2 with full clipboard integration[5]
- **AI-Driven Development**: GitHub Copilot + CopilotChat workflow enhancements
- **Modern Toolchain**: LSP support for 15+ languages with auto-configuration
- **Blazing Performance**: <50ms cold start with lazy loading plugins
```bash
git clone https://github.com/yourusername/nvim-config ~/.config/nvim
```
## 🛠️ Full Feature Breakdown
### 智能编程套件
| 组件 | 功能 | 配置文件 |
|------|------|----------|
| ![Copilot](https://via.placeholder.com/40.png/2d2d2d/ffffff?text=🤖) AI智能补全 | 实时代码建议和文档生成 | [copilot.lua](lua/plugins/copilot.lua) |
| ![LSP](https://via.placeholder.com/40.png/2d2d2d/ffffff?text=🚀) LSP 强化 | 自动安装语言服务器和诊断 | [lsp.lua](lua/config/lsp.lua) |
| ![Debug](https://via.placeholder.com/40.png/2d2d2d/ffffff?text=🐞) 调试工具 | 内建调试交互界面和性能分析 | [debug.lua](lua/plugins/debug.lua) |
### 可视化工作流
```lua
-- 主题配置示例 (onedark.lua)
require("onedarkpro").setup({
  diagnostics = {
    error = " ",
    warn = " ",
    info = " ",
    hint = "󰌶 ",
  },
  filetypes = {
    javascript = {
      keywords = "italic",
      functions = "bold"
    }
  }
})
```
## 🚀 快速安装指南
### 系统依赖
```bash
#Arch
sudo pacman -S make clang llvm python gcc ripgrep unzip fd curl python-pip nodejs npm curl cargo rust lazygit
# Ubuntu/Debian
sudo apt install python3-pip nodejs npm rustc fd-find ripgrep
# macOS (via Homebrew)
brew install python node rust fd ripgrep
```
### Neovim 配置
```bash
# 克隆配置仓库
git clone https://github.com/yourusername/nvim-config ~/.config/nvim
# 安装插件依赖
nvim +"Lazy install" +q
```
### WSL 特别优化
```powershell
# Windows 端安装 win32yank
curl.exe -LO https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
Expand-Archive win32yank-x64.zip -DestinationPath ~/win32yank
mv ~/win32yank/win32yank.exe /usr/local/bin/
```
## ⌨️ 核心快捷键映射
### 导航增强
| 按键 | 功能 | 说明 |
|------|------|------|
| `<C-b>` | 切换文件树 | NVimTree 可视化导航 |
| `<leader>ff` | 全局文件搜索 | Telescope 模糊查找 |
| `<leader>fg` | 实时内容检索 | 跨项目文本搜索 |
### 代码操作
| 组合键 | 功能 | 模式 |
|--------|------|------|
| `<C-space>` | 触发补全 | Insert |
| `gd` | 跳转定义 | Normal |
| `<leader>rn` | 变量重命名 | Visual |
## 🔧 高级自定义
### 主题个性化
```lua
-- 修改 statusline 样式 (lualine.lua)
require("lualine").setup({
  options = {
    theme = "onedark",
    section_separators = { left = "", right = "" }
  }
})
```
### 添加新语言支持
1. 安装 LSP 服务器
```bash
:MasonInstall typescript-language-server
```
2. 配置 LSP
```lua
-- lsp.lua
require("lspconfig").tsserver.setup({
  on_attach = custom_attach,
  capabilities = capabilities
})
```
## 🚨 故障排除
### 常见问题处理
```bash
# 性能问题检测
:checkhealth
# 插件更新
:Lazy update
# Copilot 授权
:Copilot auth
```
> **注意**：此配置已针对 Neovim v0.9+ 优化，建议配合最新版 Neovim 使用，获取完整功能体验。[查看更新日志](#) 
![Demo](https://via.placeholder.com/800x400.png/2d2d2d/ffffff?text=AI+代码补全演示)
