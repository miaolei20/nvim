return {
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      build = "make", -- Optional, for building from source
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "hrsh7th/nvim-cmp",
      },
      opts = {
        provider = "deepseek", -- Default provider
        vendors = {
          deepseek = {
            endpoint = "https://api.deepseek.com",
            model = "deepseek-coder",
            api_key_name = "DEEPSEEK_API_KEY",
            max_tokens = 4096, -- Set within valid range (1-8192)
            __inherited_from = "openai",
          },
          kimi = {
            endpoint = "https://api.moonshot.cn/v1",
            model = "moonshot-v1-8k",
            api_key_name = "KIMI_API_KEY",
            max_tokens = 4096, -- Set within valid range (1-8192)
            __inherited_from = "openai",
          },
        },
        mappings = {
          ask = "<leader>aa",   -- Ask AI
          edit = "<leader>ae",  -- Edit code
          refresh = "<leader>ar", -- Refresh suggestions
        },
        behaviour = {
          auto_suggestions = false,
          auto_apply_diff_after_generation = true,
        },
      },
      config = function(_, opts)
        require("avante").setup(opts)
      end,
    },
  }