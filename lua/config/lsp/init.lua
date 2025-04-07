-- init.lua
local M = {}

-- Define LSP servers and their configurations
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  clangd = {
    offsetEncoding = "utf-16",
  },
  pyright = {},
}

-- Function to set up key mappings for LSP
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) -- Fixed missing comma
  end

  -- Simplified LSP operations
  map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Definitions")
  map("n", "gr", "<cmd>Telescope lsp_references<CR>", "References")
  map("n", "K", vim.lsp.buf.hover, "Hover Doc")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
end

-- Main setup function
function M.setup()
  -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  -- Configure LSP servers
  for server, config in pairs(servers) do
    require("lspconfig")[server].setup(vim.tbl_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, config))
  end

  -- Modern diagnostic configuration
  vim.diagnostic.config({
    virtual_text = false, -- Disable inline diagnostics, use Telescope instead
    float = { border = "rounded" },
    signs = true,
    severity_sort = true,
    update_in_insert = false,
  })
end

return M