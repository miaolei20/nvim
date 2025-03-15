return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",
      "zbirenbaum/copilot-cmp"
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- 智能片段加载策略
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = {
          vim.fn.stdpath("config") .. "/snippets" -- 自定义片段目录
        }
      })

      -- 冲突解决型快捷键配置
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
          }),
          
          -- 增强型文档控制
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4)
        }),

        -- 优先级排序的补全源
        sources = cmp.config.sources({
          { name = "copilot",  priority = 100 },
          { name = "nvim_lsp", priority = 90 },
          { name = "luasnip",  priority = 85 },
          { name = "buffer",   priority = 70 },
          { name = "path",     priority = 60 }
        }),

        -- 智能片段配置
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },

        -- 优化的窗口渲染
        window = {
          completion = {
            border = "single",
            max_width = 50,    -- 限制最大宽度
            max_height = 10,   -- 限制最大高度
            scrolloff = 1,     -- 减少滚动条出现
            col_offset = -1,   -- 调整显示位置
            side_padding = 1   -- 增加内边距
          },
          documentation = {
            border = "rounded",
            max_width = 40,    -- 适中宽度
            max_height = 15    -- 适中高度
          }
        },

        -- 类型标记增强
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            preset = "codicons",
            symbol_map = {
              Copilot = "",
              Snippet = "",
              Method = "󰆧",
              Field = "󰛨"
            },
            menu = {
              luasnip = "[SNIP]",
              nvim_lsp = "[LSP]",
              copilot = "[AI]"
            }
          })
        }
      })

      -- 片段专用高亮配置
      vim.api.nvim_set_hl(0, "LuaSnipSnippet",  { fg = "#78DBA8" })
      vim.api.nvim_set_hl(0, "LuaSnipChoice",   { fg = "#FFB86C" })
    end
  }
}