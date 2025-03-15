return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",  -- 可选：显示文件图标
    },
    event = "BufWinEnter",  -- 延迟加载，降低启动时开销
    config = function()
      local ok, palette = pcall(require, "onedark.palette")
      if not ok then return end
      local dark = palette.dark
      -- 缓存常用颜色，避免重复查找
      local bg = dark.bg
      local fg = dark.fg
      local blue = dark.blue

      require("bufferline").setup({
        options = {
          numbers = "ordinal",         -- 显示缓冲区数字
          separator_style = "none",    -- 不使用分隔符，保持简约
          diagnostics = false,         -- 关闭诊断（可按需开启）
          offsets = {
            {
              filetype = "NvimTree",
              text = "",
              padding = 1,
            },
          },
          show_close_icon = false,
          show_buffer_icons = true,
          always_show_bufferline = true,
        },
        highlights = {
          fill = { guifg = fg, guibg = bg },
          background = { guifg = fg, guibg = bg },
          buffer_selected = { guifg = fg, guibg = bg, gui = "bold" },
          separator = { guifg = bg, guibg = bg },
          separator_visible = { guifg = bg, guibg = bg },
          separator_selected = { guifg = bg, guibg = bg },
          indicator_selected = { guifg = blue, guibg = bg },
          numbers = { guifg = fg, guibg = bg },
        },
      })
    end,
  },
}
