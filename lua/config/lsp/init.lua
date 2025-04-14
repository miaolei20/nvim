-- config/lsp/init.lua
local M = {}

-- LSP server configurations
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  clangd = {
    capabilities = { offsetEncoding = "utf-16" }, -- 移到 capabilities，避免警告
  },
  pyright = {},
}

-- Set up LSP key mappings
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Go to Definition")
  map("n", "gr", "<cmd>Telescope lsp_references<CR>", "References")
  map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
end

-- Main setup function
function M.setup()
  -- Get blink.cmp LSP capabilities
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  -- Configure diagnostic settings
  vim.diagnostic.config({
    virtual_text = false,
    float = { border = "rounded" },
    signs = { active = true },
    severity_sort = true,
    update_in_insert = false,
  })

  -- Set up LSP servers
  for server, config in pairs(servers) do
    require("lspconfig")[server].setup({
      on_attach = on_attach,
      capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {}),
      settings = config.settings,
    })
  end
end

return M
