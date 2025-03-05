local M = {}

-- 图标定义（可供 lspsaga、诊断等模块复用）
M.icons = {
  diagnostics = {
    Error = " ",
    Warn  = " ",
    Hint  = "󰌵 ",
    Info  = " ",
  },
  code_action = "󰌵",
  symbol = {
    File         = "󰈔 ",
    Module       = "󰆧 ",
    Namespace    = "󰅩 ",
    Package      = "󰏖 ",
    Class        = "󰠱 ",
    Method       = "󰆧 ",
    Property     = "󰜢 ",
    Field        = "󰜢 ",
    Constructor  = " ",
    Enum         = "󰕘 ",
    Interface    = "󰕘 ",
    Function     = "󰊕 ",
    Variable     = "󰫧 ",
    Constant     = "󰏿 ",
    String       = "󰉿 ",
    Number       = "󰎠 ",
    Boolean      = "󰨙 ",
    Array        = "󰅪 ",
    Object       = "󰅩 ",
    Key          = "󰌋 ",
    Null         = "󰟢 ",
    EnumMember   = " ",
    Struct       = "󰠱 ",
    Event        = " ",
    Operator     = "󰆕 ",
    TypeParameter= "󰗴 ",
    Separator    = "  ",
  },
}

function M.create_keymap(client, bufnr)
  local map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  -- 核心功能映射
  map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "Peek Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("n", "gr", "<cmd>Lspsaga finder<CR>", "Find References")
  -- map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
  -- map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "Code Action")
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "Rename Symbol")
  map("n", "<leader>lf", function()
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
    vim.defer_fn(function()
      if vim.api.nvim_buf_get_option(bufnr, "modified") then
        vim.cmd("silent w")
      end
    end, 500)
  end, "Format buffer and save")

  -- 诊断导航
  map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
  map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")

  -- 动态切换 lspsaga winbar 路径显示
  map("n", "<leader>wp", function()
    local current = require("lspsaga").config.symbol_in_winbar.show_file
    require("lspsaga").setup({
      symbol_in_winbar = {
        show_file = not current,
        separator = M.icons.symbol.Separator,
      },
    })
    vim.notify("Path display: " .. (not current and "ON" or "OFF"), vim.log.levels.INFO)
  end, "Toggle path display")
end

return M
