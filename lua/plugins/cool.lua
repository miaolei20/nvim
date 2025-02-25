return {
  "romainl/vim-cool", -- 插件名称
  event = "VeryLazy", -- 根据需要可以修改加载时机
  config = function()
    -- vim-cool 的配置项，比如设置自动清除搜索高亮的延时时间（单位：毫秒）
    vim.g.cool_timeout = 300
  end,
}
