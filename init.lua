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
    -- 基础功能与性能优化
    { import = "plugins/impatient" }, -- 性能优化插件优先加载

    -- 主题与视觉基础
    { import = "plugins/onedark" }, -- 主题必须最先加载
    { import = "plugins/icons" },   -- 图标紧随主题

    -- 核心UI组件
    { import = "plugins/lualine" },    -- 状态栏
    { import = "plugins/bufferline" }, -- 标签栏
    { import = "plugins/nvimtree" },   -- 文件树
    { import = "plugins/dashboard" },  -- 启动页
    { import = "plugins/scrollbar" },  -- 滚动条
    { import = "plugins/indent" },     -- 缩进线
    { import = "plugins/rainbow" },    -- 彩虹括号

    -- 导航与搜索
    { import = "plugins/navigation" },   -- 窗口导航
    { import = "plugins/telescope" },    -- 模糊搜索
    { import = "plugins/file-browser" }, -- 文件浏览

    -- 编辑增强
    { import = "plugins/treesitter" },         -- 语法高亮基础
    { import = "plugins/treesitter-context" }, -- 依赖treesitter
    { import = "plugins/autopairs" },          -- 自动括号
    { import = "plugins/cmp" },                -- 自动补全
    { import = "plugins/comment" },            -- 注释
    { import = "plugins/editor" },             -- 编辑器增强

    -- LSP与代码工具
    { import = "plugins/mason" },    -- LSP包管理
    { import = "plugins/lsp" },      -- LSP核心
    { import = "plugins/copilot" },  -- AI代码补全
    { import = "plugins/codesnap" }, -- 代码截图

    -- 版本控制
    { import = "plugins/gitsigns" }, -- Git状态显示
    { import = "plugins/fugitive" }, -- Git操作

    -- 调试与工具
    { import = "plugins/undotree" },   -- 撤销历史
    { import = "plugins/spectre" },    -- 搜索替换
    { import = "plugins/toggleterm" }, -- 内置终端
    { import = "plugins/avante" },     -- 未知插件（按原顺序保留）

    -- 辅助功能
    { import = "plugins/which-key" },     -- 快捷键提示
    { import = "plugins/persistence" },   -- 会话持久化
    { import = "plugins/lastplace" },     -- 恢复上次位置
    { import = "plugins/notify" },        -- 通知系统
    { import = "plugins/noice" },         -- 增强通知
    { import = "plugins/todo-comments" }, -- TODO高亮
    { import = "plugins/startime" },      -- 未知插件（按原顺序保留）
    { import = "plugins/cool" },          -- 未知插件（按原顺序保留）
    { import = "plugins/ufo" },           -- 折叠增强
  },
  performance = {                         -- 此部分保持不变
    rtp = {
      disabled_plugins = {
        "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers"
      },
    },
  },
})

