-- file: plugins/lspsaga.lua
return {
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      local colors = require("onedark.palette").dark

      require("lspsaga").setup({
        ui = {
          title = true,
          border = "rounded", -- 圆角边框
          colors = {
            normal_bg = colors.bg1, -- 背景色
            title = colors.cyan -- 标题颜色
          }
        },
        symbol_in_winbar = { enable = false }, -- 禁用 winbar 符号
        lightbulb = { enable = false }, -- 禁用灯泡图标
        outline = { auto_close = true }, -- 自动关闭大纲
        diagnostic = { show_code_action = true }, -- 显示代码动作
        code_action = { keys = { quit = "<ESC>" } } -- 退出键
      })

      -- 快捷键
      vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { desc = "LSP Finder" })
      vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })
    end
  }
}