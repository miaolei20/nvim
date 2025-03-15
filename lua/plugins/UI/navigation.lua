return {
  {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.navic_silence = true
    end,
    opts = function()
      return {
        separator = "  ", -- 更现代的分隔符
        highlight = true,
        depth_limit = 5,
        lazy_update_context = true,
      }
    end,
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if client and client.supports_method("textDocument/documentSymbol") then
            require("nvim-navic").attach(client, bufnr)
          end
        end,
      })
      require("nvim-navic").setup(opts)
    end,
  },
}
