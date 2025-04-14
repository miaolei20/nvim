return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy", -- Defer loading until needed
    opts = {
      preset = "modern", -- Use modern layout for better visuals
      delay = 300, -- Match timeoutlen
      win = {
        border = "rounded", -- VSCode-like rounded borders
        padding = { 1, 2 },
      },
    },
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup(opts)
    end,
  },
}
