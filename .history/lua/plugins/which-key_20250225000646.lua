-- file: plugins/which-key.lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          -- 其他插件集成配置...
        }
      })

      -- 添加 <leader>u 组的快捷键提示
      wk.register({
        u = {
          name = "+undotree",  -- 组名称
          u = { "<cmd>UndotreeToggle<CR>", "Toggle Undotree" },  -- 具体快捷键
        }
      }, { prefix = "<leader>" })
    end
  }
}