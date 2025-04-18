return {
  {
    "folke/noice.nvim",
    event = { "VeryLazy", "CmdlineEnter" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "folke/which-key.nvim",
    },
    opts = {
      throttle = 1000 / 60, -- Smoother rendering for STM32 workflows
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { icon = "", title = " Command " },
          search_down = { icon = " ", title = " Search Down " },
          search_up = { icon = " ", title = " Search Up " },
          filter = { icon = "", title = " Filter " },
          lua = { icon = "", title = " Lua " },
          help = { icon = "󰋖", title = " Help " },
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "split",
        view_search = false, -- Handled by nvim-hlslens
      },
      popupmenu = {
        enabled = false, -- Use blink.cmp instead
      },
      notify = {
        enabled = true,
        view = "notify",
        merge = true,
        replace = true,
        timeout = 2000, -- Shorter timeout for non-intrusive notifications
      },
      lsp = {
        progress = { enabled = false },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = true,
          opts = {
            border = "rounded",
            win_options = { winblend = 10 },
            max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.5),
            max_height = math.floor(vim.api.nvim_win_get_height(0) * 0.4),
            format = function(lines)
              -- Clamp text ranges to prevent end_col errors
              local clamped_lines = {}
              for _, line in ipairs(lines) do
                if type(line) == "string" then
                  clamped_lines[#clamped_lines + 1] = line:sub(1, vim.api.nvim_win_get_width(0) - 10)
                end
              end
              return clamped_lines
            end,
          },
        },
        signature = {
          enabled = true,
          auto_open = { enabled = true, trigger = true },
          opts = {
            border = "rounded",
            win_options = { winblend = 10 },
            max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.5),
            max_height = math.floor(vim.api.nvim_win_get_height(0) * 0.4),
          },
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
          size = { width = math.floor(vim.api.nvim_win_get_width(0) * 0.5), height = "auto" },
        },
        notify = {
          merge = true,
          replace = true,
          timeout = 2000,
        },
        mini = {
          timeout = 2000,
          win_options = { winblend = 10 },
          position = { row = "bottom", col = "right" },
        },
        split = {
          enter = true,
          size = { height = "30%" },
          position = { row = "bottom" },
          win_options = { winblend = 10 },
        },
      },
      routes = {
        { filter = { event = "msg_show", min_height = 10 }, view = "split" },
        { filter = { event = "msg_show", kind = "search_count" }, view = "mini" },
        { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
        { filter = { event = "msg_show", find = "telescope" }, opts = { skip = true } }, -- Skip telescope debug messages
        { filter = { event = "msg_show", kind = "" }, view = "mini" }, -- Fallback to mini for short messages
      },
    },
    config = function(_, opts)
      local success, err = pcall(require("noice").setup, opts)
      if not success then
        vim.notify("Noice setup failed: " .. tostring(err), vim.log.levels.ERROR)
      end
      local wk = require("which-key")
      wk.add({
        { "<leader>n", group = "Notifications", icon = "🔔" },
        { "<leader>nh", "<cmd>Noice history<CR>", desc = "Message History", mode = "n", icon = "📜" },
        { "<leader>nl", "<cmd>Noice last<CR>", desc = "Last Message", mode = "n", icon = "⏮️" },
        { "<leader>nn", "<cmd>Telescope notify<CR>", desc = "Search Notifications", mode = "n", icon = "🔍" },
        { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Dismiss Notifications", mode = "n", icon = "🗑️" },
      })
    end,
  },
}