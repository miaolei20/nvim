return {
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter", "BufReadPost" },
    dependencies = { "zbirenbaum/copilot-cmp", "hrsh7th/nvim-cmp" },
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        debounce = 120,
        keymap = {
          accept = "<M-CR>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        c = true,
        cpp = true,
        lua = true,
        python = true,
        javascript = true,
        ["*"] = false,
      },
      server_opts_overrides = {
        settings = {
          advanced = {
            languageOverrides = {
              c = { maxNodeSize = 64 },
              cpp = { maxNodeSize = 64, inlineSuggestCount = 3 },
              lua = { inlineSuggestCount = 4 },
              python = { maxNodeSize = 80 },
              javascript = { inlineSuggestCount = 3 },
            },
            maxCompletions = 30,
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    opts = {
      method = "getCompletionsCycling",
      formatters = {
        insert_text = function(_, item)
          local ft = vim.bo.filetype
          local formatters = {
            c = function(t) return t:gsub("%s*;%s*$", "") end,
            lua = function(t) return t:gsub("^end,?$", "") end,
            python = function(t) return t:gsub(":$", "") end,
            javascript = function(t) return t:gsub(";$", ""):gsub("//.*$", "") end,
          }
          return (formatters[ft] or function(t) return t end)(item.insertText)
        end,
      },
    },
  },
}