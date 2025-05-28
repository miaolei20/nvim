return {
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      stages = "slide",
      timeout = 3000,
      render = "default",
      background_colour = "#1e222a", -- 适配 onedarkpro
    },
    init = function()
      vim.notify = require("notify")
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        progress = {
          enabled = true,
          format = "lsp_progress",
          throttle = 1000 / 30,
          view = "mini",
        },
        signature = { enabled = true, auto_open = { enabled = true } },
        hover = { enabled = true },
        message = { enabled = true },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded" },
        },
        popupmenu = {
          relative = "editor",
          position = { row = 8, col = "50%" },
          size = { width = 60, height = 10 },
          border = { style = "rounded" },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" }, -- 行/列信息
              { find = "; after #%d+" }, -- 替换提示
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
    },
  },
}