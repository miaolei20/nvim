-- file: plugins/trouble.lua
return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = function()
      require("trouble").setup({
        position = "bottom", -- 显示位置
        height = 15, -- 高度
        icons = true, -- 显示图标
        mode = "document_diagnostics", -- 默认模式
        auto_close = true, -- 自动关闭
        use_diagnostic_signs = true -- 使用诊断符号
      })

      -- 快捷键
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", { desc = "Toggle Trouble" })
    end
  }
}