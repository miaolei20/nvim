return {
    {
      "goolord/alpha-nvim",
      event = "VimEnter",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
  
        -- ASCII 艺术
        local logo = {
          "███████╗███████╗████████╗██╗   ██╗██████╗ ",
          "██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗",
          "███████╗█████╗     ██║   ██║   ██║██████╔╝",
          "╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ ",
          "███████║███████╗   ██║   ╚██████╔╝██║     ",
          "╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ",
        }
  
        dashboard.section.header.val = logo
        dashboard.section.buttons.val = {
          dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
          dashboard.button("f", "󰈞  Find File", "<CMD>Telescope find_files<CR>"),
          dashboard.button("r", "󰋚  Recent Files", "<CMD>Telescope frecency<CR>"),
          dashboard.button("g", "󰺮  Live Grep", "<CMD>Telescope live_grep<CR>"),
          dashboard.button("b", "  File Browser", "<CMD>Telescope file_browser<CR>"),
          dashboard.button("p", "  Plugins", "<CMD>Telescope lazy_plugins<CR>"),
          dashboard.button("q", "󰈆  Quit NVIM", ":qa<CR>"),
        }
  
        -- 高亮组设置
        local function set_highlights()
          vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#61afef" })
          vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#98c379" })
          vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#c678dd" })
        end
  
        -- 布局配置
        dashboard.config.layout = {
          { type = "padding", val = 3 },
          dashboard.section.header,
          { type = "padding", val = 2 },
          dashboard.section.buttons,
          { type = "padding", val = 1 },
          dashboard.section.footer,
        }
  
        -- 初始化
        set_highlights()
        alpha.setup(dashboard.config)
  
        -- 动态更新 footer
        vim.api.nvim_create_autocmd("User", {
          pattern = "LazyVimStarted",
          callback = function()
            local stats = require("lazy").stats()
            local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
            dashboard.section.footer.val = "⚡ Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
            pcall(vim.cmd.AlphaRedraw)
          end,
        })
  
        -- 在 Alpha 显示时隐藏 bufferline
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            vim.opt.showtabline = 0
          end,
        })
        vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          callback = function()
            vim.opt.showtabline = 2
          end,
        })
      end,
    },
  }