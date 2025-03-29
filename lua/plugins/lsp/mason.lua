return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "󰄬",
          package_pending = "󰁔",
          package_uninstalled = "󰚌",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "clangd", "pyright", "bashls", "jsonls", "yamlls" },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "stylua", "clang-format", "black", "shfmt", "prettier" },
      auto_update = true,
      run_on_start = true,
    },
  },
}