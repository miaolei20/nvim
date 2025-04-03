return {
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>lo", "<cmd>AerialToggle!<CR>", desc = "Toggle Outline" },
    },
    opts = {
      layout = { default_direction = "right", min_width = 30 },
      show_guides = true,
      filter_kind = {
        "Class", "Constructor", "Enum", "Function",
        "Interface", "Method", "Struct",
      },
      nerd_font = "auto",
    },
  },
}