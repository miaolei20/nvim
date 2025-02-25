-- file: plugins/indent.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "HiPhish/rainbow-delimiters.nvim"
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
          char = "▏",
          highlight = { "IblIndent" },
          repeat_linebreak = true
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
          highlight = "IblScope",
          injected_languages = true,
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

