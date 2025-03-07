return {
  "mbbill/undotree",
  lazy = true, -- 仅在调用时加载，提高启动速度
  cmd = "UndotreeToggle", -- 只有执行这个命令时才加载
  keys = {
    { "<leader>u", function()
        vim.opt.undofile = true -- 确保撤销文件已启用
        vim.cmd("UndotreeToggle")
        vim.cmd("UndotreeFocus") -- 自动聚焦窗口
      end,
      desc = "Toggle Undo Tree"
    },
  },
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1 -- 切换时自动聚焦
  end,
}
