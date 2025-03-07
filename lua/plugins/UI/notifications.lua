-- 返回一个包含 nvim-notify 与 noice.nvim 配置的插件表
return {
    -- 配置 nvim-notify：用于统一显示 Neovim 通知
    {
      "rcarriga/nvim-notify",
      event = "VeryLazy", -- 延迟加载，提升启动速度
      opts = {
        timeout = 2000,                -- 通知显示时长（毫秒）
        max_width = 80,                -- 通知最大宽度
        stages = "slide",              -- 动画效果
        position = "bottom_right",     -- 显示位置
        background_colour = "#1e222a", -- 背景颜色
        icons = {                      -- 不同类型通知的图标
          ERROR = "",
          WARN  = "",
          INFO  = "",
          DEBUG = "",
          TRACE = "✎",
        },
        render = "wrapped-compact",    -- 通知样式
      },
      config = function(_, opts)
        local notify = require("notify")
        notify.setup(opts)
        vim.notify = notify  -- 重写 vim.notify 以使用 nvim-notify
      end,
    },
  
    -- 配置 noice.nvim：美化 Neovim 内置 UI（LSP、命令行、消息等）
    {
      "folke/noice.nvim",
      event = "VeryLazy", -- 延迟加载
      dependencies = {
        "MunifTanjim/nui.nvim",  -- noice 的 UI 辅助依赖
        "rcarriga/nvim-notify",   -- 集成 nvim-notify 用于通知显示
      },
      config = function()
        local noice = require("noice")
        noice.setup({
          lsp = {
            progress = { enabled = true }, -- 显示 LSP 进度
            override = {
              -- 优化 LSP 提示：美化 markdown 渲染
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
          presets = {
            bottom_search         = true,  -- 搜索结果显示在底部
            command_palette       = true,  -- 启用命令面板风格
            long_message_to_split = true,  -- 长消息拆分显示，防止界面卡顿
            inc_rename            = false, -- 关闭增量重命名以提升响应速度
          },
          routes = {
            {
              filter = { event = "msg_show", kind = "search_count" },
              opts   = { skip = true }, -- 跳过无用的搜索计数信息
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
        })
      end,
    },
  }
  