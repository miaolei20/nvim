return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" }, -- 延迟加载以提升启动性能
    version = "v1.*", -- 使用预构建二进制
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function()
      -- 动态添加 lazydev 源
      local sources = { "lsp", "path", "snippets", "buffer" }
      if pcall(require, "lazydev") then
        table.insert(sources, "lazydev")
      end

      return {
        keymap = {
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = {
            "select_next",
            "snippet_forward",
            function(cmp)
              local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
              end
              if vim.api.nvim_get_mode().mode == "c" or has_words_before() then
                cmp.show()
              end
            end,
            "fallback",
          },
          ["<S-Tab>"] = {
            "select_prev",
            "snippet_backward",
            function(cmp)
              if vim.api.nvim_get_mode().mode == "c" then cmp.show() end
            end,
            "fallback",
          },
          ["<C-N>"] = { "select_next", "show" },
          ["<C-P>"] = { "select_prev", "show" },
          ["<C-U>"] = { "scroll_documentation_up", "fallback" },
          ["<C-D>"] = { "scroll_documentation_down", "fallback" },
          ["<C-E>"] = { "hide", "fallback" },
        },
        sources = { default = sources },
        completion = {
          ghost_text = { enabled = true },
          menu = {
            border = "none",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            auto_show = true,
            window = {
              border = "none",
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            },
          },
        },
        enabled = function()
          return vim.bo.buftype ~= "prompt"
        end,
        appearance = {
          kind_icons = {
            Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "󰒓",
            Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
            Module = "󰏗", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
            Enum = "󰕘", Keyword = "󰌋", Snippet = "", Color = "󰏘",
            File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "󰕚",
            Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
            TypeParameter = "󰊄",
          },
        },
        fuzzy = { implementation = "prefer_rust" },
      }
    end,
  },
}
