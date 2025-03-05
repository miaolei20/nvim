return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      -- 安全加载 todo-comments
      local ok, todo_comments = pcall(require, "todo-comments")
      if not ok then
        vim.notify("todo-comments.nvim not found!", vim.log.levels.ERROR)
        return
      end

      -- 安全加载 telescope
      local telescope_ok, telescope = pcall(require, "telescope")
      if not telescope_ok then
        vim.notify("telescope.nvim not found!", vim.log.levels.ERROR)
        return
     end

      -- 加载 telescope 扩展
      pcall(telescope.load_extension, "todo-comments") -- 关键修复点

      -- 动态颜色适配函数
      local function get_hl_color(group, attr)
        local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
        return color ~= "" and color or nil
      end

      -- 关键字配置
      local keywords = {
        FIX = { icon = " ", color = "error" },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning" },
        PERF = { icon = "󰅒 ", color = "default" },
        NOTE = { icon = "󰎠 ", color = "hint" }
      }

      -- 颜色配置
      local colors = {
        error = get_hl_color("DiagnosticError", "fg") or "#FF0000",
        warning = get_hl_color("DiagnosticWarn", "fg") or "#FFFF00",
        info = get_hl_color("DiagnosticInfo", "fg") or "#00FFFF",
        hint = get_hl_color("DiagnosticHint", "fg") or "#00FF00",
        default = get_hl_color("Comment", "fg") or "#888888"
      }

      -- 核心配置
      todo_comments.setup({
        keywords = keywords,
        colors = colors,
        highlight = {
          multiline = false,
          keyword = "bg",
          after = ""
        },
        search = {
          pattern = [[\b(KEYWORDS)\b]],
          command = "rg"
        }
      })

      -- 修正后的快捷键配置
      vim.keymap.set("n", "<leader>ft", function()
        -- 使用内置的 Telescope 命令而非直接调用扩展
        vim.cmd("TodoTelescope")
      end, { desc = "Find TODOs" })

      vim.keymap.set("n", "]t", function()
        todo_comments.jump_next()
      end, { desc = "Next TODO" })

      vim.keymap.set("n", "[t", function()
        todo_comments.jump_prev()
      end, { desc = "Previous TODO" })
    end
  }
}

