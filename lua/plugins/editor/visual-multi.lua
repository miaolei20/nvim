return {
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_theme = "purplegray" -- Modern theme
      vim.g.VM_silent_exit = 1 -- Clean exit
      vim.g.VM_default_mappings = 0 -- Disable default mappings
    end,
    config = function()
      -- Define key mappings
      local mappings = {
        { modes = { "n" }, lhs = "<leader>mn", rhs = "<Plug>(VM-Find-Under)", desc = "Select Next" },
        { modes = { "n" }, lhs = "<leader>ma", rhs = "<Plug>(VM-Add-Cursor-At-Pos)", desc = "Add Cursor" },
        { modes = { "n" }, lhs = "<leader>mu", rhs = "<Plug>(VM-Add-Cursor-Up)", desc = "Add Cursor Up" },
        { modes = { "n" }, lhs = "<leader>md", rhs = "<Plug>(VM-Add-Cursor-Down)", desc = "Add Cursor Down" },
        { modes = { "n", "x" }, lhs = "<C-n>", rhs = "<Plug>(VM-Find-Under)", desc = "Select Next" },
        { modes = { "n" }, lhs = "<C-Up>", rhs = "<Plug>(VM-Add-Cursor-Up)", desc = "Add Cursor Up" },
        { modes = { "n" }, lhs = "<C-Down>", rhs = "<Plug>(VM-Add-Cursor-Down)", desc = "Add Cursor Down" },
      }

      -- Set key mappings
      for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.modes, mapping.lhs, mapping.rhs, { desc = mapping.desc })
      end
    end,
  },
}