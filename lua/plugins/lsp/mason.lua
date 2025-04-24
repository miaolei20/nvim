return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
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
      ensure_installed = {
        "clang-format", -- C/C++ formatter
        "black", -- Python formatter
        "stylua", -- Lua formatter
        "shfmt", -- Shell formatter
        "prettier", -- Multi-language formatter
        "cpplint", -- C/C++ linter
        "flake8", -- Python linter
      },
      auto_update = true,
      run_on_start = true,
    },
  },
}