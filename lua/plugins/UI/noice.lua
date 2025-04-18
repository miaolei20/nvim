return {
  {
    "folke/noice.nvim",
    event = { "VeryLazy", "CmdlineEnter" }, -- Lazy-load on relevant events
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "folke/which-key.nvim",
    },
    opts = {
      throttle = 1000 / 60, -- Optimize rendering for STM32 workflows
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
        view = "notify", -- Default to notify for messages
        view_error = "notify",
        view_warn = "notify",
        view_history = "split",
        view_search = false, -- Handled by nvim-hlslens
      },
      popupmenu = {
        enabled = false, -- Use blink.cmp for completion
      },
      notify = {
        enabled = true,
        merge = true, -- Merge consecutive notifications
        replace = true, -- Replace existing notifications
        timeout = 1500, -- Reduced timeout for faster dismissal
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
          silent = true, -- Suppress hover noise
          opts = {
            border = "rounded",
            win_options = { winblend = 10 },
            max_width = 80, -- Fixed width for predictability
            max_height = 20, -- Fixed height for predictability
            format = function(lines)
              -- Clamp text to prevent overflow
              local clamped_lines = {}
              for _, line in ipairs(lines) do
                if type(line) == "string" then
                  clamped_lines[#clamped_lines + 1] = line:sub(1, 70)
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
            max_width = 80, -- Fixed width for predictability
            max_height = 20, -- Fixed height for predictability
          },
        },
        message = { enabled = false }, -- Disable LSP messages to avoid clutter
      },
      presets = {
        bottom_search = false, -- Use nvim-hlslens for search
        command_palette = false, -- Disable command palette
        long_message_to_split = true, -- Split long messages
        inc_rename = false, -- Disable incremental rename
        lsp_doc_border = true, -- Add borders to LSP docs
      },
      views = {
        cmdline_popup = {
          border = { style = "rounded", padding = { 0, 1 } },
          win_options = { winblend = 10 },
          position = { row = 5, col = "50%" }, -- Fixed position for stability
          size = { width = "50%", height = "auto" }, -- Percentage-based width
        },
        notify = {
          merge = true,
          replace = true,
          timeout = 1500, -- Match notify timeout
          win_options = { winblend = 10 },
        },
        mini = {
          timeout = 1500,
          win_options = { winblend = 10 },
          position = { row = "bottom", col = "right" }, -- Stable bottom-right position
        },
        split = {
          enter = true,
          size = { height = "30%" }, -- Percentage-based height
          position = { row = "bottom" }, -- Stable bottom position
          win_options = { winblend = 10 },
        },
      },
      routes = {
        { filter = { event = "msg_show", min_height = 10 }, view = "split" }, -- Long messages to split
        { filter = { event = "msg_show", kind = "search_count" }, view = "mini" }, -- Search counts to mini
        { filter = { event = "msg_show", find = "written" }, opts = { skip = true } }, -- Skip "written" messages
        { filter = { event = "msg_show", find = "telescope" }, opts = { skip = true } }, -- Skip telescope messages
        { filter = { event = "msg_show", find = "Telescope" }, opts = { skip = true } }, -- Additional telescope skip
        { filter = { event = "msg_show", find = "Spectre" }, opts = { skip = true } }, -- Skip spectre messages
        { filter = { event = "msg_show", kind = "" }, view = "mini" }, -- Short messages to mini
      },
    },
    config = function(_, opts)
      -- Utility function to validate window dimensions
      local function validate_window()
        local lines = vim.o.lines
        local columns = vim.o.columns
        if lines < 20 or columns < 80 then
          vim.notify(
            "Window too small for noice.nvim: lines=" .. lines .. ", columns=" .. columns,
            vim.log.levels.WARN
          )
          return false
        end
        return true
      end

      -- Disable noice during telescope and spectre operations to prevent UI conflicts
      local function disable_noice_for_plugins()
        if not validate_window() or not package.loaded["noice"] then
          return
        end
        require("noice").disable()
      end

      local function enable_noice_for_plugins()
        if not validate_window() or not package.loaded["noice"] then
          return
        end
        require("noice").enable()
      end

      -- Autocommands for telescope
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopeFindPre",
        callback = disable_noice_for_plugins,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopeClose",
        callback = enable_noice_for_plugins,
      })

      -- Autocommands for spectre
      vim.api.nvim_create_autocmd("User", {
        pattern = "SpectreOpen",
        callback = disable_noice_for_plugins,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "SpectreClose",
        callback = enable_noice_for_plugins,
      })

      -- Setup noice with error handling
      local success, err = pcall(require("noice").setup, opts)
      if not success then
        vim.notify(
          "Noice setup failed: " .. tostring(err) .. "\nStacktrace: " .. debug.traceback(),
          vim.log.levels.ERROR
        )
      end

      -- Set up which-key bindings
      require("which-key").add({
        { "<leader>n", group = "Notifications", icon = "🔔" },
        { "<leader>nh", "<cmd>Noice history<CR>", desc = "Message History", mode = "n", icon = "📜" },
        { "<leader>nl", "<cmd>Noice last<CR>", desc = "Last Message", mode = "n", icon = "⏮️" },
        { "<leader>nn", "<cmd>Telescope notify<CR>", desc = "Search Notifications", mode = "n", icon = "🔍" },
        { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Dismiss Notifications", mode = "n", icon = "🗑️" },
      })
    end,
  },
}