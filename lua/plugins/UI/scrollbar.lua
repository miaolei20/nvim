return {
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    dependencies = { "navarasu/onedark.nvim", "kevinhwang91/nvim-hlslens" },
    config = function()
      -- 尝试加载 onedark 主题模块
      local ok, _ = pcall(require, "onedark")
      if not ok then
        vim.notify("未找到 onedark 主题!", vim.log.levels.WARN)
        return
      end

      -- 定义主题颜色（这里使用固定色值，可根据需要调整）
      local colors = {
        grey   = "#5c6370",
        red    = "#e06c75",
        yellow = "#e5c07b",
        blue   = "#61afef",
        cyan   = "#56b6c2",
        purple = "#c678dd",
      }

      -- 缓存 scrollbar 模块并设置基本配置
      local scrollbar = require("scrollbar")
      scrollbar.setup({
        handle = {
          color = colors.grey,
          blend = 50,         -- 使用 blend 控制透明度
          symbol = "▏",
          hide_if_all_visible = true,
        },
        marks = {
          Error  = { color = colors.red,    symbol = "●" },
          Warn   = { color = colors.yellow, symbol = "◆" },
          Info   = { color = colors.blue,   symbol = "■" },
          Hint   = { color = colors.cyan,   symbol = "▲" },
          Search = { color = colors.purple, symbol = "◈" },
        },
        excluded_filetypes = {
          "NvimTree", "TelescopePrompt", "alpha",
          "dashboard", "lazy",
        },
        handlers = {
          diagnostic = true,
          search = true,
          gitsigns = true,
        },
      })

      -- 配置高亮组，确保与 handle 配色一致
      vim.api.nvim_set_hl(0, "ScrollbarHandle", {
        bg = colors.grey,
        blend = 30,
        nocombine = true,
      })
    end,
  },
}
