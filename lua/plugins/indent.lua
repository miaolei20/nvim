-- ~/.config/nvim/lua/plugins/indent.lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "HiPhish/rainbow-delimiters.nvim"
    },
    config = function()
      local ibl = require("ibl")

      -- [[ 增强高亮系统 ]]-------------------------
      local function setup_highlights()
        local get_hl = function(group, attr, fallback)
          local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
          return color ~= "" and color or fallback
        end

        -- 缩进线颜色（浅蓝色主题）
        vim.api.nvim_set_hl(0, "IblIndent", {
          fg = "#7FD5EA",  -- 浅蓝色
          blend = 20,
          nocombine = true,
        })

        -- 作用域高亮
        vim.api.nvim_set_hl(0, "IblScope", {
          fg = get_hl("@punctuation.bracket", "fg", "#56b6c2"),
          bold = true,
        })

        -- 行号系统
        vim.api.nvim_set_hl(0, "LineNr", {
          fg = get_hl("Comment", "fg", "#6C7986"),
          bg = get_hl("Normal", "bg", "NONE"),
        })

        vim.api.nvim_set_hl(0, "CursorLineNr", {
          fg = "#FFD700",  -- 金色
          bg = "#2A2F3A",
          bold = true,
          italic = true,
        })

        vim.api.nvim_set_hl(0, "VisualLineNr", {
          fg = "#FF6B6B",  -- 珊瑚红
          bg = "#3A3F4A",
          underline = true,
        })

        vim.api.nvim_set_hl(0, "InsertLineNr", {
          fg = "#98C379",  -- 柔绿色
          bg = "#2A2F3A",
          italic = true,
        })
      end

      -- [[ 核心配置 ]]-------------------------
      local function setup_core()
        ibl.setup({
          indent = {
            char = "│",          -- 更明显的垂直线
            highlight = "IblIndent",
            smart_indent_cap = true,
            priority = 210,      -- 提高显示优先级
          },
          scope = {
            enabled = true,
            show_start = false,
            show_end = false,
            highlight = "IblScope",
            injected_languages = true,
            include = {
              node_type = {
                lua = { "function", "table", "if_statement" },
                python = { "function_definition", "class_definition" },
                javascript = { "function_declaration", "class_declaration" },
                ["*"] = { "block", "container" }
              }
            }
          },
          exclude = {
            filetypes = {
              "help", "dashboard", "neo-tree", "Trouble",
              "lazy", "mason", "nofile", "terminal",
              "gitcommit", "markdown", "text", "prompt",
              "TelescopePrompt", "alpha", "Outline"
            },
            buftypes = {
              "terminal", "nofile", "quickfix", "prompt"
            }
          },
          debounce = 100,        -- 更快的响应
        })
      end

      -- [[ 初始化流程 ]]-------------------------
      setup_highlights()
      setup_core()

      -- [[ 自动命令 ]]-------------------------
      local augroup = vim.api.nvim_create_augroup("IndentBlanklineUI", { clear = true })

      -- 主题变化处理
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        callback = function()
          setup_highlights()
          ibl.update()  -- 安全更新配置
        end
      })

      -- 模式响应式行号
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = augroup,
        pattern = "*:*",
        callback = function()
          local mode = vim.fn.mode()
          local colors = {
            n = { fg = "#FFD700", style = "bold,italic" },
            i = { fg = "#98C379", style = "italic" },
            v = { fg = "#FF6B6B", style = "underline" },
            V = { fg = "#FF6B6B", style = "underline" },
            [""] = { fg = "#FF6B6B", style = "underline" }
          }
          local cfg = colors[mode] or colors.n
          vim.api.nvim_set_hl(0, "CursorLineNr", {
            fg = cfg.fg,
            bg = "#2A2F3A",
            bold = cfg.style:find("bold"),
            italic = cfg.style:find("italic"),
            underline = cfg.style:find("underline")
          })
        end
      })

      -- [[ 交互增强 ]]-------------------------
      vim.keymap.set("n", "<leader>ui", function()
        ibl.toggle()
        vim.notify(
          "缩进指南: " .. (ibl.is_enabled() and "✅ 启用" or "⛔ 禁用"),
          vim.log.levels.INFO,
          { title = "Indent Blankline", icon = "󰙔" }
        )
      end, { desc = "切换缩进指南", silent = true })

      vim.keymap.set("n", "<leader>ul", function()
        vim.opt.relativenumber = not vim.opt.relativenumber:get()
        vim.notify(
          "相对行号: " .. (vim.opt.relativenumber:get() and "✅" or "⛔"),
          vim.log.levels.INFO,
          { title = "行号模式", icon = "󰧟" }
        )
      end, { desc = "切换相对行号", silent = true })
    end
  }
}
