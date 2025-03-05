return {
  "williamboman/mason.nvim",                     -- 主插件
  event = "VimEnter",                            -- 在 Vim 进入时加载
  dependencies = {
    "williamboman/mason-lspconfig.nvim",         -- LSP 配置插件
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- 工具安装插件
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓", -- 已安装包的图标
          package_pending = "➜", -- 待安装包的图标
          package_uninstalled = "✗" -- 未安装包的图标
        },
        border = "rounded" -- 界面边框样式
      }
    })

    require("mason-lspconfig").setup() -- 配置 mason-lspconfig 插件
    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",              -- 格式化工具
        "clang-format",        -- LLVM格式支持
        "lua-language-server", -- Lua 语言服务器
        "pyright",             -- Python 语言服务器
        "rust-analyzer",       -- Rust 语言服务器
        "codelldb"
      }
    })
  end
}
