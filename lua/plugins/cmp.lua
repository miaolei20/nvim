-- file: plugins/cmp.lua
return {
  {
    "hrsh7th/nvim-cmp",                        -- 插件名称
    event = { "InsertEnter", "CmdlineEnter" }, -- 在进入插入模式或命令行模式时加载插件
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "petertriho/cmp-git",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- 智能补全优先级
      local cmp_sources = {
        { name = "nvim_lsp", priority = 1000 }, -- LSP 补全
        { name = "luasnip", priority = 900 },   -- LuaSnip 补全
        { name = "copilot", priority = 850 },   -- Copilot 补全
        { name = "buffer", priority = 500 },    -- 缓冲区补全
        { name = "path", priority = 250 },      -- 路径补全
        { name = "git", priority = 200 }        -- Git 补全
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- 使用 LuaSnip 展开代码片段
          end
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Ctrl+b 向上滚动文档
          ["<C-f>"] = cmp.mapping.scroll_docs(4),  -- Ctrl+f 向下滚动文档
          ["<C-Space>"] = cmp.mapping.complete(),  -- Ctrl+Space 触发补全
          ["<C-e>"] = cmp.mapping.abort(),         -- Ctrl+e 取消补全
          ["<C-J>"] = cmp.mapping.confirm({        -- 替换原有 <CR> 映射
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ["<CR>"] = nil, -- 禁用默认回车确认
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
              cmp.select_prev_item() -- 补全菜单可见时选择上一个项
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)       -- LuaSnip 可跳转时跳转到上一个位置
            else
              fallback()             -- 否则执行默认操作
            end
          end, { "i", "s" })
        }),
        sources = cmp.config.sources(cmp_sources), -- 设置补全源
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text", -- 显示符号和文本
            preset = "codicons",  -- 使用 codicons 预设
            menu = {
              buffer = "[BUF]",   -- 缓冲区补全标识
              nvim_lsp = "[LSP]", -- LSP 补全标识
              luasnip = "[SNP]",  -- LuaSnip 补全标识
              copilot = "[COP]",  -- Copilot 补全标识
              git = "[GIT]",      -- Git 补全标识
              path = "[PATH]"     -- 路径补全标识
            }
          })
        },
        window = {
          completion = {
            border = "rounded",                                            -- 补全窗口边框样式
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None" -- 窗口高亮设置
          },
          documentation = {
            border = "rounded", -- 文档窗口边框样式
            max_width = 60,     -- 文档窗口最大宽度
            max_height = 15     -- 文档窗口最大高度
          }
        },
        experimental = {
          ghost_text = {
            hl_group = "Comment" -- 幽灵文本高亮组
          }
        },
        performance = {
          debounce = 80,         -- 防抖动时间
          throttle = 60,         -- 节流时间
          fetching_timeout = 200 -- 获取超时时间
        }
      })

      -- 命令行补全
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(), -- 命令行模式下的映射
        sources = { { name = "buffer" } }       -- 使用缓冲区补全源
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(), -- 命令行模式下的映射
        sources = cmp.config.sources(
          { { name = "path" } },                -- 路径补全源
          { { name = "cmdline" } }              -- 命令行补全源
        )
      })
    end
  }
}
