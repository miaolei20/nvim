-- lua/plugins/cmp.lua
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "zbirenbaum/copilot-cmp",
  },
  opts = function()
    local cmp = require("cmp")
    return {
      performance = {
        debounce = 50,
        throttle = 60,
      },
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
        { name = "luasnip", priority = 800 },
      }),
      formatting = {
        fields = { "kind", "abbr" },
        format = function(entry, item)
          local icons = {
            Copilot = "",
            nvim_lsp = "",
            luasnip = "",
          }
          item.kind = icons[entry.source.name] or ""
          return item
        end,
      },
      experimental = {
        ghost_text = {
          hl_group = "Comment",
        },
      },
    }
  end
}