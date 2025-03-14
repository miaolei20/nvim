-- lspsaga.lua 颜色优化版
local lspsaga = require("lspsaga")
local keys = require("config.lsp.keymaps")

lspsaga.setup({
  symbol_in_winbar = {
    enable = true,
    show_file = true,
    separator = keys.icons.symbols.Separator,
    color_mode = true, -- 必须开启颜色模式
    highlight_group = {
      icon = "LspSagaWinbarSep", -- 自定义高亮组
      name = "LspSagaWinbarFile"
    }
  },
  -- 新增禁用灯泡配置
  lightbulb = {
    enable = false,
    sign = keys.icons.actions.code,
    virtual_text = false,
    sign_priority = 20
  },
  ui = {
    border = "single", -- 统一边框样式
    devicon = true,
    title = true,
    expand = "",
    collapse = "",
    actionfix = "",
    lines = { "┗", "┣", "┃", "━", "┏" },
    kind = {},
    button = { "│", "│" }, -- 优化按钮样式
    imp_sign = "󰳛 "
  },
  finder = {
    layout = "float",
    filter = { prefix = false }, -- 移除过滤前缀
    default = "def+ref",
    keys = { toggle_or_open = "<CR>" }
  },
  hover = { open_link = "gl" } -- 维持现有配置
})

-- 重要！必须设置的衍生高亮组
vim.api.nvim_set_hl(0, "LspSagaWinbarSep",  { link = "Comment" })
vim.api.nvim_set_hl(0, "LspSagaWinbarFile", { link = "Directory" })
vim.api.nvim_set_hl(0, "SagaBorder",        { fg = "#569CD6", bg = "NONE" })
vim.api.nvim_set_hl(0, "SagaNormal",        { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TitleString",       { fg = "#DCDCAA", bold = true })

