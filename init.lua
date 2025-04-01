vim.g.python3_host_prog = '/usr/bin/python3'
-- 加载配置选项
require("config.options")
-- 加载键映射配置
require("config.keymaps")
-- 定义 lazy.nvim 插件的路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 如果路径不存在，则克隆 lazy.nvim 插件
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- 克隆最新的稳定版本
    lazypath,
  })
end

-- 将 lazy.nvim 插件路径添加到运行时路径中
vim.opt.rtp:prepend(lazypath)

-- 配置并加载 lazy.nvim 插件
require("lazy").setup({
  spec = {
    -- 基础与性能优化
    { import = "plugins.tools.impatient" }, -- 性能优化插件优先加载

    -- 主题与视觉基础
    { import = "plugins.UI.onedark" },   -- 主题必须最先加载

    -- 编辑增强
    { import = "plugins.editor.treesitter" },         -- 语法高亮基础
    { import = "plugins.editor.treesitter-context" },   -- 依赖 treesitter
    { import = "plugins.editor.autopairs" },            -- 自动括号
    { import = "plugins.editor.cmp" },                  -- 自动补全
    { import = "plugins.editor.comment" },              -- 注释
    { import = "plugins.editor.search" },               -- 搜索功能

    -- LSP 与代码工具
    { import = "plugins.lsp.mason" },    -- LSP 包管理
    { import = "plugins.lsp.lsp" },      -- LSP 核心
    { import = "plugins.AI.copilot" },   -- AI 代码补全

    -- 核心 UI 组件
    { import = "plugins.UI.alpha" },      -- 启动界面
    { import = "plugins.UI.lualine" },    -- 状态栏
    { import = "plugins.UI.bufferline" }, -- 标签栏
    { import = "plugins.UI.nvimtree" },   -- 文件树
    { import = "plugins.UI.rainbow" },    -- 彩虹括号
    { import = "plugins.UI.aerial" },   -- 代码大纲
    { import = "plugins.UI.notify"},    -- 通知
    { import = "plugins.UI.indent"},
    -- 导航与搜索
    { import = "plugins.tools.telescope" },    -- 模糊搜索

    -- 调试与工具
    { import = "plugins.tools.lazygit" }, -- 内置终端
    { import = "plugins.tools.leetcode" },   -- LeetCode 插件

    -- 辅助功能
    { import = "plugins.tools.which-key" },     -- 快捷键提示
    { import = "plugins.tools.lastplace" },       -- 恢复上次位置
    { import = "plugins.AI.llm"},
    { import = "plugins.tools.markdown"},
    { import = "plugins.AI.avante"},
  },
  performance = {  -- 此部分保持不变
    rtp = {
      disabled_plugins = {
        "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers"
      },
    },
  },
})
