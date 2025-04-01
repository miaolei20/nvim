return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip", -- Required for LuaSnip integration
      "zbirenbaum/copilot-cmp",
      "rafamadriz/friendly-snippets", -- Added friendly-snippets
    },
    opts = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load() -- Load friendly-snippets
      return {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "copilot", priority = 1000 },
          { name = "nvim_lsp", priority = 900 },
          { name = "luasnip", priority = 800 }, -- Includes friendly-snippets
        }),
        formatting = {
          fields = { "kind", "abbr" },
          format = function(entry, item)
            local icons = {
              copilot = "",
              nvim_lsp = "",
              luasnip = "",
            }
            item.kind = icons[entry.source.name] or ""
            return item
          end,
        },
        experimental = {
          ghost_text = { hl_group = "Comment" },
        },
      }
    end,
  },
}