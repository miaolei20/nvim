-- file: plugins/scrollbar.lua
return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      local colors = require("onedark.palette").dark

      require("scrollbar").setup({
        handle = {
          color = colors.gray, -- 滚动条颜色
          blend = 30 -- 透明度
        },
        marks = { -- 集成其他插件标记
          Search = { color = colors.yellow },
          Error = { color = colors.red },
          Warn = { color = colors.orange },
          Info = { color = colors.blue },
          Hint = { color = colors.cyan }
        },
        excluded_filetypes = { "NvimTree", "TelescopePrompt" } -- 排除文件类型
      })
    end
  }
}
