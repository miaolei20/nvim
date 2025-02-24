-- file: plugins/indent.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "HiPhish/rainbow-delimiters.nvim"  -- 新增括号颜色依赖
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

      -- 核心配置
      ibl.setup({
        indent = {
          char = "▏",
          char_highlight_list = { "IblIndent" },
          repeat_linebreak = true,
          smart_indent_cap = true,  -- 智能缩进上限
          priority = 200,           -- 提升渲染优先级
          debounce = 80             -- 减少渲染频率
        },
        scope = {
          show_start = false,
          show_end = false,
          highlight = "IblScope",
          injected_languages = true,
          include = {  -- 支持更多作用域类型
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

      -- 高级配置：彩虹括号集成
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