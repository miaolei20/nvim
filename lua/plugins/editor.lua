return {
  {
    "mg979/vim-visual-multi", -- 插件名称
    event = "VeryLazy", -- 懒加载插件
    init = function()
      -- 多光标插件配置
      vim.g.VM_theme = "purple" -- 主题颜色
      vim.g.VM_maps = {
        -- 禁用默认键位映射
        ["Find Under"] = "",
        ["Find Subword Under"] = "",
      }

      -- 自定义键位映射
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- 进入多光标模式
      map("n", "<C-n>", "<Plug>(VM-Find-Under)", opts)             -- 查找当前单词并创建光标
      map("n", "<Leader>n", "<Plug>(VM-Find-Subword-Under)", opts) -- 查找当前子单词并创建光标

      -- 多光标模式下操作
      map("x", "<C-n>", "<Plug>(VM-Find-Under)", opts)             -- 可视模式下创建多光标
      map("x", "<Leader>n", "<Plug>(VM-Find-Subword-Under)", opts) -- 可视模式下创建多光标（子单词）

      -- 多光标导航
      map("n", "gn", "<Plug>(VM-Add-Cursor-Down)", opts) -- 向下添加光标
      map("n", "gp", "<Plug>(VM-Add-Cursor-Up)", opts)   -- 向上添加光标

      -- 多光标选择
      map("n", "gs", "<Plug>(VM-Select-All)", opts)         -- 选择所有匹配项
      map("n", "gS", "<Plug>(VM-Select-Cursor-Down)", opts) -- 向下扩展选择
      map("n", "gP", "<Plug>(VM-Select-Cursor-Up)", opts)   -- 向上扩展选择

      -- 多光标编辑
      map("n", "gc", "<Plug>(VM-Add-Cursor-At-Pos)", opts) -- 在当前位置添加光标
      map("n", "gx", "<Plug>(VM-Remove-Cursor)", opts)     -- 移除当前光标
      map("n", "gX", "<Plug>(VM-Remove-Cursor)", opts)     -- 移除所有光标

      -- 多光标退出
      map("n", "<Esc>", "<Plug>(VM-Reset)", opts) -- 退出多光标模式
    end,
  },
}

