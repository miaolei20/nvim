-- ~/.config/nvim/lua/plugins/smoothcursor.lua
return {
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function()
      -- 自定义高亮组
      vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#89B4FA" })
      vim.api.nvim_set_hl(0, "SmoothCursorRed", { fg = "#F38BA8" })
      vim.api.nvim_set_hl(0, "SmoothCursorOrange", { fg = "#FAB387" })
      vim.api.nvim_set_hl(0, "SmoothCursorYellow", { fg = "#F9E2AF" })
      vim.api.nvim_set_hl(0, "SmoothCursorGreen", { fg = "#A6E3A1" })
      vim.api.nvim_set_hl(0, "SmoothCursorAqua", { fg = "#94E2D5" })
      vim.api.nvim_set_hl(0, "SmoothCursorBlue", { fg = "#89B4FA" })
      vim.api.nvim_set_hl(0, "SmoothCursorPurple", { fg = "#CBA6F7" })

      require("smoothcursor").setup({
        cursor = " ",  -- 默认光标
        texthl = "SmoothCursor",
        type = "default",  -- 使用默认动画类型
        fancy = {
          enable = true,
          head = { 
            cursor = "➜", 
            texthl = "SmoothCursorBlue",
            length = 4  -- 正确的参数位置
          },
          body = {
            { cursor = "", texthl = "SmoothCursorPurple" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = "•", texthl = "SmoothCursorGreen" },
            { cursor = "∙", texthl = "SmoothCursorYellow" }
          }
        },
        intervals = 33,
        disable_float_win = true,
        threshold = 3,
        speed = 25,
        disabled_filetypes = {
          "NvimTree", "TelescopePrompt", "dashboard", "alpha"
        }
      })

      -- 模式切换处理（简化版）
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*",
        callback = function()
          vim.opt.guicursor = vim.fn.mode() == "i" 
              and "n-v-c-sm:block,i-ci-ve:ver25" 
              or ""
        end
      })
    end
  }
}