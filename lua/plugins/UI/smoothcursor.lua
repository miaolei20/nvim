-- 在你的 Lazy 插件配置文件中添加以下配置（例如：plugins.lua）
return {
  {
    "gen740/SmoothCursor.nvim",
    event = { "CursorMoved", "ModeChanged" },
    config = function()
      local default_config = {
        cursor = "", -- 默认光标（推荐使用 Nerd Font 图标）
        texthl = "SmoothCursor", -- 高亮组
        linehl = nil, -- 行高亮（可选）
        type = "default", -- 光标类型：default, exp, matrix
        fancy = {
          enable = true, -- 启用高级特效
          head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
          body = {
            { cursor = "", texthl = "SmoothCursor" },
            { cursor = "", texthl = "SmoothCursorFade1" },
            { cursor = "", texthl = "SmoothCursorFade2" },
            { cursor = "", texthl = "SmoothCursorFade3" },
          },
          tail = { cursor = "▷", texthl = "SmoothCursor" },
        },
        speed = 25, -- 动画速度（单位：ms，值越小越快）
        intervals = 35, -- 刷新间隔（单位：帧）
        priority = 10, -- 插件优先级
        timeout = 3000, -- 无操作超时
        threshold = 3, -- 移动阈值（像素）
        disable_float_win = true, -- 禁用浮动窗口
        enabled = {
          mode = true, -- 模式变化处理
          scroll = true -- 滚动处理
        }
      }

      -- 初始化插件
      require("smoothcursor").setup(default_config)

      -- 自动命令：根据模式改变光标样式
      vim.api.nvim_create_autocmd({ "ModeChanged" }, {
        callback = function()
          local current_mode = vim.fn.mode()
          if current_mode == "n" then
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#8fff6d" }) -- 正常模式颜色
          elseif current_mode == "i" then
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#56b6c2" }) -- 插入模式颜色
          elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#c678dd" }) -- 可视模式颜色
          end
        end
      })

      -- 可选：添加切换命令
      vim.api.nvim_create_user_command("SmoothCursorToggle", function()
        require("smoothcursor").toggle()
      end, {})
    end
  }
}