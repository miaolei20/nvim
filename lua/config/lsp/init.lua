local M = {}

local function on_attach(client, bufnr)
  local wk = require("which-key")
  wk.add({
    { "<leader>l", group = "LSP", buffer = bufnr, icon = "💡" },
    { "<leader>lg", group = "Goto", buffer = bufnr },
    { "<leader>lgd", "<cmd>Telescope lsp_definitions<CR>", desc = "Go to Definition", mode = "n", buffer = bufnr, icon = "🔍" },
    { "<leader>lgr", "<cmd>Telescope lsp_references<CR>", desc = "References", mode = "n", buffer = bufnr, icon = "📚" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover Documentation", mode = "n", buffer = bufnr, icon = "📖" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "Rename Symbol", mode = "n", buffer = bufnr, icon = "✏️" },
    { "<leader>lc", vim.lsp.buf.code_action, desc = "Code Action", mode = "n", buffer = bufnr, icon = "⚙️" },
    { "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format Buffer", mode = "n", buffer = bufnr, icon = "📄" },
  }, { buffer = bufnr })
end

function M.setup()
  local diagnostic_signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
    { name = "DiagnosticSignHint", text = "" },
  }
  for _, sign in ipairs(diagnostic_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          format = { enable = false }, -- Prefer stylua via conform.nvim
        },
      },
    },
    clangd = {
      capabilities = { offsetEncoding = { "utf-16" } },
      cmd = { "clangd", "--background-index", "--clang-tidy" },
    },
    pyright = {
      settings = { python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } } },
    },
    bashls = {},
    jsonls = {
      settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
    },
    yamlls = {
      settings = { yaml = { schemas = require("schemastore").yaml.schemas() } },
    },
  }

  local capabilities = require("blink.cmp").get_lsp_capabilities()
  local lspconfig = require("lspconfig")
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      local server = servers[server_name] or {}
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = vim.tbl_deep_extend("force", capabilities, server.capabilities or {}),
        settings = server.settings,
        cmd = server.cmd,
      })
    end,
  })
end

return M
