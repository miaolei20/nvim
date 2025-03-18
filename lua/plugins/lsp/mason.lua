return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy", -- 延迟加载
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- Mason 核心配置
      require("mason").setup({
        ui = {
          border = "rounded", -- 圆角边框
          icons = {
            package_installed = "󰄬", -- 安装成功图标
            package_pending = "󰁔",   -- 安装中图标
            package_uninstalled = "󰚌", -- 未安装图标
          },
        },
        max_concurrent_installers = 4, -- 并发安装数
        log_level = vim.log.levels.INFO, -- 日志级别
      })

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
        automatic_installation = true, -- 自动安装 LSP
      })

      -- Mason 工具安装器配置
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",          -- Lua 格式化工具
          "clang-format",    -- C/C++ 格式化工具
          "black",           -- Python 格式化工具
          "shfmt",           -- Shell 格式化工具
          "prettier",        -- JSON/YAML 格式化工具
        },
        auto_update = true, -- 自动更新工具
        run_on_start = true, -- 启动时检查工具
      })
    end,
  },
}
