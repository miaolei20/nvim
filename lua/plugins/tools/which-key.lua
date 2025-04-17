return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = require("config.which-key").opts,
    config = function(_, opts)
      require("config.which-key").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "saghen/blink.cmp" },
        opts = {
          ensure_installed = { "lua_ls", "clangd", "pyright" },
        },
      },
    },
    config = function()
      require("config.lsp").setup()
    end,
  },
}