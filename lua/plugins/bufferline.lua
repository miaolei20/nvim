-- file: plugins/01-bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",               -- 插件名称
    event = "VeryLazy",                      -- 懒加载事件
    dependencies = { "nvim-web-devicons" },  -- 依赖的插件
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" }, -- Shift+h 切换到上一个缓冲区
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" }, -- Shift+l 切换到下一个缓冲区
    },
    config = function()
      -- 强制全局启用标签栏
      vim.opt.termguicolors = true
      vim.opt.showtabline = 2 -- 始终显示标签栏（Dashboard 会局部覆盖）

      -- 核心配置
      require("bufferline").setup({
        options = {
          mode = "buffers",                  -- 模式设置为缓冲区
          numbers = "none",                  -- 不显示缓冲区编号
          close_command = "bdelete! %d",     -- 关闭缓冲区的命令
          offsets = { {                      -- 偏移配置
            filetype = "NvimTree",           -- 文件类型为 NvimTree
            text = "  Explorer ",           -- 显示文本
            highlight = "Comment",           -- 高亮组
            text_align = "left",             -- 文本对齐方式
            padding = 1                      -- 填充
          } },
          separator_style = "thin",          -- 分隔符样式
          always_show_bufferline = true,     -- 始终显示缓冲区线
          show_buffer_close_icons = false,   -- 不显示缓冲区关闭图标
          show_close_icon = false,           -- 不显示关闭图标
          diagnostics = "nvim_lsp",          -- 启用 LSP 诊断
          diagnostics_indicator = function(_, _, diag) -- 诊断指示器
            return (diag.error and " " or "") .. (diag.warning and " " or "")
          end,
          custom_areas = {                   -- 自定义区域
            right = function()
              return {
                { text = " 󰍛 " .. vim.fn.system("free -h | grep Mem | awk '{print $3}'"):gsub("\n", ""), highlight = "WarningMsg" } -- 显示内存使用情况
              }
            end
          }
        },
        highlights = {                       -- 高亮配置
          fill = { bg = require("onedark.palette").dark.bg0 }, -- 填充背景色
          background = { bg = require("onedark.palette").dark.bg0, fg = require("onedark.palette").dark.gray },
          buffer_selected = { bg = require("onedark.palette").dark.bg0, fg = require("onedark.palette").dark.fg, bold = true },
          modified = { fg = require("onedark.palette").dark.green, bg = require("onedark.palette").dark.bg0 },
          diagnostic = { fg = require("onedark.palette").dark.yellow, bg = require("onedark.palette").dark.bg0 }
        }
      })
    end
  }
}
