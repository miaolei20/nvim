local M = {}

local servers = {
  lua_ls = {
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  clangd = { capabilities = { offsetEncoding = "utf-16" } },
  pyright = {},
}

local function on_attach(client, bufnr)
  client.offset_encoding = client.offset_encoding or "utf-8"
  local map = function(m, lhs, rhs)
    vim.keymap.set(m, lhs, rhs, { buffer = bufnr, silent = true })
  end
  map("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
  map("n", "gr", "<cmd>Lspsaga finder<CR>")
  map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>")
  map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
  map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
  map("n", "<leader>lf", vim.lsp.buf.format)
end

function M.setup()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- LSP servers
  for server, config in pairs(servers) do
    require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, config))
  end

  -- Diagnostics
  vim.diagnostic.config({
    virtual_text = { prefix = "●" },
    signs = { text = { Error = "", Warn = "", Hint = "󰌵", Info = "" } },
    float = { border = "rounded" },
  })

  -- Lspsaga
  require("lspsaga").setup({
    ui = { border = "rounded" },
    symbol_in_winbar = { enable = true, separator = " › " },
    lightbulb = {
      enable = false,
    },
  })
end

return M