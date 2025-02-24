-- file: plugins/todo-comments.lua
return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      -- 安全加载检查
      local ok, todo_comments = pcall(require, "todo-comments")
      if not ok then
        vim.notify("todo-comments.nvim not found!", vim.log.levels.ERROR)
        return
      end

      -- 动态颜色适配函数
      local function get_hl_color(group, attr)
        local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
        return color ~= "" and color or nil
      end

      -- 扩展关键字配置
      local keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "ISSUE" },
          signs = false
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
          highlight = { "fg", "bg" }
        },
        TEST = {
          icon = "󰙨 ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" }
        }
      }

      -- 颜色配置系统
      local colors = {
        error = get_hl_color("DiagnosticError", "fg") or "#FF0000",
        warning = get_hl_color("DiagnosticWarn", "fg") or "#FFFF00",
        info = get_hl_color("DiagnosticInfo", "fg") or "#00FFFF",
        hint = get_hl_color("DiagnosticHint", "fg") or "#00FF00",
        default = get_hl_color("Comment", "fg") or "#888888",
        test = "#FFA500"
      }

      -- 核心配置
      todo_comments.setup({
        keywords = keywords,
        colors = colors,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide_bg",
          after = "fg",
          comments_only = false,
          max_line_len = 400,
          exclude = {}
        },
        search = {
          pattern = [[\b(KEYWORDS)(\([^)]+\))?:]],
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",
            "--glob=!.git/"
          },
          command = "rg"
        },
        merge_keywords = true,
        gui_style = {
          fg = "NONE",
          bg = "BOLD"
        }
      })

      -- 快捷键映射
      vim.keymap.set("n", "<leader>ft", function()
        require("telescope").extensions.todo_comments.todo()
      end, { desc = "Find TODOs (Telescope)" })

      vim.keymap.set("n", "]t", function()
        todo_comments.jump_next()
      end, { desc = "Next TODO" })

      vim.keymap.set("n", "[t", function()
        todo_comments.jump_prev()
      end, { desc = "Previous TODO" })

      -- 增强高亮配置（替代方案）
      vim.api.nvim_set_hl(0, "TodoFgFIX", { fg = colors.error, bold = true, underline = true })
      vim.api.nvim_set_hl(0, "TodoBgFIX", { bg = colors.error, fg = "#FFFFFF", italic = true })
      
      -- 安全自动命令：保存时刷新
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*",
        callback = function()
          if package.loaded["todo-comments"] then
            require("todo-comments").search.reset()
          end
        end
      })
    end
  }
}