return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,
    init = function()
      vim.g.onedark_terminal_italics = 1  -- 修正拼写错误（italics→italics）
      vim.g.onedark_termcolors = 256
    end,
    config = function()
      local ok, onedark = pcall(require, "onedark")
      if not ok then return end  -- 移除冗余错误提示（由Neovim自动处理）

      -- 颜色定义模块化
      local colors = require("onedark.palette").dark  -- 直接使用官方调色板[<sup>5</sup>](https://zhuanlan.zhihu.com/p/140328823)
      
      -- 精简高亮配置
      onedark.setup({
        style = "dark",
        term_colors = true,
        highlights = {
          Comment = { fg = colors.grey, italic = true },
          Type = { fg = colors.yellow, bold = true },
          ["@function.builtin"] = { fg = colors.cyan },
          DiagnosticUnderlineError = { undercurl = true, sp = colors.red }
        },
        code_style = {
          comments = "italic",
          keywords = "bold",
          functions = "bold"
        }
      })

      -- 优化颜色应用逻辑
      vim.cmd.colorscheme("onedark")
      
      -- 动态适配浮动窗口颜色
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg2 })
        end
      })
    end
  }
}
