return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
    },
    build = "make",
    opts = {
      provider = "deepseek",
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder"
        },
        copilot = {
          __inherited_from = "openai",
          model = "copilot",
          request_adapter = function(params)
            local cmp_source = require("copilot_cmp.source")
            local items = cmp_source.get_completions(params) or {}
            return vim.tbl_map(function(item)
              return {
                text = item.insertText or item.text or "",
                documentation = item.documentation or ""
              }
            end, items)
          end
        }
      },
      keymaps = {
        switch_provider = "<Leader>am"
      }
    },
    config = function(_, opts)
      local avante = require("avante")
      avante.setup(opts)
      local current_provider = opts.provider

      vim.keymap.set("n", opts.keymaps.switch_provider, function()
        current_provider = (current_provider == "deepseek") and "copilot" or "deepseek"
        avante.setup(vim.tbl_extend("force", opts, { provider = current_provider }))
        vim.notify("AI Provider: " .. current_provider, vim.log.levels.INFO)
      end)
    end
  }
}

