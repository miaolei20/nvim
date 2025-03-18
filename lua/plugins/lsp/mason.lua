return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy", -- 延遲加載
    config = function()
      -- Mason 核心配置
      require("mason").setup({
        ui = {
          border = "rounded", -- 圓角邊框
          icons = {
            package_installed = "󰄬", -- 安裝成功圖標
            package_pending = "󰁔",   -- 安裝中圖標
            package_uninstalled = "󰚌", -- 未安裝圖標
          },
        },
        max_concurrent_installers = 4, -- 並發安裝數
        log_level = vim.log.levels.INFO, -- 日誌級別
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim", -- 確保在 mason.nvim 之後加載
    dependencies = {
      "williamboman/mason.nvim", -- 明確指定依賴關係
    },
    config = function()
      -- Mason LSP 配置
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",          -- Lua LSP
          "clangd",          -- C/C++ LSP
          "pyright",         -- Python LSP
          "bashls",          -- Bash LSP
          "jsonls",          -- JSON LSP
          "yamlls",          -- YAML LSP
        },
        automatic_installation = true, -- 自動安裝 LSP
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    after = "mason-lspconfig.nvim", -- 確保在 mason-lspconfig.nvim 之後加載
    dependencies = {
      "williamboman/mason.nvim", -- 明確指定依賴關係
    },
    config = function()
      -- Mason 工具安裝器配置
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",          -- Lua 格式化工具
          "clang-format",    -- C/C++ 格式化工具
          "black",           -- Python 格式化工具
          "shfmt",           -- Shell 格式化工具
          "prettier",        -- JSON/YAML 格式化工具
        },
        auto_update = true, -- 自動更新工具
        run_on_start = true, -- 啟動時檢查工具
      })
    end,
  },
}
