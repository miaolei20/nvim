return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip", -- 新增专用片段集成插件[3]
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
              luasnip.expand_or_jump() -- 优先处理片段跳转[3]
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1) -- 反向片段跳转优先[3]
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<C-e>"] = cmp.mapping.abort(), -- 统一取消操作
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
          { name = "luasnip",   priority = 85 }, -- 独立片段源[3]
          { name = "buffer",    priority = 70 },
          { name = "path",     priority = 60 }
        }),

        -- 智能片段配置
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- 安全展开片段[3]
          end
        },

        -- 优化的窗口渲染
        window = {
          completion = {
            border = "single",
            scrolloff = 3, -- 滚动边界缓冲
            col_offset = -1,
            side_padding = 0
          },
          documentation = {
            border = "rounded",
            max_width = 60,
            max_height = 18
          }
        },

        -- 类型标记增强
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            preset = "codicons",
            symbol_map = {
              Copilot = "",     -- 优化 AI 标识
              Snippet = "",     -- 独立片段标识[3]
              Method = "󰆧",
              Field = "󰛨"
            },
            menu = {
              luasnip = "[SNIP]", -- 明确片段来源[3]
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
