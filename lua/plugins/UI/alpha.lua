return {
  -- Alpha启动页面
  {
    "goolord/alpha-nvim",
    event = "VimEnter",  -- 在Vim启动时加载
    dependencies = { "nvim-lua/plenary.nvim", "nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local hl = require("alpha.themes.dashboard").highlight

      -- 自定义header文本，现代化的ASCII艺术
      dashboard.section.header.val = {
        "███╗   ██╗███████╗██╗   ██╗██╗ ██████╗████████╗",
        "████╗  ██║██╔════╝██║   ██║██║██╔══██╗╚══██╔══╝",
        "██╔██╗ ██║█████╗  ██║   ██║██║██████╔╝   ██║",
        "██║╚██╗██║██╔══╝  ██║   ██║██║██╔═══╝    ██║",
        "██║ ╚████║███████╗╚██████╔╝██║██║        ██║",
        "╚═╝  ╚═══╝ ╚══════╝ ╚═════╝ ╚═╝╚═╝        ╚═╝",
      }

      -- 自定义快捷方式，增加图标和现代化设计
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New File", ":ene <CR>"),
        dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recently Opened", ":Telescope oldfiles<CR>"),
        dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"),
        dashboard.button("s", "  Settings", ":e $MYVIMRC<CR>"),
        dashboard.button("q", "󰿅  Quit Neovim", ":qa<CR>"),
      }

      -- 自定义footer，增加版权和现代化信息
      dashboard.section.footer.val = "Welcome to Neovim!"

      -- 自动适配主题色
      local theme = vim.g.colors_name or "default"
      if theme == "onedark" then
        dashboard.section.header.opts.hl = "Statement"
        dashboard.section.buttons.opts.hl = "Function"
        dashboard.section.footer.opts.hl = "Comment"
      elseif theme == "gruvbox" then
        dashboard.section.header.opts.hl = "Identifier"
        dashboard.section.buttons.opts.hl = "Constant"
        dashboard.section.footer.opts.hl = "PreProc"
      else
        dashboard.section.header.opts.hl = "Type"
        dashboard.section.buttons.opts.hl = "Keyword"
        dashboard.section.footer.opts.hl = "String"
      end

      -- 设置边距和布局，让页面看起来更现代
      dashboard.opts.margin = 5

      -- 绑定配置
      alpha.setup(dashboard.opts)
    end,
  },
}
