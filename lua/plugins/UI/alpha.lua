return {
  -- Alpha启动页面
  {
    "goolord/alpha-nvim",
    event = "VimEnter",  -- 在Vim启动时加载
    dependencies = { "nvim-lua/plenary.nvim", "nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- 自定义header文本
      dashboard.section.header.val = {
        "   _______     __    __",
        "  / ____/ |   / /   / /",
        " / / __  | | / /   / / ",
        "/ /_/ /  | |/ /   / /__",
        "\\____/   |___/   /____/",
      }

      -- 自定义快捷方式
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles<CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep<CR>"),
        dashboard.button("q", "󰿅  Quit Neovim", ":qa<CR>"),
      }

      -- 自定义footer
      dashboard.section.footer.val = "Welcome to Neovim!"

      -- 绑定配置
      alpha.setup(dashboard.opts)
    end,
  },
}
