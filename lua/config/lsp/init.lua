local M = {}

local function on_attach(client, bufnr)
  local wk = require("which-key")
  wk.add({
    { "<leader>l", group = "LSP", buffer = bufnr, icon = "💡" },
    { "<leader>lg", group = "Goto", buffer = bufnr },
    { "<leader>lgd", "<cmd>Telescope lsp_definitions<CR>", desc = "转到定义", mode = "n", buffer = bufnr, icon = "🔍" },
    { "<leader>lgr", "<cmd>Telescope lsp_references<CR>", desc = "查找引用", mode = "n", buffer = bufnr, icon = "📚" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "悬停文档", mode = "n", buffer = bufnr, icon = "📖" },
    { "<leader>lr", vim.lsp.buf.rename, desc = "重命名符号", mode = "n", buffer = bufnr, icon = "✏️" },
    { "<leader>lc", vim.lsp.buf.code_action, desc = "代码操作", mode = "n", buffer = bufnr, icon = "⚙️" },
  }, { buffer = bufnr })
end

function M.setup()
  -- 诊断符号
  local diagnostic_signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
    { name = "DiagnosticSignHint", text = "" },
  }
  for _, sign in ipairs(diagnostic_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- 配置诊断设置
  vim.diagnostic.config({
    virtual_text = false,
    float = { border = "rounded", source = "always" },
    signs = { active = true },
    severity_sort = true,
    update_in_insert = false,
  })

  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },
    clangd = {
      capabilities = { offsetEncoding = { "utf-16" } },
      cmd = { "clangd", "--background-index", "--clang-tidy" },
    },
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
  }

  local capabilities = require("blink.cmp").get_lsp_capabilities()

  require("mason-lspconfig").setup_handlers({
    function(server_name)
      local server = servers[server_name] or {}
      require("lspconfig")[server_name].setup({
        on_attach = on_attach,
        capabilities = vim.tbl_deep_extend("force", capabilities, server.capabilities or {}),
        settings = server.settings,
        cmd = server.cmd,
      })
    end,
  })
end

return M