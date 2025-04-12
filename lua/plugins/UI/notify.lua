return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "static",   -- 静态动画，减少动画开销
        timeout = 200,       -- 短超时（毫秒）
        fps = 20,            -- 降低帧率，进一步降低 CPU 占用
        -- 其它参数均采用默认值
      })
      vim.notify = notify
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",  -- 使用 nvim-notify 作为通知后端
    },
    config = function()
      require("noice").setup({
        throttle = 1000 / 20,  -- 限制更新频率，与 notify 保持一致
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          opts = {
            border = { style = "rounded", padding = { 0, 1 } },
            win_options = { winblend = 10 },
            position = { row = "5%", col = "50%" },  -- 将命令栏放置在顶部中间
            size = { width = 60, height = "auto" },
          },
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        popupmenu = {
          enabled = false,  -- 禁用内置 popupmenu，减少额外开销
        },
        lsp = {
          progress = { enabled = false },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = true,
            opts = { border = "rounded", win_options = { winblend = 10 } },
          },
          signature = {
            enabled = true,
            opts = { border = "rounded", win_options = { winblend = 10 } },
          },
          message = { enabled = false },
        },
        presets = {
          bottom_search = false,     -- 关闭底部搜索预设
          command_palette = false,   -- 关闭命令面板预设（非必要功能）
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
        views = {
          cmdline_popup = {
            border = { style = "rounded", padding = { 0, 1 } },
            win_options = { winblend = 10 },
          },
          notify = {
            merge = true,
            replace = true,
          },
          mini = {
            timeout = 200,
            win_options = { winblend = 10 },
          },
        },
      })
    end,
  },
}
