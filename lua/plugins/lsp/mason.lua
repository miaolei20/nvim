return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy", -- 延迟加载，优化启动性能
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local ok, mason = pcall(require, "mason")
      if not ok then
        vim.notify("mason.nvim not found!", vim.log.levels.ERROR)
        return
      end

      mason.setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "󰄬", -- ✅ 更现代的 UI
            package_pending = "󰁔",
            package_uninstalled = "󰚌",
          },
        },
        max_concurrent_installers = 4, -- 限制并发安装数，避免卡顿
        log_level = vim.log.levels.INFO, -- 日志级别
      })

      -- mason-lspconfig 配置
      local ok_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
      if ok_lsp then
        mason_lspconfig.setup()
      else
        vim.notify("mason-lspconfig.nvim not found!", vim.log.levels.WARN)
      end

      -- mason-tool-installer 配置
      local ok_installer, mason_tool_installer = pcall(require, "mason-tool-installer")
      if ok_installer then
        mason_tool_installer.setup({
          ensure_installed = {
            "stylua",
            "clang-format",
            "lua-language-server",
            "pyright",
            "rust-analyzer",
            "codelldb",
          },
          auto_update = true, -- 自动更新已安装的工具
          run_on_start = false, -- 不在启动时运行，避免额外延迟
        })
      else
        vim.notify("mason-tool-installer.nvim not found!", vim.log.levels.WARN)
      end
    end,
  },
}
