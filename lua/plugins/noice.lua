-- file: plugins/noice.lua
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy", -- 延迟加载（你也可以改为 "VimEnter"）
    dependencies = {
      "MunifTanjim/nui.nvim",         -- noice 的 UI 依赖
      "rcarriga/nvim-notify",         -- 可选：集成 nvim-notify 用于通知
    },
    config = function()
      require("noice").setup({
        -- LSP 相关配置
        lsp = {
          progress = {
            enabled = true,           -- 启用 LSP 进度信息
          },
          override = {
            -- 重写 vim 内置的 markdown 渲染，使 LSP 提示更美观
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- 预设风格配置
        presets = {
          bottom_search = true,       -- 将搜索结果显示在底部（类似传统 cmdline）
          command_palette = true,     -- 启用命令面板风格
          long_message_to_split = true, -- 长消息自动拆分显示在单独窗口
          inc_rename = false,         -- 关闭增量重命名（如果你不使用 inc-rename 插件）
        },
        -- 路由配置：过滤掉不必要的消息
        routes = {
          {
            filter = { event = "msg_show", kind = "search_count" },
            opts = { skip = true },
          },
        },
        -- 自定义视图配置
        views = {
          cmdline_popup = {
            position = {
              row = 10,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = 12,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
          },
        },
      })
    end,
  },
}
