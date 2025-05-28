# Neovim 现代开发环境配置

[![License MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

模块化、极速、AI 驱动的 NeoVim 配置，专为全栈开发与嵌入式工程师设计。  
集成主流 LSP、AI 编程助手、代码格式化、调试、文件管理等现代开发工具链。

---

## ✨ 特性亮点

- 🚀 **极速启动**：智能延迟加载，启动 <50ms
- 🧠 **AI 编程**：集成 GitHub Copilot、CopilotChat、Avante 等 AI 助手
- 🛠️ **多语言支持**：自动配置 C/C++/Python/JS/Rust 等主流 LSP
- 🎨 **主题切换**：一键可视化主题选择，持久保存
- 🗂️ **文件/项目管理**：Telescope、Neo-tree、Gitsigns、Lazygit
- 🧹 **格式化/诊断**：Conform、nvim-lint、Mason 自动安装工具
- 🖥️ **跨平台优化**：Linux/macOS/WSL2 原生支持
- 🔌 **插件生态**：基于 Lazy.nvim，插件管理高效灵活
- 🧩 **模块化结构**：配置分层，易于维护和扩展
- 🏗️ **嵌入式友好**：STM32/Cortex-M 工程开箱即用

---

## 📁 目录结构

```
nvim/
├── init.lua                # 启动入口，加载核心配置与插件
├── README.md               # 本说明文档
├── .gitignore
├── lazy-lock.json
├── selected_theme.txt      # 当前主题持久化
├── lua/
│   ├── theme_persist.lua   # 自动生成的主题配置
│   ├── config/             # 基础配置（options/keymaps/lsp）
│   │   ├── options.lua     # 全局选项与自动命令
│   │   ├── keymaps.lua     # 全局快捷键
│   │   └── lsp/            # LSP 相关配置
│   ├── plugins/            # 插件模块（按功能分组）
│   │   ├── UI/             # UI/美化相关插件
│   │   ├── editor/         # 编辑器增强插件
│   │   ├── lsp/            # LSP/语言服务插件
│   │   ├── tools/          # 工具类插件
│   │   └── __disabled/     # 暂未启用的插件
```

---

## 🚀 快速开始

### 1. 安装依赖

```bash
sudo apt install fd-find ripgrep python3-pip nodejs npm
```

### 2. 拉取配置

```bash
git clone https://github.com/miaolei20/nvim ~/.config/nvim
```

### 3. 首次启动自动安装插件

```bash
nvim +"Lazy install" +qa
```

---

## ⌨️ 常用快捷键

| 快捷键         | 功能描述           | 模式    |
| -------------- | ------------------ | ------- |
| `<leader>sf`   | 项目文件搜索       | Normal  |
| `<leader>sg`   | 全局内容搜索       | Normal  |
| `<leader>sd`   | 诊断信息           | Normal  |
| `<leader>sb`   | 文件浏览器         | Normal  |
| `<leader>su`   | 撤销历史           | Normal  |
| `<leader>so`   | 打开缓冲区         | Normal  |
| `<leader>st`   | 主题选择器         | Normal  |
| `<leader>gg`   | 打开 Lazygit       | Normal  |
| `<F5>`         | 编译/运行当前文件  | Normal  |
| `<C-Space>`    | 触发代码补全       | Insert  |
| `<leader>ff`   | 手动格式化         | Normal  |
| `<leader>ft`   | 开关保存时格式化   | Normal  |
| `<leader>ut`   | 切换代码上下文窗   | Normal  |
| `<leader>wv`   | 垂直分割窗口       | Normal  |
| `<leader>wm`   | 最大化/还原窗口    | Normal  |

---

## 🧠 AI 编程助手

- **Avante**：支持 DeepSeek、Ollama、OpenAI、Claude 等多家大模型，支持代码补全、对话、自动生成注释等。
- **Copilot**：GitHub 官方 AI 编程助手，自动补全代码片段。
- **CopilotChat**：AI 问答与代码解释。

---

## 🛠️ 主要插件与功能

- **[Telescope](lua/plugins/tools/telescope.lua)**：模糊查找、文件/内容/历史/诊断/主题等一站式搜索
- **[Neo-tree](lua/plugins/UI/neotree.lua)**：现代文件树，支持 Git 状态、缓冲区、分屏操作
- **[Gitsigns](lua/plugins/editor/gitsigns.lua)**：Git 行内变更、blame、跳转
- **[Conform.nvim](lua/plugins/tools/formatter.lua)**：自动格式化，支持多语言
- **[nvim-lint](lua/plugins/editor/lint.lua)**：保存时自动 Lint，支持 C/C++/Python
- **[Mason](lua/plugins/lsp/mason.lua)**：LSP/格式化/诊断工具自动安装与管理
- **[nvim-cmp](lua/plugins/editor/cmp.lua)**：智能补全，支持 LSP/Buffer/路径/命令行
- **[nvim-treesitter](lua/plugins/editor/treesitter.lua)**：语法高亮、结构感知、代码对象选择
- **[Heirline](lua/plugins/UI/heirline.lua)**：美观可定制状态栏/标签栏/WinBar
- **[Alpha](lua/plugins/UI/alpha.lua)**：启动仪表盘，常用操作一键直达
- **[rainbow-delimiters](lua/plugins/UI/rainbow.lua)**：括号/分隔符彩虹高亮
- **[indent-blankline](lua/plugins/UI/indent.lua)**：缩进线美化
- **[nvim-surround](lua/plugins/tools/surround.lua)**：快速添加/修改/删除包裹符号

---

## 🎨 主题切换与持久化

- 支持 OneDarkPro、Catppuccin、TokyoNight、Gruvbox、Rose-pine、Everforest 等主流主题
- 可视化选择主题并即时预览：

```vim
:Telescope theme_picker
```

- 持久保存主题：

```vim
:echo 'colorscheme tokyonight' > ~/.config/nvim/selected_theme.txt
```

---

## 🧩 LSP/格式化/诊断工具安装

- 自动安装推荐 LSP/格式化/诊断工具：

```vim
:MasonInstall clangd pyright lua_ls black clang-format stylua prettier
```

- 保存时自动格式化/诊断，支持手动开关

---

## 🏗️ 嵌入式开发（STM32 示例）

```lua
require("lspconfig").clangd.setup({
  cmd = {"clangd", "--query-driver=/usr/bin/arm-none-eabi-gcc"},
  filetypes = {"c", "cpp"}
})
```

---

## ⚡ 运行当前文件

- 按 `<F5>` 自动编译并弹窗运行（支持 C/C++/Python/Java/Go）
- 自动保存、自动切换到终端窗口

---

## 🌐 浏览器集成

- `:OpenURL <url>` 命令自动在系统默认浏览器打开链接
- WSL 下自动调用 Edge

---

## 🚨 故障排查

```bash
rm -rf ~/.local/share/nvim/lazy         # 重置插件系统
:LspInfo                               # 查看 LSP 状态
:Lazy profile                          # 性能分析
```

---

## 🤝 贡献指南

1. 遵循 [Conventional Commits](https://www.conventionalcommits.org) 规范
2. 提交前格式化代码：

   ```bash
   stylua lua/
   ```

3. 欢迎 PR、Issue 与建议！

[![Buy Me a Coffee](https://img.shields.io/badge/支持作者-Buy%20Me%20a%20Coffee-ffdd00?style=flat-square)](https://www.buymeacoffee.com/miaolei)

---

> 本配置基于 LunarVim 框架深度定制，融合现代编辑器最佳实践，适配多平台与多语言开发场景。
