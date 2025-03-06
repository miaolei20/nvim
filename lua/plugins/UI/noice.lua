return {
  {
    "folke/noice.nvim",
    event = "VeryLazy", -- 延迟加载
    dependencies = {
      "MunifTanjim/nui.nvim", -- noice 的 UI 依赖
      "rcarriga/nvim-notify", -- 可选：集成 nvim-notify 用于通知
    },
    config = function()
      local noice = require("noice")

      local config = {
        lsp = {
          progress = { enabled = true }, -- 启用 LSP 进度信息
          override = {
            -- 重写 vim 内置的 markdown 渲染，使 LSP 提示更美观
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search         = true,  -- 搜索结果显示在底部
          command_palette       = true,  -- 启用命令面板风格
          long_message_to_split = true,  -- 长消息拆分显示
          inc_rename            = false, -- 关闭增量重命名
        },
        routes = {
          {
            filter = { event = "msg_show", kind = "search_count" },
            opts   = { skip = true },
          },
        },
        views = {
          cmdline_popup = {
            position = { row = 10, col = "50%" },
            size = { width = 60, height = "auto" },
          },
          popupmenu = {
            relative = "editor",
            position = { row = 12, col = "50%" },
            size = { width = 60, height = 10 },
            border = { style = "rounded", padding = { 0, 1 } },
          },
        },
      }

      noice.setup(config)
    end,
  },
}
