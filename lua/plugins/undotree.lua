-- file: plugins/undotree.lua
return {
  {
    "mbbill/undotree",
    keys = { "<leader>u" },                 -- 快捷键
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1 -- 切换时自动聚焦
      vim.g.undotree_WindowLayout = 2       -- 布局风格: 2=垂直分割
      vim.g.undotree_SplitWidth = 40        -- 窗口宽度
      vim.g.undotree_DiffpanelHeight = 15   -- Diff 面板高度

      -- 主题适配
      vim.api.nvim_set_hl(0, "UndotreeSavedBig", { fg = "#98c379", bold = true }) -- 绿色高亮保存点
      vim.api.nvim_set_hl(0, "UndotreeCurrent", { fg = "#e5c07b" })               -- 黄色当前状态
      -- 在 undotree.lua 中添加自动命令
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*",
        callback = function()
          if vim.fn.exists(":UndotreeHide") > 0 then
            vim.cmd("UndotreeHide") -- 保存时自动隐藏
          end
        end
      })
      -- 快捷键映射
      vim.keymap.set("n", "<leader>uu", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
    end
  }
}
