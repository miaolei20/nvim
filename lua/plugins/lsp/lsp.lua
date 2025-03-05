return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "glepnir/lspsaga.nvim",
      "ray-x/lsp_signature.nvim",
      "folke/neodev.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.lsp").setup()
    end,
  },
}
