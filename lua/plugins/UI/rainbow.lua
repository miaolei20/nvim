return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" }, -- 延迟加载
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- 依赖 Treesitter
    },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      -- 配置 rainbow-delimiters
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"], -- 默认全局策略
          vim = rainbow_delimiters.strategy["local"],   -- Vim 文件使用本地策略
        },
        query = {
          [""] = "rainbow-delimiters", -- 默认查询
          lua = "rainbow-delimiters",  -- Lua 专用查询
          javascript = "rainbow-parens", -- JS/TS 使用括号查询
          tsx = "rainbow-parens",
        },
        highlight = {
          -- 自定义高亮组，适配 OneDark 主题
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterGreen",
          "RainbowDelimiterCyan",
          "RainbowDelimiterViolet",
          "RainbowDelimiterOrange",
        },
      })

      -- 异步设置高亮颜色，适配 OneDark
      vim.schedule(function()
        local palette = require("onedark.palette").dark
        local colors = {
          RainbowDelimiterRed = { fg = palette.red },
          RainbowDelimiterYellow = { fg = palette.yellow },
          RainbowDelimiterBlue = { fg = palette.blue },
          RainbowDelimiterGreen = { fg = palette.green },
          RainbowDelimiterCyan = { fg = palette.cyan },
          RainbowDelimiterViolet = { fg = palette.purple },
          RainbowDelimiterOrange = { fg = palette.orange },
        }
        for group, hl in pairs(colors) do
          vim.api.nvim_set_hl(0, group, hl)
        end
      end)
    end,
  },
}