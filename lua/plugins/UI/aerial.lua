return {
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lspconfig",  -- 确保 LSP 依赖已安装
    },
    config = function()
      -- 尝试加载 aerial 模块
      local status_ok, aerial = pcall(require, "aerial")
      if not status_ok then
        return
      end

      aerial.setup({
        -- 当 LSP 附加到缓冲区时自动绑定按键
        on_attach = function(bufnr)
          vim.keymap.set("n", "<leader>o", aerial.toggle, {
            buffer = bufnr,
            desc = "Toggle Aerial Outline",
          })
        end,

        -- 设置大纲窗口布局（可根据个人习惯调整）
        layout = {
          default_direction = "prefer_right", -- 默认在右侧打开
          min_width = 20,                     -- 窗口最小宽度
          max_width = 40,                     -- 窗口最大宽度
        },

        -- 自定义符号图标，使视觉效果更佳
        icons = {
          Array = "",
          Boolean = "",
          Class = "",
          Color = "",
          Constant = "",
          Constructor = "",
          Enum = "",
          EnumMember = "",
          Event = "",
          Field = "",
          File = "",
          Folder = "",
          Function = "",
          Interface = "",
          Key = "",
          Keyword = "",
          Method = "",
          Module = "",
          Namespace = "",
          Null = "ﳠ",
          Number = "",
          Object = "",
          Operator = "",
          Package = "",
          Property = "",
          String = "",
          Struct = "",
          Text = "",
          TypeParameter = "",
          Unit = "",
          Value = "",
          Variable = "",
        },

        -- 显示层级辅助线，便于区分不同的符号层级
        show_guides = true,

        -- 设置过滤器，false 表示不过滤任何符号类型
        filter_kind = false,
      })
    end,
  },
}
