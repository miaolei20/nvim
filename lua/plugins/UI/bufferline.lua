return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons" -- 必须安装nerd字体支持
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- 颜色配置：优先使用onedark主题色，否则使用默认值
      local ok, palette = pcall(require, "onedark.palette")
      local colors = {
        bg   = ok and palette.dark.bg or "#282C34",
        fg   = ok and palette.dark.fg or "#ABB2BF",
        blue = ok and palette.dark.blue or "#61AFEF"
      }

      require("bufferline").setup({
        options = {
          numbers = "ordinal",          -- 显示序号
          separator_style = { "", "" }, -- 完全隐藏分隔符
          close_icon = "",              -- 禁用关闭图标
          show_close_icon = false,
          show_buffer_icons = true,     -- 显示文件类型图标
          always_show_bufferline = false, -- 只在多标签时显示
          indicator = { style = "underline" }, -- 当前标签下划线指示器
          offsets = {{
            filetype = "NvimTree",       -- 适配NvimTree侧边栏
            text = "",
            padding = 1,
            highlight = "Directory"
          }}
        },
        highlights = {
          -- 核心修改：统一所有背景色为主题背景色
          fill = { bg = colors.bg },     -- 移除右侧填充色块
          background = { fg = colors.fg, bg = colors.bg },
          
          -- 选中标签样式
          buffer_selected = {
            fg = colors.fg,
            bg = colors.bg,
            bold = true,
            italic = false
          },
          
          -- 统一分隔符颜色
          separator = { fg = colors.bg, bg = colors.bg },
          separator_visible = { fg = colors.bg, bg = colors.bg },
          separator_selected = { fg = colors.bg, bg = colors.bg },
          
          -- 序号颜色
          numbers = { fg = colors.fg, bg = colors.bg },
          
          -- 当前标签指示器
          indicator_selected = { fg = colors.blue, bg = colors.bg },
          
          -- 关闭按钮相关（彻底隐藏）
          close_button = { bg = colors.bg },
          close_button_visible = { bg = colors.bg },
          close_button_selected = { bg = colors.bg }
        }
      })
    end
  }
}