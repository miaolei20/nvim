-- file: plugins/cmp.lua
return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "petertriho/cmp-git",    -- 新增 Git 补全
      "zbirenbaum/copilot-cmp" -- 新增 Copilot 集成
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- 智能补全优先级
      local cmp_sources = {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 900 },
        { name = "copilot",  priority = 850 },
        { name = "buffer",   priority = 500 },
        { name = "path",     priority = 250 },
        { name = "git",      priority = 200 }
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        }),
        sources = cmp.config.sources(cmp_sources),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            preset = "codicons",
            menu = {
              buffer = "[BUF]",
              nvim_lsp = "[LSP]",
              luasnip = "[SNP]",
              copilot = "[COP]",
              git = "[GIT]",
              path = "[PATH]"
            }
          })
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None"
          },
          documentation = {
            border = "rounded",
            max_width = 60,
            max_height = 15
          }
        },
        experimental = {
          ghost_text = {
            hl_group = "Comment"
          }
        },
        performance = {
          debounce = 80,
          throttle = 60,
          fetching_timeout = 200
        }
      })

      -- 命令行补全
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        )
      })
    end
  }
}

