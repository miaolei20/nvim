-- file: plugins/dashboard.lua
return {
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",                               -- 在 Neovim 启动时自动加载
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- 图标支持
    config = function()
      local colors = require("onedark.palette").dark  -- 获取主题颜色
      local dashboard = require("dashboard")

      -- ==================== 主题适配 ====================
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = colors.cyan, bold = true })
      vim.api.nvim_set_hl(0, "DashboardDesc", { fg = colors.green })
      vim.api.nvim_set_hl(0, "DashboardKey", { fg = colors.orange })
      vim.api.nvim_set_hl(0, "DashboardIcon", { fg = colors.purple })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = colors.comment, italic = true })

      -- ==================== 核心配置 ====================
      dashboard.setup({
        theme = 'hyper',                   -- 内置主题风格
        config = {
          week_header = { enable = true }, -- 显示周数
          shortcut = {
            { desc = '󰈞  Find File', group = 'DashboardDesc', action = 'Telescope find_files', key = 'SPC f f' },
            { desc = '󰊯  Recent Files', group = 'DashboardDesc', action = 'Telescope oldfiles', key = 'SPC f r' },
            { desc = '󰍉  Live Grep', group = 'DashboardDesc', action = 'Telescope live_grep', key = 'SPC f g' },
            { desc = '󰒓  Config', group = 'DashboardIcon', action = 'edit ~/.config/nvim/init.lua', key = 'SPC c' },
            { desc = '󰗼  Quit', group = 'DashboardFooter', action = function() vim.cmd("qa!") end, key = 'q' }, },
          packages = { enable = true }, -- 显示插件数量
          footer = { "󰘃 Neovim 配置 - 已加载 " .. #vim.tbl_keys(require("lazy").plugins()) .. " 个插件" }, -- 动态统计插件数
          project = {
            enable = true,
            limit = 8, -- 显示最近项目数量
            icon = ' ',
            label = '最近项目:',
            action = 'Telescope find_files cwd='
          },
          mru = { limit = 5 }, -- 最近文件数量
          header = {           -- ASCII 艺术字生成工具：https://patorjk.com/software/taag/
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

      -- ==================== 高级功能 ====================
      -- 自动关闭 NvimTree 等插件后再显示 Dashboard
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardReady",
        callback = function()
          if package.loaded["nvim-tree"] then
            require("nvim-tree.api").tree.close()
          end
        end
      })

      -- 自定义命令快速访问
      vim.api.nvim_create_user_command("DB", function()
        require("dashboard").instance:refresh()
      end, { desc = "刷新 Dashboard 界面" })
    end
  }
}
