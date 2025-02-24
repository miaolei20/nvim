-- file: plugins/treesitter-context.lua
local M = {
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
      on_attach = function(bufnr)
        -- 增强快捷键系统
        vim.keymap.set("n", "<leader>ut", function()
          require("treesitter-context").toggle()
        end, { 
          desc = "Toggle Context Window", 
          buffer = bufnr,
          silent = true
        })

        vim.keymap.set("n", "[c", function()
          require("treesitter-context").go_to_context()
        end, { 
          desc = "Jump to Context", 
          buffer = bufnr,
          silent = true
        })
      end,
    },
    config = function(_, opts)
      -- 安全加载检查
      local ok, context = pcall(require, "treesitter-context")
      if not ok then
        vim.notify("treesitter-context not found!", vim.log.levels.ERROR)
        return
      end

      -- 动态颜色适配
      local get_hl = function(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      vim.api.nvim_set_hl(0, "TreesitterContext", {
        bg = get_hl("Normal", "bg") ~= "" and get_hl("Normal", "bg") or "#282c34",
        blend = 10
      })

      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
        fg = get_hl("LineNr", "fg") ~= "" and get_hl("LineNr", "fg") or "#5c6370",
        italic = true
      })

      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", {
        fg = get_hl("Comment", "fg") ~= "" and get_hl("Comment", "fg") or "#5c6370",
        bold = true
      })

      -- 核心配置（使用最新 API）
      context.setup(vim.tbl_deep_extend("force", {
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
          java = "method_declaration"
        },
        throttle = true,
        timeout = 80,
        scroll_speed = 50,
        -- 修复的自动刷新逻辑
        update_events = { "CursorMoved", "BufEnter" }
      }, opts))

      -- 安全的自动命令配置
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "help", "NvimTree", "dashboard" },
        group = vim.api.nvim_create_augroup("TSContextDisable", {}),
        callback = function()
          context.disable()
        end
      })

      -- 初始化后自动启用
      vim.defer_fn(function()
        if not context.enabled then
          context.enable()
        end
      end, 500)
    end
  }
}

return M