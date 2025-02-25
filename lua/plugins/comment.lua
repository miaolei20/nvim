return {
  "numToStr/Comment.nvim",                -- 主插件  -- 主插件
  event = { "BufReadPre", "BufNewFile" }, -- 在读取缓冲区或新建文件时加载插件  -- 在读取缓冲区或新建文件时加载插件
  config = function()
    -- 先加载上下文注释插件（重要!）
    require('ts_context_commentstring').setup({})

    -- 主插件配置
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(), -- 设置预处理钩子  -- 设置预处理钩子

      toggler = {
        line = '<C-_>',      -- 常规模式 Ctrl+/ 单行注释
        block = '<leader>b/' -- 建议的块注释快捷键
      },
      opleader = {
        line = '<C-_>', -- 可视模式 Ctrl+/ 多行注释
        block = '<leader>b/'
      },

      -- 增强配置
      mappings = {
        basic = true,    -- 启用默认基础映射 (gcc/gbc)
        extra = true,    -- 启用额外操作 (如 gco 下方插入注释)
        extended = false -- 禁用增强模式以免冲突
      },

      -- 视觉优化
      padding = true, -- 注释间保留空格
      sticky = true   -- 注释后保持光标位置
    })

    -- 终端适配映射（部分终端需要特殊处理）
    vim.keymap.set({ 'n', 'v' }, '<C-/>', function()
      require('Comment.api').toggle.linewise.current()
    end, { desc = "Toggle comment" })

    -- 可选：可视模式自动切块注释
    vim.keymap.set('x', '<C-/>', function()
      require('Comment.api').toggle.linewise(vim.fn.visualmode())
    end, { desc = "Toggle visual comment" })
  end,
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", -- 上下文注释插件  -- 上下文注释插件
  }
}

