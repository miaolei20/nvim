return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    priority = 100,
    dependencies = {
      "zbirenbaum/copilot-cmp",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      -- 针对不同语言类型设置优化参数
      local lang_config = {
        c = { maxNodeSize = 64 },      -- 优化 C 语言的大文件处理
        cpp = { maxNodeSize = 64 },    -- C++ 类结构优化
        lua = { inlineSuggestCount = 4 },  -- Lua 需要更多行内建议
        python = { debounce = 150 }    -- Python 需要更稳定的建议
      }

      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = true,
          debounce = 120,
          keymap = {
            accept = "<M-CR>",  -- 使用更高效的热键组合
            next = "<M-]>",
            prev = "<M-[>"
          }
        },
        panel = { enabled = false },
        filetypes = {
          c = true,
          cpp = true,
          lua = true,
          python = true,
          ["*"] = false  -- 彻底禁用其他文件类型
        },
        server_opts_overrides = {
          trace = "off",
          settings = {
            advanced = {
              listCount = 5,
              inlineSuggestCount = 3,
              -- 语言特定参数合并
              languageOverrides = lang_config,
              -- 内存优化配置
              cacheSize = 200,          -- 增大 C/C++ 缓存
              maxCompletions = 30       -- 限制最大补全数量
            },
            -- C/C++ 头文件处理优化
            cHeaderFileSuggestions = {
              enable = true,
              maxLines = 50
            }
          }
        }
      })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function()
      -- 针对不同语言的格式化优化
      local lang_formatters = {
        c = function(text) return text:gsub("%s*;%s*$", "") end,
        cpp = function(text) return text:gsub("%s*;%s*$", "") end,
        lua = function(text) return text:gsub("^%s+", ""):gsub("%s+$", "") end,
        python = function(text)
          return text:gsub(":$", ""):gsub("^%s+", ""):gsub("%s+$", "")
        end
      }

      require("copilot_cmp").setup({
        method = "getCompletionsCycling",
        formatters = {
          insert_text = function(_, item)
            local ft = vim.bo.filetype
            local formatter = lang_formatters[ft] or function(t) return t end
            return formatter(item.insertText)
          end,
          preview = function() return {} end
        },
        -- 优化大文件处理
        buffer = {
          max_size = 1024 * 1024,  -- 1MB 文件限制
          on_disk = false          -- 禁用磁盘缓存
        }
      })
    end
  }
}