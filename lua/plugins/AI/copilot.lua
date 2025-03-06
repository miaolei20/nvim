return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",  -- 更精确的触发时机
    priority = 100,
    dependencies = {
      "zbirenbaum/copilot-cmp",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = true,
          debounce = 120,  -- 增加防抖减少请求频率
        },
        panel = { enabled = false },
        filetypes = {
          python = true,    -- 明确指定需要支持的语言
          lua = true,
          cpp = true,
          c = true,
          -- 其他需要支持的语言...
          ["*"] = false     -- 默认禁用，提升启动性能
        },
        server_opts_overrides = {
          trace = "off",    -- 关闭调试跟踪
          settings = {
            advanced = {
              listCount = 5,         -- 减少建议数量
              inlineSuggestCount = 3 -- 限制行内建议数量
            }
          }
        }
      })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",  -- 延迟加载
    config = function()
      require("copilot_cmp").setup({
        method = "getCompletionsCycling", -- 使用缓存策略
        formatters = {
          insert_text = function(text)
            -- 使用更高效的字符串处理
            return text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
          end,
          preview = function() return {} end  -- 禁用预览减少计算
        }
      })
    end
  }
}