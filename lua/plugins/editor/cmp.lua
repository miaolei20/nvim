return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
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
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
        formatting = {
          fields = { "kind", "abbr" },
          format = function(_, item)
            local icons = {
              Text = "󰉿",
              Method = "󰆧",
              Function = "󰊕",
              Constructor = "󰒓",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "󰏗",
              Property = "󰜢",
              Unit = "󰑭",
              Value = "󰎠",
              Enum = "󰕘",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "󰕚",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰊄",
            }
            item.kind = icons[item.kind] or "󰉿"
            return item
          end,
        },
        window = {
          completion = { border = "none" },
          documentation = { border = "none" },
        },
        experimental = { ghost_text = true },
      })
    end,
  },
}
