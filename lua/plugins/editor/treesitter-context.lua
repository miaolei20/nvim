return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      mode = "topline",
      max_lines = 2,
      multiline_threshold = 3,
      separator = "▔",
      zindex = 45,
      trim_scope = "inner",
      patterns = {
        c = "function_definition",
        cpp = "function_definition",
        go = "function_declaration",
        lua = "function_definition",
        python = { "function_definition", "class_definition" },
        rust = "function_item",
        javascript = "function_declaration",
        typescript = "function_declaration",
        tsx = "function_declaration",
        ruby = "method_definition",
        java = "method_declaration",
      },
      throttle = true,
      timeout = 80,
      scroll_speed = 50,
      update_events = { "CursorMoved", "BufEnter" },
    },
    config = function(_, opts)
      local context = require("treesitter-context")
      context.setup(opts)

      -- 简洁配置高亮组
      local highlights = {
        TreesitterContext = { bg = "#282c34", blend = 10 },
        TreesitterContextLineNumber = { fg = "#5c6370", italic = true },
        TreesitterContextSeparator = { fg = "#5c6370", bold = true },
      }
      for group, value in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, value)
      end

      -- 快捷键映射（静默且带描述）
      vim.keymap.set("n", "<leader>ut", context.toggle, { desc = "Toggle Context Window", silent = true })
      vim.keymap.set("n", "[c", context.go_to_context, { desc = "Jump to Context", silent = true })

      -- 针对特定文件类型禁用上下文显示
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "help", "NvimTree", "dashboard" },
        callback = function() context.disable() end,
      })
    end,
  },
}
