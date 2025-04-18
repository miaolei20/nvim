return {
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "folke/which-key.nvim" },
    init = function()
      vim.g.VM_theme = "purplegray" -- Modern theme
      vim.g.VM_silent_exit = 1 -- Clean exit
      vim.g.VM_default_mappings = 0 -- Disable default mappings
    end,
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>m", group = "Multi-Cursor", icon = "✍️" },
        { "<leader>mn", "<Plug>(VM-Find-Under)", desc = "Select Next", mode = "n", icon = "➕" },
        { "<leader>ma", "<Plug>(VM-Add-Cursor-At-Pos)", desc = "Add Cursor", mode = "n", icon = "📍" },
        { "<leader>mu", "<Plug>(VM-Add-Cursor-Up)", desc = "Add Cursor Up", mode = "n", icon = "⬆️" },
        { "<leader>md", "<Plug>(VM-Add-Cursor-Down)", desc = "Add Cursor Down", mode = "n", icon = "⬇️" },
      })
      -- Keep original keymaps
      vim.keymap.set({ "n", "x" }, "<C-n>", "<Plug>(VM-Find-Under)", { desc = "Select Next" })
      vim.keymap.set("n", "<C-Up>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Add Cursor Up" })
      vim.keymap.set("n", "<C-Down>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Add Cursor Down" })
    end,
  },
}