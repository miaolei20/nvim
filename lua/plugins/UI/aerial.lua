-- aerial.lua
return {
  {
    "stevearc/aerial.nvim",
    event = { "LspAttach", "BufReadPost" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local colors = require("onedarkpro.helpers").get_colors()

      require("aerial").setup({
        layout = {
          min_width = 30,
          default_direction = "right",
          placement = "edge",
        },
        show_guides = true,
        highlight_mode = "last",
        highlight_closest = true,
        icons = require("config.icons").kinds,
        nerd_font = "auto",
        filter_kind = {
          "Class", "Constructor", "Enum", "Function", 
          "Interface", "Method", "Struct"
        },
        on_attach = function(bufnr)
          vim.keymap.set("n", "<leader>lo", "<cmd>AerialToggle!<CR>", { buffer = bufnr })
        end,
      })

      vim.api.nvim_set_hl(0, "AerialLine", { link = "DiagnosticHint" })
    end
  }
}