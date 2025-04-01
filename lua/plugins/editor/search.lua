return {
  -- Modern Git integration with minimalist signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      signcolumn = true,  -- Show in dedicated left column
      numhl = true,       -- Enable line number highlighting
      current_line_blame = true, -- Enable git blame
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr })
        vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr })
      end
    },
    config = function(_, opts)
      -- Use theme colors directly
      require("gitsigns").setup(opts)
    end
  },

  -- Minimal scrollbar with subtle styling
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      handle = {
        color = "#4b5263",  -- Subdued gray from onedark
        blend = 30,         -- Partial transparency
      },
      excluded_filetypes = { "NvimTree", "dashboard" },
      handlers = {
        gitsigns = false,   -- Disable git marks in scrollbar
        search = false      -- Cleaner look
      }
    }
  },

  -- Enhanced search visualization
  {
    "kevinhwang91/nvim-hlslens",
    keys = { "n", "N", "*", "#" },
    config = function()
      require("hlslens").setup({
        calm_down = true,    -- Stop lens jumping when holding key
        nearest_only = true -- Only highlight nearest match
      })
    end
  },

  -- Smart multi-cursor with modern keymaps
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "Create selection" },
      { "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", mode = "n" },
      { "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", mode = "n" }
    },
    init = function()
      vim.g.VM_theme = "purplegray"  -- Modern color scheme
      vim.g.VM_silent_exit = 1       -- Clean exit behavior
    end
  }
}