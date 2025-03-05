local M = {}

-- 加载依赖模块
local keymaps = require("config.lsp.keymaps")
-- 自动加载 lspsaga 和 signature 的配置
require("config.lsp.lspsaga")
require("config.lsp.signature")
require("config.lsp.diagnostic")
local servers = require("config.lsp.servers")

-- 格式化函数
local function lsp_format(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      local filetype = vim.bo[bufnr].filetype
      if filetype == "python" then
        return client.name == "pyright"
      elseif filetype == "lua" then
        return client.name == "lua_ls"
      elseif filetype:match("^c%a*") then
        return client.name == "clangd"
      end
      return client.name ~= "tsserver"
    end,
    bufnr = bufnr,
    async = true,
    timeout_ms = 3000,
  })
end

-- 扩展能力（包含 cmp 补全和折叠支持）
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities(),
  {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
    experimental = {
      foldingRange = true,
      foldingUp = true,
      foldingDown = true,
    },
  }
)

-- 通用 on_attach 函数：绑定键位、初始化折叠插件（如 ufo）
local common_on_attach = function(client, bufnr)
  keymaps.create_keymap(client, bufnr)
  if client.supports_method("textDocument/foldingRange") then
    require("ufo").attach(bufnr)
  end
  -- 若需要自动格式化，可在此添加 BufWritePre 自动命令
end

-- 加载所有语言服务器配置
local function setup_servers()
  local lspconfig = require("lspconfig")
  for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend("force", {
      on_attach = common_on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }, config))
  end
end

-- 针对特定文件类型设置缩进等选项
local function setup_filetypes_autocmd()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
      vim.bo.tabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 4
      vim.bo.expandtab = true
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      vim.bo.tabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 4
      vim.bo.expandtab = true
    end,
  })
end

function M.setup()
  -- Neovim 开发增强设置
  require("neodev").setup({
    library = {
      plugins = { "nvim-dap-ui" },
      types = true,
    },
  })

  -- Mason LSP 配置，自动安装常用语言服务器
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",  -- Lua
      "clangd",  -- C/C++
      "pyright", -- Python
      "bashls",  -- Bash
      "jsonls",  -- JSON
      "yamlls",  -- YAML
    },
    automatic_installation = true,
  })

  setup_servers()
  setup_filetypes_autocmd()
end

return M
