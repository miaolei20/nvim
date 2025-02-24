-- file: plugins/toggleterm.lua
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { "<leader>tt", "<C-\\>" }, -- 快捷键前缀
    config = function()
      require("toggleterm").setup({
        size = 15,                -- 终端高度（垂直方向）
        direction = "horizontal", -- 方向：horizontal（水平）/vertical（垂直）/float（浮动）
        shade_terminals = true,   -- 给终端添加背景遮罩
        start_in_insert = true,   -- 打开终端时自动进入插入模式
        close_on_exit = true,     -- 终端退出时自动关闭窗口
        persist_mode = false,     -- 记忆终端状态
        shell = vim.o.shell,      -- 使用系统默认 Shell
        float_opts = {
          border = "curved",      -- 浮动窗口边框样式
          winblend = 3,           -- 透明度混合（0-100）
        }
      })

      -- 基础快捷键
      vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
      vim.keymap.set("t", "<C-\\>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" }) -- 终端模式切换

      -- 可选：创建多个专用终端
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        hidden = true,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Toggle Lazygit" })
    end
  }
}