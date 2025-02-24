-- file: plugins/which-key.lua
return {
  {
    "folke/which-key.nvim",  -- 主插件
    event = "VeryLazy",  -- 在 VeryLazy 事件时加载
    config = function()
      local colors = require("onedark.palette").dark  -- 获取配色方案
      require("which-key").setup({})  -- 配置 which-key 插件
    end
  }
}
