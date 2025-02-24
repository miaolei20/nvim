-- file: plugins/scrollbar.lua
return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      local colors = require("onedark.palette").dark

      require("scrollbar").setup({
        handle = {
          color = colors.gray,   -- 滚动条颜色
          blend = 30,           -- 透明度 (0-100)
          hide_if_all_visible = true, -- 全屏时自动隐藏
        },
        marks = {
          Search = { color = colors.yellow },
          Error = { color = colors.red },
          Warn = { color = colors.orange },
          Info = { color = colors.blue },
          Hint = { color = colors.cyan },
          Cursor = { color = colors.purple } -- 光标位置标记
        },
        excluded_filetypes = { 
          "NvimTree", 
          "TelescopePrompt", 
          "dashboard", 
          "alpha" 
        },
        handlers = {
          cursor = true,    -- 启用光标标记
          search = true,     -- 启用搜索高亮
          diagnostic = true  -- 启用诊断标记
        },
        throttle_time = 100  -- 滚动事件节流时间 (ms)
      })

      -- 可选：手动刷新快捷键
      vim.keymap.set("n", "<leader>sr", function()
        require("scrollbar").refresh()
      end, { desc = "Refresh Scrollbar" })
    end
  }
}