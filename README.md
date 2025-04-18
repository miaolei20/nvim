# Neovim Ultimate 2025 Configuration
[![Lua](https://img.shields.io/badge/Lua-100%25-blueviolet?logo=lua)](https://www.lua.org)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/miaolei20/nvim?style=social)](https://github.com/miaolei20/nvim)
专业级Neovim配置，专为现代软件开发设计，集成AI编程辅助与高效工作流优化。基于Lua实现模块化架构，支持跨平台开发环境。[1]
## ✨ 核心特性
- **极速启动**：基于`lazy.nvim`的智能延迟加载，冷启动时间<50ms，插件按需加载[1]
- **全栈开发支持**：内置15+语言LSP自动配置（C/C++/Python/JS/Rust等），通过`mason.nvim`管理语言服务器[3]
- **AI智能编程**：GitHub Copilot + CopilotChat双引擎协作，支持代码建议/文档生成/对话式编程[2][4]
- **跨平台优化**：完美支持Linux/macOS/WSL2，自带剪贴板集成与终端兼容层
- **现代UI体验**：Onedark Pro主题 + 动态状态栏 + 可视化文件树，支持夜间模式自动切换
- **工程级工具链**：集成调试器、性能分析、LeetCode刷题环境，内置STM32开发工作流
![界面预览](https://via.placeholder.com/1920x1080.png/2d2d2d/ffffff?text=Neovim+2025+界面预览+%0A%F0%9F%94%A5+AI%E6%99%BA%E8%83%BD%E5%BC%80%E5%8F%91%0A%F0%9F%9B%A0+%E5%A4%9A%E7%AA%97%E5%8F%A3%E7%AE%A1%E7%90%86%0A%F0%9F%93%88+%E5%8A%A8%E6%80%81%E7%8A%B6%E6%80%81%E6%A0%8F)
## 🚀 安装指南
### 系统依赖
```bash
# Arch Linux/Manjaro
sudo pacman -S python nodejs npm rust fd ripgrep unzip lazygit clang
# Ubuntu/Debian
sudo apt install python3-pip nodejs npm rustc fd-find ripgrep build-essential
# macOS (Homebrew)
brew install python node rust fd ripgrep lazygit gcc
```
### 配置部署
```bash
# 克隆仓库到配置目录
git clone https://github.com/miaolei20/nvim ~/.config/nvim
# 安装核心依赖
pip3 install pynvim && npm install -g neovim
# 初始化插件系统
nvim +"Lazy install" +q
```
### WSL特别优化
```powershell
# 安装Windows端剪贴板支持
curl.exe -LO https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
Expand-Archive win32yank-x64.zip -DestinationPath ~/win32yank
mv ~/win32yank/win32yank.exe /usr/local/bin/
# 配置WSL2 GUI支持
echo "export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0" >> ~/.bashrc
```
## 🛠️ 核心功能详解
### 智能编程套件
| 组件 | 功能 | 配置文件 | 快捷键 |
|------|------|----------|--------|
| ![Copilot](https://via.placeholder.com/40.png/2d2d2d/ffffff?text=🤖) AI补全 | 实时代码建议与文档生成 | [copilot.lua](lua/plugins/copilot.lua) | `<M-[>`/`<M-]>` 切换建议[4] |
| ![LSP](https://via.placeholder.com/40.png/2d2d2d/ffffff?text=🚀) 语言服务器 | 自动安装与配置语言服务器 | [lsp.lua](lua/config/lsp.lua) | `gd`跳转定义 |
| ![Debug](https://via.placeholder.com/40.png/2d2d2d/ffffff?text=🐞) 调试工具 | 集成DAP与性能分析 | [dap.lua](lua/plugins/dap.lua) | `<F5>`启动调试 |
### 可视化工作流
```lua
-- 主题配置示例 (lua/config/onedark.lua)
require("onedarkpro").setup({
  diagnostics = {
    error = " ",
    warn = " ",
    info = " ",
    hint = "󰌶 ",
  },
  filetypes = {
    cpp = {
      keywords = "italic",
      functions = "bold"
    }
  },
  options = {
    terminal_colors = true,
    cursorline = true
  }
})
```
## ⌨️ 核心快捷键
### 导航增强
| 按键 | 功能 | 模式 | 插件依赖 |
|------|------|------|----------|
| `<C-b>` | 切换文件树 | Normal | neo-tree |
| `<leader>ff` | 全局文件搜索 | Normal | telescope.nvim[5] |
| `<leader>fg` | 实时内容检索 | Normal | telescope+lsp |
### 代码操作
| 组合键 | 功能 | 模式 | 实现原理 |
|--------|------|------|----------|
| `<C-space>` | 触发补全 | Insert | nvim-cmp |
| `<leader>rn` | 变量重命名 | Normal | LSP rename |
| `]d`/`[d` | 诊断跳转 | Normal | LSP diagnostic |
## 📦 插件生态
### 核心组件
| 类别 | 插件 | 版本 | 功能 |
|------|------|------|------|
| **UI框架** | heirline.nvim | 2023.12 | 动态状态栏系统 |
| **文件管理** | neo-tree.nvim | v3.x | 可视化文件树 |
| **模糊搜索** | telescope.nvim | 0.1.5 | 高性能搜索框架[5] |
| **LSP管理** | mason.nvim | 1.8.0 | 语言服务器管理器 |
完整插件清单见 [lazy-lock.json](lazy-lock.json)
## 🔧 高级配置
### Copilot优化设置
```lua
-- 配置macOS/Linux快捷键映射
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<M-]>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-[>", "<Plug>(copilot-previous)", { noremap = false })
```
### 添加新语言支持
1. 通过Mason安装语言服务器：
```bash
:MasonInstall typescript-language-server
```
2. 配置LSP客户端：
```lua
-- lua/config/lsp.lua
require("lspconfig").tsserver.setup({
  on_attach = custom_attach,
  capabilities = require("blink.cmp").get_lsp_capabilities()
})
```
## 🚨 故障排除
### 常见问题
```bash
# 插件安装失败
rm -rf ~/.local/share/nvim/lazy
# Copilot授权问题
:Copilot auth
# LSP启动失败
:LspInfo
:MasonUpdate
```
### 诊断工具
```bash
# 检查健康状态
:checkhealth
# 性能分析
:Lazy profile
```
## 🤝 参与贡献
1. Fork本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交修改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 提交Pull Request
## 📜 许可证
本项目采用 MIT 许可证 - 详情请见 [LICENSE](LICENSE) 文件
