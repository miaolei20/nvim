local colors = require("onedark.palette").dark

return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      mode = "cursor",
      max_lines = 3,
      -- 主题适配配置
      multiline_threshold = 5,
      separator = "─",
      zindex = 20,
      on_attach = function(bufnr)
        -- 绑定自定义切换快捷键
        vim.keymap.set("n", "<leader>ut", function()
          require("treesitter-context").toggle()
        end, { desc = "Toggle Treesitter Context" })
      end,
    },
    config = function(_, opts)
      -- 上下文窗口颜色配置
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = colors.bg1 })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = colors.gray })
      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = colors.purple })

      require("treesitter-context").setup(opts)
    end
  }
}
