return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "tsakirist/telescope-lazy.nvim",
      "nvim-telescope/telescope-fzf-writer.nvim",
      "rcarriga/nvim-notify", -- Replaced telescope-notify.nvim
    },
    opts = require("config.telescope").opts,
    config = function(_, opts)
      require("config.telescope").setup(opts)
    end,
  },
}