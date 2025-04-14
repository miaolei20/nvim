return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- 优化事件触发
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
