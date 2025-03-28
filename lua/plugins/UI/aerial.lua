return {
  {
    "stevearc/aerial.nvim",
    event = { "LspAttach", "BufReadPost" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons", -- 添加图标支持
    },
    config = function()
      -- 获取当前颜色方案
      local colors = require("onedark.palette").dark or {
        bg = "#282c34",
        fg = "#abb2bf",
        cyan = "#56b6c2",
        purple = "#c678dd",
      }

      -- 配置符号图标 (Nerd Font)
      local icons = {
        Array = "",
        Boolean = "",
        Class = "",
        Color = "",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "",
        Function = "󰊕",
        Interface = "",
        Key = "",
        Keyword = "",
        Method = "󰊕",
        Module = "",
        Namespace = "",
        Null = "󰟢",
        Number = "",
        Object = "",
        Operator = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Variable = "",
      }

      require("aerial").setup({
        -- 布局设置
        layout = {
          min_width = 35,
          max_width = 45,
          default_direction = "right",
          placement = "edge",
          resize_to_content = true,
        },
        
        -- 显示配置
        show_guides = true,
        guides = {
          mid_item = "├─",
          last_item = "└─",
          nested_top = "│ ",
          whitespace = "  ",
        },
        highlight_on_hover = true,
        highlight_mode = "split_width",
        highlight_closest = true,
        close_behavior = "auto",
        
        -- 样式配置
        float = {
          border = "rounded",
          row = 1,
          col = 1,
        },
        lsp = {
          diagnostics_trigger_update = true,
          update_when_errors = true,
        },
        
        -- 图标与颜色
        icons = icons,
        nerd_font = "auto",
        link_folds_to_tree = true,
        link_tree_to_folds = true,
        highlight = {
          link = "AerialLine",
          bg = colors.bg,
          fg = colors.fg,
        },
        
        -- 过滤配置
        filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Struct",
        },
        
        -- 快捷键映射
        on_attach = function(bufnr)
          -- 大纲窗口内导航
          vim.keymap.set("n", "q", "<cmd>AerialClose<CR>", { buffer = bufnr, desc = "Close outline" })
          vim.keymap.set("n", "<CR>", "<cmd>AerialGo<CR>", { buffer = bufnr, desc = "Jump to symbol" })
          
          -- 全局切换快捷键
          vim.keymap.set("n", "<leader>lo", "<cmd>AerialToggle!<CR>", {
            desc = "Toggle Code Outline (Global)",
          })
        end,
      })

      -- 自定义高亮组 (AstroNvim 风格)
      vim.api.nvim_set_hl(0, "AerialLine", { fg = colors.purple, bold = true })
      vim.api.nvim_set_hl(0, "AerialGuide", { fg = colors.cyan, bold = false })
    end
  }
}