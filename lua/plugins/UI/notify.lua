return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "static",           -- 使用静态动画效果，减少资源消耗
        timeout = 200,               -- 消息显示时长（毫秒）
        max_width = 60,              -- 最大消息宽度（字符）
        background_colour = "#000000",-- 背景颜色
        fps = 30,                    -- 限制帧率，降低性能开销
        render = "minimal",          -- 使用简洁的渲染方式
        icons = {
          ERROR = " ",
          WARN  = " ",
          INFO  = " ",
          DEBUG = " ",
        },
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { border = "rounded" })  -- 边框样式
        end,
      })
      vim.notify = notify
    end
  }
}
