return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { 'saghen/blink.cmp' },
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "clangd", "pyright" },
      })
      require("config.lsp").setup()
    end,
  },
}