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
      local ok, onedark = pcall(require, "onedark")
      if not ok then
        vim.notify("OneDark 主题加载失败!", vim.log.levels.ERROR)
        return
      end

      -- 增强型颜色定义
      local colors = {
        base = {
          bg = "#282c34",
          fg = "#abb2bf",
          red = "#e06c75",
          green = "#98c379",
          yellow = "#e5c07b",
          blue = "#61afef",
          purple = "#c678dd",
          cyan = "#56b6c2",
          grey = "#5c6370",
        },
        extended = {
          bg2 = "#21252b",
          bg3 = "#181a1f",
          grey2 = "#7f848e",
        }
      }

      -- 现代化 Dashboard 高亮适配
      onedark.setup({
        style = "dark",
        diagnostics = {
          darker = true,
          undercurl = true,
        },
        highlights = {
          -- 基础语法高亮
          Comment = { fg = colors.base.grey, italic = true },
          Type = { fg = colors.base.yellow, bold = true },
          String = { fg = colors.base.green },
          Number = { fg = colors.base.purple },

          -- Dashboard 定制高亮
          DashboardHeader = { fg = colors.base.blue, bold = true },
          DashboardDesc = { fg = colors.base.green },
          DashboardKey = { fg = colors.base.yellow, bold = true },
          DashboardIcon = { fg = colors.base.purple },
          DashboardFooter = { fg = colors.base.grey, italic = true },

          -- 界面元素
          NormalFloat = { bg = colors.extended.bg2 },
          BufferLineBackground = { bg = colors.extended.bg2 },
          
          -- 其他保持原有配置
          ["@function.builtin"] = { fg = colors.base.cyan },
          MatchParen = { bg = colors.extended.bg2, underline = true },
        },
        code_style = {
          comments = "italic",
          keywords = "bold",
          functions = "bold,italic"
        }
      })

      -- 加载主题后配置 Dashboard
      onedark.load()
      
      -- Dashboard 核心配置
      require("dashboard").setup({
        theme = 'hyper',
        config = {
          week_header = { enable = false },
          shortcut = {
            { desc = '󰈞  Find File',   group = 'DashboardDesc', action = 'Telescope find_files', key = ' ' },
            { desc = '󰈬  Find Word',   group = 'DashboardDesc', action = 'Telescope live_grep', key = ' ' },
            { desc = '󰃢  New File',    group = 'DashboardDesc', action = 'ene | startinsert',   key = ' ' },
            { desc = '󰒓  Config',      group = 'DashboardIcon', action = 'edit $MYVIMRC',      key = ' ' },
            { desc = '󰗼  Quit',        group = 'DashboardFooter', action = function() vim.cmd("qa") end, key = ' ' },
          },
          project = {
            enable = true,
            limit = 5,
            icon = ' ',
            label = ' Recent Projects:',
            action = 'Telescope find_files cwd='
          },
          mru = { 
            limit = 5, 
            icon = ' ',
            label = ' Recent Files:',
          },
          header = vim.split([[
            ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
            ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
            ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
            ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
            ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]], '\n'),
          footer = { " Neovim "..vim.version().major.."."..vim.version().minor.." - 主题：OneDark Pro" }
        }
      })

      -- 智能标签栏控制
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dashboard",
        callback = function()
          vim.opt_local.showtabline = 0
          vim.keymap.set('n', 'q', '<cmd>qa<CR>', { buffer = true, silent = true })
        end
      })

      -- 浮动窗口背景修正
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.base.blue, bg = colors.extended.bg2 })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.extended.bg2 })
    end
  },
  -- Dashboard 插件声明
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  }
}