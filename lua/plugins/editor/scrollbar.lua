return {
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      handle = {
        color = "#4b5263", -- Subdued gray
        blend = 30, -- Partial transparency
      },
      excluded_filetypes = { "NvimTree", "neo-tree", "dashboard", "TelescopePrompt" },
      handlers = {
        gitsigns = false, -- Avoid overlap with gitsigns.nvim
        search = false, -- Avoid overlap with hlslens
        cursor = true, -- Show cursor position
      },
    },
  },
}