return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,
    init = function()
      vim.g.onedark_terminal_italics = 1
      vim.g.onedark_termcolors = 256
    end,
    config = function()
      -- 安全加载 onedark 模块
      local ok, onedark = pcall(require, "onedark")
      if not ok then
        vim.notify("OneDark 主题加载失败!", vim.log.levels.ERROR)
        return
      end

      -- 定义基础和扩展配色（可根据需要调整）
      local colors = {
        base = {
          bg     = "#282c34",
          fg     = "#abb2bf",
          red    = "#e06c75",
          green  = "#98c379",
          yellow = "#e5c07b",
          blue   = "#61afef",
          purple = "#c678dd",
          cyan   = "#56b6c2",
          grey   = "#5c6370",
        },
        extended = {
          bg2   = "#21252b",
          bg3   = "#181a1f",
          grey2 = "#7f848e",
        },
      }

      -- 设置 OneDark 主题，附带定制高亮（Dashboard 与界面元素适配）
      onedark.setup({
        style = "dark",
        diagnostics = {
          darker   = true,
          undercurl = true,
        },
        highlights = {
          -- 基础语法
          Comment = { fg = colors.base.grey, italic = true },
          Type = { fg = colors.base.yellow, bold = true },
          String = { fg = colors.base.green },
          Number = { fg = colors.base.purple },

          -- Dashboard 高亮定制
          DashboardHeader = { fg = colors.base.blue, bold = true },
          DashboardDesc   = { fg = colors.base.green },
          DashboardKey    = { fg = colors.base.yellow, bold = true },
          DashboardIcon   = { fg = colors.base.purple },
          DashboardFooter = { fg = colors.base.grey, italic = true },

          -- 界面元素
          NormalFloat = { bg = colors.extended.bg2 },
          BufferLineBackground = { bg = colors.extended.bg2 },
          ["@function.builtin"] = { fg = colors.base.cyan },
          MatchParen = { bg = colors.extended.bg2, underline = true },
        },
        code_style = {
          comments  = "italic",
          keywords  = "bold",
          functions = "bold,italic",
        },
      })

      -- 应用主题配置
      onedark.load()

      -- Dashboard 配置（使用 glepnir/dashboard-nvim 插件）
      local dashboard = require("dashboard")
      dashboard.setup({
        theme = "hyper",
        config = {
          week_header = { enable = false },
          shortcut = {
            { desc = "󰈞  Find File", group = "DashboardDesc", action = "Telescope find_files", key = " " },
            { desc = "󰈬  Find Word", group = "DashboardDesc", action = "Telescope live_grep", key = " " },
            { desc = "󰃢  New File", group = "DashboardDesc", action = "ene | startinsert", key = " " },
            { desc = "󰒓  Config", group = "DashboardIcon", action = "edit $MYVIMRC", key = " " },
            { desc = "󰗼  Quit", group = "DashboardFooter", action = function() vim.cmd("qa") end, key = " " },
          },
          project = {
            enable = true,
            limit  = 5,
            icon   = " ",
            label  = " Recent Projects:",
            action = "Telescope find_files cwd=",
          },
          mru = {
            limit = 5,
            icon  = " ",
            label = " Recent Files:",
          },
          header = vim.split([[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]], "\n"),
          footer = { " Neovim " .. vim.version().major .. "." .. vim.version().minor .. " - OneDark Pro" },
        },
      })

      -- 针对 Dashboard 文件类型，隐藏标签栏并映射退出快捷键
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dashboard",
        callback = function()
          vim.opt_local.showtabline = 0
          vim.keymap.set("n", "q", "<cmd>qa<CR>", { buffer = true, silent = true })
        end,
      })

      -- 修正浮动窗口背景样式
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.base.blue, bg = colors.extended.bg2 })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.extended.bg2 })
    end,
  },
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
