return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open Lazygit" },  -- 快捷键触发
    },
    config = function()
      -- 使用延迟加载
      vim.cmd([[
        let g:lazygit_floating_window = 1
        let g:lazygit_use_neovim_remote = 1
        let g:lazygit_height = 0.9
        let g:lazygit_width = 0.9
        let g:lazygit_border = 'rounded'
      ]])

      -- 如果有懒加载机制（如Lazy），通过触发按键时加载
      -- 确保在调用时加载插件，避免启动时加载
    end,
    lazy = true,  -- 完全延迟加载
  }
}
