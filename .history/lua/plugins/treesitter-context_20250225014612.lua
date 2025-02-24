-- file: plugins/treesitter-context.lua
local colors = require("onedark.palette").dark

return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- 安全加载检查
      local ok, context = pcall(require, "treesitter-context")
      if not ok then
        vim.notify("treesitter-context not found!", vim.log.levels.ERROR)
        return
      end

      -- 动态颜色适配
      local function get_hl_color(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      -- 核心配置
      context.setup({
        enable = true,
        max_lines = 4,  -- 显示上下文行数
        min_window_height = 12,  -- 最小窗口高度
        line_numbers = true,
        multiline_threshold = 5,  -- 多行上下文阈值
        mode = "topline",  -- 更紧凑的显示模式
        separator = "▔",  -- 使用更细的分隔线
        zindex = 45,  -- 确保在浮动窗口之上
        trim_scope = "inner",  -- 更精确的作用域裁剪

        -- 深度主题适配
        on_attach = function(bufnr)
          -- 增强快捷键系统
          vim.keymap.set("n", "[c", function()
            context.go_to_context()
          end, { desc = "Jump to context", buffer = bufnr })

          vim.keymap.set("n", "<leader>uc", function()
            context.toggle()
          end, { desc = "Toggle context window", buffer = bufnr })
        end
      })

      -- 完整高亮配置 (onedark 风格)
      vim.api.nvim_set_hl(0, "TreesitterContext", {
        bg = colors.bg1,
        fg = colors.fg,
        bold = true
      })
      
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", {
        fg = colors.gray,
        bg = colors.bg1,
        italic = true
      })
      
      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", {
        fg = colors.purple,
        bg = colors.bg1,
        bold = true
      })
      
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
        sp = colors.cyan,
        bg = colors.bg1,
        underline = true
      })

      -- 自动命令优化
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
        callback = function()
          if vim.fn.pumvisible() == 0 then  -- 排除补全菜单
            context.update()
          end
        end
      })

      -- 文件类型例外列表
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "help", "NvimTree" },
        callback = function()
          context.disable()
        end
      })
    end
  }
}