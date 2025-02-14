-- file: plugins/navigation.lua
return {
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      vim.g.navic_silence = true
      require("lsp.config").on_attach(function(client, buffer)
        if client.supports_method("textDocument/documentSymbol") then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = {
      separator = "  ",
      highlight = true,
      depth_limit = 5,
      icons = require("icons").kinds, -- 使用自定义图标
      lazy_update_context = true,
    }
  },
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "MunifTanjim/nui.nvim"
    },
    keys = {
      { "<leader>cn", "<cmd>Navbuddy<cr>", desc = "Navigation Buddy" }
    },
    config = function()
      require("nvim-navbuddy").setup({
        window = {
          border = "rounded",
          size = "60%",
          position = "50%"
        },
        lsp = { auto_attach = true }
      })
    end
  }
}