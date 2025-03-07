return {
    {
      "rcarriga/nvim-notify",
      event = "VimEnter",  -- 让插件延迟加载直到 Neovim 启动后
      config = function()
        require("notify").setup({
          background_colour = "#000000",  -- 可自定义配置项
        })
      end,
    },
  }
  