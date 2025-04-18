return{
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
}