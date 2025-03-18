-- keymaps.lua
local M = {}

-- 统一图标资源库
M.icons = {
  diagnostics = {
    Error = " ", Warn = " ", Hint = "󰌵 ", Info = " "
  },
  actions = {
    code = "󰌵 ", rename = "󰅌 ", format = "󰉢 "
  },
  symbols = {
    File = "󰈔 ", Module = "󰆧 ", Method = "󰆧 ",
    Function = "󰊕 ", Variable = "󰫧 ", Class = "󰠱 ",
    Separator = "  "
  }
}

function M.create_keymap(client, bufnr, lsp_format)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- 核心 LSP 操作
  map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "Peek definition")
  map("n", "gr", "<cmd>Lspsaga finder<CR>", "References finder")
  map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Show documentation")
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename symbol")

  -- 诊断导航
  map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous diagnostic")
  map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic")

  -- 智能格式化
  map("n", "<leader>lf", function()
    lsp_format(bufnr)
    vim.notify("Formatted with " .. client.name, vim.log.levels.INFO)
  end, "Format buffer")
end

return M