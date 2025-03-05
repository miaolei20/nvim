return {
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    priority = 100, -- 高优先级加载
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false, -- 禁用独立悬浮窗
          auto_trigger = true
        },
        panel = { enabled = false },
        filetypes = {
          ["*"] = function()
            return true -- 全局启用但由 cmp 接管
          end
        }
      })
    end,
    dependencies = {
      "zbirenbaum/copilot-cmp",
      "nvim-lua/plenary.nvim"
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    after = "copilot.lua", -- 确保在 copilot 之后加载
    config = function()
      require("copilot_cmp").setup({
        formatters = {
          insert_text = function(text)
            return text:gsub("\n", " ") -- 防止换行符干扰
          end
        }
      })
    end
  }
}

