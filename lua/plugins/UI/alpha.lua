return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/which-key.nvim" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Compact, modern ASCII logo
      local logo = {
        "⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀",
      }

      -- Header
      dashboard.section.header.val = logo
      dashboard.section.header.opts.hl = "AlphaHeader"

      -- Buttons with STM32 focus
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", "<cmd>ene | startinsert<CR>"),
        dashboard.button("f", "  Find Files", "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("p", "  STM32 Project", "<cmd>Telescope find_files cwd=~/Projects/STM32<CR>"),
        dashboard.button("e", "  Explorer", "<cmd>Neotree toggle<CR>"),
        dashboard.button("g", "  Live Grep", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("c", "  Config", "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButton"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      -- Footer
      dashboard.section.footer.val = { "" }
      dashboard.section.footer.opts.hl = "AlphaFooter"

      -- Streamlined layout
      local function get_layout()
        local win_height = vim.api.nvim_win_get_height(0)
        local padding = math.max(2, math.floor(win_height * 0.1))
        return {
          { type = "padding", val = padding },
          dashboard.section.header,
          { type = "padding", val = padding },
          dashboard.section.buttons,
          { type = "padding", val = 2 },
          dashboard.section.footer,
        }
      end

      -- Theme-agnostic highlights
      local function set_highlights()
        local colors = {
          header = vim.api.nvim_get_hl(0, { name = "Keyword" }).fg or "#89b4fa",
          button = vim.api.nvim_get_hl(0, { name = "String" }).fg or "#b4befe",
          shortcut = vim.api.nvim_get_hl(0, { name = "Number" }).fg or "#f9e2af",
          footer = vim.api.nvim_get_hl(0, { name = "Comment" }).fg or "#a6e3a1",
        }
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = colors.header, bold = true })
        vim.api.nvim_set_hl(0, "AlphaButton", { fg = colors.button, italic = true })
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = colors.shortcut, bold = true })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = colors.footer, italic = true })
      end

      -- Setup
      set_highlights()
      alpha.setup({ layout = get_layout() })

      -- Dynamic footer with Lazy stats
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          dashboard.section.footer.val = { "⚡ " .. stats.count .. " plugins in " .. ms .. "ms" }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      -- Hide UI elements in Alpha
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt.showtabline = 0
          vim.opt.laststatus = 0
          vim.opt.winbar = ""
        end,
      })
      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = 0,
        callback = function()
          vim.opt.showtabline = 2
          vim.opt.laststatus = 3
          vim.opt.winbar = "%=%m %f"
        end,
      })

      -- Which-key integration
      local wk = require("which-key")
      wk.add({
        { "<leader>d", group = "Dashboard", icon = "🏠" },
        { "<leader>dd", "<cmd>Alpha<CR>", desc = "Open Dashboard", mode = "n", icon = "📊" },
      })
    end,
  },
}