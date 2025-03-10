return {
  {
    "echasnovski/mini.cursorword",
    event = "VeryLazy",  -- 延迟加载，直至 Neovim 启动后
    config = function()
      require("mini.cursorword").setup({
        delay = 100,  -- 光标移动后 100ms 内显示高亮
      })
    end,
  },
}
