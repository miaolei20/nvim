return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Larger, modern ASCII logo
      local logo = {
        "        ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀",
        "        ⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀",
        "        ⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀",
        "        ⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀",
        "        ⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀",
        "        ⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀",
        "        ⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀",
        "        ⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀",
        "        ⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀",
        "        ⠀⠀⠀⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀",
        "        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀",
      }

      -- Header
      dashboard.section.header.val = logo
      dashboard.section.header.opts.hl = "AlphaHeader"

      -- Enhanced button layout with LeetCode added
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", "<cmd>ene | startinsert<cr>"),
        dashboard.button("f", "  Find Files", "<cmd>Telescope find_files<cr>"),
        dashboard.button("r", "  Recent Files", "<cmd>Telescope frecency<cr>"),
        dashboard.button("g", "  Live Grep", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("e", "  Explorer", "<cmd>Telescope file_browser<cr>"),
        dashboard.button("l", "󰌵  LeetCode", "<cmd>Leet<cr>"), -- Added LeetCode button
        dashboard.button("c", "  Config", "<cmd>e " .. vim.fn.stdpath("config") .. "/init.lua<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }

      -- Footer with dynamic info
      dashboard.section.footer.val = { "" }
      dashboard.section.footer.opts.hl = "AlphaFooter"

      -- Full-screen, balanced layout
      local function get_layout()
        local win_height = vim.api.nvim_win_get_height(0)
        local padding_top = math.max(3, math.floor(win_height * 0.15))
        local padding_mid = math.max(2, math.floor(win_height * 0.1))
        local padding_bottom = 2
        return {
          { type = "padding", val = padding_top },
          dashboard.section.header,
          { type = "padding", val = padding_mid },
          dashboard.section.buttons,
          { type = "padding", val = padding_bottom },
          dashboard.section.footer,
        }
      end

      -- Modern, vibrant highlights
      local function set_highlights()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa", bold = true })
        vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#b4befe", italic = true })
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f9e2af", bold = true })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#a6e3a1", italic = true })
      end

      -- Setup
      set_highlights()
      alpha.setup({ layout = get_layout() })

      -- Dynamic footer with system info and Lazy stats
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          local version = vim.version()
          local nvim_ver = string.format("NVIM v%d.%d.%d", version.major, version.minor, version.patch)
          dashboard.section.footer.val = {
            "⚡ " .. stats.count .. " plugins loaded in " .. ms .. "ms",
            nvim_ver .. " | " .. vim.loop.os_uname().sysname,
          }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      -- Tabline toggle
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function() vim.opt.showtabline = 0 end,
      })
      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = 0,
        callback = function() vim.opt.showtabline = 2 end,
      })
    end,
  },
}