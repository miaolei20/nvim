return {
  {
    "rcarriga/nvim-notify",
    event = { "VeryLazy", "BufReadPost", "BufNewFile" }, -- Load after UI setup
    dependencies = { "nvim-telescope/telescope.nvim", "folke/which-key.nvim" },
    opts = {
      stages = "fade_in_slide_out", -- Smooth animation
      timeout = 3000, -- 3s duration
      fps = 30, -- Smooth animation performance
      max_width = 80, -- Readable width
      max_height = 10, -- Avoid clutter
      background_colour = "#1e222a", -- Match Neovim dark theme
      render = "compact", -- Minimal footprint
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "",
      },
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify -- Override default vim.notify
      -- Load Telescope notify extension
      pcall(require("telescope").load_extension, "notify")
      -- Which-key mappings
      local wk = require("which-key")
      wk.add({
        { "<leader>n", group = "Notifications", icon = "🔔" },
        { "<leader>nn", function() require("telescope").extensions.notify.notify() end, desc = "Search Notifications", mode = "n", icon = "🔍" },
        { "<leader>nd", function() notify.dismiss({ silent = true, pending = true }) end, desc = "Dismiss Notifications", mode = "n", icon = "🗑️" },
      })
    end,
  },
}