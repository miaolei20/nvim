return {
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter", "BufReadPost" },  -- 增加缓冲区读取后触发
    priority = 100,
    dependencies = {
      "zbirenbaum/copilot-cmp",
      "hrsh7th/nvim-cmp"  -- 明确依赖 cmp 框架
    },
    config = function()
      -- 语言优化配置（新增 JavaScript 处理）
      local lang_config = {
        c = { maxNodeSize = 64, debounce = 150 },
        cpp = { maxNodeSize = 64, inlineSuggestCount = 3 },
        lua = { inlineSuggestCount = 4, maxCompletions = 25 },
        python = { debounce = 180, maxNodeSize = 80 },
        javascript = { inlineSuggestCount = 3, maxCompletions = 20 }  -- 新增 JS 配置
      }

      require("copilot").setup({
        suggestion = {
          enabled = false,        -- 禁用原生建议窗口
          auto_trigger = true,
          debounce = 120,
          keymap = {
            accept = "<M-CR>",
            accept_word = "<M-w>",    -- 新增单词级接受
            accept_line = "<M-l>",    -- 新增行级接受
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>"
          }
        },
        panel = { enabled = false },  -- 禁用原生面板
        filetypes = {
          c = true,
          cpp = true,
          lua = true,
          python = true,
          javascript = true,      -- 启用 JS 支持
          ["*"] = false
        },
        server_opts_overrides = {
          trace = "verbose",       -- 调试时改为 verbose
          settings = {
            advanced = {
              languageOverrides = lang_config,
              cacheSize = 250,     -- 增大缓存
              maxCompletions = 30,
              -- 新增代码风格配置
              style = {
                parenthesis = "balance",  -- 括号平衡策略
                indentation = "adaptive"
              }
            },
            -- 新增头文件处理优化
            headerSuggestions = {
              enable = true,
              maxLines = 100,
              fileTypes = { "c", "cpp", "h", "hpp" }
            }
          }
        }
      })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    after = "nvim-cmp",           -- 明确加载顺序
    config = function()
      -- 增强型格式化函数（新增 JS 处理）
      local lang_formatters = {
        c = function(text)
          return text:gsub("%s*;%s*$", ""):gsub("^%s+", "")
        end,
        lua = function(text)
          return text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("^end,?$", "")
        end,
        python = function(text)
          return text:gsub(":$", ""):gsub("^%s+", ""):gsub("%s+$", "")
                  :gsub(":$", "")
        end,
        javascript = function(text)  -- 新增 JS 格式化
          return text:gsub("^%s+", ""):gsub("%s+$", "")
                  :gsub(";$", ""):gsub("//.*$", "")
        end
      }

      require("copilot_cmp").setup({
        method = "getCompletionsCycling",
        formatters = {
          insert_text = function(_, item)
            local ft = vim.bo.filetype
            return (lang_formatters[ft] or function(t) return t end)(item.insertText)
          end,
          preview = function() return {} end
        },
        -- 优化性能配置
        performance = {
          throttle = 300,
          priority = {
            python = 10,    -- Python 高优先级
            cpp = 9,
            lua = 8,
            javascript = 7
          }
        },
        experimental = {
          smart_loading = true,  -- 启用智能加载
          async_loading = true   -- 异步加载建议
        }
      })
    end
  }
}