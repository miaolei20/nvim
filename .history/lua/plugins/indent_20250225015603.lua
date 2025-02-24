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

      -- 核心配置（修复 API 变更）
      ibl.setup({
        indent = {
          char = "▏",
          highlight = { "IblIndent" },  -- 使用 highlight 替代废弃的 char_highlight_list
          repeat_linebreak = true,
          smart_indent_cap = true,
          priority = 200,
          debounce = 80
        },
        scope = {
          show_start = false,
          show_end = false,
          highlight = "IblScope",
          injected_languages = true,
          include = {
            node_type = {
              ["*"] = {
                "class",
                "function",
                "method",
                "block",
                "for_statement",
                "if_statement"
              }
            }
          }
        },
        exclude = {
          filetypes = {
            "help",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "nofile",
            "terminal",
            "prompt",
            "TelescopePrompt"
          },
          buftypes = {
            "terminal",
            "nofile",
            "quickfix",
            "prompt"
          }
        }
      })

      -- 彩虹括号集成
      local rainbow_ok, rainbow = pcall(require, "rainbow-delimiters")
      if rainbow_ok then
        vim.g.rainbow_delimiters = {
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

      -- 快捷键配置
      vim.keymap.set("n", "<leader>ui", function()
        ibl.toggle()
        vim.notify("Indent guides " .. (ibl.is_enabled() and "Enabled" or "Disabled"))
      end, { desc = "Toggle Indent Guides" })
    end
  }
}