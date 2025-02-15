return {
  "hrsh7th/nvim-cmp",  -- 主插件
  dependencies = {
    "hrsh7th/cmp-buffer",  -- 缓冲区补全源
    "hrsh7th/cmp-path",  -- 文件路径补全源
    "hrsh7th/cmp-nvim-lua",  -- Neovim Lua API 补全源
    "L3MON4D3/LuaSnip",  -- 代码片段引擎
    "saadparwaiz1/cmp_luasnip",  -- LuaSnip 补全源
    "onsails/lspkind.nvim"  -- 为补全项添加图标
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)  -- 使用 LuaSnip 展开代码片段
        end
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()  -- 如果补全菜单可见，选择下一个项
          else
            fallback()  -- 否则执行默认行为
          end
        end, { "i", "s" }),
        
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()  -- 如果补全菜单可见，选择上一个项
          else
            fallback()  -- 否则执行默认行为
          end
        end, { "i", "s" }),
        
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,  -- 确认补全项时替换当前文本
          select = true  -- 自动选择当前项
        })
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },  -- LSP 补全源
        { name = "codeium" },
        { name = "luasnip" },  -- LuaSnip 补全源
        { name = "buffer" },  -- 缓冲区补全源
        { name = "path" }  -- 文件路径补全源
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",  -- 显示图标和文本
          menu = {
            buffer = "[Buffer]",  -- 缓冲区补全项的菜单文本
            nvim_lsp = "[LSP]",  -- LSP 补全项的菜单文本
            luasnip = "[Snip]",  -- LuaSnip 补全项的菜单文本
            path = "[Path]"  -- 文件路径补全项的菜单文本
          }
        })
      },
      window = {
        completion = {
          border = "rounded",  -- 补全窗口的边框样式
          winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None"  -- 窗口高亮设置
        },
        documentation = {
          border = "rounded"  -- 文档窗口的边框样式
        }
      }
    })
  end
}
