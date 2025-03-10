-- init.lua
local M = {}

-- 加载核心模块
local keymaps = require("config.lsp.keymaps")
require("config.lsp.lspsaga")
require("config.lsp.signature")
local servers = require("config.lsp.servers")

-- 优化后的格式化函数
local function lsp_format(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      local ft = vim.bo[bufnr].filetype
      return ({
        python = "pyright",
        lua = "lua_ls",
        c = "clangd",
        cpp = "clangd",
      })[ft] == client.name
    end,
    bufnr = bufnr,
    timeout_ms = 2500,  -- 缩短超时时间提升响应速度
    async = true
  })
end

-- 精简直立客户端能力
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

-- 通用客户端附加配置
local common_on_attach = function(client, bufnr)
  keymaps.create_keymap(client, bufnr)
  
  -- 智能保存格式化 (500ms debounce)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if vim.g.auto_format_enabled then
          lsp_format(bufnr)
        end
      end
    })
  end
end

-- 初始化服务器配置
local function setup_servers()
  local lspconfig = require("lspconfig")
  local defaults = {
    on_attach = common_on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 120 }  -- 优化输入延迟
  }

  for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend("force", defaults, config))
  end
end

function M.setup()
  -- 开发增强配置
  require("neodev").setup({
    library = {
      plugins = { "nvim-dap-ui" },
      types = true
    }
  })

  -- 包管理配置
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls", "clangd", "pyright",
      "bashls", "jsonls", "yamlls"
    },
    automatic_installation = true
  })

  setup_servers()
end

return M
