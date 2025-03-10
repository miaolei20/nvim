return {
  {
    "echasnovski/mini.nvim",
    event = "VimEnter",
    config = function()
      -- 核心通知配置
      require("mini.notify").setup({
        content = {
          -- 样式定制
          border_style = "rounded",
          background_color = "#000000",
          delay = 200,          -- 消息显示时长（毫秒）
          max_width = 60,       -- 最大消息宽度（字符）
          min_width = 30,       -- 最小消息宽度（字符）
        },
        level = {
          -- 分级配置
          icons = {
            error = " ",
            warn  = " ",
            info  = " ",
            debug = " ",
          },
          colors = {
            error = "#db4b4b",
            warn  = "#e0af68",
            info  = "#0db9d7",
            debug = "#bb9af7",
          }
        },
        window = {
          blend = 30,           -- 透明度
          winblend = 30,        -- 窗口混合模式
          zindex = 100,         -- 显示层级
        }
      })

      -- 接管原生通知系统
      vim.notify = require("mini.notify").make_notify()
    end
  }
}