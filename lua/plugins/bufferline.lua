-- file: plugins/01-bufferline.lua
return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
    config = function()
      -- 强制全局启用标签栏
      vim.opt.termguicolors = true
      vim.opt.showtabline = 2 -- 始终显示标签栏（Dashboard 会局部覆盖）

      -- 核心配置
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          offsets = { {
            filetype = "NvimTree",
            text = "  Explorer ",
            highlight = "Comment",
            text_align = "left",
            padding = 1
          } },
          separator_style = "thin",
          always_show_bufferline = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            return (diag.error and " " or "") .. (diag.warning and " " or "")
          end,
          custom_areas = {
            right = function()
              return {
                { text = " 󰍛 " .. vim.fn.system("free -h | grep Mem | awk '{print $3}'"):gsub("\n", ""), highlight = "WarningMsg" }
              }
            end
          }
        },
        highlights = {
          fill = { bg = require("onedark.palette").dark.bg0 },
          background = { bg = require("onedark.palette").dark.bg0, fg = require("onedark.palette").dark.gray },
          buffer_selected = { bg = require("onedark.palette").dark.bg0, fg = require("onedark.palette").dark.fg, bold = true },
          modified = { fg = require("onedark.palette").dark.green, bg = require("onedark.palette").dark.bg0 },
          diagnostic = { fg = require("onedark.palette").dark.yellow, bg = require("onedark.palette").dark.bg0 }
        }
      })
    end
  }
}
