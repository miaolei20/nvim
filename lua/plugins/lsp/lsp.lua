return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      -- "saghen/blink.cmp",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim", -- Added for jsonls and yamlls schemas
    },
    config = function()
      require("config.lsp").setup()
    end,
  },
}
