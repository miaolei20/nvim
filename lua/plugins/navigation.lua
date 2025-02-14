-- file: plugins/navigation.lua 
return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if client.supports_method("textDocument/documentSymbol") then
            require("nvim-navic").attach(client, bufnr)
          end
        end,
      })
    end,
    opts = function()
      local icons = require("plugins.icons").kinds
      return {
        separator = " \\ ",  -- Fixed escape sequence
        highlight = false,
        depth_limit = 5,
        icons = icons,
        lazy_update_context = true,
      }
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
}
