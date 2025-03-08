return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    build = "make",
    opts = {
      provider = "deepseek",
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
        },
      },
      ui = {
        border   = "rounded",  -- 圆角边框
        padding  = 1,          -- 内边距设置
        winblend = 10,         -- 窗口透明度，数值越大越透明
        highlight = {
          title  = "Keyword",   -- 标题高亮风格
          border = "Constant",  -- 边框高亮风格
        },
      },
    },
    config = function(_, opts)
      local avante = require("avante")
      avante.setup(opts)
    end,
  },
}

