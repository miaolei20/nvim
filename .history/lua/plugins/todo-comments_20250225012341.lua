-- file: plugins/todo-comments.lua
return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },  -- 扩展触发事件
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"  -- 深度集成 Telescope
    },
    config = function()
      -- 安全加载插件
      local ok, todo_comments = pcall(require, "todo-comments")
      if not ok then
        vim.notify("todo-comments.nvim not found!", vim.log.levels.ERROR)
        return
      end

      -- 动态获取颜色（适配任意主题）
      local function get_hl_color(group, attr)
        local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
        return color ~= "" and color or nil
      end

      -- 增强关键字配置
      local keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "ISSUE" },  -- 别名支持
          signs = false  -- 禁用 gutter 标记
        },
        TODO = { 
          icon = " ",
          color = "info",
          alt = { "TIP" }
        },
        HACK = { 
          icon = " ",
          color = "warning",
          alt = { "TRICK", "WORKAROUND" }
        },
        WARN = {
          icon = " ",
          color = "warning",
          alt = { "WARNING", "CAUTION" }
        },
        PERF = {
          icon = "󰅒 ",
          color = "default",
          alt = { "OPTIMIZE", "PERFORMANCE" }
        },
        NOTE = {
          icon = "󰎠 ",
          color = "hint",
          alt = { "INFO", "NOTICE" },
          highlight = { "fg", "bg" }  -- 双样式高亮
        },
        TEST = {
          icon = "󰙨 ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" }
        }
      }

      -- 扩展颜色系统
      local colors = {
        error = get_hl_color("DiagnosticError", "fg"),
        warning = get_hl_color("DiagnosticWarn", "fg"),
        info = get_hl_color("DiagnosticInfo", "fg"),
        hint = get_hl_color("DiagnosticHint", "fg"),
        default = get_hl_color("Comment", "fg"),
        test = "#FFA500"  -- 自定义颜色
      }

      todo_comments.setup({
        keywords = keywords,
        colors = colors,
        highlight = {
          multiline = true,  -- 启用多行注释高亮
          multiline_pattern = "^.",  -- 多行注释起始符
          multiline_context = 10,  -- 上下文保留行数
          before = "",  -- 高亮前缀
          keyword = "wide_bg",  -- 增强高亮模式
          after = "fg",  -- 后缀高亮
          comments_only = false,  -- 匹配非注释区域
          max_line_len = 400,  -- 长行优化
          exclude = {}  -- 排除文件类型
        },
        search = {
          pattern = [[\b(KEYWORDS)(\([^)]+\))?:]],  -- 支持带括号的注释
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",
            "--glob=!.git/"
          },
          command = "rg"  -- 使用 ripgrep
        },
        merge_keywords = true,  -- 合并相同类型注释
        gui_style = {
          fg = "NONE",  -- 禁用 fg 颜色
          bg = "BOLD"   -- 加粗背景
        }
      })

      -- 增强快捷键系统
      local map = vim.keymap.set
      map("n", "<leader>ft", function()
        require("telescope").extensions.todo_comments.todo()
      end, { desc = "Find TODOs (Telescope)" })

      map("n", "]t", function()
        todo_comments.jump_next({ keywords = { "FIX", "HACK", "ERROR" } })  -- 仅跳转重要类型
      end, { desc = "Next critical TODO" })

      map("n", "[t", function()
        todo_comments.jump_prev({ keywords = { "FIX", "HACK", "ERROR" } })
      end, { desc = "Previous critical TODO" })

      -- 添加快速修复快捷键
      map("n", "<leader>fx", function()
        local todo = todo_comments.get_todo()
        if todo then
          vim.cmd("normal! ci"..todo.keyword)
        end
      end, { desc = "Quick fix TODO" })

      -- 自动高亮当前 TODO
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        callback = function()
          todo_comments.highlight_current_todo()
        end
      })
    end
  }
}