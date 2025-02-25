-- file: plugins/02-dashboard.lua
return {
  {
    "glepnir/dashboard-nvim", -- 插件名称
    event = "VimEnter", -- 在 VimEnter 事件时加载插件
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- 依赖的插件
    config = function()
      local colors = require("onedark.palette").dark
      local dashboard = require("dashboard")

      -- 主题适配
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = colors.cyan, bold = true }) -- 设置 DashboardHeader 高亮
      vim.api.nvim_set_hl(0, "DashboardDesc", { fg = colors.green }) -- 设置 DashboardDesc 高亮
      vim.api.nvim_set_hl(0, "DashboardKey", { fg = colors.orange }) -- 设置 DashboardKey 高亮
      vim.api.nvim_set_hl(0, "DashboardIcon", { fg = colors.purple }) -- 设置 DashboardIcon 高亮
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = colors.comment, italic = true }) -- 设置 DashboardFooter 高亮

      -- 核心配置
      dashboard.setup({
        theme = 'hyper', -- 设置主题为 hyper
        config = {
          week_header = { enable = true }, -- 启用周标题
          shortcut = { -- 快捷键配置
            { desc = '󰈞  Find File', group = 'DashboardDesc', action = 'Telescope find_files', key = 'SPC f f' },
            { desc = '󰊯  Recent Files', group = 'DashboardDesc', action = 'Telescope oldfiles', key = 'SPC f r' },
            { desc = '󰍉  Live Grep', group = 'DashboardDesc', action = 'Telescope live_grep', key = 'SPC f g' },
            { desc = '󰒓  Config', group = 'DashboardIcon', action = 'edit ~/.config/nvim/init.lua', key = 'SPC c' },
            { desc = '󰗼  Quit', group = 'DashboardFooter', action = function() vim.cmd("qa!") end, key = 'q' },
          },
          packages = { enable = true }, -- 启用包信息
          footer = { "󰘃 Neovim 配置 - 已加载 " .. #vim.tbl_keys(require("lazy").plugins()) .. " 个插件" }, -- 页脚信息
          project = { enable = true, limit = 8, icon = ' ', label = '最近项目:', action = 'Telescope find_files cwd=' }, -- 项目信息
          mru = { limit = 5 }, -- 最近使用文件限制
          header = { -- 标题信息
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
            vim.opt_local.showtabline = 0 -- 仅对 Dashboard 窗口隐藏标签栏
          else
            vim.opt.showtabline = 2       -- 其他窗口强制显示标签栏
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

