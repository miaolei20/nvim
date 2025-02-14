-- file: plugins/autopairs.lua
return {
  {
    "windwp/nvim-autopairs",  -- 插件名称
    event = "InsertEnter",  -- 在进入插入模式时加载插件
    dependencies = { "hrsh7th/nvim-cmp" },  -- 依赖的插件
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,  -- 启用 Treesitter 检查
        enable_check_bracket_line = true,  -- 启用括号对齐检查
        map_cr = true,  -- 映射回车键
        map_bs = true,  -- 映射退格键
        disable_filetype = { "TelescopePrompt" }  -- 禁用特定文件类型
      })

      -- 与 cmp 集成
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  }
}