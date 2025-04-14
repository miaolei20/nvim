return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      win = {
        border = "rounded",
        padding = { 1, 2 },
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        title = true,
        title_pos = "center",
      },
      icons = {
        breadcrumb = "»",
        separator = "→",
        group = "+",
        mappings = false,
      },
      layout = {
        align = "center",
        spacing = 4,
      },
      show_help = true,
      show_keys = true,
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "<localleader>", mode = { "n", "v" } },
        { "g", mode = { "n", "v" } },
        { "z", mode = "n" },
        { "[", mode = "n" },
        { "]", mode = "n" },
        { "<C-w>", mode = "n" },
        { "<M>", mode = "n" },
      },
    },
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.setup(opts)

      -- Neo-Tree global mappings
      wk.add({
        { "<leader>e", group = "Explorer", icon = "󰉓" },
        {
          "<leader>ee",
          "<cmd>Neotree toggle left<CR>",
          desc = "Toggle Explorer",
          icon = "󰐿",
          mode = "n",
        },
        {
          "<leader>ef",
          "<cmd>Neotree focus left<CR>",
          desc = "Focus Explorer",
          icon = "󰋱",
          mode = "n",
        },
        {
          "<leader>eg",
          "<cmd>Neotree git_status left<CR>",
          desc = "Git Status",
          icon = "󰜘",
          mode = "n",
        },
        {
          "<leader>eb",
          "<cmd>Neotree buffers left<CR>",
          desc = "Buffer List",
          icon = "󰈤",
          mode = "n",
        },
      })

      -- Register Neo-Tree buffer-local mappings for discoverability
      wk.add({
        -- Only active in Neo-Tree buffers
        buffer = nil, -- Will be set dynamically
        {
          "<space>",
          "toggle_node",
          desc = "Toggle Node",
          icon = "󰁙",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "<cr>",
          "open",
          desc = "Open",
          icon = "󰌑",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "<tab>",
          "open_with_window_picker",
          desc = "Open in Window",
          icon = "󱂬",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "P",
          "toggle_preview",
          desc = "Toggle Preview",
          icon = "󰋲",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "a",
          "add",
          desc = "Add File",
          icon = "󰝒",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "A",
          "add_directory",
          desc = "Add Directory",
          icon = "󰉌",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "d",
          "delete",
          desc = "Delete",
          icon = "󰅖",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "r",
          "rename",
          desc = "Rename",
          icon = "󰑕",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "y",
          "copy_to_clipboard",
          desc = "Copy to Clipboard",
          icon = "󰅍",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "x",
          "cut_to_clipboard",
          desc = "Cut to Clipboard",
          icon = "󰆐",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "p",
          "paste_from_clipboard",
          desc = "Paste from Clipboard",
          icon = "󰆒",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "c",
          "copy",
          desc = "Copy File",
          icon = "󰉍",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "m",
          "move",
          desc = "Move File",
          icon = "󰹑",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "q",
          "close_window",
          desc = "Close Explorer",
          icon = "󰅘",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "R",
          "refresh",
          desc = "Refresh",
          icon = "󰑐",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "?",
          "show_help",
          desc = "Show Help",
          icon = "󰋖",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
        {
          "H",
          "toggle_hidden",
          desc = "Toggle Hidden",
          icon = "󰘓",
          mode = "n",
          cond = function()
            return vim.bo.filetype == "neo-tree"
          end,
        },
      }, {
        -- Register when entering a Neo-Tree buffer
        event = "FileType",
        pattern = "neo-tree",
        callback = function(args)
          wk.add(vim.tbl_extend("force", wk.get({ buffer = nil }), { buffer = args.buf }))
        end,
      })
    end,
  },
}
