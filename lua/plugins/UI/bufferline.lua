return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- 文件图标支持
    },
    event = { "BufReadPost", "BufNewFile" }, -- 更精确的加载时机
    config = function()
      -- 延迟加载配置，避免启动时阻塞
      vim.defer_fn(function()
        local status, palette = pcall(require, "onedark.palette")
        if not status then return end
        
        local dark = palette.dark
        -- 使用局部变量缓存颜色
        local colors = {
          bg = dark.bg,
          fg = dark.fg,
          blue = dark.blue,
        }

        require("bufferline").setup({
          options = {
            numbers = "ordinal",
            separator_style = "none",
            diagnostics = false,
            show_close_icon = false,
            show_buffer_icons = true,
            always_show_bufferline = false, -- 改为 false，只在有多个 buffer 时显示
            offsets = {
              {
                filetype = "NvimTree",
                text = "",
                padding = 1,
                highlight = "Directory",
              },
            },
          },
          highlights = {
            fill = { fg = colors.fg, bg = colors.bg },
            background = { fg = colors.fg, bg = colors.bg },
            buffer_selected = { fg = colors.fg, bg = colors.bg, bold = true },
            separator = { fg = colors.bg, bg = colors.bg },
            separator_visible = { fg = colors.bg, bg = colors.bg },
            separator_selected = { fg = colors.bg, bg = colors.bg },
            indicator_selected = { fg = colors.blue, bg = colors.bg },
            numbers = { fg = colors.fg, bg = colors.bg },
          },
        })
      end, 50) -- 延迟 50ms 加载
    end,
  },
}