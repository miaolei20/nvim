-- file: plugins/gitsigns.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
      local set_hl = vim.api.nvim_set_hl
      -- 定义与 VSCode 类似的颜色，高亮组需要分别定义
      set_hl(0, "GitSignsAdd", { fg = "#81b88b", bg = "NONE" })
      set_hl(0, "GitSignsAddLn", { link = "GitSignsAdd" })
      set_hl(0, "GitSignsAddNr", { link = "GitSignsAdd" })

      set_hl(0, "GitSignsChange", { fg = "#e2c08d", bg = "NONE" })
      set_hl(0, "GitSignsChangeLn", { link = "GitSignsChange" })
      set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })

      set_hl(0, "GitSignsDelete", { fg = "#c74e39", bg = "NONE" })
      set_hl(0, "GitSignsDeleteLn", { link = "GitSignsDelete" })
      set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })

      set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
      set_hl(0, "GitSignsTopdeleteLn", { link = "GitSignsDelete" })
      set_hl(0, "GitSignsTopdeleteNr", { link = "GitSignsDelete" })

      set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
      set_hl(0, "GitSignsChangedeleteLn", { link = "GitSignsChange" })
      set_hl(0, "GitSignsChangedeleteNr", { link = "GitSignsChange" })

      require("gitsigns").setup({
        -- 只需指定符号文本，gitsigns 会自动使用上面定义的高亮组
        signs      = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        signcolumn = true,  -- 启用 signcolumn
        numhl      = false, -- 关闭数字高亮
        linehl     = false, -- 关闭整行高亮
        word_diff  = false, -- 关闭单词级别 diff
      })
    end,
  },
}
