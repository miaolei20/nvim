-- file: plugins/onedark.lua
return {
  {
    "navarasu/onedark.nvim",  -- 主插件
    priority = 1000,  -- 插件加载优先级
    config = function()
      local colors = require("onedark.palette").dark  -- 获取配色方案
      require("onedark").setup({
        style = "dark",  -- 主题风格
        transparent = false,  -- 不启用透明背景
        term_colors = true,  -- 启用终端颜色
        highlights = {
          Comment = { fg = "#5c6370", italic = true },  -- 增强注释颜色
          BufferLineBackground = { bg = "#21252b" },  -- 调整标签栏背景颜色
          BufferLineBufferSelected = { bg = "#282c34" },  -- 匹配编辑器背景颜色
          -- 增强缩进线颜色定义
          IblIndent1 = { fg = colors.bg2 },
          IblIndent2 = { fg = colors.bg3 },
          IblScope = { fg = colors.cyan },
          -- 匹配括号颜色
          MatchParen = { bg = colors.bg2, underline = true }
        }
      })
      require("onedark").load()  -- 加载主题
    end
  }
}