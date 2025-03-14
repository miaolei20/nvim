return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true     -- 启用按键超时检测
      vim.o.timeoutlen = 300   -- 设置300ms触发延迟[<sup>3</sup>](https://www.thien.dev/w/vim-plugin-which-key)
    end,
    opts = {
      -- 可在此处添加自定义配置参数
      -- 保持空表则使用默认配置[<sup>3</sup>](https://www.thien.dev/w/vim-plugin-which-key)[<sup>5</sup>](https://github.com/folke/which-key.nvim)
    },
    config = function(_, opts)
      require("which-key").setup(opts)  -- 注入opts配置参数[<sup>3</sup>](https://www.thien.dev/w/vim-plugin-which-key)
    end
  }
}
