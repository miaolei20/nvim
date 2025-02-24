-- file: plugins/02-dashboard.lua
return {
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = require("onedark.palette").dark
      local dashboard = require("dashboard")

      -- 主题适配
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = colors.cyan, bold = true })
      vim.api.nvim_set_hl(0, "DashboardDesc", { fg = colors.green })
      vim.api.nvim_set_hl(0, "DashboardKey", { fg = colors.orange })
      vim.api.nvim_set_hl(0, "DashboardIcon", { fg = colors.purple })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = colors.comment, italic = true })

      -- 核心配置
      dashboard.setup({
        theme = 'hyper',
        config = {
          week_header = { enable = true },
          shortcut = {
            { desc = '󰈞  Find File', group = 'DashboardDesc', action = 'Telescope find_files', key = 'SPC f f' },
            { desc = '󰊯  Recent Files', group = 'DashboardDesc', action = 'Telescope oldfiles', key = 'SPC f r' },
            { desc = '󰍉  Live Grep', group = 'DashboardDesc', action = 'Telescope live_grep', key = 'SPC f g' },
            { desc = '󰒓  Config', group = 'DashboardIcon', action = 'edit ~/.config/nvim/init.lua', key = 'SPC c' },
            { desc = '󰗼  Quit', group = 'DashboardFooter', action = function() vim.cmd("qa!") end, key = 'q' },
          },
          packages = { enable = true },
          footer = { "󰘃 Neovim 配置 - 已加载 " .. #vim.tbl_keys(require("lazy").plugins()) .. " 个插件" },
          project = { enable = true, limit = 8, icon = ' ', label = '最近项目:', action = 'Telescope find_files cwd=' },
          mru = { limit = 5 },
          header = {
            [[                                                                       ]],
            [[  ██████╗ ██████╗ ██████╗ ██╗   ██╗██╗███╗   ██╗███████╗██╗   ██╗███████╗ ]],
            [[ ██╔════╝██╔═══██╗██╔══██╗██║   ██║██║████╗  ██║██╔════╝██║   ██║██╔════╝ ]],
            [[ ██║     ██║   ██║██║  ██║██║   ██║██║██╔██╗ ██║█████╗  ██║   ██║███████╗ ]],
            [[ ██║     ██║   ██║██║  ██║╚██╗ ██╔╝██║██║╚██╗██║██╔══╝  ██║   ██║╚════██║ ]],
            [[ ╚██████╗╚██████╔╝██████╔╝ ╚████╔╝ ██║██║ ╚████║███████╗╚██████╔╝███████║ ]],
            [[  ╚═════╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝ ]],
            [[                                                                       ]],
          }
        }
      })

      -- 精准控制标签栏显示逻辑
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        pattern = "*",
        callback = function()
          if vim.bo.filetype == "dashboard" then
            vim.opt_local.showtabline = 0  -- 仅对 Dashboard 窗口隐藏
          else
            vim.opt.showtabline = 2       -- 其他窗口强制显示
          end
        end
      })

      -- 离开 Dashboard 后恢复标签栏
      vim.api.nvim_create_autocmd("BufLeave", {
        pattern = "dashboard",
        callback = function()
          vim.opt.showtabline = 2
        end
      })

      -- 兼容 NvimTree 自动关闭
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardReady",
        callback = function()
          if package.loaded["nvim-tree"] then
            require("nvim-tree.api").tree.close()
          end
        end
      })
    end
  }
}