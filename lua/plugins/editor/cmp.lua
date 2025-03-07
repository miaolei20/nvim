return {
  {
    "hrsh7th/nvim-cmp", -- 自动补全引擎
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",      -- 缓冲区补全
      "hrsh7th/cmp-path",        -- 路径补全
      "hrsh7th/cmp-nvim-lua",    -- Neovim Lua API 补全
      "hrsh7th/cmp-cmdline",     -- 命令行补全
      "L3MON4D3/LuaSnip",        -- 代码片段引擎
      "saadparwaiz1/cmp_luasnip",-- LuaSnip 的补全源
      "onsails/lspkind.nvim",    -- 美化补全菜单的图标支持
      "petertriho/cmp-git",      -- Git 补全
      "zbirenbaum/copilot-cmp",  -- Copilot 集成补全
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- 定义各补全源及其优先级
      local cmp_sources = {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 900  },
        { name = "copilot",  priority = 850  },
        { name = "buffer",   priority = 500  },
        { name = "path",     priority = 250  },
        { name = "git",      priority = 200  },
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- 使用 LuaSnip 展开代码片段
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- 向上滚动文档
          ["<C-f>"] = cmp.mapping.scroll_docs(4),  -- 向下滚动文档
          ["<C-Space>"] = cmp.mapping.complete(),  -- 触发补全
          ["<C-e>"] = cmp.mapping.abort(),         -- 取消补全
          ["<C-J>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<CR>"] = nil, -- 禁用默认回车确认映射
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
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
        sources = cmp.config.sources(cmp_sources),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text", -- 显示图标及文字
            preset = "codicons",
            menu = {
              buffer    = "[BUF]",
              nvim_lsp  = "[LSP]",
              luasnip   = "[SNP]",
              copilot   = "[COP]",
              git       = "[GIT]",
              path      = "[PATH]",
            },
          }),
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
          },
          documentation = {
            border = "rounded",
            max_width = 60,
            max_height = 15,
          },
        },
        experimental = {
          ghost_text = { hl_group = "Comment" }, -- 幽灵文本（预览式补全）
        },
        performance = {
          debounce = 80,         -- 防抖时间
          throttle = 60,         -- 节流时间
          fetching_timeout = 200,  -- 补全项获取超时设置
        },
      })

      -- 配置命令行模式下的补全（搜索/过滤）
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      -- 配置命令行模式下的路径与命令补全
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline" } }
        ),
      })
    end,
  },
}
