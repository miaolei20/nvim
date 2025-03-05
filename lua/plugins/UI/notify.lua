return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    timeout = 2000,                -- 通知显示时间（毫秒）
    max_width = 80,                -- 通知最大宽度
    stages = "slide",              -- 显示动画效果
    position = "bottom_right",     -- 通知位置
    background_colour = "#1e222a", -- 通知背景色
    icons = {                      -- 各种类型通知的图标
      ERROR = "",
      WARN  = "",
      INFO  = "",
      DEBUG = "",
      TRACE = "✎",
    },
    render = "wrapped-compact", -- 通知样式
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
