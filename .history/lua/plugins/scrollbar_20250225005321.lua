-- file: plugins/scrollbar.lua
return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    dependencies = { "lewis6991/gitsigns.nvim" },  -- 新增 Git 集成依赖
    config = function()
      local colors = require("onedark.palette").dark
      local scrollbar = require("scrollbar")

      -- 动态颜色适配函数
      local function blend_color(base, alpha)
        return string.format("#%06x", (tonumber(base:sub(2), 16) + (alpha * 0x1000000))
      end,

      scrollbar.setup({
        handle = {
          color = blend_color(colors.gray, 0.4),  -- 动态透明度混合
          blend = 30,
          highlight = "CursorColumn",            -- 跟随光标列高亮
          hide_if_all_visible = true,            -- 全屏时自动隐藏
        },
        marks = {
          Search = { color = colors.yellow, priority = 100 },
          Error = { color = colors.red, priority = 90 },
          Warn = { color = colors.orange, priority = 80 },
          Info = { color = colors.blue, priority = 70 },
          Hint = { color = colors.cyan, priority = 60 },
          GitAdd = { color = colors.green, symbol = "▎", priority = 50 },      -- Git 新增
          GitChange = { color = colors.yellow, symbol = "▎", priority = 40 },  -- Git 修改
          GitDelete = { color = colors.red, symbol = "▁", priority = 30 },     -- Git 删除
          Cursor = { color = colors.purple, symbol = "▌", priority = 200 },    -- 光标位置
        },
        excluded_filetypes = {
          "NvimTree", "TelescopePrompt", "dashboard", "alpha", "lazy"  -- 扩展排除列表
        },
        handlers = {
          gitsigns = true,  -- 启用 Git 标记集成
          search = true,     -- 启用搜索高亮
          diagnostic = true, -- 启用诊断标记
          cursor = true      -- 显示光标位置
        },
        throttle_time = 100,  -- 滚动事件节流时间（毫秒）
        fold = 1,             -- 折叠区域标记层级
        fade_in_delay = 150,  -- 淡入动画延迟
        fade_out_delay = 750  -- 淡出动画延迟
      })

      -- 自动命令：在特定模式下调整滚动条
      vim.api.nvim_create_autocmd({ "ModeChanged" }, {
        pattern = "*",
        callback = function()
          local is_insert_mode = vim.api.nvim_get_mode().mode:match("i")
          scrollbar.config.handle.blend = is_insert_mode and 50 or 30
          scrollbar.refresh()
        end
      })

      -- 快捷键：手动刷新滚动条
      vim.keymap.set("n", "<leader>sr", function()
        scrollbar.refresh()
      end, { desc = "Refresh Scrollbar" })
    end
  }
}