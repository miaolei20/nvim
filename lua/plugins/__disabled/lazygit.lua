return {
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit (Project root)" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      -- 设置浮动窗口现代样式
      vim.g.lazygit_floating_window_scaling_factor = 0.9  -- 窗口占屏比例
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.lazygit_use_neovim_remote = 1  -- 确保 Neovim 终端集成
    end,
    config = function()
      -- 现代配色集成（可选）
      vim.api.nvim_set_hl(0, "LazyGitBorder", { link = "FloatBorder" })
    end
  }
}