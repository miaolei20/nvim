return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade_in_slide_out", -- Smooth animation for better visibility
        timeout = 3000,               -- Longer timeout to prevent quick disappearance
        fps = 30,                     -- Balanced frame rate for smooth animations
        max_width = 80,               -- Limit width for readability
        max_height = 10,              -- Limit height to avoid clutter
        background_colour = "#1e222a", -- Match Neovim background for consistency
        render = "compact",           -- Compact style for minimal footprint
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "",
        },
      })
      vim.notify = notify
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        throttle = 1000 / 30, -- Match notify fps for consistency
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline = { icon = "" },
            search_down = { icon = " " },
            search_up = { icon = " " },
          },
          opts = {
            border = { style = "rounded", padding = { 0, 1 } },
            win_options = { winblend = 10 },
            position = { row = "10%", col = "50%" }, -- Slightly lower for better visibility
            size = { width = "auto", height = "auto" },
          },
        },
        messages = {
          enabled = true,
          view = "notify",            -- Use nvim-notify for messages
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",  -- History view for :Noice history
          view_search = "virtualtext",
        },
        popupmenu = {
          enabled = false, -- Disable to reduce overhead
        },
        notify = {
          enabled = true,
          view = "notify",
        },
        lsp = {
          progress = { enabled = false }, -- Disable LSP progress to reduce noise
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
            opts = { border = "rounded", win_options = { winblend = 10 } },
          },
          signature = {
            enabled = true,
            opts = { border = "rounded", win_options = { winblend = 10 } },
          },
          message = { enabled = false },
        },
        presets = {
          bottom_search = false,
          command_palette = false,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        views = {
          cmdline_popup = {
            border = { style = "rounded", padding = { 0, 1 } },
            win_options = { winblend = 10 },
            position = { row = "10%", col = "50%" },
            size = { width = "auto", height = "auto" },
          },
          notify = {
            merge = true,
            replace = true,
            timeout = 3000, -- Sync with nvim-notify
          },
          mini = {
            timeout = 3000, -- Match notify timeout
            win_options = { winblend = 10 },
            position = { row = "bottom", col = "right" },
          },
          messages = {
            view = "split", -- Use split for history to avoid flashing
            enter = true,
            size = { height = "30%" },
            position = { row = "bottom" },
          },
        },
        routes = {
          { -- Route long messages to split
            filter = { event = "msg_show", min_height = 10 },
            view = "split",
          },
          { -- Route search count to mini
            filter = { event = "msg_show", kind = "search_count" },
            view = "mini",
          },
        },
      })
    end,
  },
}
