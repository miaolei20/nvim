return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed   = "󰄬",
          package_pending     = "󰁔",
          package_uninstalled = "󰚌",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "clangd", "pyright", "bashls", "jsonls", "yamlls" },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonLog" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "stylua", "clang-format", "black", "shfmt", "prettier" },
      auto_update = true,
      run_on_start = true,
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
}
