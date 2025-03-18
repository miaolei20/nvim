-- init.lua
local M = {}

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
    timeout_ms = 2500,
    async = true
  })
end

-- 客户端能力配置
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

-- 通用客户端附加配置
local common_on_attach = function(client, bufnr)
  keymaps.create_keymap(client, bufnr, lsp_format)
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

-- 初始化服务器
local function setup_servers()
  local lspconfig = require("lspconfig")
  local defaults = {
    on_attach = common_on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 120 }
  }

  for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend("force", defaults, config))
  end
end

function M.setup()
  require("neodev").setup({
    library = {
      plugins = { "nvim-dap-ui" },
      types = true
    }
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls", "clangd", "pyright",
      "bashls", "jsonls", "yamlls"
    },
    automatic_installation = true
  })

  setup_servers()
end

-- 折叠配置
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 5
vim.opt.fillchars:append({ fold = " " })

function _G.custom_fold_text()
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local first_line = vim.fn.getline(vim.v.foldstart):gsub("\t", "  "):sub(1, 60)
  local icon = "󰘖 "
  return string.format("%s %s  %d lines  %s ",
    icon,
    vim.bo.filetype,
    line_count,
    first_line
  )
end

vim.opt.foldtext = "v:lua.custom_fold_text()"

-- 高亮配置
vim.api.nvim_set_hl(0, "Folded", { fg = "#569CD6", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#808080", bg = "NONE" })

-- 文件类型优化
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "python", "cpp" },
  callback = function()
    vim.opt_local.foldmethod = "syntax"
    if vim.fn.foldlevel(1) == 0 then
      vim.opt_local.foldmethod = "indent"
    end
  end
})

return M