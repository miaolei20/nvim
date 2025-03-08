return {
  "numToStr/Comment.nvim", -- 主插件：管理注释
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", -- 上下文注释支持
  },
  config = function()
    -- 配置 ts_context_commentstring 插件以支持上下文敏感注释
    require("ts_context_commentstring").setup()
    local ts_comment = require("ts_context_commentstring.integrations.comment_nvim")

    -- 主插件配置
    require("Comment").setup({
      pre_hook = ts_comment.create_pre_hook(), -- 根据光标所在位置自动调整注释风格

      toggler = {
        line = "<C-_>",      -- 普通模式：Ctrl+/ 单行注释
        block = "<leader>b/" -- 普通模式：块注释快捷键
      },
      opleader = {
        line = "<C-_>",      -- 可视模式：Ctrl+/ 多行注释
        block = "<leader>b/"
      },

      mappings = {
        basic = true,    -- 启用默认基础映射 (如 gcc/gbc)
        extra = true,    -- 启用额外映射 (如 gco 插入注释)
        extended = false -- 禁用扩展映射，避免冲突
      },

      padding = true, -- 注释符号与代码之间保留空格
      sticky = true   -- 注释后保持光标原位
    })

    -- 终端兼容键映射（确保在不同终端中都能正常使用）
    vim.keymap.set({ "n", "v" }, "<C-/>", function()
      require("Comment.api").toggle.linewise.current()
    end, { desc = "Toggle linewise comment" })

    vim.keymap.set("x", "<C-/>", function()
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end, { desc = "Toggle visual comment" })
  end,
}
