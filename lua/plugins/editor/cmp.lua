return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      -- VSCode 风格图标
      local icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Copilot = ""
      }

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function()
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            luasnip.expand_or_jump()
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            luasnip.jump(-1)
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot", priority = 1000 },
          { name = "nvim_lsp", priority = 900 },
          { name = "luasnip", priority = 800 },
        }),
        formatting = {
          fields = { "kind", "abbr" },
          format = function(_, item)
            item.kind = icons[item.kind] or icons.Text
            return item
          end
        },
        window = {
          completion = {
            winhighlight = "Normal:CmpMenu,CursorLine:CmpSelection,NormalNC:CmpMenu",
            scrollbar = false
          },
          documentation = {
            winhighlight = "Normal:CmpDoc",
            scrollbar = false
          }
        },
        experimental = { ghost_text = true }
      })

      vim.api.nvim_set_hl(0, "CmpSelection", {
        bg = "#363A4F",
        fg = "#89B4FA",
        bold = true
      })
      vim.api.nvim_set_hl(0, "CmpMenu", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpDoc", { bg = "NONE" })
    end
  }
}