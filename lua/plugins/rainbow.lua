-- file: plugins/rainbow.lua
return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    dependencies = { "navarasu/onedark.nvim" },
    config = function()
      -- 等待主题加载完成
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          local colors = require("onedark.palette").dark

          -- 定义彩虹颜色（适配 OneDark 主题）
          local rainbow_colors = {
            red = colors.red,
            yellow = colors.yellow,
            blue = colors.blue,
            orange = colors.orange,
            green = colors.green,
            violet = colors.purple,
            cyan = colors.cyan
          }

          -- 创建高亮组
          for level, color in pairs(rainbow_colors) do
            local hlgroup = "RainbowDelimiter" .. level:sub(1,1):upper() .. level:sub(2)
            vim.api.nvim_set_hl(0, hlgroup, {
              fg = color,
              bold = level == "red",
              nocombine = true
            })
          end

          -- 配置插件
          require("rainbow-delimiters.setup")({
            highlight = {
              "RainbowDelimiterRed",
              "RainbowDelimiterYellow",
              "RainbowDelimiterBlue",
              "RainbowDelimiterOrange",
              "RainbowDelimiterGreen",
              "RainbowDelimiterViolet",
              "RainbowDelimiterCyan"
            },
            strategy = {
              [""] = require("rainbow-delimiters").strategy["global"],
              commonlisp = require("rainbow-delimiters").strategy["local"]
            },
            query = {
              [""] = "rainbow-delimiters",
              latex = "rainbow-blocks"
            },
            priority = 1100
          })
        end
      })
    end
  }
}