-- file: plugins/icons.lua
return {
  {
    "nvim-tree/nvim-web-devicons",                   -- 主插件
    event = "VeryLazy",                              -- 延迟加载插件
    config = function()
      local colors = require("onedark.palette").dark -- 获取配色方案

      require("nvim-web-devicons").setup({
        override = {
          -- 使用主题色系重构颜色配置
          c = { icon = "󰙱", color = colors.blue, name = "C" }, -- C 文件图标
          cpp = { icon = "󰙲", color = colors.blue, name = "Cpp" }, -- C++ 文件图标
          py = { icon = "", color = colors.yellow, name = "Python" }, -- Python 文件图标
          lua = { icon = "", color = colors.cyan, name = "Lua" }, -- Lua 文件图标
          java = { icon = "", color = colors.red, name = "Java" }, -- Java 文件图标
          rs = { icon = "", color = colors.orange, name = "Rust" }, -- Rust 文件图标
          md = { icon = "", color = colors.purple, name = "Markdown" }, -- Markdown 文件图标
          js = { icon = "", color = colors.yellow, name = "JavaScript" }, -- JavaScript 文件图标
          ts = { icon = "", color = colors.blue, name = "TypeScript" }, -- TypeScript 文件图标
          html = { icon = "", color = colors.orange, name = "HTML" }, -- HTML 文件图标
          css = { icon = "", color = colors.blue, name = "CSS" }, -- CSS 文件图标
          json = { icon = "", color = colors.yellow, name = "JSON" }, -- JSON 文件图标
          lock = { icon = "", color = colors.red }, -- 锁文件图标
          txt = { icon = "", color = colors.green } -- 文本文件图标
        },
        default = false -- 禁用默认图标颜色
      })
    end
  }
}

