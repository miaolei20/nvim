return {
  "echasnovski/mini.comment",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- 先加载上下文注释插件
    require("ts_context_commentstring").setup({})

    -- 正确配置 mini.comment
    require("mini.comment").setup({
      options = {
        custom_commentstring = function()
          -- 更安全的上下文注释获取方式
          local ctx_comment = require("ts_context_commentstring.internal").calculate_commentstring()
          return ctx_comment or vim.bo.commentstring
        end,
      },
      
      mappings = {
        -- 基础键位设置
        comment = "<C-_>",
        comment_line = "<C-_>",
        comment_visual = "<C-_>",
        textobject = "<C-_>",
      },
    })
}