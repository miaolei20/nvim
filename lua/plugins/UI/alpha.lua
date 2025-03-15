return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- 现代化的 ASCII 艺术 (NVIM)
      local logo = {
        "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██║   ██║██║████╗ ████║",
        "██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      -- 设置 header
      dashboard.section.header.val = logo

      -- 简洁现代化的按钮
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", ":ene | startinsert<CR>"),
        dashboard.button("f", "  Find File", "<CMD>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", "<CMD>Telescope frecency<CR>"),
        dashboard.button("g", "  Live Grep", "<CMD>Telescope live_grep<CR>"),
        dashboard.button("b", "  File Browser", "<CMD>Telescope file_browser<CR>"),
        dashboard.button("p", "  Plugins", "<CMD>Telescope lazy_plugins<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- 现代化的高亮组
      local function set_highlights()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#ff79c6", bold = true }) -- 霓虹紫，现代感
        vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#89b4fa", italic = true }) -- 柔和蓝，优雅
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f9e2af", bold = true }) -- 明亮黄，醒目
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#94e2d5", italic = true }) -- 青绿色，现代
      end

      -- 简化的布局
      dashboard.config.layout = {
        { type = "padding", val = 4 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- 初始化
      set_highlights()
      alpha.setup(dashboard.config)

      -- 动态 footer（延迟加载）
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          dashboard.section.footer.val = " Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          vim.schedule(function() pcall(vim.cmd.AlphaRedraw) end)
        end,
      })

      -- 隐藏 bufferline（优化事件）
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function() vim.opt.showtabline = 0 end,
      })
      vim.api.nvim_create_autocmd({ "BufUnload", "BufNewFile" }, {
        callback = function() vim.opt.showtabline = 2 end,
      })
    end,
  },
}