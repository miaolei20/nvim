-- file: plugins/treesitter-context.lua
local M = {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      mode = "topline",        -- 更紧凑的显示模式
      max_lines = 2,           -- 减少显示行数
      multiline_threshold = 3, -- 更早触发多行检测
      separator = "▔",         -- 更清晰的视觉分隔符
      zindex = 45,             -- 提升显示层级
      trim_scope = "inner",    -- 精确上下文范围
      on_attach = function(bufnr)
        -- 增强快捷键系统
        vim.keymap.set("n", "<leader>ut", function()
          require("treesitter-context").toggle()
        end, { desc = "Toggle Context Window", buffer = bufnr })

        vim.keymap.set("n", "[c", function()
          require("treesitter-context").go_to_context()
        end, { desc = "Jump to Context", buffer = bufnr })
      end,
    },
    config = function(_, opts)
      -- 动态颜色适配
      local get_hl = function(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      -- 主题自适应配置
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

      -- 高级配置
      local context = require("treesitter-context")
      context.setup(vim.tbl_deep_extend("force", {
        patterns = {          -- 扩展支持的语言模式
          c = "function_definition",
          cpp = "function_definition",
          go = "function_declaration",
          lua = "function_definition",
          python = "function_definition",
          rust = "function_item",
          javascript = "function_declaration",
          typescript = "function_declaration",
          tsx = "function_declaration",
          ruby = "method_definition",
          java = "method_declaration"
        },
        throttle = true,      -- 启用防抖
        timeout = 80,         -- 刷新延迟（毫秒）
        scroll_speed = 50     -- 滚动同步速度
      }, opts))

      -- 自动命令优化
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("TSContextRefresh", {}),
        callback = function()
          if vim.bo.filetype ~= "" then
            context.update()
          end
        end
      })

      -- 文件类型例外列表
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "help", "NvimTree" },
        callback = function()
          context.close()
        end
      })
    end
  }
}

return M