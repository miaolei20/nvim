-- file: plugins/indent.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim", -- 插件名称
    main = "ibl", -- 主模块
    event = "BufReadPost", -- 在读取缓冲区后加载插件
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- 依赖的插件
      "HiPhish/rainbow-delimiters.nvim" -- 依赖的插件
    },
    config = function()
      -- 安全加载检查
      local ok, ibl = pcall(require, "ibl")
      if not ok then
        vim.notify("indent-blankline.nvim not found!", vim.log.levels.ERROR)
        return
      end

      -- 动态颜色适配函数
      local get_hl = function(group, attr)
        return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
      end

      -- 基于当前主题的动态配色
      vim.api.nvim_set_hl(0, "IblIndent", {
        fg = get_hl("Comment", "fg") or "#5c6370",
        nocombine = true,
        blend = 15
      })

      vim.api.nvim_set_hl(0, "IblScope", {
        fg = get_hl("@punctuation.bracket", "fg") or "#56b6c2",
        bold = true,
        nocombine = true
      })

      -- 核心配置（严格遵循官方最新API）
      ibl.setup({
        indent = {
          char = "▏", -- 缩进字符
          highlight = { "IblIndent" }, -- 缩进高亮组
          repeat_linebreak = true -- 重复换行符
        },
        scope = {
          enabled = true, -- 启用范围
          show_start = false, -- 不显示范围开始
          show_end = false, -- 不显示范围结束
          highlight = "IblScope", -- 范围高亮组
          injected_languages = true, -- 启用注入语言
          include = {
            node_type = {
              lua = { "function", "if_statement", "for_statement" },
              python = { "function_definition", "class_definition" },
              javascript = { "function_declaration", "class_declaration" },
              typescript = { "function_declaration", "class_declaration" },
              cpp = { "function_definition", "class_specifier" },
              rust = { "function_item", "impl_item" },
              ["*"] = { "block", "container" }
            }
          }
        },
        exclude = {
          filetypes = {
            "help", "dashboard", "neo-tree", "Trouble",
            "lazy", "mason", "nofile", "terminal",
            "prompt", "TelescopePrompt", "alpha",
            "gitcommit", "markdown", "txt"
          },
          buftypes = {
            "terminal", "nofile", "quickfix", "prompt"
          }
        },
        debounce = 150, -- 官方推荐的防抖时间
        enabled = true  -- 默认启用
      })

      -- 彩虹括号集成（可选配置）
      local rainbow_ok, _ = pcall(require, "rainbow-delimiters")
      if rainbow_ok then
        vim.g.rainbow_delimiters = {
          query = {
            ["*"] = "rainbow-delimiters"
          },
          highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan"
          }
        }
      end

      -- 增强快捷键系统
      vim.keymap.set("n", "<leader>ui", function()
        ibl.toggle()
        vim.notify(
          "Indent guides: " .. (ibl.is_enabled() and "󰄵 Enabled" or "󰶧 Disabled"),
          vim.log.levels.INFO,
          { title = "Indent Blankline", icon = "" }
        )
      end, {
        desc = "Toggle indent guides",
        silent = true
      })
    end
  }
}

