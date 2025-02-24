-- file: plugins/todo-comments.lua
return {
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local colors = require("onedark.palette").dark -- 匹配你的主题颜色
      require("todo-comments").setup({
        keywords = {
          FIX = { icon = " ", color = "error" },      -- 红色高亮
          TODO = { icon = " ", color = "hint" },       -- 青色高亮
          HACK = { icon = " ", color = "warning" },    -- 黄色高亮
          WARN = { icon = " ", color = "warning" },    -- 黄色高亮
          PERF = { icon = "󰅒 ", color = "default" },     -- 默认高亮
          NOTE = { icon = "󰎠 ", color = "info" },       -- 蓝色高亮
        },
        colors = {
          error = { colors.red },       -- 自定义颜色（需与主题兼容）
          warning = { colors.yellow },
          info = { colors.blue },
          hint = { colors.cyan },
          default = { colors.purple },
        },
        highlight = {
          multiline = false,           -- 不高亮多行注释
          keyword = "bg",              -- 高亮模式：bg（背景）/fg（前景）
        },
        search = {
          pattern = [[\b(KEYWORDS)\b]], -- 匹配所有大写关键字
        },
      })

      -- 快捷键绑定
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
      vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
      vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })
    end
  }
}