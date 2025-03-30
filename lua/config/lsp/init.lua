local M = {}

local servers = {
  lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
  clangd = { offsetEncoding = "utf-16" },
  pyright = {},
}

local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "查看定义")
  map("n", "gr", "<cmd>Lspsaga finder<CR>", "查找引用")
  map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "显示文档")
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "重命名")
  map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "上一个诊断")
  map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "下一个诊断")
  map("n", "<leader>lf", vim.lsp.buf.format, "格式化代码")
  map("n", "<leader>q", function()
    local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
    if loclist_winid == 0 then
      vim.diagnostic.setloclist({ open = true })
      vim.cmd("lopen")
    else
      vim.cmd("lclose")
    end
  end, "切换诊断列表")
end

function M.setup()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- 配置 LSP 服务器
  for server, config in pairs(servers) do
    require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, config))
  end

  -- 配置诊断
  vim.diagnostic.config({
    virtual_text = { prefix = "●", severity = { min = vim.diagnostic.severity.WARN } },
    float = { border = "rounded" },
    signs = { text = { "", "", "", "" } },
    severity_sort = true,
  })

  -- 动态更新诊断列表
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
        vim.diagnostic.setloclist({ open = false })
      end
    end,
  })

  -- 配置 Lspsaga
  require("lspsaga").setup({
    ui = { border = "rounded" },
    symbol_in_winbar = { enable = true },
    lightbulb = { enable = false },
  })
end

return M