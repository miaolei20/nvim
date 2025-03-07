return {
  {
    "mbbill/undotree",
    keys = { "<leader>u" },
    config = function()
      -- 设置全局变量，配置 undotree 行为
      vim.g.undotree_SetFocusWhenToggle = 1  -- 切换时自动聚焦
      vim.g.undotree_WindowLayout        = 2  -- 布局风格: 2 = 垂直分割
      vim.g.undotree_SplitWidth          = 40 -- 窗口宽度
      vim.g.undotree_DiffpanelHeight     = 15 -- Diff 面板高度

      -- 主题适配：设置 Undotree 相关高亮
      vim.api.nvim_set_hl(0, "UndotreeSavedBig", { fg = "#98c379", bold = true })
      vim.api.nvim_set_hl(0, "UndotreeCurrent",  { fg = "#e5c07b" })

      -- 创建自动命令组，避免重复创建
      vim.api.nvim_create_augroup("UndotreeAutoHide", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group   = "UndotreeAutoHide",
        pattern = "*",
        callback = function()
          -- 检查 UndotreeHide 命令是否存在（返回 2 表示存在）
          if vim.fn.exists(":UndotreeHide") == 2 then
            vim.cmd("UndotreeHide") -- 保存时自动隐藏 undotree
          end
        end,
      })

      -- 快捷键映射：<leader>uu 切换 undotree
      vim.keymap.set("n", "<leader>uu", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
    end,
  },
}

