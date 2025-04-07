return {
  {
    "saghen/blink.cmp",
    -- AstroNvim-style multi-event triggering
    event = { "InsertEnter", "CmdlineEnter" },
    version = "v1.*", -- Ensures pre-built binary download
    dependencies = {
      "rafamadriz/friendly-snippets", -- Snippet support
    },
    opts = {
      -- Key mappings with AstroNvim-like behavior
      keymap = {
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" }, -- Toggle completion and docs
        ["<CR>"] = { "accept", "fallback" }, -- Accept or fallback
        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          function(cmp)
            local has_words_before = function()
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            if vim.api.nvim_get_mode().mode == "c" or has_words_before() then
              cmp.show()
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          function(cmp)
            if vim.api.nvim_get_mode().mode == "c" then cmp.show() end
          end,
          "fallback",
        },
        ["<C-N>"] = { "select_next", "show" }, -- Next item or show
        ["<C-P>"] = { "select_prev", "show" }, -- Previous item or show
        ["<C-U>"] = { "scroll_documentation_up", "fallback" }, -- Scroll docs up
        ["<C-D>"] = { "scroll_documentation_down", "fallback" }, -- Scroll docs down
        ["<C-E>"] = { "hide", "fallback" }, -- Hide completion
      },

      -- Enhanced sources with AstroNvim-inspired defaults plus extras
      sources = {
        default = {
          "lsp",      -- Language server completions
          "path",     -- File path completions
          "snippets", -- Snippet completions (friendly-snippets)
          "buffer",   -- Buffer word completions
          "lazydev",  -- Lua-specific completions for Neovim (optional, requires lazydev.nvim)
        },
      },

      -- Completion settings for a polished UI
      completion = {
        ghost_text = { enabled = true }, -- Inline preview
        menu = {
          border = "none", -- Borderless menu
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None", -- AstroNvim-style highlights
        },
        documentation = {
          auto_show = true, -- Auto-display docs like AstroNvim
          window = {
            border = "none",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
      },

      -- Dynamic enabling, AstroNvim-like
      enabled = function()
        return vim.bo.buftype ~= "prompt" -- Disable in prompt buffers
      end,

      -- Appearance with custom icons
      appearance = {
        kind_icons = {
          Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "󰒓",
          Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
          Module = "󰏗", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
          Enum = "󰕘", Keyword = "󰌋", Snippet = "", Color = "󰏘",
          File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "󰕚",
          Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
          TypeParameter = "󰊄",
        },
      },

      -- Optional: Optimize fuzzy matching (Rust-based by default)
      fuzzy = {
        implementation = "prefer_rust", -- Use Rust fuzzy matcher if available
      },
    },
  },
}